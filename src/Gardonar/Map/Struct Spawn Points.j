library StructMapMapSpawnPoints requires Asl, StructGameItemTypes, StructGameSpawnPoint

	struct SpawnPoints
		// demons 0
		private static SpawnPoint m_wolvesStart0
		
		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod
		
		public static method init takes nothing returns nothing
			local integer index
			local integer itemIndex
			
			 // wolves start 0
			set thistype.m_wolvesStart0 = SpawnPoint.create()
			//set index = thistype.m_wolvesStart0.addUnitWithType(gg_unit_n02F_0502, 1.0)
			//call thistype.m_wolvesStart0.addNewItemType(index, 'I01H', 1.0)
			//set index = thistype.m_wolvesStart0.addUnitWithType(gg_unit_n02F_0500, 1.0)
			//call thistype.m_wolvesStart0.addNewItemType(index, 'I01H', 1.0)
			//set index = thistype.m_wolvesStart0.addUnitWithType(gg_unit_n02F_0501, 1.0)
			//call thistype.m_wolvesStart0.addNewItemType(index, 'I01H', 1.0)
			//call thistype.m_wolvesStart0.addNewItemType(index, 'rhe1', 1.0)
		endmethod
	endstruct

endlibrary