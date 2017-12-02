library ModuleTalksTalk

	/**
	 * \brief Provides the singleton pattern for a talk struct.
	 * Allows the initialization of the single instance with the method \ref initTalk().
	 * Allows getting the single referene with the method \ref talk().
	 */
	module Talk
		private static thistype m_talk

		public static method initTalk takes nothing returns nothing
			set thistype.m_talk = thistype.create()
		endmethod

		public static method talk takes nothing returns thistype
			return thistype.m_talk
		endmethod
	endmodule

endlibrary