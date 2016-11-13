library StructMapMapSpawnPoints requires Asl, StructGameItemTypes, StructGameSpawnPoint

	struct SpawnPoints
		private static SpawnPoint m_lordOfTomb

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

			set thistype.m_lordOfTomb = SpawnPoint.create()
			set index = thistype.m_lordOfTomb.addUnitWithType(gg_unit_n07H_0092, 1.0)
			set index = thistype.m_lordOfTomb.addUnitWithType(gg_unit_n07H_0093, 1.0)
			set index = thistype.m_lordOfTomb.addUnitWithType(gg_unit_n07H_0094, 1.0)
			set index = thistype.m_lordOfTomb.addUnitWithType(gg_unit_n07H_0095, 1.0)
			set index = thistype.m_lordOfTomb.addUnitWithType(gg_unit_n07L_0026, 1.0)
			set index = thistype.m_lordOfTomb.addUnitWithType(gg_unit_n07H_0097, 1.0)
			set index = thistype.m_lordOfTomb.addUnitWithType(gg_unit_n02C_0142, 1.0)
			set index = thistype.m_lordOfTomb.addUnitWithType(gg_unit_n02C_0143, 1.0)
			set index = thistype.m_lordOfTomb.addUnitWithType(gg_unit_n02C_0144, 1.0)

			//set index = thistype.m_fireCreature.addUnitWithType(gg_unit_n07D_0078, 1.0)
			//set itemIndex = thistype.m_fireCreature.addNewItemType(index, 'I06X', 1.0)
		endmethod
	endstruct

endlibrary