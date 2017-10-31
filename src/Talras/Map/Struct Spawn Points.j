library StructMapMapSpawnPoints requires Asl, StructGameItemTypes, StructGameSpawnPoint

	struct SpawnPoints
		// wolves start 0
		private static SpawnPoint m_wolvesStart0
		// wolves start 1
		private static SpawnPoint m_wolvesStart1
		// boars start 0
		private static SpawnPoint m_boarsStart0
		private static SpawnPoint m_boarsStart1
		private static SpawnPoint m_boarsStart2
		private static SpawnPoint m_boarsStart3

		private static SpawnPoint m_wolves0
		private static SpawnPoint m_wolves1
		private static SpawnPoint m_wolves2
		private static SpawnPoint m_wolves3
		private static SpawnPoint m_wolves4
		private static SpawnPoint m_boars0
		private static SpawnPoint m_boars1
		private static SpawnPoint m_bears0
		private static SpawnPoint m_boars2
		private static SpawnPoint m_boars3
		// right from the gate
		private static SpawnPoint m_highwaymen0
		private static SpawnPoint m_deers0
		private static SpawnPoint m_bears1

		private static SpawnPoint m_ditchSpiders0
		private static SpawnPoint m_ditchSpiders1
		private static SpawnPoint m_ditchSpiders2
		private static SpawnPoint m_banditsAtGuntrichsMill
		private static SpawnPoint m_box0
		private static SpawnPoint m_box1
		private static SpawnPoint m_box2
		private static SpawnPoint m_giants0
		// start
		private static ItemSpawnPoint m_healingHerbStart0
		private static ItemSpawnPoint m_healingHerbStart1
		private static ItemSpawnPoint m_manaHerbStart0
		// near Dago
		private static ItemSpawnPoint m_mushroom0
		private static ItemSpawnPoint m_mushroom1
		private static ItemSpawnPoint m_mushroom2
		private static ItemSpawnPoint m_mushroom3
		private static ItemSpawnPoint m_mushroom4
		private static ItemSpawnPoint m_mushroom5
		private static ItemSpawnPoint m_mushroom6
		private static ItemSpawnPoint m_healingHerb0
		private static ItemSpawnPoint m_healingHerb1
		private static ItemSpawnPoint m_healingHerb2
		private static ItemSpawnPoint m_healingHerb3
		private static ItemSpawnPoint m_healingHerb4
		private static ItemSpawnPoint m_manaHerb0
		private static ItemSpawnPoint m_manaHerb1
		private static ItemSpawnPoint m_manaHerb2
		private static ItemSpawnPoint m_manaHerb3

		// way up to the castle
		private static ItemSpawnPoint m_healingHerb5
		private static ItemSpawnPoint m_healingHerb6
		private static ItemSpawnPoint m_manaHerb4
		private static ItemSpawnPoint m_manaHerb5
		private static ItemSpawnPoint m_apple0
		private static ItemSpawnPoint m_apple1
		private static ItemSpawnPoint m_apple2

		// drum cave
		private static ItemSpawnPoint m_iron0
		private static ItemSpawnPoint m_iron1
		private static ItemSpawnPoint m_iron2
		private static ItemSpawnPoint m_iron3
		private static ItemSpawnPoint m_iron4
		private static ItemSpawnPoint m_iron5
		private static ItemSpawnPoint m_iron6
		private static ItemSpawnPoint m_iron7
		private static ItemSpawnPoint m_iron8
		private static ItemSpawnPoint m_iron9


		private static SpawnPoint m_vampireLord0
		private static SpawnPoint m_vampires0
		private static SpawnPoint m_box3
		private static SpawnPoint m_undeadsWithKing

		// death vault
		private static SpawnPoint m_medusaBoxes
		private static SpawnPoint m_deathVault
		private static SpawnPoint m_deathVaultBoxes0
		private static SpawnPoint m_deathVaultBoxes1

		// deranor's tomb
		private static SpawnPoint m_dearnorsGuard

		private static SpawnPoint m_deathAngel
		private static SpawnPoint m_boneDragons
		private static SpawnPoint m_giant
		private static SpawnPoint m_witch0
		private static SpawnPoint m_witch1
		private static SpawnPoint m_witch2
		private static SpawnPoint m_witch3
		private static SpawnPoint m_witches
		private static SpawnPoint m_wildCreatures
		private static SpawnPoint m_orcs0
		private static SpawnPoint m_cornEaters0
		private static SpawnPoint m_cornEaters1
		private static SpawnPoint m_cornEaters2
		private static SpawnPoint m_cornEaters3
		private static SpawnPoint m_cornEaters4
		private static SpawnPoint m_spiderQueen
		private static SpawnPoint m_undeadsForest

		// drum cave
		private static SpawnPoint m_skeletons0
		private static SpawnPoint m_skeletons1

		// tomb (Deranor)
		//private static SpawnPoint m_

		private static SpawnPoint m_bearMen0

		// river
		private static SpawnPoint m_necks0
		private static SpawnPoint m_necks1
		private static SpawnPoint m_necks2
		private static SpawnPoint m_necks3

		// farm
		private static SpawnPoint m_ditchSpidersFarm0
		private static SpawnPoint m_wolvesFarm0
		private static SpawnPoint m_boarsFarm0
		private static SpawnPoint m_deersFarm0
		private static SpawnPoint m_necksFarm0

		// left gate
		private static SpawnPoint m_boarsLeftGate0
		private static SpawnPoint m_bearLeftGate0
		private static SpawnPoint m_wolvesLeftGate0

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method init0 takes nothing returns nothing
			local integer index
			local integer itemIndex

			 // wolves start 0
			set thistype.m_wolvesStart0 = SpawnPoint.create()
			set index = thistype.m_wolvesStart0.addUnitWithType(gg_unit_n02F_0502, 1.0)
			call thistype.m_wolvesStart0.addNewItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolvesStart0.addUnitWithType(gg_unit_n02F_0500, 1.0)
			call thistype.m_wolvesStart0.addNewItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolvesStart0.addUnitWithType(gg_unit_n02F_0501, 1.0)
			call thistype.m_wolvesStart0.addNewItemType(index, 'I01H', 1.0)
			call thistype.m_wolvesStart0.addNewItemType(index, 'rhe1', 1.0)
			// wolves start 1
			set thistype.m_wolvesStart1 = SpawnPoint.create()
			set index = thistype.m_wolvesStart1.addUnitWithType(gg_unit_n02F_0503, 1.0)
			call thistype.m_wolvesStart1.addNewItemType(index, 'I01H', 1.0)
			call thistype.m_wolvesStart1.addNewItemType(index, 'rman', 1.0)
			set index = thistype.m_wolvesStart1.addUnitWithType(gg_unit_n02F_0504, 1.0)
			call thistype.m_wolvesStart1.addNewItemType(index, 'I01H', 1.0)

			// boars start 0
			set thistype.m_boarsStart0 = SpawnPoint.create()
			set index = thistype.m_boarsStart0.addUnitWithType(gg_unit_n002_0505, 1.0)
			call thistype.m_boarsStart0.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsStart0.addUnitWithType(gg_unit_n002_0507, 1.0)
			call thistype.m_boarsStart0.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsStart0.addUnitWithType(gg_unit_n002_0506, 1.0)
			call thistype.m_boarsStart0.addNewItemType(index, 'I007', 1.0)
			call thistype.m_boarsStart0.addNewItemType(index, 'rhe2', 1.0)

			// boars start 1
			set thistype.m_boarsStart1 = SpawnPoint.create()
			set index = thistype.m_boarsStart1.addUnitWithType(gg_unit_n002_0212, 1.0)
			call thistype.m_boarsStart1.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsStart1.addUnitWithType(gg_unit_n002_0210, 1.0)
			call thistype.m_boarsStart1.addNewItemType(index, 'I007', 1.0)

			// boars start 2
			set thistype.m_boarsStart2 = SpawnPoint.create()
			set index = thistype.m_boarsStart2.addUnitWithType(gg_unit_n002_0254, 1.0)
			call thistype.m_boarsStart2.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsStart2.addUnitWithType(gg_unit_n002_0220, 1.0)
			call thistype.m_boarsStart2.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsStart2.addUnitWithType(gg_unit_n002_0219, 1.0)
			call thistype.m_boarsStart2.addNewItemType(index, 'I007', 1.0)

			// boars start 3
			set thistype.m_boarsStart3 = SpawnPoint.create()
			set index = thistype.m_boarsStart3.addUnitWithType(gg_unit_n002_0688, 1.0)
			call thistype.m_boarsStart3.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsStart3.addUnitWithType(gg_unit_n002_0682, 1.0)
			call thistype.m_boarsStart3.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsStart3.addUnitWithType(gg_unit_n06K_0690, 1.0)
			call thistype.m_boarsStart3.addNewItemType(index, 'I007', 1.0)

			set thistype.m_wolves0 = SpawnPoint.create()
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02G_0140, 1.0)
			call thistype.m_wolves0.addNewItemType(index, 'I01I', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0139, 1.0)
			call thistype.m_wolves0.addNewItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0114, 1.0)
			call thistype.m_wolves0.addNewItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0136, 1.0)
			call thistype.m_wolves0.addNewItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0008, 1.0)
			call thistype.m_wolves0.addNewItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0109, 1.0)
			call thistype.m_wolves0.addNewItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0123, 1.0)
			call thistype.m_wolves0.addNewItemType(index, 'I01H', 1.0)

			set thistype.m_wolves1 = SpawnPoint.create()
			set index = thistype.m_wolves1.addUnitWithType(gg_unit_n02F_0296, 1.0)
			call thistype.m_wolves1.addNewItemType(index, 'I01I', 1.0)
			set index = thistype.m_wolves1.addUnitWithType(gg_unit_n02F_0297, 1.0)
			call thistype.m_wolves1.addNewItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves1.addUnitWithType(gg_unit_n02F_0277, 1.0)
			call thistype.m_wolves1.addNewItemType(index, 'I01H', 1.0)

			set thistype.m_wolves2 = SpawnPoint.create()
			set index = thistype.m_wolves2.addUnitWithType(gg_unit_n02F_0016, 1.0)
			call thistype.m_wolves2.addNewItemType(index, 'I01H', 1.0)

			/*
			 * Wolves below the cows.
			 */
			set thistype.m_wolves3 = SpawnPoint.create()
			set index = thistype.m_wolves3.addUnitWithType(gg_unit_n02F_0416, 1.0)
			call thistype.m_wolves3.addNewItemType(index, 'I01I', 1.0)
			set index = thistype.m_wolves3.addUnitWithType(gg_unit_n02F_0417, 1.0)
			call thistype.m_wolves3.addNewItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves3.addUnitWithType(gg_unit_n02F_0418, 1.0)
			call thistype.m_wolves3.addNewItemType(index, 'I01H', 1.0)

			/*
			 * wolves below the mill hill.
			 */
			set thistype.m_wolves4 = SpawnPoint.create()
			set index = thistype.m_wolves4.addUnitWithType(gg_unit_n02F_0460, 1.0)
			call thistype.m_wolves4.addNewItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves4.addUnitWithType(gg_unit_n02F_0459, 1.0)
			call thistype.m_wolves4.addNewItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves4.addUnitWithType(gg_unit_n02G_0458, 1.0)
			call thistype.m_wolves4.addNewItemType(index, 'I01I', 1.0)

			set thistype.m_boars0 = SpawnPoint.create()
			set index = thistype.m_boars0.addUnitWithType(gg_unit_n002_0078, 1.0)
			call thistype.m_boars0.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boars0.addUnitWithType(gg_unit_n002_0079, 1.0)
			call thistype.m_boars0.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boars0.addUnitWithType(gg_unit_n002_0080, 1.0)
			call thistype.m_boars0.addNewItemType(index, 'I007', 1.0)

			set thistype.m_boars1 = SpawnPoint.create()
			set index = thistype.m_boars1.addUnitWithType(gg_unit_n002_0076, 1.0)
			call thistype.m_boars1.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boars1.addUnitWithType(gg_unit_n002_0077, 1.0)
			call thistype.m_boars1.addNewItemType(index, 'I007', 1.0)

			set thistype.m_bears0 = SpawnPoint.create()
			set index = thistype.m_bears0.addUnitWithType(gg_unit_n008_0121, 1.0)
			call thistype.m_bears0.addNewItemType(index, 'I01J', 1.0)

			set thistype.m_boars2 = SpawnPoint.create()
			set index = thistype.m_boars2.addUnitWithType(gg_unit_n002_0122, 1.0)
			call thistype.m_boars2.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boars2.addUnitWithType(gg_unit_n002_0124, 1.0)
			call thistype.m_boars2.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boars2.addUnitWithType(gg_unit_n06K_0422, 1.0)
			call thistype.m_boars2.addNewItemType(index, 'I007', 1.0)

			set thistype.m_boars3 = SpawnPoint.create()
			set index = thistype.m_boars3.addUnitWithType(gg_unit_n002_0276, 1.0)
			call thistype.m_boars3.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boars3.addUnitWithType(gg_unit_n002_0275, 1.0)
			call thistype.m_boars3.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boars3.addUnitWithType(gg_unit_n002_0273, 1.0)
			call thistype.m_boars3.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boars3.addUnitWithType(gg_unit_n002_0274, 1.0)
			call thistype.m_boars3.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boars3.addUnitWithType(gg_unit_n002_0272, 1.0)
			call thistype.m_boars3.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boars3.addUnitWithType(gg_unit_n06K_0423, 1.0)
			call thistype.m_boars3.addNewItemType(index, 'I007', 1.0)

			set thistype.m_highwaymen0 = SpawnPoint.create()
			set index = thistype.m_highwaymen0.addUnitWithType(gg_unit_n00T_0125, 1.0)
			set itemIndex = thistype.m_highwaymen0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I00T', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rhe2', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rman', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I049', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I04D', 0.50)
			set index = thistype.m_highwaymen0.addUnitWithType(gg_unit_n00U_0128, 1.0)
			set itemIndex = thistype.m_highwaymen0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I00T', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rhe2', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rman', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I049', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I04D', 0.50)
			set index = thistype.m_highwaymen0.addUnitWithType(gg_unit_n00U_0127, 1.0)
			set itemIndex = thistype.m_highwaymen0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I00T', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rhe2', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rman', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I049', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I04D', 0.50)
			set index = thistype.m_highwaymen0.addUnitWithType(gg_unit_n00T_0126, 1.0)
			set itemIndex = thistype.m_highwaymen0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I00T', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rhe2', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rman', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I049', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I04D', 0.50)
			set index = thistype.m_highwaymen0.addUnitWithType(gg_unit_n00U_0129, 1.0)
			set itemIndex = thistype.m_highwaymen0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I00T', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rhe2', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rman', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I049', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I04D', 0.50)
			set index = thistype.m_highwaymen0.addUnitWithType(gg_unit_n00T_0130, 1.0)
			set itemIndex = thistype.m_highwaymen0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I00T', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rhe2', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rman', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I049', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I04D', 0.50)
			set index = thistype.m_highwaymen0.addUnitWithType(gg_unit_n00T_0131, 1.0)
			set itemIndex = thistype.m_highwaymen0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I00T', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rhe2', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'rman', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I049', 0.50)
			call thistype.m_highwaymen0.addItemType(index, itemIndex, 'I04D', 0.50)

			set thistype.m_deers0 = SpawnPoint.create()
			set index = thistype.m_deers0.addUnitWithType(gg_unit_n00V_0132, 1.0)
			call thistype.m_deers0.addNewItemType(index, 'I00P', 1.0)
			set index = thistype.m_deers0.addUnitWithType(gg_unit_n00V_0133, 1.0)
			call thistype.m_deers0.addNewItemType(index, 'I00P', 1.0)
			set index = thistype.m_deers0.addUnitWithType(gg_unit_n00V_0134, 1.0)
			call thistype.m_deers0.addNewItemType(index, 'I00P', 1.0)

			set thistype.m_bears1 = SpawnPoint.create()
			set index = thistype.m_bears1.addUnitWithType(gg_unit_n008_0582, 1.0)
			call thistype.m_bears1.addNewItemType(index, 'I01J', 1.0)
			set index = thistype.m_bears1.addUnitWithType(gg_unit_n008_0583, 1.0)
			call thistype.m_bears1.addNewItemType(index, 'I01J', 1.0)
			set index = thistype.m_bears1.addUnitWithType(gg_unit_n008_0584, 1.0)
			call thistype.m_bears1.addNewItemType(index, 'I01J', 1.0)

			set thistype.m_ditchSpiders0 = SpawnPoint.create()
			set index = thistype.m_ditchSpiders0.addUnitWithType(gg_unit_n01E_0075, 1.0)
			call thistype.m_ditchSpiders0.addNewItemType(index, 'I041', 1.0)

			set thistype.m_ditchSpiders1 = SpawnPoint.create()
			set index = thistype.m_ditchSpiders1.addUnitWithType(gg_unit_n01E_0070, 1.0)
			call thistype.m_ditchSpiders1.addNewItemType(index, 'I041', 1.0)
			set index = thistype.m_ditchSpiders1.addUnitWithType(gg_unit_n01E_0074, 1.0)
			call thistype.m_ditchSpiders1.addNewItemType(index, 'I041', 1.0)

			set thistype.m_ditchSpiders2 = SpawnPoint.create()
			set index = thistype.m_ditchSpiders2.addUnitWithType(gg_unit_n01D_0024, 1.0)
			call thistype.m_ditchSpiders2.addNewItemType(index, 'I041', 1.0)
			set index = thistype.m_ditchSpiders2.addUnitWithType(gg_unit_n01D_0023, 1.0)
			call thistype.m_ditchSpiders2.addNewItemType(index, 'I041', 1.0)
		endmethod

		private static method init1 takes nothing returns nothing
			local integer index

			set thistype.m_banditsAtGuntrichsMill = SpawnPoint.create()
			set index = thistype.m_banditsAtGuntrichsMill.addUnitWithType(gg_unit_n00T_0491, 1.0)
			set index = thistype.m_banditsAtGuntrichsMill.addUnitWithType(gg_unit_n00T_0492, 1.0)
			set index = thistype.m_banditsAtGuntrichsMill.addUnitWithType(gg_unit_n00U_0494, 1.0)
			set index = thistype.m_banditsAtGuntrichsMill.addUnitWithType(gg_unit_n00U_0493, 1.0)
			set index = thistype.m_banditsAtGuntrichsMill.addUnitWithType(gg_unit_n00U_0495, 1.0)

			set thistype.m_box0 = SpawnPoint.create()
			set index = thistype.m_box0.addUnitWithType(gg_unit_n02C_0059, 1.0)
			call thistype.m_box0.addNewItemType(index, 'I00A', 1.0)

			set thistype.m_box1 = SpawnPoint.create()
			set index = thistype.m_box1.addUnitWithType(gg_unit_n02C_0060, 1.0)
			call thistype.m_box1.addNewItemType(index, 'I01G', 1.0)

			set thistype.m_box2 = SpawnPoint.create()
			set index = thistype.m_box2.addUnitWithType(gg_unit_n02C_0061, 1.0)
			call thistype.m_box2.addNewItemType(index, 'I00D', 1.0)

			set thistype.m_giant = SpawnPoint.create()
			set index = thistype.m_giant.addUnitWithType(gg_unit_n02R_0253, 1.0)
			/*
			 * Make sure these items are always dropped since they are required for Björn's quest.
			 */
			call thistype.m_giant.addNewItemType(index, 'I01Z', 1.0)
			call thistype.m_giant.addNewItemType(index, 'I01Z', 1.0)

			set thistype.m_giants0 = SpawnPoint.create()
			set index = thistype.m_giants0.addUnitWithType(gg_unit_n02R_0035, 1.0)
			call thistype.m_giants0.addNewItemType(index, 'I01Z', 1.0)
			call thistype.m_giants0.addNewItemType(index, 'I01Z', 1.0)
			set index = thistype.m_giants0.addUnitWithType(gg_unit_n02R_0036, 1.0)
			call thistype.m_giants0.addNewItemType(index, 'I01Z', 1.0)
			call thistype.m_giants0.addNewItemType(index, 'I01Z', 1.0)
			set index = thistype.m_giants0.addUnitWithType(gg_unit_n02R_0037, 1.0)
			call thistype.m_giants0.addNewItemType(index, 'I01Z', 1.0)
			call thistype.m_giants0.addNewItemType(index, 'I01Z', 1.0)


			// start
			set thistype.m_healingHerbStart0 = ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0448, 1.0)
			set thistype.m_healingHerbStart1 = ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0449, 1.0)

			set thistype.m_manaHerbStart0 = ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0450, 1.0)

			// near Dago

			set thistype.m_mushroom0 = ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0238, 1.0)
			set thistype.m_mushroom1 = ItemSpawnPoint.createFromItemWithType(gg_item_I01L_0205, 1.0)
			set thistype.m_mushroom2 = ItemSpawnPoint.createFromItemWithType(gg_item_I03Y_0207, 1.0)
			set thistype.m_mushroom3 = ItemSpawnPoint.createFromItemWithType(gg_item_I03Y_0206, 1.0)
			set thistype.m_mushroom4 = ItemSpawnPoint.createFromItemWithType(gg_item_I01L_0211, 1.0)
			set thistype.m_mushroom5 = ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0213, 1.0)
			set thistype.m_mushroom6 = ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0214, 1.0)

			set thistype.m_healingHerb0 = ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0426, 1.0)
			set thistype.m_healingHerb1 = ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0428, 1.0)
			set thistype.m_healingHerb2 = ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0429, 1.0)
			set thistype.m_healingHerb3 = ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0425, 1.0)
			set thistype.m_healingHerb4 = ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0427, 1.0)

			set thistype.m_manaHerb0 = ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0431, 1.0)
			set thistype.m_manaHerb1 = ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0430, 1.0)
			set thistype.m_manaHerb2 = ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0432, 1.0)
			set thistype.m_manaHerb3 = ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0433, 1.0)

			// way up to the castle
			set thistype.m_healingHerb5 = ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0204, 1.0)
			set thistype.m_healingHerb6 = ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0438, 1.0)
			set thistype.m_manaHerb4 = ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0439, 1.0)
			set thistype.m_manaHerb5 = ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0442, 1.0)
			set thistype.m_apple0 = ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0443, 1.0)
			set thistype.m_apple1 = ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0445, 1.0)
			set thistype.m_apple2 = ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0444, 1.0)

			// drum cave
			set thistype.m_iron0 = ItemSpawnPoint.createFromItemWithType(gg_item_I05Y_0399, 1.0)
			set thistype.m_iron1 = ItemSpawnPoint.createFromItemWithType(gg_item_I05Y_0398, 1.0)
			set thistype.m_iron2 = ItemSpawnPoint.createFromItemWithType(gg_item_I05Y_0435, 1.0)
			set thistype.m_iron3 = ItemSpawnPoint.createFromItemWithType(gg_item_I05Y_0434, 1.0)
			set thistype.m_iron4 = ItemSpawnPoint.createFromItemWithType(gg_item_I05Y_0436, 1.0)
			set thistype.m_iron5 = ItemSpawnPoint.createFromItemWithType(gg_item_I05Y_0437, 1.0)
			set thistype.m_iron6 = ItemSpawnPoint.createFromItemWithType(gg_item_I05Y_0396, 1.0)
			set thistype.m_iron7 = ItemSpawnPoint.createFromItemWithType(gg_item_I05Y_0395, 1.0)
			set thistype.m_iron8 = ItemSpawnPoint.createFromItemWithType(gg_item_I05Y_0397, 1.0)
			set thistype.m_iron9 = ItemSpawnPoint.createFromItemWithType(gg_item_I05Y_0394, 1.0)


			set thistype.m_vampireLord0 = SpawnPoint.create()
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n010_0110, 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I013', 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I04L', 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I04G', 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I00C', 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I00B', 1.0)
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n00Z_0106, 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I00C', 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I04V', 1.0)
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n00Z_0107, 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I00C', 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I04V', 1.0)
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n00Z_0108, 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I00G', 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I04V', 1.0)
			// boxes
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n04B_0572, 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I00T', 1.0)
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n04B_0574, 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I00T', 1.0)
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n04B_0573, 1.0)
			call thistype.m_vampireLord0.addNewItemType(index, 'I00T', 1.0)

			set thistype.m_vampires0 = SpawnPoint.create()
			// vampires
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02L_0161, 1.0)
			call thistype.m_vampires0.addNewItemType(index, 'I02I', 1.0)
			call thistype.m_vampires0.addNewItemType(index, 'I04H', 0.60)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02L_0194, 1.0)
			call thistype.m_vampires0.addNewItemType(index, 'I02I', 1.0)
			call thistype.m_vampires0.addNewItemType(index, 'I04H', 0.60)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02L_0193, 1.0)
			call thistype.m_vampires0.addNewItemType(index, 'I02I', 1.0)
			call thistype.m_vampires0.addNewItemType(index, 'I04H', 0.60)
			// zombies
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02M_0231, 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02M_0162, 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02M_0232, 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02M_0233, 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02M_0234, 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02M_0235, 1.0)
			// archers
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n01O_0186, 1.0)
			call thistype.m_vampires0.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n01O_0187, 1.0)
			call thistype.m_vampires0.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n01O_0188, 1.0)
			call thistype.m_vampires0.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n01O_0189, 1.0)
			call thistype.m_vampires0.addNewItemType(index, 'I05I', 1.0)

			set thistype.m_box3 = SpawnPoint.create()
			set index = thistype.m_box3.addUnitWithType(gg_unit_n02C_0236, 1.0)
			call thistype.m_box3.addNewItemType(index, 'I01M', 1.0)
			call thistype.m_box3.addNewItemType(index, 'I00A', 1.0)
			set index = thistype.m_box3.addUnitWithType(gg_unit_n02C_0237, 1.0)
			call thistype.m_box3.addNewItemType(index, 'I013', 1.0)
			call thistype.m_box3.addNewItemType(index, 'I00D', 1.0)

			set thistype.m_undeadsWithKing = SpawnPoint.create()
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01P_0068, 1.0)
			call thistype.m_undeadsWithKing.addNewItemType(index, ItemTypes.swordOfDarkness().itemTypeId(), 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00Z_0067, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00Z_0066, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0178, 1.0)
			call thistype.m_undeadsWithKing.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0180, 1.0)
			call thistype.m_undeadsWithKing.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0179, 1.0)
			call thistype.m_undeadsWithKing.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0181, 1.0)
			call thistype.m_undeadsWithKing.addNewItemType(index, 'I05I', 1.0)
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
			call thistype.m_undeadsWithKing.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0176, 1.0)
			call thistype.m_undeadsWithKing.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0170, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0175, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0172, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0174, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0173, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n00O_0171, 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0166, 1.0)
			call thistype.m_undeadsWithKing.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0164, 1.0)
			call thistype.m_undeadsWithKing.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0163, 1.0)
			call thistype.m_undeadsWithKing.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_undeadsWithKing.addUnitWithType(gg_unit_n01O_0165, 1.0)
			call thistype.m_undeadsWithKing.addNewItemType(index, 'I05I', 1.0)
		endmethod

		private static method init2 takes nothing returns nothing
			local integer index = 0
			local integer itemIndex = 0

			// make boxes a separate spawn point, otherwise boxes might be left over
			set thistype.m_medusaBoxes = SpawnPoint.create()
			set index = thistype.m_medusaBoxes.addUnitWithType(gg_unit_n02C_0281, 1.0)
			set index = thistype.m_medusaBoxes.addUnitWithType(gg_unit_n02C_0280, 1.0)
			set index = thistype.m_medusaBoxes.addUnitWithType(gg_unit_n02C_0282, 1.0)
			set index = thistype.m_medusaBoxes.addUnitWithType(gg_unit_n032_0268, 1.0)
			set index = thistype.m_medusaBoxes.addUnitWithType(gg_unit_n031_0279, 1.0)
			set index = thistype.m_medusaBoxes.addUnitWithType(gg_unit_n032_0278, 1.0)

			// units
			set thistype.m_deathVault = SpawnPoint.create()
			// medusa
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n033_0239, 1.0)
			call thistype.m_deathVault.addNewItemType(index, 'I04J', 1.0)
			call thistype.m_deathVault.addNewItemType(index, 'I05W', 1.0)
			call thistype.m_deathVault.addNewItemType(index, 'I02S', 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n034_0265, 1.0)
			call thistype.m_deathVault.addNewItemType(index, 'rhe3', 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n034_0290, 1.0)
			call thistype.m_deathVault.addNewItemType(index, 'rhe3', 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n034_0289, 1.0)
			call thistype.m_deathVault.addNewItemType(index, 'rhe3', 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n034_0291, 1.0)
			call thistype.m_deathVault.addNewItemType(index, 'rma2', 1.0)
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n043_0486, 1.0)
			call thistype.m_deathVault.addNewItemType(index, 'rma2', 1.0)
			// diacon
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n035_0299, 1.0)
			call thistype.m_deathVault.addNewItemType(index, 'I04E', 1.0)
			call thistype.m_deathVault.addNewItemType(index, 'I04K', 1.0)
			call thistype.m_deathVault.addNewItemType(index, 'I04I', 1.0)
			call thistype.m_deathVault.addNewItemType(index, 'I04F', 1.0)
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
			call thistype.m_deathVaultBoxes0.addNewItemType(index, 'I00B', 1.0)
			call thistype.m_deathVaultBoxes0.addNewItemType(index, 'I056', 1.0)
			set index = thistype.m_deathVaultBoxes0.addUnitWithType(gg_unit_n02C_0364, 1.0)
			call thistype.m_deathVaultBoxes0.addNewItemType(index, 'I00A', 1.0)
			call thistype.m_deathVaultBoxes0.addNewItemType(index, 'I00D', 1.0)
			set index = thistype.m_deathVaultBoxes0.addUnitWithType(gg_unit_n04B_0361, 1.0)
			call thistype.m_deathVaultBoxes0.addNewItemType(index, 'I00C', 1.0)
			set index = thistype.m_deathVaultBoxes0.addUnitWithType(gg_unit_n04B_0362, 1.0)
			call thistype.m_deathVaultBoxes0.addNewItemType(index, 'I00B', 1.0)
			call thistype.m_deathVaultBoxes0.addNewItemType(index, 'I00A', 1.0)
			call thistype.m_deathVaultBoxes0.addNewItemType(index, 'I00D', 1.0)
			set index = thistype.m_deathVaultBoxes0.addUnitWithType(gg_unit_n04B_0363, 1.0)
			call thistype.m_deathVaultBoxes0.addNewItemType(index, 'I00C', 1.0)
			call thistype.m_deathVaultBoxes0.addNewItemType(index, 'I056', 1.0)

			set thistype.m_deathVaultBoxes1 = SpawnPoint.create()
			set index = thistype.m_deathVaultBoxes1.addUnitWithType(gg_unit_n02C_0367, 1.0)
			call thistype.m_deathVaultBoxes1.addNewItemType(index, 'I00A', 1.0)
			call thistype.m_deathVaultBoxes1.addNewItemType(index, 'I00D', 1.0)
			set index = thistype.m_deathVaultBoxes1.addUnitWithType(gg_unit_n02C_0366, 1.0)
			call thistype.m_deathVaultBoxes1.addNewItemType(index, 'I00B', 1.0)
			call thistype.m_deathVaultBoxes1.addNewItemType(index, 'I00D', 1.0)
			call thistype.m_deathVaultBoxes1.addNewItemType(index, 'I056', 1.0)
			set index = thistype.m_deathVaultBoxes1.addUnitWithType(gg_unit_n02C_0365, 1.0)
			call thistype.m_deathVaultBoxes1.addNewItemType(index, 'I00A', 1.0)
			call thistype.m_deathVaultBoxes1.addNewItemType(index, 'I00D', 1.0)
			call thistype.m_deathVaultBoxes1.addNewItemType(index, 'I056', 1.0)

			set thistype.m_deathAngel = SpawnPoint.create()
			set index = thistype.m_deathAngel.addUnitWithType(gg_unit_n02K_0160, 1.0)
			call thistype.m_deathAngel.addNewItemType(index, 'I05B', 1.0)
			call thistype.m_deathAngel.addNewItemType(index, 'I02Q', 1.0)
			set index = thistype.m_deathAngel.addUnitWithType(gg_unit_n00Y_0185, 1.0)
			set index = thistype.m_deathAngel.addUnitWithType(gg_unit_n00Y_0184, 1.0)
			set index = thistype.m_deathAngel.addUnitWithType(gg_unit_n00Y_0183, 1.0)

			set thistype.m_boneDragons = SpawnPoint.create()
			set index = thistype.m_boneDragons.addUnitWithType(gg_unit_n024_0033, 1.0)
			call thistype.m_boneDragons.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_boneDragons.addUnitWithType(gg_unit_n024_0032, 1.0)
			call thistype.m_boneDragons.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_boneDragons.addUnitWithType(gg_unit_n024_0031, 1.0)
			call thistype.m_boneDragons.addNewItemType(index, 'I05I', 1.0)

			set thistype.m_witch0 = SpawnPoint.create()
			set index = thistype.m_witch0.addUnitWithType(gg_unit_h00F_0242, 1.0)
			call thistype.m_witch0.addNewItemType(index, 'I03E', 1.0)
			call thistype.m_witch0.addNewItemType(index, 'I05H', 0.60)

			set thistype.m_witch1 = SpawnPoint.create()
			set index = thistype.m_witch1.addUnitWithType(gg_unit_h00F_0241, 1.0)
			call thistype.m_witch1.addNewItemType(index, 'I03E', 0.60)
			call thistype.m_witch1.addNewItemType(index, 'I05H', 0.60)

			set thistype.m_witch2 = SpawnPoint.create()
			set index = thistype.m_witch2.addUnitWithType(gg_unit_h00F_0244, 1.0)
			call thistype.m_witch2.addNewItemType(index, 'I03E', 0.60)
			call thistype.m_witch2.addNewItemType(index, 'I05H', 0.60)

			set thistype.m_witch3 = SpawnPoint.create()
			set index = thistype.m_witch3.addUnitWithType(gg_unit_h00F_0243, 1.0)
			call thistype.m_witch3.addNewItemType(index, 'I03E', 0.60)
			call thistype.m_witch3.addNewItemType(index, 'I05H', 0.60)

			set thistype.m_witches = SpawnPoint.create()
			set index = thistype.m_witches.addUnitWithType(gg_unit_h00F_0246, 1.0)
			call thistype.m_witches.addNewItemType(index, 'I00B', 1.0)
			call thistype.m_witches.addNewItemType(index, 'I00C', 1.0)
			call thistype.m_witches.addNewItemType(index, 'I00F', 0.60)
			call thistype.m_witches.addNewItemType(index, 'I03E', 0.60)
			call thistype.m_witches.addNewItemType(index, 'I05H', 0.60)
			call thistype.m_witches.addNewItemType(index, 'I05H', 0.60)
			set index = thistype.m_witches.addUnitWithType(gg_unit_h00F_0247, 1.0)
			call thistype.m_witches.addNewItemType(index, 'I00B', 1.0)
			call thistype.m_witches.addNewItemType(index, 'I00C', 1.0)
			call thistype.m_witches.addNewItemType(index, 'I00F', 0.60)
			call thistype.m_witches.addNewItemType(index, 'I03E', 0.60)
			call thistype.m_witches.addNewItemType(index, 'I05H', 0.60)
			call thistype.m_witches.addNewItemType(index, 'I05H', 0.60)
			set index = thistype.m_witches.addUnitWithType(gg_unit_h00F_0245, 1.0)
			call thistype.m_witches.addNewItemType(index, 'I00B', 1.0)
			call thistype.m_witches.addNewItemType(index, 'I00C', 1.0)
			call thistype.m_witches.addNewItemType(index, 'I00F', 0.60)
			call thistype.m_witches.addNewItemType(index, 'I03E', 0.60)
			call thistype.m_witches.addNewItemType(index, 'I05H', 0.60)
			call thistype.m_witches.addNewItemType(index, 'I05H', 0.60)

			set thistype.m_wildCreatures = SpawnPoint.create()
			set index = thistype.m_wildCreatures.addUnitWithType(gg_unit_n02Q_0402, 1.0)
			set itemIndex = thistype.m_wildCreatures.addNewItemType(index, 'rhe2', 0.33)
			call thistype.m_wildCreatures.addItemType(index, itemIndex, 'I04O', 0.33)
			call thistype.m_wildCreatures.addItemType(index, itemIndex, 'I04P', 0.33)
			set index = thistype.m_wildCreatures.addUnitWithType(gg_unit_n02Q_0404, 1.0)
			set itemIndex = thistype.m_wildCreatures.addNewItemType(index, 'rhe2', 0.33)
			call thistype.m_wildCreatures.addItemType(index, itemIndex, 'I04O', 0.33)
			call thistype.m_wildCreatures.addItemType(index, itemIndex, 'I04P', 0.33)
			set index = thistype.m_wildCreatures.addUnitWithType(gg_unit_n02Q_0403, 1.0)
			set itemIndex = thistype.m_wildCreatures.addNewItemType(index, 'rhe2', 0.33)
			call thistype.m_wildCreatures.addItemType(index, itemIndex, 'I04O', 0.33)
			call thistype.m_wildCreatures.addItemType(index, itemIndex, 'I04P', 0.33)

			set thistype.m_orcs0 = SpawnPoint.create()
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01A_0217, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I04T', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01A_0221, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I04T', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n019_0222, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I04S', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n019_0224, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I04S', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n019_0223, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I04S', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01F_0229, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I04Q', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01G_0230, 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01V_0321, 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01G_0225, 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01W_0323, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I04R', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n01X_0322, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I04R', 1.0)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n044_0538, 1.0)
			// boxes
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0550, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addNewItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addNewItemType(index, 'I00B', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0548, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addNewItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addNewItemType(index, 'I00C', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0547, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addNewItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addNewItemType(index, 'I00B', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n032_0549, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addNewItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addNewItemType(index, 'I00C', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n032_0553, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addNewItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addNewItemType(index, 'I00C', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0551, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addNewItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addNewItemType(index, 'I00C', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0552, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addNewItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addNewItemType(index, 'I00C', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0554, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addNewItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addNewItemType(index, 'I00B', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n02C_0555, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addNewItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addNewItemType(index, 'I00C', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n04B_0556, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addNewItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addNewItemType(index, 'I00B', 0.50)
			set index = thistype.m_orcs0.addUnitWithType(gg_unit_n04B_0557, 1.0)
			call thistype.m_orcs0.addNewItemType(index, 'I00S', 0.50)
			call thistype.m_orcs0.addNewItemType(index, 'I00T', 0.30)
			call thistype.m_orcs0.addNewItemType(index, 'I00B', 0.50)
		endmethod

		private static method init3 takes nothing returns nothing
			local integer index = 0
			local integer itemIndex = 0

			set thistype.m_cornEaters0 = SpawnPoint.create()
			set index = thistype.m_cornEaters0.addUnitWithType(gg_unit_n016_0478, 1.0)
			call thistype.m_cornEaters0.addNewItemType(index, 'I063', 1.0)

			set thistype.m_cornEaters1 = SpawnPoint.create()
			set index = thistype.m_cornEaters1.addUnitWithType(gg_unit_n016_0473, 1.0)
			call thistype.m_cornEaters1.addNewItemType(index, 'I063', 1.0)
			set index = thistype.m_cornEaters1.addUnitWithType(gg_unit_n016_0474, 1.0)
			call thistype.m_cornEaters1.addNewItemType(index, 'I063', 1.0)
			call thistype.m_cornEaters1.addNewItemType(index, 'I047', 1.0)
			set index = thistype.m_cornEaters1.addUnitWithType(gg_unit_n016_0472, 1.0)
			call thistype.m_cornEaters1.addNewItemType(index, 'I063', 1.0)
			call thistype.m_cornEaters1.addNewItemType(index, 'I046', 0.50)

			set thistype.m_cornEaters2 = SpawnPoint.create()
			set index = thistype.m_cornEaters2.addUnitWithType(gg_unit_n016_0614, 1.0)
			call thistype.m_cornEaters2.addNewItemType(index, 'I063', 1.0)
			set index = thistype.m_cornEaters2.addUnitWithType(gg_unit_n016_0613, 1.0)
			call thistype.m_cornEaters2.addNewItemType(index, 'I063', 1.0)
			set index = thistype.m_cornEaters2.addUnitWithType(gg_unit_n016_0612, 1.0)
			call thistype.m_cornEaters2.addNewItemType(index, 'I063', 1.0)

			set thistype.m_cornEaters3 = SpawnPoint.create()
			set index = thistype.m_cornEaters3.addUnitWithType(gg_unit_n016_0616, 1.0)
			call thistype.m_cornEaters3.addNewItemType(index, 'I063', 1.0)
			set index = thistype.m_cornEaters3.addUnitWithType(gg_unit_n016_0615, 1.0)
			call thistype.m_cornEaters3.addNewItemType(index, 'I063', 1.0)
			set index = thistype.m_cornEaters3.addUnitWithType(gg_unit_n016_0617, 1.0)
			call thistype.m_cornEaters3.addNewItemType(index, 'I063', 1.0)
			set index = thistype.m_cornEaters3.addUnitWithType(gg_unit_n06Q_0629, 1.0)
			call thistype.m_cornEaters3.addNewItemType(index, 'I063', 1.0)

			set thistype.m_cornEaters4 = SpawnPoint.create()
			set index = thistype.m_cornEaters4.addUnitWithType(gg_unit_n016_0663, 1.0)
			call thistype.m_cornEaters4.addNewItemType(index, 'I063', 1.0)
			set index = thistype.m_cornEaters4.addUnitWithType(gg_unit_n016_0662, 1.0)
			call thistype.m_cornEaters4.addNewItemType(index, 'I063', 1.0)
			set index = thistype.m_cornEaters4.addUnitWithType(gg_unit_n016_0661, 1.0)
			call thistype.m_cornEaters4.addNewItemType(index, 'I063', 1.0)

			 // spawn point spider queen
			set thistype.m_spiderQueen = SpawnPoint.create()
			set index = thistype.m_spiderQueen.addUnitWithType(gg_unit_n05F_0389, 1.0)
			call thistype.m_spiderQueen.addNewItemType(index, 'I041', 1.0)
			call thistype.m_spiderQueen.addNewItemType(index, 'I05U', 1.0)
			call thistype.m_spiderQueen.addNewItemType(index, 'I05U', 1.0)
			call thistype.m_spiderQueen.addNewItemType(index, 'I05U', 1.0)
			set index = thistype.m_spiderQueen.addUnitWithType(gg_unit_n01D_0390, 1.0)
			call thistype.m_spiderQueen.addNewItemType(index, 'I041', 1.0)
			set index = thistype.m_spiderQueen.addUnitWithType(gg_unit_n01D_0391, 1.0)
			call thistype.m_spiderQueen.addNewItemType(index, 'I041', 1.0)
			set index = thistype.m_spiderQueen.addUnitWithType(gg_unit_n01D_0392, 1.0)
			call thistype.m_spiderQueen.addNewItemType(index, 'I041', 1.0)

			// undeads forest
			set thistype.m_undeadsForest = SpawnPoint.create()
			set index = thistype.m_undeadsForest.addUnitWithType(gg_unit_n00Z_0659, 1.0)
			set index = thistype.m_undeadsForest.addUnitWithType(gg_unit_n00Z_0660, 1.0)
			set index = thistype.m_undeadsForest.addUnitWithType(gg_unit_n01O_0658, 1.0)
			set index = thistype.m_undeadsForest.addUnitWithType(gg_unit_n01O_0656, 1.0)
			set index = thistype.m_undeadsForest.addUnitWithType(gg_unit_n01O_0657, 1.0)

			// drum cave
			set thistype.m_skeletons0 = SpawnPoint.create()
			set index = thistype.m_skeletons0.addUnitWithType(gg_unit_n00X_0257, 1.0)
			call thistype.m_skeletons0.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_skeletons0.addUnitWithType(gg_unit_n00X_0256, 1.0)
			call thistype.m_skeletons0.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_skeletons0.addUnitWithType(gg_unit_n00X_0255, 1.0)
			call thistype.m_skeletons0.addNewItemType(index, 'I05I', 1.0)

			set thistype.m_skeletons1 = SpawnPoint.create()
			set index = thistype.m_skeletons1.addUnitWithType(gg_unit_n00Y_0261, 1.0)
			call thistype.m_skeletons1.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_skeletons1.addUnitWithType(gg_unit_n01O_0258, 1.0)
			call thistype.m_skeletons1.addNewItemType(index, 'I05I', 1.0)
			set index = thistype.m_skeletons1.addUnitWithType(gg_unit_n01O_0260, 1.0)
			call thistype.m_skeletons1.addNewItemType(index, 'I05I', 1.0)

			// bear men 0
			set thistype.m_bearMen0 = SpawnPoint.create()
			set index = thistype.m_bearMen0.addUnitWithType(gg_unit_n04G_0369, 1.0)
			call thistype.m_bearMen0.addNewItemType(index, 'I058', 1.0)
			set index = thistype.m_bearMen0.addUnitWithType(gg_unit_n04G_0368, 1.0)
			call thistype.m_bearMen0.addNewItemType(index, 'I058', 1.0)
			set index = thistype.m_bearMen0.addUnitWithType(gg_unit_n04G_0370, 1.0)
			call thistype.m_bearMen0.addNewItemType(index, 'I058', 1.0)

			// river

			set thistype.m_necks0 = SpawnPoint.create()
			set index = thistype.m_necks0.addUnitWithType(gg_unit_n05Z_0453, 1.0)
			set itemIndex = thistype.m_necks0.addNewItemType(index, 'I05W', 0.20)
			call thistype.m_necks0.addItemType(index, itemIndex, 'I00A', 0.80)
			set index = thistype.m_necks0.addUnitWithType(gg_unit_n05Z_0466, 1.0)
			set itemIndex = thistype.m_necks0.addNewItemType(index, 'I05W', 0.20)
			call thistype.m_necks0.addItemType(index, itemIndex, 'I00A', 0.80)
			set index = thistype.m_necks0.addUnitWithType(gg_unit_n05Z_0452, 1.0)
			set itemIndex = thistype.m_necks0.addNewItemType(index, 'I05W', 0.20)
			call thistype.m_necks0.addItemType(index, itemIndex, 'I00A', 0.80)

			set thistype.m_necks1 = SpawnPoint.create()
			set index = thistype.m_necks1.addUnitWithType(gg_unit_n05Z_0451, 1.0)
			set itemIndex = thistype.m_necks1.addNewItemType(index, 'I05W', 0.20)
			call thistype.m_necks1.addItemType(index, itemIndex, 'I00A', 0.80)
			set index = thistype.m_necks1.addUnitWithType(gg_unit_n05Z_0447, 1.0)
			set itemIndex = thistype.m_necks1.addNewItemType(index, 'I05W', 0.20)
			call thistype.m_necks1.addItemType(index, itemIndex, 'I00A', 0.80)
			set index = thistype.m_necks1.addUnitWithType(gg_unit_n05Z_0451, 1.0)
			set itemIndex = thistype.m_necks1.addNewItemType(index, 'I05W', 0.20)
			call thistype.m_necks1.addItemType(index, itemIndex, 'I00A', 0.80)

			set thistype.m_necks2 = SpawnPoint.create()
			set index = thistype.m_necks2.addUnitWithType(gg_unit_n05Z_0468, 1.0)
			set itemIndex = thistype.m_necks2.addNewItemType(index, 'I05W', 0.20)
			call thistype.m_necks2.addItemType(index, itemIndex, 'I00A', 0.80)
			set index = thistype.m_necks2.addUnitWithType(gg_unit_n05Z_0467, 1.0)
			set itemIndex = thistype.m_necks2.addNewItemType(index, 'I05W', 0.20)
			call thistype.m_necks2.addItemType(index, itemIndex, 'I00A', 0.80)

			set thistype.m_necks3 = SpawnPoint.create()
			set index = thistype.m_necks3.addUnitWithType(gg_unit_n05Z_0469, 1.0)
			set itemIndex = thistype.m_necks3.addNewItemType(index, 'I05W', 0.20)
			call thistype.m_necks3.addItemType(index, itemIndex, 'I00A', 0.80)
			set index = thistype.m_necks3.addUnitWithType(gg_unit_n05Z_0470, 1.0)
			set itemIndex = thistype.m_necks3.addNewItemType(index, 'I05W', 0.20)
			call thistype.m_necks3.addItemType(index, itemIndex, 'I00A', 0.80)
			set index = thistype.m_necks3.addUnitWithType(gg_unit_n05Z_0471, 1.0)
			set itemIndex = thistype.m_necks3.addNewItemType(index, 'I05W', 0.20)
			call thistype.m_necks3.addItemType(index, itemIndex, 'I00A', 0.80)

			// near ditch spiders
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03Y_0480, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03Y_0479, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0475, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0476, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0477, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01L_0483, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0482, 1.0)
		endmethod

		private static method initFarm takes nothing returns nothing
			local integer index
			set thistype.m_ditchSpidersFarm0 = SpawnPoint.create()
			set index = thistype.m_ditchSpidersFarm0.addUnitWithType(gg_unit_n01D_0489, 1.0)
			call thistype.m_ditchSpidersFarm0.addNewItemType(index, 'I041', 1.0)
			set index = thistype.m_ditchSpidersFarm0.addUnitWithType(gg_unit_n01D_0488, 1.0)
			call thistype.m_ditchSpidersFarm0.addNewItemType(index, 'I041', 1.0)

			set thistype.m_wolvesFarm0 = SpawnPoint.create()
			set index = thistype.m_wolvesFarm0.addUnitWithType(gg_unit_n02F_0490, 1.0)
			call thistype.m_wolvesFarm0.addNewItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolvesFarm0.addUnitWithType(gg_unit_n02F_0497, 1.0)
			call thistype.m_wolvesFarm0.addNewItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolvesFarm0.addUnitWithType(gg_unit_n02F_0496, 1.0)
			call thistype.m_wolvesFarm0.addNewItemType(index, 'I01H', 1.0)

			set thistype.m_boarsFarm0 = SpawnPoint.create()
			set index = thistype.m_boarsFarm0.addUnitWithType(gg_unit_n002_0528, 1.0)
			call thistype.m_boarsFarm0.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsFarm0.addUnitWithType(gg_unit_n002_0498, 1.0)
			call thistype.m_boarsFarm0.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsFarm0.addUnitWithType(gg_unit_n002_0529, 1.0)
			call thistype.m_boarsFarm0.addNewItemType(index, 'I007', 1.0)

			set thistype.m_deersFarm0 = SpawnPoint.create()
			set index = thistype.m_deersFarm0.addUnitWithType(gg_unit_n00V_0530, 1.0)
			call thistype.m_deersFarm0.addNewItemType(index, 'I00P', 1.0)
			set index = thistype.m_deersFarm0.addUnitWithType(gg_unit_n00V_0531, 1.0)
			call thistype.m_deersFarm0.addNewItemType(index, 'I00P', 1.0)
			set index = thistype.m_deersFarm0.addUnitWithType(gg_unit_n00V_0532, 1.0)
			call thistype.m_deersFarm0.addNewItemType(index, 'I00P', 1.0)

			set thistype.m_necksFarm0 = SpawnPoint.create()
			set index = thistype.m_necksFarm0.addUnitWithType(gg_unit_n05Z_0533, 1.0)
			call thistype.m_necksFarm0.addNewItemType(index, 'I05W', 0.20)
			set index = thistype.m_necksFarm0.addUnitWithType(gg_unit_n05Z_0534, 1.0)
			call thistype.m_necksFarm0.addNewItemType(index, 'I05W', 0.20)

			// TODO add item drops for creeps
		endmethod

		private static method initLeftGate takes nothing returns nothing
			local integer index
			set thistype.m_boarsLeftGate0 = SpawnPoint.create()
			set index = thistype.m_boarsLeftGate0.addUnitWithType(gg_unit_n002_0536, 1.0)
			call thistype.m_boarsLeftGate0.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsLeftGate0.addUnitWithType(gg_unit_n002_0537, 1.0)
			call thistype.m_boarsLeftGate0.addNewItemType(index, 'I007', 1.0)
			set index = thistype.m_boarsLeftGate0.addUnitWithType(gg_unit_n002_0535, 1.0)
			call thistype.m_boarsLeftGate0.addNewItemType(index, 'I007', 1.0)

			set thistype.m_bearLeftGate0 = SpawnPoint.create()
			set index = thistype.m_bearLeftGate0.addUnitWithType(gg_unit_n008_0539, 1.0)
			call thistype.m_bearLeftGate0.addNewItemType(index, 'I01J', 1.0)

			set thistype.m_wolvesLeftGate0 = SpawnPoint.create()
			set index = thistype.m_wolvesLeftGate0.addUnitWithType(gg_unit_n02F_0542, 1.0)
			call thistype.m_wolvesLeftGate0.addNewItemType(index, 'I01H', 1.0)
			call thistype.m_wolvesLeftGate0.addNewItemType(index, 'rhe2', 0.30)
			set index = thistype.m_wolvesLeftGate0.addUnitWithType(gg_unit_n02F_0543, 1.0)
			call thistype.m_wolvesLeftGate0.addNewItemType(index, 'I01H', 1.0)
			call thistype.m_wolvesLeftGate0.addNewItemType(index, 'rhe2', 0.30)
			set index = thistype.m_wolvesLeftGate0.addUnitWithType(gg_unit_n02F_0541, 1.0)
			call thistype.m_wolvesLeftGate0.addNewItemType(index, 'I01H', 1.0)
			call thistype.m_wolvesLeftGate0.addNewItemType(index, 'rman', 0.30)

			// TODO add item drops for creeps

			// Items
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0562, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0563, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0564, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0545, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0544, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0546, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0561, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0560, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03Y_0559, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03Y_0558, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0568, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0567, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0567, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0570, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0569, 1.0)
		endmethod

		private static method initDeranorsTomb takes nothing returns nothing
			local integer index
			// deranors guard
			// TODO dont use addNewItemType, they should exclude each other
			set thistype.m_dearnorsGuard = SpawnPoint.create()
			set index = thistype.m_dearnorsGuard.addUnitWithType(gg_unit_n06G_0576, 1.0)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'I06H', 0.30)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rhe2', 0.60)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rman', 0.60)
			set index = thistype.m_dearnorsGuard.addUnitWithType(gg_unit_n06G_0575, 1.0)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'I06H', 0.30)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rhe2', 0.60)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rman', 0.60)
			set index = thistype.m_dearnorsGuard.addUnitWithType(gg_unit_n06G_0579, 1.0)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'I06H', 0.30)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rhe2', 0.60)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rman', 0.60)
			set index = thistype.m_dearnorsGuard.addUnitWithType(gg_unit_n06G_0580, 1.0)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'I06H', 0.30)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rhe2', 0.60)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rman', 0.60)
			set index = thistype.m_dearnorsGuard.addUnitWithType(gg_unit_n06G_0581, 1.0)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'I06H', 0.30)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rhe2', 0.60)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rman', 0.60)
			set index = thistype.m_dearnorsGuard.addUnitWithType(gg_unit_n06G_0577, 1.0)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'I06H', 0.30)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rhe2', 0.60)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rman', 0.60)
			set index = thistype.m_dearnorsGuard.addUnitWithType(gg_unit_n06G_0578, 1.0)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'I06H', 0.30)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rhe2', 0.60)
			call thistype.m_dearnorsGuard.addNewItemType(index, 'rman', 0.60)
		endmethod

		private static method initMillHill takes nothing returns nothing
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0589, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0591, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0590, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0592, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0593, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0596, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0597, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0598, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01L_0602, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01L_0603, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01L_0604, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0607, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0605, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0606, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0608, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0610, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0609, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0601, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0600, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0599, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0595, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0594, 1.0)
		endmethod

		private static method initStartItems takes nothing returns nothing
			call ItemSpawnPoint.createFromItemWithType(gg_item_I06S_0618, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I06Q_0619, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I06R_0621, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I06R_0620, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0622, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0631, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I06Q_0630, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0632, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0638, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0639, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01L_0635, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01L_0637, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01L_0636, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03Y_0634, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03Y_0633, 1.0)
		endmethod

		private static method initKunosItems takes nothing returns nothing
			call ItemSpawnPoint.createFromItemWithType(gg_item_I02P_0651, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I02P_0652, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I02P_0653, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I02P_0654, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I02P_0647, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I02P_0648, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I02P_0650, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I02P_0649, 1.0)
		endmethod

		private static method initFarmSouthItems takes nothing returns nothing
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0668, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05L_0667, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I06S_0675, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0665, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I05K_0666, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I06S_0674, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I06S_0670, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I06S_0669, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I06S_0673, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I06S_0672, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0679, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0681, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I01K_0680, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I016_0683, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I016_0684, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0676, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0677, 1.0)
			call ItemSpawnPoint.createFromItemWithType(gg_item_I03O_0678, 1.0)
		endmethod

		public static method init takes nothing returns nothing
			/**
			 * Start with new OpLimit since it takes many many operations.
			 */
			call NewOpLimit(function thistype.init0)
			call NewOpLimit(function thistype.init1)
			call NewOpLimit(function thistype.init2)
			call NewOpLimit(function thistype.init3)
			call NewOpLimit(function thistype.initFarm)
			call NewOpLimit(function thistype.initLeftGate)
			call NewOpLimit(function thistype.initDeranorsTomb)
			call NewOpLimit(function thistype.initMillHill)
			call NewOpLimit(function thistype.initStartItems)
			call NewOpLimit(function thistype.initKunosItems)
			call NewOpLimit(function thistype.initFarmSouthItems)
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

		public static method cornEaters2 takes nothing returns SpawnPoint
			return thistype.m_cornEaters2
		endmethod

		public static method cornEaters3 takes nothing returns SpawnPoint
			return thistype.m_cornEaters3
		endmethod

		public static method cornEaters4 takes nothing returns SpawnPoint
			return thistype.m_cornEaters4
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

		public static method witch3 takes nothing returns SpawnPoint
			return thistype.m_witch3
		endmethod

		public static method witches takes nothing returns SpawnPoint
			return thistype.m_witches
		endmethod

		public static method spiderQueen takes nothing returns SpawnPoint
			return thistype.m_spiderQueen
		endmethod
	endstruct

endlibrary