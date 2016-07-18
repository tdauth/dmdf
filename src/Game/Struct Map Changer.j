library StructGameMapChanger requires Asl, StructGameCharacter, StructGameDmdfHashTable, StructGameGrimoire

	/**
	 * \brief Allows changing the map in singleplayer or in multiplayer.
	 * In singleplayer it stores the character in the gamecache and changes the map.
	 * In multiplayer it shows a savecode.
	 *
	 * Similar to the Bonus Campaign the campaign mode of The Power of Fire allows you to change to a map and back to the other map. Therefore the game is always saved when changing to another map.
	 * This allows you to create a big universe consisting of many many maps.
	 *
	 * The character is stored with all of his items and attributes. The quests depend on the map and are not transfered.
	 *
	 * \todo Transfer gold.
	 *
	 * \note Whenever the game is saved in single player campaign mode the save game name is kept and all zone save games are copied to a folder with that savegame name. So the player does always save all zones, too when saving the game. Otherwise the savegames of the zones would be lost. This is the way the Bonus Campaign handles this, too. The savegame name is also stored in the gamecache and passed to every zone.
	 */
	struct MapChanger
		public static constant string gameCacheName = "TPoF.w3v"
		/// In a custom campaign no subfolder is used for maps.
		public static constant string mapFolder = ""
		/// All map change save games will be saved into this folder.
		public static constant string zonesFolder = "TPoF"
		/// All zone save games come to this folder which do not belong to a savegame name. This folder has to be cleared whenever the game ends or is saved under a custom savegame name. Since the ending event cannot be captured the temporary folder is cleared whenever a new campaign is started from the first chapter.
		public static constant string temporaryFolder = "Temporary"
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
			if (StringLength(currentSaveGame) > 0) then
				return thistype.zonesFolder + "\\" + currentSaveGame + "\\" + mapName + ".w3z"
			endif
			// use another folder if these are temporary zone files
			return thistype.temporaryFolder + "\\" + mapName + ".w3z"
		endmethod
		
		/**
		 * This save game path should be used to save the current map before changing the level.
		 * \return Returns the name of the save game for the current map with map name \p mapName.
		 */
		private static method currentSaveGamePath takes string mapName returns string
			return thistype.saveGamePath(thistype.m_currentSaveGame, mapName)
		endmethod
		
		/**
		 * Every player character is stored with a unique mission key using the character's player ID.
		 */
		private static method characterMissionKey takes Character character returns string
			return "Character" + I2S(GetPlayerId(character.player()))
		endmethod
	
		private static method storeCharacterSinglePlayer takes Character character returns nothing
			local gamecache cache = InitGameCache(thistype.gameCacheName)
			call character.store(cache, thistype.characterMissionKey(character))
			call StoreInteger(cache, thistype.characterMissionKey(character), "SkillPoints", character.grimoire().totalSkillPoints())
			call StoreInteger(cache, thistype.characterMissionKey(character), "Gold", GetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD))
			call SaveGameCache(cache)
			set cache = null
		endmethod
		
		public static method storeCharactersSinglePlayer takes nothing returns nothing
			local gamecache cache = InitGameCache(thistype.gameCacheName)
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
			local boolean result = false
			if (ReloadGameCachesFromDisk()) then
				set cache = InitGameCache(thistype.gameCacheName)
				set result = HaveStoredBoolean(cache, "Stored", "Stored")
				set cache = null
			endif
			
			return result
		endmethod
		
		private static method restoreCharacterSinglePlayer takes gamecache cache, player whichPlayer, real x, real y, real facing returns nothing
			local Character character = Character(ACharacter.playerCharacter(whichPlayer))
			local integer i = 0
			if (character == 0) then
				set character = Character.create(whichPlayer, Character.restoreUnitFromCache(cache, thistype.characterMissionKey(character), whichPlayer, x, y, facing), 0, 0)
				call ACharacter.setPlayerCharacterByCharacter(character)
				if (character.inventory() != 0) then
					set i = 0
					loop
						exitwhen (i == bj_MAX_INVENTORY)
						if (UnitItemInSlot(character.unit(), i) != null) then
							call RemoveItem(UnitItemInSlot(character.unit(), i))
						endif
						set i = i + 1
					endloop
				endif
				// TODO clear inventory! It will be restored by the AInventory system
			endif
			// TODO leads to crash: restoreDataFromCache
			//call character.restoreDataFromCache(cache, thistype.characterMissionKey(character))
			//call SetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD, GetStoredInteger(cache, thistype.characterMissionKey(character), "Gold"))
			// TODO restore skill points
			call character.grimoire().setSkillPoints(GetStoredInteger(cache, thistype.characterMissionKey(character), "SkillPoints"))
			call SetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD, GetStoredInteger(cache, thistype.characterMissionKey(character), "Gold"))
			
			// make sure the GUI of the grimoire is correct
			call character.grimoire().updateUi.evaluate()
			
			// update inventory
			call character.inventory().enable()
			
			set thistype.m_currentSaveGame = GetStoredString(cache, "CurrentSaveGame", "CurrentSaveGame")
			debug call Print("Current save game: " + thistype.m_currentSaveGame)
		endmethod
		
		public static method restoreCharactersSinglePlayer takes nothing returns nothing
			local gamecache cache = null
			local integer i = 0
			if (ReloadGameCachesFromDisk()) then
				set cache = InitGameCache(thistype.gameCacheName)
				set i = 0
				loop
					exitwhen (i == MapData.maxPlayers)
					if (GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING) then
						call thistype.restoreCharacterSinglePlayer(cache, Player(i), MapData.startX.evaluate(i), MapData.startY.evaluate(i), 0.0)
					endif
					set i = i + 1
				endloop
				set cache = null
			endif
		endmethod
		
		/**
		 * Changes map to \p newMap and saves the current map.
		 */
		private static method changeMapSinglePlayer takes string oldMap, string newMap returns nothing
			call thistype.storeCharactersSinglePlayer()
		
			debug call Print("Saving map as " + thistype.currentSaveGamePath(oldMap))
			call SaveGame(thistype.currentSaveGamePath(oldMap))
			debug call Print("Load game path: " + thistype.currentSaveGamePath(newMap))
			
			if (SaveGameExists(thistype.currentSaveGamePath(newMap))) then
				debug call Print("Loading game since it exists.")
				call LoadGame(thistype.currentSaveGamePath(newMap), false)
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
			return IsMapFlagSet(MAP_RELOADED) and bj_isSinglePlayer and Game.isCampaign.evaluate()
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
			
			// If there was no save game before you have to clear the temporary folder, otherwise the zone savegames might be used by a different game.
			// Don't clear save game folders from older save games which might still exist and be loaded!
			// Clearing the temporary folder also happens whenever a completely new game is started from the beginning to make sure no invalid stored zones do exist.
			if (StringLength(thistype.m_currentSaveGame) == 0) then
				call RemoveSaveDirectory(thistype.temporaryFolder)
			endif
			
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
			
			// If the campaign is started completely new without loading it, the temporary folder should be cleared. Otherwise wrong zone save games from the last game might be used.
			if (bj_isSinglePlayer and Game.isCampaign.evaluate() and not IsMapFlagSet(MAP_RELOADED) and MapData.isSeparateChapter) then
				call RemoveSaveDirectory(thistype.temporaryFolder)
			endif
		endmethod
	endstruct
	
endlibrary