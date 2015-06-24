library StructMapMapSpawnPoints requires Asl, StructGameItemTypes, StructGameSpawnPoint

	struct TestSpawnPoint
		private static ARandomCreepIdGenerator m_randomCreepIdGenerator
		private static AAbstractIdItem m_testUnit0Member0
		private static AIdSet m_testUnit0IdSet
		private static AUnitSpawn m_testUnit0Spawn
		private static AAbstractIdItem m_testUnit0ItemSet0Member0
		private static AAbstractIdItem m_testUnit0ItemSet0Member1
		private static AIdSet m_testUnit0ItemSet0
		private static AAbstractIdItem m_testUnit0ItemSet1Member0
		private static AAbstractIdItem m_testUnit0ItemSet1Member1
		private static AIdSet m_testUnit0ItemSet1
		private static AAbstractIdItem m_testUnit0ItemSet2Member0
		private static AAbstractIdItem m_testUnit0ItemSet2Member1
		private static AIdSet m_testUnit0ItemSet2
		private static AIdTable m_testUnit0ItemTable
		private static AItemDrop m_testUnit0ItemDrop
	
		public static method spawn takes nothing returns nothing
			// TEST
			set thistype.m_randomCreepIdGenerator = ARandomCreepIdGenerator.create(5)
			set thistype.m_testUnit0Member0 = AAbstractIdItem.createWithGenerator(thistype.m_randomCreepIdGenerator, 100)
			
			set thistype.m_testUnit0IdSet = AIdSet.create()
			call thistype.m_testUnit0IdSet.addItem(thistype.m_testUnit0Member0)
			
			set thistype.m_testUnit0Spawn = AUnitSpawn.create()
			call thistype.m_testUnit0Spawn.setLocation(GetRectCenter(gg_rct_character_0_start))
			call thistype.m_testUnit0Spawn.setSet(thistype.m_testUnit0IdSet)
			
			set thistype.m_testUnit0ItemSet0Member0 = AAbstractIdItem.create('whwd', 50)
			set thistype.m_testUnit0ItemSet0Member1 = AAbstractIdItem.create('whwd', 50)
			set thistype.m_testUnit0ItemSet0 = AIdSet.create()
			call thistype.m_testUnit0ItemSet0.addItem(thistype.m_testUnit0ItemSet0Member0)
			call thistype.m_testUnit0ItemSet0.addItem(thistype.m_testUnit0ItemSet0Member1)
		
			set thistype.m_testUnit0ItemSet1Member0 = AAbstractIdItem.create('whwd', 50)
			set thistype.m_testUnit0ItemSet1Member1 = AAbstractIdItem.create('whwd', 50)
			set thistype.m_testUnit0ItemSet1 = AIdSet.create()
			call thistype.m_testUnit0ItemSet1.addItem(thistype.m_testUnit0ItemSet0Member0)
			call thistype.m_testUnit0ItemSet1.addItem(thistype.m_testUnit0ItemSet0Member1)
			
			set thistype.m_testUnit0ItemSet2Member0 = AAbstractIdItem.create('whwd', 50)
			set thistype.m_testUnit0ItemSet2Member1 = AAbstractIdItem.create('whwd', 50)
			set thistype.m_testUnit0ItemSet2 = AIdSet.create()
			call thistype.m_testUnit0ItemSet2.addItem(thistype.m_testUnit0ItemSet0Member0)
			call thistype.m_testUnit0ItemSet2.addItem(thistype.m_testUnit0ItemSet0Member1)
		
			set thistype.m_testUnit0ItemTable = AIdTable.create()
			call thistype.m_testUnit0ItemTable.addSet(thistype.m_testUnit0ItemSet0)
			call thistype.m_testUnit0ItemTable.addSet(thistype.m_testUnit0ItemSet1)
			call thistype.m_testUnit0ItemTable.addSet(thistype.m_testUnit0ItemSet2)
			
			set thistype.m_testUnit0ItemDrop = AItemDrop.createForUnit(thistype.m_testUnit0Spawn.onSpawn())
			call thistype.m_testUnit0ItemDrop.setTable(thistype.m_testUnit0ItemDrop)
		endmethod
	endstruct

	struct SpawnPoints
		// wolves start 0
		private static SpawnPoint m_wolvesStart0
		// wolves start 1
		private static SpawnPoint m_wolvesStart1
		// boars start 0
		private static SpawnPoint m_boarsStart0
		private static SpawnPoint m_boarsStart1
		private static SpawnPoint m_boarsStart2
   
		private static SpawnPoint m_wolves0
		private static SpawnPoint m_wolves1
		private static SpawnPoint m_wolves2
		private static SpawnPoint m_boars0
		private static SpawnPoint m_boars1
		private static SpawnPoint m_bears0
		private static SpawnPoint m_boars2
		private static SpawnPoint m_boars3
		private static SpawnPoint m_highwaymen0
		private static SpawnPoint m_highwaymen1
		private static SpawnPoint m_highwaymen2
		private static SpawnPoint m_deers0
		private static SpawnPoint m_ditchSpiders0
		private static SpawnPoint m_ditchSpiders1
		private static SpawnPoint m_banditsAtGuntrichsMill
		private static SpawnPoint m_box0
		private static SpawnPoint m_box1
		private static SpawnPoint m_box2
		private static SpawnPoint m_giants0
		private static ItemSpawnPoint m_mushroom0
		private static ItemSpawnPoint m_mushroom1
		private static ItemSpawnPoint m_mushroom2
		private static ItemSpawnPoint m_mushroom3
		private static ItemSpawnPoint m_mushroom4
		private static ItemSpawnPoint m_mushroom5
		private static ItemSpawnPoint m_mushroom6
		private static SpawnPoint m_vampireLord0
		private static SpawnPoint m_vampires0
		private static SpawnPoint m_box3
		private static SpawnPoint m_undeadsWithKing
		private static SpawnPoint m_medusaBoxes
		private static SpawnPoint m_medusa
		private static SpawnPoint m_deathVault
		private static SpawnPoint m_deathVaultBoxes0
		private static SpawnPoint m_deathVaultBoxes1
		private static SpawnPoint m_deathAngel
		private static SpawnPoint m_boneDragons
		private static SpawnPoint m_giant
		private static SpawnPoint m_witch0
		private static SpawnPoint m_witch1
		private static SpawnPoint m_witch2
		private static SpawnPoint m_witches
		private static SpawnPoint m_wildCreatures
		private static SpawnPoint m_orcs0
		private static SpawnPoint m_cornEaters0
		private static SpawnPoint m_cornEaters1
		
		// drum cave
		private static SpawnPoint m_skeletons0
		private static SpawnPoint m_skeletons1

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// \todo change unit type
		public static method init takes nothing returns nothing
			local integer index
			
			 // wolves start 0
			set thistype.m_wolvesStart0 = SpawnPoint.create()
			set index = thistype.m_wolvesStart0.addUnitWithType(gg_unit_n02F_0502, 1.0)
			call thistype.m_wolvesStart0.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolvesStart0.addUnitWithType(gg_unit_n02F_0500, 1.0)
			call thistype.m_wolvesStart0.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolvesStart0.addUnitWithType(gg_unit_n02F_0501, 1.0)
			call thistype.m_wolvesStart0.addItemType(index, 'I01H', 1.0)
			call thistype.m_wolvesStart0.addItemType(index, 'rhe1', 1.0)
			// wolves start 1
			set thistype.m_wolvesStart1 = SpawnPoint.create()
			set index = thistype.m_wolvesStart1.addUnitWithType(gg_unit_n02F_0503, 1.0)
			call thistype.m_wolvesStart1.addItemType(index, 'I01H', 1.0)
			call thistype.m_wolvesStart1.addItemType(index, 'rman', 1.0)
			set index = thistype.m_wolvesStart1.addUnitWithType(gg_unit_n02F_0504, 1.0)
			call thistype.m_wolvesStart1.addItemType(index, 'I01H', 1.0)
			
			// boars start 0
			set thistype.m_boarsStart0 = SpawnPoint.create()
			set index = thistype.m_boarsStart0.addUnitWithType(gg_unit_n002_0505, 1.0)
			call thistype.m_boarsStart0.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsStart0.addUnitWithType(gg_unit_n002_0507, 1.0)
			call thistype.m_boarsStart0.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsStart0.addUnitWithType(gg_unit_n002_0506, 1.0)
			call thistype.m_boarsStart0.addItemType(index, 'I007', 1.0)
			call thistype.m_boarsStart0.addItemType(index, 'rhe2', 1.0)
			
			// boars start 1
			set thistype.m_boarsStart1 = SpawnPoint.create()
			set index = thistype.m_boarsStart1.addUnitWithType(gg_unit_n002_0212, 1.0)
			call thistype.m_boarsStart1.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsStart1.addUnitWithType(gg_unit_n002_0210, 1.0)
			call thistype.m_boarsStart1.addItemType(index, 'I007', 1.0)
			
			// boars start 2
			set thistype.m_boarsStart2 = SpawnPoint.create()
			set index = thistype.m_boarsStart2.addUnitWithType(gg_unit_n002_0254, 1.0)
			call thistype.m_boarsStart2.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsStart2.addUnitWithType(gg_unit_n002_0220, 1.0)
			call thistype.m_boarsStart2.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsStart2.addUnitWithType(gg_unit_n002_0219, 1.0)
			call thistype.m_boarsStart2.addItemType(index, 'I007', 1.0)
			
			set thistype.m_wolves0 = SpawnPoint.create()
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02G_0140, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01I', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0139, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0114, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0136, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0008, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0109, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0123, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01H', 1.0)

			set thistype.m_wolves1 = SpawnPoint.create()
			set index = thistype.m_wolves1.addUnitWithType(gg_unit_n02F_0296, 1.0)
			call thistype.m_wolves1.addItemType(index, 'I01I', 1.0)
			set index = thistype.m_wolves1.addUnitWithType(gg_unit_n02F_0297, 1.0)
			call thistype.m_wolves1.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves1.addUnitWithType(gg_unit_n02F_0277, 1.0)
			call thistype.m_wolves1.addItemType(index, 'I01H', 1.0)

			set thistype.m_wolves2 = SpawnPoint.create()
			set index = thistype.m_wolves2.addUnitWithType(gg_unit_n02F_0204, 1.0)
			call thistype.m_wolves2.addItemType(index, 'I01I', 1.0)
			set index = thistype.m_wolves2.addUnitWithType(gg_unit_n02F_0016, 1.0)
			call thistype.m_wolves2.addItemType(index, 'I01H', 1.0)
			
			set thistype.m_boars0 = SpawnPoint.create()
			set index = thistype.m_boars0.addUnitWithType(gg_unit_n002_0078, 1.0)
			call thistype.m_boars0.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boars0.addUnitWithType(gg_unit_n002_0079, 1.0)
			call thistype.m_boars0.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boars0.addUnitWithType(gg_unit_n002_0080, 1.0)
			call thistype.m_boars0.addItemType(index, 'I007', 1.0)

			set thistype.m_boars1 = SpawnPoint.create()
			set index = thistype.m_boars1.addUnitWithType(gg_unit_n002_0076, 1.0)
			call thistype.m_boars1.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boars1.addUnitWithType(gg_unit_n002_0077, 1.0)
			call thistype.m_boars1.addItemType(index, 'I007', 1.0)

			set thistype.m_bears0 = SpawnPoint.create()
			set index = thistype.m_bears0.addUnitWithType(gg_unit_n008_0121, 1.0)
			call thistype.m_bears0.addItemType(index, 'I01J', 1.0)

			set thistype.m_boars2 = SpawnPoint.create()
			set index = thistype.m_boars2.addUnitWithType(gg_unit_n002_0122, 1.0)
			call thistype.m_boars2.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boars2.addUnitWithType(gg_unit_n002_0124, 1.0)
			call thistype.m_boars2.addItemType(index, 'I007', 1.0)

			set thistype.m_boars3 = SpawnPoint.create()
			set index = thistype.m_boars3.addUnitWithType(gg_unit_n002_0276, 1.0)
			call thistype.m_boars3.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boars3.addUnitWithType(gg_unit_n002_0275, 1.0)
			call thistype.m_boars3.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boars3.addUnitWithType(gg_unit_n002_0273, 1.0)
			call thistype.m_boars3.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boars3.addUnitWithType(gg_unit_n002_0274, 1.0)
			call thistype.m_boars3.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boars3.addUnitWithType(gg_unit_n002_0272, 1.0)
			call thistype.m_boars3.addItemType(index, 'I007', 1.0)

			set thistype.m_highwaymen0 = SpawnPoint.create()
			set index = thistype.m_highwaymen0.addUnitWithType(gg_unit_n00T_0125, 1.0)
			call thistype.m_highwaymen0.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'I00T', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'rhe2', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'rman', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'I049', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'I04D', 0.50)
			set index = thistype.m_highwaymen0.addUnitWithType(gg_unit_n00U_0128, 1.0)
			call thistype.m_highwaymen0.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'I00T', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'I049', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'I04C', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'I04D', 0.50)
			set index = thistype.m_highwaymen0.addUnitWithType(gg_unit_n00U_0127, 1.0)
			call thistype.m_highwaymen0.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'I00T', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'rhe2', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'rman', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'I049', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'I04D', 0.50)

			set thistype.m_highwaymen1 = SpawnPoint.create()
			set index = thistype.m_highwaymen1.addUnitWithType(gg_unit_n00T_0126, 1.0)
			call thistype.m_highwaymen1.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen1.addItemType(index, 'I00T', 0.50)
			call thistype.m_highwaymen1.addItemType(index, 'I049', 0.50)
			call thistype.m_highwaymen1.addItemType(index, 'I04D', 0.50)
			set index = thistype.m_highwaymen1.addUnitWithType(gg_unit_n00U_0129, 1.0)
			call thistype.m_highwaymen1.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen1.addItemType(index, 'I00T', 0.50)
			call thistype.m_highwaymen1.addItemType(index, 'rhe2', 0.50)
			call thistype.m_highwaymen1.addItemType(index, 'rman', 0.50)
			call thistype.m_highwaymen1.addItemType(index, 'I049', 0.50)
			call thistype.m_highwaymen1.addItemType(index, 'I04D', 0.50)

			set thistype.m_highwaymen2 = SpawnPoint.create()
			set index = thistype.m_highwaymen2.addUnitWithType(gg_unit_n00T_0130, 1.0)
			call thistype.m_highwaymen2.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen2.addItemType(index, 'I00T', 0.50)
			call thistype.m_highwaymen2.addItemType(index, 'I049', 0.50)
			call thistype.m_highwaymen2.addItemType(index, 'I04D', 0.50)
			set index = thistype.m_highwaymen2.addUnitWithType(gg_unit_n00T_0131, 1.0)
			call thistype.m_highwaymen2.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen2.addItemType(index, 'I00T', 0.50)
			call thistype.m_highwaymen2.addItemType(index, 'rhe2', 0.50)
			call thistype.m_highwaymen2.addItemType(index, 'rman', 0.50)
			call thistype.m_highwaymen2.addItemType(index, 'I049', 0.50)
			call thistype.m_highwaymen2.addItemType(index, 'I04D', 0.50)

			set thistype.m_deers0 = SpawnPoint.create()
			set index = thistype.m_deers0.addUnitWithType(gg_unit_n00V_0132, 1.0)
			call thistype.m_deers0.addItemType(index, 'I00P', 1.0)
			set index = thistype.m_deers0.addUnitWithType(gg_unit_n00V_0133, 1.0)
			call thistype.m_deers0.addItemType(index, 'I00P', 1.0)
			set index = thistype.m_deers0.addUnitWithType(gg_unit_n00V_0134, 1.0)
			call thistype.m_deers0.addItemType(index, 'I00P', 1.0)

			set thistype.m_ditchSpiders0 = SpawnPoint.create()
			set index = thistype.m_ditchSpiders0.addUnitWithType(gg_unit_n01E_0075, 1.0)
			call thistype.m_ditchSpiders0.addItemType(index, 'I041', 1.0)

			set thistype.m_ditchSpiders1 = SpawnPoint.create()
			set index = thistype.m_ditchSpiders1.addUnitWithType(gg_unit_n01E_0070, 1.0)
			call thistype.m_ditchSpiders1.addItemType(index, 'I041', 1.0)
			set index = thistype.m_ditchSpiders1.addUnitWithType(gg_unit_n01E_0074, 1.0)
			call thistype.m_ditchSpiders1.addItemType(index, 'I041', 1.0)
			
			set thistype.m_banditsAtGuntrichsMill = SpawnPoint.create()
			set index = thistype.m_banditsAtGuntrichsMill.addUnitWithType(gg_unit_n00T_0491, 1.0)
			set index = thistype.m_banditsAtGuntrichsMill.addUnitWithType(gg_unit_n00T_0492, 1.0)
			set index = thistype.m_banditsAtGuntrichsMill.addUnitWithType(gg_unit_n00U_0494, 1.0)
			set index = thistype.m_banditsAtGuntrichsMill.addUnitWithType(gg_unit_n00U_0493, 1.0)
			set index = thistype.m_banditsAtGuntrichsMill.addUnitWithType(gg_unit_n00U_0495, 1.0)

			set thistype.m_box0 = SpawnPoint.create()
			set index = thistype.m_box0.addUnitWithType(gg_unit_n02C_0059, 1.0)
			call thistype.m_box0.addItemType(index, 'I00A', 1.0)

			set thistype.m_box1 = SpawnPoint.create()
			set index = thistype.m_box1.addUnitWithType(gg_unit_n02C_0060, 1.0)
			call thistype.m_box1.addItemType(index, 'I01G', 1.0)

			set thistype.m_box2 = SpawnPoint.create()
			set index = thistype.m_box2.addUnitWithType(gg_unit_n02C_0061, 1.0)
			call thistype.m_box2.addItemType(index, 'I00D', 1.0)
			
			set thistype.m_giant = SpawnPoint.create()
			set index = thistype.m_giant.addUnitWithType(gg_unit_n02R_0253, 1.0)
			/*
			 * Make sure these items are always dropped since they are required for Björn's quest.
			 */
			call thistype.m_giant.addItemType(index, 'I01Z', 1.0)
			call thistype.m_giant.addItemType(index, 'I01Z', 1.0)

			set thistype.m_giants0 = SpawnPoint.create()
			set index = thistype.m_giants0.addUnitWithType(gg_unit_n02R_0035, 1.0)
			call thistype.m_giants0.addItemType(index, 'I01Z', 1.0)
			call thistype.m_giants0.addItemType(index, 'I01Z', 1.0)
			set index = thistype.m_giants0.addUnitWithType(gg_unit_n02R_0036, 1.0)
			call thistype.m_giants0.addItemType(index, 'I01Z', 1.0)
			call thistype.m_giants0.addItemType(index, 'I01Z', 1.0)
			set index = thistype.m_giants0.addUnitWithType(gg_unit_n02R_0037, 1.0)
			call thistype.m_giants0.addItemType(index, 'I01Z', 1.0)
			call thistype.m_giants0.addItemType(index, 'I01Z', 1.0)

			set thistype.m_mushroom0 = ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0238, 1.0)
			set thistype.m_mushroom1 = ItemSpawnPoint.createFromItemWithType(gg_item_I01L_0205, 1.0)
			set thistype.m_mushroom2 = ItemSpawnPoint.createFromItemWithType(gg_item_I03Y_0207, 1.0)
			set thistype.m_mushroom3 = ItemSpawnPoint.createFromItemWithType(gg_item_I03Y_0206, 1.0)
			set thistype.m_mushroom4 = ItemSpawnPoint.createFromItemWithType(gg_item_I01L_0211, 1.0)
			set thistype.m_mushroom5 = ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0213, 1.0)
			set thistype.m_mushroom6 = ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0214, 1.0)
	
			set thistype.m_vampireLord0 = SpawnPoint.create()
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n010_0110, 1.0)
			call thistype.m_vampireLord0.addItemType(index, 'I013', 1.0)
			call thistype.m_vampireLord0.addItemType(index, 'I04L', 1.00)
			call thistype.m_vampireLord0.addItemType(index, 'I04G', 1.00)
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n00Z_0106, 1.0)
			call thistype.m_vampireLord0.addItemType(index, 'I00C', 1.0)
			call thistype.m_vampireLord0.addItemType(index, 'I04V', 1.0)
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n00Z_0107, 1.0)
			call thistype.m_vampireLord0.addItemType(index, 'I00C', 1.0)
			call thistype.m_vampireLord0.addItemType(index, 'I04V', 1.0)
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n00Z_0108, 1.0)
			call thistype.m_vampireLord0.addItemType(index, 'I00G', 1.0)
			call thistype.m_vampireLord0.addItemType(index, 'I04V', 1.0)

			set thistype.m_vampires0 = SpawnPoint.create()
			// vampires
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02L_0161, 1.0)
			call thistype.m_vampires0.addItemType(index, 'I02I', 1.0)
			call thistype.m_vampires0.addItemType(index, 'I04H', 0.60)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02L_0194, 1.0)
			call thistype.m_vampires0.addItemType(index, 'I02I', 1.0)
			call thistype.m_vampires0.addItemType(index, 'I04H', 0.60)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02L_0193, 1.0)
			call thistype.m_vampires0.addItemType(index, 'I02I', 1.0)
			call thistype.m_vampires0.addItemType(index, 'I04H', 0.60)
			// zombies
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02M_0231, 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02M_0162, 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02M_0232, 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02M_0233, 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02M_0234, 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02M_0235, 1.0)
			// archers
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n01O_0186, 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n01O_0187, 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n01O_0188, 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n01O_0189, 1.0)

			set thistype.m_box3 = SpawnPoint.create()
			set index = thistype.m_box3.addUnitWithType(gg_unit_n02C_0236, 1.0)
			call thistype.m_box3.addItemType(index, 'I01M', 1.0)
			call thistype.m_box3.addItemType(index, 'I00A', 1.0)
			set index = thistype.m_box3.addUnitWithType(gg_unit_n02C_0237, 1.0)
			call thistype.m_box3.addItemType(index, 'I013', 1.0)
			call thistype.m_box3.addItemType(index, 'I00D', 1.0)

			set thistype.m_undeadsWithKing = SpawnPoint.create()
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01P_0068, 1.0)
			call thistype.m_undeadsWithKing.addItemType(index, ItemTypes.swordOfDarkness().itemType(), 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00Z_0067, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00Z_0066, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0178, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0180, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0179, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0181, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01Q_0169, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01Q_0168, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01Q_0167, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01R_0182, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0340, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0349, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0342, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0350, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0341, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0339, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0338, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0337, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0343, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0348, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0344, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0347, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0345, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0346, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0177, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0176, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0170, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0175, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0172, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0174, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0173, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0171, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0166, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0164, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0163, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0165, 1.0)

			// make boxes a separate spawn point, otherwise boxes might be left over
			set thistype.m_medusaBoxes = SpawnPoint.create()
			set index = thistype.m_medusaBoxes.addUnitWithType(gg_unit_n02C_0281, 1.0)
			set index = thistype.m_medusaBoxes.addUnitWithType(gg_unit_n02C_0280, 1.0)
			set index = thistype.m_medusaBoxes.addUnitWithType(gg_unit_n02C_0282, 1.0)
			set index = thistype.m_medusaBoxes.addUnitWithType(gg_unit_n032_0268, 1.0)
			set index = thistype.m_medusaBoxes.addUnitWithType(gg_unit_n031_0279, 1.0)
			set index = thistype.m_medusaBoxes.addUnitWithType(gg_unit_n032_0278, 1.0)
			
			// units
			set thistype.m_medusa = SpawnPoint.create()
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n033_0239, 1.0)
			call thistype.m_medusa.addItemType(index, 'I04J', 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n034_0265, 1.0)
			call thistype.m_medusa.addItemType(index, 'rhe3', 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n034_0290, 1.0)
			call thistype.m_medusa.addItemType(index, 'rhe3', 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n034_0289, 1.0)
			call thistype.m_medusa.addItemType(index, 'rhe3', 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n034_0291, 1.0)
			call thistype.m_medusa.addItemType(index, 'rma2', 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n043_0486, 1.0)
			call thistype.m_medusa.addItemType(index, 'rma2', 1.0)

			set thistype.m_deathVault = SpawnPoint.create()
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n035_0299, 1.0)
			call thistype.m_deathVault.addItemType(index, 'I04E', 1.0)
			call thistype.m_deathVault.addItemType(index, 'I04K', 1.0)
			call thistype.m_deathVault.addItemType(index, 'I04I', 1.0)
			call thistype.m_deathVault.addItemType(index, 'I04F', 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n037_0301, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n03B_0302, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n03B_0305, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n036_0311, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n03B_0304, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n03B_0306, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n036_0308, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n036_0312, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n03A_0313, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n03A_0314, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n037_0333, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n036_0319, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n036_0309, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n036_0310, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n036_0330, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n036_0331, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n036_0332, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n038_0317, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n038_0318, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n036_0332, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n038_0317, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n038_0318, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n03A_0316, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n03A_0315, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n038_0326, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n038_0327, 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n038_0328, 1.0)
			
			set thistype.m_deathVaultBoxes0 = SpawnPoint.create()
			set index = thistype.m_deathVaultBoxes0.addUnitWithType(gg_unit_n02C_0360, 1.0)
			call thistype.m_deathVaultBoxes0.addItemType(index, 'I00B', 1.0)
			call thistype.m_deathVaultBoxes0.addItemType(index, 'I056', 1.0)
			set index = thistype.m_deathVaultBoxes0.addUnitWithType(gg_unit_n02C_0364, 1.0)
			call thistype.m_deathVaultBoxes0.addItemType(index, 'I00A', 1.0)
			call thistype.m_deathVaultBoxes0.addItemType(index, 'I00D', 1.0)
			set index = thistype.m_deathVaultBoxes0.addUnitWithType(gg_unit_n04B_0361, 1.0)
			call thistype.m_deathVaultBoxes0.addItemType(index, 'I00C', 1.0)
			set index = thistype.m_deathVaultBoxes0.addUnitWithType(gg_unit_n04B_0362, 1.0)
			call thistype.m_deathVaultBoxes0.addItemType(index, 'I00B', 1.0)
			call thistype.m_deathVaultBoxes0.addItemType(index, 'I00A', 1.0)
			call thistype.m_deathVaultBoxes0.addItemType(index, 'I00D', 1.0)
			set index = thistype.m_deathVaultBoxes0.addUnitWithType(gg_unit_n04B_0363, 1.0)
			call thistype.m_deathVaultBoxes0.addItemType(index, 'I00C', 1.0)
			call thistype.m_deathVaultBoxes0.addItemType(index, 'I056', 1.0)
			
			set thistype.m_deathVaultBoxes1 = SpawnPoint.create()
			set index = thistype.m_deathVaultBoxes1.addUnitWithType(gg_unit_n02C_0367, 1.0)
			call thistype.m_deathVaultBoxes1.addItemType(index, 'I00A', 1.0)
			call thistype.m_deathVaultBoxes1.addItemType(index, 'I00D', 1.0)
			set index = thistype.m_deathVaultBoxes1.addUnitWithType(gg_unit_n02C_0366, 1.0)
			call thistype.m_deathVaultBoxes1.addItemType(index, 'I00B', 1.0)
			call thistype.m_deathVaultBoxes1.addItemType(index, 'I00D', 1.0)
			call thistype.m_deathVaultBoxes1.addItemType(index, 'I056', 1.0)
			set index = thistype.m_deathVaultBoxes1.addUnitWithType(gg_unit_n02C_0365, 1.0)
			call thistype.m_deathVaultBoxes1.addItemType(index, 'I00A', 1.0)
			call thistype.m_deathVaultBoxes1.addItemType(index, 'I00D', 1.0)
			call thistype.m_deathVaultBoxes1.addItemType(index, 'I056', 1.0)

			set thistype.m_deathAngel = SpawnPoint.create()
			set index = thistype.m_deathAngel.addUnitWithType(gg_unit_n02K_0160, 1.0)
			set index = thistype.m_deathAngel.addUnitWithType(gg_unit_n00Y_0185, 1.0)
			set index = thistype.m_deathAngel.addUnitWithType(gg_unit_n00Y_0184, 1.0)
			set index = thistype.m_deathAngel.addUnitWithType(gg_unit_n00Y_0183, 1.0)

			set thistype.m_boneDragons = SpawnPoint.create()
			set index = thistype.m_boneDragons.addUnitWithType(gg_unit_n024_0033, 1.0)
			set index = thistype.m_boneDragons.addUnitWithType(gg_unit_n024_0032, 1.0)
			set index = thistype.m_boneDragons.addUnitWithType(gg_unit_n024_0031, 1.0)
			
			set thistype.m_witch0 = SpawnPoint.create()
			set index = thistype.m_witch0.addUnitWithType(gg_unit_h00F_0242, 1.0)
			call thistype.m_witch0.addItemType(index, 'I03E', 1.0)

			set thistype.m_witch1 = SpawnPoint.create()
			set index = thistype.m_witch1.addUnitWithType(gg_unit_h00F_0241, 1.0)
			call thistype.m_witch1.addItemType(index, 'I03E', 0.60)

			set thistype.m_witch2 = SpawnPoint.create()
			set index = thistype.m_witch2.addUnitWithType(gg_unit_h00F_0244, 1.0)
			call thistype.m_witch2.addItemType(index, 'I03E', 0.60)

			set thistype.m_witches = SpawnPoint.create()
			set index = thistype.m_witches.addUnitWithType(gg_unit_h00F_0246, 1.0)
			call thistype.m_witches.addItemType(index, 'I00B', 1.0)
			call thistype.m_witches.addItemType(index, 'I00C', 1.0)
			call thistype.m_witches.addItemType(index, 'I00F', 0.60)
			call thistype.m_witches.addItemType(index, 'I03E', 0.60)
			set index = thistype.m_witches.addUnitWithType(gg_unit_h00F_0247, 1.0)
			call thistype.m_witches.addItemType(index, 'I00B', 1.0)
			call thistype.m_witches.addItemType(index, 'I00C', 1.0)
			call thistype.m_witches.addItemType(index, 'I00F', 0.60)
			call thistype.m_witches.addItemType(index, 'I03E', 0.60)
			set index = thistype.m_witches.addUnitWithType(gg_unit_h00F_0245, 1.0)
			call thistype.m_witches.addItemType(index, 'I00B', 1.0)
			call thistype.m_witches.addItemType(index, 'I00C', 1.0)
			call thistype.m_witches.addItemType(index, 'I00F', 0.60)
			call thistype.m_witches.addItemType(index, 'I03E', 0.60)

			set thistype.m_wildCreatures = SpawnPoint.create()
			set index = thistype.m_wildCreatures.addUnitWithType(gg_unit_n02Q_0402, 1.0)
			call thistype.m_wildCreatures.addItemType(index, 'rhe2', 0.50)
			call thistype.m_wildCreatures.addItemType(index, 'I04O', 0.60)
			call thistype.m_wildCreatures.addItemType(index, 'I04P', 0.30)
			set index = thistype.m_wildCreatures.addUnitWithType(gg_unit_n02Q_0404, 1.0)
			call thistype.m_wildCreatures.addItemType(index, 'I04O', 0.60)
			call thistype.m_wildCreatures.addItemType(index, 'rhe2', 0.50)
			call thistype.m_wildCreatures.addItemType(index, 'I04P', 0.30)
			set index = thistype.m_wildCreatures.addUnitWithType(gg_unit_n02Q_0403, 1.0)
			call thistype.m_wildCreatures.addItemType(index, 'I04O', 0.60)
			call thistype.m_wildCreatures.addItemType(index, 'rhe2', 0.50)
			call thistype.m_wildCreatures.addItemType(index, 'I04P', 0.30)
			
			set thistype.m_orcs0 = SpawnPoint.create()
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01A_0221, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I04T', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n019_0222, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I04S', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n019_0224, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I04S', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n019_0223, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I04S', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01F_0229, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I04Q', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01G_0230, 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01V_0321, 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01G_0225, 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01W_0323, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I04R', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01X_0322, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I04R', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n044_0538, 1.0)
			// boxes
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0550, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addItemType(index, 'I00B', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0548, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addItemType(index, 'I00C', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0547, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addItemType(index, 'I00B', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n032_0549, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addItemType(index, 'I00C', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n032_0553, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addItemType(index, 'I00C', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0551, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addItemType(index, 'I00C', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0552, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addItemType(index, 'I00C', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0554, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addItemType(index, 'I00B', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0555, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addItemType(index, 'I00C', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n04B_0556, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addItemType(index, 'I00B', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n04B_0557, 1.0)
			call thistype.m_orcs0.addItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addItemType(index, 'I00B', 0.50)
			
			set thistype.m_cornEaters0 = SpawnPoint.create()
			set index = thistype.m_cornEaters0.addUnitWithType(gg_unit_n016_0478, 1.0)
			call thistype.m_cornEaters0.addItemType(index, 'whwd', 1.0)
			set thistype.m_cornEaters1 = SpawnPoint.create()
			set index = thistype.m_cornEaters1.addUnitWithType(gg_unit_n016_0473, 1.0)
			call thistype.m_cornEaters1.addItemType(index, 'whwd', 1.0)
			set index = thistype.m_cornEaters1.addUnitWithType(gg_unit_n016_0474, 1.0)
			call thistype.m_cornEaters1.addItemType(index, 'whwd', 1.0)
			call thistype.m_cornEaters1.addItemType(index, 'I047', 1.0)
			set index = thistype.m_cornEaters1.addUnitWithType(gg_unit_n016_0472, 1.0)
			call thistype.m_cornEaters1.addItemType(index, 'whwd', 1.0)
			call thistype.m_cornEaters1.addItemType(index, 'I046', 0.50)
			
			// drum cave
			set thistype.m_skeletons0 = SpawnPoint.create()
			set index = thistype.m_skeletons0.addUnitWithType(gg_unit_n00X_0257, 1.0)
			set index = thistype.m_skeletons0.addUnitWithType(gg_unit_n00X_0256, 1.0)
			set index = thistype.m_skeletons0.addUnitWithType(gg_unit_n00X_0255, 1.0)
			
			set thistype.m_skeletons1 = SpawnPoint.create()
			set index = thistype.m_skeletons1.addUnitWithType(gg_unit_n00Y_0261, 1.0)
			set index = thistype.m_skeletons1.addUnitWithType(gg_unit_n01O_0258, 1.0)
			set index = thistype.m_skeletons1.addUnitWithType(gg_unit_n01O_0260, 1.0)
		endmethod

		public static method spawn takes nothing returns nothing
			//call thistype.m_spawnPointBoars0.spawn()
			//call thistype.m_spawnPointBoars1.spawn()
			//call thistype.m_spawnPointBoars2.spawn()
			//call thistype.m_spawnPointBoars3.spawn()
			//call thistype.m_spawnPointBoars4.spawn()
			//call thistype.m_spawnPointBoars5.spawn()
		endmethod

		public static method vampireLord0 takes nothing returns SpawnPoint
			return thistype.m_vampireLord0
		endmethod

		public static method vampires0 takes nothing returns SpawnPoint
			return thistype.m_vampires0
		endmethod

		public static method medusa takes nothing returns SpawnPoint
			return thistype.m_medusa
		endmethod

		public static method deathVault takes nothing returns SpawnPoint
			return thistype.m_deathVault
		endmethod

		public static method deathAngel takes nothing returns SpawnPoint
			return thistype.m_deathAngel
		endmethod

		public static method boneDragons takes nothing returns SpawnPoint
			return thistype.m_boneDragons
		endmethod
		
		public static method orcs0 takes nothing returns SpawnPoint
			return thistype.m_orcs0
		endmethod
		
		public static method destroyOrcs0 takes nothing returns nothing
			call thistype.m_orcs0.destroy()
			set thistype.m_orcs0 = 0
		endmethod
		
		public static method banditsAtGuntrichsMill takes nothing returns SpawnPoint
			return thistype.m_banditsAtGuntrichsMill
		endmethod
		
		public static method cornEaters0 takes nothing returns SpawnPoint
			return thistype.m_cornEaters0
		endmethod
		
		public static method cornEaters1 takes nothing returns SpawnPoint
			return thistype.m_cornEaters1
		endmethod
		
		public static method witch0 takes nothing returns SpawnPoint
			return thistype.m_witch0
		endmethod
		
		public static method witch1 takes nothing returns SpawnPoint
			return thistype.m_witch1
		endmethod
		
		public static method witch2 takes nothing returns SpawnPoint
			return thistype.m_witch2
		endmethod
		
		public static method witches takes nothing returns SpawnPoint
			return thistype.m_witches
		endmethod
	endstruct

endlibrary