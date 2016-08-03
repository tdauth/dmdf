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
		
		private static method saveGameFolder takes string currentSaveGame returns string
			if (currentSaveGame != null and StringLength(currentSaveGame) > 0) then
				return thistype.zonesFolder + "\\" + currentSaveGame
			endif
			// use another folder if these are temporary zone files
			return thistype.temporaryFolder
		endmethod
			
		
		/**
		 * \return Returns a save game path using the zone folder and \p currentSaveGame as well as \p mapName.
		 */
		private static method saveGamePath takes string currentSaveGame, string mapName returns string
			return thistype.saveGameFolder(currentSaveGame) + "\\" + mapName + ".w3z"
		endmethod
		
		/**
		 * This save game path should be used to save the current map before changing the level.
		 * \return Returns the name of the save game for the current map with map name \p mapName.
		 */
		private static method currentSaveGamePath takes string mapName returns string
			return thistype.saveGamePath(thistype.m_currentSaveGame, mapName)
		endmethod
		
		private static method playerMissionKey takes player whichPlayer returns string
			return "Character" + GetPlayerName(whichPlayer)
		endmethod
		
		/**
		 * Every player character is stored with a unique mission key using the character's player ID.
		 */
		private static method characterMissionKey takes Character character returns string
			return thistype.playerMissionKey(character.player())
		endmethod
	
		/**
		 * Stores a player's character into a game cache. It stores ASL character data, skill points, gold, lumber, and spell levels.
		 * \param cache The game cache which the character is stored to.
		 * \param character The character which is stored into the game cache.
		 */
		private static method storeCharacterSinglePlayer takes gamecache cache, Character character returns nothing
			local string missionKey = thistype.characterMissionKey(character)
			local integer i = 0
			local Spell spell = 0
			call FlushStoredMission(cache, missionKey) // flush old data, otherwise old inventory might be loaded
			call character.store(cache, missionKey)
			// Store all skill points since they are used to reskill the spells on restoration! They restored character starts with all spells with level 0.
			call StoreInteger(cache, missionKey, "SkillPoints", character.grimoire().totalSkillPoints())
			call StoreInteger(cache, missionKey, "Gold", GetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD))
			call StoreInteger(cache, missionKey, "Lumber", GetPlayerState(character.player(), PLAYER_STATE_RESOURCE_LUMBER))
			set i = 0
			loop
				exitwhen (i == character.grimoire().spells())
				set spell = character.grimoire().spell(i)
				call StoreInteger(cache, missionKey, "Grimoire" + I2S(spell.ability()), spell.level())
				set i = i + 1
			endloop
		endmethod
		
		/**
		 * Stores all player characters to a game cache as well as general data which is required in the next map.
		 * Stores the current savegame name and the zone name of the current zone that the next map can identify where the characters come from.
		 * The game cache uses the identifier \ref thistype.gameCacheName.
		 */
		public static method storeCharactersSinglePlayer takes nothing returns nothing
			local gamecache cache  = InitGameCache(thistype.gameCacheName)
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (Character.playerCharacter(Player(i)) != 0) then
					call thistype.storeCharacterSinglePlayer(cache, Character.playerCharacter(Player(i)))
				endif
				set i = i + 1
			endloop
			call StoreBoolean(cache, "Stored", "Stored", true)
			// the current save game name has to be stored to know from where the save games have to be copied
			call StoreString(cache, "CurrentSaveGame", "CurrentSaveGame", thistype.m_currentSaveGame)
			call StoreString(cache, "Zone", "Zone", MapData.mapName)
			call SaveGameCache(cache)
			set cache = null
		endmethod
		
		/**
		 * \return Returns true if characters are stored in the gamecache at all.
		 */
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
			local string missionKey = thistype.playerMissionKey(whichPlayer)
			local unit restoredUnit = null
			local integer i = 0
			local Spell spell = 0
			set restoredUnit = Character.restoreUnitFromCache(cache, missionKey, whichPlayer, x, y, facing)
			// clear the inventory before
			set i = 0
			loop
				exitwhen (i == bj_MAX_INVENTORY)
				if (UnitItemInSlot(restoredUnit, i) != null) then
					call RemoveItem(UnitItemInSlot(restoredUnit, i))
				endif
				set i = i + 1
			endloop
			
			// The map is started for the first time.
			if (character == 0) then
				// use the constructor from struct Character to make sure everything is run properly
				set character = Character.create(whichPlayer, restoredUnit, 0, 0)
				// restores the inventory automatically
				call ACharacter.setPlayerCharacterByCharacter(character)
				
				debug call Print("Creating spells")
				// Creates spells which are required in the grimoire etc. and adds hero glow etc.
				call ClassSelection.setupCharacterUnit.evaluate(character, character.class())
				debug call Print("After spell creation")
			// The map is laoded with an existing character in it.
			else
				call RemoveUnit(character.unit())
				call character.replaceUnit(restoredUnit)
				// TODO add grimoire abilities to the unit
				debug call Print("Replaced character")
			endif
			
			// Restores the inventory items etc.
			call character.restoreDataFromCache(cache, missionKey)
			
			call character.grimoire().setSkillPoints(GetStoredInteger(cache, missionKey, "SkillPoints"))
			call SetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD, GetStoredInteger(cache, missionKey, "Gold"))
			call SetPlayerState(character.player(), PLAYER_STATE_RESOURCE_LUMBER, GetStoredInteger(cache, missionKey, "Lumber"))
			
			debug call Print("Restoring spell levels")
			// load the grimoire levels
			set i = 0
			loop
				exitwhen (i == character.grimoire().spells())
				set spell = character.grimoire().spell(i)
				// reset OpLimit, otherwise OpLimit will be reached very fast
				call thistype.restoreGrimoireSpellLevel.evaluate(character, cache, missionKey, i, "Grimoire" + I2S(spell.ability()))
				set i = i + 1
			endloop
			debug call Print("After restoing spell levels")
			
			// make sure the GUI of the grimoire is correct
			call character.grimoire().updateUi.evaluate()
			
			set thistype.m_currentSaveGame = GetStoredString(cache, "CurrentSaveGame", "CurrentSaveGame")
			debug call Print("Current save game: " + thistype.m_currentSaveGame)
		endmethod
		
		private static method restoreGrimoireSpellLevel takes Character character, gamecache cache, string missionKey, integer spellIndex, string key returns nothing
			call character.grimoire().setSpellLevelByIndex(spellIndex, GetStoredInteger(cache, missionKey, key), false)
		endmethod

		public static method restoreCharactersSinglePlayer takes nothing returns nothing
			local gamecache cache = null
			local string zone = null
			local integer i = 0
			if (ReloadGameCachesFromDisk()) then
				set cache = InitGameCache(thistype.gameCacheName)
				set zone = GetStoredString(cache, "Zone", "Zone") // the zone from which they come, this helps to place the character at the correct position
				set i = 0
				loop
					exitwhen (i == MapData.maxPlayers)
					if (GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING) then
						call thistype.restoreCharacterSinglePlayer(cache, Player(i), MapData.restoreStartX.evaluate(i, zone), MapData.restoreStartY.evaluate(i, zone), MapData.restoreStartFacing.evaluate(i, zone))
					endif
					set i = i + 1
				endloop
				debug call Print("From zone: " + zone)
				set cache = null
			endif
		endmethod
		
		private static method forGroupBanMagic takes unit whichUnit returns nothing
			if (IsUnitType(whichUnit, UNIT_TYPE_SUMMONED)) then
				call RemoveUnit(whichUnit)
			else
				call UnitRemoveBuffsBJ(bj_REMOVEBUFFS_ALL, whichUnit)
			endif
		endmethod
		
		private static method removeBuffsAndSummonedUnits takes nothing returns nothing
			local AGroup whichGroup = AGroup.create()
			call whichGroup.addUnitsInRect(GetPlayableMapRect(), null)
			call whichGroup.forGroup(thistype.forGroupBanMagic)
			call whichGroup.destroy()
		endmethod
		
		/**
		 * Changes map to \p newMap and saves the current map.
		 */
		private static method changeMapSinglePlayer takes string oldMap, string newMap returns nothing
			local string savePath = thistype.currentSaveGamePath(oldMap)
			local string loadPath = thistype.currentSaveGamePath(newMap)
			local string nextLevelPath = thistype.mapPath(newMap)
			debug call Print("Before storing characters")
			// removing buffs and summoned units is also done in the Bonus Campaign, probably it indicates the elapsed time after a transition
			call ForForce(bj_FORCE_PLAYER[0], function thistype.removeBuffsAndSummonedUnits)
			call ForForce(bj_FORCE_PLAYER[0], function thistype.storeCharactersSinglePlayer) // New Op Limit
			debug call Print("Saving map as " + savePath)
			debug call Print("Load game path: " + loadPath)
			call SaveGame(savePath)
			
			if (SaveGameExists(loadPath)) then
				debug call Print("Loading game since it exists.")
				call LoadGame(loadPath, false)
			else
				debug call Print("Change map to " + nextLevelPath)
				call ChangeLevel(nextLevelPath, false)
			endif
		endmethod
		
		public static method changeMap takes string newMap returns nothing
			// changing map with saving the game does only work in campaign mode
			if (bj_isSinglePlayer and Game.isCampaign.evaluate()) then
				debug call Print("Change map single player campaign")
				call thistype.changeMapSinglePlayer(MapData.mapName, newMap)
			else
				debug call Print("No change possible")
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
			// Only copy all save games if the game is saved under a different file name and it is the singleplayer campaign
			return bj_isSinglePlayer and Game.isCampaign.evaluate() and thistype.m_currentSaveGame != GetSaveBasicFilename()
		endmethod
		
		/**
		 * Copying all save games of the zones to a folder which contains the save file name, saves all zones as well not only the current one.
		 */
		private static method triggerActionSave takes nothing returns nothing
			local string zoneName = null
			local string zoneSaveGame = null
			local string zoneTargetSaveGame = null
			local AStringVector zoneNames = Zone.zoneNames.evaluate()
			local integer i = 0
			// Remove existing zones directory if a savegame already existed with the same name, otherwise old zone save games will remain.
			call RemoveSaveDirectory(thistype.saveGameFolder(GetSaveBasicFilename()))
			// Copy savegames for all zones into the new directory. Consider that every map needs ALL zones therefore. Disable unused zones in the map.
			loop
				exitwhen (i == zoneNames.size())
				set zoneName = zoneNames[i]
				set zoneSaveGame = thistype.currentSaveGamePath(zoneName)
				if (SaveGameExists(zoneSaveGame)) then
					set zoneTargetSaveGame = thistype.saveGamePath(GetSaveBasicFilename(), zoneName)
					debug call Print("Copying: " + zoneSaveGame)
					debug call Print("To: " + zoneTargetSaveGame)
					call CopySaveGame(zoneSaveGame, zoneTargetSaveGame)
				debug else
					debug call Print("Missing: " + zoneSaveGame)
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