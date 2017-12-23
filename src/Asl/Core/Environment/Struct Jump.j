library AStructCoreEnvironmentJump requires optional ALibraryCoreDebugMisc, AStructCoreGeneralList, ALibraryCoreMathsReal, ALibraryCoreMathsPoint, ALibraryCoreMathsUnit

	/// \todo Should be a part of \ref AJump, vJass bug.
	function interface AJumpAlightAction takes unit usedUnit returns nothing

	/**
	 * \brief Allows creating jump movements for units with a parabola curve.
	 *
	 * \todo Test and fix \ref AMissile first and use vectors for this struct, too afterwards.
	 */
	struct AJump
		// static construction members
		private static real m_refreshRate
		// static members
		private static timer m_timer
		private static AIntegerList m_jumps
		// dynamic members
		private real m_speed
		// construction members
		private unit m_unit
		private real m_maxHeight
		private real m_targetX
		private real m_targetY
		private AJumpAlightAction m_alightAction
		// members
		private real m_startX
		private real m_startY
		private real m_distance
		private real m_x

		//! runtextmacro optional A_STRUCT_DEBUG("\"AJump\"")

		// dynamic members

		/**
		 * Sets the distance the unit is moved in its target direction per second.
		 * \param speed The distance per second the unit is moved.
		 */
		public method setSpeed takes real speed returns nothing
			set this.m_speed = speed * thistype.m_refreshRate
		endmethod

		public method speed takes nothing returns real
			return this.m_speed
		endmethod

		// construction members

		private method refreshPosition takes nothing returns boolean
			set this.m_x = this.m_x + this.m_speed
			call SetUnitX(this.m_unit, GetPolarProjectionX(this.m_startX, GetUnitFacing(this.m_unit), this.m_x))
			call SetUnitY(this.m_unit, GetPolarProjectionY(this.m_startY, GetUnitFacing(this.m_unit), this.m_x))
			call SetUnitZ(this.m_unit, ParabolaZ(this.m_maxHeight, this.m_distance, this.m_x))
			return this.m_x >= this.m_distance
		endmethod

		public static method create takes unit usedUnit, real maxHeight, real targetX, real targetY, AJumpAlightAction alightAction, real speed returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			call this.setSpeed(speed)
			// construction members
			set this.m_unit = usedUnit
			set this.m_maxHeight = maxHeight
			set this.m_targetX = targetX
			set this.m_targetY = targetY
			set this.m_alightAction = alightAction
			// members
			set this.m_startX = GetUnitX(usedUnit)
			set this.m_startY = GetUnitY(usedUnit)
			set this.m_distance = GetDistanceBetweenPoints(this.m_startX, this.m_startY, 0.0, targetX, targetY, 0)
			set this.m_x = 0.0

			call PauseUnit(usedUnit, true)
			call SetUnitFacing(usedUnit, GetAngleBetweenPoints(this.m_startX, this.m_startY, targetX, targetY))

			call thistype.m_jumps.pushBack(this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call thistype.m_jumps.remove(this)
			if (this.m_unit != null) then //could be removed by user function
				call PauseUnit(this.m_unit, false)
			endif
			// construction members
			set this.m_unit = null
		endmethod

		/// \todo fast creation can cause crashes. behaviour is not change if vector members are erased in this method and not in destructor.
		private static method timerFunction takes nothing returns nothing
			local thistype jump
			local AIntegerListIterator iterator = thistype.m_jumps.begin()
			loop
				exitwhen (not iterator.isValid())
				set jump = iterator.data()
				call iterator.next()
				if (jump.refreshPosition()) then
					if (jump.m_alightAction != 0) then
						call jump.m_alightAction.evaluate(jump.m_unit)
					endif
					call jump.destroy()
				elseif (IsUnitDeadBJ(jump.m_unit)) then
					call jump.destroy()
				endif
			endloop
			call iterator.destroy()
		endmethod

		/**
		 * Initializes the whole AJump system. This method should be called before any AJump instance is created or used.
		 * \param refreshRate The periodic interval in seconds which is used to update all jumps positions.
		 */
		public static method init takes real refreshRate returns nothing
			// static construction members
			set thistype.m_refreshRate = refreshRate
			// static members
			set thistype.m_timer = CreateTimer()
			call TimerStart(thistype.m_timer, thistype.m_refreshRate, true, function thistype.timerFunction)
			set thistype.m_jumps = AIntegerList.create()
		endmethod

		public static method cleanUp takes nothing returns nothing
			call PauseTimer(thistype.m_timer)
			call DestroyTimer(thistype.m_timer)
			set thistype.m_timer = null
			loop
				exitwhen (thistype.m_jumps.empty())
				call thistype(thistype.m_jumps.back()).destroy()
			endloop
			call thistype.m_jumps.destroy()
		endmethod

		/**
		 * Resumes all jumps again after they have been disabled.
		 */
		public static method enable takes nothing returns nothing
			call ResumeTimer(thistype.m_timer)
		endmethod

		/**
		 * Pauses all jumps.
		 */
		public static method disable takes nothing returns nothing
			call PauseTimer(thistype.m_timer)
		endmethod

		public static method refreshRate takes nothing returns real
			return thistype.m_refreshRate
		endmethod
	endstruct

endlibrary