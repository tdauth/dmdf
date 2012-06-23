library StructGameDmdfHashTable requires Asl

	struct DmdfHashTable
		private static AHashTable m_global

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.m_global = 0
		endmethod

		public static method global takes nothing returns AHashTable
			if (thistype.m_global == 0) then
				set thistype.m_global = AHashTable.create()
			endif
			return thistype.m_global
		endmethod
	endstruct

endlibrary