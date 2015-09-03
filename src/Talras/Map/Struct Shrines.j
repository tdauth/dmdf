library StructMapMapShrines requires Asl, StructGameShrine

	/**
	 * \brief Static struct which stores and initializes all revival shrines on the map.
	 */
	struct Shrines
		private static Shrine m_startShrine
		private static Shrine m_aosShrineNeutral
		private static Shrine m_aosShrineHaldar
		private static Shrine m_aosShrineBaldar
		private static Shrine m_aosShrineOutside
		private static Shrine m_talrasShrine
		private static Shrine m_talrasCastleShrine
		private static Shrine m_talrasExitShrine
		private static Shrine m_farmShrine
		private static Shrine m_hillShrine
		private static Shrine m_kunoShrine
		private static Shrine m_trommonShrine
		private static Shrine m_deathAngelShrine
		private static Shrine m_tanka
		private static Shrine m_farm
		private static Shrine m_norsemen
		private static Shrine m_tomb
		private static Shrine m_orcCamp

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_startShrine = Shrine.create(gg_unit_n02D_0062, gg_dest_B008_0069, gg_rct_shrine_0_discover, gg_rct_shrine_0_revival, 230.0)

			set thistype.m_aosShrineNeutral = Shrine.create(gg_unit_n02D_0084, gg_dest_B008_8168, gg_rct_shrine_5_discover, gg_rct_shrine_5_revival, 90.0)

			set thistype.m_aosShrineHaldar = Shrine.create(gg_unit_n02D_0091, gg_dest_B008_2815, gg_rct_shrine_haldar_discover, gg_rct_shrine_haldar_revival, 230.61)
			set thistype.m_aosShrineBaldar = Shrine.create(gg_unit_n02D_0085, gg_dest_B008_0354, gg_rct_shrine_baldar_discover, gg_rct_shrine_baldar_revival, 270.0)

			set thistype.m_aosShrineOutside = Shrine.create(gg_unit_n02D_0082, gg_dest_B008_0363, gg_rct_shrine_2_discover, gg_rct_shrine_2_revival, 0.0)

			set thistype.m_talrasShrine = Shrine.create(gg_unit_n02D_0081, gg_dest_B008_0080, gg_rct_shrine_3_discover, gg_rct_shrine_3_revival, 321.0)

			set thistype.m_talrasCastleShrine = Shrine.create(gg_unit_n02D_0034, gg_dest_B008_3006, gg_rct_shrine_9_discover, gg_rct_shrine_9_revival, 144.52)

			set thistype.m_talrasExitShrine = Shrine.create(gg_unit_n02D_0097, gg_dest_B008_2836, gg_rct_shrine_6_discover, gg_rct_shrine_6_revival, 72.27)

			set thistype.m_farmShrine = Shrine.create(gg_unit_n02D_0100, gg_dest_B008_2837, gg_rct_shrine_7_discover, gg_rct_shrine_7_revival, 312.69)

			set thistype.m_hillShrine = Shrine.create(gg_unit_n02D_0096, gg_dest_B008_7781, gg_rct_shrine_4_discover, gg_rct_shrine_4_revival, 222.22)
			
			set thistype.m_kunoShrine = Shrine.create(gg_unit_n02D_0454, gg_dest_B008_15988, gg_rct_shrine_kuno_discover, gg_rct_shrine_kuno_revival, 103.70)
			
			set thistype.m_trommonShrine = Shrine.create(gg_unit_n02D_0455, gg_dest_B008_16118, gg_rct_shrine_trommon_discover, gg_rct_shrine_trommon_revival, 310.62)
			
			set thistype.m_trommonShrine = Shrine.create(gg_unit_n02D_0457, gg_dest_B008_21512, gg_rct_shrine_death_angel_discover, gg_rct_shrine_death_angel_revival, 310.62)
			
			set thistype.m_tanka = Shrine.create(gg_unit_n02D_0320, gg_dest_B008_15996, gg_rct_shrine_tanka_discover, gg_rct_shrine_tanka_revival, 235.81)
			
			set thistype.m_farm = Shrine.create(gg_unit_n02D_0215, gg_dest_B008_21755, gg_rct_shrine_farm_discover, gg_rct_shrine_farm_revival, 128.61)
			
			set thistype.m_norsemen = Shrine.create(gg_unit_n02D_0216, gg_dest_B008_21758, gg_rct_shrine_norsemen_discover, gg_rct_shrine_norsemen_revival, 235.58)
			
			set thistype.m_tomb = Shrine.create(gg_unit_n02D_0262, gg_dest_B008_30012, gg_rct_shrine_tomb_discover, gg_rct_shrine_tomb_revival, 188.82)
			
			/*
			 * Used after finishing the quest The Norsemen.
			 */
			set thistype.m_orcCamp = 0
		endmethod

		public static method startShrine takes nothing returns Shrine
			return thistype.m_startShrine
		endmethod

		public static method aosShrineNeutral takes nothing returns Shrine
			return thistype.m_aosShrineNeutral
		endmethod

		public static method aosShrineHaldar takes nothing returns Shrine
			return thistype.m_aosShrineHaldar
		endmethod

		public static method aosShrineBaldar takes nothing returns Shrine
			return thistype.m_aosShrineBaldar
		endmethod

		public static method aosShrineOutside takes nothing returns Shrine
			return thistype.m_aosShrineOutside
		endmethod

		public static method talrasShrine takes nothing returns Shrine
			return thistype.m_talrasShrine
		endmethod

		public static method hillShrine takes nothing returns Shrine
			return thistype.m_hillShrine
		endmethod
		
		public static method kunoShrine takes nothing returns Shrine
			return thistype.m_kunoShrine
		endmethod
		
		public static method trommonShrine takes nothing returns Shrine
			return thistype.m_trommonShrine
		endmethod
		
		public static method initOrcCamp takes nothing returns nothing
			set thistype.m_orcCamp = Shrine.create(gg_unit_n02D_0463, gg_dest_B008_32530, gg_rct_shrine_orc_camp_discover, gg_rct_shrine_orc_camp_revival, 319.94)
		endmethod
		
		public static method orcCamp takes nothing returns Shrine
			return thistype.m_orcCamp
		endmethod
	endstruct

endlibrary
