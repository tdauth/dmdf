library AStructSystemsGuiArrowButton requires ALibraryCoreDebugMisc, AStructSystemsGuiButton

	struct AArrowButton extends AButton
		public static constant integer styleTop = 0
		public static constant integer styleBottom = 1
		public static constant integer styleLeft = 2
		public static constant integer styleRight = 3
		private integer m_style

		//! runtextmacro A_STRUCT_DEBUG("\"AArrowButton\"")

		public method style takes nothing returns integer
			return this.m_style
		endmethod

		public static method create takes AMainWindow mainWindow, integer style, real x, real y, real width, real height, string modelFilePath, AWidgetOnHitAction onHitAction, AWidgetOnTrackAction onTrackAction returns thistype
			local thistype this

static if (DEBUG_MODE) then
			if (style < thistype.styleTop or style > thistype.styleRight) then
				call thistype.staticPrint("Invalid style: " + I2S(style) + ".")
				return 0
			endif
endif

			set this = thistype.allocate(mainWindow, x, y, width, height, modelFilePath, onHitAction, onTrackAction)
			set this.m_style = style

			if (this.m_style == thistype.styleTop) then
				call this.setFile(mainWindow.style().arrowTopImageFilePath())
			elseif (this.m_style == thistype.styleBottom) then
				call this.setFile(mainWindow.style().arrowBottomImageFilePath())
			elseif (this.m_style == thistype.styleLeft) then
				call this.setFile(mainWindow.style().arrowLeftImageFilePath())
			elseif (this.m_style == thistype.styleRight) then
				call this.setFile(mainWindow.style().arrowRightImageFilePath())
			endif

			return this
		endmethod
	endstruct

endlibrary