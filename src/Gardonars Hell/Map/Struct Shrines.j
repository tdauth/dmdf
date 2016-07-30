library StructMapMapShrines requires Asl, StructGameShrine

	/**
	 * \brief Static struct which stores and initializes all revival shrines on the map.
	 */
	struct Shrines
		private static Shrine m_startShrine
		private static Shrine m_endShrine

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_startShrine = Shrine.create(gg_unit_n06J_0006, gg_dest_B008_4964, gg_rct_shrine_start_discover, gg_rct_shrine_start_revival, 300.0)
			set thistype.m_endShrine = Shrine.create(gg_unit_n06J_0014, gg_dest_B008_5031, gg_rct_shrine_end_discover, gg_rct_shrine_end_revival, 211.05)
		endmethod

		public static method startShrine takes nothing returns Shrine
			return thistype.m_startShrine
		endmethod
		
		public static method endShrine takes nothing returns Shrine
			return thistype.m_endShrine
		endmethod
	endstruct

endlibrary
