library AStructSystemsGuiStyle requires ALibraryCoreDebugMisc

	/**
	 * Defines custom GUI style for a single main window.
	 * Note that there're only pre-defined styles for some Warcraft III races at the moment.
	 * GUI files of races "Demon", "Naga" and "Panda" are delivered with "Die Macht des Feuers".
	 * \sa MainWindow
	 */
	struct AStyle
		private static thistype m_human
		private static thistype m_orc
		private static thistype m_undead
		private static thistype m_nightElf
		private static thistype m_demon
		private static thistype m_naga
		private static thistype m_nerubian
		private static thistype m_panda
		private string m_frameTopImageFilePath
		private string m_frameBottomImageFilePath
		private string m_frameLeftImageFilePath
		private string m_frameRightImageFilePath
		private string m_arrowTopImageFilePath
		private string m_arrowBottomImageFilePath
		private string m_arrowLeftImageFilePath
		private string m_arrowRightImageFilePath

		//! runtextmacro A_STRUCT_DEBUG("\"AStyle\"")
		
		public method setFrameTopImageFilePath takes string frameTopImageFilePath returns nothing
			set this.m_frameTopImageFilePath = frameTopImageFilePath
		endmethod

		public method frameTopImageFilePath takes nothing returns string
			return this.m_frameTopImageFilePath
		endmethod
		
		public method setFrameBottomImageFilePath takes string frameBottomImageFilePath returns nothing
			set this.m_frameBottomImageFilePath = frameBottomImageFilePath
		endmethod

		public method frameBottomImageFilePath takes nothing returns string
			return this.m_frameBottomImageFilePath
		endmethod
		
		public method setFrameLeftImageFilePath takes string frameLeftImageFilePath returns nothing
			set this.m_frameLeftImageFilePath = frameLeftImageFilePath
		endmethod

		public method frameLeftImageFilePath takes nothing returns string
			return this.m_frameLeftImageFilePath
		endmethod
		
		public method setFrameRightImageFilePath takes string frameRightImageFilePath returns nothing
			set this.m_frameRightImageFilePath = frameRightImageFilePath
		endmethod

		public method frameRightImageFilePath takes nothing returns string
			return this.m_frameRightImageFilePath
		endmethod

		public method arrowTopImageFilePath takes nothing returns string
			return this.m_arrowTopImageFilePath
		endmethod

		public method arrowBottomImageFilePath takes nothing returns string
			return this.m_arrowBottomImageFilePath
		endmethod

		public method arrowLeftImageFilePath takes nothing returns string
			return this.m_arrowLeftImageFilePath
		endmethod

		public method arrowRightImageFilePath takes nothing returns string
			return this.m_arrowRightImageFilePath
		endmethod

		public static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.m_human = 0
			set thistype.m_orc = 0
			set thistype.m_undead = 0
			set thistype.m_nightElf = 0
			set thistype.m_demon = 0
			set thistype.m_naga = 0
			set thistype.m_nerubian = 0
		endmethod

		private static method createHuman takes nothing returns thistype
			local thistype this = thistype.allocate()
			set this.m_frameTopImageFilePath = "UserInterfaces\\Human\\FrameTop.blp"
			set this.m_frameBottomImageFilePath = "UserInterfaces\\Human\\FrameBottom.blp"
			set this.m_frameLeftImageFilePath = "UserInterfaces\\Human\\FrameLeft.blp"
			set this.m_frameRightImageFilePath = "UserInterfaces\\Human\\FrameRight.blp"
			return this
		endmethod

		private static method createOrc takes nothing returns thistype
			local thistype this = thistype.allocate()
			return this
		endmethod

		private static method createUndead takes nothing returns thistype
			local thistype this = thistype.allocate()
			return this
		endmethod

		private static method createNightElf takes nothing returns thistype
			local thistype this = thistype.allocate()
			return this
		endmethod

		public static method human takes nothing returns thistype
			if (thistype.m_human == 0) then
				set thistype.m_human = thistype.createHuman()
			endif
			return thistype.m_human
		endmethod

		public static method orc takes nothing returns thistype
			if (thistype.m_orc == 0) then
				set thistype.m_orc = thistype.createOrc()
			endif
			return thistype.m_orc
		endmethod

		public static method undead takes nothing returns thistype
			if (thistype.m_undead == 0) then
				set thistype.m_undead = thistype.createUndead()
			endif
			return thistype.m_undead
		endmethod

		public static method nightElf takes nothing returns thistype
			if (thistype.m_nightElf == 0) then
				set thistype.m_nightElf = thistype.createNightElf()
			endif
			return thistype.m_nightElf
		endmethod
	endstruct

endlibrary