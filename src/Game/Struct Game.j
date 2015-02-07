library StructGameGame requires Asl, StructGameCharacter, StructGameItemTypes

	// helps finding stops on metamorphosis spells
	private function PrintImmediateStop takes unit whichUnit, string whichOrder returns nothing
		if (whichOrder == "stop") then
			debug call Print("Immediate stop on " + GetUnitName(whichUnit))
		endif
	endfunction

	hook IssueImmediateOrder PrintImmediateStop

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
		private static constant real range = 0.0
		private static constant real unitsFactor = 1.0
		private static constant real alliedUnitsFactor = 1.0
		private static constant real characterFactor = 1.0
		private static constant real alliedCharactersFactor = 1.0

		public static method maxExperienceFormula takes unit hero returns integer
			return GetHeroMaxXP(hero)
		endmethod

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
				set result = I2R(GetUnitXP(whichUnit))
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

			return R2I(result)
		endmethod

		public static method giveUnitExperienceToCharacter takes Character character, unit whichUnit, unit killingUnit returns integer
			local integer experience = thistype.unitExperienceForCharacter(character, whichUnit, killingUnit)
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

		public static method unitBounty takes unit whichUnit returns integer
			return R2I(GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE) + GetUnitState(whichUnit, UNIT_STATE_MAX_MANA)) / 10 + GetUnitLevel(whichUnit) * 10 /// @todo Get the right formula.
		endmethod

		public static method unitBountyForCharacter takes Character character, unit whichUnit, unit killingUnit returns integer
			// never give bounty for buildings. For example boxes are buildings.
			if (GetUnitAllianceStateToUnit(character.unit(), whichUnit) != bj_ALLIANCE_UNALLIED or (GetUnitAllianceStateToUnit(character.unit(), killingUnit) != bj_ALLIANCE_ALLIED and character.player() != GetOwningPlayer(killingUnit)) or IsUnitType(whichUnit, UNIT_TYPE_STRUCTURE)) then
				return 0
			endif
			return thistype.unitBounty(whichUnit) / ACharacter.countAllPlaying()
		endmethod

		public static method giveBountyToCharacter takes Character character, unit whichUnit, unit killingUnit returns integer
			local integer bounty = thistype.unitBountyForCharacter(character, whichUnit, killingUnit)
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
		private static AWeather m_weather
		private static trigger m_levelTrigger
		private static trigger m_killTrigger
		private static AIntegerVector array m_hiddenUnits[6] /// \todo \ref MapData.maxPlayers

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// Access weather by @struct MapData.
		public static method weather takes nothing returns AWeather
			return thistype.m_weather
		endmethod

		public static method hostilePlayer takes nothing returns player
			return Player(PLAYER_NEUTRAL_AGGRESSIVE)
		endmethod

		public static method playingPlayers takes nothing returns integer
			return CountPlayingPlayers() - MapData.computerPlayers
		endmethod

		public static method missingPlayers takes nothing returns integer
			return MapData.maxPlayers - thistype.playingPlayers()
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
			//debug call Print("Damage recorder list id :" + I2S(thistype.m_onDamageActions) + " and size: " + thistype.m_onDamageActions.size())
			loop
				exitwhen (not iterator.isValid())
				//debug call Print("Damage recorder")
				call ADamageRecorderOnDamageAction(iterator.data()).evaluate(damageRecorder)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

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

		private static method createWeather takes nothing returns nothing
			set thistype.m_weather = AWeather.create()
		endmethod

		private static method triggerConditionLevel takes nothing returns boolean
			local unit triggerUnit = GetTriggerUnit()
			local boolean result = ACharacter.isUnitCharacter(triggerUnit)
			set triggerUnit = null

			return result
		endmethod

		private static method triggerActionLevel takes nothing returns nothing
			local unit triggerUnit = GetTriggerUnit()
			local Character character = ACharacter.getCharacterByUnit(triggerUnit)
			local integer bonus
			call character.grimoire().addSkillPoints.evaluate(MapData.levelSpellPoints)

			// decrease difficulty
			set bonus = Character.attributesLevelBonus()
			if (bonus > 0) then
				debug call Print("Difficulty is easier, adding attribute bonus " + I2S(bonus))
				call ModifyHeroStat(bj_HEROSTAT_STR, triggerUnit, bj_MODIFYMETHOD_ADD, bonus)
				call ModifyHeroStat(bj_HEROSTAT_AGI, triggerUnit, bj_MODIFYMETHOD_ADD, bonus)
				call ModifyHeroStat(bj_HEROSTAT_INT, triggerUnit, bj_MODIFYMETHOD_ADD, bonus)
			endif

			// reached last level TODO: maybe we should give him a little present
			if (GetHeroLevel(triggerUnit) == MapData.maxLevel) then
				call character.displayFinalLevel(tr("Sie haben die letzte Stufe erreicht."))
				call character.displayFinalLevelToAllOthers(StringArg(tr("%s hat die letzte Stufe erreicht."), character.name()))
			endif

			set triggerUnit = null
		endmethod

		private static method createLevelTrigger takes nothing returns nothing
			local conditionfunc conditionFunction
			local triggercondition triggerCondition
			local triggeraction triggerAction
			set thistype.m_levelTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_levelTrigger, EVENT_PLAYER_HERO_LEVEL)
			set conditionFunction = Condition(function thistype.triggerConditionLevel)
			set triggerCondition = TriggerAddCondition(thistype.m_levelTrigger, conditionFunction)
			set triggerAction = TriggerAddAction(thistype.m_levelTrigger, function thistype.triggerActionLevel)
			set conditionFunction = null
			set triggerCondition = null
			set triggerAction = null
		endmethod

		private static method triggerActionKill takes nothing returns nothing
			if (GetOwningPlayer(GetTriggerUnit()) == Player(PLAYER_NEUTRAL_AGGRESSIVE)) then
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
static if (DMDF_VIOLENCE) then
			call TriggerRegisterAnyUnitEventBJ(thistype.m_killTrigger, EVENT_PLAYER_UNIT_DEATH)
else
			call TriggerRegisterPlayerUnitEvent(thistype.m_killTrigger,  Player(PLAYER_NEUTRAL_AGGRESSIVE), EVENT_PLAYER_UNIT_DEATH, null)
endif
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
			call AJump.init(1.00, null) /// @todo Set correct refresh rate.
			// interface systems
			call AArrowKeys.init(true)
			call AThirdPersonCamera.init(true)
			// bonus mod systems
			call AInitBonusMod()
			// gui systems
			/// @todo Use localized shortcuts
			call ADialog.init('V',  'N', tr("Vorherige Seite"), tr("Nächste Seite"), tr("%s|n(%i/%i)"))
			call AGui.init('h003', 0.0, 0.0, tr("OK"), sc("DMDF_GUI_OK_SHORTCUT"))
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
			call AVote.init(4.0, tr("%1% hat für \"%2%\" gestimmt (%3% Stimme(n))."), tr("Abstimmung wurde mit dem Ergebnis \"%1%\" abgeschlossen (%2% Stimme(n))"))
			// character systems
			call AAbstractQuest.init(15.0, "Sound\\Interface\\QuestNew.wav", "Sound\\Interface\\QuestCompleted.wav", "Sound\\Interface\\QuestFailed.wav", tr("%s"), tr("|cffc3dbff%s (Abgeschlossen)|r"), tr("%s (|c00ff0000Fehlgeschlagen|r)"), tr("+%i Stufe(n)"), tr("+%i Fähigkeitenpunkt(e)"), tr("+%i Erfahrung"), tr("+%i Stärke"), tr("+%i Geschick"), tr("+%i Wissen"), tr("+%i Goldmünze(n)"), tr("+%i Holz"))
			call ABuff.init()
			call ACharacter.init(true, true, false, true, false, true, true, true, DMDF_INFO_LOG)
			call AClass.init(1, 1)
			call initSpeechSkip(AKeyEscape, 0.10)
			call AInventory.init('I001', 'I000', 'A015', false, tr("Ausrüstungsfach wird bereits von einem anderen Gegenstand belegt."), null, tr("Rucksack ist voll."),  tr("\"%s\" im Rucksack verstaut."), tr("Gegenstand konnte nicht verschoben werden."), tr("Die Seitengegenstände können nicht abgelegt werden."), tr("Die Seitengegenstände können nicht verschoben werden."), tr("Der Gegendstand gehört einem anderen Spieler."))
			call AItemType.init(tr("Gegenstand benötigt eine höhere Stufe."), tr("Gegenstand benötigt mehr Stärke."), tr("Gegenstand benötigt mehr Geschick."), tr("Gegenstand benötigt mehr Wissen."), tr("Gegenstand benötigt eine andere Charakterklasse."))
			call AQuest.init0(true, true, "Sound\\Interface\\QuestLog.wav", tr("|c00ffcc00NEUER AUFTRAG|r"), tr("|c00ffcc00AUFTRAG ABGESCHLOSSEN|r"), tr("|c00ffcc00AUFTRAG FEHLGESCHLAGEN|r"), tr("|c00ffcc00AUFTRAGS-AKTUALISIERUNG|r"), tr("- %s"))
			call AVideo.init(2, 4.0, tr("Spieler %s möchte das Video überspringen."), tr("Video wird übersprungen."))
			// world systems
			call ASpawnPoint.init()
			call AWeather.init()
			// Die Macht des Feuers
			// game
			set thistype.m_onDamageActions = AIntegerList.create()
static if (DMDF_VIOLENCE) then
			call thistype.registerOnDamageActionOnce(thistype.onDamageActionViolence) // blood/violence system
endif
			call thistype.createWeather()
			call thistype.createLevelTrigger()
			call thistype.createKillTrigger()
			// game guis
			call Credits.init0.evaluate()
			//! import "Game/Credits.j"
			call Fellow.init.evaluate(tr("%1% hat sich Ihrer Gruppe angeschlossen."), null, tr("%1% hat Ihre Gruppe verlassen."), null, tr("%1% ist gefallen und wird in %2% Sekunden wiederbelebt."), null)
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
			// tutorial GUI, after map data!
			call Tutorial.init.evaluate()
			
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (GetPlayerController(Player(i)) != MAP_CONTROL_NONE) then
					set thistype.m_hiddenUnits[i] = AGroup.create()
				endif

				// set melee to default
				// when range items are equipped the range research will be level 1 and the melee 0
				// both attack types are enabled by default therefore the range has to be disabled
				// the melee research does also enable ONLY attack 1
				// if both attack types are not enabled by default, the icon for the range attack type will be hidden!
				call SetPlayerTechResearched(Player(i), MapData.rangeResearchId, 0)
				call SetPlayerTechResearched(Player(i), MapData.meleeResearchId, 1)
				
				// set allied player and neutral passive player alliance status
				call SetPlayerAllianceStateBJ(Player(i), MapData.alliedPlayer, bj_ALLIANCE_NEUTRAL)
				call SetPlayerAllianceStateBJ(MapData.alliedPlayer, Player(i), bj_ALLIANCE_NEUTRAL)
				call SetPlayerAllianceStateBJ(Player(i), MapData.neutralPassivePlayer, bj_ALLIANCE_NEUTRAL)
				call SetPlayerAllianceStateBJ(MapData.neutralPassivePlayer, Player(i), bj_ALLIANCE_NEUTRAL)
				set i = i + 1
			endloop
			
			call SetPlayerAllianceStateBJ(Player(PLAYER_NEUTRAL_AGGRESSIVE), MapData.neutralPassivePlayer, bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(MapData.neutralPassivePlayer, Player(PLAYER_NEUTRAL_AGGRESSIVE), bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(MapData.alliedPlayer, MapData.neutralPassivePlayer, bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(MapData.neutralPassivePlayer, MapData.alliedPlayer, bj_ALLIANCE_NEUTRAL)
			
			// class selection
			call TriggerSleepAction(0.0) // class selection multiboard is shown and characters scheme multiboard is created.
			call Classes.showClassSelection() // multiboard is created
			debug call benchmark.stop()
		endmethod

static if (DEBUG_MODE) then
		private static method onCheatActionCheats takes ACheat cheat returns nothing
			call Print(tr("Spiel-Cheats:"))
			call Print(tr("cleanup - Räumt den Rucksack des Charakters auf."))
			call Print(tr("classes - Listet alle verfügbaren Klassenkürzel auf."))
			call Print(tr("addspells <Klasse> - Der Charakter erhält sämtliche Zauber der Klasse im Zauberbuch (keine Klassenangabe oder \"all\" bewirken das Hinzufügen aller Zauber der anderen Klassen)."))
			call Print(tr("setspellsmax <Klasse> - Alle Zauber des Charakters der Klasse werden auf ihre Maximalstufe gesetzt (keine Klassenangabe oder \"all\" bewirken das Setzen aller Klassenzauber)."))
			call Print(tr("addskillpoints <x> - Der Charakter erhält x Zauberpunkte."))
			call Print(tr("addclassspells - Der Charakter erhält sämtliche Zauber seiner Klasse im Zauberbuch."))
			call Print(tr("addotherclassspells - Der Charakter erhält sämtliche Zauber der anderen Klassen im Zauberbuch."))
			call Print(tr("movable - Der Charakter wird bewegbar oder nicht mehr bewegbar."))
static if (DMDF_CHARACTER_STATS) then
			call Print(tr("stats - Zeigt die Statistik des Spielercharakters an."))
endif
		endmethod

		private static method onCheatActionCleanup takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call Print(tr("Rucksack wird aufgeräumt."))
			call ACharacter.playerCharacter(whichPlayer).inventory().cleanUpRucksack()
			set whichPlayer = null
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
			call Print(StringArg(tr("%s - \"a\""), Classes.className(Classes.astralModifier())))
			call Print(StringArg(tr("%s - \"i\""), Classes.className(Classes.illusionist())))
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
			elseif (class == "a") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addAstralModifierSpells.evaluate()
				call Print(tr("Alle Astralwandlerzauber erhalten."))
			elseif (class == "i") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addIllusionistSpells.evaluate()
				call Print(tr("Alle Illusionistenzauber erhalten."))
			elseif (class == "w") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addWizardSpells.evaluate()
				call Print(tr("Alle Zaubererzauber erhalten."))
			else
				call Print(Format(tr("Unbekanntes Klassenkürzel: \"%1%\"")).s(class).result())
			endif
		endmethod

		private static method onCheatActionSetSpellsMax takes ACheat cheat returns nothing
			if (Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().setSpellsMaxLevel.evaluate()) then
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

static if (DMDF_CHARACTER_STATS) then
		private static method onCheatActionStats takes ACheat cheat returns nothing
			call Character(ACharacter.playerCharacter(GetTriggerPlayer())).characterStats().show()
		endmethod
endif

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

		/**
		* This method usually is called after all players selected their character class.
		*/
		public static method start takes nothing returns nothing
			local integer i
			local integer playingPlayers
			local integer missingPlayers
			local integer startBonus
			local integer levelBonus
			call StopMusic(false)
			call SuspendTimeOfDay(false)
			//call SetCreepCampFilterState(true)
			//call SetAllyColorFilterState(0)
			call thistype.m_weather.start()
			call ACharactersScheme.init(1.0, true, true, true, 10, GameExperience.maxExperienceFormula, 10, 10, tr("Charaktere"), tr("Stufe"), tr("Hat das Spiel verlassen."))
			call ACharactersScheme.setExperienceBarValueIcon(0, "Icons\\Interface\\Bars\\Experience\\ExperienceL8.tga")
			call ACharactersScheme.setExperienceBarEmptyIcon(0, "Icons\\Interface\\Bars\\Experience\\ExperienceL0.tga")
			set i = 1
			loop
				exitwhen (i == 9)
				call ACharactersScheme.setExperienceBarValueIcon(i, "Icons\\Interface\\Bars\\Experience\\ExperienceM8.tga")
				call ACharactersScheme.setExperienceBarEmptyIcon(i, "Icons\\Interface\\Bars\\Experience\\ExperienceM0.tga")
				set i = i + 1
			endloop
			call ACharactersScheme.setExperienceBarValueIcon(9, "Icons\\Interface\\Bars\\Experience\\ExperienceR8.tga")
			call ACharactersScheme.setExperienceBarEmptyIcon(9, "Icons\\Interface\\Bars\\Experience\\ExperienceR0.tga")

			call ACharactersScheme.setHitPointsBarValueIcon(0, "Icons\\Interface\\Bars\\Chunk\\ChunkL2.tga")
			call ACharactersScheme.setHitPointsBarEmptyIcon(0, "Icons\\Interface\\Bars\\Chunk\\ChunkL0.tga")
			set i = 1
			loop
				exitwhen (i == 9)
				call ACharactersScheme.setHitPointsBarValueIcon(i, "Icons\\Interface\\Bars\\Chunk\\ChunkM2.tga")
				call ACharactersScheme.setHitPointsBarEmptyIcon(i, "Icons\\Interface\\Bars\\Chunk\\ChunkM0.tga")
				set i = i + 1
			endloop
			call ACharactersScheme.setHitPointsBarValueIcon(9, "Icons\\Interface\\Bars\\Chunk\\ChunkR2.tga")
			call ACharactersScheme.setHitPointsBarEmptyIcon(9, "Icons\\Interface\\Bars\\Chunk\\ChunkR0.tga")

			call ACharactersScheme.setManaBarValueIcon(0, "Icons\\Interface\\Bars\\Mana\\ManaL8.tga")
			call ACharactersScheme.setManaBarEmptyIcon(0, "Icons\\Interface\\Bars\\Mana\\ManaL0.tga")
			set i = 1
			loop
				exitwhen (i == 9)
				call ACharactersScheme.setManaBarValueIcon(i, "Icons\\Interface\\Bars\\Mana\\ManaM8.tga")
				call ACharactersScheme.setManaBarEmptyIcon(i, "Icons\\Interface\\Bars\\Mana\\ManaM0.tga")
				set i = i + 1
			endloop
			call ACharactersScheme.setManaBarValueIcon(9, "Icons\\Interface\\Bars\\Mana\\ManaR8.tga")
			call ACharactersScheme.setManaBarEmptyIcon(9, "Icons\\Interface\\Bars\\Mana\\ManaR0.tga")
			// shows only if enabled
			call Character.showCharactersSchemeToAll()

			// create after character creation (character should be F1)
			call Character.createHeroIconsForAll()
			// disable RPG view
			call Character.setViewForAll(false)
			// enable tutorial by default for beginners
			call Character.setTutorialForAll(true)

			call ACharacter.suspendExperienceForAll(true) // we're using a customized experience system

			call Character.addSkillGrimoirePointsToAll(MapData.startSkillPoints)

			// get difficulty
			set playingPlayers = thistype.playingPlayers()
			set missingPlayers = thistype.missingPlayers()

			// decrease difficulty for others if players are missing
			set startBonus = Character.attributesStartBonus()
			if (startBonus > 0) then

				call ACharacter.addStrengthToAll(startBonus)
				call ACharacter.addAgilityToAll(startBonus)
				call ACharacter.addIntelligenceToAll(startBonus)
				call Character.displayDifficultyToAll(Format(tr("Da Sie das Spiel ohne %1% Spieler beginnen, erhält Ihr Charakter auf jedes seiner Attribute einen Bonus von %2% Punkten. Zudem erhält Ihr Charakter pro Stufenaufstieg auf jedes seiner Attribute einen Bonus von %3% Punkten und sowohl mehr Erfahrungspunkte als auch mehr Goldmünzen beim Töten von Gegnern.")).s(trp("einen weiteren", Format("%1% weitere").i(missingPlayers).result(), missingPlayers)).i(startBonus).i(Character.attributesLevelBonus()).result())
			endif

			// just a little notice that you're watching a replay
			if (not IsInGameEx()) then
				call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, tr("|c00ffcc00WIEDERHOLUNG|r"))
				call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, tr("Sie befinden sich in der Wiederholung eines Spiels, welches bereits stattgefunden hat."))
			endif

			// debug mode allows you to use various cheats
static if (DEBUG_MODE) then
			call Print(tr("|c00ffcc00TEST-MODUS|r"))
			call Print(tr("Sie befinden sich im Testmodus. Verwenden Sie den Cheat \"gamecheats\", um eine Liste sämtlicher Spiel-Cheats zu erhalten."))
			call ACheat.create("gamecheats", true, thistype.onCheatActionCheats)
			call ACheat.create("cleanup", true, thistype.onCheatActionCleanup)
			call ACheat.create("classes", true, thistype.onCheatActionClasses)
			call ACheat.create("addspells", false, thistype.onCheatActionAddSpells)
			call ACheat.create("addskillpoints", false, thistype.onCheatActionAddSkillPoints)
			call ACheat.create("setspellsmax", false, thistype.onCheatActionSetSpellsMax)
			call ACheat.create("addclassspells", true, thistype.onCheatActionAddClassSpells)
			call ACheat.create("addotherclassspells", true, thistype.onCheatActionAddOtherClassSpells)
			call ACheat.create("movable", true, thistype.onCheatActionMovable)
static if (DMDF_CHARACTER_STATS) then
			call ACheat.create("stats", true, thistype.onCheatActionStats)
endif
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
			return not IsUnitHidden(GetFilterUnit())
		endmethod

		private static method hideUnit takes unit whichUnit returns nothing
			call ShowUnit(whichUnit, false)
			call UnitRemoveBuffsBJ(bj_REMOVEBUFFS_NONTLIFE, whichUnit)
		endmethod

		/**
		 * Cinematic stuff (from Bonus Campaign)
		 * - Disables weather.
		 * - Disables gold and experience by kills.
		 * - Setups music volume.
		 * - Hides all items.
		 * - Hides all character owner units.
		 * - Removes specific buffs.
		 */
		public static method initVideoSettings takes nothing returns nothing
			local integer i
			call thistype.m_weather.disable()
			call Fellow.pauseAllRevivals.evaluate(true)
			call DisableTrigger(thistype.m_levelTrigger)
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
			// Disable all abilities which might be annoying it a video
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYER_SLOTS)
				call SetPlayerAbilityAvailable(Player(i), 'Aneu', false)
				call SetPlayerAbilityAvailable(Player(i), 'Ane2', false)
				call SetPlayerAbilityAvailable(Player(i), 'Asid', false)
				call SetPlayerAbilityAvailable(Player(i), 'Apit', false)
				set i = i + 1
			endloop
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
			call thistype.resetCameraBounds()
			call thistype.m_weather.enable()
			call EnableTrigger(thistype.m_levelTrigger)
			call EnableTrigger(thistype.m_killTrigger)
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
			// Enable all abilities which might be annoying it a video
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYER_SLOTS)
				call SetPlayerAbilityAvailable(Player(i), 'Aneu', true)
				call SetPlayerAbilityAvailable(Player(i), 'Ane2', true)
				call SetPlayerAbilityAvailable(Player(i), 'Asid', true)
				call SetPlayerAbilityAvailable(Player(i), 'Apit', true)
				set i = i + 1
			endloop
			
			/*
			 * Make sure that not default wc3 music is played.
			 */
			call thistype.setDefaultMapMusic()
			call Fellow.pauseAllRevivals.evaluate(false)
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