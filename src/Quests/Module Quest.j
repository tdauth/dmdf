library ModuleQuestsQuest

	module Quest
		private static thistype m_quest

		public static method initQuest takes nothing returns nothing
			set thistype.m_quest = thistype.create.evaluate()
		endmethod

		public static method quest takes nothing returns thistype
			return thistype.m_quest
		endmethod
	endmodule

endlibrary