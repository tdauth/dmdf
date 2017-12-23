library AStructSystemsGuiDialog requires optional ALibraryCoreDebugMisc, ALibraryCoreStringConversion, AStructCoreGeneralHashTable, AStructCoreGeneralVector, AStructCoreStringFormat, AStructSystemsGuiDialogButton

	/**
	 * \brief Provides a kind of wrapper struct for common Warcraft III dialogs.
	 * Actually it's not only a wrapper since it's expands the whole functionality of dialogs by using \ref ADialogButton instances.
	 * Besides it allows user to add more than \ref AMaxDialogButtons (Warcraft III limit) buttons by adding next and previous page buttons and splitting
	 * all 10-button groups into pages.
	 * \todo Should become forced-based (when player leaves other players could select).
	 */
	struct ADialog
		// static constant members
		public static constant integer maxPageButtons = 10
		public static constant integer maxMessageChars = 10
		// static construction members
		private static integer shortcutPreviousPage
		private static integer shortcutNextPage
		private static string textPreviousPage
		private static string textNextPage
		private static string m_textMessage
		// dynamic members
		private string m_message
		private boolean m_isDisplayed
		// construction members
		private player m_player
		// members
		private dialog m_dialog
		private AIntegerVector m_dialogButtons // use vector since you need the index
		private integer m_currentPage
		private integer m_maxPageNumber
		private button m_previousPageButton
		private trigger m_nextPageTrigger
		private button m_nextPageButton
		private trigger m_previousPageTrigger

		//! runtextmacro optional A_STRUCT_DEBUG("\"ADialog\"")

		public method modifiedMessage takes nothing returns string
			if (this.m_maxPageNumber == 0) then
				return this.m_message
			endif
			/// \todo Fix InsertLineBreaks
			return InsertLineBreaks(IntegerArg(IntegerArg(StringArg(thistype.m_textMessage, this.m_message), this.m_currentPage + 1), this.m_maxPageNumber + 1), thistype.maxMessageChars)
		endmethod

		// dynamic members

		/**
		* Changes the dialog's message.
		* Dialog messages are displayed in the top of the dialog window.
		* The shown message can be queried by ADialog.modifiedMessage.
		* \note Line breaks will be inserted automatically so there won't be any long messages which cross the window's border (ADialog.maxMessageChars).
		* \sa message()
		* \sa modifiedMessage()
		*/
		public method setMessage takes string message returns nothing
			set this.m_message = message
			if (this.m_isDisplayed) then
				call DialogSetMessage(this.m_dialog, this.modifiedMessage())
			endif
		endmethod

		/**
		 * \return Returns the unmodified message of the dialog.
		 * \sa modifiedMessage()
		 */
		public method message takes nothing returns string
			return this.m_message
		endmethod

		public method setDisplayed takes boolean displayed returns nothing
			local integer i = this.m_currentPage * thistype.maxPageButtons
			local integer exitValue = (this.m_currentPage + 1) * thistype.maxPageButtons
			set this.m_isDisplayed = displayed
			if (displayed) then
				call DialogSetMessage(this.m_dialog, this.modifiedMessage())
				loop
					exitwhen (i == exitValue or i == this.m_dialogButtons.size())
					call ADialogButton(this.m_dialogButtons[i]).addButton()
					set i = i + 1
				endloop
				if (this.m_maxPageNumber > 0) then
					call this.createPreviousPageButton.evaluate()
					call this.createNextPageButton.evaluate()
				endif
			else
				loop
					exitwhen (i == exitValue or i == this.m_dialogButtons.size())
					call ADialogButton(this.m_dialogButtons[i]).removeButton()
					set i = i + 1
				endloop
				if (this.m_maxPageNumber > 0) then
					call this.removePreviousPageButton.evaluate()
					call this.removeNextPageButton.evaluate()
				endif
				call DialogClear(this.m_dialog)
			endif
			call DialogDisplay(this.m_player, this.m_dialog, displayed)
		endmethod

		/// \return Returns if the dialog is displayed to player.
		public method isDisplayed takes nothing returns boolean
			return this.m_isDisplayed
		endmethod

		// construction members

		public method player takes nothing returns player
			return this.m_player
		endmethod

		// members

		public method dialog takes nothing returns dialog
			return this.m_dialog
		endmethod

		public method currentPage takes nothing returns integer
			return this.m_currentPage
		endmethod

		/// \return Returns the number of the last page (starting from 0).
		/// For example: If there are three pages this method will return 2.
		public method maxPageNumber takes nothing returns integer
			return this.m_maxPageNumber
		endmethod

		// methods

		public method show takes nothing returns nothing
			call this.setDisplayed(true)
		endmethod

		public method hide takes nothing returns nothing
			call this.setDisplayed(false)
		endmethod

		public method showOnPage takes integer pageNumber returns boolean
			local boolean result = pageNumber > this.m_maxPageNumber or pageNumber < 0
			if (result) then
				set pageNumber = 0
			endif
			set this.m_currentPage = pageNumber
			call this.show()
			return result
		endmethod

		private static method formatText takes string text, integer shortcut returns string
			return HighlightShortcut(text, shortcut, "ffffffff")
		endmethod

		public method addExtendedDialogButton takes string text, integer shortcut, boolean isQuitButton, boolean doScoreScreen, ADialogButtonAction action returns ADialogButton
			return ADialogButton.create(this, thistype.formatText(text, shortcut), shortcut, isQuitButton, doScoreScreen, action)
		endmethod

		/**
		 * Uses dialog button's index as shortcut and adds string "[<shortcut index>]" before button's text.
		 */
		public method addExtendedDialogButtonIndex takes string text, boolean isQuitButton, boolean doScoreScreen, ADialogButtonAction action returns ADialogButton
			local integer shortcut = ModuloInteger(this.m_dialogButtons.size(), thistype.maxPageButtons) // faster than ADialog.pageIndex() + 1
			return this.addExtendedDialogButton(Format(A_TEXT_DIALOG_BUTTON).i(shortcut).s(text).result(), '0' + shortcut, isQuitButton, doScoreScreen, action)
		endmethod

		public method addDialogButton takes string text, integer shortcut, ADialogButtonAction action returns ADialogButton
			return this.addExtendedDialogButton(text, shortcut, false, false, action)
		endmethod

		/**
		 * Uses dialog button's index as shortcut and adds string "[<shortcut index>]" before button's text.
		 */
		public method addDialogButtonIndex takes string text, ADialogButtonAction action returns ADialogButton
			return this.addExtendedDialogButtonIndex(text, false, false, action)
		endmethod

		public method addSimpleDialogButton takes string text, integer shortcut returns ADialogButton
			return this.addExtendedDialogButton(text, shortcut, false, false, 0)
		endmethod

		/**
		 * Uses dialog button's index as shortcut and adds string "[<shortcut index>]" before button's text.
		 */
		public method addSimpleDialogButtonIndex takes string text returns ADialogButton
			return this.addExtendedDialogButtonIndex(text, false, false, 0)
		endmethod

		/// \todo Friend relation to \ref ADialogButton, do not use!
		public method addDialogButtonInstance takes ADialogButton instance returns integer
			if (this.m_dialogButtons.size() - this.m_maxPageNumber * thistype.maxPageButtons == ADialog.maxPageButtons) then
				set this.m_maxPageNumber = this.m_maxPageNumber + 1
			endif
			call this.m_dialogButtons.pushBack(instance)
			return this.m_dialogButtons.backIndex()
		endmethod

		public method dialogButtons takes nothing returns integer
			return this.m_dialogButtons.size()
		endmethod

		/// Next and previous page buttons are in list!
		public method clear takes nothing returns nothing
			if (this.m_isDisplayed) then
				//before page number is changed
				if (this.m_maxPageNumber > 0) then
					call this.removePreviousPageButton.evaluate()
					call this.removeNextPageButton.evaluate()
				endif
				set this.m_isDisplayed = false
			endif
			loop
				exitwhen (this.m_dialogButtons.empty())
				call ADialogButton(this.m_dialogButtons.back()).destroy() // removes itself from the list!
				call this.m_dialogButtons.popBack()
			endloop
			set this.m_currentPage = 0
			set this.m_maxPageNumber = 0
			call DialogClear(this.m_dialog)
		endmethod

		/// Friend relation to \ref ADialogButton.
		public method setDisplayedByButton takes boolean displayed returns nothing
			set this.m_isDisplayed = displayed
		endmethod

		private method changeToPreviousPage takes nothing returns nothing
			call this.setDisplayed(false)
			if (this.m_currentPage == 0) then
				set this.m_currentPage = this.m_maxPageNumber
			else
				set this.m_currentPage = this.m_currentPage - 1
			endif
			call this.setDisplayed(true)
		endmethod

		private method changeToNextPage takes nothing returns nothing
			call this.setDisplayed(false)
			if (this.m_currentPage == this.m_maxPageNumber) then
				set this.m_currentPage = 0
			else
				set this.m_currentPage = this.m_currentPage + 1
			endif
			call this.setDisplayed(true)
		endmethod

		private static method triggerActionPreviousPage takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.changeToPreviousPage()
		endmethod

		private method createPreviousPageButton takes nothing returns nothing
			set this.m_previousPageButton = DialogAddButton(this.m_dialog, thistype.formatText(thistype.textPreviousPage, thistype.shortcutPreviousPage), thistype.shortcutPreviousPage)
			set this.m_previousPageTrigger = CreateTrigger()
			call TriggerRegisterDialogButtonEvent(this.m_previousPageTrigger, this.m_previousPageButton)
			call TriggerAddAction(this.m_previousPageTrigger, function thistype.triggerActionPreviousPage)
			call AHashTable.global().setHandleInteger(this.m_previousPageTrigger, 0, this)
		endmethod

		private static method triggerActionNextPage takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.changeToNextPage()
		endmethod

		private method removePreviousPageButton takes nothing returns nothing
			set this.m_previousPageButton = null
			call AHashTable.global().destroyTrigger(this.m_previousPageTrigger)
			set this.m_previousPageTrigger = null
		endmethod

		private method createNextPageButton takes nothing returns nothing
			set this.m_nextPageButton = DialogAddButton(this.m_dialog, thistype.formatText(thistype.textNextPage, thistype.shortcutNextPage), thistype.shortcutNextPage)
			set this.m_nextPageTrigger = CreateTrigger()
			call TriggerRegisterDialogButtonEvent(this.m_nextPageTrigger, this.m_nextPageButton)
			call TriggerAddAction(this.m_nextPageTrigger, function thistype.triggerActionNextPage)
			call AHashTable.global().setHandleInteger(this.m_nextPageTrigger, 0, this)
		endmethod

		private method removeNextPageButton takes nothing returns nothing
			set this.m_nextPageButton = null
			call AHashTable.global().destroyTrigger(this.m_nextPageTrigger)
			set this.m_nextPageTrigger = null
		endmethod

		public static method create takes player usedPlayer returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_isDisplayed = false
			// construction members
			set this.m_player = usedPlayer
			// members
			set this.m_dialog = DialogCreate()
			set this.m_dialogButtons = AIntegerVector.create()
			set this.m_currentPage = 0
			set this.m_maxPageNumber = 0

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.clear()
			set this.m_player = null
			call DialogDestroy(this.m_dialog)
			set this.m_dialog = null
			call this.m_dialogButtons.destroy()
		endmethod

		public static method init takes integer shortcutPreviousPage, integer shortcutNextPage, string textPreviousPage, string textNextPage, string textMessage returns nothing
			// static construction members
			set thistype.shortcutPreviousPage = shortcutPreviousPage
			set thistype.shortcutNextPage = shortcutNextPage
			set thistype.textPreviousPage = textPreviousPage
			set thistype.textNextPage = textNextPage
			set thistype.m_textMessage = textMessage
		endmethod
	endstruct

endlibrary