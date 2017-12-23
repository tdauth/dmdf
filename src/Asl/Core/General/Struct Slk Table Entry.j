/// Do not use this library, it is unfinished!
/// \todo Finish and test this library.
library AStructCoreGeneralSlkTableEntry

	/**
	 * \brief Basic inheritance struct for SLK tables.
	 * SLK tables are used by Warcraft II for saving object data of various kinds of objects like doodads, units etc..
	 * \todo There exists a problem with strings because their quotes will be ignored.
	 */
	struct ASlkTableEntry
		private static thistype array m_entry

		/// This method is based on the JassHelper manual's example.
		public static method entry takes integer index returns thistype
			if (thistype.m_entry[index] == 0) then
				set thistype.m_entry[index] = thistype.create()
			endif
			return thistype.m_entry[index]
		endmethod
	endstruct

endlibrary