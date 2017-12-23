library AStructSystemsGuiDialogButton requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, ALibraryCoreStringConversion

	/// \todo Should be a part of \ref ADialogButton, vJass bug.
	function interface ADialogButtonAction takes ADialogButton dialogButton returns nothing

	/**
	* Dialog buttons will be added to their corresponding dialogs automatically when being created.
	* \todo Add property "permanent" which indicates that the button is shown on each page of dialog.
	*/
	struct ADialogButton
		// construction members
		private ADialog m_dialog
		private string m_text
		private integer m_shortcut
		private boolean m_isQuitButton
		private boolean m_doScoreScreen
		private ADialogButtonAction m_action
		// members
		private integer m_index
		private button m_button
		private trigger m_trigger

		//! runtextmacro optional A_STRUCT_DEBUG("\"ADialogButton\"")

		// construction members

		public method dialog takes nothing returns ADialog
			return this.m_dialog
		endmethod

		public method text takes nothing returns string
			return this.m_text
		endmethod

		public method shortcut takes nothing returns integer
			return this.m_shortcut
		endmethod

		public method isQuitButton takes nothing returns boolean
			return this.m_isQuitButton
		endmethod

		public method doScoreScreen takes nothing returns boolean
			return this.m_doScoreScreen
		endmethod

		public method action takes nothing returns ADialogButtonAction
			return this.m_action
		endmethod

		// members

		/**
		 * \return Returns the button's index of dialog. Dialog button indices start at 0.
		 * \sa ADialogButton.pageIndex()
		 */
		public method index takes nothing returns integer
			return this.m_index
		endmethod

		public method button takes nothing returns button
			return this.m_button
		endmethod

		// methods

		public stub method onAction takes nothing returns nothing
			// action should never be 0
			//if (this.m_action != 0) then
				call this.m_action.execute(this)
			//endif
		endmethod

		/**
		 * \return Returns the button's page and not global index. Dialog button page indices start at 0.
		 * \sa ADialogButton.index()
		 */
		public method pageIndex takes nothing returns integer
			return ModuloInteger(this.m_index, ADialog.maxPageButtons)
		endmethod

		/**
		 * Usually you do not need this method. It is used by \ref ADialog.
		 * Hightlights shortcuts of dialog buttons white (ffffff) since text normally is
		 * coloured yellow.
		 */
		public method addButton takes nothing returns nothing
			if (not this.m_isQuitButton) then
				set this.m_button = DialogAddButton(this.m_dialog.dialog.evaluate(), HighlightShortcut(this.m_text, this.m_shortcut, "ffffffff"),  this.m_shortcut)
			else
				 set this.m_button = DialogAddQuitButton(this.m_dialog.dialog.evaluate(), this.m_doScoreScreen, HighlightShortcut(this.m_text, this.m_shortcut, "ffffffff"),  this.m_shortcut)
			endif
			call this.createTrigger.evaluate()
		endmethod

		public method removeButton takes nothing returns nothing
			set this.m_button = null
			call this.destroyTrigger.evaluate()
		endmethod

		private static method triggerActionRunDialogButtonAction takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local ADialogButton this = AHashTable.global().handleInteger(triggeringTrigger, 0)
			call this.dialog().setDisplayedByButton.evaluate(false) // Do not clear the dialog automatically (dialog().clear()) since it can be shown again with same buttons.
			call this.onAction()
			set triggeringTrigger = null
		endmethod

		private method createTrigger takes nothing returns nothing
			local event triggerEvent
			local triggeraction triggerAction
			// create always since it sends the dialog that it's hidden again.
			//if (this.m_action != 0) then
				set this.m_trigger = CreateTrigger()
				set triggerEvent = TriggerRegisterDialogButtonEvent(this.m_trigger, this.m_button)
				set triggerAction = TriggerAddAction(this.m_trigger, function thistype.triggerActionRunDialogButtonAction)
				call AHashTable.global().setHandleInteger(this.m_trigger, 0, this)
				set triggerEvent = null
				set triggerAction = null
			//endif
		endmethod

		public static method create takes ADialog whichDialog, string text, integer shortcut, boolean isQuitButton, boolean doScoreScreen, ADialogButtonAction action returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_dialog = whichDialog
			set this.m_text = text
			set this.m_shortcut = shortcut
			set this.m_isQuitButton = isQuitButton
			set this.m_doScoreScreen = doScoreScreen
			set this.m_action = action
			// members
			set this.m_index = whichDialog.addDialogButtonInstance.evaluate(this)

			return this
		endmethod

		private method destroyTrigger takes nothing returns nothing
			//if (this.m_action != 0) then
				call AHashTable.global().destroyTrigger(this.m_trigger)
				set this.m_trigger = null
			//endif
		endmethod

		public method onDestroy takes nothing returns nothing
			// NOTE do not remove the button automatically from the dialog since it makes the indicies invalid.
			if (this.m_button != null) then
				set this.m_button = null // can not be destroyed
				call this.destroyTrigger()
			endif
		endmethod
	endstruct

endlibrary