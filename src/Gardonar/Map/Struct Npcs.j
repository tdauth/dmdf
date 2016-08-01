library StructMapMapNpcs requires StructGameDmdfHashTable

	/**
	 * \brief Static struct which stores global instances of the NPCs for simplified access.
	 */
	struct Npcs
		private static unit m_wigberht
		private static unit m_ricman
		private static unit m_dragonSlayer
		private static unit m_gardonar
		private static unit m_deranor
		private static unit m_gammar
		private static unit m_barade
		
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
			set thistype.m_gardonar = gg_unit_n06U_0005
			set thistype.m_deranor = gg_unit_u00A_0006
			set thistype.m_gammar = gg_unit_n06W_0007
			set thistype.m_barade = gg_unit_n06V_0008
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
		
		public static method gardonar takes nothing returns unit
			return thistype.m_gardonar
		endmethod
		
		public static method deranor takes nothing returns unit
			return thistype.m_deranor
		endmethod
		
		public static method gammar takes nothing returns unit
			return thistype.m_gammar
		endmethod
		
		public static method barade takes nothing returns unit
			return thistype.m_barade
		endmethod
	endstruct

endlibrary