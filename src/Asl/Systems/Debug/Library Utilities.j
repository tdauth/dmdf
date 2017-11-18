/**
* This library provides some cheats only usable in debug mode to test your map.
* Cheat list:
* version - Displays ASL information.
* clear - Clears screen messages for cheating player.
* gold - Gives player gold or shows his current amount.
* lumber - Gives player lumber or shows his current amount.
* foodcap - Gives player foot capacity or shows his current amount.
* info - Shows some information about selected unit of cheating player.
* setlevel - Sets level for selected unit of cheating player.
* kill - Kills selected units of cheating player.
* copy - Copies selected units of cheating player.
* remove - Removes selected units of cheating player.
* giveall - Resets hit points, mana and all ability cooldowns of selected unit of cheating player.
* damage - Damages selected unit.
* xp - Adds experience to selected hero or shows experience information about selected unit.
* pathing - Enables unit's pathing.
* nopathing - Disables unit's pathing.
* order - Displays unit order information or issues unit order.
* timeofday - Suspends, continues, sets or shows current time of day.
* benchmarks - Shows all benchmarks.
* clearbenchmarks - Clears all benchmarks.
* display - Displays or hides \ref Print() calls.
* enable - Enables debug identifier(s).
* disable - Disables debug identifier(s) or shows all disabled.
* setdamage - Assigns damage to selected unit.
* rotate - Rotates camera for player.
* units - Shows all units.
* items - Shows all items.
* destructables - Shows all destructables.
* debugstring - Runs string debug.
* debugmultiboardbar - Runs multiboard bar debug.
* debuglist - Runs list debug.
* debugtd - Runs time of day debug.
* debugtimer - Runs timer debugging hook function.
* debugdesync - Runs desync test.
* debugbonusmod - Runs Bonus Mod test.
* debugbash - Tests ShowBashTextTagForPlayer().
* debugimage - Tests CreateImageForPlayer().
* debugnatives - Test if option A_DEBUG_NATIVES does work.
*/
library ALibrarySystemsDebugUtilities requires ALibraryCoreEnvironmentUnit, ALibraryCoreGeneralUnit, ALibraryCoreStringConversion, ALibraryCoreInterfaceSelection, AStructCoreDebugBenchmark, AStructCoreDebugCheat, AStructCoreStringFormat, ALibrarySystemsBonusModBonusMod, ALibraryCoreInterfaceTextTag, ALibraryCoreInterfaceImage, ATest

	private function help takes ACheat cheat returns nothing
		local player triggerPlayer = GetTriggerPlayer()
static if (DEBUG_MODE) then
		call Print("version")
		call Print("clear")
		call Print("gold <gold>")
		call Print("lumber <lumber>")
		call Print("foodcap <food capacity>")
		call Print("info")
		call Print("setlevel")
		call Print("kill")
		call Print("copy")
		call Print("remove")
		call Print("giveall")
		call Print("damage <damage>")
		call Print("xp <experience>")
		call Print("pathing")
		call Print("nopathing")
		call Print("order <order>")
		call Print("timeofday <stop/continue/time of day>")
		call Print("benchmarks")
		call Print("clearbenchmarks")
		call Print("display")
		call Print("enable <identifier>")
		call Print("disable <identifier>")
		call Print("setdamage <damage>")
		call Print("rotate <degrees>")
endif
static if (DEBUG_MODE and A_DEBUG_HANDLES) then
		call Print("units")
		call Print("items")
		call Print("destructables")
endif
static if (DEBUG_MODE) then
		call Print("debugstring")
		call Print("debugmultiboardbar")
		call Print("debuglist")
		call Print("debugtd")
endif
static if (DEBUG_MODE and A_DEBUG_NATIVES) then
		call Print("debugtimer")
endif
static if (DEBUG_MODE) then
		call Print("debugdesync")
		call Print("debugbonusmod")
		call Print("debugbash")
		call Print("debugimage")
		call Print("debugnatives")
endif
		set triggerPlayer = null
	endfunction

	private function showVersion takes ACheat cheat returns nothing
static if (DEBUG_MODE) then
		call Asl.showInformation()
endif
	endfunction

	private function clear takes ACheat cheat returns nothing
		local player triggerPlayer = GetTriggerPlayer()
		call ClearScreenMessagesForPlayer(triggerPlayer)
		set triggerPlayer = null
	endfunction

	private function playerState takes string playerStateName, player whichPlayer, integer amount, playerstate whichPlayerState returns nothing
		if (amount == -1) then
			debug call Print(Format(tr(A_TEXT_PLAYER_STATE_AMOUNT)).s(playerStateName).i(GetPlayerState(whichPlayer, whichPlayerState)).result())
		else
			// don't adjust which would add gathered gold
			call SetPlayerState(whichPlayer, whichPlayerState, GetPlayerState(whichPlayer, whichPlayerState) + amount)
			debug call Print(Format(tr(A_TEXT_PLAYER_STATE_ADDED)).i(amount).s(playerStateName).result())
		endif
	endfunction

	private function gold takes ACheat cheat returns nothing
		local string amountString = StringTrim(cheat.argument())
		local integer amount
		if (StringLength(amountString) == 0) then
			set amount = -1
		else
			set amount = S2I(amountString)
		endif
		debug call playerState(A_TEXT_PLAYER_STATE_GOLD, GetTriggerPlayer(), amount, PLAYER_STATE_RESOURCE_GOLD)
	endfunction

	private function lumber takes ACheat cheat returns nothing
		local string amountString = StringTrim(cheat.argument())
		local integer amount
		if (StringLength(amountString) == 0) then
			set amount = -1
		else
			set amount = S2I(amountString)
		endif
		debug call playerState(A_TEXT_PLAYER_STATE_LUMBER, GetTriggerPlayer(), amount, PLAYER_STATE_RESOURCE_LUMBER)
	endfunction

	private function foodcap takes ACheat cheat returns nothing
		local string amountString = StringTrim(cheat.argument())
		local integer amount
		if (StringLength(amountString) == 0) then
			set amount = -1
		else
			set amount = S2I(amountString)
		endif
		debug call playerState(A_TEXT_PLAYER_STATE_FOOD_CAP, GetTriggerPlayer(), amount, PLAYER_STATE_RESOURCE_FOOD_CAP)
	endfunction

	/// \todo Add some information.
	private function info takes ACheat cheat returns nothing
		local player triggerPlayer = GetTriggerPlayer()
		local unit selectedUnit = GetFirstSelectedUnitOfPlayer(triggerPlayer)
		if (selectedUnit != null) then
static if (DEBUG_MODE) then
			call Print(Format(A_TEXT_UNIT_NAME).s(GetUnitName(selectedUnit)).result())
			call Print(Format(A_TEXT_UNIT_POSITION).r(GetUnitX(selectedUnit)).r(GetUnitY(selectedUnit)).result())
			call Print(Format(A_TEXT_UNIT_LEVEL).i(GetUnitLevel(selectedUnit)).result())
			call Print(Format(A_TEXT_UNIT_ACQUIRE_RANGE).r(GetUnitAcquireRange(selectedUnit)).result())
			call Print(Format(A_TEXT_UNIT_CURRENT_ORDER).i(GetUnitCurrentOrder(selectedUnit)).result())
endif
			if (IsUnitType(selectedUnit, UNIT_TYPE_HERO)) then
static if (DEBUG_MODE) then
				call Print(A_TEXT_HERO_DATA)
				call Print(Format(A_TEXT_HERO_LEVEL).i(GetHeroLevel(selectedUnit)).result())
				call Print(Format(A_TEXT_HERO_XP_PART).i(GetHeroXP(selectedUnit)).i(GetHeroLevelMaxXP(GetHeroLevel(selectedUnit))).result())
				call Print(Format(A_TEXT_HERO_SKILL_POINTS).i(GetHeroSkillPoints(selectedUnit)).result())
				call Print(Format(A_TEXT_HERO_STRENGTH).i(GetHeroStr(selectedUnit, false)).i(GetHeroStrBonus(selectedUnit)).result())
				call Print(Format(A_TEXT_HERO_AGILITY).i(GetHeroAgi(selectedUnit, false)).i(GetHeroAgiBonus(selectedUnit)).result())
				call Print(Format(A_TEXT_HERO_INTELLIGENCE).i(GetHeroInt(selectedUnit, false)).i(GetHeroIntBonus(selectedUnit)).result())
endif
			endif
			set selectedUnit = null
		endif
		set triggerPlayer = null
	endfunction

	private function setlevel takes ACheat cheat returns nothing
		local player triggerPlayer = GetTriggerPlayer()
		local string message = GetEventPlayerChatString()
		local unit hero = GetFirstSelectedUnitOfPlayer(triggerPlayer)
		local integer level
		local boolean suspend
		if (hero != null) then
			if (IsUnitType(hero, UNIT_TYPE_HERO)) then
				set level = S2I(StringTrim(cheat.argument()))
				set suspend = IsSuspendedXP(hero)
				if (suspend) then
					call SuspendHeroXP(hero, false)
				endif
				call SetHeroLevelBJ(hero, level, true)
				if (suspend) then
					call SuspendHeroXP(hero, true)
				endif
				debug call Print(Format(A_TEXT_SET_LEVEL).i(level).result())
			debug else
				debug call Print(A_TEXT_NO_HERO)
			endif
			set hero = null
		endif
		set triggerPlayer = null
	endfunction

	private function KillUnitFunction takes nothing returns nothing
		debug call Print(Format(A_TEXT_KILL_UNIT).u(GetEnumUnit()).result())
		call KillUnit(GetEnumUnit())
	endfunction

	/// \todo If no unit is selected, kill an item or a destructable
	private function kill takes ACheat cheat returns nothing
		local player triggerPlayer = GetTriggerPlayer()
		local group selectedUnits = GetUnitsSelectedAll(triggerPlayer)
		call ForGroup(selectedUnits, function KillUnitFunction)
		call DestroyGroup(selectedUnits)
		set selectedUnits = null
		set triggerPlayer = null
	endfunction

	private function CopyUnitFunction takes nothing returns nothing
		debug call Print(Format(A_TEXT_COPY_UNIT).u(GetEnumUnit()).result())
		call CopyUnit(GetEnumUnit(), GetUnitX(GetEnumUnit()), GetUnitY(GetEnumUnit()), GetUnitFacing(GetEnumUnit()), bj_UNIT_STATE_METHOD_ABSOLUTE)
	endfunction

	private function copy takes ACheat cheat returns nothing
		local player triggerPlayer = GetTriggerPlayer()
		local group selectedUnits = GetUnitsSelectedAll(triggerPlayer)
		call ForGroup(selectedUnits, function CopyUnitFunction)
		call DestroyGroup(selectedUnits)
		set selectedUnits = null
		set triggerPlayer = null
	endfunction

	private function RemoveUnitFunction takes nothing returns nothing
		debug call Print(Format(A_TEXT_REMOVE_UNIT).u(GetEnumUnit()).result())
		call RemoveUnit(GetEnumUnit())
	endfunction

	private function remove takes ACheat cheat returns nothing
		local player triggerPlayer = GetTriggerPlayer()
		local group selectedUnits = GetUnitsSelectedAll(triggerPlayer)
		call ForGroup(selectedUnits, function RemoveUnitFunction)
		call DestroyGroup(selectedUnits)
		set selectedUnits = null
		set triggerPlayer = null
	endfunction

	private function giveall takes ACheat cheat returns nothing
		local player triggerPlayer = GetTriggerPlayer()
		local unit selectedUnit = GetFirstSelectedUnitOfPlayer(triggerPlayer)
		if (selectedUnit != null) then
			call SetUnitLifePercentBJ(selectedUnit, 100.0)
			call SetUnitManaPercentBJ(selectedUnit, 100.0)
			call UnitResetCooldown(selectedUnit)
			debug call Print(tr("Gave all."))
			set selectedUnit = null
		endif
		set triggerPlayer = null
	endfunction

	private function damage takes ACheat cheat returns nothing
		local player triggerPlayer = GetTriggerPlayer()
		local unit selectedUnit = GetFirstSelectedUnitOfPlayer(triggerPlayer)
		local real damageAmount
		if (selectedUnit != null) then
			set damageAmount = S2R(StringTrim(cheat.argument()))
			debug call Print("Damage amount is " + R2S(damageAmount) + ".")
			if (damageAmount > 0.0) then
				call UnitDamageTargetBJ(selectedUnit, selectedUnit, damageAmount, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
			endif
			set selectedUnit = null
		else
			debug call Print(A_TEXT_EMPTY_SELECTION)
		endif
		set triggerPlayer = null
	endfunction

	private function xp takes ACheat cheat returns nothing
		local player triggerPlayer = GetTriggerPlayer()
		local unit selectedUnit = GetFirstSelectedUnitOfPlayer(triggerPlayer)
		local integer experience
		local boolean suspend
		if (selectedUnit != null) then
			set experience = S2I(StringTrim(cheat.argument()))
			if (experience != 0) then
				if (IsUnitType(selectedUnit, UNIT_TYPE_HERO)) then
					set suspend = IsSuspendedXP(selectedUnit)
					if (suspend) then
						call SuspendHeroXP(selectedUnit, false)
					endif
					call AddHeroXP(selectedUnit, experience, true)
					if (suspend) then
						call SuspendHeroXP(selectedUnit, true)
					endif
					debug call Print(Format(A_TEXT_ADDED_XP).i(experience).result())
				else
					debug call Print(A_TEXT_NO_HERO)
				endif
			elseif (IsUnitType(selectedUnit, UNIT_TYPE_HERO)) then
				debug call Print(Format(A_TEXT_HERO_XP_PART).i(GetHeroXP(selectedUnit)).i(GetHeroLevelMaxXP(GetHeroLevel(selectedUnit))).result())
				debug call Print(Format(A_TEXT_UNIT_XP).i(GetUnitXP(selectedUnit)).result())
			else
				debug call Print(Format(A_TEXT_UNIT_XP).i(GetUnitXP(selectedUnit)).result())
			endif
			set selectedUnit = null
		endif
		set triggerPlayer = null
	endfunction

	private function pathing takes ACheat cheat returns nothing
		local player triggerPlayer = GetTriggerPlayer()
		local unit selectedUnit = GetFirstSelectedUnitOfPlayer(triggerPlayer)
		if (selectedUnit != null) then
			call SetUnitPathing(selectedUnit, true)
			debug call Print(A_TEXT_UNIT_PATHING_ENABLE)
			set selectedUnit = null
		endif
		set triggerPlayer = null
	endfunction

	private function nopathing takes ACheat cheat returns nothing
		local player triggerPlayer = GetTriggerPlayer()
		local unit selectedUnit = GetFirstSelectedUnitOfPlayer(triggerPlayer)
		if (selectedUnit != null) then
			call SetUnitPathing(selectedUnit, false)
			debug call Print(A_TEXT_UNIT_PATHING_DISABLE)
			set selectedUnit = null
		endif
		set triggerPlayer = null
	endfunction

	private function order takes ACheat cheat returns nothing
		local unit selectedUnit = GetFirstSelectedUnitOfPlayer(GetTriggerPlayer())
		local string orderString
		if (selectedUnit != null) then
			set orderString = StringTrim(cheat.argument())
			if (orderString == null) then
				debug call Print(Format(A_TEXT_ORDER).s(GetUnitName(selectedUnit)).s(OrderId2String(GetUnitCurrentOrder(selectedUnit))).result())
			elseif (IsStringAlphabetical(orderString)) then
				debug call Print(Format(A_TEXT_ORDER).s(GetUnitName(selectedUnit)).s(orderString).result())
				call IssueImmediateOrder(selectedUnit, orderString)
			else
				debug call Print(Format(A_TEXT_ORDER).s(GetUnitName(selectedUnit)).s(OrderId2String(GetUnitCurrentOrder(selectedUnit))).result())
				call IssueImmediateOrderById(selectedUnit, S2I(orderString))
			endif
		else
			debug call Print(A_TEXT_EMPTY_SELECTION)
		endif
	endfunction

	private function timeofday takes ACheat cheat returns nothing
		local string argument = StringTrim(cheat.argument())
		if (StringLength(argument) > 0) then
			if (argument == "stop") then
				call SuspendTimeOfDay(true)
			elseif (argument == "continue") then
				call SuspendTimeOfDay(false)
			else
				debug call Print("This is the real value: " + R2S(S2R(argument)))
				call SetTimeOfDay(S2R(argument))
				debug call Print(Format(A_TEXT_TIME_OF_DAY_SET_TIME).s(argument).result())
			endif
		else
			debug call Print(Format(A_TEXT_TIME_OF_DAY).s(GetTimeOfDayString()).result())
		endif
	endfunction

	private function benchmarks takes ACheat cheat returns nothing
		debug call Print(A_TEXT_SHOW_BENCHMARKS)
		call ABenchmark.showBenchmarks()
	endfunction

	private function clearbenchmarks takes ACheat cheat returns nothing
		debug call Print(A_TEXT_CLEAR_BENCHMARKS)
		call ABenchmark.clearAll()
	endfunction

	private function display takes ACheat cheat returns nothing
static if (DEBUG_MODE) then
		set ADisplayPrint = not ADisplayPrint
		// NOTE don't use Print itself ;)
		if (ADisplayPrint) then
			call BJDebugMsg(A_TEXT_DISPLAY_ENABLE)
		else
			call BJDebugMsg(A_TEXT_DISPLAY_DISABLE)
		endif
endif
	endfunction

	private function enable takes ACheat cheat returns nothing
static if (DEBUG_MODE) then
		local string identifier = StringTrim(cheat.argument())
		if (StringLength(identifier) == 0) then
			call Print(A_TEXT_ENABLE_IDENTIFIERS)
			call EnableAllPrintIdentifiers()
		elseif (IsPrintIdentifierDisabled(identifier)) then
			call Print(Format(A_TEXT_ENABLE_IDENTIFIER).s(identifier).result())
			call EnablePrintIdentifier(identifier)
		else
			call Print(Format(A_TEXT_ENABLE_IDENTIFIER_ERROR).s(identifier).result())
		endif
endif
	endfunction

	private function disable takes ACheat cheat returns nothing
static if (DEBUG_MODE) then
		local string identifier = StringTrim(cheat.argument())
		if (StringLength(identifier) == 0) then
			call PrintDisabledIdentifiers()
		elseif (IsPrintIdentifierEnabled(identifier)) then
			call Print(Format(A_TEXT_DISABLE_IDENTIFIER).s(identifier).result())
			call DisablePrintIdentifier(identifier)
		else
			call Print(Format(A_TEXT_DISABLE_IDENTIFIER_ERROR).s(identifier).result())
		endif
endif
	endfunction

	private function setdamage takes ACheat cheat returns nothing
		local string argument = StringTrim(cheat.argument())
		local unit selectedUnit = GetFirstSelectedUnitOfPlayer(GetTriggerPlayer())
		local integer dmg
		if (selectedUnit != null) then
			if (StringLength(argument) == 0) then
				call AUnitSetBonus(selectedUnit, A_BONUS_TYPE_DAMAGE, 0)
				debug call Print(Format(A_TEXT_SET_DAMAGE).i(0).result())
			else
				set dmg = S2I(argument)
				call AUnitSetBonus(selectedUnit, A_BONUS_TYPE_DAMAGE, dmg)
				debug call Print(Format(A_TEXT_SET_DAMAGE).i(dmg).result())
			endif
		else
			debug call Print(A_TEXT_EMPTY_SELECTION)
		endif
	endfunction

	private function rotate takes ACheat cheat returns nothing
		local string argument = StringTrim(cheat.argument())
		local real degrees = S2R(argument)
		if (StringLength(argument) == 0) then
			set degrees = GetCameraField(CAMERA_FIELD_ROTATION) * bj_RADTODEG + 90.0
			debug call Print("Current degrees: " + R2S(GetCameraField(CAMERA_FIELD_ROTATION) * bj_RADTODEG))
			debug call Print("New degrees: " + R2S(degrees))
			if (degrees > 360.0) then
				set degrees = 90.0
			endif
			debug call Print("Real new degrees: " + R2S(degrees))
		else
			set degrees = S2R(argument)
			debug call Print("New degrees: " + R2S(degrees))
		endif
		debug call Print("New degrees in rad: " + R2S(bj_DEGTORAD * degrees))
		call SetCameraFieldForPlayer(GetTriggerPlayer(), CAMERA_FIELD_ROTATION,  bj_DEGTORAD * degrees, 0.0)
	endfunction

static if (A_DEBUG_HANDLES) then
	private function units takes ACheat cheat returns nothing
		call ABenchmark.showUnits()
	endfunction

	private function items takes ACheat cheat returns nothing
		call ABenchmark.showItems()
	endfunction

	private function destructables takes ACheat cheat returns nothing
		call ABenchmark.showDestructables()
	endfunction

	private function timers takes ACheat cheat returns nothing
		call ABenchmark.showTimers()
	endfunction
endif

static if (DEBUG_MODE) then
	private function stringDebug takes ACheat cheat returns nothing
		debug call Print("string debug cheat")
		call AStringConversionDebug()
		call AStringMiscDebug()
		call AStringPoolDebug()
	endfunction

	private function multiboardbarDebug takes ACheat cheat returns nothing
		call AMultiboardBarDebug()
	endfunction

	private function listDebug takes ACheat cheat returns nothing
		call AListDebug()
	endfunction

	private function timeofdayDebug takes ACheat cheat returns nothing
		call ATimeOfDayDebug()
	endfunction
endif

static if (DEBUG_MODE and A_DEBUG_NATIVES) then
	private function timerDebug takes ACheat cheat returns nothing
		local timer whichTimer = CreateTimer()
		call TimerStart(whichTimer, 20.0, false, null)
		call DestroyTimer(whichTimer) // destroy running timer, should be paused
		set whichTimer = null
	endfunction
endif

static if (DEBUG_MODE) then
	private function desyncDebug takes ACheat cheat returns nothing
		call ADesyncDebug()
	endfunction

	private function bonusModDebug takes ACheat cheat returns nothing
		call ABonusModDebug()
	endfunction

	private function bashDebug takes ACheat cheat returns nothing
		call ShowBashTextTagForPlayer(GetTriggerPlayer(), GetCameraTargetPositionX(), GetCameraTargetPositionY(), 10)
	endfunction

	private function imageDebug takes ACheat cheat returns nothing
		call CreateImageForPlayer(Player(0), "Textures\\BackGround.blp", GetCameraTargetPositionX(), GetCameraTargetPositionY(), 0.0, 40.0, 40.0, true)
	endfunction

	private function nativesDebug takes ACheat cheat returns nothing
		call ANativesDebug()
	endfunction
endif

	function AInitUtilityCheats takes nothing returns nothing
static if (DEBUG_MODE) then
		call ACheat.create("help", true, help)
		call ACheat.create("version", true, showVersion)
		call ACheat.create("clear", true, clear)
		call ACheat.create("gold", false, gold)
		call ACheat.create("lumber", false, lumber)
		call ACheat.create("foodcap", false, foodcap)
		call ACheat.create("info", true, info)
		call ACheat.create("setlevel", false, setlevel)
		call ACheat.create("kill", true, kill)
		call ACheat.create("copy", true, copy)
		call ACheat.create("remove", true, remove)
		call ACheat.create("giveall", true, giveall)
		call ACheat.create("damage", false, damage)
		call ACheat.create("xp", false, xp)
		call ACheat.create("pathing", true, pathing)
		call ACheat.create("nopathing", true, nopathing)
		call ACheat.create("order", false, order)
		call ACheat.create("timeofday", false, timeofday)
		call ACheat.create("benchmarks", true, benchmarks)
		call ACheat.create("clearbenchmarks", true, clearbenchmarks)
		call ACheat.create("display", true, display)
		call ACheat.create("enable", false, enable)
		call ACheat.create("disable", false, disable)
		call ACheat.create("setdamage", false, setdamage)
		call ACheat.create("rotate", false, rotate)
endif

static if (A_DEBUG_HANDLES) then
		call ACheat.create("units", true, units)
		call ACheat.create("items", true, items)
		call ACheat.create("destructables", true, destructables)
		call ACheat.create("timers", true, timers)
endif

static if (DEBUG_MODE) then
		call ACheat.create("debugstring", true, stringDebug)
		call ACheat.create("debugmultiboardbar", true, multiboardbarDebug)
		call ACheat.create("debuglist", true, listDebug)
		call ACheat.create("debugtd", true, timeofdayDebug)
endif

static if (DEBUG_MODE and A_DEBUG_NATIVES) then
		call ACheat.create("debugtimer", true, timerDebug)
endif

static if (DEBUG_MODE) then
		call ACheat.create("debugdesync", true, desyncDebug)
		call ACheat.create("debugbonusmod", true, bonusModDebug)
		call ACheat.create("debugbash", true, bashDebug)
		call ACheat.create("debugimage", true, imageDebug)
		call ACheat.create("debugnatives", true, nativesDebug)
endif

	endfunction

endlibrary