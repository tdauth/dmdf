library ALibraryTestTimeOfDayTimeOfDay requires ALibraryCoreDebugMisc, AStructCoreDebugBenchmark, ALibraryCoreEnvironmentTimeOfDay, ALibraryCoreStringConversion

	/**
	 * Test for time of day functions.
	 */
	function ATimeOfDayDebug takes nothing returns nothing
static if (DEBUG_MODE) then
		call Print("Warcraft time of day: " + R2S(GetTimeOfDay()))
		call Print("Elapsed hours: " + I2S(GetTimeOfDayElapsedHours()))
		call Print("Minutes percentage: " + R2S(GetTimeOfDayMinutesPercentage()))
		call Print("Elapsed minutes in hour: " + I2S(GetTimeOfDayElapsedMinutesInHour()))
		call Print("Remaining hours of day: " + I2S(GetTimeOfDayRemainingHours()))
		call Print("Elapsed minutes: " + I2S(GetTimeOfDayElapsedMinutes()))
		call Print("Seconds percentage: " + R2S(GetTimeOfDaySecondsPercentage()))
		call Print("Elapsed seconds in minute: " + I2S(GetTimeOfDayElapsedSecondsInMinute()))
		call Print("Remaining minutes of day: " + I2S(GetTimeOfDayRemainingMinutes()))
		call Print("Elapsed seconds: " + I2S(GetTimeOfDayElapsedSeconds()))
		call Print("Remaining seconds of day: " + I2S(GetTimeOfDayRemainingSeconds()))
		call Print("Time of day string for whole day: " + GetTimeString(ADailySeconds))
		if (IsTimeOfDay(12.2343)) then
			call Print("First is time of day! Correct!")
		else
			call Print("First isn't time of day! Incorrect!")
		endif
		if (IsTimeOfDay(36.23)) then
			call Print("Second is time of day! Incorrect!")
		else
			call Print("Second isn't time of day! Correct!")
		endif
endif
	endfunction

endlibrary