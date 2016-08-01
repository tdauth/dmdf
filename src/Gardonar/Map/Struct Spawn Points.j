library StructMapMapSpawnPoints requires Asl, StructGameItemTypes, StructGameSpawnPoint

	struct SpawnPoints
		private static SpawnPoint m_demons3
		private static SpawnPoint m_demons2
		private static SpawnPoint m_demons1
		private static SpawnPoint m_demons0
		private static SpawnPoint m_hellServants1
		private static SpawnPoint m_hellServants0
		private static SpawnPoint m_demonBeast
		private static SpawnPoint m_fireDemons
		private static SpawnPoint m_boxes1
		private static SpawnPoint m_boxes0
		
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
			
			set thistype.m_demons3 = SpawnPoint.create()
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n07B_0126, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n07B_0125, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n073_0130, 1.0)
			set itemIndex = thistype.m_demons3.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n073_0131, 1.0)
			set itemIndex = thistype.m_demons3.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n073_0132, 1.0)
			set itemIndex = thistype.m_demons3.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n078_0123, 1.0)
			set itemIndex = thistype.m_demons3.addNewItemType(index, 'I06Y', 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n078_0124, 1.0)
			set itemIndex = thistype.m_demons3.addNewItemType(index, 'I06Y', 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n072_0122, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n072_0122, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n072_0121, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n07A_0129, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n07A_0128, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n07A_0127, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n04C_0154, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n04C_0155, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n04D_0156, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n02C_0157, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n02C_0158, 1.0)
			
			set thistype.m_demons2 = SpawnPoint.create()
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n07B_0117, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n07B_0118, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n07B_0119, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n04C_0153, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n04D_0151, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n04D_0152, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n04D_0150, 1.0)
			
			set thistype.m_demons1 = SpawnPoint.create()
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n079_0114, 1.0)
			set itemIndex = thistype.m_demons1.addNewItemType(index, 'I06V', 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n079_0115, 1.0)
			set itemIndex = thistype.m_demons1.addNewItemType(index, 'I06V', 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n079_0116, 1.0)
			set itemIndex = thistype.m_demons1.addNewItemType(index, 'I06V', 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0099, 1.0)
			set itemIndex = thistype.m_demons1.addNewItemType(index, 'I06Y', 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0100, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0101, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0102, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0103, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0104, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0105, 1.0)
			set itemIndex = thistype.m_demons1.addNewItemType(index, 'I06Y', 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0106, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0107, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0108, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0109, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0110, 1.0)
			set itemIndex = thistype.m_demons1.addNewItemType(index, 'I06Y', 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0111, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0112, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n078_0113, 1.0)
			set itemIndex = thistype.m_demons1.addNewItemType(index, 'I06Y', 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n02C_0143, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n02C_0142, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n02C_0144, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n032_0148, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n032_0149, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n02C_0146, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n02C_0147, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n02C_0145, 1.0)
			
			set thistype.m_demons0 = SpawnPoint.create()
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n07A_0095, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n07A_0096, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n07B_0097, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n04D_0141, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n04C_0139, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n04C_0140, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n07B_0098, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n07A_0094, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n07A_0093, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n07A_0092, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n04B_0138, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n04B_0137, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n04B_0136, 1.0)
			
			set thistype.m_hellServants1 = SpawnPoint.create()
			set index = thistype.m_hellServants1.addUnitWithType(gg_unit_n073_0089, 1.0)
			set itemIndex = thistype.m_hellServants1.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_hellServants1.addUnitWithType(gg_unit_n073_0087, 1.0)
			set itemIndex = thistype.m_hellServants1.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_hellServants1.addUnitWithType(gg_unit_n073_0088, 1.0)
			set index = thistype.m_hellServants1.addUnitWithType(gg_unit_n073_0090, 1.0)
			set itemIndex = thistype.m_hellServants1.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_hellServants1.addUnitWithType(gg_unit_n073_0091, 1.0)
			
			set thistype.m_hellServants0 = SpawnPoint.create()
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0080, 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0083, 1.0)
			set itemIndex = thistype.m_hellServants0.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0084, 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0075, 1.0)
			set itemIndex = thistype.m_hellServants0.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0074, 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0072, 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0071, 1.0)
			set itemIndex = thistype.m_hellServants0.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0079, 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0070, 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0081, 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0082, 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0077, 1.0)
			set itemIndex = thistype.m_hellServants0.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0078, 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0069, 1.0)
			set itemIndex = thistype.m_hellServants0.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0076, 1.0)
			set itemIndex = thistype.m_hellServants0.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0073, 1.0)

			set thistype.m_demonBeast = SpawnPoint.create()
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0057, 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0053, 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0044, 1.0)
			set itemIndex = thistype.m_demonBeast.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0045, 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0043, 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0055, 1.0)
			set itemIndex = thistype.m_demonBeast.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0052, 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0048, 1.0)
			set itemIndex = thistype.m_demonBeast.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0050, 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0058, 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0056, 1.0)
			set itemIndex = thistype.m_demonBeast.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0059, 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0051, 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0047, 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0054, 1.0)
			set itemIndex = thistype.m_demonBeast.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0046, 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0049, 1.0)
			set itemIndex = thistype.m_demonBeast.addNewItemType(index, 'I06Z', 1.0)
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n073_0060, 1.0)
			// the beast itself
			set index = thistype.m_demonBeast.addUnitWithType(gg_unit_n071_0039, 1.0)
			set itemIndex = thistype.m_demonBeast.addNewItemType(index, 'I06W', 1.0)
			
			set thistype.m_fireDemons = SpawnPoint.create()
			set index = thistype.m_fireDemons.addUnitWithType(gg_unit_n072_0040, 1.0)
			set index = thistype.m_fireDemons.addUnitWithType(gg_unit_n072_0042, 1.0)
			set index = thistype.m_fireDemons.addUnitWithType(gg_unit_n072_0041, 1.0)

			set thistype.m_boxes1 = SpawnPoint.create()
			set index = thistype.m_boxes1.addUnitWithType(gg_unit_n04D_0067, 1.0)
			set itemIndex = thistype.m_boxes1.addNewItemType(index, 'I00C', 1.0)
			set itemIndex = thistype.m_boxes1.addNewItemType(index, 'I00B', 1.0)
			set index = thistype.m_boxes1.addUnitWithType(gg_unit_n04C_0068, 1.0)
			set itemIndex = thistype.m_boxes1.addNewItemType(index, 'I00C', 1.0)
			set itemIndex = thistype.m_boxes1.addNewItemType(index, 'I00B', 1.0)
			set index = thistype.m_boxes1.addUnitWithType(gg_unit_n04D_0065, 1.0)
			set itemIndex = thistype.m_boxes1.addNewItemType(index, 'I00C', 1.0)
			set itemIndex = thistype.m_boxes1.addNewItemType(index, 'I00T', 1.0)
			set index = thistype.m_boxes1.addUnitWithType(gg_unit_n04D_0066, 1.0)
			set itemIndex = thistype.m_boxes1.addNewItemType(index, 'I00T', 1.0)
			
			set thistype.m_boxes0 = SpawnPoint.create()
			set index = thistype.m_boxes0.addUnitWithType(gg_unit_n04C_0063, 1.0)
			set itemIndex = thistype.m_boxes0.addNewItemType(index, 'I00A', 1.0)
			set itemIndex = thistype.m_boxes0.addNewItemType(index, 'I00D', 1.0)
			set index = thistype.m_boxes0.addUnitWithType(gg_unit_n04D_0062, 1.0)
			set itemIndex = thistype.m_boxes0.addNewItemType(index, 'I00A', 1.0)
			set itemIndex = thistype.m_boxes0.addNewItemType(index, 'I00D', 1.0)
			set index = thistype.m_boxes0.addUnitWithType(gg_unit_n04D_0061, 1.0)
			set itemIndex = thistype.m_boxes0.addNewItemType(index, 'I00A', 1.0)
			set itemIndex = thistype.m_boxes0.addNewItemType(index, 'I00D', 1.0)
		endmethod
	endstruct

endlibrary