library StructMapMapMapData requires Asl, StructGameGame

	struct MapData extends MapDataInterface
		public static constant string mapName = "Holzbruck0.8"
		public static constant string mapMusic = "Music\\Ingame.mp3;Music\\Talras.mp3"
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

		private static Zone m_zoneTalras
		private static Zone m_zoneGardonar
		
		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod
		
		/// Required by \ref Game.
		// TODO split up in multiple trigger executions to avoid OpLimit, .evaluate doesn't seem to work.
		public static method init takes nothing returns nothing
			// player should look like neutral passive
			call SetPlayerColor(MapData.neutralPassivePlayer, ConvertPlayerColor(PLAYER_NEUTRAL_PASSIVE))
			
			set thistype.m_zoneTalras = Zone.create("Talras" + Game.gameVersion, gg_rct_zone_talras)
			set thistype.m_zoneGardonar = Zone.create("Gardonar" + Game.gameVersion, gg_rct_zone_gardonar)
			
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

		/// Required by \ref Game.
		public static method start takes nothing returns nothing
			local integer i
			
			call SuspendTimeOfDay(false)
			call SetMapFlag(MAP_FOG_HIDE_TERRAIN, false)
			call SetMapFlag(MAP_FOG_ALWAYS_VISIBLE, true)
			call SetMapFlag(MAP_FOG_MAP_EXPLORED, true)
			call FogMaskEnableOff()
			call FogEnableOff()
			
			set i = 0
			loop
				exitwhen (i == thistype.maxPlayers)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call ACharacter.playerCharacter(Player(i)).setMovable(true)
					call SelectUnitForPlayerSingle(ACharacter.playerCharacter(Player(i)).unit(), Player(i))
				endif
				set i = i + 1
			endloop
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
			if (zone == "GardonarsHell" + Game.gameVersion) then
				return GetRectCenterX(gg_rct_start_hell)
			endif
			
			return GetRectCenterX(gg_rct_start_talras)
		endmethod

		/// Required by \ref MapChanger.
		public static method restoreStartY takes integer index, string zone returns real
			if (zone == "GardonarsHell" + Game.gameVersion) then
				return GetRectCenterY(gg_rct_start_hell)
			endif
			
			return GetRectCenterY(gg_rct_start_talras)
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