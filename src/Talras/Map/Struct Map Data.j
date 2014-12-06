library StructMapMapMapData requires Asl, StructGameCharacter, StructGameGame, StructMapMapShrines, StructMapMapNpcRoutines, StructMapQuestsQuestTalras, StructMapQuestsQuestTheNorsemen, MapVideos

	//! inject config
		/// @todo tr leads to crash
		call SetMapName("Talras") // Game.mapName("Talras")
		call SetMapDescription("Wählen Sie zunächst Ihre Charakterklasse aus. Diese Auswahl ist für die restliche Spielzeit unwiderruflich.\n- Drücken Sie die linke oder rechte Pfeiltaste, um die angezeigte Charakterklasse zu wechseln.\n- Drücken Sie die Escape-Taste, um die angezeigte Charakterklasse auszuwählen.")
		call SetPlayers(9)
		call SetTeams(9)
		call SetGamePlacement(MAP_PLACEMENT_TEAMS_TOGETHER)

		call DefineStartLocation( 0, -22592.0, 18944.0 )
		call DefineStartLocation( 1, -22592.0, 18944.0 )
		call DefineStartLocation( 2, -22592.0, 18944.0 )
		call DefineStartLocation( 3, -22592.0, 18944.0 )
		call DefineStartLocation( 4, -22592.0, 18944.0 )
		call DefineStartLocation( 5, -22592.0, 18944.0 )
		call DefineStartLocation( 6, -22592.0, 18944.0 )
		call DefineStartLocation( 7, -22592.0, 18944.0 )
		call DefineStartLocation( 8, -22592.0, 18944.0 )
		// Player setup
		call InitCustomPlayerSlots()
		call InitCustomTeams()
		call InitAllyPriorities()

		call PlayMusic("Music\\LoadingScreen.mp3") /// WARNING: If file does not exist, game crashes?
	//! endinject

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
		public static constant string mapMusic = "Music\\Ingame.mp3;Music\\Talras.mp3"
		public static constant integer maxPlayers = 6
		public static constant integer computerPlayers = 1 // one additional player for the arena and the last quest
		public static constant player alliedPlayer = Player(6)
		public static constant player neutralPassivePlayer = Player(7)
		public static constant real morning = 6.0
		public static constant real midday = 12.0
		public static constant real afternoon = 16.0
		public static constant real evening = 18.0
		public static constant real videoWaitInterval = 1.0
		public static constant real revivalTime = 20.0
		public static constant integer startSkillPoints = 3
		public static constant integer levelSpellPoints = 2
		public static constant integer maxLevel = 25
		public static constant integer difficultyStartAttributeBonus = 4 // start attribute bonus per missing player
		public static constant integer difficultyLevelAttributeBonus = 2 // level up attribute bonus per missing player
		public static constant integer workerUnitTypeId = 'h00E'
		
		private static region m_welcomeRegion
		private static trigger m_welcomeTalrasTrigger

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
			call TransmissionFromUnitWithNameBJ(humans, gg_unit_n015_0149, tr("Krieger"), null, tr("Willkommen in Talras!"), bj_TIMETYPE_ADD, 0.0, false)
			call DisableTrigger(GetTriggeringTrigger())
			call DestroyForce(humans)
			set humans = null
			call RemoveRegion(thistype.m_welcomeRegion)
			set thistype.m_welcomeRegion = null
			call DestroyTrigger(GetTriggeringTrigger())
		endmethod

		/// Required by \ref Game.
		public static method init takes nothing returns nothing
			call Aos.init.evaluate()
			call Arena.init(GetRectCenterX(gg_rct_arena_outside), GetRectCenterY(gg_rct_arena_outside), 0.0, tr("Sie haben die Arena betreten."), tr("Sie haben die Arena verlassen."), tr("Ein Arenakampf beginnt nun."), tr("Ein Arenakampf endet nun. Der Gewinner ist \"%s\"."))
			call Arena.addRect(gg_rct_arena_0)
			call Arena.addRect(gg_rct_arena_1)
			call Arena.addRect(gg_rct_arena_2)
			call Arena.addRect(gg_rct_arena_3)
			call Arena.addRect(gg_rct_arena_4)
			call Arena.addStartPoint(GetRectCenterX(gg_rct_arena_enemy_0), GetRectCenterY(gg_rct_arena_enemy_0), 180.0)
			call Arena.addStartPoint(GetRectCenterX(gg_rct_arena_enemy_1), GetRectCenterY(gg_rct_arena_enemy_1), 0.0)
			call Layers.init()
			call Markers.init()
static if (DMDF_NPC_ROUTINES) then
			call NpcRoutines.init()
endif
			call Shrines.init()
			call SpawnPoints.init()
			call initMapSpells.evaluate()
			call initMapTalks.evaluate()
			call initMapVideos()
			call Fellows.init()
			// weather
			call Game.weather().setMinimumChangeTime(20.0)
			call Game.weather().setMaximumChangeTime(60.0)
			call Game.weather().setChangeSky(false) // TODO prevent lags?
			call Game.weather().setWeatherTypeAllowed(AWeather.weatherTypeLordaeronRainHeavy, true)
			call Game.weather().setWeatherTypeAllowed(AWeather.weatherTypeLordaeronRainLight, true)
			call Game.weather().setWeatherTypeAllowed(AWeather.weatherTypeNoWeather, true)
			call Game.weather().addRect(gg_rct_area_playable)
			
			set thistype.m_welcomeTalrasTrigger = CreateTrigger()
			set thistype.m_welcomeRegion = CreateRegion()
			call RegionAddRect(thistype.m_welcomeRegion, gg_rct_quest_talras_quest_item_0)
			call TriggerRegisterEnterRegion(thistype.m_welcomeTalrasTrigger, thistype.m_welcomeRegion, null)
			call TriggerAddCondition(thistype.m_welcomeTalrasTrigger, Condition(function thistype.triggerConditionWelcomeTalras))
			call TriggerAddAction(thistype.m_welcomeTalrasTrigger, function thistype.triggerActionWelcomeTalras)
		endmethod

static if (DEBUG_MODE) then
		private static method onCheatActionMapCheats takes ACheat cheat returns nothing
			call Print(tr("Örtlichkeiten-Cheats:"))
			call Print("bonus")
			call Print("start")
			call Print("castle")
			call Print("talras")
			call Print("farm")
			call Print("forest")
			call Print("aos")
			call Print("aosentry")
			call Print(tr("Video-Cheats:"))
			call Print("intro")
			call Print("rescuedago0")
			call Print("rescuedago1")
			call Print("thecastle")
			call Print("thedukeoftalras")
			call Print("thechief")
			call Print("thefirstcombat")
			call Print("wigberht")
			call Print("anewalliance")
			call Print("upstream")
			call Print("dragonhunt")
			call Print("deathvault")
			call Print("bloodthirstiness")
			call Print(tr("Erzeugungs-Cheats:"))
			call Print("unitspawns")
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
			set whichPlayer = null
		endmethod

		private static method onCheatActionCamp takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_camp)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			set whichPlayer = null
		endmethod

		private static method onCheatActionCastle takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_castle)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			set whichPlayer = null
		endmethod

		private static method onCheatActionTalras takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_talras)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			set whichPlayer = null
		endmethod

		private static method onCheatActionFarm takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_farm)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			set whichPlayer = null
		endmethod

		private static method onCheatActionForest takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_forest)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			set whichPlayer = null
		endmethod

		private static method onCheatActionAos takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_shrine_1_discover)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			set whichPlayer = null
		endmethod

		private static method onCheatActionAosEntry takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_aos_outside)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			set whichPlayer = null
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

		private static method onCheatActionUpstream takes ACheat cheat returns nothing
			call VideoUpstream.video().play()
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

		private static method onCheatActionUnitSpawn takes ACheat cheat returns nothing
			call UnitTypes.spawn(GetTriggerPlayer(), GetUnitX(Character.playerCharacter(GetTriggerPlayer()).unit()), GetUnitY(Character.playerCharacter(GetTriggerPlayer()).unit()))
		endmethod
endif

		/// Required by \ref Game.
		public static method start takes nothing returns nothing
			local integer i
			call BJDebugMsg("Before primary quests")
			call initMapPrimaryQuests()
			call BJDebugMsg("Before secundary quests")
			call initMapSecundaryQuests()
			call BJDebugMsg("Before map spells")
			set i = 0
			loop
				exitwhen (i == thistype.maxPlayers)
				call initMapCharacterSpells.evaluate(ACharacter.playerCharacter(Player(i)))
				set i = i + 1
			endloop
			call VideoIntro.video().play()
			call waitForVideo(thistype.videoWaitInterval)
static if (DEBUG_MODE) then
			call Print(tr("|c00ffcc00TEST-MODUS|r"))
			call Print(tr("Sie befinden sich im Testmodus. Verwenden Sie den Cheat \"mapcheats\", um eine Liste sämtlicher Karten-Cheats zu erhalten."))
			call ACheat.create("mapcheats", true, thistype.onCheatActionMapCheats)
			call ACheat.create("bonus", true, thistype.onCheatActionBonus)
			call ACheat.create("start", true, thistype.onCheatActionStart)
			call ACheat.create("camp", true, thistype.onCheatActionCamp)
			call ACheat.create("castle", true, thistype.onCheatActionCastle)
			call ACheat.create("talras", true, thistype.onCheatActionTalras)
			call ACheat.create("farm", true, thistype.onCheatActionFarm)
			call ACheat.create("forest", true, thistype.onCheatActionForest)
			call ACheat.create("aos", true, thistype.onCheatActionAos)
			call ACheat.create("aosentry", true, thistype.onCheatActionAosEntry)
			call ACheat.create("intro", true, thistype.onCheatActionIntro)
			call ACheat.create("rescuedago0", true, thistype.onCheatActionRescueDago0)
			call ACheat.create("rescuedago1", true, thistype.onCheatActionRescueDago1)
			call ACheat.create("thecastle", true, thistype.onCheatActionTheCastle)
			call ACheat.create("thedukeoftalras", true, thistype.onCheatActionTheDukeOfTalras)
			call ACheat.create("thechief", true, thistype.onCheatActionTheChief)
			call ACheat.create("thefirstcombat", true, thistype.onCheatActionTheFirstCombat)
			call ACheat.create("wigberht", true, thistype.onCheatActionWigberht)
			call ACheat.create("anewalliance", true, thistype.onCheatActionANewAlliance)
			call ACheat.create("upstream", true, thistype.onCheatActionUpstream)
			call ACheat.create("dragonhunt", true, thistype.onCheatActionDragonHunt)
			call ACheat.create("deathvault", true, thistype.onCheatActionDeathVault)
			call ACheat.create("bloodthirstiness", true, thistype.onCheatActionBloodthirstiness)
			call ACheat.create("unitspawn", true, thistype.onCheatActionUnitSpawn)
endif
			call BJDebugMsg("Setting all movable")
			call ACharacter.setAllMovable(true) // set movable since they weren't before after class selection (before video)
			call BJDebugMsg("After movable")
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, tr("Drücken Sie die Escape-Taste, um ins Haupt-Menü zu gelangen."))
			call ACharacter.panCameraSmartToAll()
			call ACharacter.enableShrineForAll(Shrines.startShrine(), false)
			call BJDebugMsg("Quest talras id " + I2S(QuestTalras.quest()))
			call QuestTalras.quest().enable()
			// start weapons
			set i = 0
			loop
				exitwhen (i == thistype.maxPlayers)
				call UnitAddItemById(ACharacter.playerCharacter(Player(i)).unit(), ItemTypes.shortword().itemType())
				call UnitAddItemById(ACharacter.playerCharacter(Player(i)).unit(), ItemTypes.lightWoodenShield().itemType())
				set i = i + 1
			endloop

			call NpcRoutines.manualStart() // necessary since at the beginning time of day events might not have be called
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

		public static method setCameraBoundsToMapForPlayer takes player user returns nothing
			call ResetCameraBoundsToMapRectForPlayer(user)
		endmethod

		/// Required by \ref Classes.
		public static method setCameraBoundsToPlayableAreaForPlayer takes player user returns nothing
			call SetCameraBoundsToRectForPlayerBJ(user, gg_rct_area_playable)
		endmethod

		public static method setCameraBoundsToTavernForPlayer takes player user returns nothing
			call SetCameraBoundsToRectForPlayerBJ(user, gg_rct_area_tavern)
		endmethod

		public static method setCameraBoundsToAosForPlayer takes player user returns nothing
			call SetCameraBoundsToRectForPlayerBJ(user, gg_rct_area_aos)
		endmethod

		public static method setCameraBoundsToFightAreaForPlayer takes player user returns nothing
			call SetCameraBoundsToRectForPlayerBJ(user, gg_rct_quest_the_norsemen_fight_area)
		endmethod

		/// Required by \ref Game.
		public static method resetCameraBoundsForPlayer takes player user returns nothing
			if (Aos.areaContainsCharacter.evaluate(ACharacter.playerCharacter(user))) then
				call thistype.setCameraBoundsToAosForPlayer(user)
			elseif (false) then /// @todo Tavern area
				call thistype.setCameraBoundsToTavernForPlayer(user)
			elseif (QuestTheNorsemen.quest().hasStarted()) then
				call thistype.setCameraBoundsToFightAreaForPlayer(user)
			else
				call thistype.setCameraBoundsToPlayableAreaForPlayer(user)
			endif
		endmethod
	endstruct

endlibrary