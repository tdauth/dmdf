library StructMapMapNpcs requires StructGameDmdfHashTable

	/**
	 * \brief Static struct which stores global instances of the NPCs for simplified access.
	 */
	struct Npcs
		private static unit m_ralph
		private static unit m_mother
		private static unit m_gotlinde
		private static unit m_hans
		private static unit m_wotan

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// This method is and has to be called after unit creation.
		private static method onInit takes nothing returns nothing
			set thistype.m_ralph = gg_unit_H015_0029
			call SetUnitInvulnerable(thistype.m_ralph, true)
			set thistype.m_mother = gg_unit_H03H_0013
			call SetUnitInvulnerable(thistype.m_mother, true)
			set thistype.m_gotlinde = gg_unit_H03I_0012
			call SetUnitInvulnerable(thistype.m_gotlinde, true)
			set thistype.m_hans = gg_unit_H03G_0008
			call SetUnitInvulnerable(thistype.m_hans, true)
			set thistype.m_wotan = gg_unit_H03J_0062
			call SetUnitInvulnerable(thistype.m_wotan, true)
		endmethod

		public static method ralph takes nothing returns unit
			return thistype.m_ralph
		endmethod

		public static method mother takes nothing returns unit
			return thistype.m_mother
		endmethod

		public static method gotlinde takes nothing returns unit
			return thistype.m_gotlinde
		endmethod

		public static method hans takes nothing returns unit
			return thistype.m_hans
		endmethod

		public static method wotan takes nothing returns unit
			return thistype.m_wotan
		endmethod
	endstruct

endlibrary