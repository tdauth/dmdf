library AStructCoreMathsPoint requires ALibraryCoreMathsPoint, ALibraryCoreMathsRect

	/**
	 * \brief APoint provides a 2-dimensional location similar to Warcraft III's data type \ref location but as vJass structure usable for inheritance.
	 */
	struct APoint
		// dynamic members
		private real m_x /// \todo Should be protected, vJass limit.
		private real m_y

		// dynamic members

		public method setX takes real x returns nothing
			set this.m_x = x
		endmethod

		public method x takes nothing returns real
			return this.m_x
		endmethod

		public method setY takes real y returns nothing
			set this.m_y = y
		endmethod

		public method y takes nothing returns real
			return this.m_y
		endmethod

		// methods

		public method isInRect takes rect whichRect returns boolean
			return RectContainsCoords(whichRect, this.m_x, this.m_y)
		endmethod

		public method containsCoordinates takes real x, real y returns boolean
			return this.m_x == x and this.m_y == y
		endmethod

		public method contains takes thistype other returns boolean
			return this.containsCoordinates(other.m_x, other.m_y)
		endmethod

		public method containsLocation takes location whichLocation returns boolean
			return this.containsCoordinates(GetLocationX(whichLocation), GetLocationY(whichLocation))
		endmethod

		public method containsRectCenter takes rect whichRect returns boolean
			return this.containsCoordinates(GetRectCenterX(whichRect), GetRectCenterY(whichRect))
		endmethod

		public method containsWidget takes widget whichWidget returns boolean
			return this.containsCoordinates(GetWidgetX(whichWidget), GetWidgetY(whichWidget))
		endmethod

		public method angleBetween takes thistype other returns real
			return GetAngleBetweenPoints(this.m_x, this.m_y, other.m_x, other.m_y)
		endmethod

		public method angleBetweenFromCentre takes thistype other, real centreX, real centreY returns real
			return GetAngleBetweenPointsFromCentre(centreX, centreY, this.m_x, this.m_y, other.m_x, other.m_y)
		endmethod

		public method polarProjectionX takes real angle, real distance returns real
			return GetPolarProjectionX(this.m_x, angle, distance)
		endmethod

		public method polarProjectionY takes real angle, real distance returns real
			return GetPolarProjectionY(this.m_y, angle, distance)
		endmethod

		public method polarProjectionLocation takes real angle, real distance returns location
			return GetPolarProjectionOfPoint(this.m_x, this.m_y, angle, distance)
		endmethod

		public method location takes nothing returns location
			return Location(this.m_x, this.m_y)
		endmethod

		public method polarProjectionRect takes real angle, real distance, real width, real height returns rect
			return RectFromPointSize(GetPolarProjectionX(this.m_x, angle, distance), GetPolarProjectionY(this.m_y, angle, distance), width, height)
		endmethod

		public method rect takes real width, real height returns rect
			return RectFromPointSize(this.m_x, this.m_y, width, height)
		endmethod

		public method assignToCoordinates takes real x, real y returns nothing
			set this.m_x = x
			set this.m_y = y
		endmethod

		public method assignTo takes thistype other returns nothing
			call this.assignToCoordinates(other.m_x, other.m_y)
		endmethod

		public method assignToLocation takes location whichLocation returns nothing
			call this.assignToCoordinates(GetLocationX(whichLocation), GetLocationY(whichLocation))
		endmethod

		public method assignToRectCenter takes rect whichRect returns nothing
			call this.assignToCoordinates(GetRectCenterX(whichRect), GetRectCenterY(whichRect))
		endmethod

		public method assignToWidget takes widget whichWidget returns nothing
			call this.assignToCoordinates(GetWidgetX(whichWidget), GetWidgetY(whichWidget))
		endmethod

		public static method create takes real x, real y returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			call this.assignToCoordinates(x, y)

			return this
		endmethod

		public static method createFrom takes thistype other returns thistype
			local thistype this = thistype.allocate()
			call this.assignTo(other)
			return this
		endmethod

		public static method createFromLocation takes location whichLocation returns thistype
			local thistype this = thistype.allocate()
			call this.assignToLocation(whichLocation)
			return this
		endmethod

		public static method createFromRectCenter takes rect whichRect returns thistype
			local thistype this = thistype.allocate()
			call this.assignToRectCenter(whichRect)
			return this
		endmethod

		public static method createFromWidget takes widget whichWidget returns thistype
			local thistype this = thistype.allocate()
			call this.assignToWidget(whichWidget)
			return this
		endmethod
	endstruct

endlibrary
