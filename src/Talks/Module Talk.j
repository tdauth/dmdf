library ModuleTalksTalk

	module Talk
		private static thistype m_talk

		public static method initTalk takes nothing returns nothing
			local texttag name
			set thistype.m_talk = thistype.create.evaluate()
			set name = CreateTextTag()
			call SetTextTagText(name, thistype.m_talk.name(), 10.0)
			call SetTextTagPosUnit(name, thistype.m_talk.unit(), 10.0)
			call SetTextTagVisibility(name, true)
		endmethod

		public static method talk takes nothing returns thistype
			return thistype.m_talk
		endmethod
	endmodule

endlibrary