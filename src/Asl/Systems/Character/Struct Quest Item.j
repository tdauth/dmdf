library AStructSystemsCharacterQuestItem requires optional ALibraryCoreDebugMisc, AStructSystemsCharacterAbstractQuest

	/**
	 * \brief The item of a \ref AQuest.
	 * An item represents one single task in a quest. A quest can consist of multiple items which have independent states.
	 */
	struct AQuestItem extends AAbstractQuest
		// construction members
		private AQuest m_quest
		// members
		private questitem m_questItem
		private integer m_index

		///! runtextmacro optional A_STRUCT_DEBUG("\"AQuestItem\"")

		// construction members

		public method quest takes nothing returns AQuest
			return this.m_quest
		endmethod

		// methods

		/**
		 * \return Returns the index of the quest item in the quest.
		 */
		public method index takes nothing returns integer
			return this.m_index
		endmethod

		/// Single call!
		public stub method enable takes nothing returns boolean
			if (this.setState(AAbstractQuest.stateNew)) then
				call this.quest().displayUpdate.evaluate()
				return true
			endif
			return false
		endmethod

		/// Single call!
		public stub method disable takes nothing returns boolean
			return this.setState(AAbstractQuest.stateNotUsed)
		endmethod

		/// Single call!
		public stub method complete takes nothing returns boolean
			local integer oldState = this.quest().state.evaluate()
			if (this.setState(AAbstractQuest.stateCompleted)) then
				if (this.quest().state.evaluate() == AAbstractQuest.stateCompleted and oldState != AAbstractQuest.stateCompleted) then
					call this.quest().displayState.evaluate()
				else
					call this.quest().displayUpdate.evaluate()
				endif
				return true
			endif
			return false
		endmethod

		/// Single call!
		public stub method fail takes nothing returns boolean
			local integer oldState = this.quest().state.evaluate()
			if (this.setState(AAbstractQuest.stateFailed)) then
				if (this.quest().state.evaluate() == AAbstractQuest.stateFailed and oldState != AAbstractQuest.stateFailed) then
					call this.quest().displayState.evaluate()
				else
					call this.quest().displayUpdate.evaluate()
				endif
				return true
			endif
			return false
		endmethod

		public stub method setStateWithoutCondition takes integer state returns nothing
			if (this.state() == state) then
				return
			endif
			call this.setStateWithoutConditionAndCheck.evaluate(state) // TODO JassHelper bug, shouldn't use .evaluate since we're calling from parent struct. Change order that this method is declared after setStateWithoutConditionAndCheck() again when bug is fixed.
			call this.quest().checkQuestItemsForState.evaluate(state)
		endmethod

		/// Friend relationship to \ref AQuest, do not use.
		public method createQuestItem takes nothing returns nothing
			if (AQuest.isQuestLogUsed.evaluate()) then
				set this.m_questItem = null
				set this.m_questItem = QuestCreateItem(this.quest().questLogQuest.evaluate())
				call QuestItemSetDescription(this.m_questItem, this.title())
				call QuestItemSetCompleted(this.m_questItem, this.state() == AAbstractQuest.stateCompleted)
			endif
		endmethod

		/// \note Required by structure \ref AQuest, don't call manually.
		public method setStateWithoutConditionAndCheck takes integer state returns nothing
			if (this.state() == state) then
				call super.setStateWithoutCondition(state)
				return
			endif
			call super.setStateWithoutCondition(state)
			call this.quest().reorderQuestItems.evaluate()
		endmethod

		public static method create takes AQuest whichQuest, string description returns thistype
			local thistype this = thistype.allocate(whichQuest.character(), description)
			debug if (whichQuest <= 0) then
				debug call this.print("Invalid used quest.")
			debug endif
			// construction members
			set this.m_quest = whichQuest
			// members
			if (AQuest.isQuestLogUsed.evaluate()) then
				set this.m_questItem = null
			endif
			set this.m_index = whichQuest.addQuestItem.evaluate(this)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.quest().removeQuestItemByIndex.evaluate(this.m_index)
			if (AQuest.isQuestLogUsed.evaluate()) then
				if (this.m_questItem != null) then
					set this.m_questItem = null
					//Could not destroy quest items!
				endif
			endif
		endmethod
	endstruct

endlibrary
