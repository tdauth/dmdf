library StructMapMapShrines requires Asl, StructGameShrine

	/**
	 * \brief Static struct which stores and initializes all revival shrines on the map.
	 */
	struct Shrines
		private static Shrine m_startShrine

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_startShrine = Shrine.create(gg_unit_n02D_0011, gg_dest_B008_6511, gg_rct_shrine_start_discover, gg_rct_shrine_start_revival, 306.72)
		endmethod

		public static method startShrine takes nothing returns Shrine
			return thistype.m_startShrine
		endmethod
	endstruct

endlibrary
