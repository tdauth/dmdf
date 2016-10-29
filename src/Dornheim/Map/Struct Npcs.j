library StructMapMapNpcs requires StructGameDmdfHashTable

	/**
	 * \brief Static struct which stores global instances of the NPCs for simplified access.
	 */
	struct Npcs
		private static unit m_ralph

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// This method is and has to be called after unit creation.
		private static method onInit takes nothing returns nothing
			set thistype.m_ralph = gg_unit_H01D_0011
		endmethod

		public static method ralph takes nothing returns unit
			return thistype.m_ralph
		endmethod
	endstruct

endlibrary