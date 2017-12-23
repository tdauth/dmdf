library StructGameZoneRestorePosition requires Asl

	/**
	 * \brief The restore position of a character for a specific zone in a specific map.
	 */
	struct ZoneRestorePosition
		private real m_x
		private real m_y
		private real m_facing

		public static method create takes real x, real y, real facing returns thistype
			local thistype this = thistype.allocate()
			set this.m_x = x
			set this.m_y = y
			set this.m_facing = facing

			return this
		endmethod

		public method x takes nothing returns real
			return this.m_x
		endmethod

		public method y takes nothing returns real
			return this.m_y
		endmethod

		public method facing takes nothing returns real
			return this.m_facing
		endmethod
	endstruct

endlibrary