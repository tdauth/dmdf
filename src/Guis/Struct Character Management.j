library StructGuisCharacterManagement requires Asl, StructGameCharacter, StructGuisMainWindow

	/**
	 * \brief Shows information about the character and different sub windows.
	*/
	struct CharacterManagementMainWindow extends MainWindow
		private static constant integer entriesPerPage = 8
		// construction members
		private Character m_character
		// members
		private AImage m_background

		public stub method onShow takes nothing returns nothing
			call super.onShow()
		endmethod

		public stub method onHide takes nothing returns nothing
			call super.onHide()
		endmethod

		public static method create takes Character character, rect whichRect returns thistype
			local thistype this = thistype.allocate(character, AStyle.human(), whichRect)
			call this.setTooltipX(1100.0)
			call this.setTooltipY(300.0)
			// construction members
			set this.m_character = character
			// members
			set this.m_background = AImage.create(this, 0.0, 0.0, GetRectWidthBJ(whichRect), GetRectHeightBJ(whichRect), "", 0, 0)
			// TODO crash!
			call this.m_background.setFile("CharacterManagement.tga")

			return this
		endmethod
	endstruct

endlibrary