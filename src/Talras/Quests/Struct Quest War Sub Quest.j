library StructMapQuestsQuestWarSubQuest requires Asl, StructGameQuestArea

	/**
	 * \brief All sub quests of the quest "War" belong to one quest item of this quest. The item is completed when the sub quest itself is completed.
	 */
	struct QuestWarSubQuest extends SharedQuest
		private integer m_itemIndex
		
		private method stateActionComplete takes nothing returns nothing
			call QuestWar.quest.evaluate().questItem.evaluate(this.m_itemIndex).setState(thistype.stateCompleted)
			call this.displayState()
			// TODO quest disappears after this call
		endmethod
	
		public static method create takes string title, integer itemIndex returns thistype
			local thistype this = thistype.allocate(title)
			set this.m_itemIndex = itemIndex
			call this.setStateAction(thistype.stateCompleted, thistype.stateActionComplete)
			
			return this
		endmethod
	endstruct
	
endlibrary