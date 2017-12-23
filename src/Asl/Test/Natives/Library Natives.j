library ALibraryTestNativesNatives requires ALibraryCoreDebugMisc

	function ANativesDebug takes nothing returns nothing
static if (A_DEBUG_NATIVES) then
		debug call Print("Debug natives is on!")
else
		debug call Print("Debug natives is off!")
endif
		call Player(100)
	endfunction

endlibrary