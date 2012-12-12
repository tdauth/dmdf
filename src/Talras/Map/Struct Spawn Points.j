library StructMapMapSpawnPoints requires Asl, StructGameItemTypes

	struct SpawnPoints
		private static ASpawnPoint m_wolves0
		private static ASpawnPoint m_wolves1
		private static ASpawnPoint m_boars0
		private static ASpawnPoint m_boars1
		private static ASpawnPoint m_bears0
		private static ASpawnPoint m_boars2
		private static ASpawnPoint m_boars3
		private static ASpawnPoint m_highwaymen0
		private static ASpawnPoint m_highwaymen1
		private static ASpawnPoint m_highwaymen2
		private static ASpawnPoint m_deers0
		private static ASpawnPoint m_ditchSpiders0
		private static ASpawnPoint m_ditchSpiders1
		private static ASpawnPoint m_box0
		private static ASpawnPoint m_box1
		private static ASpawnPoint m_box2
		private static ASpawnPoint m_giants0
		private static AItemSpawnPoint m_mushroom0
		private static ASpawnPoint m_vampireLord0
		private static ASpawnPoint m_vampires0
		private static ASpawnPoint m_box3
		private static ASpawnPoint m_undeadsWithKing
		private static ASpawnPoint m_medusa
		private static ASpawnPoint m_deathVault
		private static ASpawnPoint m_deathAngel
		private static ASpawnPoint m_boneDragons
		private static ASpawnPoint m_giant
		private static ASpawnPoint m_witch0
		private static ASpawnPoint m_witch1
		private static ASpawnPoint m_witch2
		private static ASpawnPoint m_witches
		private static ASpawnPoint m_wildCreatures

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// \todo change unit type
		public static method init takes nothing returns nothing
			local integer index
			set thistype.m_wolves0 = ASpawnPoint.create()
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02G_0140, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01I', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0139, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0114, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0136, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0112, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0109, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves0.addUnitWithType(gg_unit_n02F_0123, 1.0)
			call thistype.m_wolves0.addItemType(index, 'I01H', 1.0)

			set thistype.m_wolves1 = ASpawnPoint.create()
			set index = thistype.m_wolves1.addUnitWithType(gg_unit_n02F_0296, 1.0)
			call thistype.m_wolves1.addItemType(index, 'I01I', 1.0)
			set index = thistype.m_wolves1.addUnitWithType(gg_unit_n02F_0297, 1.0)
			call thistype.m_wolves1.addItemType(index, 'I01H', 1.0)
			set index = thistype.m_wolves1.addUnitWithType(gg_unit_n02F_0277, 1.0)
			call thistype.m_wolves1.addItemType(index, 'I01H', 1.0)

			set thistype.m_boars0 = ASpawnPoint.create()
			set index = thistype.m_boars0.addUnitWithType(gg_unit_n002_0078, 1.0)
			call thistype.m_boars0.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boars0.addUnitWithType(gg_unit_n002_0079, 1.0)
			call thistype.m_boars0.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boars0.addUnitWithType(gg_unit_n002_0080, 1.0)
			call thistype.m_boars0.addItemType(index, 'I007', 1.0)

			set thistype.m_boars1 = ASpawnPoint.create()
			set index = thistype.m_boars1.addUnitWithType(gg_unit_n002_0076, 1.0)
			call thistype.m_boars1.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boars1.addUnitWithType(gg_unit_n002_0077, 1.0)
			call thistype.m_boars1.addItemType(index, 'I007', 1.0)

			set thistype.m_bears0 = ASpawnPoint.create()
			set index = thistype.m_bears0.addUnitWithType(gg_unit_n008_0121, 1.0)
			call thistype.m_bears0.addItemType(index, 'I01J', 1.0)

			set thistype.m_boars2 = ASpawnPoint.create()
			set index = thistype.m_boars2.addUnitWithType(gg_unit_n002_0122, 1.0)
			call thistype.m_boars2.addItemType(index, 'I007', 1.0)
			set index = thistype.m_boars2.addUnitWithType(gg_unit_n002_0124, 1.0)
			call thistype.m_boars2.addItemType(index, 'I007', 1.0)

			set thistype.m_boars3 = ASpawnPoint.create()
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

			set thistype.m_highwaymen0 = ASpawnPoint.create()
			set index = thistype.m_highwaymen0.addUnitWithType(gg_unit_n00T_0125, 1.0)
			call thistype.m_highwaymen0.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'I00T', 0.50)
			set index = thistype.m_highwaymen0.addUnitWithType(gg_unit_n00U_0128, 1.0)
			call thistype.m_highwaymen0.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'I00T', 0.50)
			set index = thistype.m_highwaymen0.addUnitWithType(gg_unit_n00U_0127, 1.0)
			call thistype.m_highwaymen0.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen0.addItemType(index, 'I00T', 0.50)

			set thistype.m_highwaymen1 = ASpawnPoint.create()
			set index = thistype.m_highwaymen1.addUnitWithType(gg_unit_n00T_0126, 1.0)
			call thistype.m_highwaymen1.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen1.addItemType(index, 'I00T', 0.50)
			set index = thistype.m_highwaymen1.addUnitWithType(gg_unit_n00U_0129, 1.0)
			call thistype.m_highwaymen1.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen1.addItemType(index, 'I00T', 0.50)

			set thistype.m_highwaymen2 = ASpawnPoint.create()
			set index = thistype.m_highwaymen2.addUnitWithType(gg_unit_n00T_0130, 1.0)
			call thistype.m_highwaymen2.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen2.addItemType(index, 'I00T', 0.50)
			set index = thistype.m_highwaymen2.addUnitWithType(gg_unit_n00T_0131, 1.0)
			call thistype.m_highwaymen2.addItemType(index, 'I00S', 0.50)
			call thistype.m_highwaymen2.addItemType(index, 'I00T', 0.50)

			set thistype.m_deers0 = ASpawnPoint.create()
			set index = thistype.m_deers0.addUnitWithType(gg_unit_n00V_0132, 1.0)
			call thistype.m_deers0.addItemType(index, 'I00P', 1.0)
			set index = thistype.m_deers0.addUnitWithType(gg_unit_n00V_0133, 1.0)
			call thistype.m_deers0.addItemType(index, 'I00P', 1.0)
			set index = thistype.m_deers0.addUnitWithType(gg_unit_n00V_0134, 1.0)
			call thistype.m_deers0.addItemType(index, 'I00P', 1.0)

			set thistype.m_ditchSpiders0 = ASpawnPoint.create()
			set index = thistype.m_ditchSpiders0.addUnitWithType(gg_unit_n01E_0075, 1.0)

			set thistype.m_ditchSpiders1 = ASpawnPoint.create()
			set index = thistype.m_ditchSpiders1.addUnitWithType(gg_unit_n01E_0070, 1.0)
			set index = thistype.m_ditchSpiders1.addUnitWithType(gg_unit_n01E_0074, 1.0)

			set thistype.m_box0 = ASpawnPoint.create()
			set index = thistype.m_box0.addUnitWithType(gg_unit_n02C_0059, 1.0)
			call thistype.m_box0.addItemType(index, 'I00A', 1.0)

			set thistype.m_box1 = ASpawnPoint.create()
			set index = thistype.m_box1.addUnitWithType(gg_unit_n02C_0060, 1.0)
			call thistype.m_box1.addItemType(index, 'I01G', 1.0)

			set thistype.m_box2 = ASpawnPoint.create()
			set index = thistype.m_box2.addUnitWithType(gg_unit_n02C_0061, 1.0)
			call thistype.m_box2.addItemType(index, 'I00D', 1.0)

			set thistype.m_giants0 = ASpawnPoint.create()
			set index = thistype.m_giants0.addUnitWithType(gg_unit_n02R_0035, 1.0)
			call thistype.m_giants0.addItemType(index, 'I01Z', 1.0)
			set index = thistype.m_giants0.addUnitWithType(gg_unit_n02R_0036, 1.0)
			call thistype.m_giants0.addItemType(index, 'I01Z', 1.0)
			set index = thistype.m_giants0.addUnitWithType(gg_unit_n02R_0037, 1.0)
			call thistype.m_giants0.addItemType(index, 'I01Z', 1.0)

			set thistype.m_mushroom0 = AItemSpawnPoint.create(gg_item_I01K_0238, 1.0)

			set thistype.m_vampireLord0 = ASpawnPoint.create()
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n010_0110, 1.0)
			call thistype.m_vampireLord0.addItemType(index, 'I013', 1.0)
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n00Z_0106, 1.0)
			call thistype.m_vampireLord0.addItemType(index, 'I00C', 1.0)
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n00Z_0107, 1.0)
			call thistype.m_vampireLord0.addItemType(index, 'I00C', 1.0)
			set index = thistype.m_vampireLord0.addUnitWithType(gg_unit_n00Z_0108, 1.0)
			call thistype.m_vampireLord0.addItemType(index, 'I00G', 1.0)

			set thistype.m_vampires0 = ASpawnPoint.create()
			// vampires
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02L_0161, 1.0)
			call thistype.m_vampires0.addItemType(index, 'I02I', 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02L_0194, 1.0)
			call thistype.m_vampires0.addItemType(index, 'I02I', 1.0)
			set index = thistype.m_vampires0.addUnitWithType(gg_unit_n02L_0193, 1.0)
			call thistype.m_vampires0.addItemType(index, 'I02I', 1.0)
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

			set thistype.m_box3 = ASpawnPoint.create()
			set index = thistype.m_box3.addUnitWithType(gg_unit_n02C_0236, 1.0)
			call thistype.m_box3.addItemType(index, 'I01M', 1.0)
			call thistype.m_box3.addItemType(index, 'I00A', 1.0)
			set index = thistype.m_box3.addUnitWithType(gg_unit_n02C_0237, 1.0)
			call thistype.m_box3.addItemType(index, 'I013', 1.0)
			call thistype.m_box3.addItemType(index, 'I00D', 1.0)

			set thistype.m_undeadsWithKing = ASpawnPoint.create()
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

			set thistype.m_medusa = ASpawnPoint.create()
			// boxes
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n02C_0281, 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n02C_0280, 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n02C_0282, 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n032_0268, 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n031_0279, 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n032_0278, 1.0)
			// units
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n033_0239, 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n034_0265, 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n034_0290, 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n034_0289, 1.0)
			set index = thistype.m_medusa.addUnitWithType(gg_unit_n034_0291, 1.0)

			set thistype.m_deathVault = ASpawnPoint.create()
			set index = thistype.m_deathVault.addUnitWithType(gg_unit_n035_0299, 1.0)
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

			set thistype.m_deathAngel = ASpawnPoint.create()
			set index = thistype.m_deathAngel.addUnitWithType(gg_unit_n02K_0160, 1.0)
			set index = thistype.m_deathAngel.addUnitWithType(gg_unit_n00Y_0185, 1.0)
			set index = thistype.m_deathAngel.addUnitWithType(gg_unit_n00Y_0184, 1.0)
			set index = thistype.m_deathAngel.addUnitWithType(gg_unit_n00Y_0183, 1.0)

			set thistype.m_boneDragons = ASpawnPoint.create()
			set index = thistype.m_boneDragons.addUnitWithType(gg_unit_n024_0033, 1.0)
			set index = thistype.m_boneDragons.addUnitWithType(gg_unit_n024_0032, 1.0)
			set index = thistype.m_boneDragons.addUnitWithType(gg_unit_n024_0031, 1.0)

			set thistype.m_giant = ASpawnPoint.create()
			set index = thistype.m_giant.addUnitWithType(gg_unit_n02R_0253, 1.0)

			set thistype.m_witch0 = ASpawnPoint.create()
			set index = thistype.m_witch0.addUnitWithType(gg_unit_h00F_0242, 1.0)

			set thistype.m_witch1 = ASpawnPoint.create()
			set index = thistype.m_witch1.addUnitWithType(gg_unit_h00F_0241, 1.0)

			set thistype.m_witch2 = ASpawnPoint.create()
			set index = thistype.m_witch2.addUnitWithType(gg_unit_h00F_0244, 1.0)

			set thistype.m_witches = ASpawnPoint.create()
			set index = thistype.m_witches.addUnitWithType(gg_unit_h00F_0246, 1.0)
			set index = thistype.m_witches.addUnitWithType(gg_unit_h00F_0247, 1.0)
			set index = thistype.m_witches.addUnitWithType(gg_unit_h00F_0245, 1.0)

			set thistype.m_wildCreatures = ASpawnPoint.create()
			set index = thistype.m_wildCreatures.addUnitWithType(gg_unit_n02Q_0402, 1.0)
			set index = thistype.m_wildCreatures.addUnitWithType(gg_unit_n02Q_0404, 1.0)
			set index = thistype.m_wildCreatures.addUnitWithType(gg_unit_n02Q_0403, 1.0)
		endmethod

		public static method spawn takes nothing returns nothing
			//call thistype.m_spawnPointBoars0.spawn()
			//call thistype.m_spawnPointBoars1.spawn()
			//call thistype.m_spawnPointBoars2.spawn()
			//call thistype.m_spawnPointBoars3.spawn()
			//call thistype.m_spawnPointBoars4.spawn()
			//call thistype.m_spawnPointBoars5.spawn()
		endmethod

		public static method vampireLord0 takes nothing returns ASpawnPoint
			return thistype.m_vampireLord0
		endmethod

		public static method vampires0 takes nothing returns ASpawnPoint
			return thistype.m_vampires0
		endmethod

		public static method medusa takes nothing returns ASpawnPoint
			return thistype.m_medusa
		endmethod

		public static method deathVault takes nothing returns ASpawnPoint
			return thistype.m_deathVault
		endmethod

		public static method deathAngel takes nothing returns ASpawnPoint
			return thistype.m_deathAngel
		endmethod

		public static method boneDragons takes nothing returns ASpawnPoint
			return thistype.m_boneDragons
		endmethod
	endstruct

endlibrary