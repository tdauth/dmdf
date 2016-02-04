library ModuleQuestsQuest

	module Quest
		private static thistype m_quest = 0

		public static method initQuest takes nothing returns nothing
			set thistype.m_quest = thistype.create.evaluate()
			// use the required quest column for information only
			call thistype.m_quest.setIsRequired(false)
		endmethod

		public static method quest takes nothing returns thistype
			return thistype.m_quest
		endmethod
	endmodule

endlibrary