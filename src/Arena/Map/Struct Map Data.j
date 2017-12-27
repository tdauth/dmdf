library StructMapMapMapData requires Asl, Game

	struct MapData
		public static constant integer maxScore = 25
		private static trigger m_safeEnterTrigger
		private static trigger m_safeLeaveTrigger
		private static Shrine m_shrine
		private static leaderboard m_leaderboard
		private static trigger m_deathTrigger
		private static integer array m_score[12]

		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// Required by \ref Game.
		public static method initSettings takes nothing returns nothing
			call MapSettings.setMapName("AR")
			call MapSettings.setMapMusic("Sound\\Music\\mp3Music\\PippinTheHunchback.mp3")
			call MapSettings.setMaxPlayers(12)
			call MapSettings.setAlliedPlayer(null)
			call MapSettings.setNeutralPassivePlayer(Player(PLAYER_NEUTRAL_PASSIVE))
			call MapSettings.setRevivalTime(5.0)
			call MapSettings.setStartLevel(30)
			call MapSettings.setStartSkillPoints(5)
			call MapSettings.setLevelSkillPoints(2)
			call MapSettings.setMaxLevel(30)
			call MapSettings.setIsSeparateChapter(true)
			call MapSettings.setPlayerGivesXP(Player(PLAYER_NEUTRAL_AGGRESSIVE), false)
		endmethod

		/// Required by \ref Game.
		public static method init takes nothing returns nothing
			local quest whichQuest = null
			local questitem questItem = null
			local NpcTalksRoutine talkRoutine = 0

			// info
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Regeln", "Rules"))
			call QuestSetDescription(whichQuest, tre("Zu seiner Belustigung hat Heimrich, der Herzog von Talras, euch gemeinsam in eine Arena werfen lassen, aus welcher der Sieg die einzige Möglichkeit zu entkommen ist.", "For his amusement Heimrich, the duke of Talras, has thrown you into an arena from which the victory is the only possibility to escape."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNCorpseExplode.blp")
			call QuestSetEnabled(whichQuest, true)
			call QuestSetRequired(whichQuest, false) // don't show in infos
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, Format(tre("Tötet einander bis einer der Spieler %1% Punkte erreicht hat.", "Kill each other until one player has reached %1% kills.")).i(thistype.maxScore).result())

			// player should look like neutral passive
			call SetPlayerColor(MapSettings.neutralPassivePlayer(), ConvertPlayerColor(PLAYER_NEUTRAL_PASSIVE))

			set talkRoutine = NpcTalksRoutine.create(Routines.talk(), gg_unit_n013_0012, 0.0, 24.00, gg_rct_waypoint_heimrich_0)
			call talkRoutine.setPartner(gg_unit_n014_0038)
			call talkRoutine.addSound(tre("Was erlaubt sich das einfache Volk?", "Who does the common people think it is?"), gg_snd_Heimrich12)
			call talkRoutine.addSound(tre("Wir müssen uns auf den Krieg vorbereiten.", "We have to prepare ourselves for the war."), gg_snd_Heimrich13)
			call talkRoutine.addSound(tre("Hat Er sich um alles Nötige gekümmert?", "Did he take care of everything necessary?"), gg_snd_Heimrich14)
			call talkRoutine.addSound(tre("Bald werden sie hier einfallen und dann?", "Soon they will come here and then?"), gg_snd_Heimrich15)

			set talkRoutine = NpcTalksRoutine.create(Routines.talk(), gg_unit_n014_0038, 0.0, 24.00, gg_rct_waypoint_markward_0)
			call talkRoutine.setPartner(gg_unit_n013_0012)

			call Game.addDefaultDoodadsOcclusion()
		endmethod

		/// Required by \ref ClassSelection.
		public static method onCreateClassSelectionItems takes AClass class, unit whichUnit returns nothing
			call Classes.createDefaultClassSelectionItems(class, whichUnit)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onCreateClassItems takes Character character returns nothing
			call Classes.createDefaultClassItems(character)
		endmethod

		private static method filterSummoned takes nothing returns boolean
			return IsUnitType(GetFilterUnit(), UNIT_TYPE_SUMMONED)
		endmethod

		private static method triggerConditionEnterSafe takes nothing returns boolean
			local integer i = 0
			local AGroup summonedUnits = 0
			if (ACharacter.isUnitCharacter(GetTriggerUnit())) then
				set i = 0
				loop
					exitwhen (i == MapSettings.maxPlayers())
					if (GetPlayerId(GetOwningPlayer(GetTriggerUnit())) != i) then
						call SetPlayerAllianceStateBJ(Player(i), GetOwningPlayer(GetTriggerUnit()), bj_ALLIANCE_NEUTRAL)
						call SetPlayerAllianceStateBJ(GetOwningPlayer(GetTriggerUnit()), Player(i), bj_ALLIANCE_NEUTRAL)
					endif
					set i = i + 1
				endloop
				call SetUnitInvulnerable(GetTriggerUnit(), true)

				set summonedUnits = AGroup.create()
				call summonedUnits.addUnitsInRect(gg_rct_area_playable, Filter(function thistype.filterSummoned))
				set i = 0
				loop
					exitwhen (i == summonedUnits.units().size())
					if (GetOwningPlayer(summonedUnits.units()[i]) == GetOwningPlayer(GetTriggerUnit())) then
						call KillUnit(summonedUnits.units()[i])
					endif
					set i = i + 1
				endloop
				call summonedUnits.destroy()
				set summonedUnits = 0
			endif


			return false
		endmethod

		private static method triggerConditionLeaveSafe takes nothing returns boolean
			local integer i = 0
			if (ACharacter.isUnitCharacter(GetTriggerUnit())) then
				set i = 0
				loop
					exitwhen (i == MapSettings.maxPlayers())
					if (GetPlayerId(GetOwningPlayer(GetTriggerUnit())) != i and not RectContainsUnit(gg_rct_area_safe, ACharacter.playerCharacter(Player(i)).unit())) then
						call SetPlayerAllianceStateBJ(Player(i), GetOwningPlayer(GetTriggerUnit()), bj_ALLIANCE_UNALLIED)
						call SetPlayerAllianceStateBJ(GetOwningPlayer(GetTriggerUnit()), Player(i), bj_ALLIANCE_UNALLIED)
					endif
					set i = i + 1
				endloop
				call SetUnitInvulnerable(GetTriggerUnit(), false)
			endif

			return false
		endmethod

		private static method randomWord takes nothing returns string
			local integer random = GetRandomInt(0, 3)
			if (random == 0) then
				return tre("zermalmt", "crushed")
			elseif (random == 1) then
				return tre("geplättet", "nuked")
			elseif (random == 2) then
				return tre("abgeschlachtet", "slaughtered")
			endif

			return tre("gezeigt wo der Hammer hängt", "shown who the boss is")
		endmethod

		private static method victory takes player whichPlayer returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (i != GetPlayerId(whichPlayer)) then
					call MeleeDefeatDialogBJ(Player(i), false)
				endif
				set i = i + 1
			endloop
			call MeleeVictoryDialogBJ(whichPlayer, false)
		endmethod

		private static method triggerConditionDeath takes nothing returns boolean
			local integer killerPlayerId
			if (GetKillingUnit() != null and ACharacter.isUnitCharacter(GetTriggerUnit()) and GetOwningPlayer(GetKillingUnit()) != GetOwningPlayer(GetTriggerUnit())) then
				call DisplayTextToForce(bj_FORCE_ALL_PLAYERS, Format(tre("%1% hat %2% %3%.", "%1% has %2% %3%.")).s(GetPlayerName(GetOwningPlayer(GetKillingUnit()))).s(GetPlayerName(GetOwningPlayer(GetTriggerUnit()))).s(thistype.randomWord()).result())

				set killerPlayerId = GetPlayerId(GetOwningPlayer(GetKillingUnit()))
				set thistype.m_score[killerPlayerId] = thistype.m_score[killerPlayerId] + 1
				call LeaderboardSetPlayerItemValueBJ(GetOwningPlayer(GetKillingUnit()), thistype.m_leaderboard, thistype.m_score[killerPlayerId])
				call LeaderboardSortItemsByValue(thistype.m_leaderboard, false)

				if (thistype.m_score[killerPlayerId] == thistype.maxScore) then
					call thistype.victory(GetOwningPlayer(GetKillingUnit()))
				endif
			endif

			return false
		endmethod

		/// Required by \ref Game.
		public static method onInitMapSpells takes ACharacter character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method onStart takes nothing returns nothing
			call SetTimeOfDay(12.0)
			call SuspendTimeOfDay(true)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onSelectClass takes Character character, AClass class, boolean last returns nothing
			call SetUnitX(character.unit(), GetRectCenterX(gg_rct_area_safe))
			call SetUnitY(character.unit(), GetRectCenterY(gg_rct_area_safe))
			call SetUnitFacing(character.unit(), 0.0)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onRepick takes Character character returns nothing
			debug call Print("Auto skill for player " + GetPlayerName(character.player()))
			// evaluate because of OpLimit
			call thistype.autoSkill.evaluate(character.player())
		endmethod

		/// Required by \ref Game.
		public static method start takes nothing returns nothing
			local integer i

			call SetMapFlag(MAP_FOG_HIDE_TERRAIN, false)
			call SetMapFlag(MAP_FOG_ALWAYS_VISIBLE, true)
			call SetMapFlag(MAP_FOG_MAP_EXPLORED, true)
			call FogMaskEnableOff()
			call FogEnableOff()

			set thistype.m_safeEnterTrigger = CreateTrigger()
			call TriggerRegisterEnterRectSimple(thistype.m_safeEnterTrigger, gg_rct_area_safe)
			call TriggerAddCondition(thistype.m_safeEnterTrigger, Condition(function thistype.triggerConditionEnterSafe))

			set thistype.m_safeLeaveTrigger = CreateTrigger()
			call TriggerRegisterLeaveRectSimple(thistype.m_safeLeaveTrigger, gg_rct_area_safe)
			call TriggerAddCondition(thistype.m_safeLeaveTrigger, Condition(function thistype.triggerConditionLeaveSafe))

			set thistype.m_shrine = Shrine.create(gg_unit_n02D_0000, gg_dest_B008_0000, gg_rct_shrine_discover, gg_rct_shrine_revival, 312.69)

			set thistype.m_leaderboard = CreateLeaderboardBJ(bj_FORCE_ALL_PLAYERS, tre("Punkte:", "Kills:"))

			set thistype.m_deathTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_deathTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(thistype.m_deathTrigger, Condition(function thistype.triggerConditionDeath))

			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				call thistype.setupCharacter.evaluate(Player(i))
				set i = i + 1
			endloop

			call Character.showCharactersSchemeToAll()

			call DisplayTextToForce(bj_FORCE_ALL_PLAYERS, Format(tre("Schlachtet euch gegenseitig für Ruhm und Ehre in der Arena ab. Gewonnen hat derjenige, der zuerst %1% Gegner niedergestreckt hat.", "Slaughter each other in the arena for glory and honour. The one who slaughtered %1% enemies first has won.")).i(thistype.maxScore).result())
		endmethod

		private static method setupCharacter takes player whichPlayer returns nothing
			local integer j
			if (ACharacter.playerCharacter(whichPlayer) != 0) then
				set j = 0
				loop
					exitwhen (j == MapSettings.maxPlayers())
					if (GetPlayerId(whichPlayer) != j) then
						call SetPlayerAllianceStateBJ(whichPlayer, Player(j), bj_ALLIANCE_UNALLIED)
						call SetPlayerAllianceStateBJ(Player(j), whichPlayer, bj_ALLIANCE_UNALLIED)
					endif
					set j = j + 1
				endloop
				call SelectUnitForPlayerSingle(ACharacter.playerCharacter(whichPlayer).unit(), whichPlayer)
				call thistype.m_shrine.enableForCharacter(ACharacter.playerCharacter(whichPlayer), false)
				call ACharacter.playerCharacter(whichPlayer).setMovable(true)
				call ACharacter.playerCharacter(whichPlayer).panCamera()
				call Character.setTutorialForAll(false) // no need in a PvP map

				call LeaderboardAddItemBJ(whichPlayer, thistype.m_leaderboard, GetPlayerName(whichPlayer), 0)

				call SetUnitInvulnerable(ACharacter.playerCharacter(whichPlayer).unit(), true)

				// evaluate because of OpLimit
				call thistype.autoSkill.evaluate(whichPlayer)
			endif
		endmethod

		private static method autoSkill takes player whichPlayer returns nothing
			local Grimoire grimoire = Character(ACharacter.playerCharacter(whichPlayer)).grimoire()
			local integer i = 0
			local boolean result = true
			// try for every spell and do not exit before since it returns false on having the maximum level already
			loop
				exitwhen (i == grimoire.spells())
				// evaluate because of OpLimit
				if (not thistype.autoSkillGrimoireSpell.evaluate(grimoire, i)) then
					set result = false
					debug call Print("Failed at " + GetObjectName(grimoire.spell(i).ability()))
				endif
				set i = i + 1
			endloop
			call grimoire.updateUi.evaluate()
		endmethod

		private static method autoSkillGrimoireSpell takes Grimoire grimoire, integer index returns boolean
			return grimoire.setSpellMaxLevelByIndex.evaluate(index, false)
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacter takes string zone, Character character returns nothing
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacters takes string zone returns nothing
		endmethod

		public static method onInitVideoSettings takes nothing returns nothing
		endmethod

		public static method onResetVideoSettings takes nothing returns nothing
		endmethod
	endstruct

endlibrary