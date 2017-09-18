library ALibraryCoreGeneralTimer requires AStructCoreGeneralHashTable

	/**
	 * Waits \p seconds game-time seconds (synchronous), checking condition \p condition by using \ref PolledWait polling method.
	 * \param condition If this condition becomes true, wait is canceled immediately and function returns true. Otherwise it returns false after wait has finished normally.
	 * \param hashTable If this value is not 0 hash table is attached to trigger handle (stored with key 0) usable for custom condition parameters.
	 * \sa PolledWait
	 */
	function WaitCheckingCondition takes real seconds, code condition, AHashTable hashTable returns boolean
		local timer whichTimer = CreateTimer()
		local trigger whichTrigger = CreateTrigger()
		local conditionfunc triggerCondition = Condition(condition)
		local boolean result = false
		call TriggerAddCondition(whichTrigger, triggerCondition)
		if (hashTable != 0) then
			call AHashTable.global().setHandleInteger(whichTrigger, 0, hashTable)
		endif
		call TimerStart(whichTimer, seconds, false, null)
		loop
			set seconds = TimerGetRemaining(whichTimer)
			exitwhen (seconds <= 0.0)
			if (TriggerEvaluate(whichTrigger)) then
				set result = true
				exitwhen (true)
			endif
			
			// If we have a bit of time left, skip past 10% of the remaining
			// duration instead of checking every interval, to minimize the
			// polling on long waits.
			if (seconds > bj_POLLED_WAIT_SKIP_THRESHOLD) then
				call TriggerSleepAction(0.1 * seconds)
			else
				call TriggerSleepAction(bj_POLLED_WAIT_INTERVAL)
			endif
		endloop
		call PauseTimer(whichTimer)
		call DestroyTimer(whichTimer)
		set whichTimer = null
		if (hashTable != 0) then
			call AHashTable.global().destroyTrigger(whichTrigger)
		else
			call DestroyTrigger(whichTrigger)
		endif
		set whichTrigger = null
		call DestroyCondition(triggerCondition)
		set triggerCondition = null
		return result
	endfunction
	
endlibrary