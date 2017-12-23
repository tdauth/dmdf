library ALibraryCoreGeneralGame requires optional ALibraryCoreDebugMisc

	/**
	 * This function I (PandaMine) discovered myself (and with the help of Captain Griffen). Simply put, if your
	 * actually playing a game, it will return true HOWEVER if your viewing the game as a replay it
	 * will return false. The function has been tested in MultiPlayer and it now causes no desyncs
	 * (by tested I mean vigorously tested by IceFrog for like 3 months). There is only one
	 * downside, and that is the function uses up one pause.
	 *
	 * There might be a second version of the function that doesn't use up a pause (discovered by
	 * Strilanc) however there are a couple of issues with it
	 *
	 * How does it work?
	 * Simply put a replay is just a file that contains the inputs from the various players when
	 * playing a game. However when Wc3 views a replay, there are differences then if you were
	 * physically playing the game. One of the differences is pausing. If you are actually playing
	 * and you pause a game, it is paused. However during a replay, if you pause a game the replay
	 * simply finishes at the point you paused the game, if the game is resumed some time later then
	 * the replay completely skips the pause phase. There are only a few things that work in real
	 * time during pauses when your playing the game (anything else you do during the pause just
	 * gets 'suspended' until the game is resumed). The 2 things that work in real time are camera
	 * angles and trigger sleep action.
	 *
	 * The function works by moving the camera during the pause. If the camera is moved during the
	 * pause, then you are playing the actual game. If the camera isn't moved then it is the replay
	 * (since the pause phase is totally skipped)
	 *
	 * - It is HIGHLY recommended that you save the returning value of the function into a boolean
	 * variable i.e.
	 * set someboolean = IsInGame()
	 * So you only call the function once (since it takes up a pause)
	 * \author PandaMine, Captain Griffen
	 */
	function IsInGame takes nothing returns boolean
		local integer counter = 0
		local player localPlayer = GetLocalPlayer()
		local player user
		local real cameraX
		local real cameraY
		local real x
		local real y
		local boolean result
		loop
			exitwhen (counter == bj_MAX_PLAYERS)
			set user = Player(counter)
			if (localPlayer == user) then
				set cameraX = GetCameraTargetPositionX()
				set cameraY = GetCameraTargetPositionY()
			endif
			set user = null
			set counter = counter + 1
		endloop
		call PauseGame(true)
		call TriggerSleepAction(0)
		set counter = 0
		loop
			exitwhen (counter == bj_MAX_PLAYERS)
			set user = Player(counter)
			if (localPlayer == user) then
				call SetCameraPosition(cameraX + 1, cameraY + 1)
			endif
			set user = null
			set counter = counter + 1
		endloop
		call TriggerSleepAction(0)
		call PauseGame(false)
		set counter = 0
		loop
			exitwhen (counter == bj_MAX_PLAYERS)
			set user = Player(counter)
			if (localPlayer == user) then
				set x = GetCameraTargetPositionX()
				if x == cameraX + 1 then
					set result = true
				else
					set result = false
				endif
				call SetCameraPosition(cameraX, cameraY)
			endif
			set user = null
			set counter = counter + 1
		endloop
		return result
	endfunction

	/**
	 * With the new change to the function, it no longer needs to be synchronized however you should
	 * still initialize it like this because it has been reported that selecting units +
	 * triggersleepaction can cause desyncs
	 * \author PandaMine, Captain Griffen
	 */
	function IsInGameEx takes nothing returns boolean
		local boolean result
		call EnableUserControl(false)
		call TriggerSleepAction(.0)
		set result = IsInGame()
		call EnableUserControl(true)
		return result
	endfunction

	globals
		private trigger preventSaveTrigger
		private timer preventSaveTimer
		private dialog preventSaveDialog
	endglobals

	private function Exit takes nothing returns nothing
		call DialogDisplay(GetLocalPlayer(), preventSaveDialog, false)
	endfunction

	private function StopSave takes nothing returns nothing
		call DialogDisplay(GetLocalPlayer(), preventSaveDialog, true)
		call TimerStart(preventSaveTimer, 0.00, false, function Exit)
	endfunction

	/**
	 * Note that this shows and hides a dialog to all players.
	 * <a href="http://www.wc3c.net/showthread.php?p=1111606#post1111606">Wc3C.net thread</a>
	 * \author
	 * TriggerHappy187
	 * Tamino Dauth
	 */
	function PreventSave takes boolean prevent returns nothing
		if (prevent and preventSaveTrigger == null) then
			set preventSaveTrigger = CreateTrigger()
			call TriggerRegisterGameEvent(preventSaveTrigger, EVENT_GAME_SAVE)
			call TriggerAddAction(preventSaveTrigger, function StopSave)
			set preventSaveTimer = CreateTimer()
			set preventSaveDialog = DialogCreate()
		debug elseif (prevent and preventSaveTrigger != null) then
			debug call PrintFunctionError("PreventSave", "Saving is already prevented.")
		elseif (not prevent and preventSaveTrigger != null) then
			call DestroyTrigger(preventSaveTrigger)
			set preventSaveTrigger = null
			call DestroyTimer(preventSaveTimer)
			set preventSaveTimer = null
			call DialogDestroy(preventSaveDialog)
			set preventSaveDialog = null
		debug elseif (not prevent and preventSaveTrigger == null) then
			debug call PrintFunctionError("PreventSave", "Saving was not prevented.")
		endif
	endfunction

endlibrary