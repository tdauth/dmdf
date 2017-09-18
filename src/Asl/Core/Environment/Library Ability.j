/**
* \link http://www.wc3c.net/showthread.php?t=105279
* \author grim001
*/
library ALibraryCoreEnvironmentAbility initializer Init requires ALibraryCoreDebugMisc

	globals
		private constant integer PreloadUnitRawcode = 'zsmc'
		// This is the rawcode for "Sammy!". It is never used and has no model,
		// which makes an ideal preloading unit. Change it if you want to.
		private unit PreloadUnit
	endglobals

	/**
	* The main purpose of this function is to prevent the tiny lag of adding an ability to a unit the first time.
	* Therefore it is added to a dummy or ghost unit which is created at the beginning of the game.
	*/
	function AbilityPreload takes integer abilityid returns nothing
static if (DEBUG_MODE) then
		if (GetUnitTypeId(PreloadUnit) == 0) then
			call PrintFunctionError("AbilityPreload", "Can't preload an ability after initialization.")
			return
		endif
endif
		call UnitAddAbility(PreloadUnit, abilityid)
static if (DEBUG_MODE) then
		if (GetUnitAbilityLevel(PreloadUnit, abilityid) == 0) then
			call PrintFunctionError("AbilityPreload", "Attempted to preload a non-existent ability.")
		endif
endif
	endfunction

	/**
	* \copydoc AbilityPreload
	* \p start The ability id which the preloading has to start with.
	* \p end The ability id which the preloading has to end with.
	* \note start has not to be smaller than end.
	*/
	function AbilityRangePreload takes integer start, integer end returns nothing
		local integer i = 1
static if (DEBUG_MODE) then
		if (GetUnitTypeId(PreloadUnit) == 0) then
			call PrintFunctionError("AbilityPreload", "Can't preload an ability after initialization")
			return
		endif
endif
		if (start > end) then
			set i = -1
		endif
		loop
			call UnitAddAbility(PreloadUnit, start)
			exitwhen (start == end)
			set start = start + i
		endloop
	endfunction

	private function Init takes nothing returns nothing
		set PreloadUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), PreloadUnitRawcode, 0., 0., 0.)
		call UnitApplyTimedLife(PreloadUnit, 0, .001)
		call ShowUnit(PreloadUnit, false)
		call UnitAddAbility(PreloadUnit, 'Aloc')
	endfunction

endlibrary