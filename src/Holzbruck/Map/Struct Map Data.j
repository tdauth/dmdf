library StructMapMapMapData requires Asl, StructGameGame

	struct MapData extends MapDataInterface
		public static constant string mapMusic = "Music\\Ingame.mp3;Music\\Talras.mp3"
		public static constant integer maxPlayers = 6
		public static constant player alliedPlayer = Player(6)
		public static constant player neutralPassivePlayer = Player(PLAYER_NEUTRAL_PASSIVE)
		public static constant real morning = 5.0
		public static constant real midday = 12.0
		public static constant real afternoon = 16.0
		public static constant real evening = 18.0
		public static constant real videoWaitInterval = 1.0
		public static constant real revivalTime = 5.0
		public static constant real revivalLifePercentage = 100.0
		public static constant real revivalManaPercentage = 100.0
		public static constant integer startSkillPoints = 3
		public static constant integer levelSpellPoints = 2
		public static constant integer maxLevel = 25
		public static constant integer workerUnitTypeId = 'h00E'
		
		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod
		
		/// Required by \ref Game.
		// TODO split up in multiple trigger executions to avoid OpLimit, .evaluate doesn't seem to work.
		public static method init takes nothing returns nothing
			// weather
			call Game.weather().setMinimumChangeTime(20.0)
			call Game.weather().setMaximumChangeTime(60.0)
			call Game.weather().setChangeSky(false) // TODO prevent lags?
			call Game.weather().setWeatherTypeAllowed(AWeather.weatherTypeLordaeronRainHeavy, true)
			call Game.weather().setWeatherTypeAllowed(AWeather.weatherTypeLordaeronRainLight, true)
			call Game.weather().setWeatherTypeAllowed(AWeather.weatherTypeNoWeather, true)
			call Game.weather().addRect(gg_rct_area_playable)
			
			// player should look like neutral passive
			call SetPlayerColor(MapData.neutralPassivePlayer, ConvertPlayerColor(PLAYER_NEUTRAL_PASSIVE))
			
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
		 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
		 */
		public static method createClassSelectionItems takes AClass class, unit whichUnit returns nothing
			if (class == Classes.ranger()) then
				// Hunting Bow
				call UnitAddItemById(whichUnit, 'I020')
			elseif (class == Classes.cleric() or class == Classes.necromancer() or class == Classes.elementalMage() or class == Classes.wizard()) then	
				// Haunted Staff
				call UnitAddItemById(whichUnit, 'I03V')
			else
				call UnitAddItemById(whichUnit, ItemTypes.shortword().itemType())
				call UnitAddItemById(whichUnit, ItemTypes.lightWoodenShield().itemType())
			endif
			// scroll of death to teleport from the beginning, otherwise characters must walk long ways
			call UnitAddItemById(whichUnit, 'I01N')
			
			call UnitAddItemById(whichUnit, 'I00A')
			call UnitAddItemById(whichUnit, 'I00D')
		endmethod
		
		/**
		 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
		 */
		public static method createClassItems takes AClass class, unit whichUnit returns nothing
			call thistype.createClassSelectionItems(class, whichUnit)
			call UnitAddItemById(whichUnit, 'I00A')
			call UnitAddItemById(whichUnit, 'I00A')
			call UnitAddItemById(whichUnit, 'I00A')
			call UnitAddItemById(whichUnit, 'I00D')
			call UnitAddItemById(whichUnit, 'I00D')
			call UnitAddItemById(whichUnit, 'I00D')
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
		public static method start takes nothing returns nothing
			local integer i
			
			call SetMapFlag(MAP_FOG_HIDE_TERRAIN, false)
			call SetMapFlag(MAP_FOG_ALWAYS_VISIBLE, true)
			call SetMapFlag(MAP_FOG_MAP_EXPLORED, true)
			call FogMaskEnableOff()
			call FogEnableOff()
			
			// tutorial GUI, after creating quests. Should be listed at the bottom of finished quests.
			call Tutorial.init.evaluate()
			
			set i = 0
			loop
				exitwhen (i == thistype.maxPlayers)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call ACharacter.playerCharacter(Player(i)).setMovable(true)
					call SelectUnitForPlayerSingle(ACharacter.playerCharacter(Player(i)).unit(), Player(i))
					
					call AddUnitOcclusion(ACharacter.playerCharacter(Player(i)).unit())
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
		
		/**
		 * \return Returns true if characters gain experience from killing units of player \p whichPlayer. Otherwise it returns false.
		 */
		public static method playerGivesXP takes player whichPlayer returns boolean
			return whichPlayer == Player(PLAYER_NEUTRAL_AGGRESSIVE)
		endmethod
	endstruct

endlibrary