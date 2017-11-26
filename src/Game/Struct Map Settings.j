library StructGameMapSettings requires StructGameZoneRestorePosition

	/**
	 * \brief All required map settings which have to be set before GameData.onInit() is called.
	 *
	 * Just use MapData.initSettings() to configure the settings.
	 *
	 * Note that most settings have default values.
	 */
	struct MapSettings
		/// The map name is used for zones for example to detect the map file name.
		private static string m_mapName = ""
		/// This list of music files is set as map music during the map initialization.
		private static string m_mapMusic = "Sound\\Music\\mp3Music\\Pippin the Hunchback.mp3;Sound\\Music\\mp3Music\\Minstrel Guild.mp3"
		private static integer m_maxPlayers = 6
		/// The player who owns fellows whose control is shared by all users.
		private static player m_alliedPlayer = Player(6)
		/// The player for actors during video sequences. This prevents returning the units to their creep spots automatically.
		private static player m_neutralPassivePlayer = Player(PLAYER_NEUTRAL_PASSIVE)
		private static boolean array m_playerGivesXP[16]
		/// The fixed time in seconds which it takes until a character is revived automatically after his death.
		private static real m_revivalTime = 15.0
		private static integer m_startLevel = 1
		/// Includes the skill point for the default spell.
		private static integer m_startSkillPoints = 1
		private static integer m_levelSkillPoints = 2
		private static integer m_maxLevel = 10000
		/// If this value is true there will always be a class selection in the beginning if the map is started for the first time. Otherwise characters will be loaded from the gamecache in campaign mode if available.
		private static boolean m_isSeparateChapter = false
		private static unit m_goldmine
		private static AGlobalHashTable m_excludedTeleportUnitTypeIds
		private static boolean m_allowTravelingWithUnits = true
		/**
		 * One entry per \ref Zone.zones() and player of the current map.
		 * Stores instances of the type \ref ZoneRestorePosition.
		 */
		private static hashtable m_zoneRestorePositions = null

		/**
		 * Initializes the default values for the map setttings.
		 * This method has to be called before applying any custom map settings.
		 */
		public static method initDefaults takes nothing returns nothing
			set thistype.m_excludedTeleportUnitTypeIds = AGlobalHashTable.create()
			set thistype.m_playerGivesXP[GetPlayerId(Player(PLAYER_NEUTRAL_AGGRESSIVE))] = true
			set thistype.m_zoneRestorePositions = InitHashtable()
		endmethod

		public static method setMapName takes string mapName returns nothing
			set thistype.m_mapName = mapName
		endmethod

		public static method mapName takes nothing returns string
			return thistype.m_mapName
		endmethod

		public static method setMapMusic takes string musicList returns nothing
			set thistype.m_mapMusic = musicList
		endmethod

		public static method mapMusic takes nothing returns string
			return thistype.m_mapMusic
		endmethod

		public static method setMaxPlayers takes integer maxPlayers returns nothing
			set thistype.m_maxPlayers = maxPlayers
		endmethod

		public static method maxPlayers takes nothing returns integer
			return thistype.m_maxPlayers
		endmethod

		public static method setAlliedPlayer takes player whichPlayer returns nothing
			set thistype.m_alliedPlayer = whichPlayer
		endmethod

		public static method alliedPlayer takes nothing returns player
			return thistype.m_alliedPlayer
		endmethod

		/**
		 * \{
		 */
		public static method setNeutralPassivePlayer takes player whichPlayer returns nothing
			set thistype.m_neutralPassivePlayer = whichPlayer
		endmethod

		public static method neutralPassivePlayer takes nothing returns player
			return thistype.m_neutralPassivePlayer
		endmethod
		/**
		 * \}
		 */

		public static method setPlayerGivesXP takes player whichPlayer, boolean flag returns nothing
			set thistype.m_playerGivesXP[GetPlayerId(whichPlayer)] = flag
		endmethod

		/**
		 * \return Returns true if characters gain experience from killing units of player \p whichPlayer. Otherwise it returns false.
		 */
		public static method playerGivesXP takes player whichPlayer returns boolean
			return thistype.m_playerGivesXP[GetPlayerId(whichPlayer)]
		endmethod

		public static method setRevivalTime takes real revivalTime returns nothing
			set thistype.m_revivalTime = revivalTime
		endmethod

		public static method revivalTime takes nothing returns real
			return thistype.m_revivalTime
		endmethod

		public static method setStartLevel takes integer startLevel returns nothing
			set thistype.m_startLevel = startLevel
		endmethod

		public static method startLevel takes nothing returns integer
			return thistype.m_startLevel
		endmethod

		public static method setStartSkillPoints takes integer startSkillPoints returns nothing
			set thistype.m_startSkillPoints = startSkillPoints
		endmethod

		public static method startSkillPoints takes nothing returns integer
			return thistype.m_startSkillPoints
		endmethod

		/**
		 * The skill points a character gains when leveling up.
		 * \{
		 */
		public static method setLevelSkillPoints takes integer skillPoints returns nothing
			set thistype.m_levelSkillPoints = skillPoints
		endmethod

		public static method levelSkillPoints takes nothing returns integer
			return thistype.m_levelSkillPoints
		endmethod
		/**
		 * \}
		 */

		public static method setMaxLevel takes integer maxLevel returns nothing
			set thistype.m_maxLevel = maxLevel
		endmethod

		public static method maxLevel takes nothing returns integer
			return thistype.m_maxLevel
		endmethod

		public static method setIsSeparateChapter takes boolean isSeparateChapter returns nothing
			set thistype.m_isSeparateChapter = isSeparateChapter
		endmethod

		public static method isSeparateChapter takes nothing returns boolean
			return thistype.m_isSeparateChapter
		endmethod

		public static method setGoldmine takes unit goldmine returns nothing
			set thistype.m_goldmine = goldmine
		endmethod

		public static method goldmine takes nothing returns unit
			return thistype.m_goldmine
		endmethod

		public static method setUnitTypeIdExcludedFromTeleports takes integer unitTypeId, boolean flag returns nothing
			if (flag) then
				call thistype.m_excludedTeleportUnitTypeIds.setBoolean(0, unitTypeId, true)
			else
				call thistype.m_excludedTeleportUnitTypeIds.removeBoolean(0, unitTypeId)
			endif
		endmethod

		public static method isUnitTypeIdExcludedFromTeleports takes integer unitTypeId returns boolean
			if (not thistype.m_excludedTeleportUnitTypeIds.hasBoolean(0, unitTypeId)) then
				return false
			endif

			return thistype.m_excludedTeleportUnitTypeIds.boolean(0, unitTypeId)
		endmethod

		private static method indexOfZone takes string zone returns integer
			return Zone.zoneNameIndex.evaluate(zone)
		endmethod

		public static method addZoneRestorePosition takes string zone, player whichPlayer, real x, real y, real facing returns nothing
			local integer zoneIndex = thistype.indexOfZone(zone)
			if (zoneIndex != -1) then
				call SaveInteger(thistype.m_zoneRestorePositions, zoneIndex, GetPlayerId(whichPlayer), ZoneRestorePosition.create(x, y, facing))
			endif
		endmethod

		public static method addZoneRestorePositionForAllPlayers takes string zone, real x, real y, real facing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				call thistype.addZoneRestorePosition(zone, Player(i), x, y, facing)
				set i = i + 1
			endloop
		endmethod

		private static method loadZoneRestorePosition takes string zone, player whichPlayer returns integer
			local integer zoneIndex = thistype.indexOfZone(zone)
			if (zoneIndex == -1) then
				return 0
			endif
			return ZoneRestorePosition(LoadInteger(thistype.m_zoneRestorePositions, zoneIndex, GetPlayerId(whichPlayer)))
		endmethod

		public static method zoneRestoreX takes string zone, player whichPlayer returns real
			local ZoneRestorePosition zoneRestorePosition = thistype.loadZoneRestorePosition(zone, whichPlayer)
			if (zoneRestorePosition == 0) then
				return 0.0
			endif
			return zoneRestorePosition.x()
		endmethod

		public static method zoneRestoreY takes string zone, player whichPlayer returns real
			local ZoneRestorePosition zoneRestorePosition = thistype.loadZoneRestorePosition(zone, whichPlayer)
			if (zoneRestorePosition == 0) then
				return 0.0
			endif
			return zoneRestorePosition.y()
		endmethod

		public static method zoneRestoreFacing takes string zone, player whichPlayer returns real
			local ZoneRestorePosition zoneRestorePosition = thistype.loadZoneRestorePosition(zone, whichPlayer)
			if (zoneRestorePosition == 0) then
				return 0.0
			endif
			return zoneRestorePosition.facing()
		endmethod
	endstruct

endlibrary