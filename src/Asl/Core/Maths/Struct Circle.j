library AStructCoreMathsCircle requires AStructCoreMathsPoint, ALibraryCoreMathsPoint

	struct ACircle extends APoint
		// dynamic members
		private real m_radius

		// dynamic members

		public method setRadius takes real radius returns nothing
			set this.m_radius = radius
		endmethod

		public method radius takes nothing returns real
			return this.m_radius
		endmethod

		// methods

		public method diameter takes nothing returns real
			return 2 * this.m_radius
		endmethod

		public method area takes nothing returns real
			return Pow(this.m_radius, 2.0) * bj_PI
		endmethod

		public method areaContainsPoint takes real x, real y returns boolean
			return (GetDistanceBetweenPoints(x, y, 0.0, this.x(), this.y(), 0.0) <= this.m_radius)
		endmethod

		//instead of x() and y() it has to be a protected element
		//but there is no protected keyword...
		public method borderContainsPoint takes real x, real y returns boolean
			return (GetDistanceBetweenPoints(x, y, 0.0, this.x(), this.y(), 0.0) == this.m_radius)
		endmethod

		//! textmacro ACircleMacro takes TYPE, TYPENAME
			public method areaContains$TYPENAME$ takes $TYPE$ circle$TYPENAME$ returns boolean
				return this.areaContainsPoint(Get$TYPENAME$X(circle$TYPENAME$), Get$TYPENAME$Y(circle$TYPENAME$)) //Because of the location type I use the 'Circle' prefix
			endmethod

			public method borderContains$TYPENAME$ takes $TYPE$ circle$TYPENAME$ returns boolean
				return this.borderContainsPoint(Get$TYPENAME$X(circle$TYPENAME$), Get$TYPENAME$Y(circle$TYPENAME$))
			endmethod
		//! endtextmacro

		//! runtextmacro ACircleMacro("location", "Location")
		//! runtextmacro ACircleMacro("widget", "Widget")
		//! runtextmacro ACircleMacro("unit", "Unit")
		//! runtextmacro ACircleMacro("destructable", "Destructable")
		//! runtextmacro ACircleMacro("item", "Item")

		public method borderLocation takes real angle returns location
			return GetPolarProjectionOfPoint(this.x(), this.y(), angle, this.m_radius)
		endmethod

		public method randomAreaLocation takes nothing returns location
			local real distance = (SquareRoot(GetRandomReal(0.0, 1.0)) * this.m_radius)
			local real angle = GetRandomReal(0.0, (2.0 * bj_PI))
			return Location((this.x() + (distance * Cos(angle))), (this.y() + (distance * Sin(angle))))
		endmethod

		/// \return Added special effect.
		public method addSpecialEffect takes string modelName, real angle, real distance returns effect
			return AddSpecialEffect(modelName, this.polarProjectionX(angle, distance), this.polarProjectionY(angle, distance))
		endmethod

		/// \return Added spell effect.
		public method addSpellEffect takes string abilityString, effecttype effectType, real angle, real distance returns effect
			return AddSpellEffect(abilityString, effectType, this.polarProjectionX(angle, distance), this.polarProjectionY(angle, distance))
		endmethod

		/// \return Added spell effect.
		public method addSpellEffectById takes integer abilityId, effecttype effectType, real angle, real distance returns effect
			return AddSpellEffectById(abilityId, effectType, this.polarProjectionX(angle, distance), this.polarProjectionY(angle, distance))
		endmethod

		/// \return Created unit.
		public method createUnit takes player user, integer unitType, real angle, real distance, real face returns unit
			return CreateUnit(user, unitType, this.polarProjectionX(angle, distance), this.polarProjectionY(angle, distance), face)
		endmethod

		/// \return Created destructable.
		public method createDestructable takes integer destructableType, real angle, real distance, real face, real scale, integer variation returns destructable
			return CreateDestructable(destructableType, this.polarProjectionX(angle, distance), this.polarProjectionY(angle, distance), face, scale, variation)
		endmethod

		/// \return Created destructable.
		public method createDestructableZ takes integer destructableType, real angle, real distance, real z, real face, real scale, integer variation returns destructable
			return CreateDestructableZ(destructableType, this.polarProjectionX(angle, distance), this.polarProjectionY(angle, distance), z, face, scale, variation)
		endmethod

		/// \return Created item.
		public method createItem takes integer itemType, real angle, real distance returns item
			return CreateItem(itemType, this.polarProjectionX(angle, distance), this.polarProjectionY(angle, distance))
		endmethod

		/// \return Created trackable.
		public method createTrackable takes string modelPath, real angle, real distance, real facing returns trackable
			return CreateTrackable(modelPath, this.polarProjectionX(angle, distance), this.polarProjectionY(angle, distance), facing)
		endmethod

		public static method create takes real x, real y, real radius returns thistype
			local thistype this = thistype.allocate(x, y)
			// dynamic members
			set this.m_radius = radius

			return this
		endmethod
	endstruct

endlibrary