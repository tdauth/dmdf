library ALibraryCoreGeneralPlayer

	/**
	 * Checks whether a player is a playing user.
	 * \author Tamino Dauth
	 */
	function IsPlayerPlayingUser takes player whichPlayer returns boolean
		return ((GetPlayerController(whichPlayer) == MAP_CONTROL_USER) and (GetPlayerSlotState(whichPlayer) == PLAYER_SLOT_STATE_PLAYING))
	endfunction

	/**
	 * \return Returns the number of playing users in game.
	 * \author Tamino Dauth
	 */
	function CountPlayingUsers takes nothing returns integer
		local integer result = 0
		local player user
		local integer i = 0
		loop
			exitwhen (i == bj_MAX_PLAYERS)
			set user = Player(i)
			if (IsPlayerPlayingUser(user)) then
				set result = result + 1
			endif
			set user = null
			set i= i + 1
		endloop
		return result
	endfunction

	/**
	 * \return Returns the number of playing players in game (without neutral players).
	 * \author Tamino Dauth
	 */
	function CountPlayingPlayers takes nothing returns integer
		local integer result = 0
		local player whichPlayer
		local integer i = 0
		loop
			exitwhen (i == bj_MAX_PLAYERS)
			set whichPlayer = Player(i)
			if (GetPlayerController(whichPlayer) == MAP_CONTROL_COMPUTER or IsPlayerPlayingUser(whichPlayer)) then
				set result = result + 1
			endif
			set whichPlayer = null
			set i= i + 1
		endloop
		return result
	endfunction

	/**
	 * Gets all players who are controlled by human players and which are actually playing at the moment.
	 * \return Returns the number of players with human controlling players who have not left the game yet.
	 * \note The returned force has to be destroyed manually.
	 */
	function GetPlayingUsers takes nothing returns force
		local force result = CreateForce()
		local player whichPlayer
		local integer i = 0
		loop
			exitwhen (i == bj_MAX_PLAYERS)
			set whichPlayer = Player(i)
			if (IsPlayerPlayingUser(whichPlayer)) then
				call ForceAddPlayer(result, whichPlayer)
			endif
			set whichPlayer = null
			set i= i + 1
		endloop
		return result
	endfunction

	function GetPlayingPlayers takes nothing returns force
		local force result = CreateForce()
		local player whichPlayer
		local integer i = 0
		loop
			exitwhen (i == bj_MAX_PLAYERS)
			set whichPlayer = Player(i)
			if (GetPlayerController(whichPlayer) == MAP_CONTROL_COMPUTER or IsPlayerPlayingUser(whichPlayer)) then
				call ForceAddPlayer(result, whichPlayer)
			endif
			set whichPlayer = null
			set i= i + 1
		endloop
		return result
	endfunction

endlibrary