library StructMapMapMapData requires Asl, Game, StructMapMapShrines, StructMapMapNpcRoutines, StructMapMapWeather, StructMapQuestsQuestTalras, StructMapQuestsQuestTheNorsemen, MapQuests, MapVideos

	struct MapData
		/// This player is only required by Talras since there is an arena with opponents.
		public static constant player arenaPlayer = Player(8)
		public static constant player orcPlayer = Player(9)
		public static constant player haldarPlayer = Player(10)
		public static constant player baldarPlayer = Player(11)

		private static boolean m_startedGameAfterIntro = false
		private static region m_welcomeRegion
		private static trigger m_welcomeTalrasTrigger

		private static region m_portalsHintRegion
		private static trigger m_portalsHintTrigger
		private static boolean array m_portalsHintShown[12]

		private static region m_talkHintRegion
		private static trigger m_talkHintTrigger
		private static boolean array m_talkHintShown[12]

		private static region m_deranorsDungeonHintRegion
		private static trigger m_deranorsDungeonHintTrigger

		private static trigger m_giantDeathTrigger

		// Zones which can be reached directly from this map.
		private static Zone m_zoneGardonar
		private static Zone m_zoneHolzbruck
		private static Zone m_zoneDornheim

		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// Required by \ref Game.
		public static method initSettings takes nothing returns nothing
			call MapSettings.setMapName("TL")
			// Ascetic_-_06_-_Falling_into_Darkness.mp3
			// ;Music\\mp3Music\\Pride_v002.mp3
			call MapSettings.setMapMusic("Sound\\Music\\mp3Music\\PippinTheHunchback.mp3")
			call MapSettings.setGoldmine(gg_unit_n06E_0487)
			call MapSettings.setNeutralPassivePlayer(Player(7))
			call MapSettings.setPlayerGivesXP(thistype.orcPlayer, true)
			call MapSettings.setStartLevel(2) // Talras starts AFTER Dornheim where the character gets to level 2

			// Add all quest unit types of units which have to be moved somewhere.
			call MapSettings.setUnitTypeIdExcludedFromTeleports('n04P', true)
			call MapSettings.setUnitTypeIdExcludedFromTeleports('h021', true)
			call MapSettings.setUnitTypeIdExcludedFromTeleports('h01Z', true)
			call MapSettings.setUnitTypeIdExcludedFromTeleports('h022', true)
			call MapSettings.setUnitTypeIdExcludedFromTeleports('h016', true)
			call MapSettings.setUnitTypeIdExcludedFromTeleports('h020', true)
			call MapSettings.setUnitTypeIdExcludedFromTeleports('u00C', true)

			call MapSettings.addZoneRestorePositionForAllPlayers("WM", GetRectCenterX(gg_rct_start_gardonar), GetRectCenterY(gg_rct_start_gardonar), 180.0)
			call MapSettings.addZoneRestorePositionForAllPlayers("GA", GetRectCenterX(gg_rct_start_gardonar), GetRectCenterY(gg_rct_start_gardonar), 180.0)
			call MapSettings.addZoneRestorePositionForAllPlayers("HB", GetRectCenterX(gg_rct_start_holzbruck), GetRectCenterY(gg_rct_start_holzbruck), 270.0)
			call MapSettings.addZoneRestorePositionForAllPlayers("DH", GetRectCenterX(gg_rct_start_dornheim), GetRectCenterY(gg_rct_start_dornheim), 90.0)
		endmethod

		private static method triggerConditionWelcomeTalras takes nothing returns boolean
			return ACharacter.isUnitCharacter(GetTriggerUnit())
		endmethod

		private static method triggerActionWelcomeTalras takes nothing returns nothing
			local force humans = GetPlayersByMapControl(MAP_CONTROL_USER)
			call TransmissionFromUnitWithNameBJ(humans, gg_unit_n015_0149, tre("Krieger", "Warrior"), null, tre("Willkommen in Talras!", "Welcome to Talras!"), bj_TIMETYPE_ADD, 0.0, false)
			call DisableTrigger(GetTriggeringTrigger())
			call DestroyForce(humans)
			set humans = null
			call RemoveRegion(thistype.m_welcomeRegion)
			set thistype.m_welcomeRegion = null
			call DestroyTrigger(GetTriggeringTrigger())
		endmethod

		private static method triggerConditionPortalsHint takes nothing returns boolean
			return ACharacter.isUnitCharacter(GetTriggerUnit()) and not thistype.m_portalsHintShown[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))]
		endmethod

		private static method triggerActionPortalsHint takes nothing returns nothing
			call Character(ACharacter.getCharacterByUnit(GetTriggerUnit())).displayHint("Magische Kreise auf der Karte dienen als Portale. Schicken Sie Einheiten auf die Kreise, um sie an verschiedene Punkte auf der Karte zu bewegen.")
			set thistype.m_portalsHintShown[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] = true
		endmethod

		private static method triggerConditionTalkHint takes nothing returns boolean
			return ACharacter.isUnitCharacter(GetTriggerUnit()) and not thistype.m_talkHintShown[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))]
		endmethod

		private static method triggerActionTalkHint takes nothing returns nothing
			call Character(ACharacter.getCharacterByUnit(GetTriggerUnit())).displayHint(tre("Schicken Sie Ihren Charakter in die Nähe einer Person, um diese anzusprechen. Klicken Sie dazu auf die Person und wählen Sie \"Person ansprechen\" aus.", "Send your character near a person to speak to the person. For that click on the person and select \"Speak to person\"."))
			set thistype.m_talkHintShown[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] = true
		endmethod

		private static method triggerConditionDeranorsDungeonHint takes nothing returns boolean
			return ACharacter.isUnitCharacter(GetTriggerUnit()) and not WaygateIsActive(gg_unit_n02I_0264)
		endmethod

		private static method triggerActionDeranorsDungeonHint takes nothing returns nothing
			call Character(ACharacter.getCharacterByUnit(GetTriggerUnit())).displayHint(tre("Der Zugang zur Gruft ist momentan verschlossen.", "The entry to the tomb is currently closed."))
		endmethod

		private static method triggerConditionGiantDeath takes nothing returns boolean
			// always drop a fur?
			if (GetUnitTypeId(GetTriggerUnit()) == 'n02R' and IsUnitType(GetTriggerUnit(), UNIT_TYPE_SUMMONED)) then
				call CreateItem('I01Z', GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()))
			endif

			return false
		endmethod

		private static method trigggerConditionTrack takes nothing returns boolean
			local string text = DmdfHashTable.global().handleStr(GetTriggeringTrigger(), 0)
			local player whichPlayer = DmdfHashTable.global().handlePlayer(GetTriggeringTrigger(), 1)
			debug call Print("Tracked by " + GetPlayerName(whichPlayer))
			call DisplayTextToPlayer(whichPlayer, 0.0, 0.0, text)
			return false
		endmethod

		private static method createTombstone takes rect whichRect, string text returns nothing
			local trackable tombStoneTrackable = null
			local trigger trackTrigger = null
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set tombStoneTrackable = CreateTrackableForPlayer(Player(i), "Doodads\\Terrain\\InvisiblePlatform\\InvisiblePlatform.mdl", GetRectCenterX(whichRect), GetRectCenterY(whichRect), 0.0)
				set trackTrigger = CreateTrigger()
				call TriggerRegisterTrackableTrackEvent(trackTrigger, tombStoneTrackable)
				call TriggerAddCondition(trackTrigger, Condition(function thistype.trigggerConditionTrack))
				call DmdfHashTable.global().setHandleStr(trackTrigger, 0, text)
				call DmdfHashTable.global().setHandlePlayer(trackTrigger, 1, Player(i))
				set i = i + 1
			endloop
		endmethod

		private static method initTombstones takes nothing returns nothing
			call thistype.createTombstone(gg_rct_sign_tombstone_0, tre("Vater wusste es besser.", "Father knew better."))
			call thistype.createTombstone(gg_rct_sign_tombstone_1, tre("Hier ruhe ich, nicht du!", "Here I rest, not you!"))
			call thistype.createTombstone(gg_rct_sign_tombstone_2, tre("Du schuldest mir noch Goldmünzen für diesen Grabstein!", "You owe me gold coins for this tombstone!"))
			call thistype.createTombstone(gg_rct_sign_tombstone_3, tre("Man sieht sich.", "See you."))
			call thistype.createTombstone(gg_rct_sign_tombstone_4, tre("Brot kann schimmeln, was kannst du?", "Bread can mold, what can you do?"))
			call thistype.createTombstone(gg_rct_sign_tombstone_5, tre("Sprang von einer Klippe und kam auch unten an.", "Jumped from a cliff and also came down."))
			call thistype.createTombstone(gg_rct_sign_tombstone_6, tre("Es war todsicher.", "It was dead sure."))
			call thistype.createTombstone(gg_rct_sign_tombstone_7, tre("Ein andermal vielleicht.", "Another time perhaps."))
			call thistype.createTombstone(gg_rct_sign_tombstone_8, tre("Begrabt mich auf keinen Fall. Verbrennt mich!", "Do not bury me. Burn me!"))
			call thistype.createTombstone(gg_rct_sign_tombstone_9, tre("Lag gerne herum und tat nichts.", "Liked lying around and doing nothing."))
			call thistype.createTombstone(gg_rct_sign_tombstone_10, tre("Im nächsten Leben bin ich sicher reich.", "In the next life I am certainly rich."))
			call thistype.createTombstone(gg_rct_sign_tombstone_castle_1, tre("Regierte mit Strenge, aber regierte wenigstens.", "Ruled with severity, but ruled at least."))
			call thistype.createTombstone(gg_rct_sign_tombstone_castle_2, tre("Ertrug ihren Mann bis zuletzt.", "She beared her husband to the last."))
		endmethod

		/// Required by \ref Game.
		// TODO split up in multiple trigger executions to avoid OpLimit, .evaluate doesn't seem to work when placed explicitely. The methods have to be declared below which forces .evaluate() to use a real TriggerEvaluate().
		public static method init takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				/*
				 * Players must see all Orc enemies.
				 */
				call SetPlayerAllianceStateBJ(Player(i), MapData.orcPlayer, bj_ALLIANCE_UNALLIED_VISION)
				call SetPlayerAllianceStateBJ(MapData.orcPlayer, Player(i), bj_ALLIANCE_UNALLIED_VISION)
				set i = i + 1
			endloop

			call SetPlayerAllianceStateBJ(MapData.orcPlayer, Player(PLAYER_NEUTRAL_AGGRESSIVE), bj_ALLIANCE_ALLIED)
			call SetPlayerAllianceStateBJ(Player(PLAYER_NEUTRAL_AGGRESSIVE), MapData.orcPlayer, bj_ALLIANCE_ALLIED)
			call SetPlayerAllianceStateBJ(MapData.orcPlayer, MapSettings.alliedPlayer(), bj_ALLIANCE_UNALLIED_VISION)
			call SetPlayerAllianceStateBJ(MapSettings.alliedPlayer(), MapData.orcPlayer, bj_ALLIANCE_UNALLIED_VISION)

			// preload everything like in the Warcraft III campaigns
			//call Preloader("Scripts\\Talras.pld")

			call Aos.init.evaluate()
			call Arena.init(GetRectCenterX(gg_rct_arena_outside), GetRectCenterY(gg_rct_arena_outside), 0.0, tre("Sie haben die Arena betreten.", "You have entered the arena."), tre("Sie haben die Arena verlassen.", "You have left the arena."), tre("Ein Arenakampf beginnt nun.", "An arena fight is starting now."), tre("Ein Arenakampf endet nun. Der Gewinner ist \"%1%\" und er bekommt %2% Goldmünzen.", "An arena fight is ending now. The winner is \"%1%\" and gets %2% gold coins."))
			call Arena.addRect(gg_rct_arena_0)
			call Arena.addRect(gg_rct_arena_1)
			call Arena.addRect(gg_rct_arena_2)
			call Arena.addRect(gg_rct_arena_3)
			call Arena.addRect(gg_rct_arena_4)
			call Arena.addStartPoint(GetRectCenterX(gg_rct_arena_enemy_0), GetRectCenterY(gg_rct_arena_enemy_0), 180.0)
			call Arena.addStartPoint(GetRectCenterX(gg_rct_arena_enemy_1), GetRectCenterY(gg_rct_arena_enemy_1), 0.0)

			call NewOpLimit(function Dungeons.init)

static if (DMDF_NPC_ROUTINES) then
			/*
			 * Extract this call since it contains many many calls which should be executed in a different trigger to avoid OpLimit.
			 * Usually you would simply use .evaluate() which is synchronous and evaluates a trigger which has its own OpLimit.
			 * Unfortunately for calling already declared methods with .evaluate() the JassHelper does not generate such a trigger evaluation.
			 * This workaround can be used for parameterless functions and calls the function with a separate OpLimit as well.
			 */
			call NewOpLimit(function NpcRoutines.init)
endif
			call Shrines.init()
			call NewOpLimit(function SpawnPoints.init)
			call NewOpLimit(function Tomb.init)
			/*
			 * For functions the JassHelper always generates a TriggerEvaluate() call.
			 */
			call initMapSpells.evaluate()
			call initMapTalks.evaluate()
			/**
			 * Use a new OpLimit since many videos are created.
			 */
			call initMapVideos.evaluate()
			call NewOpLimit(function Fellows.init) // init after talks (new)
			call NewOpLimit(function Npcs.initShops) //  has to be called AFTER Shop.init()!

			set thistype.m_welcomeTalrasTrigger = CreateTrigger()
			set thistype.m_welcomeRegion = CreateRegion()
			call RegionAddRect(thistype.m_welcomeRegion, gg_rct_quest_talras_quest_item_0)
			call TriggerRegisterEnterRegion(thistype.m_welcomeTalrasTrigger, thistype.m_welcomeRegion, null)
			call TriggerAddCondition(thistype.m_welcomeTalrasTrigger, Condition(function thistype.triggerConditionWelcomeTalras))
			call TriggerAddAction(thistype.m_welcomeTalrasTrigger, function thistype.triggerActionWelcomeTalras)

			set thistype.m_portalsHintTrigger = CreateTrigger()
			set thistype.m_portalsHintRegion = CreateRegion()
			call RegionAddRect(thistype.m_portalsHintRegion, gg_rct_hint_portals)
			call TriggerRegisterEnterRegion(thistype.m_portalsHintTrigger, thistype.m_portalsHintRegion, null)
			call TriggerAddCondition(thistype.m_portalsHintTrigger, Condition(function thistype.triggerConditionPortalsHint))
			call TriggerAddAction(thistype.m_portalsHintTrigger, function thistype.triggerActionPortalsHint)

			set thistype.m_talkHintRegion = CreateRegion()
			set thistype.m_talkHintTrigger = CreateTrigger()
			call RegionAddRect(thistype.m_talkHintRegion, gg_rct_hint_talk)
			call TriggerRegisterEnterRegion(thistype.m_talkHintTrigger, thistype.m_talkHintRegion, null)
			call TriggerAddCondition(thistype.m_talkHintTrigger, Condition(function thistype.triggerConditionTalkHint))
			call TriggerAddAction(thistype.m_talkHintTrigger, function thistype.triggerActionTalkHint)

			set thistype.m_deranorsDungeonHintTrigger = CreateTrigger()
			set thistype.m_deranorsDungeonHintRegion = CreateRegion()
			call RegionAddRect(thistype.m_deranorsDungeonHintRegion, gg_rct_hint_deranors_dungeon)
			call TriggerRegisterEnterRegion(thistype.m_deranorsDungeonHintTrigger, thistype.m_deranorsDungeonHintRegion, null)
			call TriggerAddCondition(thistype.m_deranorsDungeonHintTrigger, Condition(function thistype.triggerConditionDeranorsDungeonHint))
			call TriggerAddAction(thistype.m_deranorsDungeonHintTrigger, function thistype.triggerActionDeranorsDungeonHint)

			set thistype.m_giantDeathTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_giantDeathTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(thistype.m_giantDeathTrigger, Condition(function thistype.triggerConditionGiantDeath))

			call thistype.initTombstones()

			set thistype.m_zoneGardonar = Zone.create("GA", gg_rct_zone_gardonar)
			call thistype.m_zoneGardonar.disable()
			set thistype.m_zoneHolzbruck = Zone.create("HB", gg_rct_zone_holzbruck)
			call thistype.m_zoneHolzbruck.disable()
			set thistype.m_zoneDornheim = Zone.create("DH", gg_rct_zone_dornheim) // Tutorial

			call Game.addDefaultDoodadsOcclusion()
		endmethod

		public static method enableWayToGardonar takes nothing returns nothing
			call thistype.m_zoneGardonar.enable()
		endmethod

		public static method zoneGardonar takes nothing returns Zone
			return thistype.m_zoneGardonar
		endmethod

		public static method zoneHolzbruck takes nothing returns Zone
			return thistype.m_zoneHolzbruck
		endmethod

		/// Required by \ref ClassSelection.
		public static method onCreateClassSelectionItems takes AClass class, unit whichUnit returns nothing
			call Classes.createDefaultClassSelectionItems(class, whichUnit)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onCreateClassItems takes Character character returns nothing
			call Classes.createDefaultClassItems(character)
		endmethod

		/// Required by \ref Game.
		public static method onInitMapSpells takes ACharacter character returns nothing
			call initMapCharacterSpells.evaluate(character)
		endmethod

		/// Required by \ref Game.
		public static method onStart takes nothing returns nothing
			call SuspendTimeOfDay(true)
			call SetTimeOfDay(0.0)
		endmethod

		private static method startX takes integer index returns real
			debug if (index < 0 or index >= MapSettings.maxPlayers()) then
				debug call thistype.staticPrint("Error: Invalid start X index.")
			debug endif
			if (index == 0) then
				return GetRectCenterX(gg_rct_character_0_start)
			elseif (index == 1) then
				return GetRectCenterX(gg_rct_character_1_start)
			elseif (index == 2) then
				return GetRectCenterX(gg_rct_character_2_start)
			elseif (index == 3) then
				return GetRectCenterX(gg_rct_character_3_start)
			elseif (index == 4) then
				return GetRectCenterX(gg_rct_character_4_start)
			elseif (index == 5) then
				return GetRectCenterX(gg_rct_character_5_start)
			endif
			return 0.0
		endmethod

		private static method startY takes integer index returns real
			debug if (index < 0 or index >= MapSettings.maxPlayers()) then
				debug call thistype.staticPrint("Error: Invalid start Y index.")
			debug endif
			if (index == 0) then
				return GetRectCenterY(gg_rct_character_0_start)
			elseif (index == 1) then
				return GetRectCenterY(gg_rct_character_1_start)
			elseif (index == 2) then
				return GetRectCenterY(gg_rct_character_2_start)
			elseif (index == 3) then
				return GetRectCenterY(gg_rct_character_3_start)
			elseif (index == 4) then
				return GetRectCenterY(gg_rct_character_4_start)
			elseif (index == 5) then
				return GetRectCenterY(gg_rct_character_5_start)
			endif
			return 0.0
		endmethod

		/// Required by \ref ClassSelection.
		public static method onSelectClass takes Character character, AClass class, boolean last returns nothing
			call SetUnitX(character.unit(), thistype.startX(GetPlayerId(character.player())))
			call SetUnitY(character.unit(), thistype.startY(GetPlayerId(character.player())))
			call SetUnitFacing(character.unit(), 0.0)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onRepick takes Character character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method start takes nothing returns nothing
			local integer i = 0
			// Need the created characters and add something to the quest log.
			call NewOpLimit(function initMapPrimaryQuests)
			call NewOpLimit(function initMapSecundaryQuests)
			call NewOpLimit(function Dungeons.addSpellbookAbilities)

			debug call Print("Map Start 1")

			call SuspendTimeOfDay(false)

			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call SelectUnitForPlayerSingle(ACharacter.playerCharacter(Player(i)).unit(), Player(i))
				endif
				set i = i + 1
			endloop

			debug call Print("Map Start 2")

			call Weather.startRainCountdown()

			debug call Print("Map Start 3")

			// call GetCamOffset after initialization to make sure it returns the correct value
			call CameraHeight.addRect.evaluate(gg_rct_bridge_talras_camera_area, GetPointZ(GetRectCenterX(gg_rct_bridge_talras), GetRectCenterY(gg_rct_bridge_talras)) / 2.2)
			call CameraHeight.addRect.evaluate(gg_rct_bridge_death_vault_0_camera_area, GetPointZ(GetRectCenterX(gg_rct_bridge_death_vault_0), GetRectCenterY(gg_rct_bridge_death_vault_0)) / 2.2)
			call CameraHeight.addRect.evaluate(gg_rct_bridge_death_vault_1_camera_area, GetPointZ(GetRectCenterX(gg_rct_bridge_death_vault_1), GetRectCenterY(gg_rct_bridge_death_vault_1)) / 2.2)

			call VideoIntro.video().play()
		endmethod

		/**
		 * This method should be called after the intro has been shown.
		 * It uses a boolean variable to make sure it is only called once in case the video "Intro" is run via a cheat
		 * multiple times.
		 *
		 * The function enables the main quest "Talras", starts NPC routines and adds start items to characters.
		 *
		 * It is called in the onStopAction() of the video intro with .evaluate() which means it is called after unpausing all units and restoring all player data.
		 */
		public static method startAfterIntro takes nothing returns nothing
			local real handicap = 0.0
			// call the following code only once in case the intro is showed multiple times
			if (thistype.m_startedGameAfterIntro) then
				return
			endif
			set thistype.m_startedGameAfterIntro = true

			debug call Print("Waited successfully for intro video.")

			call ACharacter.setAllMovable(true) // set movable since they weren't before after class selection (before video)
			call ACharacter.panCameraSmartToAll()
			call ACharacter.enableShrineForAll(Shrines.startShrine(), false)
			call QuestTalras.quest().enable()

			call NewOpLimit(function AUnitRoutine.manualStartAll) // necessary since at the beginning time of day events might not have be called

			set handicap = Game.applyHandicapToCreeps()
			call SetPlayerHandicap(MapData.orcPlayer, handicap)
			call SetPlayerHandicap(MapData.haldarPlayer, handicap)
			call SetPlayerHandicap(MapData.baldarPlayer, handicap)
			call SetPlayerHandicap(MapData.arenaPlayer, handicap)
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacter takes string zone, Character character returns nothing
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacters takes string zone returns nothing
			// When the character finally comes back from Holzbruck you can directly travel to Holzbruck.
			if (zone == "HB") then
				call thistype.m_zoneHolzbruck.enable()
				call Character.displayHintToAll(tre("Sie können nun direkt nach Holzbruck reisen.", "You can now directly travel to Holzbruck."))
			elseif (zone == "GA") then
				call thistype.m_zoneGardonar.enable()
			endif
		endmethod

		/**
		 * Required by \ref Game. Called by .evaluate()
		 */
		public static method onInitVideoSettings takes nothing returns nothing
			/*
			 * If AOS spawn is not paused, warriors might spawn during a video sequence and not be paused.
			 */
			if (Aos.characterHasEntered.evaluate()) then
				call Aos.pauseSpawn.evaluate()
			endif
			call Weather.pauseWeather()
			// shop markers
			call ShowUnit(gg_unit_o008_0209, false)
			call ShowUnit(gg_unit_o007_0208, false)
		endmethod

		/**
		 * Required by \ref Game. Called by .evaluate()
		 */
		public static method onResetVideoSettings takes nothing returns nothing
			if (Aos.characterHasEntered.evaluate()) then
				call Aos.continueSpawn.evaluate()
			endif
			call Weather.resumeWeather()
			// shop markers
			call ShowUnit(gg_unit_o008_0209, true)
			call ShowUnit(gg_unit_o007_0208, true)
		endmethod
	endstruct

endlibrary