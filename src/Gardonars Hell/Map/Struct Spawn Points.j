library StructMapMapSpawnPoints requires Asl, StructGameItemTypes, StructGameSpawnPoint

	struct SpawnPoints
		private static SpawnPoint m_dragon2
		private static SpawnPoint m_dragon1
		private static SpawnPoint m_dragon0
		private static SpawnPoint m_berserks
		private static SpawnPoint m_fireCreature
		private static SpawnPoint m_demons7
		private static SpawnPoint m_demons6
		private static SpawnPoint m_demons5
		private static SpawnPoint m_demons4
		private static SpawnPoint m_demons3
		private static SpawnPoint m_demons2
		private static SpawnPoint m_demons1
		private static SpawnPoint m_demons0
		private static SpawnPoint m_hellServants0

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

			// Dragon 2
			set thistype.m_dragon2 = SpawnPoint.create()
			set index = thistype.m_dragon2.addUnitWithType(gg_unit_n01M_0029, 1.0)
			set index = thistype.m_dragon2.addUnitWithType(gg_unit_n01M_0030, 1.0)

			// Dragon 1
			set thistype.m_dragon1 = SpawnPoint.create()
			set index = thistype.m_dragon1.addUnitWithType(gg_unit_n01M_0028, 1.0)

			// Dragon 0
			set thistype.m_dragon0 = SpawnPoint.create()
			set index = thistype.m_dragon0.addUnitWithType(gg_unit_n01L_0027, 1.0)

			// Berserks
			set thistype.m_berserks = SpawnPoint.create()
			set index = thistype.m_berserks.addUnitWithType(gg_unit_n07C_0083, 1.0)
			set index = thistype.m_berserks.addUnitWithType(gg_unit_n07C_0084, 1.0)
			set index = thistype.m_berserks.addUnitWithType(gg_unit_n07C_0085, 1.0)
			set index = thistype.m_berserks.addUnitWithType(gg_unit_n07C_0086, 1.0)

			// Fire Creature
			set thistype.m_fireCreature = SpawnPoint.create()
			set index = thistype.m_fireCreature.addUnitWithType(gg_unit_n07A_0079, 1.0)
			set index = thistype.m_fireCreature.addUnitWithType(gg_unit_n07A_0081, 1.0)
			set index = thistype.m_fireCreature.addUnitWithType(gg_unit_n07A_0080, 1.0)
			set index = thistype.m_fireCreature.addUnitWithType(gg_unit_n07A_0082, 1.0)
			set index = thistype.m_fireCreature.addUnitWithType(gg_unit_n07D_0078, 1.0)
			set itemIndex = thistype.m_fireCreature.addNewItemType(index, 'I06X', 1.0)

			// Demons 7
			set thistype.m_demons7 = SpawnPoint.create()
			set index = thistype.m_demons7.addUnitWithType(gg_unit_n07C_0071, 1.0)
			set index = thistype.m_demons7.addUnitWithType(gg_unit_n07B_0074, 1.0)
			set index = thistype.m_demons7.addUnitWithType(gg_unit_n07B_0073, 1.0)
			set index = thistype.m_demons7.addUnitWithType(gg_unit_n07B_0072, 1.0)
			set index = thistype.m_demons7.addUnitWithType(gg_unit_n07B_0075, 1.0)
			set index = thistype.m_demons7.addUnitWithType(gg_unit_n07B_0076, 1.0)
			set index = thistype.m_demons7.addUnitWithType(gg_unit_n07B_0077, 1.0)

			// Demons 6
			set thistype.m_demons6 = SpawnPoint.create()
			set index = thistype.m_demons6.addUnitWithType(gg_unit_n07B_0070, 1.0)
			set index = thistype.m_demons6.addUnitWithType(gg_unit_n07B_0069, 1.0)

			// Demons 5
			set thistype.m_demons5 = SpawnPoint.create()
			set index = thistype.m_demons5.addUnitWithType(gg_unit_n078_0059, 1.0)
			set index = thistype.m_demons5.addUnitWithType(gg_unit_n078_0055, 1.0)
			set index = thistype.m_demons5.addUnitWithType(gg_unit_n078_0057, 1.0)
			set index = thistype.m_demons5.addUnitWithType(gg_unit_n078_0056, 1.0)
			set index = thistype.m_demons5.addUnitWithType(gg_unit_n078_0058, 1.0)

			// Demons 4
			set thistype.m_demons4 = SpawnPoint.create()
			set index = thistype.m_demons4.addUnitWithType(gg_unit_n078_0054, 1.0)
			set index = thistype.m_demons4.addUnitWithType(gg_unit_n078_0052, 1.0)
			set index = thistype.m_demons4.addUnitWithType(gg_unit_n078_0053, 1.0)

			// Demons 3
			set thistype.m_demons3 = SpawnPoint.create()
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n073_0067, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n073_0068, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n073_0065, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n073_0066, 1.0)
			set index = thistype.m_demons3.addUnitWithType(gg_unit_n073_0064, 1.0)

			// Demons 2
			set thistype.m_demons2 = SpawnPoint.create()
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n073_0062, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n073_0060, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n073_0061, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n073_0063, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n079_0047, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n079_0048, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n079_0050, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n079_0049, 1.0)
			set index = thistype.m_demons2.addUnitWithType(gg_unit_n079_0051, 1.0)

			// Demons 1
			set thistype.m_demons1 = SpawnPoint.create()
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n07B_0043, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n07B_0042, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n07B_0041, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n07A_0046, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n07A_0044, 1.0)
			set index = thistype.m_demons1.addUnitWithType(gg_unit_n07A_0045, 1.0)

			// Demons 0
			set thistype.m_demons0 = SpawnPoint.create()
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n07B_0040, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n07B_0039, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n072_0035, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n072_0036, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n072_0031, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n072_0034, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n072_0033, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n072_0032, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n07A_0038, 1.0)
			set index = thistype.m_demons0.addUnitWithType(gg_unit_n07A_0037, 1.0)

			// Hell Servants 0
			set thistype.m_hellServants0 = SpawnPoint.create()
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0013, 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0011, 1.0)
			set index = thistype.m_hellServants0.addUnitWithType(gg_unit_n073_0012, 1.0)
		endmethod
	endstruct

endlibrary