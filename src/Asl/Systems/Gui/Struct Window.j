library AStructSystemsGuiWindow requires AStructSystemsGuiFrame, AStructSystemsGuiImage, AStructSystemsGuiWidget

	struct AWindow extends AFrame
		private AImage m_backgroundImage

		public method setBackgroundImageFilePath takes string backgroundImageFilePath returns nothing
			if (this.m_backgroundImage == 0) then
				set this.m_backgroundImage = AImage.create(this.mainWindow(), this.x(), this.y(), this.sizeX(), this.sizeY(), null, 0, 0)
			endif
			call this.m_backgroundImage.setFile(backgroundImageFilePath)
		endmethod

		public method backgroundImageFilePath takes nothing returns string
			if (this.m_backgroundImage == 0) then
				return null
			endif
			return this.m_backgroundImage.file()
		endmethod

		public static method create takes AMainWindow mainWindow, real x, real y, real width, real height returns thistype
			local thistype this = thistype.allocate(mainWindow, x, y, width, height)
			set this.m_backgroundImage = 0
			return this
		endmethod

		public static method createByRectSize takes AMainWindow mainWindow, real x, real y, rect whichRect returns thistype
			return thistype.create(mainWindow, x, y, GetRectWidthBJ(whichRect), GetRectHeightBJ(whichRect))
		endmethod

		public static method createByRect takes AMainWindow mainWindow, rect whichRect returns thistype
			return thistype.createByRectSize(mainWindow, GetRectMinX(whichRect), GetRectMaxY(whichRect), whichRect)
		endmethod
	endstruct

endlibrary