library ALibraryCoreInterfaceMultiboard

	/**
	 * Shows or hides a multiboard for one player only.
	 * \param whichPlayer The player for whom the multiboard is shown or hidden.
	 * \param whichMultiboard The multiboard which is shown or hidden.
	 * \param show If this value is true, the multiboard is shown. Otherwise it is hidden.
	 */
	function ShowMultiboardForPlayer takes player whichPlayer, multiboard whichMultiboard, boolean show returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call MultiboardDisplay(whichMultiboard, show)
		endif
	endfunction

	function MultiboardSuppressDisplayForPlayer takes player whichPlayer, boolean flag returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call MultiboardSuppressDisplay(flag)
		endif
	endfunction

endlibrary