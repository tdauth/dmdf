library StructGameMapChanger requires Asl, StructGameCharacter, StructGameDmdfHashTable, StructGameGrimoire, StructSpellsSpellMetamorphosis

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
	 * \note For every existing savegame which belongs to the current game a boolean flag with the value true is stored in \ref m_saveGamesHashTable. It uses the index of the corresponding zone name of the savegame as parent key. This helps to decide whether a savegame exists and belongs to the current game.
	 */
	struct MapChanger
		/// The name of the gamecache which is used for storing all character data.
		public static constant string gameCacheName = "TPoF.w3v"
		/// In a custom campaign no subfolder is used for maps.
		public static constant string mapFolder = "Maps\\TPOF\\Campaign10"
		/// All map change save games will be saved into this folder.
		public static constant string zonesFolder = "TPoF"
		/// All zone save games come to this folder which do not belong to a savegame name. This folder has to be cleared whenever the game ends or is started newly. Since the ending event cannot be captured the temporary folder is cleared whenever a new campaign is started from the first chapter.
		public static constant string temporaryFolder = "Temporary"
		private static trigger m_loadTriggerTransition
		private static trigger m_loadTriggerUser
		private static trigger m_saveTriggerUser
		/// Stores the savegame name whenever the user saves the game. A directory is created with the same name which has a backup of all the zone savegames.
		private static string m_currentSaveGame = null
		/*
		 * Stores markers for all zones which have a savegame in the current game. This prevents loading savegames which have to correct path but do not belong to the current game.
		 */
		private static AIntegerVector m_saveGames = 0

		/**
		 * \return Returns the file path of a map with the file name \p mapName (without extension) relatively to the Warcraft III directory.
		 */
		public static method mapPath takes string mapName returns string
			local string folder = ""
			if (StringLength(thistype.mapFolder) > 0) then
				set folder = thistype.mapFolder + "\\"
			endif
			return folder + mapName + ".w3x"
		endmethod

		public static method saveGameFolder takes string currentSaveGame returns string
			if (currentSaveGame != null and StringLength(currentSaveGame) > 0) then
				return thistype.zonesFolder + "\\" + currentSaveGame
			endif
			// use another folder if these are temporary zone files
			return thistype.temporaryFolder
		endmethod


		/**
		 * \return Returns a save game path using the zone folder and \p currentSaveGame as well as \p mapName.
		 */
		public static method saveGamePath takes string currentSaveGame, string mapName returns string
			return thistype.saveGameFolder(currentSaveGame) + "\\" + mapName + ".w3z"
		endmethod

		/**
		 * This save game path should be used to save the current map before changing the level.
		 * \return Returns the name of the save game for the current map with map name \p mapName.
		 */
		public static method currentSaveGamePath takes string mapName returns string
			return thistype.saveGamePath(thistype.m_currentSaveGame, mapName)
		endmethod

		public static method temporarySaveGamePath takes string mapName returns string
			return thistype.saveGamePath("", mapName)
		endmethod

		public static method playerMissionKey takes player whichPlayer returns string
			return "Character" + GetPlayerName(whichPlayer)
		endmethod

		/**
		 * Every player character is stored with a unique mission key using the character's player ID.
		 */
		public static method characterMissionKey takes Character character returns string
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
				call StoreInteger(cache, missionKey, "Grimoire" + I2S(spell.ability()) + "Level", spell.level())
				call StoreBoolean(cache, missionKey, "Grimoire" + I2S(spell.ability()) + "Favorites", character.grimoire().favourites().contains(spell))
				set i = i + 1
			endloop
		endmethod

		/**
		 * Unmorphing the character before a map change is essential. Otherwise the unit type is wrong on restoring the character when the character comes back to the map.
		 * Besides the morphing would have to be considered in the next map.
		 * \param character The character which is restored if he/she is currently morphed.
		 */
		private static method unmorphCharacterIfNecessary takes Character character returns boolean
			if (character.isMorphed()) then
				return character.morphSpell().restoreUnit()
			endif

			return true
		endmethod

		private static method filterUnit takes nothing returns boolean
			return not IsUnitType(GetFilterUnit(), UNIT_TYPE_DEAD) and not IsUnitType(GetFilterUnit(), UNIT_TYPE_SUMMONED) and not IsUnitType(GetFilterUnit(), UNIT_TYPE_HERO) and not IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE)
		endmethod

		/**
		 * Stores all units who are no buildings, not dead and no heroes of player \p whichPlayer in a range of 900.0 of a point with the coordinates \p x and \p y.
		 * This helps the player to use units like horses or bought units in other maps, too.
		 * \todo Don't do this for the World Map.
		 */
		private static method storeUnitsSinglePlayer takes gamecache cache, player whichPlayer, real x, real y returns nothing
			local string missionKey = thistype.playerMissionKey(whichPlayer) + "Units"
			local integer i = 0
			local AGroup whichGroup = AGroup.create()
			call whichGroup.addUnitsInRange(x, y, 900.0, Filter(function thistype.filterUnit))
			set i = 0
			loop
				exitwhen (i == whichGroup.units().size())
				if (GetOwningPlayer(whichGroup.units()[i]) != whichPlayer or Character.isUnitCharacter(whichGroup.units()[i])) then
					call whichGroup.units().erase(i)
				else
					set i = i + 1
				endif
			endloop
			call StoreInteger(cache, missionKey, "Count", whichGroup.units().size())
			set i = 0
			loop
				exitwhen (i == whichGroup.units().size())
				if (StoreUnit(cache, missionKey, I2S(i), whichGroup.units()[i])) then
					call RemoveUnit(whichGroup.units()[i])
				endif
				set i = i + 1
			endloop
			call whichGroup.destroy()
		endmethod

		private static method setupMapTransition takes nothing returns nothing
			// Hide transition delay.
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 0.00, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 0, 0, 0, 0)
			call ShowInterface(false, 1.0)
			call EnableUserControl(false)
			call ClearTextMessages()
			call ClearSelection()
		endmethod

		private static method clearMapTransition takes nothing returns nothing
			// Disable the transition mode. NOTE don't play any video in onRestoreCharacter() before.
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.00, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 0, 0, 0, 0)
			call ShowInterface(true, 1.0)
			call EnableUserControl(true)
		endmethod
		/**
		 * Marks the current zone as a saved game.
		 * This indicates that a savegame exists of the path \ref zoneSaveGame(MapSettings.mapName()).
		 * This is required for every map the user travels to that it can be decided on a map transition if the savegame exists.
		 */
		private static method markCurrentSaveGame takes nothing returns boolean
			local integer index = Zone.zoneNameIndex.evaluate(MapSettings.mapName())

			if (index != -1) then
				if (not thistype.m_saveGames.contains(index)) then
					debug call Print("Marking savegame: " + MapSettings.mapName() + " with index " + I2S(index) + " which corresponds to zone name " +  Zone.zoneNames.evaluate()[index])
					call thistype.m_saveGames.pushBack(index)
				endif

				return true
			debug else
				debug call Print("Critical: Missing zone of name " + MapSettings.mapName())
			endif

			return false
		endmethod

		/**
		 * Use this method to check if the savegame should exist and belongs to the current game.
		 * Sometimes savegames exist in the temporary folder which do not belong to the current game. Therefore you need to make sure
		 * that the zone has a save game at all in the current game. Use this before checking with \ref SaveGameExists().
		 * \return Returns true if the savegame for the zone \p targetZoneName should exist belongs the current game.
		 */
		public static method zoneHasSaveGame takes string targetZoneName returns boolean
			local integer index = Zone.zoneNameIndex.evaluate(targetZoneName)

			if (index != -1) then
				return thistype.m_saveGames.contains(index)
			debug else
				debug call Print("Critical: Missing zone of name " + targetZoneName)
			endif

			return false
		endmethod

		/**
		 * Stores all markers for zone savegames for the next map.
		 * \param cache The game cache in which the markers are stored.
		 */
		private static method storeSaveGames takes gamecache cache returns nothing
			local integer i = 0
			call FlushStoredMission(cache, "ZoneSaveGames")
			loop
				exitwhen (i == thistype.m_saveGames.size())
				debug call Print("Store savegame of zone: " + Zone.zoneNames.evaluate()[thistype.m_saveGames[i]])
				call StoreBoolean(cache, "ZoneSaveGames", Zone.zoneNames.evaluate()[thistype.m_saveGames[i]], true)
				set i = i + 1
			endloop
		endmethod

		/**
		 * Restores all markers for zone savegames for the current map.
		 * \param cache The game cache from which the markers are restored.
		 */
		private static method restoreSaveGames takes gamecache cache returns nothing
			local string zoneName = null
			local integer i = 0
			// clear all old entries before
			call thistype.m_saveGames.clear()
			debug call Print("Zone names size: " + I2S(Zone.zoneNames.evaluate().size()) + " and allocated save games value " + I2S(thistype.m_saveGames))
			loop
				exitwhen (i == Zone.zoneNames.evaluate().size())
				set zoneName = Zone.zoneNames.evaluate()[i]
				if (HaveStoredBoolean(cache, "ZoneSaveGames", zoneName)) then
					if (not thistype.m_saveGames.contains(i)) then
						debug call Print("Restored savegame of zone: " + zoneName)
						call thistype.m_saveGames.pushBack(i)
					debug else
						debug call Print("Savegame is already stored for zone: " + zoneName)
					endif
				debug else
					debug call Print("Savegame of zone does not exist: " + zoneName)
				endif
				set i = i + 1
			endloop
		endmethod

		/**
		 * Stores all player characters to a game cache as well as general data which is required in the next map.
		 * Stores the current savegame name and the zone name of the current zone that the next map can identify where the characters come from.
		 * The game cache uses the identifier \ref thistype.gameCacheName.
		 */
		public static method storeCharactersSinglePlayer takes string zone returns boolean
			local gamecache cache  = InitGameCache(thistype.gameCacheName)
			local Character character = 0
			local integer i = 0
			call thistype.setupMapTransition()
			// Store all characters.
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set character = Character(Character.playerCharacter(Player(i)))
				if (character != 0) then
					if (not thistype.unmorphCharacterIfNecessary(character)) then
						debug call Print("Could not unmorph character of player " + GetPlayerName(character.player()))
						return false
					endif

					call thistype.storeCharacterSinglePlayer(cache, character)
					call character.setMovable(false) // Protect from any damage during the delay, but after saving the character in the game cache.

					// Not all zones allow traveling with other units.
					if (Zone.zoneAllowTravelingWithOtherUnits.evaluate(zone)) then
						// Store horses in range for example and transfer them as well
						call thistype.storeUnitsSinglePlayer(cache, character.player(), GetUnitX(character.unit()), GetUnitY(character.unit()))
					else
						call StoreInteger(cache, thistype.playerMissionKey(Player(i)) + "Units", "Count", 0)
					endif
				endif
				set i = i + 1
			endloop
			call StoreBoolean(cache, "Stored", "Stored", true)
			// the current save game name has to be stored to know from where the save games have to be copied
			call StoreString(cache, "CurrentSaveGame", "CurrentSaveGame", thistype.m_currentSaveGame)
			call StoreString(cache, "Zone", "Zone", zone)

			// Store all save game flags
			call thistype.storeSaveGames(cache)

			call SaveGameCache(cache)
			set cache = null

			return true
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

		private static method restoreUnitsSinglePlayer takes gamecache cache, player whichPlayer, real x, real y, real facing returns nothing
			local string missionKey = thistype.playerMissionKey(whichPlayer) + "Units"
			local integer count = GetStoredInteger(cache, missionKey, "Count")
			local integer i = 0
			loop
				exitwhen (i == count)
				call RestoreUnit(cache, missionKey, I2S(i), whichPlayer, x, y, facing)
				set i = i + 1
			endloop
		endmethod

		private static method selectAndMoveCamera takes unit restoredUnit, player whichPlayer returns nothing
			call SelectUnitForPlayerSingle(restoredUnit, whichPlayer)
			//debug call Print("After selecting character " + GetUnitName(restoredUnit) + " for player " + GetPlayerName(whichPlayer))
			call SetCameraPositionForPlayer(whichPlayer, GetUnitX(restoredUnit), GetUnitY(restoredUnit))
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
			local unit oldUnit = null
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
				set oldUnit = character.unit()
				// Replace the old character unit by the newly restored. This triggers also all updates which have to use the new unit reference.
				call character.replaceUnit(restoredUnit)

				// Update order of hero icons. FIXME refreshing options makes the new options unclickable.
				call character.refreshOptions()

				// Remove after replacing the options.
				call AHashTable.global().flushHandle(oldUnit)
				call RemoveUnit(oldUnit)

				// Reset all grimoire spells to reskill them afterwards with the total skill points. Besides the spells have to be removed from the skilled spells in grimoire.
				call character.grimoire().clearLearnedSpells()
				call character.grimoire().favourites().clear()
				// Make sure that the grimoire spells (also not learned spells are cleared). They can only be removed by Grimoire.removeSpellByIndex() or simply by clearing them.
				call character.grimoire().clearSpells()
				// For showing a new page better clear the currently showed UI spells as well.
				call character.grimoire().clearUiSpells()
				// Destroy all spells since the class might have been repicked! Include map specific spells etc. as well. Exclude Grimoire control spells as well as the grimoire spell itself.
				call thistype.destroyAllNonGrimoireSpells.evaluate(character) // New OpLimit.
				// don't clear all ASpell spells, otherwise Grimoire spells which inherit ASpell will be cleared completely.
				call character.classSpells().clear()
			endif

			// Restores the class, inventory items etc.
			call character.restoreDataFromCache(cache, missionKey)

			// Set skill points before creating spells. A skill point is required for the basic spell.
			call character.grimoire().setSkillPoints(GetStoredInteger(cache, missionKey, "SkillPoints"), false) // grimoire UI will be updated in the end

			// Set the stored level of the hero which is required for level ups. Otherwise hints will appear and the number of skill points will be wrong.
			call character.grimoire().setHeroLevel(GetHeroLevel(character.unit()))

			// Create spells only when the class is set, otherwise the grimoire stays empty.
			// Creates spells which are required in the grimoire etc. and adds hero glow etc.
			call ClassSelection.setupCharacterUnit.evaluate(character, character.class())

			call SetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD, GetStoredInteger(cache, missionKey, "Gold"))
			call SetPlayerState(character.player(), PLAYER_STATE_RESOURCE_LUMBER, GetStoredInteger(cache, missionKey, "Lumber"))

			debug call Print("Restoring spell levels: " + I2S(character.grimoire().spells()) + " with character spells: " + I2S(character.spellCount()) + " and learned grimoire spells: " + I2S(character.grimoire().learnedSpells()))
			// load the grimoire levels
			set i = 0
			loop
				exitwhen (i == character.grimoire().spells())
				set spell = character.grimoire().spell(i)
				// use new OpLimit, otherwise OpLimit will be reached very fast
				call thistype.restoreGrimoireSpellLevel.evaluate(character, cache, missionKey, i, "Grimoire" + I2S(spell.ability()) + "Level")
				// use new OpLimit, otherwise OpLimit will be reached very fast
				call thistype.restoreGrimoireSpellIsInFavorites.evaluate(character, cache, missionKey, spell, "Grimoire" + I2S(spell.ability()) + "Favorites")
				set i = i + 1
			endloop

			// make sure the GUI of the grimoire is correct
			// updates the UI and makes sure the page is shown not the current spell
			call character.grimoire().setPage.evaluate(0)

			// update 3rd person camera
			if (character.isViewEnabled()) then
				call character.view().enable()
			endif

			// Not all zones allow traveling with other units.
			if (Zone.zoneAllowTravelingWithOtherUnits.evaluate(MapSettings.mapName())) then
				call thistype.restoreUnitsSinglePlayer(cache, whichPlayer, x, y, facing)
			endif

			// Since the character traveled for some time fill stats.
			call SetUnitLifePercentBJ(restoredUnit, 100.0)
			call SetUnitManaPercentBJ(restoredUnit, 100.0)

			if (not character.isMovable()) then
				call character.setMovable(true)
			endif

			// NOTE works not on the load event.
			call thistype.selectAndMoveCamera(restoredUnit, whichPlayer)
		endmethod

		/**
		 * \return Returns true if \p abilityId belongs to a grimoire action.
		 */
		private static method isGrimoireAbility takes integer abilityId returns boolean
			return  abilityId == Grimoire.abilityId or abilityId == PreviousPage.id or abilityId == NextPage.id or abilityId == SetMax.id or abilityId == Unlearn.id or abilityId == Increase.id or abilityId == Decrease.id or abilityId == AddToFavourites.id or abilityId == RemoveFromFavourites.id or abilityId == BackToGrimoire.id
		endmethod

		private static method destroyAllNonGrimoireSpells takes Character character returns nothing
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

		private static method restoreGrimoireSpellIsInFavorites takes Character character, gamecache cache, string missionKey, Spell spell, string key returns nothing
			local boolean inFavorites = GetStoredBoolean(cache, missionKey, key)
			if (inFavorites) then
				call character.grimoire().addFavouriteSpell(spell)
			endif
		endmethod

		public static method restoreCharactersSinglePlayer takes nothing returns nothing
			local gamecache cache = null
			local string zone = null
			local real x = 0.0
			local real y = 0.0
			local real facing = 0.0
			local integer i = 0
			if (ReloadGameCachesFromDisk()) then
				set cache = InitGameCache(thistype.gameCacheName)
				// the zone from which they come, this helps to place the character at the correct position
				set zone = GetStoredString(cache, "Zone", "Zone")
				// the current save game which is used as folder name for all zone savegames
				set thistype.m_currentSaveGame = GetStoredString(cache, "CurrentSaveGame", "CurrentSaveGame")

				// Restore all save game flags
				call thistype.restoreSaveGames(cache)

				set i = 0
				loop
					exitwhen (i == MapSettings.maxPlayers())
					if (GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING) then
						// Do not restore at (0 | 0). The region will be discovered otherwise.
						set x = MapSettings.zoneRestoreX(zone, Player(i))
						set y = MapSettings.zoneRestoreY(zone, Player(i))
						set facing = MapSettings.zoneRestoreFacing(zone, Player(i))
						call thistype.restoreCharacterSinglePlayer(cache, Player(i), x, y, facing)
						call MapData.onRestoreCharacter.evaluate(zone, Character(Character.playerCharacter(Player(i))))
					endif
					set i = i + 1
				endloop

				call thistype.clearMapTransition()

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
			call NewOpLimit(function thistype.removeBuffsAndSummonedUnits) // New Op Limit

			/*
			 * Mark this savegame before actually saving it, so that it is stored correctly in the gamecache.
			 */
			if (not thistype.markCurrentSaveGame()) then
				debug call Print("Could not mark the current savegame.")
				return
			endif

			if (not thistype.storeCharactersSinglePlayerNewOpLimit.evaluate(oldMap)) then // New Op Limit
				debug call Print("Could not store all characters.")
				return
			endif

			debug call Print("Saving map as " + savePath)
			debug call Print("Load game path: " + loadPath)
			call SaveGame(savePath)

			if (thistype.zoneHasSaveGame(newMap) and SaveGameExists(loadPath)) then
				debug call Print("Loading game since it exists: " + loadPath)
				call LoadGame(loadPath, false)
			else
				debug call Print("Change map to " + nextLevelPath)
				call ChangeLevel(nextLevelPath, false)
			endif
		endmethod

		private static method storeCharactersSinglePlayerNewOpLimit takes string zone returns boolean
			return thistype.storeCharactersSinglePlayer(zone)
		endmethod

		public static method changeMap takes string newMap returns nothing
			// changing map with saving the game does only work in campaign mode
			if (bj_isSinglePlayer and Game.isCampaign.evaluate()) then
				debug call Print("Change map single player campaign")
				if (StringLength(MapSettings.mapName()) > 0) then
					call thistype.changeMapSinglePlayer(MapSettings.mapName(), newMap)
				else
					call Character.displayWarningToAll(tre("Der Zonenname dieser Karte wurde nicht bestimmt.", "The zone name of this map has not been specified."))
				endif
			else
				debug call Print("No change possible")
				call Character.displayHintToAll(tre("Die Karte kann nur in der Einzelspieler-Kampagne gewechselt werden.", "The map can only be changed in the singleplayer campaign."))
			endif
		endmethod

		private static method triggerConditionLoadTransition takes nothing returns boolean
			return IsMapFlagSet(MAP_RELOADED) and bj_isSinglePlayer and Game.isCampaign.evaluate()
		endmethod

		private static method timerFunctionSelectAndMoveCamera takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (Character.playerCharacter(Player(i)) != 0) then
					call thistype.selectAndMoveCamera(Character.playerCharacter(Player(i)).unit(), Player(i))
				endif
				set i = i + 1
			endloop
			call PauseTimer(GetExpiredTimer())
			call DestroyTimer(GetExpiredTimer())
		endmethod

		private static method triggerActionLoadTransition takes nothing returns nothing
			local timer tmpTimer = null
			call thistype.restoreCharactersSinglePlayer()
			// start temporary 0 timer for selection and camera position, since it cannot be done without a delay on initialization
			set tmpTimer = CreateTimer()
			call TimerStart(tmpTimer, 0.0, false, function thistype.timerFunctionSelectAndMoveCamera)
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
				if (thistype.zoneHasSaveGame(zoneName) and SaveGameExists(zoneSaveGame)) then
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
				if (thistype.zoneHasSaveGame(zoneName) and SaveGameExists(zoneSaveGame)) then
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
			set thistype.m_saveGames = AIntegerVector.create()

			// If the campaign is started completely new without loading it, the temporary folder should be cleared. Otherwise wrong zone save games from the last game might be used.
			if (bj_isSinglePlayer and Game.isCampaign.evaluate() and not IsMapFlagSet(MAP_RELOADED) and MapSettings.isSeparateChapter()) then
				call RemoveSaveDirectory(thistype.temporaryFolder)
			debug else
				debug call Print("Not the first chapter. Therefore keep the temporary folder.")
			endif
		endmethod
	endstruct

endlibrary