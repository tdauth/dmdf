library StructGameZone requires Asl, StructGameCharacter, StructGameQuestArea, StructGameMapChanger

	/**
	 * \brief Zones are used for map changes.
	 * Like in the Bonus Campaign these areas can be entered by all characters. When all characters have entered the rect the map is changed.
	 * In multiplayer of course this does not work so only the save code might be shown or nothing happens.
	 * In a campaign the map is changed and everything is stored in a gamecache. The game is saved before that the player can return to the original map.
	 */
	struct Zone extends QuestArea
		public static constant integer unitTypeId = 'n06N'
		private static AIntegerVector m_zones
		/// All zone names even the names of zones which cannot be reached in this map. This is required for copying all save games.
		private static AStringVector m_zoneNames
		private static ABooleanVector m_zoneAllowTravelingWithOtherUnits
		private string m_mapName
		private unit m_iconUnit
		private boolean m_isEnabled

		/**
		 * \return Returns a vector of all \ref Zone instances in this map.
		 */
		public static method zones takes nothing returns AIntegerVector
			return thistype.m_zones
		endmethod

		public method mapName takes nothing returns string
			return this.m_mapName
		endmethod

		public method iconUnit takes nothing returns unit
			return this.m_iconUnit
		endmethod

		public stub method onCheck takes nothing returns boolean
			if (not this.m_isEnabled) then
				call Character.displayHintToAll(tre("Dieser Kartenausgang kann noch nicht benutzt werden.", "This map exit cannot be used yet."))
			endif

			return this.m_isEnabled
		endmethod

		/**
		 * \note Is called with .execute().
		 */
		public stub method onStart takes nothing returns nothing
			call MapChanger.changeMap(this.mapName())
		endmethod

		public stub method show takes nothing returns nothing
			call super.show()
			call ShowUnit(this.m_iconUnit, true)
		endmethod

		public stub method hide takes nothing returns nothing
			call super.hide()
			call ShowUnit(this.m_iconUnit, false)
		endmethod

		public stub method enable takes nothing returns nothing
			call super.enable()
			set this.m_isEnabled = true
			call ShowUnit(this.m_iconUnit, true)
			call this.show()
		endmethod

		public stub method disable takes nothing returns nothing
			call super.disable()
			set this.m_isEnabled = false
			call ShowUnit(this.m_iconUnit, false)
			call this.hide()
		endmethod

		/**
		 * Creates a new zone which can be reached via a zone area. Make sure that the zone's name is also in the global zone's name list.
		 * \param mapName This should be the name of the other map (without extension) which the zone belongs to.
		 * \param whichRect Whenever this rect is entered by the character a map change is done.
		 */
		public static method create takes string mapName, rect whichRect returns thistype
			local thistype this = thistype.allocate(whichRect, false) // Don't make zone areas visible from the beginning! Otherwise players can teleport there!
			set this.m_mapName = mapName
			// Zone areas have to be permanent.
			call this.setDestroyOnActivation(false)
			call thistype.m_zones.pushBack(this)
			set this.m_iconUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), thistype.unitTypeId, GetRectCenterX(whichRect), GetRectCenterY(whichRect), 0.0)
			call SetUnitInvulnerable(this.m_iconUnit, true)
			call SetUnitPathing(this.m_iconUnit, false)
			call UnitSetUsesAltIcon(this.m_iconUnit, true)
			set this.m_isEnabled = true

			debug if (not thistype.m_zoneNames.contains(mapName)) then
			debug call Print("Missing zone name \"" + mapName + "\" in global zone name list.")
			debug endif

			return this
		endmethod

		/**
		 * Initializes the zone system which has to be done before creating any zone.
		 */
		public static method initZones takes nothing returns nothing
			set thistype.m_zones = AIntegerVector.create()
			call SetAltMinimapIcon("UI\\Minimap\\MiniMap-Entrance.blp")
			set thistype.m_zoneNames = AStringVector.create()
			set thistype.m_zoneAllowTravelingWithOtherUnits = ABooleanVector.create()
			/// All zone names of the current campaign must be added here. They have to be copied whenever the game is saved.
			call thistype.m_zoneNames.pushBack("TL") // Talras
			call thistype.m_zoneAllowTravelingWithOtherUnits.pushBack(true)

			call thistype.m_zoneNames.pushBack("GA") // Gardonar
			call thistype.m_zoneAllowTravelingWithOtherUnits.pushBack(true)

			call thistype.m_zoneNames.pushBack("GH") // Gardonar's Hell
			call thistype.m_zoneAllowTravelingWithOtherUnits.pushBack(true)

			call thistype.m_zoneNames.pushBack("DS") // Deranor's Swamp
			call thistype.m_zoneAllowTravelingWithOtherUnits.pushBack(true)

			call thistype.m_zoneNames.pushBack("HB") // Holzbruck
			call thistype.m_zoneAllowTravelingWithOtherUnits.pushBack(true)

			call thistype.m_zoneNames.pushBack("HU") // Holzbruck's Underworld
			call thistype.m_zoneAllowTravelingWithOtherUnits.pushBack(true)

			call thistype.m_zoneNames.pushBack("WM") // World Map
			call thistype.m_zoneAllowTravelingWithOtherUnits.pushBack(false)

			call thistype.m_zoneNames.pushBack("DH") // Tutorial: Dornheim
			call thistype.m_zoneAllowTravelingWithOtherUnits.pushBack(true)

			call thistype.m_zoneNames.pushBack("TN") // The North
			call thistype.m_zoneAllowTravelingWithOtherUnits.pushBack(true)
		endmethod

		public static method zoneNames takes nothing returns AStringVector
			return thistype.m_zoneNames
		endmethod

		/**
		 * \param zoneName The name of the zone for which the index is returned.
		 * \return Returns the index of the zone name \p zoneName in the list of zone names. If the zone name was not found it returns -1.
		 */
		public static method zoneNameIndex takes string zoneName returns integer
			return thistype.zoneNames().find(zoneName) // TODO slow
		endmethod

		/**
		 * Checks whether it is allowed to travel to a zone with other units.
		 * The units should be transfered to the zone's map just like the character unit.
		 * \param zoneName The name of the zone for which the flag is returned.
		 * \return Returns true if it is allowed. Otherwise, it returns false.
		 */
		public static method zoneAllowTravelingWithOtherUnits takes string zoneName returns boolean
			local integer index = thistype.zoneNameIndex(zoneName)
			if (index != -1) then
				return thistype.m_zoneAllowTravelingWithOtherUnits[index]
			debug else
				debug call Print("Missing Allow Traveling With Other Units Entry for Zone: " + zoneName)
			endif

			return false
		endmethod
	endstruct

endlibrary