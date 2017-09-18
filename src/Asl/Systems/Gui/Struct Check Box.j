library AStructSystemsGuiCheckBox requires AStructSystemsGuiWidget, AStructSystemsGuiImage

	struct ACheckBox extends AImage
		// static construction members
		private static string m_checkedImageFilePath
		private static string m_uncheckedImageFilePath
		// dynamic members
		private boolean m_checked

		// dynamic members

		public method setChecked takes boolean checked returns nothing
			set this.m_checked = checked
			if (checked) then
				call this.setFile(thistype.m_checkedImageFilePath)
			else
				call this.setFile(thistype.m_uncheckedImageFilePath)
			endif
		endmethod

		public method isChecked takes nothing returns boolean
			return this.m_checked
		endmethod

		private static method onHitAction takes AWidget whichWidget returns nothing
			call thistype(whichWidget).setChecked(not thistype(whichWidget).isChecked())
		endmethod

		// methods

		public static method create takes AMainWindow mainWindow, real x, real y, real sizeX, real sizeY, string modelFilePath, AWidgetOnTrackAction onTrackAction, boolean checked returns thistype
			local thistype this = thistype.allocate(mainWindow, x, y, sizeX, sizeY, modelFilePath, thistype.onHitAction, onTrackAction)
			// dynamic members
			set this.m_checked = false

			call this.setFile(thistype.m_uncheckedImageFilePath)
			return this
		endmethod

		// static methods

		public static method init0 takes string checkedImageFilePath, string uncheckedImageFilePath returns nothing
			// static construction members
			set thistype.m_checkedImageFilePath = checkedImageFilePath
			set thistype.m_uncheckedImageFilePath = uncheckedImageFilePath
		endmethod
	endstruct

endlibrary