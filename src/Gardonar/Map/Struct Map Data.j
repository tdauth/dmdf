library StructMapMapMapData requires Asl, Game, StructMapMapShrines, StructMapQuestsQuestPalace, StructMapVideosVideoIntro

	struct MapData
		// Zones which can be reached directly from this map.
		private static Zone m_zoneTalras
		private static Zone m_zoneGardonarsHell
		// Multiplayer only
		private static trigger m_winTrigger

		private static timer m_zombieTimer
		private static integer m_waveCounter = 0
		private static trigger m_zombieTrigger

		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// Required by \ref Game.
		public static method initSettings takes nothing returns nothing
			call MapSettings.setMapName("GA")
			call MapSettings.setMapMusic("Sound\\Music\\mp3Music\\War3XMainScreen.mp33")
			call MapSettings.setGoldmine(gg_unit_n06E_0161)
			call MapSettings.addZoneRestorePositionForAllPlayers("WM", GetRectCenterX(gg_rct_start), GetRectCenterY(gg_rct_start), 90.0)
			call MapSettings.addZoneRestorePositionForAllPlayers("TL", GetRectCenterX(gg_rct_start), GetRectCenterY(gg_rct_start), 90.0)
			call MapSettings.addZoneRestorePositionForAllPlayers("GH", GetRectCenterX(gg_rct_start_hell), GetRectCenterY(gg_rct_start_hell), 90.0)
		endmethod

		private static method triggerConditionWin takes nothing returns boolean
			if (GetOwningPlayer(GetTriggerUnit()) == GetLocalPlayer()) then
				call EndGame(true)
			endif
			return false
		endmethod

		private static method zombieSpawn takes nothing returns nothing
			local unit zombie = null
			local integer i = 0
			loop
				exitwhen (i == 40)
				set zombie = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), 'n02M', GetRandomReal(GetRectMinX(gg_rct_zombies), GetRectMaxX(gg_rct_zombies)), GetRandomReal(GetRectMinY(gg_rct_zombies), GetRectMaxY(gg_rct_zombies)), 0.0)
				call SetUnitPathing(zombie, false)
				call SetUnitAnimation(zombie, "Birth")
				set i = i + 1
			endloop
			set thistype.m_waveCounter = thistype.m_waveCounter + 1
			call StartSound(gg_snd_SoulPreservation)

			if (thistype.m_waveCounter >= 10) then
				call PauseTimer(GetExpiredTimer())
				call DestroyTimer(GetExpiredTimer())
			endif
		endmethod

		private static method triggerConditionZombies takes nothing returns boolean
			if (ACharacter.isUnitCharacter(GetTriggerUnit())) then
				call TimerStart(thistype.m_zombieTimer, 8.0, true, function thistype.zombieSpawn)
				call Character.displayWarningToAll(tre("Die Toten erwachen.", "The deads are awakening."))
				call thistype.zombieSpawn()
				call DisableTrigger(GetTriggeringTrigger())
			endif
			return false
		endmethod

		/// Required by \ref Game.
		// TODO split up in multiple trigger executions to avoid OpLimit, .evaluate doesn't seem to work.
		public static method init takes nothing returns nothing
			call Shrines.init()
			call NewOpLimit(function SpawnPoints.init)
			call NewOpLimit(function Fellows.init) // init after talks (new)
			call initMapVideos.evaluate()

			set thistype.m_zoneTalras = Zone.create("TL", gg_rct_zone_talras)
			set thistype.m_zoneGardonarsHell = Zone.create("GH", gg_rct_zone_gardonars_hell)

			// in single player campaigns the player can continue the game in the next level
			if (not bj_isSinglePlayer or not Game.isCampaign.evaluate()) then
				set thistype.m_winTrigger = CreateTrigger()
				call TriggerRegisterEnterRectSimple(thistype.m_winTrigger, gg_rct_zone_gardonars_hell)
				call TriggerAddCondition(thistype.m_winTrigger, Condition(function thistype.triggerConditionWin))
			endif

			set thistype.m_zombieTimer = CreateTimer()
			set thistype.m_zombieTrigger = CreateTrigger()
			call TriggerRegisterEnterRectSimple(thistype.m_zombieTrigger, gg_rct_zombies)
			call TriggerAddCondition(thistype.m_zombieTrigger, Condition(function thistype.triggerConditionZombies))

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

		/// Required by \ref Game.
		public static method onInitMapSpells takes ACharacter character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method onStart takes nothing returns nothing
			call SuspendTimeOfDay(true)
			call SetTimeOfDay(0.0)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onSelectClass takes Character character, AClass class, boolean last returns nothing
			call SetUnitX(character.unit(), GetRectCenterX(gg_rct_start))
			call SetUnitY(character.unit(), GetRectCenterY(gg_rct_start))
			call SetUnitFacing(character.unit(), 90.0)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onRepick takes Character character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method start takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call ACharacter.playerCharacter(Player(i)).setMovable(true)
					call SelectUnitForPlayerSingle(ACharacter.playerCharacter(Player(i)).unit(), Player(i))
				endif
				set i = i + 1
			endloop

			call initMapPrimaryQuests()
			call initMapSecundaryQuests()

			call SuspendTimeOfDay(false)

			call VideoIntro.video().play()
		endmethod

		public static method startAfterIntro takes nothing returns nothing
			debug call Print("Waited successfully for intro video.")

			call ACharacter.setAllMovable(true) // set movable since they weren't before after class selection (before video)
			call ACharacter.panCameraSmartToAll()
			call ACharacter.enableShrineForAll(Shrines.startShrine(), false)

			call Fellows.wigberht().shareWithAll()
			call Fellows.ricman().shareWithAll()
			call Fellows.dragonSlayer().shareWithAll()

			call QuestPalace.quest().enable()

			//call NpcRoutines.manualStart() // necessary since at the beginning time of day events might not have be called

			call Game.applyHandicapToCreeps()
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