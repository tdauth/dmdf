library StructMapMapMapData requires Asl, AStructSystemsCharacterVideo, StructGameCharacter, StructGameClasses, StructGameGame, StructGameZone, StructMapMapShrines, StructMapMapNpcRoutines, StructMapMapWeather, StructMapQuestsQuestTalras, StructMapQuestsQuestTheNorsemen, MapVideos

	//! inject config
		call SetMapName( "TRIGSTR_001" )
		call SetMapDescription( "" )
		call SetPlayers( 12 )
		call SetTeams( 12 )
		call SetGamePlacement( MAP_PLACEMENT_TEAMS_TOGETHER )

		call DefineStartLocation( 0, -22592.0, 18944.0 )
		call DefineStartLocation( 1, -22592.0, 18944.0 )
		call DefineStartLocation( 2, -22592.0, 18944.0 )
		call DefineStartLocation( 3, -22592.0, 18944.0 )
		call DefineStartLocation( 4, -22592.0, 18944.0 )
		call DefineStartLocation( 5, -22592.0, 18944.0 )
		call DefineStartLocation( 6, -22592.0, 18944.0 )
		call DefineStartLocation( 7, -22592.0, 18944.0 )
		call DefineStartLocation( 8, -22592.0, 18944.0 )
		call DefineStartLocation( 9, -22592.0, 18944.0 )
		call DefineStartLocation( 10, -22592.0, 18944.0 )
		call DefineStartLocation( 11, -22592.0, 18944.0 )

		// Player setup
		call InitCustomPlayerSlots(  )
		call InitCustomTeams(  )
		call InitAllyPriorities(  )

		call PlayMusic("Music\\LoadingScreen.mp3") /// WARNING: If file does not exist, game crashes?
	//! endinject

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

		public static constant integer deathAngel = 'n02K'
		public static constant integer vampire = 'n02L'
		public static constant integer vampireLord = 'n010'
		public static constant integer doomedMan = 'n037'
		public static constant integer deacon = 'n035'
		public static constant integer ravenJuggler = 'n036'
		public static constant integer degenerateSoul = 'n038'
		public static constant integer medusa = 'n033'
		public static constant integer thunderCreature = 'n034'

		public static constant integer boneDragon = 'n024' /// \todo FIXME
		public static constant integer osseousDragon = 'n024'
		
		public static constant integer deranor = 'u00A'
		
		public static constant integer cornEater = 'n016'
		
		public static constant integer witch = 'h00F'
		
		public static constant integer giant = 'n02R'

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method spawn takes player whichPlayer, real x, real y returns nothing
			call CreateUnit(whichPlayer, thistype.orcCrossbow, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.orcBerserk, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.orcWarlock, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.orcWarrior, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.orcGolem, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.orcPython, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.orcLeader, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.darkElfSatyr, x, y, GetRandomFacing())
			call CreateUnit(whichPlayer, thistype.norseman, x, y, GetRandomFacing())
		endmethod
	endstruct

	struct MapData extends MapDataInterface
		public static constant string mapName = "Talras0.6"
		public static constant string mapMusic = "Music\\Ingame.mp3;Music\\Talras.mp3"
		public static constant integer maxPlayers = 6
		public static constant player alliedPlayer = Player(6)
		public static constant player neutralPassivePlayer = Player(7)
		public static constant player arenaPlayer = Player(8)
		public static constant real morning = 5.0
		public static constant real midday = 12.0
		public static constant real afternoon = 16.0
		public static constant real evening = 18.0
		public static constant real videoWaitInterval = 1.0
		public static constant real revivalTime = 35.0
		public static constant real revivalLifePercentage = 100.0
		public static constant real revivalManaPercentage = 100.0
		public static constant integer startSkillPoints = 4
		public static constant integer levelSpellPoints = 2
		public static constant integer maxLevel = 30
		public static constant integer workerUnitTypeId = 'h00E'
		public static sound cowSound = null
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
		
		private static Zone m_zoneGardonar
		private static Zone m_zoneHolzbruck

		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
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
		
		/// Required by \ref Game.
		// TODO split up in multiple trigger executions to avoid OpLimit, .evaluate doesn't seem to work.
		public static method init takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				/*
				 * Players must see all Orc enemies.
				 */
				call SetPlayerAllianceStateBJ(Player(i), MapData.orcPlayer, bj_ALLIANCE_UNALLIED_VISION)
				call SetPlayerAllianceStateBJ(MapData.orcPlayer, Player(i), bj_ALLIANCE_UNALLIED_VISION)
				set i = i + 1
			endloop
			
			call SetPlayerAllianceStateBJ(MapData.orcPlayer, Player(PLAYER_NEUTRAL_AGGRESSIVE), bj_ALLIANCE_ALLIED)
			call SetPlayerAllianceStateBJ(Player(PLAYER_NEUTRAL_AGGRESSIVE), MapData.orcPlayer, bj_ALLIANCE_ALLIED)
			call SetPlayerAllianceStateBJ(MapData.orcPlayer, MapData.alliedPlayer, bj_ALLIANCE_UNALLIED_VISION)
			call SetPlayerAllianceStateBJ(MapData.alliedPlayer, MapData.orcPlayer, bj_ALLIANCE_UNALLIED_VISION)
			
			call Aos.init.evaluate()
			call Arena.init(GetRectCenterX(gg_rct_arena_outside), GetRectCenterY(gg_rct_arena_outside), 0.0, tre("Sie haben die Arena betreten.", "You have entered the arena."), tre("Sie haben die Arena verlassen.", "You have left the arena."), tre("Ein Arenakampf beginnt nun.", "An arena fight is starting now."), tre("Ein Arenakampf endet nun. Der Gewinner ist \"%1%\" und er bekommt %2% Goldmünzen.", "An arena fight is ending now. The winner is \"%1%\" and gets %2% gold coins."))
			call Arena.addRect(gg_rct_arena_0)
			call Arena.addRect(gg_rct_arena_1)
			call Arena.addRect(gg_rct_arena_2)
			call Arena.addRect(gg_rct_arena_3)
			call Arena.addRect(gg_rct_arena_4)
			call Arena.addStartPoint(GetRectCenterX(gg_rct_arena_enemy_0), GetRectCenterY(gg_rct_arena_enemy_0), 180.0)
			call Arena.addStartPoint(GetRectCenterX(gg_rct_arena_enemy_1), GetRectCenterY(gg_rct_arena_enemy_1), 0.0)
			
			call ForForce(bj_FORCE_PLAYER[0], function Dungeons.init)
			
static if (DMDF_NPC_ROUTINES) then
			/*
			 * Extract this call since it contains many many calls which should be executed in a different trigger to avoid OpLimit.
			 * Usually you would simply use .evaluate() which is synchronous and evaluates a trigger which has its own OpLimit.
			 * Unfortunately for calling already declared methods with .evaluate() the JassHelper does not generate such a trigger evaluation.
			 * This workaround can be used for parameterless functions and calls the function with a separate OpLimit as well.
			 */
			call ForForce(bj_FORCE_PLAYER[0], function NpcRoutines.init)
endif
			call Shrines.init()
			call ForForce(bj_FORCE_PLAYER[0], function SpawnPoints.init)
			call ForForce(bj_FORCE_PLAYER[0], function Tavern.init)
			call ForForce(bj_FORCE_PLAYER[0], function Tomb.init)
			/*
			 * For functions the JassHelper always generates a TriggerEvaluate() call.
			 */
			call initMapSpells.evaluate()
			call initMapTalks.evaluate()
			call initMapVideos.evaluate()
			call ForForce(bj_FORCE_PLAYER[0], function Fellows.init) // init after talks (new)
			
			// player should look like neutral passive
			call SetPlayerColor(MapData.neutralPassivePlayer, ConvertPlayerColor(PLAYER_NEUTRAL_PASSIVE))
			
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
			
			set thistype.m_zoneGardonar = Zone.create("Gardonar" + Game.gameVersion, gg_rct_zone_gardonar)
			call thistype.m_zoneGardonar.disable()
			set thistype.m_zoneHolzbruck = Zone.create("Holzbruck" + Game.gameVersion, gg_rct_zone_holzbruck)
			call thistype.m_zoneHolzbruck.disable()
			
			call Game.addDefaultDoodadsOcclusion()
		endmethod
		
		public static method enableWayToGardonar takes nothing returns nothing
			call thistype.m_zoneGardonar.enable()
		endmethod
		
		/**
		 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
		 */
		public static method createClassSelectionItems takes AClass class, unit whichUnit returns nothing
			if (class == Classes.ranger()) then
				// Hunting Bow
				call UnitAddItemToSlotById(whichUnit, 'I020', 2)
			elseif (class == Classes.cleric() or class == Classes.necromancer() or class == Classes.elementalMage() or class == Classes.wizard()) then	
				// Haunted Staff
				call UnitAddItemToSlotById(whichUnit, 'I03V', 2)
			elseif (class == Classes.dragonSlayer()) then
				// sword and morning star
				call UnitAddItemToSlotById(whichUnit, ItemTypes.shortword().itemType(), 2)
				call UnitAddItemToSlotById(whichUnit, 'I06I', 3)
			elseif (class == Classes.druid()) then
				// simple druid staff
				call UnitAddItemToSlotById(whichUnit, 'I06J', 2)
			else
				call UnitAddItemToSlotById(whichUnit, ItemTypes.shortword().itemType(), 2)
				call UnitAddItemToSlotById(whichUnit, ItemTypes.lightWoodenShield().itemType(), 3)
			endif
			// scroll of death to teleport from the beginning, otherwise characters must walk long ways
			call UnitAddItemToSlotById(whichUnit, 'I01N', 0)
			call UnitAddItemToSlotById(whichUnit, 'I061', 1)
			
			call UnitAddItemToSlotById(whichUnit, 'I00A', 4)
			call UnitAddItemToSlotById(whichUnit, 'I00D', 5)
		endmethod
		
		/**
		 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
		 */
		public static method createClassItems takes Character character returns nothing
			if (character.class() == Classes.ranger()) then
				// Hunting Bow
				call character.giveItem('I020')
			elseif (character.class() == Classes.cleric() or character.class() == Classes.necromancer() or character.class() == Classes.elementalMage() or character.class() == Classes.wizard()) then	
				// Haunted Staff
				call character.giveItem('I03V')
			elseif (character.class() == Classes.dragonSlayer()) then
				// sword and morning star
				call character.giveItem(ItemTypes.shortword().itemType())
				call character.giveItem('I06I')
			elseif (character.class() == Classes.druid()) then
				// simple druid staff
				call character.giveItem('I06J')
			else
				call character.giveItem(ItemTypes.shortword().itemType())
				call character.giveItem(ItemTypes.lightWoodenShield().itemType())
			endif
		
			// scroll of death to teleport from the beginning, otherwise characters must walk long ways
			call character.giveItem('I01N')
			call character.giveQuestItem('I061')

			call character.giveItem('I00A')
			call character.giveItem('I00A')
			call character.giveItem('I00A')
			call character.giveItem('I00A')
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call character.giveItem('I00D')
		endmethod
		
		/// Required by \ref Game.
		public static method initMapSpells takes ACharacter character returns nothing
			call initMapCharacterSpells.evaluate(character)
		endmethod

		/// Required by \ref Game.
		public static method start takes nothing returns nothing
			local integer i
			set thistype.cowSound = gg_snd_Cow
			call initMapPrimaryQuests()
			call initMapSecundaryQuests()
			
			set i = 0
			loop
				exitwhen (i == thistype.maxPlayers)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call SelectUnitForPlayerSingle(ACharacter.playerCharacter(Player(i)).unit(), Player(i))
				endif
				set i = i + 1
			endloop
			
			call Weather.startRainCountdown()
			
			// call GetCamOffset after initialization to make sure it returns the correct value
			call CameraHeight.addRect(gg_rct_bridge_talras_camera_area, GetPointZ(GetRectCenterX(gg_rct_bridge_talras), GetRectCenterY(gg_rct_bridge_talras)) / 2.2)
			call CameraHeight.addRect(gg_rct_bridge_death_vault_0_camera_area, GetPointZ(GetRectCenterX(gg_rct_bridge_death_vault_0), GetRectCenterY(gg_rct_bridge_death_vault_0)) / 2.2)
			call CameraHeight.addRect(gg_rct_bridge_death_vault_1_camera_area, GetPointZ(GetRectCenterX(gg_rct_bridge_death_vault_1), GetRectCenterY(gg_rct_bridge_death_vault_1)) / 2.2)
			
			call VideoIntro.video().play()
		endmethod
		
		private static method applyHandicap takes nothing returns nothing
			local integer missingPlayers =  Game.missingPlayers()
			local real handicap = 1.0 - missingPlayers * 0.10
			// decrease difficulty for others if players are missing
			if (missingPlayers > 0) then
				call SetPlayerHandicap(Player(PLAYER_NEUTRAL_AGGRESSIVE), handicap)
				call TriggerSleepAction(4.0)
				call Character.displayDifficultyToAll(Format(tre("Da Sie das Spiel ohne %1% Spieler beginnen, erhalten die Gegner ein Handicap von %2% %. Zudem erhält Ihr Charakter sowohl mehr Erfahrungspunkte als auch mehr Goldmünzen beim Töten von Gegnern.", "Since you are starting the game without %1% players the enemies get a handicap of %2% %. Besides your character gains more experience as well as more gold coins from killing enemies.")).s(trpe("einen weiteren", Format("%1% weitere").i(missingPlayers).result(), "one more", Format("%1% more").i(missingPlayers).result(), missingPlayers)).rw(handicap * 100.0, 0, 0).result())
			endif
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
			// call the following code only once in case the intro is showed multiple times
			if (thistype.m_startedGameAfterIntro) then
				return
			endif
			set thistype.m_startedGameAfterIntro = true
			
			debug call Print("Waited successfully for intro video.")
			
			call ACharacter.setAllMovable(true) // set movable since they weren't before after class selection (before video)
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, tre("Geben Sie \"-menu\" im Chat ein, um ins Haupt-Menü zu gelangen.", "Enter \"-menu\" into the chat to reach the main menu."))
			call ACharacter.panCameraSmartToAll()
			call ACharacter.enableShrineForAll(Shrines.startShrine(), false)
			call QuestTalras.quest().enable()

			call NpcRoutines.manualStart() // necessary since at the beginning time of day events might not have be called
			
			// execute because of trigger sleep action
			call thistype.applyHandicap.execute()
		endmethod

		/// Required by \ref Classes.
		public static method startX takes integer index returns real
			debug if (index < 0 or index >= thistype.maxPlayers) then
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

		/// Required by \ref Classes.
		public static method startY takes integer index returns real
			debug if (index < 0 or index >= thistype.maxPlayers) then
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
		
		/**
		 * \return Returns true if characters gain experience from killing units of player \p whichPlayer. Otherwise it returns false.
		 */
		public static method playerGivesXP takes player whichPlayer returns boolean
			return whichPlayer == Player(PLAYER_NEUTRAL_AGGRESSIVE) or whichPlayer == thistype.orcPlayer
		endmethod
		
		public static method initVideoSettings takes nothing returns nothing
			call Weather.pauseWeather()
		endmethod
		
		public static method resetVideoSettings takes nothing returns nothing
			call Weather.resumeWeather()
		endmethod
	endstruct

endlibrary