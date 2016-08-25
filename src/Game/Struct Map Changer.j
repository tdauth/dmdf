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
	 * \note Whenever the game is saved in single player campaign mode the save game name is kept and all zone save games are copied to a folder with that savegame name. So the player does always save all zones, too when saving the game. Otherwise the savegames of the zones would be lost. This is the way the Bonus Campaign handles this, too. The savegame name is also stored in the gamecache and passed to every zone.
	 */
	struct MapChanger
		/// The name of the gamecache which is used for storing all character data.
		public static constant string gameCacheName = "TPoF.w3v"
		/// In a custom campaign no subfolder is used for maps.
		public static constant string mapFolder = ""
		/// All map change save games will be saved into this folder.
		public static constant string zonesFolder = "TPoF"
		/// All zone save games come to this folder which do not belong to a savegame name. This folder has to be cleared whenever the game ends or is started newly. Since the ending event cannot be captured the temporary folder is cleared whenever a new campaign is started from the first chapter.
		public static constant string temporaryFolder = "Temporary"
		private static trigger m_loadTriggerTransition
		private static trigger m_loadTriggerUser
		private static trigger m_saveTriggerUser
		/// Stores the savegame name whenever the user saves the game. A directory is created with the same name which has a backup of all the zone savegames.
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

		private static method temporarySaveGamePath takes string mapName returns string
			return thistype.saveGamePath("", mapName)
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

		/**
		 * Restores a single player character from \p cache for \p whichPlayer at \p x, \p y with \p facing.
		 * If the map is started for the first time, the character is created newly. Otherwise its unit and spells are replaced as well as the inventory.
		 * The resources are loaded as well.
		 */
		private static method restoreCharacterSinglePlayer takes gamecache cache, player whichPlayer, real x, real y, real facing returns nothing
			local Character character = Character(ACharacter.playerCharacter(whichPlayer))
			local boolean createCompletelyNewCharacter = character == 0
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
			if (createCompletelyNewCharacter) then
				// use the constructor from struct Character to make sure everything is run properly
				set character = Character.create(whichPlayer, restoredUnit, 0, 0)
				// set the player character for the first time
				call ACharacter.setPlayerCharacterByCharacter(character)
			// The map is loaded with an existing character in it.
			else
				call AHashTable.global().flushHandle(character.unit())
				call RemoveUnit(character.unit())
				// Replace the old character unit by the newly restored. This triggers also all updates which have to use the new unit reference.
				call character.replaceUnit(restoredUnit)
				// Reset all grimoire spells to reskill them afterwards with the total skill points. Besides the spells have to be removed from the skilled spells in grimoire.
				debug call Print("Clearing grimoire spells with count: " + I2S(character.grimoire().spells()))
				call character.grimoire().clearLearnedSpells()
				call character.grimoire().favourites().clear()
				// Make sure that the grimoire spells (also not learned spells are cleared). They can only be removed by Grimoire.removeSpellByIndex() or simply by clearing them.
				call character.grimoire().clearSpells()
				// For showing a new page better clear the currently showed UI spells as well.
				call character.grimoire().clearUiSpells()
				debug call Print("New grimoire spells count: " + I2S(character.grimoire().spells()) + " favorite spells count: " + I2S(character.grimoire().favourites().size()) + " and learned spells count " + I2S(character.grimoire().learnedSpells()))
				// Destroy all spells since the class might have been repicked! Include map specific spells etc. as well. Exclude Grimoire control spells as well as the grimoire spell itself.
				call thistype.destroyAllSpells.evaluate(character) // New OpLimit.
				// don't clear all ASpell spells, otherwise Grimoire spells which inherit ASpell will be cleared completely.
				call character.classSpells().clear()
			endif

			// Restores the class, inventory items etc.
			call character.restoreDataFromCache(cache, missionKey)

			// Set skill points before creating spells. A skill point is required for the basic spell.
			call character.grimoire().setSkillPoints(GetStoredInteger(cache, missionKey, "SkillPoints"), false) // grimoire UI will be updated in the end

			// Create spells only when the class is set, otherwise the grimoire stays empty.
			//debug call Print("Creating spells, character has " + I2S(character.spellCount()) + " spells")
			// Creates spells which are required in the grimoire etc. and adds hero glow etc.
			call ClassSelection.setupCharacterUnit.evaluate(character, character.class())
			//debug call Print("After spell creation classes, character has " + I2S(character.spellCount()) + " spells")

			call SetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD, GetStoredInteger(cache, missionKey, "Gold"))
			call SetPlayerState(character.player(), PLAYER_STATE_RESOURCE_LUMBER, GetStoredInteger(cache, missionKey, "Lumber"))

			debug call Print("Restoring spell levels: " + I2S(character.grimoire().spells()) + " with character spells: " + I2S(character.spellCount()) + " and learned grimoire spells: " + I2S(character.grimoire().learnedSpells()))
			// load the grimoire levels
			set i = 0
			loop
				exitwhen (i == character.grimoire().spells())
				set spell = character.grimoire().spell(i)
				// use new OpLimit, otherwise OpLimit will be reached very fast
				call thistype.restoreGrimoireSpellLevel.evaluate(character, cache, missionKey, i, "Grimoire" + I2S(spell.ability()))
				set i = i + 1
			endloop
			//debug call Print("After restoring spell levels. Total skill points: " + I2S(character.grimoire().totalSkillPoints()))

			// make sure the GUI of the grimoire is correct
			// updates the UI and makes sure the page is shown not the current spell
			call character.grimoire().setPage.evaluate(0)

			// update 3rd person camera
			if (character.isViewEnabled()) then
				call character.view().enable()
			endif

			// Since the character traveled for some time fill stats.
			call SetUnitLifePercentBJ(restoredUnit, 100.0)
			call SetUnitManaPercentBJ(restoredUnit, 100.0)
			call SelectUnitForPlayerSingle(restoredUnit, whichPlayer)
			//debug call Print("After selecting character " + GetUnitName(restoredUnit) + " for player " + GetPlayerName(whichPlayer))
			call SetCameraPositionForPlayer(whichPlayer, GetUnitX(restoredUnit), GetUnitY(restoredUnit))
		endmethod

		/**
		 * \return Returns true if \p abilityId belongs to a grimoire action.
		 */
		private static method isGrimoireAbility takes integer abilityId returns boolean
			return  abilityId == Grimoire.abilityId or abilityId == PreviousPage.id or abilityId == NextPage.id or abilityId == SetMax.id or abilityId == Unlearn.id or abilityId == Increase.id or abilityId == Decrease.id or abilityId == AddToFavourites.id or abilityId == RemoveFromFavourites.id or abilityId == BackToGrimoire.id
		endmethod

		private static method destroyAllSpells takes Character character returns nothing
			local integer i = 0
			local boolean foundGrimoireAbility = false
			// Destroy Spell instances (class spells) first which automatically destroys the corresponding grimoire entries (of type ASpell) and removes the spells from class spells
			loop
				exitwhen (character.classSpells().isEmpty())
				call thistype.destroyClassSpell.evaluate(Spell(character.classSpells().back())) // New OpLimit
			endloop
			debug call Print("Remaining class spells: " + I2S(character.classSpells().size()))
			debug call Print("Spell count without class spells: " + I2S(character.spellCount()))
			// Now that all grimoire entries are removed and the class spells are cleared all remaining spells except the grimoire actions have to be destroyed, since they are recreated later.
			set i = 0
			loop
				exitwhen (i == character.spellCount())
				// Never destroy the Grimoire spells which are required by the grimoire but do destroy grimoire entries of spells.
				if (not thistype.isGrimoireAbility(character.spell(i).ability())) then
					// Removes the spell automatically from the spells.
					// Use new OpLimit
					debug call Print("Destroying " + GetObjectName(character.spell(i).ability()) + " with remaining size " + I2S(character.spellCount() - 1))
					call thistype.destroySpell.evaluate(character, i)
				else
					debug call Print("Skipping: " + GetObjectName(character.spell(i).ability()))
					set foundGrimoireAbility = true
					set i = i + 1
				endif
			endloop
			if (not foundGrimoireAbility) then
				debug call Print("How the fuck is there no grimoire ability?! character " + I2S(character) + " spell count " + I2S(character.spellCount()))
			endif
		endmethod

		private static method destroyClassSpell takes Spell spell returns nothing
			call spell.destroy()
		endmethod

		private static method destroySpell takes Character character, integer index returns nothing
			call character.spell(index).destroy()
		endmethod

		private static method restoreGrimoireSpellLevel takes Character character, gamecache cache, string missionKey, integer spellIndex, string key returns nothing
			local integer level = GetStoredInteger(cache, missionKey, key)
			if (level > 0) then
				call character.grimoire().setSpellLevelByIndex(spellIndex, level, false)
			endif
		endmethod

		public static method restoreCharactersSinglePlayer takes nothing returns nothing
			local gamecache cache = null
			local string zone = null
			local integer i = 0
			if (ReloadGameCachesFromDisk()) then
				set cache = InitGameCache(thistype.gameCacheName)
				// the zone from which they come, this helps to place the character at the correct position
				set zone = GetStoredString(cache, "Zone", "Zone")
				// the current save game which is used as folder name for all zone savegames
				set thistype.m_currentSaveGame = GetStoredString(cache, "CurrentSaveGame", "CurrentSaveGame")
				set i = 0
				loop
					exitwhen (i == MapData.maxPlayers)
					if (GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING) then
						call thistype.restoreCharacterSinglePlayer(cache, Player(i), MapData.restoreStartX.evaluate(i, zone), MapData.restoreStartY.evaluate(i, zone), MapData.restoreStartFacing.evaluate(i, zone))
					endif
					set i = i + 1
				endloop
				//debug call Print("From zone: " + zone)
				//debug call Print("Current save game: " + thistype.m_currentSaveGame)
				call MapData.onRestoreCharacters.evaluate(zone)
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
			local string savePath = thistype.temporarySaveGamePath(oldMap)
			local string loadPath = thistype.temporarySaveGamePath(newMap)
			local string nextLevelPath = thistype.mapPath(newMap)
			debug call Print("Before storing characters")
			// removing buffs and summoned units is also done in the Bonus Campaign, probably it indicates the elapsed time after a transition
			call ForForce(bj_FORCE_PLAYER[0], function thistype.removeBuffsAndSummonedUnits) // New Op Limit
			call ForForce(bj_FORCE_PLAYER[0], function thistype.storeCharactersSinglePlayer) // New Op Limit
			debug call Print("Saving map as " + savePath)
			debug call Print("Load game path: " + loadPath)
			call SaveGame(savePath)

			if (SaveGameExists(loadPath)) then
				debug call Print("Loading game since it exists: " + loadPath)
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

		private static method triggerConditionLoadTransition takes nothing returns boolean
			return IsMapFlagSet(MAP_RELOADED) and bj_isSinglePlayer and Game.isCampaign.evaluate()
		endmethod

		private static method triggerActionLoadTransition takes nothing returns nothing
			call thistype.restoreCharactersSinglePlayer()
			debug call Print("Restored characters on loading the map in map transition")
		endmethod

		private static method triggerConditionLoadUser takes nothing returns boolean
			return not IsMapFlagSet(MAP_RELOADED) and bj_isSinglePlayer and Game.isCampaign.evaluate()
		endmethod

		/// Copy all to the temporary folder.
		private static method triggerActionLoadUser takes nothing returns nothing
			local string zoneName = null
			local string zoneSaveGame = null
			local string zoneTargetSaveGame = null
			local AStringVector zoneNames = Zone.zoneNames.evaluate()
			local integer i = 0
			call RemoveSaveDirectory(thistype.temporaryFolder)
			set i = 0
			loop
				exitwhen (i == zoneNames.size())
				set zoneName = zoneNames[i]
				set zoneSaveGame = thistype.currentSaveGamePath(zoneName)
				if (SaveGameExists(zoneSaveGame)) then
					set zoneTargetSaveGame = thistype.temporarySaveGamePath(zoneName)
					debug call Print("Copying: " + zoneSaveGame)
					debug call Print("To: " + zoneTargetSaveGame)
					call CopySaveGame(zoneSaveGame, zoneTargetSaveGame)
				debug else
					debug call Print("Missing: " + zoneSaveGame)
				endif
				set i = i + 1
			endloop
		endmethod

		private static method triggerConditionSaveUser takes nothing returns boolean
			return bj_isSinglePlayer and Game.isCampaign.evaluate()
		endmethod

		/**
		 * Copying all save games of the zones to a folder which contains the save file name, saves all zones as well not only the current one.
		 */
		private static method triggerActionSaveUser takes nothing returns nothing
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
				set zoneSaveGame = thistype.temporarySaveGamePath(zoneName)
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

			set thistype.m_currentSaveGame = GetSaveBasicFilename()
			debug call Print("Copied zone save games for current save with size " + I2S(Zone.zones.evaluate().size()))
		endmethod

		private static method onInit takes nothing returns nothing
			/*
			 * This trigger only triggers when the game is loaded by a map change.
			 * It restores all necessary data which needs to be updated from the previous map.
			 */
			set thistype.m_loadTriggerTransition = CreateTrigger()
			call TriggerRegisterGameEvent(thistype.m_loadTriggerTransition, EVENT_GAME_LOADED)
			call TriggerAddCondition(thistype.m_loadTriggerTransition, Condition(function thistype.triggerConditionLoadTransition))
			call TriggerAddAction(thistype.m_loadTriggerTransition, function thistype.triggerActionLoadTransition)

			/*
			 * Triggered when the user loads a game.
			 * In this case the temporary directory is replaced by all zone save games.
			 */
			set thistype.m_loadTriggerUser = CreateTrigger()
			call TriggerRegisterGameEvent(thistype.m_loadTriggerUser, EVENT_GAME_LOADED)
			call TriggerAddCondition(thistype.m_loadTriggerUser, Condition(function thistype.triggerConditionLoadUser))
			call TriggerAddAction(thistype.m_loadTriggerUser, function thistype.triggerActionLoadUser)

			/**
			 * This trigger is triggered when the user saves the game.
			 * It makes sure that all zone savegames are copied as well.
			 * All savegames are backed up into a folder with the save game's name.
			 */
			set thistype.m_saveTriggerUser = CreateTrigger()
			call TriggerRegisterGameEvent(thistype.m_saveTriggerUser, EVENT_GAME_SAVE)
			call TriggerAddCondition(thistype.m_saveTriggerUser, Condition(function thistype.triggerConditionSaveUser))
			call TriggerAddAction(thistype.m_saveTriggerUser, function thistype.triggerActionSaveUser)

			set thistype.m_currentSaveGame = null

			// If the campaign is started completely new without loading it, the temporary folder should be cleared. Otherwise wrong zone save games from the last game might be used.
			if (bj_isSinglePlayer and Game.isCampaign.evaluate() and not IsMapFlagSet(MAP_RELOADED) and MapData.isSeparateChapter) then
				call RemoveSaveDirectory(thistype.temporaryFolder)
			endif
		endmethod
	endstruct

endlibrary