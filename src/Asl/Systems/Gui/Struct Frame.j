library AStructSystemsGuiFrame requires AStructSystemsGuiFrameBar, AStructSystemsGuiWidget

	struct AFrame extends AWidget
		private AFrameBar m_barTop
		private AFrameBar m_barBottom
		private AFrameBar m_barLeft
		private AFrameBar m_barRight

		public static method create takes AMainWindow mainWindow, real x, real y, real width, real height returns thistype
			local thistype this = thistype.allocate(mainWindow, x, y, width, height, null, 0, 0)
			set this.m_barTop = AFrameBar.create(mainWindow, AFrameBar.styleTop, x, y, 20.0, width)
			set this.m_barBottom = AFrameBar.create(mainWindow, AFrameBar.styleBottom, x, y + height - 20.0 , 20.0, width)
			set this.m_barLeft = AFrameBar.create(mainWindow, AFrameBar.styleLeft, x, y, 20.0, height)
			set this.m_barRight = AFrameBar.create(mainWindow, AFrameBar.styleRight, x + width - 20.0, y, 20.0, height)

			return this
		endmethod

	endstruct

endlibrary