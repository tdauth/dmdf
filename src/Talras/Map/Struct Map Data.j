library StructMapMapMapData requires Asl, AStructSystemsCharacterVideo, StructGameCharacter, StructGameClasses, StructGameGame, StructGameZone, StructMapMapShrines, StructMapMapNpcRoutines, StructMapQuestsQuestTalras, StructMapQuestsQuestTheNorsemen, MapVideos

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
		
		private static timer m_rainTimer
		private static timer m_resetRainTimer
		private static timer m_thunderTimer
		private static weathereffect m_rainWeatherEffect
		
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
			// weather
			set thistype.m_rainTimer = CreateTimer()
			set thistype.m_resetRainTimer = CreateTimer()
			set thistype.m_thunderTimer = CreateTimer()
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
			
			// TODO fix zone management first then uncomment this
			//set thistype.m_zoneHolzbruck = Zone.create("Holzbruck" + Game.gameVersion, gg_rct_zone_holzbruck)
			
			call Game.addDefaultDoodadsOcclusion()
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
		
		public static method setCameraBoundsToMapForPlayer takes player user returns nothing
			call ResetCameraBoundsToMapRectForPlayer(user)
		endmethod

		/// Required by \ref Classes.
		public static method setCameraBoundsToPlayableAreaForPlayer takes player user returns nothing
			call SetCameraBoundsToRectForPlayerBJ(user, gg_rct_area_playable)
		endmethod

		public static method setCameraBoundsToTavernForPlayer takes player user returns nothing
			call SetCameraBoundsToRectForPlayerBJ(user, gg_rct_area_tavern_bounds)
		endmethod

		public static method setCameraBoundsToAosForPlayer takes player user returns nothing
			call SetCameraBoundsToRectForPlayerBJ(user, gg_rct_area_aos)
		endmethod

		public static method setCameraBoundsToTombForPlayer takes player user returns nothing
			call SetCameraBoundsToRectForPlayerBJ(user, gg_rct_area_tomb)
		endmethod

		/// Required by \ref Game.
		public static method resetCameraBoundsForPlayer takes player user returns nothing
			if (Aos.areaContainsCharacter.evaluate(ACharacter.playerCharacter(user))) then
				call thistype.setCameraBoundsToAosForPlayer(user)
			elseif (Tomb.areaContainsCharacter.evaluate(ACharacter.playerCharacter(user))) then
				call thistype.setCameraBoundsToTombForPlayer(user)
			elseif (false) then /// @todo Tavern area
				call thistype.setCameraBoundsToTavernForPlayer(user)
			else
				call thistype.setCameraBoundsToPlayableAreaForPlayer(user)
			endif
		endmethod

static if (DEBUG_MODE) then
		private static method onCheatActionMapCheats takes ACheat cheat returns nothing
			call Print(tre("Örtlichkeiten-Cheats:", "Location Cheats:"))
			call Print("bonus")
			call Print("start")
			call Print("castle")
			call Print("talras")
			call Print("farm")
			call Print("forest")
			call Print("aos")
			call Print("aosentry")
			call Print("tavern")
			call Print("tomb")
			call Print("orccamp")
			call Print(tre("Video-Cheats:", "Video Cheats:"))
			call Print("intro")
			call Print("rescuedago0")
			call Print("rescuedago1")
			call Print("thecastle")
			call Print("thedukeoftalras")
			call Print("thechief")
			call Print("thefirstcombat")
			call Print("wigberht")
			call Print("anewalliance")
			call Print("dragonhunt")
			call Print("deathvault")
			call Print("bloodthirstiness")
			call Print("deranor")
			call Print("deranorsdeath")
			call Print("recruitthehighelf")
			call Print("prepareforthedefense")
			call Print("thedefenseoftalras")
			call Print("dararos")
			call Print("victory")
			call Print("holzbruck")
			call Print("upstream")
			call Print(tre("Handlungs-Cheats:", "Plot Cheats:"))
			call Print("aftertalras")
			call Print("afterthenorsemen")
			call Print("afterslaughter")
			call Print("afterderanor")
			call Print("afterthebattle")
			call Print("afterwar")
			call Print("afterthedefenseoftalras")
			call Print(tre("Erzeugungs-Cheats:", "Spawn Cheats:"))
			call Print("unitspawns")
			call Print("testspawnpoint")
		endmethod
		
		private static method onCheatActionBonus takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_bonus)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call SetCameraBoundsToRectForPlayerBJ(whichPlayer, gg_rct_bonus)
			set whichPlayer = null
		endmethod

		private static method onCheatActionStart takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_start)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionCamp takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_camp)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionCastle takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_castle)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionTalras takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_talras)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionFarm takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_farm)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionForest takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_forest)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionAos takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_shrine_baldar_discover)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionAosEntry takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_aos_outside)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call thistype.setCameraBoundsToPlayableAreaForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod
		
		private static method onCheatActionTavern takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_area_tavern_bounds)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			set whichPlayer = null
		endmethod
		
		private static method onCheatActionTomb takes ACheat cheat returns nothing
			call ACharacter.playerCharacter(GetTriggerPlayer()).setRect(gg_rct_cheat_tomb)
			call IssueImmediateOrder(ACharacter.playerCharacter(GetTriggerPlayer()).unit(), "stop")
		endmethod
		
		private static method onCheatActionOrcCamp takes ACheat cheat returns nothing
			call ACharacter.playerCharacter(GetTriggerPlayer()).setRect(gg_rct_cheat_orc_camp)
			call IssueImmediateOrder(ACharacter.playerCharacter(GetTriggerPlayer()).unit(), "stop")
		endmethod

		private static method onCheatActionIntro takes ACheat cheat returns nothing
			call VideoIntro.video().play()
		endmethod

		private static method onCheatActionRescueDago0 takes ACheat cheat returns nothing
			call VideoRescueDago0.video().play()
		endmethod

		private static method onCheatActionRescueDago1 takes ACheat cheat returns nothing
			call VideoRescueDago1.video().play()
		endmethod

		private static method onCheatActionTheCastle takes ACheat cheat returns nothing
			call VideoTheCastle.video().play()
		endmethod

		private static method onCheatActionTheDukeOfTalras takes ACheat cheat returns nothing
			call VideoTheDukeOfTalras.video().play()
		endmethod

		private static method onCheatActionTheChief takes ACheat cheat returns nothing
			call VideoTheChief.video().play()
		endmethod

		private static method onCheatActionTheFirstCombat takes ACheat cheat returns nothing
			call VideoTheFirstCombat.video().play()
		endmethod

		private static method onCheatActionWigberht takes ACheat cheat returns nothing
			call VideoWigberht.video().play()
		endmethod

		private static method onCheatActionANewAlliance takes ACheat cheat returns nothing
			call VideoANewAlliance.video().play()
		endmethod

		private static method onCheatActionDragonHunt takes ACheat cheat returns nothing
			call VideoDragonHunt.video().play()
		endmethod

		private static method onCheatActionDeathVault takes ACheat cheat returns nothing
			call VideoDeathVault.video().play()
		endmethod

		private static method onCheatActionBloodthirstiness takes ACheat cheat returns nothing
			call VideoBloodthirstiness.video().play()
		endmethod
		
		private static method onCheatActionDeranor takes ACheat cheat returns nothing
			call VideoDeranor.video().play()
		endmethod
		
		private static method onCheatActionDeranorsDeath takes ACheat cheat returns nothing
			call VideoDeranorsDeath.video().play()
		endmethod
		
		private static method onCheatActionRecruitTheHighElf takes ACheat cheat returns nothing
			call VideoRecruitTheHighElf.video().play()
		endmethod
		
		private static method onCheatActionPrepareForTheDefense takes ACheat cheat returns nothing
			call VideoPrepareForTheDefense.video().play()
		endmethod
		
		private static method onCheatActionTheDefenseOfTalras takes ACheat cheat returns nothing
			call VideoTheDefenseOfTalras.video().play()
		endmethod
		
		private static method onCheatActionDararos takes ACheat cheat returns nothing
			call VideoDararos.video().play()
		endmethod
		
		private static method onCheatActionVictory takes ACheat cheat returns nothing
			call VideoVictory.video().play()
		endmethod
		
		private static method onCheatActionHolzbruck takes ACheat cheat returns nothing
			call VideoHolzbruck.video().play()
		endmethod
			
		private static method onCheatActionUpstream takes ACheat cheat returns nothing
			call VideoUpstream.video().play()
		endmethod
		
		private static method moveCharactersToRect takes rect whichRect returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					/*
					 * If the character is already standing in the rect move outside first to trigger the event afterwards.
					 */
					if (RectContainsUnit(whichRect, ACharacter.playerCharacter(Player(i)).unit())) then
						call SetUnitX(ACharacter.playerCharacter(Player(i)).unit(), GetRectMaxX(whichRect) + 100.0)
						call SetUnitY(ACharacter.playerCharacter(Player(i)).unit(), GetRectMaxY(whichRect) + 100.0)
					endif
				
					call SetUnitX(ACharacter.playerCharacter(Player(i)).unit(), GetRectCenterX(whichRect))
					call SetUnitY(ACharacter.playerCharacter(Player(i)).unit(), GetRectCenterY(whichRect))
				endif
				set i = i + 1
			endloop
		endmethod
		
		private static method makeCharactersInvulnerable takes boolean invulnerable returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call SetUnitInvulnerable(ACharacter.playerCharacter(Player(i)).unit(), invulnerable)
				endif
				set i = i + 1
			endloop
		endmethod
		
		private static method onCheatActionAfterTalras takes ACheat cheat returns nothing
			call thistype.makeCharactersInvulnerable(true)
			if (not QuestTalras.quest.evaluate().isCompleted()) then
				if (not QuestTalras.quest.evaluate().isNew()) then
					debug call Print("New quest Talras")
					if (not QuestTalras.quest.evaluate().enable()) then
						debug call Print("Failed enabling quest Talras")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTalras.quest.evaluate().questItem(QuestTalras.questItemReachTheCastle).isCompleted()) then
					debug call Print("Complete quest item 0 Talras")
					/*
					 * Plays video "The Castle".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_talras_quest_item_0)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					if (not  QuestTalras.quest.evaluate().questItem(QuestTalras.questItemReachTheCastle).isCompleted()) then
						debug call Print("Failed completing quest item meet at reach the castle.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTalras.quest.evaluate().questItem(QuestTalras.questItemMeetHeimrich).isCompleted()) then
					debug call Print("Complete quest item 1 Talras")
					/*
					 * Plays video "The Duke of Talras".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_talras_quest_item_1)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
				endif
			endif
			call thistype.makeCharactersInvulnerable(false)
		endmethod
		
		private static method onCheatActionAfterTheNorsemen takes ACheat cheat returns nothing
			call thistype.makeCharactersInvulnerable(true)
			if (not QuestTalras.quest().isCompleted()) then
				debug call Print("Quest Talras must be completed before.")
				call thistype.makeCharactersInvulnerable(false)
				return
			endif
			/*
			 * Quest The Norsemen must be at least new now.
			 */
			if (not QuestTheNorsemen.quest.evaluate().isCompleted()) then
				if (not QuestTheNorsemen.quest.evaluate().isNew()) then
					if (not QuestTheNorsemen.quest.evaluate().enable()) then
						debug call Print("Failed enabling quest The Norsemen")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
			
				if (not QuestTheNorsemen.quest.evaluate().questItem.evaluate(QuestTheNorsemen.questItemMeetTheNorsemen).isCompleted()) then
					/*
					 * Plays video "The Chief".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_the_norsemen_quest_item_0)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					if (not  QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemMeetTheNorsemen).isCompleted()) then
						debug call Print("Failed completing quest item meet at the norsemen.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemMeetAtTheBattlefield).isCompleted()) then
					/*
					 * Plays video "The First combat".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_the_norsemen_assembly_point)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					if (not  QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemMeetAtTheBattlefield).isCompleted()) then
						debug call Print("Failed completing quest item meet at the battlefield.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemFight).isCompleted()) then
					/*
					 * TODO cleanup does not work! Remove fighting troops, disable leaderboard etc.
					 * TODO Does not change the state!
					 */
					if (QuestTheNorsemen.quest.evaluate().completeFight()) then
						
					else
						debug call Print("Failed completing quest item fight.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				
				if (not QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemMeetAtTheOutpost).isCompleted()) then
					/*
					 * Plays video "Wigberht".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_the_defense_of_talras)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					
					if (not  QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemMeetAtTheOutpost).isCompleted()) then
						debug call Print("Failed completing quest item meet at the outpost.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemReportHeimrich).isCompleted()) then
					/*
					 * Plays video "A new alliance"
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_talras_quest_item_1)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
				endif
			endif
			call thistype.makeCharactersInvulnerable(false)
		endmethod
		
		private static method onCheatActionAfterSlaughter takes ACheat cheat returns nothing
			call thistype.makeCharactersInvulnerable(true)
			if (not QuestSlaughter.quest().isCompleted()) then
				if (not QuestSlaughter.quest().isNew()) then
					if (not QuestSlaughter.quest().enable()) then
						debug call Print("Enabling quest Slaughter failed.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
			
				// TODO it would be safer to complete the single quest items
				call QuestSlaughter.quest().complete()
				call TriggerSleepAction(2.0 + 2.0)
				call waitForVideo(MapData.videoWaitInterval)
				call TriggerSleepAction(2.0 + 2.0)
			endif
			call thistype.makeCharactersInvulnerable(false)
		endmethod
		
		private static method onCheatActionAfterDeranor takes ACheat cheat returns nothing
			call thistype.makeCharactersInvulnerable(true)
			
			if (not QuestSlaughter.quest().isCompleted()) then
				debug call Print("Quest Slaughter must be completed before.")
				call thistype.makeCharactersInvulnerable(false)
				return
			endif
			
			if (not QuestDeranor.quest().isCompleted()) then
				if (not QuestDeranor.quest().isNew()) then
					if (not QuestDeranor.quest().enable()) then
						debug call Print("Enabling quest Deranor failed.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
			
				if (not QuestDeranor.quest.evaluate().questItem(QuestDeranor.questItemEnterTheTomb).isCompleted()) then
					/*
					 * Plays video "Deranor".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_deranor_characters)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					if (not QuestDeranor.quest.evaluate().questItem(QuestDeranor.questItemEnterTheTomb).isCompleted()) then
						debug call Print("Failed to complete enter the tomb.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestDeranor.quest.evaluate().questItem(QuestDeranor.questItemKillDeranor).isCompleted()) then
					/*
					 * Plays video "Deranor's Death".
					 */
					call KillUnit(gg_unit_u00A_0353)

					if (not QuestDeranor.quest.evaluate().questItem(QuestDeranor.questItemKillDeranor).isCompleted()) then
						debug call Print("Failed to complete kill deranor.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestDeranor.quest.evaluate().questItem(QuestDeranor.questItemMeetAtTomb).isCompleted()) then
					/*
					 * Plays video "Deranor's Death".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_deranor_tomb)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					if (not QuestDeranor.quest.evaluate().questItem(QuestDeranor.questItemMeetAtTomb).isCompleted()) then
						debug call Print("Failed to complete kill deranor.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
			endif
			call thistype.makeCharactersInvulnerable(false)
		endmethod
		
		/**
		 * This cheat action tries to emulate that the battle with the norseman has been done and now the quest "A new alliance" is active.
		 * Therefore the following quests have been completed:
		 * Talras
		 * The Norsemen
		 * Slaughter
		 * Deranor
		 *
		 * All events which happened by these quests must be emulated.
		 */
		private static method onCheatActionAfterTheBattle takes ACheat cheat returns nothing
			call thistype.onCheatActionAfterTalras(cheat)
			call thistype.onCheatActionAfterTheNorsemen(cheat)
			call thistype.onCheatActionAfterSlaughter(cheat)
			call thistype.onCheatActionAfterDeranor(cheat)
		endmethod
		
		private static method onCheatActionAfterANewAlliance takes ACheat cheat returns nothing
			call thistype.onCheatActionAfterTheBattle(cheat)
		
			call thistype.makeCharactersInvulnerable(true)
			
			if (not QuestDeranor.quest().isCompleted()) then
				debug call Print("Quest Deranor must be completed before.")
				call thistype.makeCharactersInvulnerable(false)
				return
			endif
			
			
			if (not QuestANewAlliance.quest().isCompleted()) then
				/*
				 * Plays video "A New Alliance".
				 */
				call thistype.moveCharactersToRect(gg_rct_quest_a_new_alliance)
				
				call TriggerSleepAction(2.0 + 2.0)
				call waitForVideo(MapData.videoWaitInterval)
				call TriggerSleepAction(2.0 + 2.0)
				if (not QuestANewAlliance.quest.evaluate().isCompleted()) then
					debug call Print("Failed to complete quest Deranor.")
					call thistype.makeCharactersInvulnerable(false)
					return
				endif
			endif
			
			call thistype.makeCharactersInvulnerable(false)
		endmethod
		
		private static method onCheatActionAfterWar takes ACheat cheat returns nothing
			local integer i = 0
			call thistype.onCheatActionAfterANewAlliance(cheat)

			call thistype.makeCharactersInvulnerable(true)
			
			if (not QuestANewAlliance.quest().isCompleted()) then
				debug call Print("Quest A New Alliance must be completed before.")
				call thistype.makeCharactersInvulnerable(false)
				return
			endif
			
			if (not QuestWar.quest.evaluate().isCompleted()) then
			
				if (not QuestWarWeaponsFromWieland.quest.evaluate().questItem(QuestWarWeaponsFromWieland.questItemWeaponsFromWieland).isCompleted()) then
					/*
					 * Plays video "Wieland".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_war_wieland)
					
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
	
					if (not QuestWarWeaponsFromWieland.quest.evaluate().questItem(QuestWarWeaponsFromWieland.questItemIronFromTheDrumCave).isCompleted()) then
						/*
						 * Plays video "Iron From The Drum Cave".
						 */
						call thistype.moveCharactersToRect(gg_rct_quest_war_iron_from_the_drum_cave)
						
						call TriggerSleepAction(2.0 + 2.0)
						call waitForVideo(MapData.videoWaitInterval)
						call TriggerSleepAction(2.0 + 2.0)
					endif
				
					if (not QuestWarWeaponsFromWieland.quest.evaluate().questItem(QuestWarWeaponsFromWieland.questItemMoveImpsToWieland).isCompleted()) then
						call QuestWarWeaponsFromWieland.quest.evaluate().moveImpsToWieland()
						if (not QuestWarWeaponsFromWieland.quest.evaluate().questItem(QuestWarWeaponsFromWieland.questItemMoveImpsToWieland).isCompleted()) then
							debug call Print("Failed to complete quest item move imps to wieland.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif

					endif
					
					if (not QuestWarWeaponsFromWieland.quest.evaluate().questItem(QuestWarWeaponsFromWieland.questItemReportWieland).isCompleted()) then
						/*
						 * Plays video "Weapons From Wieland".
						 */
						call thistype.moveCharactersToRect(gg_rct_quest_war_wieland)
						call TriggerSleepAction(2.0 + 2.0)
						call waitForVideo(MapData.videoWaitInterval)
						call TriggerSleepAction(2.0 + 2.0)
						if (not QuestWarWeaponsFromWieland.quest.evaluate().questItem(QuestWarWeaponsFromWieland.questItemReportWieland).isCompleted()) then
							debug call Print("Failed to complete quest item report wieland.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
						if (not QuestWarWeaponsFromWieland.quest.evaluate().questItem(QuestWarWeaponsFromWieland.questItemIronFromTheDrumCave).isCompleted()) then
							debug call Print("Failed to complete quest item iron from the drum cave.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif
					
					if (not QuestWarWeaponsFromWieland.quest.evaluate().questItem(QuestWarWeaponsFromWieland.questItemWaitForWielandsWeapons).isCompleted()) then
						call TriggerSleepAction(QuestWar.constructionTime + 2.0)
						
						if (not QuestWarWeaponsFromWieland.quest.evaluate().questItem(QuestWarWeaponsFromWieland.questItemWaitForWielandsWeapons).isCompleted()) then
							debug call Print("Failed to complete quest item wait for wielands weapons.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif
					
					if (not QuestWarWeaponsFromWieland.quest.evaluate().questItem(QuestWarWeaponsFromWieland.questItemMoveWielandWeaponsToTheCamp).isCompleted()) then
						/*
						 * Completes questItemMoveWielandWeaponsToTheCamp and questItemWeaponsFromWieland.
						 */
						call QuestWarWeaponsFromWieland.quest.evaluate().moveWeaponsCartToCamp()
					
						call TriggerSleepAction(1.0)
						
						if (not QuestWarWeaponsFromWieland.quest.evaluate().questItem(QuestWarWeaponsFromWieland.questItemMoveWielandWeaponsToTheCamp).isCompleted()) then
							debug call Print("Failed to complete quest item move wieland weapons to the camp.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif
					
					if (not QuestWarWeaponsFromWieland.quest.evaluate().questItem(QuestWarWeaponsFromWieland.questItemWeaponsFromWieland).isCompleted()) then
						debug call Print("Failed to complete quest item  weapons from wieland.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestWarSupplyFromManfred.quest.evaluate().questItem(QuestWarSupplyFromManfred.questItemSupplyFromManfred).isCompleted()) then
					/*
					 * Plays video "Manfred".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_war_manfred)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					
					if (not QuestWarSupplyFromManfred.quest.evaluate().questItem(QuestWarSupplyFromManfred.questItemSupplyFromManfred).isNew()) then
						debug call Print("Failed to enable quest item supply from manfred.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
					
					if (not QuestWarSupplyFromManfred.quest.evaluate().questItem(QuestWarSupplyFromManfred.questItemKillTheCornEaters).isCompleted()) then
						call SpawnPoints.cornEaters0().spawn()
						call SpawnPoints.cornEaters1().spawn()
						call SpawnPoints.cornEaters0().kill()
						call SpawnPoints.cornEaters1().kill()
					
						if (not QuestWarSupplyFromManfred.quest.evaluate().questItem(QuestWarSupplyFromManfred.questItemKillTheCornEaters).isCompleted()) then
							debug call Print("Failed to complete quest item kill the corn eaters.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif
					
					if (not QuestWarSupplyFromManfred.quest.evaluate().questItem(QuestWarSupplyFromManfred.questItemReportManfred).isCompleted()) then
						/*
						* Plays video "Report Manfred".
						*/
						call thistype.moveCharactersToRect(gg_rct_quest_war_manfred)
						call TriggerSleepAction(2.0 + 2.0)
						call waitForVideo(MapData.videoWaitInterval)
						call TriggerSleepAction(2.0 + 2.0)
						
						if (not QuestWarSupplyFromManfred.quest.evaluate().questItem(QuestWarSupplyFromManfred.questItemReportManfred).isCompleted()) then
							debug call Print("Failed to complete quest item report manfred.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif
					
					if (not QuestWarSupplyFromManfred.quest.evaluate().questItem(QuestWarSupplyFromManfred.questItemWaitForManfredsSupply).isCompleted()) then
						call TriggerSleepAction(QuestWar.constructionTime + 2.0)
						
						if (not QuestWarSupplyFromManfred.quest.evaluate().questItem(QuestWarSupplyFromManfred.questItemWaitForManfredsSupply).isCompleted()) then
							debug call Print("Failed to complete quest item wait for manfreds supply.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif
					
					if (not QuestWarSupplyFromManfred.quest.evaluate().questItem(QuestWarSupplyFromManfred.questItemMoveManfredsSupplyToTheCamp).isCompleted()) then
						call QuestWarSupplyFromManfred.quest.evaluate().moveSupplyCartToCamp()
						
						call TriggerSleepAction(1.0)
						
						if (not QuestWarSupplyFromManfred.quest.evaluate().questItem(QuestWarSupplyFromManfred.questItemMoveManfredsSupplyToTheCamp).isCompleted()) then
							debug call Print("Failed to complete quest item move manfreds supply to the camp.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif
					
					if (not QuestWarSupplyFromManfred.quest.evaluate().questItem(QuestWarSupplyFromManfred.questItemSupplyFromManfred).isCompleted()) then
						debug call Print("Failed to complete quest item supply from manfred.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestWarLumberFromKuno.quest.evaluate().questItem(QuestWarLumberFromKuno.questItemLumberFromKuno).isCompleted()) then
					/*
					 * Plays video "Kuno".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_war_kuno)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					
					if (not QuestWarLumberFromKuno.quest.evaluate().questItem(QuestWarLumberFromKuno.questItemLumberFromKuno).isNew()) then
						debug call Print("Failed to enable quest item lumber from kuno.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
					
					if (not QuestWarLumberFromKuno.quest.evaluate().questItem(QuestWarLumberFromKuno.questItemKillTheWitches).isCompleted()) then
						call SpawnPoints.witch0().spawn()
						call SpawnPoints.witch1().spawn()
						call SpawnPoints.witch2().spawn()
						call SpawnPoints.witches().spawn()
						call SpawnPoints.witch0().kill()
						call SpawnPoints.witch1().kill()
						call SpawnPoints.witch2().kill()
						call SpawnPoints.witches().kill()
						
						if (not QuestWarLumberFromKuno.quest.evaluate().questItem(QuestWarLumberFromKuno.questItemKillTheWitches).isCompleted()) then
							debug call Print("Failed to complete quest item kill the witches.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif
					
					if (not QuestWarLumberFromKuno.quest.evaluate().questItem(QuestWarLumberFromKuno.questItemReportKuno).isCompleted()) then
						/*
						 * Plays video "Report Kuno".
						 */
						call thistype.moveCharactersToRect(gg_rct_quest_war_kuno)
						call TriggerSleepAction(2.0 + 2.0)
						call waitForVideo(MapData.videoWaitInterval)
						call TriggerSleepAction(2.0 + 2.0)
						
						if (not QuestWarLumberFromKuno.quest.evaluate().questItem(QuestWarLumberFromKuno.questItemReportKuno).isCompleted()) then
							debug call Print("Failed to complete quest item report kuno.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif
					
					if (not QuestWarLumberFromKuno.quest.evaluate().questItem(QuestWarLumberFromKuno.questItemMoveKunosLumberToTheCamp).isCompleted()) then
						call QuestWarLumberFromKuno.quest.evaluate().moveLumberCartToCamp()
						
						call TriggerSleepAction(1.0)
						
						if (not QuestWarLumberFromKuno.quest.evaluate().questItem(QuestWarLumberFromKuno.questItemMoveKunosLumberToTheCamp).isCompleted()) then
							debug call Print("Failed to complete quest item report kuno.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif
					
					if (not QuestWarLumberFromKuno.quest.evaluate().questItem(QuestWarLumberFromKuno.questItemLumberFromKuno).isCompleted()) then
						debug call Print("Failed to complete quest item lumber from kuno.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestWarTrapsFromBjoern.quest.evaluate().questItem(QuestWarTrapsFromBjoern.questItemTrapsFromBjoern).isCompleted()) then
					/*
					 * Plays video "Bjoern".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_war_bjoern)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					
					if (not QuestWarTrapsFromBjoern.quest.evaluate().questItem(QuestWarTrapsFromBjoern.questItemPlaceTraps).isNew()) then
						debug call Print("Failed to enable quest item place traps.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
					
					/*
					 * NOTE Placing traps still has to be done manually.
					 */
				endif
				
				if (not QuestWarRecruit.quest.evaluate().questItem(QuestWarRecruit.questItemRecruit).isCompleted()) then
					/*
					 * Plays video "Recruit".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_war_farm)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					
					if (not QuestWarRecruit.quest.evaluate().questItem(QuestWarRecruit.questItemRecruit).isNew()) then
						debug call Print("Failed to enable quest item recruit.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
					
					set i = 0
					loop
						exitwhen (i == QuestWarRecruit.maxRecruits)
						call CreateUnit(MapData.alliedPlayer, 'n02J', GetRectCenterX(gg_rct_quest_war_cart_destination), GetRectCenterY(gg_rct_quest_war_cart_destination), 0.0)
						set i = i + 1
					endloop
					
					if (not QuestWarRecruit.quest.evaluate().questItem(QuestWarRecruit.questItemGetRecruits).isCompleted() or not QuestWarRecruit.quest.evaluate().questItem(QuestWarRecruit.questItemRecruit).isCompleted()) then
						debug call Print("Failed to complete quest item get recruits or quest item recruit.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				/*
				 * Plays video "Prepare For The Defense".
				 */
				call thistype.moveCharactersToRect(gg_rct_quest_war_heimrich)
				call TriggerSleepAction(2.0 + 2.0)
				call waitForVideo(MapData.videoWaitInterval)
				call TriggerSleepAction(2.0 + 2.0)
				
				if (not QuestWar.quest.evaluate().isCompleted()) then
					debug call Print("Failed to complete quest war.")
					call thistype.makeCharactersInvulnerable(false)
					return
				endif
			endif
			
			call thistype.makeCharactersInvulnerable(false)
		endmethod
		
		private static method onCheatActionAfterTheDefenseOfTalras takes ACheat cheat returns nothing
			local integer i = 0
			call thistype.onCheatActionAfterWar(cheat)

			call thistype.makeCharactersInvulnerable(true)
			
			if (not QuestWar.quest().isCompleted()) then
				debug call Print("Quest War must be completed before.")
				call thistype.makeCharactersInvulnerable(false)
				return
			endif
			
			if (not QuestTheDefenseOfTalras.quest.evaluate().isCompleted()) then
			
				if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemMoveToCamp).isCompleted()) then
					/*
					 * Plays video "The Defense Of Talras".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_the_defense_of_talras)
					
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					
					if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemMoveToCamp).isCompleted()) then
						debug call Print("Error on completing quest item move to camp")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemPrepare).isCompleted()) then
					call QuestTheDefenseOfTalras.quest.evaluate().finishTimer()
					
					if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemPrepare).isCompleted()) then
						debug call Print("Error on completing quest item prepare")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemDefendAgainstOrcs).isCompleted()) then
					call QuestTheDefenseOfTalras.quest.evaluate().finishDefendAgainstOrcs()
					
					if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemDefendAgainstOrcs).isCompleted()) then
						debug call Print("Error on completing quest item defend against the orcs")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemDestroyArtillery).isCompleted()) then
					call QuestTheDefenseOfTalras.quest.evaluate().finishDestroyArtillery()
					
					if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemDestroyArtillery).isCompleted()) then
						debug call Print("Error on completing quest item destroy artillery")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemGatherAtTheCamp).isCompleted()) then
					/*
					 * Plays video "Dararos".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_the_defense_of_talras)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					
					if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemGatherAtTheCamp).isCompleted()) then
						debug call Print("Error on completing quest item gather at the camp")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemDefeatTheEnemy).isCompleted()) then
					call QuestTheDefenseOfTalras.quest.evaluate().finishDefeatTheEnemy()
					
					// plays video "Victory"
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					
					if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemDefeatTheEnemy).isCompleted()) then
						debug call Print("Error on completing quest item defeat the enemy")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
				if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemReportHeimrich).isCompleted()) then
					call thistype.moveCharactersToRect(gg_rct_quest_the_defense_of_talras_heimrich)
					
					// plays video "Holzbruck"
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(MapData.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					
					if (not QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemReportHeimrich).isCompleted()) then
						debug call Print("Error on completing quest item report heimrich")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
				
			endif
			
			call thistype.makeCharactersInvulnerable(false)
		endmethod

		private static method onCheatActionUnitSpawn takes ACheat cheat returns nothing
			call UnitTypes.spawn(GetTriggerPlayer(), GetUnitX(Character.playerCharacter(GetTriggerPlayer()).unit()), GetUnitY(Character.playerCharacter(GetTriggerPlayer()).unit()))
		endmethod
		
		private static method onCheatActionTestSpawnPoint takes ACheat cheat returns nothing
			call TestSpawnPoint.spawn()
		endmethod
		
		private static method createCheats takes nothing returns nothing
			local ACheat cheat
			debug call Print(tre("|c00ffcc00TEST-MODUS|r", "|c00ffcc00TEST MODE|r"))
			debug call Print(tre("Sie befinden sich im Testmodus. Verwenden Sie den Cheat \"mapcheats\", um eine Liste sämtlicher Karten-Cheats zu erhalten.", "You are in test mode. Use the cheat \"mapcheats\" to get a list of all map cheats."))
			debug call Print("Before creating \"mapcheats\"")
			set cheat = ACheat.create("mapcheats", true, thistype.onCheatActionMapCheats)
			debug call Print("After creating \"mapcheats\": " + I2S(cheat))
			call ACheat.create("bonus", true, thistype.onCheatActionBonus)
			call ACheat.create("start", true, thistype.onCheatActionStart)
			call ACheat.create("camp", true, thistype.onCheatActionCamp)
			call ACheat.create("castle", true, thistype.onCheatActionCastle)
			call ACheat.create("talras", true, thistype.onCheatActionTalras)
			call ACheat.create("farm", true, thistype.onCheatActionFarm)
			call ACheat.create("forest", true, thistype.onCheatActionForest)
			call ACheat.create("aos", true, thistype.onCheatActionAos)
			call ACheat.create("aosentry", true, thistype.onCheatActionAosEntry)
			call ACheat.create("tavern", true, thistype.onCheatActionTavern)
			call ACheat.create("tomb", true, thistype.onCheatActionTomb)
			call ACheat.create("orccamp", true, thistype.onCheatActionOrcCamp)
			// videos
			call ACheat.create("intro", true, thistype.onCheatActionIntro)
			call ACheat.create("rescuedago0", true, thistype.onCheatActionRescueDago0)
			call ACheat.create("rescuedago1", true, thistype.onCheatActionRescueDago1)
			call ACheat.create("thecastle", true, thistype.onCheatActionTheCastle)
			call ACheat.create("thedukeoftalras", true, thistype.onCheatActionTheDukeOfTalras)
			call ACheat.create("thechief", true, thistype.onCheatActionTheChief)
			call ACheat.create("thefirstcombat", true, thistype.onCheatActionTheFirstCombat)
			call ACheat.create("wigberht", true, thistype.onCheatActionWigberht)
			call ACheat.create("anewalliance", true, thistype.onCheatActionANewAlliance)
			call ACheat.create("dragonhunt", true, thistype.onCheatActionDragonHunt)
			call ACheat.create("deathvault", true, thistype.onCheatActionDeathVault)
			call ACheat.create("bloodthirstiness", true, thistype.onCheatActionBloodthirstiness)
			call ACheat.create("deranor", true, thistype.onCheatActionDeranor)
			call ACheat.create("deranorsdeath", true, thistype.onCheatActionDeranorsDeath)
			call ACheat.create("recruitthehighelf", true, thistype.onCheatActionRecruitTheHighElf)
			call ACheat.create("prepareforthedefense", true, thistype.onCheatActionPrepareForTheDefense)
			call ACheat.create("thedefenseoftalras", true, thistype.onCheatActionTheDefenseOfTalras)
			call ACheat.create("dararos", true, thistype.onCheatActionDararos)
			call ACheat.create("victory", true, thistype.onCheatActionVictory)
			call ACheat.create("holzbruck", true, thistype.onCheatActionHolzbruck)
			call ACheat.create("upstream", true, thistype.onCheatActionUpstream)
			// plot cheats
			call ACheat.create("aftertalras", true, thistype.onCheatActionAfterTalras)
			call ACheat.create("afterthenorsemen", true, thistype.onCheatActionAfterTheNorsemen)
			call ACheat.create("afterslaughter", true, thistype.onCheatActionAfterSlaughter)
			call ACheat.create("afterderanor", true, thistype.onCheatActionAfterDeranor)
			call ACheat.create("afterthebattle", true, thistype.onCheatActionAfterTheBattle)
			call ACheat.create("afteranewalliance", true, thistype.onCheatActionAfterANewAlliance)
			call ACheat.create("afterwar", true, thistype.onCheatActionAfterWar)
			call ACheat.create("afterthedefenseoftalras", true, thistype.onCheatActionAfterTheDefenseOfTalras)
			// test cheats
			call ACheat.create("unitspawn", true, thistype.onCheatActionUnitSpawn)
			call ACheat.create("testspawnpoint", true, thistype.onCheatActionTestSpawnPoint)
			debug call Print("Before creating all cheats")
		endmethod
endif

		private static method timerFunctionThunder takes nothing returns nothing
			local integer i
			// don't create thunder effect if it is not raining anymore or the rain stops in a few seconds
			if (thistype.m_rainWeatherEffect != null and TimerGetRemaining(thistype.m_resetRainTimer) > 5.0) then
				set i = 0
				loop
					exitwhen (i == MapData.maxPlayers)
					if (GetLocalPlayer() == Player(i)) then
						// only play thunder if view is in playable area where it rains
						if (GetCameraTargetPositionX() <= GetRectMaxX(gg_rct_area_playable) and GetCameraTargetPositionX() >= GetRectMinX(gg_rct_area_playable) and GetCameraTargetPositionY() <= GetRectMaxY(gg_rct_area_playable) and GetCameraTargetPositionY() >= GetRectMinY(gg_rct_area_playable)) then
							call StartSound(gg_snd_RollingThunder1)
							call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUTIN, 0.10, "ReplaceableTextures\\CameraMasks\\White_mask.blp", 100.0, 100.0, 100.0, 0)
						endif
					endif
					set i = i + 1
				endloop

				call thistype.startThunderCountdown.evaluate()
			endif
		endmethod
		
		private static method timerFunctionRestartRain takes nothing returns nothing
			call RemoveWeatherEffect(thistype.m_rainWeatherEffect)
			set thistype.m_rainWeatherEffect = null
			
			call thistype.startRainCountdown.evaluate()
		endmethod

		private static method timerFunctionRain takes nothing returns nothing
			local integer random = GetRandomInt(0, 1)
			if (random == 0) then
				set thistype.m_rainWeatherEffect = AddWeatherEffect(gg_rct_area_playable, 'RLlr')
			else
				set thistype.m_rainWeatherEffect = AddWeatherEffect(gg_rct_area_playable, 'RLhr')
			endif
			call EnableWeatherEffect(thistype.m_rainWeatherEffect, true)
			
			call thistype.startThunderCountdown.evaluate()
			call TimerStart(thistype.m_resetRainTimer, GetRandomReal(45.0, 60.0), false, function thistype.timerFunctionRestartRain)
		endmethod
		
		private static method startThunderCountdown takes nothing returns nothing
			call TimerStart(thistype.m_thunderTimer, GetRandomReal(15.0, 20.0), false, function thistype.timerFunctionThunder)
		endmethod
		
		private static method startRainCountdown takes nothing returns nothing
			call TimerStart(thistype.m_rainTimer, GetRandomReal(120.0, 180.0), false, function thistype.timerFunctionRain)
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
			
			call thistype.startRainCountdown()
			
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

			debug call thistype.createCheats()
			
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
			if (thistype.m_rainWeatherEffect != null) then
				call EnableWeatherEffect(thistype.m_rainWeatherEffect, false)
				call PauseTimer(thistype.m_thunderTimer)
			else
				call PauseTimer(thistype.m_rainTimer)
			endif
		endmethod
		
		public static method resetVideoSettings takes nothing returns nothing
			if (thistype.m_rainWeatherEffect != null) then
				call EnableWeatherEffect(thistype.m_rainWeatherEffect, true)
				call ResumeTimer(thistype.m_thunderTimer)
			else
				call ResumeTimer(thistype.m_rainTimer)
			endif
		endmethod
	endstruct

endlibrary