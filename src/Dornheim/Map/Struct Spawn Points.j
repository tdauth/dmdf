library StructMapMapSpawnPoints requires Asl, StructGameItemTypes, StructGameSpawnPoint

	struct SpawnPoints
		private static SpawnPoint m_fireCreature

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

			set thistype.m_fireCreature = SpawnPoint.create()
			//set index = thistype.m_fireCreature.addUnitWithType(gg_unit_n07D_0078, 1.0)
			//set itemIndex = thistype.m_fireCreature.addNewItemType(index, 'I06X', 1.0)

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