library AStructSystemsCharacterRevival requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, ALibraryCoreInterfaceMisc, AStructSystemsCharacterAbstractCharacterSystem

	/**
	 * \brief ARevival allows you to specify where and when a character is being revived.
	 * Bear in mind that revival works only for heroes not normal units.
	 * \ref setShowDialog() allows you to enable a timer dialog for all players.
	 * \ref setShowEffect() allows you to specify if the "eye candy" is shown on revival (\ref ReviveHero()).
	 * Use \ref setTime() and \ref setX(), \ref setY() and \ref setFacing() to specify the time and the place of the revival.
	 */
	struct ARevival extends AAbstractCharacterSystem
		// dynamic members
		private real m_time
		private real m_x
		private real m_y
		private real m_facing
		private boolean m_showEffect
		// members
		/**
		 * This trigger runs whenever the character dies and starts the automatic revival.
		 */
		private trigger m_deathTrigger
		/**
		 * This trigger cancels the timer plus timer dialog if the character has been revived somewhere else.
		 */
		private trigger m_revivalTrigger
		private timer m_timer
		private timerdialog m_timerDialog
		/**
		 * Boolean flag which indicates if the revival timer is running at the moment.
		 */
		private boolean m_runs

		//! runtextmacro optional A_STRUCT_DEBUG("\"ARevival\"")

		// dynamic members

		/**
		 * Sets the time a revival takes.
		 * \note This has no effect if the revival does already run.
		 */
		public method setTime takes real time returns nothing
			set this.m_time = time
		endmethod

		public method time takes nothing returns real
			return this.m_time
		endmethod

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

		public method setFacing takes real facing returns nothing
			set this.m_facing = facing
		endmethod

		public method facing takes nothing returns real
			return this.m_facing
		endmethod

		public method setShowEffect takes boolean showEffect returns nothing
			set this.m_showEffect = showEffect
		endmethod

		public method showEffect takes nothing returns boolean
			return this.m_showEffect
		endmethod

		public method showDialog takes nothing returns boolean
			return this.m_timerDialog != null
		endmethod

		public method setShowDialog takes boolean show returns nothing
			if (show == this.showDialog()) then
				return
			endif
			if (show) then
				set this.m_timerDialog = CreateTimerDialog(this.m_timer)
				call TimerDialogSetTitle(this.m_timerDialog, GetModifiedPlayerName(this.character().player()))
			else
				call DestroyTimerDialog(this.m_timerDialog)
				set this.m_timerDialog = null
			endif
		endmethod

		// methods

		public stub method enable takes nothing returns nothing
			call super.enable()
		endmethod

		/**
		 * This does not disable the revival at all since the revival is too important to be disabled at any time.
		 */
		public stub method disable takes nothing returns nothing
			call super.disable()
		endmethod
		
		/**
		 * Ends the revival without reviving the character.
		 * This should be used carefully for example whenever the character is revived manually.
		 */
		public method end takes nothing returns nothing
			call PauseTimer(this.m_timer) // stop for safety
			if (this.showDialog()) then
				call TimerDialogDisplay(this.m_timerDialog, false)
			endif
		endmethod

		/**
		 * Revives the character immediately at the given coordinates with the given facing.
		 */
		private method revive takes nothing returns nothing
			call ReviveHero(this.character().unit(), this.x(), this.y(), this.showEffect())
			call SetUnitFacing(this.character().unit(), this.facing())
			call this.character().onRevival.evaluate()
		endmethod

		private static method timerFunctionRevival takes nothing returns nothing
			local timer expiredTimer = GetExpiredTimer()
			local thistype this = AHashTable.global().handleInteger(expiredTimer, 0)
			set this.m_runs = false
			call this.revive()
			call this.end()
			set expiredTimer = null
		endmethod

		private method start takes nothing returns nothing
			call TimerStart(this.m_timer, this.m_time, false, function thistype.timerFunctionRevival)
			set this.m_runs = true
			if (this.showDialog()) then
				call TimerDialogDisplay(this.m_timerDialog, true)
			endif
		endmethod

		private method createTimer takes nothing returns nothing
			set this.m_timer = CreateTimer()
			call AHashTable.global().setHandleInteger(this.m_timer, 0, this)
		endmethod
		
		private static method triggerConditionIsCharacter takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return GetTriggerUnit() == this.character().unit()
		endmethod

		private static method triggerActionDeath takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			if (this.m_time > 0.0) then
				call this.start()
			else
				call this.revive()
			endif
		endmethod

		private method createDeathTrigger takes nothing returns nothing
			set this.m_deathTrigger = CreateTrigger()
			/*
			 * Use a generic event to make sure that the character is always revived even if another player took over or the unit changed.
			 */
			call TriggerRegisterAnyUnitEventBJ(this.m_deathTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(this.m_deathTrigger, Condition(function thistype.triggerConditionIsCharacter))
			call TriggerAddAction(this.m_deathTrigger, function thistype.triggerActionDeath)
			call AHashTable.global().setHandleInteger(this.m_deathTrigger, 0, this)
		endmethod
		
		private static method triggerActionRevival takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			if (this.m_runs) then
				debug call Print("Hero has been revived by something else.")
				call this.end()
			endif
		endmethod
		
		private method createRevivalTrigger takes nothing returns nothing
			set this.m_revivalTrigger = CreateTrigger()
			 call TriggerRegisterAnyUnitEventBJ(this.m_revivalTrigger, EVENT_PLAYER_HERO_REVIVE_FINISH)
			 call TriggerAddCondition(this.m_revivalTrigger, Condition(function thistype.triggerConditionIsCharacter))
			call TriggerAddAction(this.m_revivalTrigger, function thistype.triggerActionRevival)
			call AHashTable.global().setHandleInteger(this.m_revivalTrigger, 0, this)
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character)
			// dynamic members
			set this.m_time = 20.0
			set this.m_x = 0.0
			set this.m_y = 0.0
			set this.m_facing = 0.0
			set this.m_showEffect = true
			// members
			set this.m_runs = false

			call this.createTimer()
			call this.createDeathTrigger()
			call this.createRevivalTrigger()
			call this.setShowDialog(true) // default value
			return this
		endmethod

		private method destroyTimer takes nothing returns nothing
			call PauseTimer(this.m_timer)
			call AHashTable.global().destroyTimer(this.m_timer)
			set this.m_timer = null
		endmethod

		private method destroyDeathTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_deathTrigger)
			set this.m_deathTrigger = null
		endmethod
		
		private method destroyRevivalTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_revivalTrigger)
			set this.m_revivalTrigger = null
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.setShowDialog(false) // destroys dialog if necessary
			call this.destroyTimer()
			call this.destroyDeathTrigger()
			call this.destroyRevivalTrigger()
		endmethod
	endstruct

endlibrary