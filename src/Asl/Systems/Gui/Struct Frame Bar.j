library AStructSystemsGuiFrameBar requires ALibraryCoreDebugMisc, AStructSystemsGuiImage, AStructSystemsGuiMainWindow

	struct AFrameBar extends AImage
		public static constant integer styleTop = 0
		public static constant integer styleBottom = 1
		public static constant integer styleLeft = 2
		public static constant integer styleRight = 3
		private integer m_style

		//! runtextmacro A_STRUCT_DEBUG("\"AFrameBar\"")

		public method style takes nothing returns integer
			return this.m_style
		endmethod

		public method isHorizontal takes nothing returns boolean
			return this.m_style == thistype.styleTop or this.m_style == thistype.styleBottom
		endmethod

		public method isVertical takes nothing returns boolean
			return this.m_style == thistype.styleLeft or this.m_style == thistype.styleRight
		endmethod

		public method width takes nothing returns real
			if (this.isHorizontal()) then
				return this.sizeY()
			endif
			return this.sizeX()
		endmethod

		public method length takes nothing returns real
			if (this.isHorizontal()) then
				return this.sizeX()
			endif
			return this.sizeY()
		endmethod

		public static method create takes AMainWindow mainWindow, integer style, real x, real y, real width, real length returns thistype
			local real sizeX
			local real sizeY
			local thistype this

static if (DEBUG_MODE) then
			if (style < thistype.styleTop or style > thistype.styleRight) then
				call thistype.staticPrint("Invalid style: " + I2S(style) + ".")
				return 0
			endif
endif

			if (style == thistype.styleTop or style == thistype.styleBottom) then
				set sizeX = length
				set sizeY = width
			else
				set sizeX= width
				set sizeY = length
			endif

			set this = thistype.allocate(mainWindow, x, y, sizeX, sizeY, null, 0, 0)
			set this.m_style = style

			if (this.m_style == thistype.styleTop) then
				call this.setFile(mainWindow.style().frameTopImageFilePath())
			elseif (this.m_style == thistype.styleBottom) then
				call this.setFile(mainWindow.style().frameBottomImageFilePath())
			elseif (this.m_style == thistype.styleLeft) then
				call this.setFile(mainWindow.style().frameLeftImageFilePath())
			elseif (this.m_style == thistype.styleRight) then
				call this.setFile(mainWindow.style().frameRightImageFilePath())
			endif

			return this
		endmethod
	endstruct

endlibrary