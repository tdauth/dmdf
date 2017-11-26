library StructMapMapSpawnPoints requires Asl, StructGameItemTypes, StructGameSpawnPoint

	/**
	 * \brief Makes sure that invulnerable animals beceome vulnerable.
	 */
	private struct VulnerableSpawnPoint extends SpawnPoint
		/**
		 * Called by .evaluate() whenever a unit is respawned or added for the first time.
		 */
		public stub method onSpawnUnit takes unit whichUnit, integer memberIndex returns nothing
			call SetUnitOwner(whichUnit, Player(PLAYER_NEUTRAL_PASSIVE), true)
			call SetUnitInvulnerable(whichUnit, false)
		endmethod

	endstruct

	struct SpawnPoints
		private static VulnerableSpawnPoint m_chickens
		private static VulnerableSpawnPoint m_horses
		private static VulnerableSpawnPoint m_pigs
		private static VulnerableSpawnPoint m_ducks
		private static VulnerableSpawnPoint m_children

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			local integer index = 0
			local integer itemIndex = 0

			set thistype.m_chickens = VulnerableSpawnPoint.create()
			set index = thistype.m_chickens.addUnitWithType(gg_unit_n02X_0101, 1.0)
			set index = thistype.m_chickens.addUnitWithType(gg_unit_n02X_0103, 1.0)
			set index = thistype.m_chickens.addUnitWithType(gg_unit_n02Y_0100, 1.0)
			set index = thistype.m_chickens.addUnitWithType(gg_unit_n02X_0102, 1.0)

			set thistype.m_horses = VulnerableSpawnPoint.create()
			set index = thistype.m_horses.addUnitWithType(gg_unit_h03L_0129, 1.0)
			set index = thistype.m_horses.addUnitWithType(gg_unit_h03L_0127, 1.0)
			set index = thistype.m_horses.addUnitWithType(gg_unit_h03L_0128, 1.0)

			set thistype.m_pigs = VulnerableSpawnPoint.create()
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0116, 1.0)
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0119, 1.0)
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0117, 1.0)
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0114, 1.0)
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0115, 1.0)
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0120, 1.0)
			set index = thistype.m_pigs.addUnitWithType(gg_unit_n083_0118, 1.0)

			set thistype.m_ducks = VulnerableSpawnPoint.create()
			set index = thistype.m_ducks.addUnitWithType(gg_unit_n02N_0105, 1.0)
			set index = thistype.m_ducks.addUnitWithType(gg_unit_n02N_0107, 1.0)
			set index = thistype.m_ducks.addUnitWithType(gg_unit_n02N_0106, 1.0)
			set index = thistype.m_ducks.addUnitWithType(gg_unit_n02N_0064, 1.0)
			set index = thistype.m_ducks.addUnitWithType(gg_unit_n02N_0109, 1.0)
			set index = thistype.m_ducks.addUnitWithType(gg_unit_n02N_0110, 1.0)
			set index = thistype.m_ducks.addUnitWithType(gg_unit_n02N_0104, 1.0)
			set index = thistype.m_ducks.addUnitWithType(gg_unit_n02N_0108, 1.0)
			set index = thistype.m_ducks.addUnitWithType(gg_unit_n02N_0112, 1.0)
			set index = thistype.m_ducks.addUnitWithType(gg_unit_n02N_0113, 1.0)
			set index = thistype.m_ducks.addUnitWithType(gg_unit_n02N_0124, 1.0)

			set thistype.m_children = VulnerableSpawnPoint.create()
			set index = thistype.m_children.addUnitWithType(gg_unit_nvlk_0077, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvlk_0078, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvlk_0079, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvlk_0080, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvlk_0081, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvlk_0082, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0083, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0084, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0085, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0086, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0087, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0088, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0089, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0090, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0091, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0092, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0093, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0094, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0095, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0096, 1.0)
			set index = thistype.m_children.addUnitWithType(gg_unit_nvk2_0097, 1.0)

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