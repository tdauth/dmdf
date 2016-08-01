library StructMapMapMapData requires Asl, StructGameGame, StructMapMapShrines, StructMapQuestsQuestPalace, StructMapVideosVideoIntro

	struct MapData extends MapDataInterface
		public static constant string mapName = "Gardonar0.8"
		public static constant string mapMusic = "Sound\\Music\\mp3Music\\War3XMainScreen.mp3"
		public static constant integer maxPlayers = 6
		public static constant player alliedPlayer = Player(6)
		public static constant player neutralPassivePlayer = Player(PLAYER_NEUTRAL_PASSIVE)
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
		public static constant boolean isSeparateChapter = false
		public static sound cowSound = null
		// Zones which can be reached directly from this map.
		private static Zone m_zoneTalras
		private static Zone m_zoneGardonarsHell
		// Multiplayer only
		private static trigger m_winTrigger
		
		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod
		
		private static method triggerConditionWin takes nothing returns boolean
			if (GetOwningPlayer(GetTriggerUnit()) == GetLocalPlayer()) then
				call EndGame(true)
			endif
			return false
		endmethod
		
		/// Required by \ref Game.
		// TODO split up in multiple trigger executions to avoid OpLimit, .evaluate doesn't seem to work.
		public static method init takes nothing returns nothing
			// player should look like neutral passive
			call SetPlayerColor(MapData.neutralPassivePlayer, ConvertPlayerColor(PLAYER_NEUTRAL_PASSIVE))
			
			call Shrines.init()
			call ForForce(bj_FORCE_PLAYER[0], function SpawnPoints.init)
			call ForForce(bj_FORCE_PLAYER[0], function Fellows.init) // init after talks (new)
			call initMapVideos.evaluate()
			
			set thistype.m_zoneTalras = Zone.create("Talras" + Game.gameVersion, gg_rct_zone_talras)
			set thistype.m_zoneGardonarsHell = Zone.create("GardonarsHell" + Game.gameVersion, gg_rct_zone_gardonars_hell)
			
			// in single player campaigns the player can continue the game in the next level
			if (not bj_isSinglePlayer or not Game.isCampaign.evaluate()) then
				set thistype.m_winTrigger = CreateTrigger()
				call TriggerRegisterEnterRectSimple(thistype.m_winTrigger, gg_rct_zone_gardonars_hell)
				call TriggerAddCondition(thistype.m_winTrigger, Condition(function thistype.triggerConditionWin))
			endif

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

		/// Required by \ref Game.
		public static method resetCameraBoundsForPlayer takes player user returns nothing
		endmethod
		
		/// Required by \ref Game.
		public static method initMapSpells takes ACharacter character returns nothing
		endmethod
		
		/// Required by \ref Game.
		public static method onStart takes nothing returns nothing
			call SuspendTimeOfDay(true)
			call SetTimeOfDay(0.0)
		endmethod
		
		/// Required by \ref ClassSelection.
		public static method onSelectClass takes Character character, AClass class, boolean last returns nothing
		endmethod
		
		/// Required by \ref ClassSelection.
		public static method onRepick takes Character character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method start takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.maxPlayers)
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
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, tre("Geben Sie \"-menu\" im Chat ein, um ins Haupt-Menü zu gelangen.", "Enter \"-menu\" into the chat to reach the main menu."))
			call ACharacter.panCameraSmartToAll()
			call ACharacter.enableShrineForAll(Shrines.startShrine(), false)
			
			call Fellows.wigberht().shareWithAll()
			call Fellows.ricman().shareWithAll()
			call Fellows.dragonSlayer().shareWithAll()
			
			call QuestPalace.quest().enable()

			//call NpcRoutines.manualStart() // necessary since at the beginning time of day events might not have be called
			
			// execute because of trigger sleep action
			call Game.applyHandicapToCreeps.execute()
		endmethod

		/// Required by \ref Classes.
		public static method startX takes integer index returns real
			return GetRectCenterX(gg_rct_start)
		endmethod

		/// Required by \ref Classes.
		public static method startY takes integer index returns real
			return GetRectCenterY(gg_rct_start)
		endmethod
		
		/// Required by \ref MapChanger.
		public static method restoreStartX takes integer index, string zone returns real
			debug call Print("From Zone: " + zone)
			if (zone == "Talras" + Game.gameVersion) then
				return GetRectCenterX(gg_rct_start)
			endif
			
			return GetRectCenterX(gg_rct_start_hell)
		endmethod

		/// Required by \ref MapChanger.
		public static method restoreStartY takes integer index, string zone returns real
			if (zone == "Talras" + Game.gameVersion) then
				return GetRectCenterY(gg_rct_start)
			endif
			
			return GetRectCenterY(gg_rct_start_hell)
		endmethod
		
		/// Required by \ref MapChanger.
		public static method restoreStartFacing takes integer index, string zone returns real
			return 90.0
		endmethod
		
		/**
		 * \return Returns true if characters gain experience from killing units of player \p whichPlayer. Otherwise it returns false.
		 */
		public static method playerGivesXP takes player whichPlayer returns boolean
			return whichPlayer == Player(PLAYER_NEUTRAL_AGGRESSIVE)
		endmethod
		
		public static method initVideoSettings takes nothing returns nothing
		endmethod
		
		public static method resetVideoSettings takes nothing returns nothing
		endmethod
	endstruct

endlibrary