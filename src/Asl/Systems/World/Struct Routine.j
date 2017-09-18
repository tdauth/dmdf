library AStructSystemsWorldRoutine requires optional ALibraryCoreDebugMisc, ALibraryCoreEnvironmentTimeOfDay, AStructCoreGeneralHashTable, AStructCoreGeneralList, ALibraryCoreMathsUnit

	/// \todo Should be contained by \ref ARoutinePeriod, vJass bug.
	function interface ARoutineCondition takes ARoutinePeriod period returns boolean

	/// \todo Should be a part of \ref ARoutine, vJass bug.
	function interface ARoutineAction takes ARoutinePeriod period returns nothing

	/**
	 * \brief Provides NPC routine handling like in the games series Gothic.
	 * You are able to assign day times and routine actions either by using the function interface \ref ARouteAction or by overwriting stub event methods in your derived structure.
	 * There are start, end and target actions which can be specified by user.
	 * Additionally, you can make periodic routines by calling \ref AContinueRoutineLoop in your routine action.
	 * If the assigned unit is paused, routine won't be run until unit gets unpaused.
	 * Each routine can be used by multiple NPCs (units) at multiple times using \ref ARoutinePeriod.
	 * \sa ARoutinePeriod
	 */
	struct ARoutine
		// dynamic members
		private boolean m_hasTarget
		private boolean m_isLoop
		private ARoutineCondition m_condition
		private ARoutineAction m_startAction
		private ARoutineAction m_endAction
		private ARoutineAction m_targetAction

		//! runtextmacro optional A_STRUCT_DEBUG("\"ARoutine\"")

		// dynamic members

		/**
		 * Routines with targets send their NPCs to target rects and call the target action when the NPC reached its target.
		 */
		public method setHasTarget takes boolean hasTarget returns nothing
			set this.m_hasTarget = hasTarget
		endmethod

		public method hasTarget takes nothing returns boolean
			return this.m_hasTarget
		endmethod

		/**
		 * Loop routines will be automatically resumed on \ref ARoutinePeriod.resume() as well as
		 * checked in \ref AContinueRoutineLoop().
		 * Despite setting this to true \ref AContinueRoutineLoop() has to be called manually in the routine target action.
		 */
		public method setIsLoop takes boolean isLoop returns nothing
			set this.m_isLoop = isLoop
		endmethod

		public method isLoop takes nothing returns boolean
			return this.m_isLoop
		endmethod

		/**
		 * \param condition Condition which is evaluated whenever routine period should be started automatically (in \ref onCondition()). It's only started if this condition returns true or is set to 0.
		 */
		public method setCondition takes ARoutineCondition condition returns nothing
			set this.m_condition = condition
		endmethod

		public method condition takes nothing returns ARoutineCondition
			return this.m_condition
		endmethod

		public method setStartAction takes ARoutineAction startAction returns nothing
			set this.m_startAction = startAction
		endmethod

		public method startAction takes nothing returns ARoutineAction
			return this.m_startAction
		endmethod

		public method setEndAction takes ARoutineAction endAction returns nothing
			set this.m_endAction = endAction
		endmethod

		public method endAction takes nothing returns ARoutineAction
			return this.m_startAction
		endmethod

		public method setTargetAction takes ARoutineAction targetAction returns nothing
			set this.m_targetAction = targetAction
		endmethod

		public method targetAction takes nothing returns ARoutineAction
			return this.m_targetAction
		endmethod

		// methods

		/**
		 * Called by .evaluate().
		 * Usually calls \ref condition() via .evaluate().
		 */
		public stub method onCondition takes ARoutinePeriod period returns boolean
			if (this.condition() != 0) then
				return this.condition().evaluate(period)
			endif
			return true
		endmethod

		/**
		 * Called by .execute().
		 * Usually calls \ref startAction() via .execute().
		 */
		public stub method onStart takes ARoutinePeriod period returns nothing
			if (this.startAction() != 0) then
				call this.startAction().execute(period)
			endif
		endmethod

		/**
		 * Called by .execute().
		 * Usually calls \ref endAction() via .execute().
		 */
		public stub method onEnd takes ARoutinePeriod period returns nothing
			if (this.endAction() != 0) then
				call this.endAction().execute(period)
			endif
		endmethod

		/**
		 * Called by .execute().
		 * Usually calls \ref targetAction() via .execute().
		 */
		public stub method onTarget takes ARoutinePeriod period returns nothing
			//debug call this.print("OnTarget for unit " + GetUnitName(period.unit.evaluate()))
			if (this.targetAction() != 0) then
				//debug call this.print("OnTarget has target action, calling with execute for unit " + GetUnitName(period.unit.evaluate()))
				call this.targetAction().execute(period)
			endif
		endmethod

		/**
		 * \param hasTarget If this value is true routine's unit will be send to its target rect before starting its target action.
		 * \param isLoop If this value is true target action will be called as loop.
		 * \param startAction This action is called when the routine starts for a unit. It's called in \ref thistype.onStart().
		 * \param endAction This action is called when the routine ends for a unit. It's called in \ref thistype.onEnd().
		 * \param targetAction This action is either be called (if routine has target) when a unit reaches target rect or when the routine starts. It's called in \ref thistype.onTarget().
		 * \return Returns a newly created routine.
		 */
		public static method create takes boolean hasTarget, boolean isLoop, ARoutineCondition condition, ARoutineAction startAction, ARoutineAction endAction, ARoutineAction targetAction returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_hasTarget = hasTarget
			set this.m_isLoop = isLoop
			set this.m_condition = condition
			set this.m_startAction = startAction
			set this.m_endAction = endAction
			set this.m_targetAction = targetAction

			return this
		endmethod
	endstruct

	/**
	 * \brief Each unit can have multiple times for one single routine provided by this structure.
	 * Additionally, each time range can have its own target rect which is used for routines which do have a target (\ref ARoutine.hasTarget()).
	 * Time ranges can be enabled and disabled dynamically using \ref setEnabled().
	 * As long as the corresponding unit is paused active routines will be queued to be started when unit is being unpaused.
	 * \note When \ref PauseUnit() is called routines are stopped and resumed automatically!
	 * \note If some periods do have some intersections, the latest will always be enabled because there can only be one routine per unit active at the same time, so you're recommended to avoid this.
	 * \sa AUnitRoutine
	 */
	struct ARoutinePeriod
		private static constant integer hashTableKeyCurrent = A_HASHTABLE_KEY_ROUTINE_CURRENT
		private static constant integer hashTableKeyNext = A_HASHTABLE_KEY_ROUTINE_NEXT
		// static members
		private static AIntegerList m_routinePeriods // required for manual time changes using SetFloatGameState(GAME_STATE_TIME_OF_DAY, <>) or SetTimeOfDay()
		// dynamic members
		private ARoutine m_routine
		private unit m_unit
		private real m_startTimeOfDay
		private real m_endTimeOfDay
		private rect m_targetRect
		// members
		private boolean m_isEnabled
		private trigger m_startTrigger
		private trigger m_endTrigger
		private trigger m_targetTrigger
		private region m_targetRegion

		//! runtextmacro optional A_STRUCT_DEBUG("\"ARoutinePeriod\"")

		/**
		 * \todo At its current state changing the routine won't affect the period's behaviour immediately.
		 */
		public method setRoutine takes ARoutine routine returns nothing
			set this.m_routine = routine
		endmethod

		public method routine takes nothing returns ARoutine
			return this.m_routine
		endmethod

		/**
		 * \sa setUnit()
		 */
		public method unit takes nothing returns unit
			return this.m_unit
		endmethod

		public method startTimeOfDay takes nothing returns real
			return this.m_startTimeOfDay
		endmethod

		public method endTimeOfDay takes nothing returns real
			return this.m_endTimeOfDay
		endmethod

		public method targetRect takes nothing returns rect
			return this.m_targetRect
		endmethod

		// members

		/**
		 * \return Returns true if the period is enabled for the unit which means that it gets started when the time of day is reached. Otherwise it returns false.
		 */
		public method isEnabled takes nothing returns boolean
			return this.m_isEnabled
		endmethod

		// methods

		/**
		 * \return Returns the currently active period for unit \p whichUnit. This is 0 if none is currently active.
		 */
		public static method current takes unit whichUnit returns thistype
			return AHashTable.global().handleInteger(whichUnit, thistype.hashTableKeyCurrent)
		endmethod

		/**
		 * \return Returns true if there is a currently active period for unit \p whichUnit.
		 */
		public static method hasCurrent takes unit whichUnit returns boolean
			return AHashTable.global().hasHandleInteger(whichUnit, thistype.hashTableKeyCurrent)
		endmethod

		public static method next takes unit whichUnit returns thistype
			return AHashTable.global().handleInteger(whichUnit, thistype.hashTableKeyNext)
		endmethod

		public static method hasNext takes unit whichUnit returns boolean
			return AHashTable.global().hasHandleInteger(whichUnit, thistype.hashTableKeyNext)
		endmethod

		private static method setCurrent takes unit whichUnit, thistype period returns nothing
			call AHashTable.global().setHandleInteger(whichUnit, thistype.hashTableKeyCurrent, period)
		endmethod

		private static method clearCurrent takes unit whichUnit returns nothing
			call AHashTable.global().removeHandleInteger(whichUnit, thistype.hashTableKeyCurrent)
		endmethod

		private static method setNext takes unit whichUnit, thistype period returns nothing
			//don't check if there's already a value, just overwrite!
			call AHashTable.global().setHandleInteger(whichUnit, thistype.hashTableKeyNext, period)
		endmethod

		private static method clearNext takes unit whichUnit returns nothing
			call AHashTable.global().removeHandleInteger(whichUnit, thistype.hashTableKeyNext)
		endmethod

		public method canContinue takes nothing returns boolean
			return (not IsUnitPaused(this.unit()) and this.isEnabled())
		endmethod

		/**
		 * \return Returns true if \p timeOfDay is during the routine's time.
		 */
		public method isInSpecifiedTime takes real timeOfDay returns boolean
			if (this.startTimeOfDay() > this.endTimeOfDay()) then // next day
				return timeOfDay >= this.startTimeOfDay() or timeOfDay <= this.endTimeOfDay()
			endif
			return timeOfDay >= this.startTimeOfDay() and timeOfDay <= this.endTimeOfDay()
		endmethod

		/**
		 * \return Returns true if the current time of day is in the routine period.
		 */
		public method isInTime takes nothing returns boolean
			return this.isInSpecifiedTime(GetFloatGameState(GAME_STATE_TIME_OF_DAY))
		endmethod

		/**
		 * \return Returns true if the period is the one which is currently active for the corresponding unit. Otherwise it returns false.
		 */
		public method isCurrent takes nothing returns boolean
			return thistype.current(this.unit()) == this
		endmethod

		/**
		 * \return Returns true if the period is the one which is currently queued as next for the corresponding unit. Otherwise it returns false.
		 */
		public method isNext takes nothing returns boolean
			return thistype.next(this.unit()) == this
		endmethod

		private method destroyTargetTrigger takes nothing returns nothing
			if (this.m_targetRegion != null) then
				call RemoveRegion(this.m_targetRegion)
				set this.m_targetRegion = null
			endif
			if (this.m_targetTrigger != null) then
				call AHashTable.global().destroyTrigger(this.m_targetTrigger)
				set this.m_targetTrigger = null
			endif
		endmethod

		private static method triggerConditionTarget takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local boolean result = GetTriggerUnit() == this.unit()
			//debug call this.print("Target condition, entering unit: " + GetUnitName(GetTriggerUnit()) + " and name of required unit: " + GetUnitName(this.unit()))
			return result
		endmethod

		private static method triggerActionTarget takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call DisableTrigger(GetTriggeringTrigger())
			//debug call this.print("Routine is " + I2S(this.routine()))
			call this.routine().onTarget.execute(this)
			//debug call this.print("Before destroying target trigger")
			call this.destroyTargetTrigger() // destroys this trigger
			//debug call this.print("After target trigger destruction")
		endmethod

		private method createTargetTrigger takes nothing returns nothing
			call this.destroyTargetTrigger()
			set this.m_targetRegion = CreateRegion()
			call RegionAddRect(this.m_targetRegion, this.targetRect())
			set this.m_targetTrigger = CreateTrigger()
			call TriggerRegisterEnterRegion(this.m_targetTrigger, this.m_targetRegion, null)
			call TriggerAddCondition(this.m_targetTrigger, Condition(function thistype.triggerConditionTarget))
			call TriggerAddAction(this.m_targetTrigger, function thistype.triggerActionTarget)
			call AHashTable.global().setHandleInteger(this.m_targetTrigger, 0, this)
			call IssueRectOrder(this.unit(), "move", this.targetRect())
			//debug call this.print("Created target trigger for " + GetUnitName(this.unit()))
		endmethod

		/**
		 * Ends the routine period and clears it from the unit.
		 * Destroys the target trigger and calls \ref ARoutine.onEnd() with .execute() if it is enabled.
		 */
		private method end takes nothing returns nothing
			if (this.isCurrent()) then
				call thistype.clearCurrent(this.unit())
			endif
			if (this.isNext()) then
				call thistype.clearNext(this.unit())
			endif
			if (this.routine().hasTarget() and this.m_targetTrigger != null) then
				call this.destroyTargetTrigger()
			endif
			if (this.isEnabled()) then
				call this.routine().onEnd.execute(this)
			endif
		endmethod

		/**
		 * Internal method which is called when routine period time of day is reached.
		 * Should only be called manually with checking \ref isInTime().
		 * It does also automatically call end() of the currently enabled routine of the unit.
		 */
		public method start takes nothing returns nothing
			local boolean condition = this.routine().onCondition.evaluate(this)
			// start immediately
			if (not IsUnitPaused(this.unit())) then
				if (condition) then // optional condition
					// current routine has not been disabled already
					if (thistype.hasCurrent(this.unit()) and not this.isCurrent()) then
						//debug call this.print("Warning: " + GetUnitName(this.unit()) + " routine period " + I2S(thistype.current(this.unit())) + " has not been disabled before starting " + I2S(this))
						call thistype.current(this.unit()).end()
						call thistype.clearCurrent(this.unit())
					endif

					/*
					 * Clear the next queued.
					 */
					if (thistype.hasNext(this.unit()) and this.isNext()) then
						call thistype.clearNext(this.unit())
					elseif (not this.isNext()) then
						//debug call this.print("Warning: " + GetUnitName(this.unit()) + " at start time " + R2S(this.startTimeOfDay()) + " overlaps with " + I2S(thistype.next(this.unit())) + " with start time " + R2S(thistype.next(this.unit()).startTimeOfDay()))
					endif

					call thistype.setCurrent(this.unit(), this)
					call this.routine().onStart.execute(this)

					if (this.routine().hasTarget()) then
						if (RectContainsUnit(this.m_targetRect, this.unit())) then // already at target
							call this.routine().onTarget.execute(this)
						else
							call this.createTargetTrigger()
						endif
					endif
				endif
			// queue for paused unit that it will be started on unpausing the unit
			elseif (condition) then // optional condition
				call thistype.setNext(this.unit(), this)
			endif
		endmethod

		private static method triggerActionStart takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			//debug call this.print("Starting for unit " + GetUnitName(this.unit()))
			call this.start()
		endmethod

		private method createStartTrigger takes nothing returns nothing
			set this.m_startTrigger = CreateTrigger()
			call TriggerRegisterGameStateEvent(this.m_startTrigger, GAME_STATE_TIME_OF_DAY, EQUAL, this.m_startTimeOfDay)
			call TriggerAddAction(this.m_startTrigger, function thistype.triggerActionStart)
			call AHashTable.global().setHandleInteger(this.m_startTrigger, 0, this)
		endmethod

		private static method triggerActionEnd takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.end()
		endmethod

		private method createEndTrigger takes nothing returns nothing
			set this.m_endTrigger = CreateTrigger()
			call TriggerRegisterGameStateEvent(this.m_endTrigger, GAME_STATE_TIME_OF_DAY, EQUAL, this.m_endTimeOfDay)
			call TriggerAddAction(this.m_endTrigger, function thistype.triggerActionEnd)
			call AHashTable.global().setHandleInteger(this.m_endTrigger, 0, this)
		endmethod

		private method destroyStartTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_startTrigger)
			set this.m_startTrigger = null
		endmethod

		private method destroyEndTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_endTrigger)
			set this.m_endTrigger = null
		endmethod

		/**
		 * Changes the start time of day at which the period is triggered for the unit.
		 * \param startTimeOfDay The real representation of the time of day at which the period is started.
		 */
		public method setStartTimeOfDay takes real startTimeOfDay returns nothing
			debug if (not IsTimeOfDay(startTimeOfDay)) then
				debug call this.print("start time of day is no valid time of day: " + R2S(startTimeOfDay))
			debug endif
			set this.m_startTimeOfDay = startTimeOfDay
			/*
			 * The start trigger as to be recreated with the new time of day as float state.
			 */
			call this.destroyStartTrigger()
			call this.createStartTrigger()
		endmethod

		public method setEndTimeOfDay takes real endTimeOfDay returns nothing
			debug if (not IsTimeOfDay(endTimeOfDay)) then
				debug call this.print("end time of day is no valid time of day: " + R2S(endTimeOfDay))
			debug endif
			set this.m_endTimeOfDay = endTimeOfDay
			/*
			 * The end trigger as to be recreated with the new time of day as float state.
			 */
			call this.destroyEndTrigger()
			call this.createEndTrigger()
		endmethod

		/// \note Expects to be in time (use \ref isInTime() to verify)!
		private method resume takes nothing returns nothing
			if (this.routine().hasTarget()) then
				call EnableTrigger(this.m_endTrigger)
				if (this.m_targetTrigger != null) then
					if (RectContainsUnit(this.m_targetRect, this.unit())) then // reached target
						call this.routine().onTarget.execute(this)
						call this.destroyTargetTrigger()
					else // has to reach target
						call EnableTrigger(this.m_targetTrigger)
						call IssueRectOrder(this.unit(), "move", this.targetRect())
					endif
				// is still in target and loop action
				elseif (RectContainsUnit(this.m_targetRect, this.unit()) and this.routine().isLoop()) then
					call this.routine().onTarget.execute(this)
				endif
			endif
		endmethod

		/**
		 * Enables the period for the specified unit.
		 * Should only be called if it was disabled before, otherwise it has no effect.
		 * \sa disable()
		 * \sa setEnabled()
		 */
		public stub method enable takes nothing returns nothing
			if (this.isEnabled()) then
				debug call this.print("Trying to enable an enabled period.")
				return
			endif
			set this.m_isEnabled = true
			call EnableTrigger(this.m_startTrigger)
			if (not IsUnitPaused(this.unit())) then
				call EnableTrigger(this.m_endTrigger)
				if (this.m_targetTrigger != null) then
					call EnableTrigger(this.m_targetTrigger)
				endif
				if (this.isInTime()) then
					call this.resume()
				endif
			endif
		endmethod

		/**
		 * Disables the period for the specified unit.
		 * Should only be called if it was enabled before, otherwise it has no effect.
		 * \sa enable()
		 * \sa setEnabled()
		 */
		public stub method disable takes nothing returns nothing
			if (not this.isEnabled()) then
				debug call this.print("Trying to disable a disabled period.")
				return
			endif
			set this.m_isEnabled = false
			call DisableTrigger(this.m_startTrigger)
			if (not IsUnitPaused(this.unit())) then
				// run end trigger to clear data
				if (thistype.current(this.unit()) != this and thistype.next(this.unit()) != this) then
					call DisableTrigger(this.m_endTrigger)
				endif
				if (this.m_targetTrigger != null) then
					call DisableTrigger(this.m_targetTrigger)
				endif
			endif
		endmethod

		/**
		 * \sa enable()
		 * \sa disable()
		 */
		public method setEnabled takes boolean enabled returns nothing
			if (enabled) then
				call this.enable()
			else
				call this.disable()
			endif
		endmethod

		/**
		 * \sa unit()
		 */
		public stub method setUnit takes unit whichUnit returns nothing
			if (this.unit() == whichUnit) then
				return
			endif
			call this.destroyTargetTrigger()

			if (thistype.current(this.unit()) == this) then
				call thistype.clearCurrent(this.unit())
				call thistype.setCurrent(whichUnit, this)
			endif

			if (thistype.next(this.unit()) == this) then
				call thistype.clearNext(this.unit())
				call thistype.setNext(whichUnit, this)
			endif

			set this.m_unit = whichUnit

			if (this.canContinue() and this.isInTime()) then
				call this.resume()
			endif
		endmethod

		/**
		 * Creates a new period for a unit in a time frame.
		 * \param routine The routine which is used for the period.
		 * \param whichUnit The unit which runs the period at the given time of day.
		 * \param startTimeOfDay The start time of the period. At this time the period will start and be triggered automatically for the unit.
		 * \param endTimeOfDay The end time of the period. At this time the period will end which will also be triggered automatically for the unit.
		 * \param targetRect The target rect where the unit has to move. This is only required for routines with targets. The period will only start when the unit has reached the target rect.
		 */
		public static method create takes ARoutine routine, unit whichUnit, real startTimeOfDay, real endTimeOfDay, rect targetRect returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_routine = routine
			set this.m_unit = whichUnit
			set this.m_startTimeOfDay = startTimeOfDay
			set this.m_endTimeOfDay = endTimeOfDay
			set this.m_targetRect = targetRect
			// members
			set this.m_isEnabled = true
			set this.m_targetRegion = null

			call this.createStartTrigger()
			call this.createEndTrigger()

			// static members
			call thistype.m_routinePeriods.pushBack(this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			if (thistype.current(this.unit()) == this) then
				call thistype.clearCurrent(this.unit())
			endif
			if (thistype.next(this.unit()) == this) then
				call thistype.clearNext(this.unit())
			endif
			// dynamic members
			set this.m_unit = null
			set this.m_targetRect = null
			// members
			call this.destroyStartTrigger()
			call this.destroyEndTrigger()
			// static members
			call thistype.m_routinePeriods.remove(this)
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.m_routinePeriods = AIntegerList.create()
		endmethod

		public static method routinePeriods takes nothing returns AIntegerList
			return thistype.m_routinePeriods
		endmethod

		public static method enableCurrent takes unit whichUnit returns boolean
			local boolean result = thistype.hasCurrent(whichUnit)
			if (result) then
				call thistype.current(whichUnit).enable()
			endif
			return result
		endmethod

		public static method disableCurrent takes unit whichUnit returns boolean
			local boolean result = thistype.hasCurrent(whichUnit)
			if (result) then
				call thistype.current(whichUnit).disable()
			endif
			return result
		endmethod

		public static method hookPauseUnit takes unit whichUnit, boolean flag returns nothing
			local thistype this

			if (not thistype.hasCurrent(whichUnit)) then
				return
			endif

			set this = thistype.current(whichUnit)

			debug if (this == 0) then
				debug call thistype.staticPrint("Current routine unit data of unit " + GetUnitName(whichUnit) + " is 0.")
				debug return
			debug endif

			// pause
			if (flag) then

				if (this.isEnabled()) then
					call DisableTrigger(this.m_endTrigger)
					if (this.m_targetTrigger != null) then
						call DisableTrigger(this.m_targetTrigger)
					endif
				endif
			// unpause
			else
				if (this.isEnabled()) then
					if (this.isInTime()) then
						call this.resume()
					// not in time, run next!
					else
						call this.end() // run onEnd() and clear current
					endif
				endif

				if (not this.isInTime()) then
					call thistype.clearCurrent(this.unit())

					if (not thistype.hasNext(this.unit())) then
						return
					endif

					set this = thistype.next(whichUnit)

					if (this.isInTime()) then
						call this.start()
					endif
				endif
			endif
		endmethod

		public static method hookRemoveUnit takes unit whichUnit returns nothing
			if (thistype.hasCurrent(whichUnit)) then
				call thistype.clearCurrent(whichUnit)
			endif
			if (thistype.hasNext(whichUnit)) then
				call thistype.clearNext(whichUnit)
			endif
		endmethod

		/**
		 * \note hooks are run before the native funciton, so we can compare to old time of day
		 * \note This functions takes quite some performance by iterating through all existing periods which are stored in a global list therefore.
		 * \todo Maybe this behaviour should be optional.
		 */
		public static method hookSetFloatGameState takes fgamestate whichFloatGameState, real value returns nothing
			local AIntegerListIterator iterator = 0
			local AIntegerList toEndRoutines = 0
			local AIntegerList toStartRoutines = 0
			local real currentTime = 0.0
			local thistype period = 0
			if (whichFloatGameState == GAME_STATE_TIME_OF_DAY) then
				set currentTime = GetTimeOfDay()
				set toEndRoutines = AIntegerList.create()
				set toStartRoutines = AIntegerList.create()
				// do not compare currentTime and values, real type!
				//debug call Print("Hook for time of day with " + I2S(thistype.m_routinePeriods.size()) + " periods, new time " + R2S(value) + " and old time " + R2S(currentTime))
				set iterator = thistype.m_routinePeriods.begin()
				loop
					exitwhen (not iterator.isValid())
					set period = thistype(iterator.data())
					if (period.isEnabled()) then
						// is now in time but wasn't before
						if (not period.isCurrent() and period.isInSpecifiedTime(value) and not period.isInSpecifiedTime(currentTime)) then
							call toStartRoutines.pushBack(period)
						// was in time but isn't now
						elseif (period.isCurrent() and not period.isInSpecifiedTime(value) and period.isInSpecifiedTime(currentTime)) then
							call toEndRoutines.pushBack(period)
						endif
					endif
					call iterator.next()
				endloop
				call iterator.destroy()

				/*
				 * Now end first and then start other routines.
				 * Otherwise bugs may appear since a routine might be started and another one ended after that (enter and leave house bugs).
				 */
				set iterator = toEndRoutines.begin()
				loop
					exitwhen (not iterator.isValid())
					set period = thistype(iterator.data())
					//debug call Print("Ending routine period " + GetUnitName(period.unit()))
					call period.end()
					call iterator.next()
				endloop
				call iterator.destroy()

				set iterator = toStartRoutines.begin()
				loop
					exitwhen (not iterator.isValid())
					set period = thistype(iterator.data())
					//debug call Print("Starting routine period " + GetUnitName(thistype(iterator.data()).unit()))
					call period.start()
					call iterator.next()
				endloop
				call iterator.destroy()

				call toEndRoutines.destroy()
				call toStartRoutines.destroy()
			endif
		endmethod

		public static method hookSetTimeOfDay takes real timeOfDay returns nothing
			call thistype.hookSetFloatGameState(GAME_STATE_TIME_OF_DAY, timeOfDay)
		endmethod
	endstruct

	/**
	 * Whenever a unit is paused its current routine period is paused, as well.
	 * When it is unpaused again its next/current routine period is resumed.
	 */
	hook PauseUnit ARoutinePeriod.hookPauseUnit
	hook RemoveUnit ARoutinePeriod.hookRemoveUnit
	/// \todo Maybe this behaviour should be optional.
	hook SetFloatGameState ARoutinePeriod.hookSetFloatGameState
	/// \todo Has to be set separately, vJass limitation (see manual).
	/// "There are some limitations for now, if the native/bj function is called by another bj function, the hook does not work when that other bj function gets called."
	hook SetTimeOfDay ARoutinePeriod.hookSetTimeOfDay

	/**
	 * Call this function in loop routine actions of type \ref ARoutineAction to
	 * continue action, otherwise it will be stopped!
	 */
	function AContinueRoutineLoop takes ARoutinePeriod period, ARoutineAction routineAction returns nothing
		debug if (not period.routine().isLoop()) then
			debug call Print("Warning: Routine " + I2S(period.routine()) + " with routine data for unit " + GetUnitName(period.unit()) + " is not marked as loop (isLoop).")
		debug endif
		if (period.canContinue() and period.isInTime() and period.isCurrent()) then // NOTE isInTime() is not necessary since it should be ended automatically but if user changes time manually end will never be reached!
			call routineAction.execute(period)
		endif
		// otherwise cancel, routine loop action will be called automatically again when unit is unpaused and still in routine time
	endfunction

	/**
	 * \brief Extension to \ref ARoutinePeriod which allows easy access to all unit related routines.
	 * Besides it hooks \ref RemoveUnit() and cleans up all unit routines automatically when unit is being removed using \ref thistype.clean().
	 * \todo If \ref A_MAP is stable use \ref AIntegerMap instead of \ref AIntegerList for faster lookup performance.
	 * \sa ARoutine
	 * \sa ARoutinePeriod
	 */
	struct AUnitRoutine extends ARoutinePeriod
		private static constant integer hashTableKey = A_HASHTABLE_KEY_ROUTINES

		/**
		 * \return Returns list of \ref thistype instances. If unit \p whichUnit has no routines it returns 0.
		 * \note You should store the result instead of calling this method several times except you want to be sure if it has already been destroyed.
		 */
		public static method routines takes unit whichUnit returns AIntegerList
			return AIntegerList(AHashTable.global().handleInteger(whichUnit, thistype.hashTableKey))
		endmethod

		/**
		 * Enables all routine periods for unit \p whichUnit.
		 * \ref disableAll()
		 */
		public static method enableAll takes unit whichUnit returns nothing
			local AIntegerList list = thistype.routines(whichUnit)
			local AIntegerListIterator iterator
			if (list == 0) then
				return
			endif
			set iterator = list.begin()
			loop
				exitwhen (not iterator.isValid())
				call thistype(iterator.data()).enable()
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		/**
		 * Disables all routine periods for unit \p whichUnit.
		 * \ref enableAll()
		 */
		public static method disableAll takes unit whichUnit returns nothing
			local AIntegerList list = thistype.routines(whichUnit)
			local AIntegerListIterator iterator
			debug call Print("Routines count for unit " + GetUnitName(whichUnit) + ": " + I2S(list.size()))
			if (list == 0) then
				return
			endif
			set iterator = list.begin()
			loop
				exitwhen (not iterator.isValid())
				debug call Print("Disable routine: " + I2S(thistype(iterator.data())))
				call thistype(iterator.data()).disable()
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		private static method add takes unit whichUnit, thistype period returns nothing
			local AIntegerList list = thistype.routines(whichUnit)
			if (list == 0) then
				call AHashTable.global().setHandleInteger(whichUnit, thistype.hashTableKey, AIntegerList.createWithSize(1, period))
			else
				call list.pushBack(period)
			endif
		endmethod

		private static method remove takes unit whichUnit, thistype period returns nothing
			local AIntegerList list = thistype.routines(whichUnit)
			local AIntegerListIterator iterator
			if (list == 0) then
				return
			endif
			set iterator = list.begin()
			loop
				exitwhen (not iterator.isValid())
				if (thistype(iterator.data()) == period) then
					call list.erase(iterator).destroy() // destroy the resulting iterator to prevent leaks
					exitwhen (true)
				endif
				call iterator.next()
			endloop
			call iterator.destroy()
			if (list.empty()) then
				call list.destroy()
				call AHashTable.global().removeHandleInteger(whichUnit, thistype.hashTableKey)
			endif
		endmethod

		public stub method setUnit takes unit whichUnit returns nothing
			if (this.unit() == whichUnit) then
				return
			endif
			call thistype.remove(this.unit(), this)
			call super.setUnit(whichUnit)
			call thistype.add(whichUnit, this)
		endmethod

		public static method create takes ARoutine routine, unit whichUnit, real startTimeOfDay, real endTimeOfDay, rect targetRect returns thistype
			local thistype this = thistype.allocate(routine, whichUnit, startTimeOfDay, endTimeOfDay, targetRect)
			call thistype.add(whichUnit, this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call thistype.remove(this.unit(), this)
		endmethod

		/**
		 * Destroys all routine periods of unit \p whichUnit.
		 * \note Performance should be better than calling \ref destroy() for each period.
		 */
		public static method clean takes unit whichUnit returns nothing
			local AIntegerList list = thistype.routines(whichUnit)
			if (list == 0) then
				return
			endif
			loop
				exitwhen (list.empty())
				call thistype(list.back()).destroy()
				call list.popBack()
			endloop
			call list.destroy()
			call AHashTable.global().removeHandleInteger(whichUnit, thistype.hashTableKey)
		endmethod

		/**
		 * This method can be useful at the beginning of game when time hadn't become \ref EQUAL yet, to start current routines.
		 * \note It might take quite some performance since it has to check ALL available routine periods (multiple routine periods at the same time are allowed and will be started in order of appearance).
		 * \note Alternatively, events would have to be called other than on \ref EQUAL like \ref GREATER_THAN_OR_EQUAL with additional time checks which would be more expensive through the whole game.
		 */
		public static method manualStart takes unit whichUnit returns nothing
			local AIntegerList list = thistype.routines(whichUnit)
			local AIntegerListIterator iterator = 0
			local thistype unitRoutine = 0
			if (list == 0) then // (thistype.hasCurrent(whichUnit) and thistype.current(whichUnit).isInTime())
				return
			endif
			set iterator = list.begin()
			loop
				exitwhen (not iterator.isValid())
				set unitRoutine = thistype(iterator.data())
				if (unitRoutine.isInTime() and thistype.current(whichUnit) != unitRoutine) then // check if it's the current period already, as well to prevent multiple starts
					call unitRoutine.start()
				endif
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		/**
		 * Starts the routines manually for all created unit routines.
		 * This might be necessary in the beginning of the game since the time of day events might not have be called yet.
		 */
		public static method manualStartAll takes nothing returns nothing
			local AIntegerListIterator iterator = thistype.routinePeriods().begin()
			local ARoutinePeriod period = 0
			local thistype unitRoutine = 0
			loop
				exitwhen (not iterator.isValid())
				set period = ARoutinePeriod(iterator.data())
				if (period.getType() == AUnitRoutine.typeid) then
					set unitRoutine = AUnitRoutine(period)
					if (unitRoutine.isInTime() and thistype.current(unitRoutine.unit()) != unitRoutine) then // check if it's the current period already, as well to prevent multiple starts
						call unitRoutine.start()
					endif
				endif
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod
	endstruct

	/// Cleans up all unit routines automatically.
	hook RemoveUnit AUnitRoutine.clean

endlibrary