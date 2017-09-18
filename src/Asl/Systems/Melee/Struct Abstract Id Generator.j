library AStructSystemsMeleeAbstractIdGenerator

	/**
	 * Abstract structure which can be extended by structures which generate object data id's (e. g. unit type ids).
	 * \sa AAbstractIdItem, AIdGeneratorSet, AIdGeneratorTable
	 */
	struct AAbstractIdGenerator

		/**
		 * \return Returns a newly generated object data id according to the rules of the extension struct.
		 */
		public stub method generate takes nothing returns integer
			return 0
		endmethod
	endstruct

endlibrary