library StructMapMapShrines requires Asl, StructGameShrine

	/**
	 * \brief Static struct which stores and initializes all revival shrines on the map.
	 */
	struct Shrines
		private static Shrine m_startShrine
		private static Shrine m_endShrine
		private static Shrine m_townHallShrine

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_startShrine = Shrine.create(gg_unit_n02D_0010, gg_dest_B008_1343, gg_rct_shrine_start_discover, gg_rct_shrine_start_revival, 304.23)
			set thistype.m_endShrine = Shrine.create(gg_unit_n02D_0125, gg_dest_B008_2661, gg_rct_shrine_end_discover, gg_rct_shrine_end_revival, 218.30)
			set thistype.m_townHallShrine = Shrine.create(gg_unit_n02D_0126, gg_dest_B008_2781, gg_rct_shrine_town_hall_discover, gg_rct_shrine_town_hall_revival, 299.26)
		endmethod

		public static method startShrine takes nothing returns Shrine
			return thistype.m_startShrine
		endmethod
	endstruct

endlibrary
