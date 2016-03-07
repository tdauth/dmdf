library StructMapMapNpcs requires StructGameDmdfHashTable

	/**
	 * \brief Static struct which stores global instances of the NPCs for simplified access.
	 */
	struct Npcs
		private static unit m_wigberht
		private static unit m_ricman
		private static unit m_dragonSlayer
		
		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// This method is and has to be called after unit creation.
		private static method onInit takes nothing returns nothing
			set thistype.m_dragonSlayer = gg_unit_H01F_0004
			set thistype.m_ricman = gg_unit_H01E_0009
			set thistype.m_wigberht = gg_unit_H01C_0003
		endmethod
		
		public static method dragonSlayer takes nothing returns unit
			return thistype.m_dragonSlayer
		endmethod
		
		public static method ricman takes nothing returns unit
			return thistype.m_ricman
		endmethod

		public static method wigberht takes nothing returns unit
			return thistype.m_wigberht
		endmethod
	endstruct

endlibrary