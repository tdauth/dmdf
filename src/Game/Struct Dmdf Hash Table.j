library StructGameDmdfHashTable requires Asl

	globals
		constant integer DMDF_HASHTABLE_KEY_TALK = A_HASHTABLE_KEY_MAX
		constant integer DMDF_HASHTABLE_KEY_FELLOW = A_HASHTABLE_KEY_MAX + 1
		constant integer DMDF_HASHTABLE_KEY_BUFFTAUNT = A_HASHTABLE_KEY_MAX + 2
		constant integer DMDF_HASHTABLE_KEY_BUFFEMBLAZE = A_HASHTABLE_KEY_MAX + 3
		constant integer DMDF_HASHTABLE_KEY_DAMAGERECORDER = A_HASHTABLE_KEY_MAX + 4
		constant integer DMDF_HASHTABLE_KEY_ANEYEFORANEYE_DAMAGE = A_HASHTABLE_KEY_MAX + 5
		constant integer DMDF_HASHTABLE_KEY_JUMPATTACK = A_HASHTABLE_KEY_MAX + 6
		constant integer DMDF_HASHTABLE_KEY_HIDDEN = A_HASHTABLE_KEY_MAX + 7
		constant integer DMDF_HASHTABLE_KEY_CONTROLLEDTIMEFLOW_MOVESPEED = A_HASHTABLE_KEY_MAX + 8
		constant integer DMDF_HASHTABLE_KEY_CONTROLLEDTIMEFLOW_EFFECT = A_HASHTABLE_KEY_MAX + 9
		constant integer DMDF_HASHTABLE_KEY_FURIOUSBLOODTHIRSTINESS_ENABLED = A_HASHTABLE_KEY_MAX + 10
		constant integer DMDF_HASHTABLE_KEY_FURIOUSBLOODTHIRSTINESS_DAMAGE = A_HASHTABLE_KEY_MAX + 11
		constant integer DMDF_HASHTABLE_KEY_MERCILESSNESS_DAMAGE = A_HASHTABLE_KEY_MAX + 12
		constant integer DMDF_HASHTABLE_KEY_RAGE_ENABLED = A_HASHTABLE_KEY_MAX + 13
		constant integer DMDF_HASHTABLE_KEY_RAGE_DAMAGE = A_HASHTABLE_KEY_MAX + 14
		constant integer DMDF_HASHTABLE_KEY_RESERVES_DAMAGE = A_HASHTABLE_KEY_MAX + 15
		constant integer DMDF_HASHTABLE_KEY_THRILLOFVICTORY_DAMAGE = A_HASHTABLE_KEY_MAX + 16
	endglobals

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