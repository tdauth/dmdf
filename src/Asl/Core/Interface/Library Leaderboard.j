library ALibraryCoreInterfaceLeaderboard

	/**
	 * Shows or hides leaderboard \p whichLeaderboard for player \p whichPlayer.
	 */
	function ShowLeaderboardForPlayer takes player whichPlayer, leaderboard whichLeaderboard, boolean show returns nothing
		if (show) then
			call PlayerSetLeaderboard(whichPlayer, whichLeaderboard)
		endif
		if (whichPlayer == GetLocalPlayer()) then
			call LeaderboardDisplay(whichLeaderboard, show)
		endif
	endfunction

endlibrary