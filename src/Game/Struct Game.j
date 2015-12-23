library StructGameGame requires Asl, StructGameCameraHeight, StructGameCharacter, StructGameItemTypes, StructGameRoutines, StructGameTreeTransparency, LibraryGameLanguage

	/**
	 * This static structure provides constants and functions for DMdFs experience calculation for all experience which is gained by killing other units.
	 * As in Warcraft III itself characters do not necessarily have to kill enemies theirselfs (e. g. with a final hit).
	 * A custom experience system is necessary to be able to distribute the whole gained experience equally (not like in Warcraft III where some do get more and some do get less).
	 * \ref distributeUnitExperience() calculates the whole gained experience by one single kill which can be distributed on all characters.
	 */
	struct GameExperience
		private static constant real damageFactor = 10.0
		private static constant real damageTypeWeightFactor = 100.0
		private static constant real armourFactor = 100.0
		private static constant real armourTypeWeightFactor = 100.0
		private static constant real hpFactor = 1.0
		private static constant real manaFactor = 2.0
		private static constant real levelFactor = 100.0
		private static constant real summands = 7.0
		private static constant real dividend = 10.0
		/// \note If the range is 0.0 or smaller it is ignored.
		private static constant real range = 0.0
		private static constant real xpHandicap = 0.30 //0.20 // this XP factor is used to reduce the actual gained experience such as in the Bonus Campaign. We want to prevent the characters from leveling too fast. In the Bonus Campaign it is 10 % and on difficulty hard it is even 7 %.
		private static constant real unitsFactor = 1.0
		private static constant real alliedUnitsFactor = 1.0
		private static constant real characterFactor = 1.0
		private static constant real alliedCharactersFactor = 1.0

		public static method maxExperienceFormula takes unit hero returns integer
			return GetHeroMaxXP(hero)
		endmethod

		/**
		 * Calculates the given experience for \p character from unit \p whichUnit which is killed by \p killingUnit.
		 * Depending on the alliance between owners the character only gets experience when the killed unit is unallied to the
		 * character and the killing unit is allied to or owned by the owner of \p character.
		 * Besides it checks if the character is in range if \ref thistype.range is greater than 0.0.
		 * If the initial conditions are true the experience is calculated from the factors depending on the unit type and player of \p killingUnit.
		 * The actual experience without any factors from a unit is calculated using \ref GetUnitXP()
		 */
		public static method unitExperienceForCharacter takes Character character, unit whichUnit, unit killingUnit returns integer
			local real result = 0.0
			// unallied and in range
			//debug call Print("Alliance state to died unit: " + I2S(GetUnitAllianceStateToUnit(character.unit(), whichUnit)) + ".")
			//debug call Print("Alliance state to killing unit: " + I2S(GetUnitAllianceStateToUnit(character.unit(), killingUnit)) + ".")
			// never give XP for buildings. for example boxes are buildings as well
			if (GetUnitAllianceStateToUnit(character.unit(), whichUnit) == bj_ALLIANCE_UNALLIED and (GetUnitAllianceStateToUnit(character.unit(), killingUnit) == bj_ALLIANCE_ALLIED or character.player() == GetOwningPlayer(killingUnit)) and ((thistype.range > 0.0 and GetDistanceBetweenUnitsWithZ(character.unit(), whichUnit) <= thistype.range) or thistype.range <= 0.0) and not IsUnitType(whichUnit, UNIT_TYPE_STRUCTURE)) then
				/// @todo FIXME, DMdF customized XP formula
				//set result = thistype.damageFactor * GetUnitDamage(whichUnit) + thistype.damageTypeWeightFactor * GetUnitDamageType(whichUnit) + thistype.armourFactor * GetUnitArmour(whichUnit) + thistype.armourTypeWeightFactor * GetUnitArmourType(whichUnit) + thistype.hpFactor * GetUnitState(whichUnit, UNIT_STATE_LIFE) + thistype.manaFactor * GetUnitState(whichUnit, UNIT_STATE_MANA) + thistype.levelFactor * GetUnitLevel(whichUnit)
				// Warcraft 3 default XP formula
				set result = I2R(GetUnitXP(whichUnit)) * thistype.xpHandicap
				//debug call Print("Result is " + R2S(result))
				//set result = result / (thistype.summands * (thistype.dividend - Game.missingPlayers.evaluate()))
				if (killingUnit == character.unit()) then
					set result = result * thistype.characterFactor
				elseif (ACharacter.isUnitCharacter(killingUnit)) then
					set result = result * thistype.alliedCharactersFactor
				elseif (GetOwningPlayer(killingUnit) == character.player()) then
					set result = result * thistype.unitsFactor
				else //if (GetUnitAllianceStateToUnit(character.unit(), killingUnit) == bj_ALLIANCE_ALLIED) then
					set result = result * thistype.alliedUnitsFactor
				endif
			endif

			return IMaxBJ(R2I(result / ACharacter.countAllPlaying()), 1) // give at least 1 XP
		endmethod

		/**
		 * Gives a character the XP gained for killing unit \p whichUnit by the killer \p killingUnit.
		 * The XP is always divided by the number of players. Otherwise the game would be too easy for multiple players.
		 * \return Returns the XP.
		 */
		public static method giveUnitExperienceToCharacter takes Character character, unit whichUnit, unit killingUnit returns integer
			local integer experience = thistype.unitExperienceForCharacter(character, whichUnit, killingUnit) / ACharacter.countAll()
			//debug call Print("Experience: " + I2S(experience))
			if (experience > 0) then
				call ShowGeneralFadingTextTagForPlayer(character.player(), IntegerArg(tr("+%i"), experience), GetUnitX(character.unit()), GetUnitY(character.unit()), 255, 0, 255, 255)
				call character.addExperience(experience, true)
			endif
			return experience
		endmethod

		public static method distributeUnitExperience takes unit whichUnit, unit killingUnit returns integer
			local integer experience = 0
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					set experience = experience + thistype.giveUnitExperienceToCharacter(ACharacter.playerCharacter(Player(i)), whichUnit, killingUnit)
				endif
				set i = i + 1
			endloop
			return experience
		endmethod


		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod
	endstruct

	/**
	 * DMdF uses a custom bounty system which tries to be like the usual of Warcraft III.
	 * As the custom experience system \ref GameExperience this is required since we don't want to give the killer all bounty.
	 * Instead, bounty is distributed to all players so everyone gets equal bounty.
	 */
	struct GameBounty

		/**
		 * \todo In Warcraft III the bounty is set in the object editor for each unit. This formula tries to calculate it in a meaningful way but at the moment the bounty seems to be too big.
		 */
		public static method unitBounty takes unit whichUnit returns integer
			return GetUnitLevel(whichUnit) * 2 /// @todo Get the right formula.
		endmethod

		public static method unitBountyForCharacter takes Character character, unit whichUnit, unit killingUnit returns integer
			// never give bounty for buildings. For example boxes are buildings.
			if (GetUnitAllianceStateToUnit(character.unit(), whichUnit) != bj_ALLIANCE_UNALLIED or (GetUnitAllianceStateToUnit(character.unit(), killingUnit) != bj_ALLIANCE_ALLIED and character.player() != GetOwningPlayer(killingUnit)) or IsUnitType(whichUnit, UNIT_TYPE_STRUCTURE)) then
				return 0
			endif
			return thistype.unitBounty(whichUnit) / ACharacter.countAllPlaying()
		endmethod

		public static method giveBountyToCharacter takes Character character, unit whichUnit, unit killingUnit returns integer
			local integer bounty = thistype.unitBountyForCharacter(character, whichUnit, killingUnit) / ACharacter.countAll()
			if (bounty > 0) then
				call Bounty(character.player(), GetUnitX(whichUnit), GetUnitY(whichUnit), bounty)
			endif
			return bounty
		endmethod

		public static method distributeUnitBounty takes unit whichUnit, unit killingUnit returns integer
			local integer bounty = 0
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					set bounty = bounty + thistype.giveBountyToCharacter(ACharacter.playerCharacter(Player(i)), whichUnit, killingUnit)
				endif
				set i = i + 1
			endloop
			return bounty
		endmethod

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod
	endstruct

	struct Game
		private static constant real maxMoveSpeed = 522.0
		private static AIntegerList m_onDamageActions
		private static trigger m_killTrigger
		private static AIntegerVector array m_hiddenUnits[12] /// \todo \ref MapData.maxPlayers

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method hostilePlayer takes nothing returns player
			return Player(PLAYER_NEUTRAL_AGGRESSIVE)
		endmethod

		public static method missingPlayers takes nothing returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_EMPTY) then
					set result = result + 1
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		public static method registerOnDamageAction takes ADamageRecorderOnDamageAction onDamageAction returns nothing
			call thistype.m_onDamageActions.pushBack(onDamageAction)
		endmethod

		public static method registerOnDamageActionOnce takes ADamageRecorderOnDamageAction onDamageAction returns nothing
			if (not thistype.m_onDamageActions.contains(onDamageAction)) then
				call thistype.m_onDamageActions.pushBack(onDamageAction)
			endif
		endmethod

		public static method unregisterOnDamageAction takes ADamageRecorderOnDamageAction onDamageAction returns nothing
			call thistype.m_onDamageActions.remove(onDamageAction)
		endmethod

		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local AIntegerListIterator iterator = thistype.m_onDamageActions.begin()
			//debug call Print("DAMAGE RECORDER")
			//debug call Print("Damage recorder list id :" + I2S(thistype.m_onDamageActions) + " and size: " + I2S(thistype.m_onDamageActions.size()))
			loop
				exitwhen (not iterator.isValid())
				//debug call Print("Damage recorder")
				call ADamageRecorderOnDamageAction(iterator.data()).evaluate(damageRecorder)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		/**
		 * The violence system enables blood effects on killing units.
		 * \ref randomBigBloodEffectPath() is used when the killed unit takes a lot of damage at once.
		 * The damage handler \ref onDamageActionViolence() creates blood effects but only if \ref DMDF_VIOLENCE is set to true.
		 */
static if (DMDF_VIOLENCE) then
		private static constant method bloodEffectPathDeath takes integer index returns string
			if (index == 0) then
				return "Models\\Effects\\BloodExplosion.mdx"
			elseif (index == 1) then
				return "Models\\Effects\\BloodExplosionNoSplat.mdx"
			elseif (index == 2) then
				return "Models\\Effects\\BloodExplosionSpecial1.mdx"
			elseif (index == 3) then
				return "Models\\Effects\\BloodExplosionSpecial2.mdx"
			endif
			return null
		endmethod

		private static constant method maxDeathBloodEffectPaths takes nothing returns integer
			return 4
		endmethod

		private static method randomDeathBloodEffectPath takes nothing returns string
			return thistype.bloodEffectPathDeath(GetRandomInt(0, thistype.maxDeathBloodEffectPaths()))
		endmethod

		private static constant method bloodEffectPathBig takes integer index returns string
			if (index == 0) then
				return "Models\\Effects\\BigBleeding.mdx"
			elseif (index == 1) then
				return "Models\\Effects\\BigBleedingNoSplat.mdx"
			endif
			return null
		endmethod

		private static constant method maxBigBloodEffectPaths takes nothing returns integer
			return 2
		endmethod

		private static method randomBigBloodEffectPath takes nothing returns string
			return thistype.bloodEffectPathBig(GetRandomInt(0, thistype.maxBigBloodEffectPaths()))
		endmethod

		private static constant method bloodEffectPath takes integer index returns string
			if (index == 0) then
				return "Models\\Effects\\Bleeding.mdx"
			elseif (index == 1) then
				return "Models\\Effects\\BleedingNoSplat.mdx"
			endif
			return null
		endmethod

		private static constant method maxBloodEffectPaths takes nothing returns integer
			return 2
		endmethod

		private static method randomBloodEffectPath takes nothing returns string
			return thistype.bloodEffectPath(GetRandomInt(0, thistype.maxBloodEffectPaths()))
		endmethod

		// blood/violence system
		/// \todo How to prevent blood effects when damage is being prevented (by spell etc.)
		private static method onDamageActionViolence takes ADamageRecorder damageRecorder returns nothing
			local string effectPath
			if (not IsUnitType(GetTriggerUnit(), UNIT_TYPE_MECHANICAL) and not IsUnitType(GetTriggerUnit(), UNIT_TYPE_UNDEAD)) then
				// equal to or more than 20% of max life
				if (GetEventDamage() >= GetUnitState(GetTriggerUnit(), UNIT_STATE_MAX_LIFE) * 0.20) then
					set effectPath = thistype.randomBigBloodEffectPath()
				// normal damage
				else
					set effectPath = thistype.randomBloodEffectPath()
				endif
				call DestroyEffect(AddSpecialEffectTarget(effectPath, GetTriggerUnit(), "origin"))
			endif
			/// \todo play sound
			//call PlaySoundFileOnUnit(thistype.randomViolenceSoundPath(), GetTriggerUnit())
		endmethod
endif
		private static method triggerActionKill takes nothing returns nothing
			/*
			 * Characters get only experience if a creep is being killed.
			 */
			if (MapData.playerGivesXP.evaluate(GetOwningPlayer(GetTriggerUnit()))) then
				call GameExperience.distributeUnitExperience(GetTriggerUnit(), GetKillingUnit())
				call GameBounty.distributeUnitBounty(GetTriggerUnit(), GetKillingUnit())
			endif
static if (DMDF_VIOLENCE) then
			// violence
			if (not IsUnitType(GetTriggerUnit(), UNIT_TYPE_MECHANICAL) and not IsUnitType(GetTriggerUnit(), UNIT_TYPE_UNDEAD)) then
				call DestroyEffect(AddSpecialEffectTarget(thistype.randomDeathBloodEffectPath(), GetTriggerUnit(), "origin"))
			endif
			/// \todo Sound
endif
		endmethod

		/// @todo What's about AOS players?
		private static method createKillTrigger takes nothing returns nothing
			set thistype.m_killTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_killTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddAction(thistype.m_killTrigger, function thistype.triggerActionKill)
		endmethod

		/// Most ASL systems are initialized here.
		private static method onInit takes nothing returns nothing
			local integer i
			debug local ABenchmark benchmark
			// Advanced Script Library
			// general systems
			call Asl.init()
			// debugging systems
static if (DEBUG_MODE) then
				call ABenchmark.init()
				set benchmark = ABenchmark.create("Initialization")
				call TriggerSleepAction(0.0) //before starting timer
				call benchmark.start()
				call AInitUtilityCheats()
endif
			// environment systems
			call ADamageRecorder.init(true, thistype.onDamageAction, false)
			call AMissile.init(1.00, 9.80665, false) /// @todo Set correct refresh rate.
			// NOTE AJump is only required for a jump done by Wigberht in the video "Wigberht".
			call AJump.init(0.05, null)
			// interface systems
			call AArrowKeys.init(true)
			call AThirdPersonCamera.init(true)
			// bonus mod systems
			call AInitBonusMod()
			// gui systems
			/// @todo Use localized shortcuts
			call ADialog.init('V',  'N', tre("Vorherige Seite", "Previous page"), tre("Nächste Seite", "Next page"), tre("%s|n(%i/%i)", "%s|n(%i/%i)"))
			call AGui.init('h003', 0.0, 0.0, tre("OK", "OK"), sc("DMDF_GUI_OK_SHORTCUT"))
			call AGui.setShortcutAbility('a', 'A003')
			call AGui.setShortcutAbility('b', 'A00F')
			call AGui.setShortcutAbility('c', 'A00G')
			call AGui.setShortcutAbility('d', 'A00H')
			call AGui.setShortcutAbility('e', 'A00I')
			call AGui.setShortcutAbility('f', 'A00J')
			call AGui.setShortcutAbility('g', 'A00K')
			call AGui.setShortcutAbility('h', 'A00L')
			call AGui.setShortcutAbility('i', 'A00M')
			call AGui.setShortcutAbility('j', 'A00N')
			call AGui.setShortcutAbility('k', 'A00O')
			call AGui.setShortcutAbility('l', 'A00P')
			call AGui.setShortcutAbility('m', 'A00Q')
			call AGui.setShortcutAbility('n', 'A00R')
			call AGui.setShortcutAbility('o', 'A00S')
			call AGui.setShortcutAbility('p', 'A00T')
			call AGui.setShortcutAbility('q', 'A00U')
			call AGui.setShortcutAbility('r', 'A00V')
			call AGui.setShortcutAbility('s', 'A00W')
			call AGui.setShortcutAbility('t', 'A00X')
			call AGui.setShortcutAbility('u', 'A00Y')
			call AGui.setShortcutAbility('v', 'A00Z')
			call AGui.setShortcutAbility('w', 'A010')
			call AGui.setShortcutAbility('x', 'A011')
			call AGui.setShortcutAbility('y', 'A012')
			call AGui.setShortcutAbility('z', 'A013')
			call AWidget.init("Sound\\Interface\\MouseClick1.wav", null)
			call ACheckBox.init0("", "") /// @todo set correct image file paths
			call AVote.init(4.0, tre("%1% hat für \"%2%\" gestimmt (%3% Stimme(n)).", "%1% voted for \"%2%\" (%3% vote(s))."), tre("Abstimmung wurde mit dem Ergebnis \"%1%\" abgeschlossen (%2% Stimme(n)).", "Voting has been completed with the result \"%1%\" (%2% vote(s))."))
			// character systems
			// In the Bonus Campaign the ping rate for quests is 25.0 seconds.
			call AAbstractQuest.init(25.0, "Sound\\Interface\\QuestNew.wav", "Sound\\Interface\\QuestCompleted.wav", "Sound\\Interface\\QuestFailed.wav", tre("%s", "%s"), tre("|cffc3dbff%s (Abgeschlossen)|r", "|cffc3dbff%s (Completed)|r"), tre("%s (|c00ff0000Fehlgeschlagen|r)", "%s (|c00ff0000Failed|r)"), tre("+%i Stufe(n)", "+%i level(s)"), tre("+%i Fähigkeitenpunkt(e)", "+%i skill point(s)"), tre("+%i Erfahrung", "+%i experience"), tre("+%i Stärke", "+%i strength"), tre("+%i Geschick", "+%i dexterity"), tre("+%i Wissen", "+%i lore"), tre("+%i Goldmünze(n)", "+%i gold coin(s)"), tre("+%i Holz", "+%i lumber"))
			call ABuff.init()
			call ACharacter.init(true, true, false, true, false, true, true, true, DMDF_INFO_LOG)
			call initSpeechSkip(AKeyEscape, 0.2)
			call AInventory.init('I001', 'I000', 'A015', false, tre("Ausrüstungsfach wird bereits von einem anderen Gegenstand belegt.", "Equipment slot is already used by another item."), null, tre("Rucksack ist voll.", "Backpack is full."), tre("%1% im Rucksack verstaut.", "%1% put into the bag."), tre("Gegenstand konnte nicht verschoben werden.", "Item cannot be moved"), tre("Die Seitengegenstände können nicht abgelegt werden.", "The page items cannot be dropped."), tre("Die Seitengegenstände können nicht verschoben werden.", "The page items cannot be moved."), tre("Der Gegendstand gehört einem anderen Spieler.", "This item belongs to another player."), tre("Vorherige Seite ist bereits voll.", "Previous page is already full."), tre("Nächste Seite ist bereits voll.", "Next page is already full."))
			call AItemType.init(tre("Gegenstand benötigt eine höhere Stufe.", "Item requires a higher level."), tre("Gegenstand benötigt mehr Stärke.", "Item requires more strength."), tre("Gegenstand benötigt mehr Geschick.", "Items requires more dexterity."), tre("Gegenstand benötigt mehr Wissen.", "Item requires more lore."), tre("Gegenstand benötigt eine andere Charakterklasse.", "Item requires another character class."))
			call AQuest.init0(true, true, "Sound\\Interface\\QuestLog.wav", tre("|c00ffcc00NEUER AUFTRAG|r", "|c00ffcc00NEW QUEST|r"), tre("|c00ffcc00AUFTRAG ABGESCHLOSSEN|r", "|c00ffcc00QUEST COMPLETED|r"), tre("|c00ffcc00AUFTRAG FEHLGESCHLAGEN|r", "|c00ffcc00QUEST FAILED|r"), tre("|c00ffcc00AUFTRAGS-AKTUALISIERUNG|r", "|c00ffcc00QUEST UPDATE|r"), tre("- %s", "- %s"))
			call AVideo.init(tre("Spieler %s möchte das Video überspringen.", "Player %s wants to skip the video."), tre("Video wird übersprungen.", "Video has been skipped."))
			call ATalk.init(tre("Ende", "Exit"), tre("Zurück", "Back"), tre("Ziel unterhält sich bereits", "Target does already talk."))
			// world systems
			call ASpawnPoint.init()
			// Die Macht des Feuers
			// game
			set thistype.m_onDamageActions = AIntegerList.create()
static if (DMDF_VIOLENCE) then
			call thistype.registerOnDamageActionOnce(thistype.onDamageActionViolence) // blood/violence system
endif
			call thistype.createKillTrigger()
			// game guis
			call Credits.init0.evaluate()
			//! import "Game/Credits.j"
			call Fellow.init.evaluate(tre("%1% hat sich Ihrer Gruppe angeschlossen.", "%1% has joined your group."), null, tre("%1% hat Ihre Gruppe verlassen.", "%1% has left your group"), null, tre("%1% ist gefallen und wird in %2% Sekunden wiederbelebt.", "%1% has fallen and will be revived in %2% seconds."), null)
static if (DMDF_INVENTORY) then
			call Inventory.init0.evaluate()
endif
			// game types
			call Classes.init()
			call ItemTypes.init() // after classes!
static if (DMDF_NPC_ROUTINES) then
			call Routines.init()
endif
			call initSpells.evaluate() // after classes!
			// map
			call MapData.init.evaluate()
			
			/*
			 * DMdF uses a custom XP system.
			 */
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYER_SLOTS)
				call SetPlayerHandicapXP(Player(i), 0.0)
				call SetPlayerAbilityAvailable(Player(i), Grimoire.dummyAbilityId, false)
				call SetPlayerAbilityAvailable(Player(i), Grimoire.dummyHeroAbilityId, false)
				set i = i + 1
			endloop
			
			/*
			 * Setup initial alliances:
			 * Players must be  neutral to the allied and to the neutral passive player of the map.
			 */
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (GetPlayerController(Player(i)) != MAP_CONTROL_NONE) then
					set thistype.m_hiddenUnits[i] = AGroup.create()
				endif
				
				// set allied player and neutral passive player alliance status
				call SetPlayerAllianceStateBJ(Player(i), MapData.alliedPlayer, bj_ALLIANCE_NEUTRAL)
				call SetPlayerAllianceStateBJ(MapData.alliedPlayer, Player(i), bj_ALLIANCE_NEUTRAL)
				// they have to be allied and not neutral. Otherwise shared shop won't work.
				call SetPlayerAllianceStateBJ(Player(i), Player(PLAYER_NEUTRAL_PASSIVE), bj_ALLIANCE_ALLIED)
				call SetPlayerAllianceStateBJ(Player(PLAYER_NEUTRAL_PASSIVE), Player(i), bj_ALLIANCE_ALLIED)
				call SetPlayerAllianceStateBJ(Player(i), MapData.neutralPassivePlayer, bj_ALLIANCE_ALLIED)
				call SetPlayerAllianceStateBJ(MapData.neutralPassivePlayer, Player(i), bj_ALLIANCE_ALLIED)
				set i = i + 1
			endloop
			
			call SetPlayerAllianceStateBJ(Player(PLAYER_NEUTRAL_AGGRESSIVE), MapData.neutralPassivePlayer, bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(MapData.neutralPassivePlayer, Player(PLAYER_NEUTRAL_AGGRESSIVE), bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(MapData.alliedPlayer, MapData.neutralPassivePlayer, bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(MapData.neutralPassivePlayer, MapData.alliedPlayer, bj_ALLIANCE_NEUTRAL)
			
			// class selection
			call TriggerSleepAction(0.0) // class selection multiboard is shown and characters scheme multiboard is created.
			call ClassSelection.showClassSelection.evaluate() // multiboard is created
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call DisplayTextToPlayer(Player(i), 0.0, 0.0, Format(tre("Sprache: %1%", "Language: %1%")).s(GetLanguage()).result())
				set i = i + 1
			endloop
			debug call benchmark.stop()
		endmethod

static if (DEBUG_MODE) then
		private static method onCheatActionCheats takes ACheat cheat returns nothing
			call Print(tre("Spiel-Cheats:", "Game Cheats:"))
			call Print(tr("classes - Listet alle verfügbaren Klassenkürzel auf."))
			call Print(tr("addspells <Klasse> - Der Charakter erhält sämtliche Zauber der Klasse im Zauberbuch (keine Klassenangabe oder \"all\" bewirken das Hinzufügen aller Zauber der anderen Klassen)."))
			call Print(tr("setspellsmax <Klasse> - Alle Zauber des Charakters der Klasse werden auf ihre Maximalstufe gesetzt (keine Klassenangabe oder \"all\" bewirken das Setzen aller Klassenzauber)."))
			call Print(tr("addskillpoints <x> - Der Charakter erhält x Zauberpunkte."))
			call Print(tr("addclassspells - Der Charakter erhält sämtliche Zauber seiner Klasse im Zauberbuch."))
			call Print(tr("addotherclassspells - Der Charakter erhält sämtliche Zauber der anderen Klassen im Zauberbuch."))
			call Print(tr("movable - Der Charakter wird bewegbar oder nicht mehr bewegbar."))
		endmethod

		private static method onCheatActionClasses takes ACheat cheat returns nothing
			call Print(tr("Klassenkürzelliste:"))
			call Print(StringArg(tr("%s - \"c\""), Classes.className(Classes.cleric())))
			call Print(StringArg(tr("%s - \"n\""), Classes.className(Classes.necromancer())))
			call Print(StringArg(tr("%s - \"d\""), Classes.className(Classes.druid())))
			call Print(StringArg(tr("%s - \"k\""), Classes.className(Classes.knight())))
			call Print(StringArg(tr("%s - \"s\""), Classes.className(Classes.dragonSlayer())))
			call Print(StringArg(tr("%s - \"r\""), Classes.className(Classes.ranger())))
			call Print(StringArg(tr("%s - \"e\""), Classes.className(Classes.elementalMage())))
			call Print(StringArg(tr("%s - \"w\""), Classes.className(Classes.wizard())))
		endmethod

		private static method onCheatActionAddSpells takes ACheat cheat returns nothing
			local string class = StringTrim(cheat.argument())
			if (class == "all" or class == null) then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addAllOtherClassSpells.evaluate()
				call Print(tr("Alle anderen Klassenzauber erhalten."))
			elseif (class == "c") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addClericSpells.evaluate()
				call Print(tr("Alle Klerikerzauber erhalten."))
			elseif (class == "n") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addNecromancerSpells.evaluate()
				call Print(tr("Alle Nekromantenzauber erhalten."))
			elseif (class == "d") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addDruidSpells.evaluate()
				call Print(tr("Alle Druidenzauber erhalten."))
			elseif (class == "k") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addKnightSpells.evaluate()
				call Print(tr("Alle Ritterzauber erhalten."))
			elseif (class == "s") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addDragonSlayerSpells.evaluate()
				call Print(tr("Alle Drachentöterzauber erhalten."))
			elseif (class == "r") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addRangerSpells.evaluate()
				call Print(tr("Alle Waldläuferzauber erhalten."))
			elseif (class == "e") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addElementalMageSpells.evaluate()
				call Print(tr("Alle Elementarmagierzauber erhalten."))
			elseif (class == "w") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addWizardSpells.evaluate()
				call Print(tr("Alle Zaubererzauber erhalten."))
			else
				call Print(Format(tr("Unbekanntes Klassenkürzel: \"%1%\"")).s(class).result())
			endif
		endmethod

		private static method onCheatActionSetSpellsMax takes ACheat cheat returns nothing
			local Grimoire grimoire = Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire()
			local integer i = 0
			local boolean result = true
			// try for every spell and do not exit before since it returns false on having the maximum level already
			loop
				exitwhen (i == grimoire.spells())
				if (not grimoire.setSpellMaxLevelByIndex(i, false)) then
					set result = false
				endif
				set i = i + 1
			endloop
			call grimoire.updateUi()
			if (result) then
				call Print(tr("Alle Zauber auf ihre Maximalstufe gesetzt."))
			else
				call Print(tr("Konnte nicht alle Zauber ihre Maximulstufe setzen (eventuell nicht genügend Zauberpunkte)."))
			endif
		endmethod

		private static method onCheatActionAddSkillPoints takes ACheat cheat returns nothing
			local integer skillPoints = S2I(StringTrim(cheat.argument()))
			call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addSkillPoints.evaluate(skillPoints)
			call Print(Format(tr("%1% Zauberpunkt(e) erhalten.")).i(skillPoints).result())
		endmethod

		private static method onCheatActionAddClassSpells takes ACheat cheat returns nothing
			call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addCharacterClassSpells.evaluate()
			call Print(tr("Alle Klassenzauber erhalten."))
		endmethod

		private static method onCheatActionAddOtherClassSpells takes ACheat cheat returns nothing
			call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addAllOtherClassSpells.evaluate()
			call Print(tr("Alle anderen Klassenzauber erhalten."))
		endmethod

		private static method onCheatActionMovable takes ACheat cheat returns nothing
			if (Character.playerCharacter(GetTriggerPlayer()) != 0) then
				if (Character.playerCharacter(GetTriggerPlayer()).isMovable()) then
					call Character.playerCharacter(GetTriggerPlayer()).setMovable(false)
					call Print(tr("Charakter unbewegbar gemacht."))
				else
					call Character.playerCharacter(GetTriggerPlayer()).setMovable(true)
					call Print(tr("Charakter bewegbar gemacht."))
				endif
			else
				call Print(tr("Sie haben keinen Charakter."))
			endif
		endmethod
endif
		/**
		 * \param musicList File paths should be separated by ; character.
		 */
		public static method setMapMusic takes string musicList returns nothing
			call StopMusic(false)
			call ClearMapMusic()
			call SetMapMusic(musicList, true, 0)
			//call ResumeMusic()
		endmethod

		/**
		* Map data structure MapData should always have public static constant string member "mapMusic" which contains a list of music files.
		* If that value is equal to null music won't be changed.
		*/
		public static method setDefaultMapMusic takes nothing returns nothing
			if (MapData.mapMusic != null) then
				call thistype.setMapMusic(MapData.mapMusic)
			endif
		endmethod

		public static method setMapMusicForPlayer takes player whichPlayer, string musicList returns nothing
			call StopMusicForPlayer(whichPlayer, false)
			call ClearMapMusicForPlayer(whichPlayer)
			call SetMapMusicForPlayer(whichPlayer, musicList, true, 0)
		endmethod

		public static method setDefaultMapMusicForPlayer takes player whichPlayer returns nothing
			if (MapData.mapMusic != null) then
				call thistype.setMapMusicForPlayer(whichPlayer, MapData.mapMusic)
			endif
		endmethod
		
		private static method initCharactersScheme takes nothing returns nothing
			local integer i
			call ACharactersScheme.init(1.0, true, true, true, 20, GameExperience.maxExperienceFormula, 20, 20, true, tre("Charaktere", "Characters"), tre("Stufe", "Level"), tre("Hat das Spiel verlassen.", "Has left the game."), "ReplaceableTextures\\CommandButtons\\BTNChestOfGold.blp")
			call ACharactersScheme.setBarWidths(0.003)
			call ACharactersScheme.setExperienceBarValueIcon(0, "Icons\\Interface\\Bars\\Experience\\ExperienceL8.tga")
			call ACharactersScheme.setExperienceBarEmptyIcon(0, "Icons\\Interface\\Bars\\Experience\\ExperienceL0.tga")
			set i = 1
			loop
				exitwhen (i == 19)
				call ACharactersScheme.setExperienceBarValueIcon(i, "Icons\\Interface\\Bars\\Experience\\ExperienceM8.tga")
				call ACharactersScheme.setExperienceBarEmptyIcon(i, "Icons\\Interface\\Bars\\Experience\\ExperienceM0.tga")
				set i = i + 1
			endloop
			call ACharactersScheme.setExperienceBarValueIcon(19, "Icons\\Interface\\Bars\\Experience\\ExperienceR8.tga")
			call ACharactersScheme.setExperienceBarEmptyIcon(19, "Icons\\Interface\\Bars\\Experience\\ExperienceR0.tga")

			call ACharactersScheme.setHitPointsBarValueIcon(0, "Icons\\Interface\\Bars\\Chunk\\ChunkL2.tga")
			call ACharactersScheme.setHitPointsBarEmptyIcon(0, "Icons\\Interface\\Bars\\Chunk\\ChunkL0.tga")
			set i = 1
			loop
				exitwhen (i == 19)
				call ACharactersScheme.setHitPointsBarValueIcon(i, "Icons\\Interface\\Bars\\Chunk\\ChunkM2.tga")
				call ACharactersScheme.setHitPointsBarEmptyIcon(i, "Icons\\Interface\\Bars\\Chunk\\ChunkM0.tga")
				set i = i + 1
			endloop
			call ACharactersScheme.setHitPointsBarValueIcon(19, "Icons\\Interface\\Bars\\Chunk\\ChunkR2.tga")
			call ACharactersScheme.setHitPointsBarEmptyIcon(19, "Icons\\Interface\\Bars\\Chunk\\ChunkR0.tga")

			call ACharactersScheme.setManaBarValueIcon(0, "Icons\\Interface\\Bars\\Mana\\ManaL8.tga")
			call ACharactersScheme.setManaBarEmptyIcon(0, "Icons\\Interface\\Bars\\Mana\\ManaL0.tga")
			set i = 1
			loop
				exitwhen (i == 19)
				call ACharactersScheme.setManaBarValueIcon(i, "Icons\\Interface\\Bars\\Mana\\ManaM8.tga")
				call ACharactersScheme.setManaBarEmptyIcon(i, "Icons\\Interface\\Bars\\Mana\\ManaM0.tga")
				set i = i + 1
			endloop
			call ACharactersScheme.setManaBarValueIcon(19, "Icons\\Interface\\Bars\\Mana\\ManaR8.tga")
			call ACharactersScheme.setManaBarEmptyIcon(19, "Icons\\Interface\\Bars\\Mana\\ManaR0.tga")
		endmethod

		/**
		* This method usually is called after all players selected their character class.
		*/
		public static method start takes nothing returns nothing
			local integer i
			call StopMusic(false)
			call SuspendTimeOfDay(false)
			//call SetCreepCampFilterState(true)
			//call SetAllyColorFilterState(0)
			
			call ForForce(bj_FORCE_PLAYER[0], function thistype.initCharactersScheme)
			

			// create after character creation (character should be F1)
			// disable RPG view
			call Character.setViewForAll(false)
			// enable tutorial by default for beginners
			call Character.setTutorialForAll(true)
			
			// all but one missing, disable characters schema since it is not required
			if (thistype.missingPlayers() == MapData.maxPlayers - 1) then
				set i = 0
				loop
					exitwhen (i == MapData.maxPlayers)
					if (ACharacter.playerCharacter(Player(i)) != 0) then
						call Character(ACharacter.playerCharacter(Player(i))).setShowCharactersScheme(false)
					endif
					set i = i + 1
				endloop
			endif
			
			// shows only if enabled, otherwise hide
			call Character.showCharactersSchemeToAll()


			//call ACharacter.suspendExperienceForAll(true) // we're using a customized experience system

			call Character.addSkillGrimoirePointsToAll(MapData.startSkillPoints)
			
			call CameraHeight.start()

			// debug mode allows you to use various cheats
static if (DEBUG_MODE) then
			call Print(tr("|c00ffcc00TEST-MODUS|r"))
			call Print(tr("Sie befinden sich im Testmodus. Verwenden Sie den Cheat \"gamecheats\", um eine Liste sämtlicher Spiel-Cheats zu erhalten."))
			call ACheat.create("gamecheats", true, thistype.onCheatActionCheats)
			call ACheat.create("classes", true, thistype.onCheatActionClasses)
			call ACheat.create("addspells", false, thistype.onCheatActionAddSpells)
			call ACheat.create("addskillpoints", false, thistype.onCheatActionAddSkillPoints)
			call ACheat.create("setspellsmax", false, thistype.onCheatActionSetSpellsMax)
			call ACheat.create("addclassspells", true, thistype.onCheatActionAddClassSpells)
			call ACheat.create("addotherclassspells", true, thistype.onCheatActionAddOtherClassSpells)
			call ACheat.create("movable", true, thistype.onCheatActionMovable)
endif
			call thistype.setDefaultMapMusic()
			/// has to be called by struct \ref MapData.
			//call ACharacter.setAllMovable(true)
			call MapData.start.execute()
		endmethod

		/// We've got one allied player for shared control with NPCs. Use this method to enable alliance.
		public static method setAlliedPlayerAlliedToPlayer takes player whichPlayer returns nothing
			call SetPlayerAllianceStateBJ(whichPlayer, MapData.alliedPlayer, bj_ALLIANCE_ALLIED_ADVUNITS)
			call SetPlayerAllianceStateBJ(MapData.alliedPlayer, whichPlayer, bj_ALLIANCE_ALLIED_ADVUNITS)
			// works!
			if (Character(Character.playerCharacter(whichPlayer)).showCharactersScheme()) then
				call ACharactersScheme.showForPlayer(whichPlayer) // hide team resources
			else
				call MultiboardSuppressDisplayForPlayer(whichPlayer, true) // hide team resources
			endif
		endmethod

		/// The allied player can also be used for arena fights (one or several characters against NPCs without other characters)
		public static method setAlliedPlayerUnalliedToPlayer takes player whichPlayer returns nothing
			call SetPlayerAllianceStateBJ(whichPlayer, MapData.alliedPlayer, bj_ALLIANCE_UNALLIED)
			call SetPlayerAllianceStateBJ(MapData.alliedPlayer, whichPlayer, bj_ALLIANCE_UNALLIED)
		endmethod

		public static method setAlliedPlayerAlliedToCharacter takes Character character returns nothing
			call thistype.setAlliedPlayerAlliedToPlayer(character.player())
		endmethod

		public static method setAlliedPlayerAlliedToAllCharacters takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (Character.playerCharacter(Player(i)) != 0) then
					call thistype.setAlliedPlayerAlliedToPlayer(Player(i))
				endif
				set i = i + 1
			endloop
		endmethod

		public static method resetCameraBounds takes nothing returns nothing
			local player user
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set user = Player(i)
				if (IsPlayerPlayingUser(user)) then
					call MapData.resetCameraBoundsForPlayer.evaluate(user)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		private static method filterShownItem takes nothing returns boolean
			return not IsItemVisible(GetFilterItem())
		endmethod

		private static method hideItem takes nothing returns nothing
			call SetItemVisible(GetEnumItem(), false)
			call DmdfHashTable.global().setHandleBoolean(GetEnumItem(), "Hidden", true)
		endmethod

		private static method filterShownUnit takes nothing returns boolean
			return not IsUnitHidden(GetFilterUnit()) and not AVideo.unitIsActor(GetFilterUnit())
		endmethod

		private static method hideUnit takes unit whichUnit returns nothing
			call ShowUnit(whichUnit, false)
			call UnitRemoveBuffsBJ(bj_REMOVEBUFFS_NONTLIFE, whichUnit)
		endmethod

		/**
		 * Cinematic stuff (from Bonus Campaign)
		 * - Disables gold and experience by kills.
		 * - Setups music volume.
		 * - Hides all items.
		 * - Hides all character owner units except actors.
		 * - Removes specific buffs.
		 * - Disables all sell abilities for all players to prevent arrows in videos.
		 * - Disables shrine auras.
		 */
		public static method initVideoSettings takes nothing returns nothing
			local integer i
			// Disable all abilities which might be annoying it a video
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYER_SLOTS)
				call SetPlayerAbilityAvailable(Player(i), 'Aneu', false)
				call SetPlayerAbilityAvailable(Player(i), 'Ane2', false)
				call SetPlayerAbilityAvailable(Player(i), 'Asid', false)
				call SetPlayerAbilityAvailable(Player(i), 'Apit', false)
				
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call Character(ACharacter.playerCharacter(Player(i))).grimoire().disableLevelTrigger()
					
					if (Character(ACharacter.playerCharacter(Player(i))).credits() != 0 and  Character(ACharacter.playerCharacter(Player(i))).credits().isShown()) then
						call Character(ACharacter.playerCharacter(Player(i))).credits().hide()
					endif
				endif
				set i = i + 1
			endloop
			call ForForce(bj_FORCE_PLAYER[0], function Fellow.reviveAllForVideo)
			call ForForce(bj_FORCE_PLAYER[0], function SpawnPoint.pauseAll)
			call ForForce(bj_FORCE_PLAYER[0], function ItemSpawnPoint.pauseAll)
			call ForForce(bj_FORCE_PLAYER[0], function Routines.destroyTextTags)
			call DisableTrigger(thistype.m_killTrigger)
			//call VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UI, 1.0) /// @todo TEST
			call VolumeGroupSetVolume(SOUND_VOLUMEGROUP_MUSIC, 1.0)
			call EnumItemsInRect(GetPlayableMapRect(), Filter(function thistype.filterShownItem), function thistype.hideItem)
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (Character.playerCharacter(Player(i)) != 0) then
					call AGroup(thistype.m_hiddenUnits[i]).addUnitsOfPlayer(Player(i), Filter(function thistype.filterShownUnit))
					call AGroup(thistype.m_hiddenUnits[i]).forGroup(thistype.hideUnit)
				endif
				set i = i + 1
			endloop
			call DisableTransparency()
			call CameraHeight.pause()
			call MapData.initVideoSettings.evaluate()
		endmethod

		private static method filterHiddenItem takes nothing returns boolean
			return DmdfHashTable.global().handleBoolean(GetFilterItem(), "Hidden")
		endmethod

		private static method showItem takes nothing returns nothing
			call SetItemVisible(GetEnumItem(), true)
			call DmdfHashTable.global().removeHandleBoolean(GetEnumItem(), "Hidden")
		endmethod

		private static method showUnit takes unit whichUnit returns nothing
			call ShowUnit(whichUnit, true)
		endmethod

		public static method resetVideoSettings takes nothing returns nothing
			local integer i
			// Enable all abilities which might be annoying it a video
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYER_SLOTS)
				call SetPlayerAbilityAvailable(Player(i), 'Aneu', true)
				call SetPlayerAbilityAvailable(Player(i), 'Ane2', true)
				call SetPlayerAbilityAvailable(Player(i), 'Asid', true)
				call SetPlayerAbilityAvailable(Player(i), 'Apit', true)
				
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call Character(ACharacter.playerCharacter(Player(i))).grimoire().enableLevelTrigger()
					call ACharacter.playerCharacter(Player(i)).panCameraSmart()
					call SetCameraFieldForPlayer(Player(i), CAMERA_FIELD_TARGET_DISTANCE, Character(ACharacter.playerCharacter(Player(i))).mainMenu().cameraDistance.evaluate(), 0.0)
				endif
				
				set i = i + 1
			endloop
			call thistype.resetCameraBounds()
			call EnableTrigger(thistype.m_killTrigger)
			/*
			 * Make sure that not default wc3 music is played.
			 */
			call thistype.setDefaultMapMusic()
			call ForForce(bj_FORCE_PLAYER[0], function SpawnPoint.resumeAll)
			call ForForce(bj_FORCE_PLAYER[0], function ItemSpawnPoint.resumeAll)
			call EnumItemsInRect(GetPlayableMapRect(), Filter(function thistype.filterHiddenItem), function thistype.showItem)
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (Character.playerCharacter(Player(i)) != 0) then
					call AGroup(thistype.m_hiddenUnits[i]).forGroup(thistype.showUnit)
					call AGroup(thistype.m_hiddenUnits[i]).units().clear()
				endif
				set i = i + 1
			endloop
			call EnableTransparency()
			call CameraHeight.resume()
			call MapData.resetVideoSettings.evaluate()
		endmethod

		public static method addUnitMoveSpeed takes unit whichUnit, real value returns real
			if (value + GetUnitMoveSpeed(whichUnit) > thistype.maxMoveSpeed) then
				set value = thistype.maxMoveSpeed - GetUnitMoveSpeed(whichUnit)
			elseif (value + GetUnitMoveSpeed(whichUnit) < 0.0) then
				set value = 0.0
			endif
			call SetUnitMoveSpeed(whichUnit, GetUnitMoveSpeed(whichUnit) + value)
			return value
		endmethod

		public static method removeUnitMoveSpeed takes unit whichUnit, real value returns real
			return thistype.addUnitMoveSpeed(whichUnit, -value)
		endmethod

		public static method hideSpawnPointUnits takes ASpawnPoint spawnPoint returns nothing
			local integer i = 0
			loop
				exitwhen (i == spawnPoint.countUnits())
				call ShowUnit(spawnPoint.unit(i), false)
				set i = i + 1
			endloop
		endmethod

		public static method showSpawnPointUnits takes ASpawnPoint spawnPoint returns nothing
			local integer i = 0
			loop
				exitwhen (i == spawnPoint.countUnits())
				call ShowUnit(spawnPoint.unit(i), true)
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary