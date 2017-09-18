library ALibraryTestInterfaceMultiboardBar requires ALibraryCoreDebugMisc, AStructCoreInterfaceMultiboardBar

	globals
		private multiboard array usedMultiboard
	endglobals

	private function MultiboardBarValueFunctionGetValue takes AMultiboardBar multiboardBar returns real
		return 100.0
	endfunction

	private function MultiboardBarValueFunctionGetMaxValue takes AMultiboardBar multiboardBar returns real
		return 100.0
	endfunction

	private function GetMultiboardBarDebug takes player user returns nothing
		local AMultiboardBar multiboardBar
		if (usedMultiboard[GetPlayerId(user)] == null) then
			set usedMultiboard[GetPlayerId(user)] = CreateMultiboard()
			call MultiboardSetTitleText(usedMultiboard[GetPlayerId(user)], "Test Multiboard")
			call ShowMultiboardForPlayer(user, usedMultiboard[GetPlayerId(user)], true)
			set multiboardBar = AMultiboardBar.create(usedMultiboard[GetPlayerId(user)], 0, 0, 10, 1.0, true)
			call multiboardBar.setValueFunction(MultiboardBarValueFunctionGetValue)
			call multiboardBar.setMaxValueFunction(MultiboardBarValueFunctionGetMaxValue)
			call multiboardBar.setAllIcons("ReplaceableTextures\\CommandButtons\\BTNAlleriaFlute.blp", true)
			call multiboardBar.setAllIcons("ReplaceableTextures\\CommandButtons\\BTNSpellShieldAmulet.blp", false)
			call multiboardBar.refresh()
		endif
	endfunction

	function AMultiboardBarDebug takes nothing returns nothing
		local player triggerPlayer = GetTriggerPlayer()
		call GetMultiboardBarDebug(triggerPlayer)
		set triggerPlayer = null
	endfunction

endlibrary