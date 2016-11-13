library StructMapMapSpawnPoints requires Asl, StructGameItemTypes, StructGameSpawnPoint

	/**
	 * \brief Makes sure that invulnerable animals beceome vulnerable.
	 */
	private struct VulnerableSpawnPoint extends SpawnPoint
		/**
		 * Called by .evaluate() whenever a unit is respawned or added for the first time.
		 */
		public stub method onSpawnUnit takes unit whichUnit, integer memberIndex returns nothing
			call SetUnitInvulnerable(whichUnit, false)
		endmethod

	endstruct

	struct SpawnPoints
		private static VulnerableSpawnPoint m_chickens
		private static VulnerableSpawnPoint m_horses
		private static VulnerableSpawnPoint m_pigs

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			local integer index = 0
			local integer itemIndex = 0

			// TODO add dropping item to boss I06X, to Gardonar's hell
			//addNewItemType  integer itemTypeId, real weight returns integer
			//addItemType takes integer index, integer itemTypeId, real weight returns nothing

			set thistype.m_chickens = VulnerableSpawnPoint.create()
			set index = thistype.m_chickens.addUnitWithType(gg_unit_n02X_0101, 1.0)
			set index = thistype.m_chickens.addUnitWithType(gg_unit_n02X_0103, 1.0)
			set index = thistype.m_chickens.addUnitWithType(gg_unit_n02Y_0100, 1.0)
			set index = thistype.m_chickens.addUnitWithType(gg_unit_n02X_0102, 1.0)

			//set itemIndex = thistype.m_fireCreature.addNewItemType(index, 'I06X', 1.0)

			set thistype.m_horses = VulnerableSpawnPoint.create()
			set index = thistype.m_horses.addUnitWithType(gg_unit_h02K_0121, 1.0)
			set index = thistype.m_horses.addUnitWithType(gg_unit_h02K_0122, 1.0)
			set index = thistype.m_horses.addUnitWithType(gg_unit_h02K_0123, 1.0)

			set thistype.m_pigs = VulnerableSpawnPoint.create()
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0116, 1.0)
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0119, 1.0)
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0117, 1.0)
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0114, 1.0)
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0115, 1.0)
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0120, 1.0)
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0118, 1.0)

			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0018, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0016, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0017, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0015, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0021, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0020, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0027, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0028, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0025, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0026, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0022, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0023, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0024, 1.0)
		endmethod
	endstruct

endlibrary