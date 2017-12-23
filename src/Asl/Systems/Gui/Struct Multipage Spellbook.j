library AStructSystemsGuiMultipageSpellbook requires optional ALibraryCoreDebugMisc, ALibraryCoreStringConversion, AStructCoreGeneralHashTable, AStructCoreGeneralVector

	/**
	 * \brief Derive your custom struct from this struct to implement a custom action button.
	 * Override \ref onCheck() and \ref onTrigger() to implement the logic of your custom action.
	 */
	struct AMultipageSpellbookAction
		private AMultipageSpellbook m_multipageSpellbook
		private integer m_abilityId
		private integer m_spellbookAbilityId
		private trigger m_actionTrigger

		public method multipageSpellbook takes nothing returns AMultipageSpellbook
			return this.m_multipageSpellbook
		endmethod

		public method abilityId takes nothing returns integer
			return this.m_abilityId
		endmethod

		public method spellbookAbilityId takes nothing returns integer
			return this.m_spellbookAbilityId
		endmethod

		public method enable takes nothing returns nothing
			call EnableTrigger(this.m_actionTrigger)
		endmethod

		public method disable takes nothing returns nothing
			call DisableTrigger(this.m_actionTrigger)
		endmethod

		public method isShown takes unit whichUnit returns boolean
			return GetUnitAbilityLevel(whichUnit, this.spellbookAbilityId()) > 0
		endmethod

		public method show takes unit whichUnit returns nothing
			if (this.isShown(whichUnit)) then
				debug call Print("is shown ability: " + GetObjectName(this.spellbookAbilityId()))
				return
			endif

			debug call Print("Show ability: " + GetObjectName(this.spellbookAbilityId()))
			call UnitAddAbility(whichUnit, this.spellbookAbilityId())
			call SetPlayerAbilityAvailable(GetOwningPlayer(whichUnit), this.spellbookAbilityId(), false)
			call SetUnitAbilityLevel(whichUnit, this.abilityId(), 1)
			call this.enable()
		endmethod

		public method hide takes unit whichUnit returns nothing
			if (not this.isShown(whichUnit)) then
				return
			endif

			call this.disable() // disable to prevent casts if some spells have the same id (spell book)
			call UnitRemoveAbility(whichUnit, this.spellbookAbilityId())
		endmethod

		public stub method onCheck takes nothing returns boolean
			return true
		endmethod

		public stub method onTrigger takes nothing returns nothing
		endmethod

		private static method triggerConditionAction takes nothing returns boolean
			local thistype this = thistype(AHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			if (GetSpellAbilityId() == this.abilityId()) then
				return this.onCheck.evaluate()
			endif

			return false
		endmethod

		private static method triggerActionAction takes nothing returns nothing
			local thistype this = thistype(AHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			call this.onTrigger.execute()
		endmethod

		public static method create takes AMultipageSpellbook multipageSpellbook, integer abilityId, integer spellbookAbilityId returns thistype
			local thistype this = thistype.allocate()
			set this.m_multipageSpellbook = multipageSpellbook
			set this.m_abilityId = abilityId
			set this.m_spellbookAbilityId = spellbookAbilityId
			set this.m_actionTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_actionTrigger, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
			call TriggerAddCondition(this.m_actionTrigger, Condition(function thistype.triggerConditionAction))
			call TriggerAddAction(this.m_actionTrigger, function thistype.triggerActionAction)
			call AHashTable.global().setHandleInteger(this.m_actionTrigger, 0, this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_actionTrigger)
			set this.m_actionTrigger = null
		endmethod
	endstruct

	private struct AMultipageSpellbookActionNextPage extends AMultipageSpellbookAction

		public stub method onTrigger takes nothing returns nothing
			call this.multipageSpellbook().nextPage.evaluate()
		endmethod
	endstruct

	private struct AMultipageSpellbookActionPreviousPage extends AMultipageSpellbookAction

		public stub method onTrigger takes nothing returns nothing
			call this.multipageSpellbook().previousPage.evaluate()
		endmethod
	endstruct

	/**
	 * \brief A unit can get a spellbook ability which contains icons for all different actions. Since the number of icon slots is limited, this struct supports multiple pages of icons.
	 *
	 * New icons can be added with \ref addEntry() and the spell book gets automatically two actions for changing the current page.
	 */
	struct AMultipageSpellbook
		private unit m_unit
		private integer m_entriesPerPage = 8
		private integer m_currentPage = 0
		/**
		 * Stores instances of \ref AMultipageSpellbookAction.
		 */
		private AIntegerVector m_entries
		private string m_shortcut
		private AIntegerVector m_shownEntries
		private AMultipageSpellbookActionNextPage m_nextPageAction
		private AMultipageSpellbookActionPreviousPage m_previousPageAction

		public method unit takes nothing returns unit
			return this.m_unit
		endmethod

		public method entriesPerPage takes nothing returns integer
			return this.m_entriesPerPage
		endmethod

		/**
		 * \return Returns the maximum number of pages which depends on \ref entries() and \ref entriesPerPage().
		 */
		public method maxPages takes nothing returns integer
			local integer result = this.m_entries.size() / this.entriesPerPage()
			// add extra page for remaining entries
			if (ModuloInteger(this.m_entries.size(), this.entriesPerPage()) > 0) then
				set result = result + 1
			endif
			// at least one page
			if (result == 0) then
				set result = 1
			endif
			return result
		endmethod

		/**
		 * Updates the complete UI for the current page.
		 * Removes all shown entries from the UI and adds all entries to the UI for the currently shown page.
		 */
		public method updateUi takes nothing returns nothing
			local integer i = this.m_entries.size() / this.entriesPerPage() * this.m_currentPage
			local integer maxEntries = IMinBJ(this.m_entries.size(), i + this.entriesPerPage())
			local AMultipageSpellbookAction entry = 0
			local integer j = 0
			loop
				exitwhen (j == this.m_shownEntries.size())
				set entry = AMultipageSpellbookAction(this.m_shownEntries[j])
				call entry.hide(this.unit())
				set j = j + 1
			endloop
			call this.m_shownEntries.clear()

			debug call Print("Show entries: " + I2S(maxEntries))
			loop
				exitwhen (i == maxEntries)
				set entry = AMultipageSpellbookAction(this.m_entries[i])
				call entry.show(this.unit())
				call this.m_shownEntries.pushBack(entry)
				set i = i + 1
			endloop

			/*
			 * Only show if there are multiple pages at all.
			 */
			if (this.maxPages() > 1) then
				call this.m_nextPageAction.show(this.unit())
				call this.m_previousPageAction.show(this.unit())
			endif
		endmethod

		public method currentPage takes nothing returns integer
			return this.m_currentPage
		endmethod

		public method setCurrentPage takes integer page returns nothing
			if (this.currentPage() == page) then
				return
			endif

			set this.m_currentPage = page
			call this.updateUi()
		endmethod

		public method setEntriesPerPage takes integer entriesPerPage returns nothing
			debug if (entriesPerPage > 11) then
				debug call Print("Warning: More than 11 entries per page block place for page buttons.")
			debug endif
			set this.m_entriesPerPage = entriesPerPage
			call this.updateUi()
		endmethod

		public method nextPage takes nothing returns nothing
			if (this.currentPage() == this.maxPages() - 1) then
				call this.setCurrentPage(0)
			else
				call this.setCurrentPage(this.currentPage() + 1)
			endif

			if (GetTriggerPlayer() != null and this.m_shortcut != null) then
				call ForceUIKeyBJ(GetTriggerPlayer(), this.m_shortcut) // WORKAROUND: whenever an ability is being removed it closes grimoire
			endif
		endmethod

		public method previousPage takes nothing returns nothing
			if (this.currentPage() == 0) then
				call this.setCurrentPage(this.maxPages() - 1)
			else
				call this.setCurrentPage(this.currentPage() - 1)
			endif

			if (GetTriggerPlayer() != null and this.m_shortcut != null) then
				call ForceUIKeyBJ(GetTriggerPlayer(), this.m_shortcut) // WORKAROUND: whenever an ability is being removed it closes grimoire
			endif
		endmethod

		/**
		 * Adds a new entry to the multipage spellbook. It is appended to the end.
		 * The ownership of the entry is hold by the multipage spellbook. It will be destroyed automatically when
		 * the multipage spellbook is destroyed.
		 */
		public method addEntry takes AMultipageSpellbookAction entry returns integer
			call this.m_entries.pushBack(entry)
			call this.updateUi()

			return this.m_entries.backIndex()
		endmethod

		public method removeEntry takes integer index returns nothing
			call AMultipageSpellbookAction(this.m_entries[index]).destroy()
			call this.m_entries.erase(index)
		endmethod

		/**
		 * The shortcut is important for reopening the spellbook after updating its UI. Otherwise it will always be closed automatically
		 * when the UI is updated. Unfortunately this is the only way to keep it open.
		 * @{
		 * \param shortcut The shortcut for the spellbook ability which works also ingame. For example "A".
		 */
		public method setShortcut takes string shortcut returns nothing
			set this.m_shortcut = shortcut
		endmethod

		/**
		 * \return Returns the corresponding ingame shortcut for the spellbook ability.
		 */
		public method shortcut takes nothing returns string
			return this.m_shortcut
		endmethod
		/**
		 * @}
		 */

		public static method create takes unit whichUnit, integer nextPageAbility, integer nextPageSpellbookAbility, integer previousPageAbility, integer previousPageSpellbookAbility returns thistype
			local thistype this = thistype.allocate()
			set this.m_unit = whichUnit
			set this.m_entriesPerPage = 8
			set this.m_currentPage = 0
			set this.m_entries = AIntegerVector.create()
			set this.m_shortcut = null
			set this.m_shownEntries = AIntegerVector.create()
			set this.m_nextPageAction = AMultipageSpellbookActionNextPage.create(this, nextPageAbility, nextPageSpellbookAbility)
			set this.m_previousPageAction = AMultipageSpellbookActionPreviousPage.create(this, previousPageAbility, previousPageSpellbookAbility)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			local integer i = this.m_entries.size() - 1
			loop
				exitwhen (i < 0)
				call this.removeEntry(i)
				set i = i - 1
			endloop
			call this.m_entries.destroy()
			call this.m_shownEntries.destroy()
			call this.m_nextPageAction.destroy()
			call this.m_previousPageAction.destroy()
			set this.m_unit = null
		endmethod
	endstruct

endlibrary