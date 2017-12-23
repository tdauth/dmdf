library ALibraryCoreDebugMisc initializer init requires ALibraryCoreGeneralPlayer, AStructCoreGeneralHashTable, AStructCoreGeneralList

	globals
		/// If this value is false nothing will be displayed on the screen when \ref Print() etc. is called.
		boolean ADisplayPrint = true
	endglobals

	/**
	 * Displays \p message on the screen visible for all playing users. Only available in debug mode.
	 * Using JassNewGenPack (war3err) this appends \p message to file "logs//war3erruser.txt", as well.
	 * \author Tamino Dauth
	 * \param message The message which will be shown on the screen and if Warcraft was started with war3err it appends it to file "logs//war3err.txt", as well.
	*/
static if (DEBUG_MODE) then
	function Print takes string message returns nothing
		local integer i
		local player user
		if (ADisplayPrint) then
			set i = 0
			loop
				exitwhen(i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (IsPlayerPlayingUser(user)) then
					call DisplayTimedTextToPlayer(user, 0.0, 0.0, 999999.0, message)
				endif
				set user = null
				set i = i + 1
			endloop
		endif
		call Cheat("DebugMsg: " + message) // war3err
	endfunction

	function PrintIf takes boolean condition, string message returns nothing
		if (condition) then
			call Print(message)
		endif
	endfunction

	globals
		private AStringList disabledPrintIdentifiers
	endglobals

	function EnablePrintIdentifier takes string identifier returns nothing
		call disabledPrintIdentifiers.remove(identifier)
	endfunction

	function DisablePrintIdentifier takes string identifier returns nothing
		if (disabledPrintIdentifiers.contains(identifier)) then
			return
		endif
		call disabledPrintIdentifiers.pushBack(identifier)
	endfunction

	function IsPrintIdentifierEnabled takes string identifier returns boolean
		return not disabledPrintIdentifiers.contains(identifier)
	endfunction

	function IsPrintIdentifierDisabled takes string identifier returns boolean
		return disabledPrintIdentifiers.contains(identifier)
	endfunction

	function SetPrintIdentifierEnabled takes string identifier, boolean enabled returns nothing
		if (enabled) then
			call EnablePrintIdentifier(identifier)
		else
			call DisablePrintIdentifier(identifier)
		endif
	endfunction

	function EnableAllPrintIdentifiers takes nothing returns nothing
		call disabledPrintIdentifiers.clear()
	endfunction

	function PrintDisabledIdentifiers takes nothing returns integer
		local AStringListIterator iterator = disabledPrintIdentifiers.begin()
		call Print("Disabled identifiers:")
		loop
			exitwhen (not iterator.isValid())
			call Print("- " + iterator.data())
			call iterator.next()
		endloop
		call iterator.destroy()
		call Print("Total: " + I2S(disabledPrintIdentifiers.size()))
		return disabledPrintIdentifiers.size()
	endfunction

	function PrintFunctionError takes string functionName, string message returns nothing
		if (IsPrintIdentifierDisabled(functionName)) then
			return
		endif
		call Print("Function error in function \"" + functionName + "\": " + message)
	endfunction

	function PrintFunctionErrorIf takes boolean condition, string functionName, string message returns boolean
		if (condition) then
			call PrintFunctionError(functionName, message)
		endif
		return condition
	endfunction

	/**
	 * Useful for getting the corresponding struct and instance where the message is sent from.
	 * Displays the string \p message in the following schema: "<structname> - <instanceid>: <message>"
	 * \author Tamino Dauth
	 */
	function PrintStructInstanceMessage takes string structName, integer instance, string message returns nothing
		if (IsPrintIdentifierDisabled(structName)) then
			return
		endif
		call Print(structName + " - " + I2S(instance) + ": " + message)
	endfunction

	function PrintStructInstanceMessageIf takes string structName, integer instance, boolean condition, string message returns boolean
		if (condition) then
			call PrintStructInstanceMessage(structName, instance, message)
		endif
		return condition
	endfunction

	function PrintMethodError takes string structName, integer instance, string methodName, string message returns nothing
		if (IsPrintIdentifierDisabled(structName) or IsPrintIdentifierDisabled(structName + "." + methodName)) then
			return
		endif
		call Print(structName + " - " + I2S(instance) + ": Method error in method \"" + methodName + "\": " + message)
	endfunction

	function PrintMethodErrorIf takes string structName, integer instance, boolean condition, string methodName, string message returns boolean
		if (condition) then
			call PrintMethodError(structName, instance, methodName, message)
		endif
		return condition
	endfunction

	function StaticPrint takes string structName, string message returns nothing
		if (IsPrintIdentifierDisabled(structName)) then
			return
		endif
		call Print(structName + ": " + message)
	endfunction

	function StaticPrintIf takes string structName, boolean condition, string message returns boolean
		if (condition) then
			call StaticPrint(structName, message)
		endif
		return condition
	endfunction

	function StaticPrintMethodError takes string structName, string methodName, string message returns nothing
		if (IsPrintIdentifierDisabled(structName) or IsPrintIdentifierDisabled(structName + "." + methodName)) then
			return
		endif
		call Print(structName + ": Method error in method \"" + methodName + "\": " + message)
	endfunction

	function StaticPrintMethodErrorIf takes string structName, boolean condition, string methodName, string message returns boolean
		if (condition) then
			call StaticPrintMethodError(structName, methodName, message)
		endif
		return condition
	endfunction
endif

	/**
	 * Allows to use various print methods in your custom struct.
	 * Should only be necessary in debug mode.
	 * Example:
	 * \code
	 * struct MyStruct
	 * static if (DEBUG_MODE) then
	 * 	//! runtextmacro A_STRUCT_DEBUG("\"MyStruct\"")
	 * endif
	 *
	 * 	public method myMethod takes nothing returns nothing
	 * 		debug call this.printMethodError("myMethod", "Test error") // only usable in debug mode
	 * 	endmethod
	 * endstruct
	 * \endcode
	 */
	//! textmacro A_STRUCT_DEBUG takes STRUCTNAME
static if (DEBUG_MODE) then
		/**
		 * \copydoc PrintStructInstanceMessage
		 */
		public method print takes string message returns nothing
			call PrintStructInstanceMessage($STRUCTNAME$, this, message)
		endmethod

		public method printIf takes boolean condition, string message returns boolean
			return PrintStructInstanceMessageIf($STRUCTNAME$, this, condition, message)
		endmethod

		public method printMethodError takes string methodName, string message returns nothing
			call PrintMethodError($STRUCTNAME$, this, methodName, message)
		endmethod

		public method printMethodErrorIf takes boolean condition, string methodName, string message returns boolean
			return PrintMethodErrorIf($STRUCTNAME$, this, condition, methodName, message)
		endmethod

		private static method staticPrint takes string message returns nothing
			call StaticPrint($STRUCTNAME$, message)
		endmethod

		private static method staticPrintIf takes boolean condition, string message returns boolean
			return StaticPrintIf($STRUCTNAME$, condition, message)
		endmethod

		private static method staticPrintMethodError takes string methodName, string message returns nothing
			call StaticPrintMethodError($STRUCTNAME$, methodName, message)
		endmethod

		private static method staticPrintMethodErrorIf takes boolean condition, string methodName, string message returns boolean
			return StaticPrintMethodErrorIf($STRUCTNAME$, condition, methodName, message)
		endmethod
endif
	//! endtextmacro

	/**
	 * DumpGlobalHT - prints the names and values of all global variables into file "logs//war3err.txt".
	 * \ingroup war3err
	 * \author Tamino Dauth
	 */
	function PrintGlobals takes nothing returns nothing
		call Cheat("war3err_DumpGlobalHT") // war3err
	endfunction

	/**
	 * DumpLocalHT - As \ref PrintGlobals() above, but for the local variables of the current scope.
	 * \ingroup war3err
	 * \author Tamino Dauth
	 */
	function PrintLocals takes nothing returns nothing
		call Cheat("war3err_DumpLocalHT") // war3err
	endfunction

	/**
	 * PauseTracer: If bytecode logging is enabled, this pauses recording.
	 * \ingroup war3err
	 * \author Tamino Dauth
	 */
	function PauseBytecodeLogging takes nothing returns nothing
		call Cheat("PauseTracer") // war3err
	endfunction

	/**
	 * ContinueTracer: If bytecode logging is enabled, this resumes recording.
	 * \ingroup war3err
	 * \author Tamino Dauth
	 */
	function ContinueBytecodeLogging takes nothing returns nothing
		call Cheat("ContinueTracer") // war3err
	endfunction

	/**
	 * When the breakpoint is reached Warcraft III is frozen.
	 * \ingroup war3err
	 * \author Tamino Dauth
	 */
	function Breakpoint takes nothing returns nothing
		call Cheat("war3err_Break") // war3err
	endfunction

	/// \ingroup nativedebug
	/// \todo Should be private, vJass bug.
	function DebugPlayer takes integer number returns nothing
		if (number < 0 or number >= bj_MAX_PLAYER_SLOTS) then
			debug call PrintFunctionError("Player", "Invalid parameter number, value " + I2S(number) + ". Setting number to 0 to avoid game crash.")
			//set number = 0
		endif
		//return Player(number)
	endfunction

	globals
		/// \todo Should be private, vJass bug.
		integer gameCacheCounter = 0
	endglobals

	/// \ingroup nativedebug
	/// \todo Should be private, vJass bug.
	function DebugInitGameCache takes string campaignFile returns nothing
		if (gameCacheCounter == 256) then
			debug call PrintFunctionError("InitGameCache", "Reached game cache maximum. Canceling function call.")
			//return null
		endif
		set gameCacheCounter = gameCacheCounter + 1
		//return InitGameCache(campaignFile)
	endfunction

	/// \ingroup nativedebug
	/// \todo Should be private, vJass bug.
	function DebugSetUnitX takes unit whichUnit, real newX returns nothing
		if (newX < GetRectMinX(bj_mapInitialPlayableArea) or newX > GetRectMaxX(bj_mapInitialPlayableArea)) then
			debug call PrintFunctionError("SetUnitX", "Invalid parameter newX, value " + R2S(newX) + ". Canceling function call to avoid game crash.")
			//return
		endif
	endfunction

	/// \ingroup nativedebug
	/// \todo Should be private, vJass bug.
	function DebugSetUnitY takes unit whichUnit, real newY returns nothing
		if (newY < GetRectMinY(bj_mapInitialPlayableArea) or newY > GetRectMaxY(bj_mapInitialPlayableArea)) then
			debug call PrintFunctionError("SetUnitY", "Invalid parameter newY, value " + R2S(newY) + ". Canceling function call to avoid game crash.")
			//return
		endif
	endfunction

	/// \ingroup nativedebug
	/// \todo Should be private, vJass bug.
	function DebugCreateUnit takes player id, integer unitid, real x, real y, real face returns nothing
		if (x < GetRectMinX(bj_mapInitialPlayableArea) or x > GetRectMaxX(bj_mapInitialPlayableArea) or y < GetRectMinY(bj_mapInitialPlayableArea) or y > GetRectMaxY(bj_mapInitialPlayableArea)) then
			debug call PrintFunctionError("CreateUnit", "Invalid parameter x or y, values " + R2S(x) + " and " + R2S(y) + ". Canceling function call to avoid game crash.")
			//return null
		endif
		//return CreateUnit(id, unitid, x, y, face)
	endfunction

	/// \ingroup nativedebug
	/// \todo Should be private, vJass bug.
	function DebugRestoreUnit takes gamecache cache, string missionKey, string key, player forWhichPlayer, real x, real y, real facing returns nothing
		if (not HaveStoredUnit(cache, missionKey, key)) then
			debug call PrintFunctionError("RestoreUnit", "Stored unit does not exist in game cache. Canceling function call to avoid game crash.")
			//return null
		endif
		//return RestoreUnit(cache, missionKey, key, forWhichPlayer, x, y, facing)
	endfunction

	/// \ingroup nativedebug
	/// \todo Should be private, vJass bug.
	function DebugSetImageRender takes image whichImage, boolean flag returns nothing
		debug call PrintFunctionError("SetImageRender", "Does not work, use SetImageRenderAlways instead.")
	endfunction

	/// \ingroup nativedebug
	function DebugShowInterface takes boolean flag, real fadeDuration returns nothing
		if (fadeDuration == 0.0 and flag) then
			debug call PrintFunctionError("ShowInterface", "Don't use 0.0 for fade duration when enabling flag since it will prevent unit portraits from working correctly.")
		endif
	endfunction

	function DebugTriggerSleepAction takes real time returns nothing
		if (time <= 0.0) then
			debug call PrintFunctionError("TriggerSleepAction", "Don't use 0.0. Minimum is around 0.02. Use 0-timers if you want to be more precise.")
		endif
	endfunction

/// \todo Seems to prevent map from being able to be started.
static if (DEBUG_MODE and A_DEBUG_NATIVES) then
	/// \ingroup nativedebug
	hook Player DebugPlayer
	/// \ingroup nativedebug
	hook InitGameCache DebugInitGameCache
	/// \ingroup nativedebug
	hook SetUnitX DebugSetUnitX
	/// \ingroup nativedebug
	hook SetUnitY DebugSetUnitY
	/// \ingroup nativedebug
	hook CreateUnit DebugCreateUnit
	/// \ingroup nativedebug
	hook RestoreUnit DebugRestoreUnit
	/// \ingroup nativedebug
	hook SetImageRender DebugSetImageRender
	/// \ingroup nativedebug
	hook ShowInterface DebugShowInterface
	/// \ingroup nativedebug
	hook TriggerSleepAction DebugTriggerSleepAction
endif

	//GroupEnumUnitsInRectCounted und GroupEnumUnitsInRangeCounted
	//- Die Funktionen GroupEnumUnitsInRectCounted und GroupEnumUnitsInRangeCounted können sich unterschiedlich verhalten, falls sie eine große Anzahl von Einheiten haben.
	//GetExpiredTimer
	//- GetExpiredTimer() kann einen Absturtz des Spiels verursachen, wenn es keinen Timer gibt.
	//Einheitengruppen – vom InWarcraft-Nutzer gexxo
	//- Werden Einheiten per RemoveUnit() aus dem Spiel entfernt und befinden sich bereits in einer Einheitengruppe, so kann es zu Fehlern kommen, da die erste Einheit der Gruppe nun immer null ist.

	private function init takes nothing returns nothing
static if (DEBUG_MODE) then
		set disabledPrintIdentifiers = AStringList.create()
endif
	endfunction

endlibrary
