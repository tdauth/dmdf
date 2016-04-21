library StructGameMapChanger requires Asl, StructGameCharacter, StructGameDmdfHashTable

	/**
	 * \brief Allows changing the map in singleplayer or in multiplayer.
	 * In singleplayer it stores the character in the gamecache and changes the map.
	 * In multiplayer it shows a savecode.
	 */
	struct MapChanger
		/// In a custom campaign no subfolder is used for maps.
		public static constant string mapFolder = ""
		/// All map change save games will be saved into this folder.
		public static constant string zonesFolder = "TPoF"
		private static trigger m_loadTrigger
		private static trigger m_saveTrigger
		private static string m_currentSaveGame = null
		
		/**
		 * \return Returns the file path of a map with the file name \p mapName (without extension) relatively to the Warcraft III directory.
		 */
		private static method mapPath takes string mapName returns string
			local string folder = ""
			if (StringLength(thistype.mapFolder) > 0) then
				set folder = thistype.mapFolder + "\\"
			endif
			return folder + mapName + ".w3x"
		endmethod
		
		/**
		 * \return Returns a save game path using the zone folder and \p currentSaveGame as well as \p mapName.
		 */
		private static method saveGamePath takes string currentSaveGame, string mapName returns string
			local string saveGameFolder = ""
			if (StringLength(currentSaveGame) > 0) then
				set saveGameFolder = currentSaveGame + "\\"
			endif
			return thistype.zonesFolder + "\\" + saveGameFolder + mapName + ".w3z"
		endmethod
		
		/**
		 * This save game path should be used to save the current map before changing the level.
		 * \return Returns the name of the save game for the current map with map name \p mapName.
		 */
		private static method currentSaveGamePath takes string mapName returns string
			return thistype.saveGamePath(thistype.m_currentSaveGame, mapName)
		endmethod
		
		private static method loadGamePath takes string currentSaveGame, string mapName returns string
			local string saveGameFolder = ""
			if (currentSaveGame != null) then
				set saveGameFolder = thistype.m_currentSaveGame + "\\"
			endif
			// "CustomSaves\\" +
			return thistype.zonesFolder + "\\" + saveGameFolder + mapName + ".w3z"
		endmethod
	
		private static method currentLoadGamePath takes string mapName returns string
			return thistype.loadGamePath(thistype.m_currentSaveGame, mapName)
		endmethod
	
		private static method storeCharacterSinglePlayer takes Character character returns nothing
			local gamecache cache = InitGameCache("TPoF.w3v")
			call character.store(cache, "Character" + I2S(GetPlayerId(character.player())))
			call SaveGameCache(cache)
			set cache = null
		endmethod
		
		public static method storeCharactersSinglePlayer takes nothing returns nothing
			local gamecache cache = InitGameCache("TPoF.w3v")
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (Character.playerCharacter(Player(i)) != 0) then
					call thistype.storeCharacterSinglePlayer(Character.playerCharacter(Player(i)))
				endif
				set i = i + 1
			endloop
			call StoreBoolean(cache, "Stored", "Stored", true)
			// the current save game name has to be stored to know from where the save games have to be copied
			call StoreString(cache, "CurrentSaveGame", "CurrentSaveGame", thistype.m_currentSaveGame)
			call SaveGameCache(cache)
			set cache = null
		endmethod
		
		public static method charactersExistSinglePlayer takes nothing returns boolean
			local gamecache cache = null
			if (ReloadGameCachesFromDisk()) then
				set cache = InitGameCache("TPoF.w3v")
				return HaveStoredBoolean(cache, "Stored", "Stored")
			endif
			
			return false
		endmethod
		
		private static method restoreCharacterSinglePlayer takes player whichPlayer, real x, real y, real facing returns nothing
			local gamecache cache = null
			if (ReloadGameCachesFromDisk()) then
				set cache = InitGameCache("TPoF.w3v")
				if (ACharacter.playerCharacter(whichPlayer) == 0) then
					call ACharacter.setPlayerCharacter(whichPlayer, null)
				endif
				call ACharacter.playerCharacter(whichPlayer).restore(cache, "Character" + I2S(GetPlayerId(whichPlayer)), x, y, facing)
				set thistype.m_currentSaveGame = GetStoredString(cache, "CurrentSaveGame", thistype.m_currentSaveGame)
				set cache = null
			endif
		endmethod
		
		public static method restoreCharactersSinglePlayer takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call thistype.restoreCharacterSinglePlayer(Player(i), MapData.startX.evaluate(i), MapData.startY.evaluate(i), 0.0)
				set i = i + 1
			endloop
		endmethod
		
		/**
		 * Changes map to \p newMap and saves the current map.
		 */
		private static method changeMapSinglePlayer takes string oldMap, string newMap returns nothing
			call thistype.storeCharactersSinglePlayer()
		
			debug call Print("Saving map as " + thistype.currentSaveGamePath(oldMap))
			call SaveGame(thistype.currentSaveGamePath(oldMap))
			debug call Print("Load game path: " + thistype.currentLoadGamePath(newMap))
			
			if (SaveGameExists(thistype.currentLoadGamePath(newMap))) then
				call LoadGame(thistype.currentLoadGamePath(newMap), false)
			else
				debug call Print("Change map to " + thistype.mapPath(newMap))
				call ChangeLevel(thistype.mapPath(newMap), false)
			endif
		endmethod
		
		public static method changeMap takes string newMap returns nothing
			// changing map with saving the game does only work in campaign mode
			if (bj_isSinglePlayer and Game.isCampaign.evaluate()) then
				call thistype.changeMapSinglePlayer(MapData.mapName, newMap)
			else
				call Character.displayHintToAll(tre("Die Karte kann nur in der Einzelspieler-Kampagne gewechselt werden.", "The map can only be changed in the singleplayer campaign."))
			endif
		endmethod
		
		private static method triggerConditionLoad takes nothing returns boolean
			return IsMapFlagSet(MAP_RELOADED) and bj_isSinglePlayer and  Game.isCampaign.evaluate()
		endmethod
		
		private static method triggerActionLoad takes nothing returns nothing
			call thistype.restoreCharactersSinglePlayer()
			debug call Print("Restored characters")
		endmethod
		
		private static method triggerConditionSave takes nothing returns boolean
			return bj_isSinglePlayer and Game.isCampaign.evaluate()
		endmethod
		
		/**
		 * Copying all save games of the zones to a folder which contains the save file name, saves all zones as well not only the current one.
		 */
		private static method triggerActionSave takes nothing returns nothing
			local Zone zone = 0
			local integer i = 0
			loop
				exitwhen (i == Zone.zones.evaluate().size())
				set zone = Zone(Zone.zones.evaluate()[i])
				if (SaveGameExists(thistype.currentSaveGamePath(zone.mapName.evaluate()))) then
					debug call Print("Copying: " + thistype.currentSaveGamePath(zone.mapName.evaluate()))
					debug call Print("To: " + thistype.saveGamePath(GetSaveBasicFilename(), zone.mapName.evaluate()))
					call CopySaveGame(thistype.currentSaveGamePath(zone.mapName.evaluate()), thistype.saveGamePath(GetSaveBasicFilename(), zone.mapName.evaluate()))
				debug else
					debug call Print("Missing: " + thistype.currentSaveGamePath(zone.mapName.evaluate()))
				endif
				set i = i + 1
			endloop
			set thistype.m_currentSaveGame = GetSaveBasicFilename()
			debug call Print("Copied zone save games for current save with size " + I2S(Zone.zones.evaluate().size()))
		endmethod
		
		private static method onInit takes nothing returns nothing
			/*
			 * This trigger only triggers when the game is loaded by a map change.
			 * It restores all necessary data which needs to be updated from the previous map.
			 */
			set thistype.m_loadTrigger = CreateTrigger()
			call TriggerRegisterGameEvent(thistype.m_loadTrigger, EVENT_GAME_LOADED)
			call TriggerAddCondition(thistype.m_loadTrigger, Condition(function thistype.triggerConditionLoad))
			call TriggerAddAction(thistype.m_loadTrigger, function thistype.triggerActionLoad)
			
			/**
			 * This trigger is triggered when the user saves the game.
			 * It makes sure that all zone savegames are copied as well.
			 */
			set thistype.m_saveTrigger = CreateTrigger()
			call TriggerRegisterGameEvent(thistype.m_saveTrigger, EVENT_GAME_SAVE)
			call TriggerAddCondition(thistype.m_saveTrigger, Condition(function thistype.triggerConditionSave))
			call TriggerAddAction(thistype.m_saveTrigger, function thistype.triggerActionSave)
			
			set thistype.m_currentSaveGame = null
		endmethod
	endstruct
	
endlibrary