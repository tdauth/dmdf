/**
 * These functions do only work with environment's default settings (24 hours per day, 60 minutes per hour)
 * \note \ref GetTimeOfDay() returns current hour and percentage of minutes/seconds of day.
 */
library ALibraryCoreEnvironmentTimeOfDay requires ALibraryCoreStringConversion

	function GetTimeOfDayElapsedHoursEx takes real timeOfDay returns integer
		return R2I(timeOfDay)
	endfunction

	function GetTimeOfDayElapsedHours takes nothing returns integer
		return GetTimeOfDayElapsedHoursEx(GetTimeOfDay())
	endfunction

	function GetTimeOfDayMinutesPercentageEx takes real timeOfDay returns real
		return 60.0 * (timeOfDay - I2R(GetTimeOfDayElapsedHoursEx(timeOfDay)))
	endfunction

	function GetTimeOfDayMinutesPercentage takes nothing returns real
		return GetTimeOfDayMinutesPercentageEx(GetTimeOfDay())
	endfunction

	function GetTimeOfDayElapsedMinutesInHourEx takes real timeOfDay returns integer
		return R2I(GetTimeOfDayMinutesPercentageEx(timeOfDay))
	endfunction

	function GetTimeOfDayElapsedMinutesInHour takes nothing returns integer
		return GetTimeOfDayElapsedMinutesInHourEx(GetTimeOfDay())
	endfunction

	function GetTimeOfDayRemainingHoursEx takes real timeOfDay returns integer
		return 24 - GetTimeOfDayElapsedHoursEx(timeOfDay)
	endfunction

	function GetTimeOfDayRemainingHours takes nothing returns integer
		return GetTimeOfDayRemainingHoursEx(GetTimeOfDay())
	endfunction

	globals
		constant integer ADailyMinutes = 1440 // 24 * 60
		constant integer ADailySeconds = 86400 // 24 * 60 * 60
	endglobals

	function GetTimeOfDayElapsedMinutesEx takes real timeOfDay returns integer
		return GetTimeOfDayElapsedHoursEx(timeOfDay) * 60 + GetTimeOfDayElapsedMinutesInHourEx(timeOfDay)
	endfunction

	function GetTimeOfDayElapsedMinutes takes nothing returns integer
		return GetTimeOfDayElapsedMinutesEx(GetTimeOfDay())
	endfunction

	function GetTimeOfDaySecondsPercentageEx takes real timeOfDay returns real
		return 60.0 * (GetTimeOfDayMinutesPercentageEx(timeOfDay) - I2R(GetTimeOfDayElapsedMinutesInHourEx(timeOfDay)))
	endfunction

	function GetTimeOfDaySecondsPercentage takes nothing returns real
		return GetTimeOfDaySecondsPercentageEx(GetTimeOfDay())
	endfunction

	function GetTimeOfDayElapsedSecondsInMinuteEx takes real timeOfDay returns integer
		return R2I(GetTimeOfDaySecondsPercentageEx(timeOfDay))
	endfunction

	function GetTimeOfDayElapsedSecondsInMinute takes nothing returns integer
		return GetTimeOfDayElapsedSecondsInMinuteEx(GetTimeOfDay())
	endfunction

	function GetTimeOfDayRemainingMinutesEx takes real timeOfDay returns integer
		return ADailyMinutes - GetTimeOfDayElapsedMinutesEx(timeOfDay)
	endfunction

	function GetTimeOfDayRemainingMinutes takes nothing returns integer
		return GetTimeOfDayRemainingMinutesEx(GetTimeOfDay())
	endfunction

	function GetTimeOfDayElapsedSecondsEx takes real timeOfDay returns integer
		return GetTimeOfDayElapsedMinutesEx(timeOfDay) * 60 + GetTimeOfDayElapsedSecondsInMinuteEx(timeOfDay)
	endfunction

	function GetTimeOfDayElapsedSeconds takes nothing returns integer
		return GetTimeOfDayElapsedSecondsEx(GetTimeOfDay())
	endfunction

	function GetTimeOfDayRemainingSecondsEx takes real timeOfDay returns integer
		return ADailySeconds - GetTimeOfDayElapsedSecondsEx(timeOfDay)
	endfunction

	function GetTimeOfDayRemainingSeconds takes nothing returns integer
		return GetTimeOfDayRemainingSecondsEx(GetTimeOfDay())
	endfunction

	function GetTimeOfDayStringEx takes real timeOfDay returns string
		return GetTimeString(GetTimeOfDayElapsedSecondsEx(timeOfDay))
	endfunction

	function GetTimeOfDayString takes nothing returns string
		return GetTimeOfDayStringEx(GetTimeOfDay())
	endfunction

	function IsTimeOfDay takes real timeOfDay returns boolean
		return timeOfDay >= 0.0 and timeOfDay <= 24.0
	endfunction

endlibrary