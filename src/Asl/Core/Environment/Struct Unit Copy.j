library AStructCoreEnvironmentUnitCopy requires optional ALibraryCoreDebugMisc, ALibraryCoreEnvironmentUnit, ALibraryCoreGeneralUnit, AStructCoreGeneralHashTable

	/**
	 * \brief Unit copies can be used to create copies of units which will be refreshed automatically after starting it.
	 * The user can specify which properties should be copied and which not or alternatively overwrite method \ref AUnitCopy.onCopy() in his derived structure.
	 * \note Does not copy unit's location automatically since this doesn't mostly make sense.
	 * \sa AHeroIcon
	 */
	struct AUnitCopy
		// dynamic members
		private boolean m_copyVisibility
		private boolean m_copyPause
		private boolean m_copyVulnerbility
		private boolean m_copyDeath
		// construction members
		private unit m_unit
		private real m_refreshTime
		// members
		private unit m_unitCopy
		private timer m_refreshTimer
		private boolean m_isPaused

		//! runtextmacro A_STRUCT_DEBUG("\"AUnitCopy\"")

		// dynamic members

		public method setCopyVisibility takes boolean copyVisibility returns nothing
			set this.m_copyVisibility = copyVisibility
		endmethod

		public method copyVisibility takes nothing returns boolean
			return this.m_copyVisibility
		endmethod

		public method setCopyPause takes boolean copyPause returns nothing
			set this.m_copyPause = copyPause
		endmethod

		public method copyPause takes nothing returns boolean
			return this.m_copyPause
		endmethod

		public method setCopyVulnerbility takes boolean copyVulnerbility returns nothing
			set this.m_copyVulnerbility = copyVulnerbility
		endmethod

		public method copyVulnerbility takes nothing returns boolean
			return this.m_copyVulnerbility
		endmethod

		public method setCopyDeath takes boolean copyDeath returns nothing
			set this.m_copyDeath = copyDeath
		endmethod

		public method copyDeath takes nothing returns boolean
			return this.m_copyDeath
		endmethod

		// construction members

		/**
		 * \return Returns the original unit which is copied.
		 */
		public method unit takes nothing returns unit
			return this.m_unit
		endmethod


		/**
		 * \return Returns the unit copy's refresh time. This is the time interval in which the unit copy is refreshed.
		 * You set this value when creating the unit copy. It's not dynamic.
		 */
		public method refreshTime takes nothing returns real
			return this.m_refreshTime
		endmethod

		// members

		/**
		 * \return Returns the copy of the original unit. Usually you shouldn't modify this unit.
		 * Should only be used in your custom onCopy method (\todo Should be protected, vJass limit).
		 */
		public method unitCopy takes nothing returns unit
			return this.m_unitCopy
		endmethod

		/**
		 * \return Returns true if the unit copy's refreshment is paused at the moment.
		 * \sa pause()
		 * \sa resume()
		 * \sa isEnabled()
		 */
		public method isPaused takes nothing returns boolean
			return this.m_isPaused
		endmethod

		// methods

		/**
		 * The unit copy doesn't react on state events since there aren't events for all required states (such as hero attributes).
		 * Therefore it is refreshed all x seconds where x is value of \ref refreshTime() which is set on unit copy's creation.
		 * For refreshing all necessary attributes this method is called.
		 * Since it is stub you can overwrite it in your derived structure and change attributes treatment.
		 */
		public stub method onCopy takes nothing returns nothing
			/// \todo Copy revival?
			if (this.copyDeath()) then
				call SetUnitState(this.unitCopy(), UNIT_STATE_MAX_LIFE, GetUnitState(this.unit(), UNIT_STATE_MAX_LIFE))
				call SetUnitState(this.unitCopy(), UNIT_STATE_LIFE, GetUnitState(this.unit(), UNIT_STATE_LIFE))
			else
				call SetUnitState(this.unitCopy(), UNIT_STATE_MAX_LIFE, RMaxBJ(GetUnitState(this.unit(), UNIT_STATE_MAX_LIFE), 1.0))
				call SetUnitState(this.unitCopy(), UNIT_STATE_LIFE, RMaxBJ(GetUnitState(this.unit(), UNIT_STATE_LIFE), 1.0))
			endif
			call SetUnitState(this.unitCopy(), UNIT_STATE_MAX_MANA, GetUnitState(this.unit(), UNIT_STATE_MAX_MANA))
			call SetUnitState(this.unitCopy(), UNIT_STATE_MANA, GetUnitState(this.unit(), UNIT_STATE_MANA))
			// sometimes you'll change unit type in derived structures, so it can differ from original one, also prevents from crashes
			if (IsUnitType(this.unit(), UNIT_TYPE_HERO) and IsUnitType(this.unitCopy(), UNIT_TYPE_HERO)) then
				call SetHeroLevel(this.unitCopy(), GetHeroLevel(this.unit()), false)
				call SuspendHeroXP(this.unitCopy(), false)
				call SetHeroXP(this.unitCopy(), GetHeroXP(this.unit()), false)
				call SuspendHeroXP(this.unitCopy(), true)
				call SetHeroStr(this.unitCopy(), GetHeroStr(this.unit(), false), true)
				call SetHeroStr(this.unitCopy(), GetHeroStrBonus(this.unit()), false)
				call SetHeroAgi(this.unitCopy(), GetHeroAgi(this.unit(), false), true)
				call SetHeroAgi(this.unitCopy(), GetHeroAgiBonus(this.unit()), false)
				call SetHeroInt(this.unitCopy(), GetHeroInt(this.unit(), false), true)
				call SetHeroInt(this.unitCopy(), GetHeroIntBonus(this.unit()), false)
				call UnitModifySkillPoints(this.unitCopy(), GetHeroSkillPoints(this.unit()) - GetHeroSkillPoints(this.unit()))
			endif
			if (this.m_copyVisibility) then
				call ShowUnit(this.unitCopy(), not IsUnitHidden(this.unit()))
			endif
			if (this.m_copyVulnerbility) then
				call SetUnitInvulnerable(this.unitCopy(), IsUnitInvulnerable(this.unit()))
			endif
			if (this.m_copyPause) then
				call PauseUnit(this.unitCopy(), IsUnitPaused(this.unit()))
			endif
		endmethod

		public method setX takes real x returns nothing
			call SetUnitX(this.unitCopy(), x)
		endmethod

		public method x takes nothing returns real
			return GetUnitX(this.unitCopy())
		endmethod

		public method setY takes real y returns nothing
			call SetUnitY(this.m_unitCopy, y)
		endmethod

		public method y takes nothing returns real
			return GetUnitY(this.m_unitCopy)
		endmethod

		public method setFacing takes real facing returns nothing
			call SetUnitFacing(this.m_unitCopy, facing)
		endmethod

		public method facing takes nothing returns real
			return GetUnitFacing(this.m_unitCopy)
		endmethod

		private static method timerFunctionRefresh takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetExpiredTimer(), 0)
			call this.onCopy.evaluate()
		endmethod

		/**
		 * Starts unit copy's refreshment.
		 * \note This method has to be called manually. Refreshment doesn't start automatically after creation.
		 */
		public method start takes nothing returns nothing
			call TimerStart(this.m_refreshTimer, this.m_refreshTime, true, function thistype.timerFunctionRefresh)
		endmethod

		/**
		 * Opposite of \ref isPaused().
		 */
		public method isEnabled takes nothing returns boolean
			return not this.isPaused()
		endmethod

		/**
		 * Resumes unit copy's refreshment.
		 * \sa pause()
		 * \sa enable()
		 */
		public method resume takes nothing returns nothing
			if (not this.isPaused()) then
				return
			endif
			call ResumeTimer(this.m_refreshTimer)
		endmethod

		/**
		 * Equal to \ref resume() but stub for overwriting.
		 */
		public stub method enable takes nothing returns nothing
			call this.resume()
		endmethod

		/**
		 * Pauses unit copy's refreshment.
		 * \sa resume()
		 * \sa disable()
		 */
		public method pause takes nothing returns nothing
			if (this.isPaused()) then
				return
			endif
			call PauseTimer(this.m_refreshTimer)
		endmethod

		/**
		 * Equal to \ref pause() but stub for overwriting.
		 */
		public stub method disable takes nothing returns nothing
			call this.pause()
		endmethod

		public method setEnabled takes boolean enabled returns nothing
			if (enabled) then
				call this.enable()
			else
				call this.disable()
			endif
		endmethod

		/**
		 * Creates a new unit copy.
		 * \param whichUnit Unit which the copy is created from.
		 * \param refreshTime Time interval (seconds) which is used for unit copy's refreshment.
		 * \param x X coordinate of unit copy's location.
		 * \param y Y coordinate of unit copy's location.
		 * \param facing Facing angle (degree) of unit copy.
		 * \return Returns a newly created unit copy instance.
		 * \note This doesn't start unit copy's refreshment. Call \ref start() to start and \ref resume() or \ref pause() to resume or to pause unit copy.
		 */
		public static method create takes unit whichUnit, real refreshTime, real x, real y, real facing returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_copyVisibility = true
			set this.m_copyPause = true
			set this.m_copyVulnerbility = true
			set this.m_copyDeath = true
			// construction members
			set this.m_unit = whichUnit
			set this.m_refreshTime = refreshTime
			// members
			set this.m_unitCopy = CopyUnit(whichUnit, x, y, facing, bj_UNIT_STATE_METHOD_MAXIMUM)
			// suspend XP since we want to copy the exact value
			if (IsUnitType(this.m_unitCopy, UNIT_TYPE_HERO)) then
				call SuspendHeroXP(this.m_unitCopy, true)
			endif
			set this.m_refreshTimer = CreateTimer()
			call AHashTable.global().setHandleInteger(this.m_refreshTimer, 0, this)
			set this.m_isPaused = false

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			if (not this.isPaused()) then
				call PauseTimer(this.m_refreshTimer)
			endif
			call AHashTable.global().destroyTimer(this.m_refreshTimer)
			set this.m_refreshTimer = null
			// construction members
			set this.m_unit = null
			// members
			call RemoveUnit(this.m_unitCopy)
			set this.m_unitCopy = null
		endmethod
	endstruct

endlibrary