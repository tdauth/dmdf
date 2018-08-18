library StructGameGame requires Asl, StructGameCameraHeight, StructGameCharacter, StructGameItemTypes, StructGameMapChanger, StructGameOrderAnimations, StructGameRoutines, StructGameTreeTransparency, LibraryGameLanguage

	/**
	 * \brief A static class which defines unit type ids with identifiers.
	 */
	struct UnitTypes
		public static constant integer orcCrossbow = 'n01A'
		public static constant integer orcBerserk = 'n01G'
		public static constant integer orcWarlock = 'n018'
		public static constant integer orcWarrior = 'n019'
		public static constant integer orcGolem = 'n025'
		public static constant integer orcPython = 'n01F'
		public static constant integer orcLeader = 'n02P'
		public static constant integer darkElfSatyr = 'n02O'
		public static constant integer norseman = 'n01I'
		public static constant integer ranger = 'n03F'
		public static constant integer armedVillager = 'n03H'

		public static constant integer broodMother = 'n05F'
		public static constant integer deathAngel = 'n02K'
		public static constant integer vampire = 'n02L'
		public static constant integer vampireLord = 'n010'
		public static constant integer doomedMan = 'n037'
		public static constant integer deacon = 'n035'
		public static constant integer ravenJuggler = 'n036'
		public static constant integer degenerateSoul = 'n038'
		public static constant integer medusa = 'n033'
		public static constant integer thunderCreature = 'n034'

		public static constant integer boneDragon = 'n024'

		public static constant integer deranor = 'u00A'

		public static constant integer cornEater = 'n016'

		public static constant integer witch = 'h00F'

		public static constant integer giant = 'n02R'

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod
	endstruct

	/**
	 * \brief This static structure provides constants and functions for DMdFs experience calculation for all experience which is gained by killing other units.
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
		/// \note If the range is 0.0 or smaller it is ignored.
		private static constant real range = 0.0
		private static constant real xpHandicap = 0.10 // this XP factor is used to reduce the actual gained experience such as in the Bonus Campaign. We want to prevent the characters from leveling too fast. In the Bonus Campaign it is 10 % and on difficulty hard it is even 7 %.
		private static constant real unitsFactor = 1.0
		private static constant real alliedUnitsFactor = 1.0
		private static constant real characterFactor = 1.0
		private static constant real alliedCharactersFactor = 1.0

		public static method currentExperieneFormula takes unit hero returns integer
			local integer previousLevelXP = GetHeroLevelMaxXP(GetHeroLevel(hero) - 1)
			return GetHeroXP(hero) - previousLevelXP
		endmethod

		public static method maxExperienceFormula takes unit hero returns integer
			local integer previousLevelXP = GetHeroLevelMaxXP(GetHeroLevel(hero) - 1)
			return GetHeroLevelMaxXP(GetHeroLevel(hero)) - previousLevelXP
		endmethod

		/**
		 * \param unitTypeId The unit type ID of a killed unit.
		 * \return Returns true if units with the unit type ID \p unitTypeId give experience. Otherwise, it returns false.
		 */
		public static method unitTypeIdGivesXp takes integer unitTypeId returns boolean
			return unitTypeId != 'n04B' and unitTypeId != 'n04C' and unitTypeId != 'n04D' and unitTypeId != 'n02C' and unitTypeId != 'n031' and unitTypeId != 'n032'
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
				// Warcraft III default XP formula
				set result = I2R(GetUnitXP(whichUnit)) * thistype.xpHandicap
				if (killingUnit == character.unit()) then
					set result = result * thistype.characterFactor
				elseif (ACharacter.isUnitCharacter(killingUnit)) then
					set result = result * thistype.alliedCharactersFactor
				elseif (GetOwningPlayer(killingUnit) == character.player()) then
					set result = result * thistype.unitsFactor
				else
					set result = result * thistype.alliedUnitsFactor
				endif
			endif

			return IMaxBJ(R2I(result), 1) // give at least 1 XP
		endmethod

		/**
		 * Gives a character the XP gained for killing unit \p whichUnit by the killer \p killingUnit.
		 * \return Returns the XP.
		 */
		public static method giveUnitExperienceToCharacter takes Character character, unit whichUnit, unit killingUnit returns integer
			local integer experience = thistype.unitExperienceForCharacter(character, whichUnit, killingUnit)
			//debug call Print("Experience: " + I2S(experience))
			if (experience > 0) then
				if (not IsUnitDeadBJ(character.unit())) then
					call ShowGeneralFadingTextTagForPlayer(character.player(), IntegerArg(tre("+%i", "+%i"), experience), GetUnitX(character.unit()), GetUnitY(character.unit()), 255, 0, 255, 255)
				endif
				call character.addExperience(experience, true)
			endif
			return experience
		endmethod

		public static method distributeUnitExperience takes unit whichUnit, unit killingUnit returns integer
			local integer experience = 0
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
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
			return thistype.unitBounty(whichUnit)
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
				exitwhen (i == MapSettings.maxPlayers())
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

	/**
	 * \brief The static game struct with all important global methods and attributes.
	 * Has all the static initialization methods and relies on the static struct MapData in every map with specific methods and attributes.
	 */
	struct Game
		/// The version of the current release of the modification.
		public static constant string gameVersion = "1.0"

		/**
		 * The polling interval in seconds when waiting for a video.
		 */
		public static constant real videoWaitInterval = 1.0

		private static constant real maxMoveSpeed = 522.0
		private static AIntegerList m_onDamageActions
		private static trigger m_killTrigger
		private static AIntegerVector array m_hiddenUnits[12] /// \todo \ref MapSettings.maxPlayers() + 1 (one additional for MapSettings.alliedPlayer())
		/**
		 * The order animations for the actor of the character.
		 */
		private static OrderAnimations m_actorOrderAnimations
		/**
		 * The global characters scheme which can be shown or hidden by any player.
		 */
		private static ACharactersScheme m_charactersScheme
		/**
		 * Indicates if the map has been started by a map transition in the singleplayer campaign or not.
		 */
		private static boolean m_restoreCharacters

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/**
		 * \return Returns the global characters scheme which uses a multiboard.
		 */
		public static method charactersScheme takes nothing returns ACharactersScheme
			return thistype.m_charactersScheme
		endmethod

		/**
		 * This method detects if the current game is a map in the singleplayer campaign.
		 * \return Returns true if the current game is in the campaign. Otherwise if it's a normal map (for example in multiplayer) it returns false.
		 */
		public static method isCampaign takes nothing returns boolean
			// this custom object should only exist in the campaign not in the usual maps
			return GetObjectName('h03V') == "IsCampaign"
		endmethod

		/**
		 * \return Returns true if the characters should be restored from the gamecache in the beginning of the game. Otherwise, it returns false.
		 */
		public static method restoreCharacters takes nothing returns boolean
			return thistype.m_restoreCharacters
		endmethod

		/**
		 * Adds occlusion detection to default doodads such as trees.
		 * Of course they need the animation "Stand Alternate" which makes them transparent.
		 */
		public static method addDefaultDoodadsOcclusion takes nothing returns nothing
			call AddDoodadOcclusion('D027')
			call AddDoodadOcclusion('D028')
			call AddDoodadOcclusion('D029')
			call AddDoodadOcclusion('D02A')
			call AddDoodadOcclusion('D02B')
			call AddDoodadOcclusion('D02C')
			call AddDoodadOcclusion('D02D')
			call AddDoodadOcclusion('D02E')
			call AddDoodadOcclusion('D02F')
			call AddDoodadOcclusion('D02G')
			call AddDoodadOcclusion('D02H')
			call AddDoodadOcclusion('D02I')
			call AddDoodadOcclusion('D02J')
			call AddDoodadOcclusion('D02K')
			call AddDoodadOcclusion('D074')
			call AddDoodadOcclusion('D075')
			call AddDoodadOcclusion('D076')
			call AddDoodadOcclusion('D077')
			call AddDoodadOcclusion('D078')
			call AddDoodadOcclusion('D08E')
			call AddDoodadOcclusion('D08F')

			call AddDoodadOcclusion('D02N')
			call AddDoodadOcclusion('D02O')
			call AddDoodadOcclusion('D02P')
			call AddDoodadOcclusion('D02Q')
			call AddDoodadOcclusion('D02R')
			call AddDoodadOcclusion('D02S')
			call AddDoodadOcclusion('D02T')
			call AddDoodadOcclusion('D02U')
			call AddDoodadOcclusion('D02V')
			call AddDoodadOcclusion('D02W')
			call AddDoodadOcclusion('D02X')
			call AddDoodadOcclusion('D07B')
			call AddDoodadOcclusion('D07C')
			call AddDoodadOcclusion('D07D')

			call AddDoodadOcclusion('D04K')
		endmethod

		/**
		 * \return Returns the player who owns all the creeps in the map.
		 */
		public static method hostilePlayer takes nothing returns player
			return Player(PLAYER_NEUTRAL_AGGRESSIVE)
		endmethod

		/**
		 * \return Returns the number of missing players from the character controlling players.
		 */
		public static method missingPlayers takes nothing returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_EMPTY) then
					set result = result + 1
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		/**
		 * Depending on the missing characters and the set difficulty the handicap of the player PLAYER_NEUTRAL_AGGRESSIVE is set.
		 * Therefore the creeps become stronger or weaker.
		 * This method does also print a hint about the handicap.
		 */
		public static method applyHandicapToCreeps takes nothing returns real
			local integer missingPlayers = Game.missingPlayers()
			local real handicap = 1.0 - missingPlayers * 0.10

			if (GetGameDifficulty() == MAP_DIFFICULTY_EASY) then
				set handicap = handicap - 0.05
			elseif (GetGameDifficulty() == MAP_DIFFICULTY_HARD) then
				set handicap = handicap + 0.10
			elseif (GetGameDifficulty() == MAP_DIFFICULTY_INSANE) then
				set handicap = handicap + 0.30
			endif

			// decrease difficulty for others if players are missing
			call SetPlayerHandicap(Player(PLAYER_NEUTRAL_AGGRESSIVE), handicap)

			if (not Game.restoreCharacters()) then
				if (missingPlayers > 0) then
					call Character.displayDifficultyToAll(Format(tre("Da Sie das Spiel ohne %1% Spieler beginnen, erhalten die Gegner ein Handicap von %2% %. Zudem erhält Ihr Charakter sowohl mehr Erfahrungspunkte als auch mehr Goldmünzen beim Töten von Gegnern.", "Since you are starting the game without %1% players the enemies get a handicap of %2% %. Besides your character gains more experience as well as more gold coins from killing enemies.")).s(trpe("einen weiteren", Format("%1% weitere").i(missingPlayers).result(), "one more", Format("%1% more").i(missingPlayers).result(), missingPlayers)).rw(handicap * 100.0, 0, 0).result())
				elseif (handicap > 1.0 or handicap < 1.0) then
					call Character.displayDifficultyToAll(Format(tre("Aufgrund der eingestellten Schwierigkeit starten die Unholde mit einem Handicap von %1%.", "Because of the set difficulty the creeps start with a handicap of %1%.")).rw(handicap * 100.0, 0, 0).result())
				endif
			endif

			return handicap
		endmethod

		/**
		 * Registers a global \p onDamageAction which is evaluated everytime a unit gets damage.
		 * \note The more actions you register the slower fighting might become.
		 */
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
			loop
				exitwhen (not iterator.isValid())
				call ADamageRecorderOnDamageAction(iterator.data()).evaluate(damageRecorder)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		/**
		 * The violence system enables blood effects on killing units.
		 * \ref randomBigBloodEffectPath() is used when the killed unit takes a lot of damage at once.
		 * The damage handler \ref onDamageActionViolence() creates blood effects.
		 */
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

		private static method triggerActionKill takes nothing returns nothing
			/*
			 * Characters get only experience if a creep is being killed.
			 */
			if (MapSettings.playerGivesXP(GetOwningPlayer(GetTriggerUnit())) and GameExperience.unitTypeIdGivesXp(GetUnitTypeId(GetTriggerUnit()))) then
				call GameExperience.distributeUnitExperience(GetTriggerUnit(), GetKillingUnit())
				call GameBounty.distributeUnitBounty(GetTriggerUnit(), GetKillingUnit())
			endif

			// violence
			if (not IsUnitType(GetTriggerUnit(), UNIT_TYPE_MECHANICAL) and not IsUnitType(GetTriggerUnit(), UNIT_TYPE_UNDEAD)) then
				call DestroyEffect(AddSpecialEffectTarget(thistype.randomDeathBloodEffectPath(), GetTriggerUnit(), "origin"))
			endif
			/// \todo Sound

		endmethod

		/// @todo What's about AOS players?
		private static method createKillTrigger takes nothing returns nothing
			set thistype.m_killTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_killTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddAction(thistype.m_killTrigger, function thistype.triggerActionKill)
		endmethod

		/// Most ASL systems are initialized here.
		private static method onInit takes nothing returns nothing
			local integer i = 0

			call Zone.initZones.evaluate() // before map settings
			/*
			 * Initialize the MapSettings properties here.
			 */
			call MapSettings.initDefaults()
			call MapData.initSettings.evaluate()

			if (MapSettings.neutralPassivePlayer() != null) then
				// player should look like neutral passive
				call SetPlayerColor(MapSettings.neutralPassivePlayer(), ConvertPlayerColor(PLAYER_NEUTRAL_PASSIVE))
			endif

			// restore the characters in a single player campaign of the game is changed by loading or if it is not the initial chapter
			set thistype.m_restoreCharacters = bj_isSinglePlayer and Game.isCampaign() and MapChanger.charactersExistSinglePlayer() and (IsMapFlagSet(MAP_RELOADED) or not MapSettings.isSeparateChapter())

			// Advanced Script Library
			// general systems
			call Asl.init()
			// debugging systems
static if (DEBUG_MODE) then
			call AInitUtilityCheats()
endif
			// environment systems
			call ADamageRecorder.init(true, thistype.onDamageAction, false)
			call AMissile.init(0.05)
			call ADynamicLightning.init(0.50)
			// NOTE AJump is only required for a jump done by Wigberht in the video "Wigberht".
			call AJump.init(0.05)
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
			// character systems
			// In the Bonus Campaign the ping rate for quests is 25.0 seconds.
			call AAbstractQuest.init(25.0, "Sound\\Interface\\QuestNew.wav", "Sound\\Interface\\QuestCompleted.wav", "Sound\\Interface\\QuestFailed.wav", tre("%s", "%s"), tre("|cffc3dbff%s (Abgeschlossen)|r", "|cffc3dbff%s (Completed)|r"), tre("%s (|c00ff0000Fehlgeschlagen|r)", "%s (|c00ff0000Failed|r)"), tre("+%i Stufe(n)", "+%i level(s)"), tre("+%i Fähigkeitenpunkt(e)", "+%i skill point(s)"), tre("+%i Erfahrung", "+%i experience"), tre("+%i Stärke", "+%i strength"), tre("+%i Geschick", "+%i dexterity"), tre("+%i Wissen", "+%i lore"), tre("+%i Goldmünze(n)", "+%i gold coin(s)"), tre("+%i Holz", "+%i lumber"))
			call ACharacter.init(true, true, true, false, false, true, true, true)
			call initSpeechSkip(AKeyEscape, 0.01)
			call AUnitInventory.init('I001', 'I000', 'A015', false, tre("Ausrüstungsfach wird bereits von einem anderen Gegenstand belegt.", "Equipment slot is already used by another item."), tre("%1% angelegt.", "Equipped %1%"), tre("Rucksack ist voll.", "Backpack is full."), tre("%1% im Rucksack verstaut.", "%1% put into the bag."), tre("Gegenstand konnte nicht verschoben werden.", "Item cannot be moved."), tre("Die Seitengegenstände können nicht abgelegt werden.", "The page items cannot be dropped."), tre("Die Seitengegenstände können nicht verschoben werden.", "The page items cannot be moved."), tre("Der Gegendstand gehört einem anderen Spieler.", "This item belongs to another player."), tre("Vorherige Seite ist bereits voll.", "Previous page is already full."), tre("Nächste Seite ist bereits voll.", "Next page is already full."))
			call AItemType.init(tre("Gegenstand benötigt eine höhere Stufe.", "Item requires a higher level."), tre("Gegenstand benötigt mehr Stärke.", "Item requires more strength."), tre("Gegenstand benötigt mehr Geschick.", "Items requires more dexterity."), tre("Gegenstand benötigt mehr Wissen.", "Item requires more lore."))
			call ACharacterItemType.initCharacterItemType(tre("Gegenstand benötigt eine andere Charakterklasse.", "Item requires another character class."))
			call AQuest.init0(true, true, "Sound\\Interface\\QuestLog.wav", tre("|c00ffcc00NEUER AUFTRAG|r", "|c00ffcc00NEW QUEST|r"), tre("|c00ffcc00AUFTRAG ABGESCHLOSSEN|r", "|c00ffcc00QUEST COMPLETED|r"), tre("|c00ffcc00AUFTRAG FEHLGESCHLAGEN|r", "|c00ffcc00QUEST FAILED|r"), tre("|c00ffcc00AUFTRAGS-AKTUALISIERUNG|r", "|c00ffcc00QUEST UPDATE|r"), tre("- %s", "- %s"))
			call AVideo.init(tre("Spieler %s möchte das Video überspringen.", "Player %s wants to skip the video."), tre("Video wird übersprungen.", "Video has been skipped."))
			// world systems
			call ASpawnPoint.init()
			// The Power of Fire
			// game
			set thistype.m_onDamageActions = AIntegerList.create()
			call thistype.registerOnDamageActionOnce(thistype.onDamageActionViolence) // blood/violence system
			call thistype.createKillTrigger()
			// game guis
			call Fellow.init.evaluate(tre("%1% hat sich Ihrer Gruppe angeschlossen.", "%1% has joined your group."), null, tre("%1% hat Ihre Gruppe verlassen.", "%1% has left your group"), null, tre("%1% ist gefallen und wird in %2% Sekunden wiederbelebt.", "%1% has fallen and will be revived in %2% seconds."), null)
static if (DMDF_INVENTORY) then
			call Inventory.init0.evaluate()
endif

			call Dungeon.init.evaluate() // before map data init
			// game types
			call Classes.init()
			call ItemTypes.init() // after classes!
			call Routines.init()
			call initSpells.evaluate() // after classes!
			call Shop.init.evaluate() // before map data initialization!
			call QuestArea.init.evaluate() // before map data initialization!
			// map
			call MapData.init.evaluate()

			// the map music has to be set in the initialization
			if (MapSettings.mapMusic() != null) then
				call ClearMapMusic()
				call SetMapMusic(MapSettings.mapMusic(), true, 0)
			debug else
				debug call Print("Error: Map music is empty.")
			endif

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
				// one additional for MapSettings.alliedPlayer()
				exitwhen (i == MapSettings.maxPlayers())
				// set allied player and neutral passive player alliance status
				call SetPlayerAllianceStateBJ(Player(i), MapSettings.alliedPlayer(), bj_ALLIANCE_NEUTRAL)
				call SetPlayerAllianceStateBJ(MapSettings.alliedPlayer(), Player(i), bj_ALLIANCE_NEUTRAL)
				// they have to be allied and not neutral. Otherwise shared shop won't work.
				call SetPlayerAllianceStateBJ(Player(i), Player(PLAYER_NEUTRAL_PASSIVE), bj_ALLIANCE_ALLIED)
				call SetPlayerAllianceStateBJ(Player(PLAYER_NEUTRAL_PASSIVE), Player(i), bj_ALLIANCE_ALLIED)
				call SetPlayerAllianceStateBJ(Player(i), MapSettings.neutralPassivePlayer(), bj_ALLIANCE_ALLIED)
				call SetPlayerAllianceStateBJ(MapSettings.neutralPassivePlayer(), Player(i), bj_ALLIANCE_ALLIED)
				set i = i + 1
			endloop

			call SetPlayerAllianceStateBJ(Player(PLAYER_NEUTRAL_AGGRESSIVE), MapSettings.neutralPassivePlayer(), bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(MapSettings.neutralPassivePlayer(), Player(PLAYER_NEUTRAL_AGGRESSIVE), bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(MapSettings.alliedPlayer(), MapSettings.neutralPassivePlayer(), bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(MapSettings.neutralPassivePlayer(), MapSettings.alliedPlayer(), bj_ALLIANCE_NEUTRAL)

			set i = 0
			loop
				// one additional group for the allied player
				exitwhen (i == MapSettings.maxPlayers() + 1)
				set thistype.m_hiddenUnits[i] = AGroup.create()
				set i = i + 1
			endloop

			 // dont run in map initialization already, leads to not starting the map at all (probably because of unallowed function calls or waits)
			call TriggerSleepAction(0.0) // class selection multiboard is shown and characters scheme multiboard is created.
			call MapData.onStart.evaluate()

			// if the game is new show the class selection, otherwise restore characters from the game cache (only in campaign mode)
			if (thistype.restoreCharacters()) then
				// new OpLimit
				call NewOpLimit(function MapChanger.restoreCharactersSinglePlayer)
				// Make sure the flag is set to true that every repick is detected successfully.
				call ClassSelection.startGame.evaluate()
			// Otherwise start the game from beginning by letting players select their class.
			else
				set i = 0
				loop
					exitwhen (i == MapSettings.maxPlayers())
					call DisplayTextToPlayer(Player(i), 0.0, 0.0, Format(tre("Sprache: %1%", "Language: %1%")).s(GetLanguage()).result())
					set i = i + 1
				endloop
				// class selection
				call ClassSelection.showClassSelection.execute() // multiboard is created, uses TriggerSleepAction()
			endif
		endmethod

		/**
		 * Creates the global scheme for a character overview which can be shown to every player.
		 */
		private static method initCharactersScheme takes nothing returns nothing
			local integer i = 0
			local integer maxMiddleIcons = 19
			set thistype.m_charactersScheme = ACharactersScheme.create(DMDF_CHARACTERS_SCHEMA_REFRESH_RATE, true, true, true, 20, GameExperience.currentExperieneFormula, GameExperience.maxExperienceFormula, 20, 20, true, tre("Charaktere", "Characters"), tre("Stufe", "Level"), tre("Hat das Spiel verlassen.", "Has left the game."), "ReplaceableTextures\\CommandButtons\\BTNChestOfGold.blp")
			call thistype.m_charactersScheme.setBarWidths(0.003)
			call thistype.m_charactersScheme.setExperienceBarValueIcon(0, "Icons\\Interface\\Bars\\Experience\\ExperienceL8.tga")
			call thistype.m_charactersScheme.setExperienceBarEmptyIcon(0, "Icons\\Interface\\Bars\\Experience\\ExperienceL0.tga")
			set i = 1
			loop
				exitwhen (i == maxMiddleIcons)
				call thistype.m_charactersScheme.setExperienceBarValueIcon(i, "Icons\\Interface\\Bars\\Experience\\ExperienceM8.tga")
				call thistype.m_charactersScheme.setExperienceBarEmptyIcon(i, "Icons\\Interface\\Bars\\Experience\\ExperienceM0.tga")
				set i = i + 1
			endloop
			call thistype.m_charactersScheme.setExperienceBarValueIcon(maxMiddleIcons, "Icons\\Interface\\Bars\\Experience\\ExperienceR8.tga")
			call thistype.m_charactersScheme.setExperienceBarEmptyIcon(maxMiddleIcons, "Icons\\Interface\\Bars\\Experience\\ExperienceR0.tga")

			call thistype.m_charactersScheme.setHitPointsBarValueIcon(0, "Icons\\Interface\\Bars\\Chunk\\ChunkL2.tga")
			call thistype.m_charactersScheme.setHitPointsBarEmptyIcon(0, "Icons\\Interface\\Bars\\Chunk\\ChunkL0.tga")
			set i = 1
			loop
				exitwhen (i == maxMiddleIcons)
				call thistype.m_charactersScheme.setHitPointsBarValueIcon(i, "Icons\\Interface\\Bars\\Chunk\\ChunkM2.tga")
				call thistype.m_charactersScheme.setHitPointsBarEmptyIcon(i, "Icons\\Interface\\Bars\\Chunk\\ChunkM0.tga")
				set i = i + 1
			endloop
			call thistype.m_charactersScheme.setHitPointsBarValueIcon(maxMiddleIcons, "Icons\\Interface\\Bars\\Chunk\\ChunkR2.tga")
			call thistype.m_charactersScheme.setHitPointsBarEmptyIcon(maxMiddleIcons, "Icons\\Interface\\Bars\\Chunk\\ChunkR0.tga")

			call thistype.m_charactersScheme.setManaBarValueIcon(0, "Icons\\Interface\\Bars\\Mana\\ManaL8.tga")
			call thistype.m_charactersScheme.setManaBarEmptyIcon(0, "Icons\\Interface\\Bars\\Mana\\ManaL0.tga")
			set i = 1
			loop
				exitwhen (i == maxMiddleIcons)
				call thistype.m_charactersScheme.setManaBarValueIcon(i, "Icons\\Interface\\Bars\\Mana\\ManaM8.tga")
				call thistype.m_charactersScheme.setManaBarEmptyIcon(i, "Icons\\Interface\\Bars\\Mana\\ManaM0.tga")
				set i = i + 1
			endloop
			call thistype.m_charactersScheme.setManaBarValueIcon(maxMiddleIcons, "Icons\\Interface\\Bars\\Mana\\ManaR8.tga")
			call thistype.m_charactersScheme.setManaBarEmptyIcon(maxMiddleIcons, "Icons\\Interface\\Bars\\Mana\\ManaR0.tga")
			// initial refresh to fix widths
			call thistype.m_charactersScheme.refresh()
		endmethod

		/**
		 * Resets the camera bounds for all human character controlling players to their current dungeon in which their character is at the moment.
		 */
		public static method resetCameraBounds takes nothing returns nothing
			local player user
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set user = Player(i)
				if (IsPlayerPlayingUser(user)) then
					call Dungeon.resetCameraBoundsForPlayer.evaluate(user)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		/**
		 * This method usually is called after all players selected their character class.
		 */
		public static method start takes nothing returns nothing
			local integer i = 0

			// use new OpLimit
			call NewOpLimit(function thistype.initCharactersScheme)

			// create after character creation (character should be F1)
			// disable RPG view
			call Character.setViewForAll(false)
			// enable tutorial by default for beginners
			call Character.setTutorialForAll(true)

			// all but one missing, disable characters schema since it is not required
			if (thistype.missingPlayers() == MapSettings.maxPlayers() - 1) then
				set i = 0
				loop
					exitwhen (i == MapSettings.maxPlayers())
					if (ACharacter.playerCharacter(Player(i)) != 0) then
						call Character(ACharacter.playerCharacter(Player(i))).setShowCharactersScheme(false)
					endif
					set i = i + 1
				endloop
			endif

			// enable camera timer after starting the game
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call Character(ACharacter.playerCharacter(Player(i))).setCameraTimer(true)
				endif
				set i = i + 1
			endloop

			// shows only if enabled, otherwise hide
			call Character.showCharactersSchemeToAll()

			// we're using a customized experience system
			call ACharacter.suspendExperienceForAll(true)

			// apply initial camera bounds
			call thistype.resetCameraBounds()
			call CameraHeight.start()

			// debug mode allows you to use various cheats
static if (DEBUG_MODE) then
			call GameCheats.init.evaluate()
endif
			/// has to be called by struct \ref MapData.
			//call ACharacter.setAllMovable(true)
			call MapData.start.execute()
		endmethod

		/// We've got one allied player for shared control with NPCs. Use this method to enable alliance.
		public static method setAlliedPlayerAlliedToPlayer takes player whichPlayer returns nothing
			call SetPlayerAllianceStateBJ(whichPlayer, MapSettings.alliedPlayer(), bj_ALLIANCE_ALLIED_ADVUNITS)
			call SetPlayerAllianceStateBJ(MapSettings.alliedPlayer(), whichPlayer, bj_ALLIANCE_ALLIED_ADVUNITS)
			// works!
			if (Character(Character.playerCharacter(whichPlayer)).showCharactersScheme()) then
				call thistype.charactersScheme().showForPlayer(whichPlayer) // hide team resources
			else
				call MultiboardSuppressDisplayForPlayer(whichPlayer, true) // hide team resources
			endif
		endmethod

		/// The allied player can also be used for arena fights (one or several characters against NPCs without other characters)
		public static method setAlliedPlayerUnalliedToPlayer takes player whichPlayer returns nothing
			call SetPlayerAllianceStateBJ(whichPlayer, MapSettings.alliedPlayer(), bj_ALLIANCE_UNALLIED)
			call SetPlayerAllianceStateBJ(MapSettings.alliedPlayer(), whichPlayer, bj_ALLIANCE_UNALLIED)
		endmethod

		public static method setAlliedPlayerAlliedToCharacter takes Character character returns nothing
			call thistype.setAlliedPlayerAlliedToPlayer(character.player())
		endmethod

		public static method setAlliedPlayerAlliedToAllCharacters takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (Character.playerCharacter(Player(i)) != 0) then
					call thistype.setAlliedPlayerAlliedToPlayer(Player(i))
				endif
				set i = i + 1
			endloop
		endmethod

		private static method filterShownItem takes nothing returns boolean
			return not IsItemVisible(GetFilterItem())
		endmethod

		private static method hideItem takes nothing returns nothing
			call SetItemVisible(GetEnumItem(), false)
			call DmdfHashTable.global().setHandleBoolean(GetEnumItem(), DMDF_HASHTABLE_KEY_HIDDEN, true)
		endmethod

		private static method filterShownUnit takes nothing returns boolean
			return not IsUnitHidden(GetFilterUnit()) and not AVideo.unitIsActor(GetFilterUnit())
		endmethod

		private static method hideUnit takes unit whichUnit returns nothing
			call ShowUnit(whichUnit, false)
			call UnitRemoveBuffsBJ(bj_REMOVEBUFFS_NONTLIFE, whichUnit)
		endmethod

		public static method fadeOut takes nothing returns nothing
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
		endmethod

		public static method fadeOutWithWait takes nothing returns nothing
			call thistype.fadeOut()
			if (wait(1.50)) then
				return
			endif
		endmethod

		public static method fadeIn takes nothing returns nothing
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
		endmethod

		public static method fadeInWithWait takes nothing returns nothing
			call thistype.fadeIn()
			if (wait(1.50)) then
				return
			endif
		endmethod

		/**
		 * This function has to be called by all \ref Video instances on a videos initialization.
		 *
		 * Cinematic stuff (from Bonus Campaign)
		 * - Disables gold and experience by kills.
		 * - Setups music volume.
		 * - Hides all items.
		 * - Hides all character owner units except actors.
		 * - Removes specific buffs.
		 * - Disables all sell abilities for all players to prevent arrows in videos.
		 * - Revive all fellows immediately.
		 * - Disable transparency.
		 * - Disable automatic camera height.
		 * - Replace attack orders of the character's actor.
		 *
		 * \sa resetVideoSettings()
		 */
		public static method initVideoSettings takes AVideo video returns nothing
			local Character character = 0
			local integer i = 0
			// make sure camera is reset before waiting for other camera resets, this resets at least any pans etc.
			call ResetToGameCamera(0.0)

			// Disable all abilities which might be annoying it a video
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYER_SLOTS)
				call SetPlayerAbilityAvailable(Player(i), 'Aneu', false)
				call SetPlayerAbilityAvailable(Player(i), 'Ane2', false)
				call SetPlayerAbilityAvailable(Player(i), 'Asid', false)
				call SetPlayerAbilityAvailable(Player(i), 'Apit', false)

				// marker abilities
				call SetPlayerAbilityAvailable(Player(i), 'A0HG', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DK', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DN', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DG', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DM', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DH', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DF', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DJ', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DI', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1DL', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1J1', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1J2', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1UP', false)
				call SetPlayerAbilityAvailable(Player(i), 'A1RM', false)

				// hide abilities
				call SetPlayerAbilityAvailable(Player(i), 'S003', false)
				set character = Character(ACharacter.playerCharacter(Player(i)))

				if (character != 0) then
					call character.grimoire().disableLevelTrigger()

					if (character.credits() != 0 and  character.credits().isShown()) then
						call character.credits().hide()
					endif

					call character.setCameraTimer(false)
				endif
				set i = i + 1
			endloop

			call NewOpLimit(function QuestArea.hideAll)
			call NewOpLimit(function Fellow.reviveAllForVideo)
			call NewOpLimit(function SpawnPoint.pauseAll)
			call NewOpLimit(function ItemSpawnPoint.pauseAll)
			call NewOpLimit(function Routines.destroyTextTags)
			call NewOpLimit(function Routines.stopSounds)
			call DisableTrigger(thistype.m_killTrigger)
			call EnumItemsInRect(GetPlayableMapRect(), Filter(function thistype.filterShownItem), function thistype.hideItem)
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (Character.playerCharacter(Player(i)) != 0) then
					call AGroup(thistype.m_hiddenUnits[i]).addUnitsOfPlayer(Player(i), Filter(function thistype.filterShownUnit))
					call AGroup(thistype.m_hiddenUnits[i]).forGroup(thistype.hideUnit)
				endif
				set i = i + 1
			endloop
			// Allied fellows should be hidden too.
			call AGroup(thistype.m_hiddenUnits[MapSettings.maxPlayers()]).addUnitsOfPlayer(MapSettings.alliedPlayer(), Filter(function thistype.filterShownUnit))
			call AGroup(thistype.m_hiddenUnits[MapSettings.maxPlayers()]).forGroup(thistype.hideUnit)

			call DisableTransparency()
			// has trigger sleep action
			call CameraHeight.pause()

			// make sure camera is reset after resetting camera height and camera timer of characters
			call StopCamera()
			call ResetToGameCamera(0.0)

			/*
			 * The attack order animations of the Villager255 have to be handled for the actor as well.
			 * Otherwise the wrong animations will be shown in a fight.
			 */
			if (video.actor() != null) then
				set thistype.m_actorOrderAnimations = OrderAnimations.create(Character(ACharacter.getFirstCharacter()), video.actor())
			endif
			call StopMusic(false)
			call MapData.onInitVideoSettings.evaluate()
		endmethod

		private static method filterHiddenItem takes nothing returns boolean
			return DmdfHashTable.global().handleBoolean(GetFilterItem(), DMDF_HASHTABLE_KEY_HIDDEN)
		endmethod

		private static method showItem takes nothing returns nothing
			call SetItemVisible(GetEnumItem(), true)
			call DmdfHashTable.global().removeHandleBoolean(GetEnumItem(), DMDF_HASHTABLE_KEY_HIDDEN)
		endmethod

		private static method showUnit takes unit whichUnit returns nothing
			call ShowUnit(whichUnit, true)
		endmethod

		public static method resetVideoSettings takes nothing returns nothing
			local Character character = 0
			local integer i = 0
			// Enable all abilities which might be annoying it a video
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYER_SLOTS)
				call SetPlayerAbilityAvailable(Player(i), 'Aneu', true)
				call SetPlayerAbilityAvailable(Player(i), 'Ane2', true)
				call SetPlayerAbilityAvailable(Player(i), 'Asid', true)
				call SetPlayerAbilityAvailable(Player(i), 'Apit', true)

				// marker abilities
				call SetPlayerAbilityAvailable(Player(i), 'A0HG', true)
				call SetPlayerAbilityAvailable(Player(i), 'A1DK', true)
				call SetPlayerAbilityAvailable(Player(i), 'A1DN', true)
				call SetPlayerAbilityAvailable(Player(i), 'A1DG', true)
				call SetPlayerAbilityAvailable(Player(i), 'A1DM', true)
				call SetPlayerAbilityAvailable(Player(i), 'A1DH', true)
				call SetPlayerAbilityAvailable(Player(i), 'A1DF', true)
				call SetPlayerAbilityAvailable(Player(i), 'A1DJ', true)
				call SetPlayerAbilityAvailable(Player(i), 'A1DI', true)
				call SetPlayerAbilityAvailable(Player(i), 'A1DL', true)
				call SetPlayerAbilityAvailable(Player(i), 'A1J1', true)
				call SetPlayerAbilityAvailable(Player(i), 'A1J2', true)
				call SetPlayerAbilityAvailable(Player(i), 'A1UP', true)
				call SetPlayerAbilityAvailable(Player(i), 'A1RM', true)

				// hide abilities
				call SetPlayerAbilityAvailable(Player(i), 'S003', true)
				set character = Character(ACharacter.playerCharacter(Player(i)))

				if (character != 0) then
					call character.grimoire().enableLevelTrigger()
					call character.panCameraSmart()
					call character.setCameraTimer(true)
				endif

				set i = i + 1
			endloop
			call thistype.resetCameraBounds()
			call EnableTrigger(thistype.m_killTrigger)

			call NewOpLimit(function QuestArea.showAll)
			call NewOpLimit(function SpawnPoint.resumeAll)
			call NewOpLimit(function ItemSpawnPoint.resumeAll)
			call EnumItemsInRect(GetPlayableMapRect(), Filter(function thistype.filterHiddenItem), function thistype.showItem)
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (Character.playerCharacter(Player(i)) != 0) then
					call AGroup(thistype.m_hiddenUnits[i]).forGroup(thistype.showUnit)
					call AGroup(thistype.m_hiddenUnits[i]).units().clear()
				endif
				set i = i + 1
			endloop
			// Show units of allied player, too.
			call AGroup(thistype.m_hiddenUnits[MapSettings.maxPlayers()]).forGroup(thistype.showUnit)
			call AGroup(thistype.m_hiddenUnits[MapSettings.maxPlayers()]).units().clear()

			call EnableTransparency()
			call CameraHeight.resume()
			if (thistype.m_actorOrderAnimations != 0) then
				call thistype.m_actorOrderAnimations.destroy()
				set thistype.m_actorOrderAnimations = 0
			endif
			call EndThematicMusic()
			call VolumeGroupResetBJ()
			call ResumeMusic()
			call MapData.onResetVideoSettings.evaluate()
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