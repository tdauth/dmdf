library AStructSystemsMeleeAbstractIdLevelGenerator

	/**
	* Allows implementation of an id generator which uses a level value as choice criterion (e. g. for unit type or item type ids).
	*/
	struct AAbstractIdLevelGenerator extends AAbstractIdGenerator
		private integer m_level

		/**
		* \param level -1 means random.
		*/
		public method setLevel takes integer level returns nothing
			set this.m_level = level
		endmethod

		/**
		* \return -1 means random.
		*/
		public method level takes nothing returns integer
			return this.m_level
		endmethod

		/**
		* \copydoc AAbstractIdLevelGenerator#setLevel
		*/
		public static method create takes integer level returns thistype
			local thistype this = thistype.allocate()
			set this.m_level = level

			return this
		endmethod
	endstruct

endlibrary