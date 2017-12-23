library ALibraryCoreInterfaceMisc initializer init requires ALibraryCoreStringConversion

	globals
		// keys
		constant integer AKeyEscape = 0
		constant integer AKeyUp = 1
		constant integer AKeyDown = 2
		constant integer AKeyRight = 3
		constant integer AKeyLeft = 4
		// shortcuts for dialogs (ASCII values)
		constant integer AShortcutBackspace = 8
		constant integer AShortcutTab = 9
		constant integer AShortcutEscape = 27
		constant integer AShortcutSpace = 32
		constant integer AShortcut0 = 48
		constant integer AShortcut1 = 49
		constant integer AShortcut2 = 50
		constant integer AShortcut3 = 51
		constant integer AShortcut4 = 52
		constant integer AShortcut5 = 53
		constant integer AShortcut6 = 54
		constant integer AShortcut7 = 55
		constant integer AShortcut8 = 56
		constant integer AShortcut9 = 57
		// small letters
		constant integer AShortcutA = 65
		constant integer AShortcutB = 66
		constant integer AShortcutC = 67
		constant integer AShortcutD = 68
		constant integer AShortcutE = 69
		constant integer AShortcutF = 70
		constant integer AShortcutG = 71
		constant integer AShortcutH = 72
		constant integer AShortcutI = 73
		constant integer AShortcutJ = 74
		constant integer AShortcutK = 75
		constant integer AShortcutL = 76
		constant integer AShortcutM = 77
		constant integer AShortcutN = 78
		constant integer AShortcutO = 79
		constant integer AShortcutP = 80
		constant integer AShortcutQ = 81
		constant integer AShortcutR = 82
		constant integer AShortcutS = 83
		constant integer AShortcutT = 84
		constant integer AShortcutU = 85
		constant integer AShortcutV = 86
		constant integer AShortcutW = 87
		constant integer AShortcutX = 88
		constant integer AShortcutY = 89
		constant integer AShortcutZ = 90
		// dialogs
		/// \todo 16?
		constant integer AMaxDialogButtons = 12
	endglobals

	function KeyIsValid takes integer key returns boolean
		return key >= AKeyEscape and key <= AKeyLeft
	endfunction

	function TriggerRegisterKeyEventForPlayer takes player user, trigger usedTrigger, integer key, boolean press returns event
		debug if (not KeyIsValid(key)) then
			debug call Print("TriggerRegisterKeyEventForPlayer: Invalid key " + I2S(key) + ".")
		debug endif
		if (key == AKeyEscape) then
			debug if (not press) then
				debug call Print("TriggerRegisterKeyEventForPlayer: Escape key release event can't be used.")
			debug endif
			return TriggerRegisterPlayerEvent(usedTrigger, user, EVENT_PLAYER_END_CINEMATIC)
		elseif (key == AKeyUp) then
			if (press) then
				return TriggerRegisterPlayerEvent(usedTrigger, user, EVENT_PLAYER_ARROW_UP_DOWN)
			else
				return TriggerRegisterPlayerEvent(usedTrigger, user, EVENT_PLAYER_ARROW_UP_UP)
			endif
		elseif (key == AKeyDown) then
			if (press) then
				return TriggerRegisterPlayerEvent(usedTrigger, user, EVENT_PLAYER_ARROW_DOWN_DOWN)
			else
				return TriggerRegisterPlayerEvent(usedTrigger, user, EVENT_PLAYER_ARROW_DOWN_UP)
			endif
		elseif (key == AKeyRight) then
			if (press) then
				return TriggerRegisterPlayerEvent(usedTrigger, user, EVENT_PLAYER_ARROW_RIGHT_DOWN)
			else
				return TriggerRegisterPlayerEvent(usedTrigger, user, EVENT_PLAYER_ARROW_RIGHT_UP)
			endif
		elseif (key == AKeyLeft) then
			if (press) then
				return TriggerRegisterPlayerEvent(usedTrigger, user, EVENT_PLAYER_ARROW_LEFT_DOWN)
			else
				return TriggerRegisterPlayerEvent(usedTrigger, user, EVENT_PLAYER_ARROW_LEFT_UP)
			endif
		endif
		return null
	endfunction
	
	/**
	 * \return Returns the player's name in the color of the player.
	 */
	function GetColoredPlayerName takes player whichPlayer returns string
		return "|c00" + PlayerColorToString(GetPlayerColor(whichPlayer)) + GetPlayerName(whichPlayer) + "|r"
	endfunction

	/**
	 * \return Returns the colored player's name with the players number in brackets.
	 */
	function GetModifiedPlayerName takes player whichPlayer returns string
		return GetColoredPlayerName(whichPlayer) + " |c00ffffff[" + I2S(GetPlayerId(whichPlayer) + 1) + "]|r"
	endfunction

	/**
	 * Returns RGB value of player color \p playerColor.
	 * \sa StringToPlayerColor, PlayerColorToString, GetPlayerColorRed, GetPlayerColorGreen, GetPlayerColorBlue
	 */
	function GetPlayerColorValue takes playercolor playerColor returns integer
		if (playerColor == PLAYER_COLOR_RED) then
			return 0xFF0000
		elseif (playerColor == PLAYER_COLOR_BLUE) then
			return 0x0000FF
		elseif (playerColor == PLAYER_COLOR_CYAN) then
			return 0x1CB619
		elseif (playerColor == PLAYER_COLOR_PURPLE) then
			return 0x800080
		elseif (playerColor == PLAYER_COLOR_YELLOW) then
			return 0xFFFF00
		elseif (playerColor == PLAYER_COLOR_ORANGE) then
			return 0xFF8000
		elseif (playerColor == PLAYER_COLOR_GREEN) then
			return 0x00FF00
		elseif (playerColor == PLAYER_COLOR_PINK) then
			return 0xFF80C0
		elseif (playerColor == PLAYER_COLOR_LIGHT_GRAY) then
			return 0xC0C0C0
		elseif (playerColor == PLAYER_COLOR_LIGHT_BLUE) then
			return 0x0080FF
		elseif (playerColor == PLAYER_COLOR_AQUA) then
			return 0x106246
		elseif (playerColor == PLAYER_COLOR_BROWN) then
			return 0x804000
		endif
		return 0
	endfunction

	function GetPlayerColorRed takes playercolor playerColor returns integer
		if (playerColor == PLAYER_COLOR_RED) then
			return 0xFF
		elseif (playerColor == PLAYER_COLOR_BLUE) then
			return 0x00
		elseif (playerColor == PLAYER_COLOR_CYAN) then
			return 0x1C
		elseif (playerColor == PLAYER_COLOR_PURPLE) then
			return 0x80
		elseif (playerColor == PLAYER_COLOR_YELLOW) then
			return 0xFF
		elseif (playerColor == PLAYER_COLOR_ORANGE) then
			return 0xFF
		elseif (playerColor == PLAYER_COLOR_GREEN) then
			return 0x00
		elseif (playerColor == PLAYER_COLOR_PINK) then
			return 0xFF
		elseif (playerColor == PLAYER_COLOR_LIGHT_GRAY) then
			return 0xC0
		elseif (playerColor == PLAYER_COLOR_LIGHT_BLUE) then
			return 0x00
		elseif (playerColor == PLAYER_COLOR_AQUA) then
			return 0x10
		elseif (playerColor == PLAYER_COLOR_BROWN) then
			return 0x80
		endif
		return 0
	endfunction

	function GetPlayerColorGreen takes playercolor playerColor returns integer
		if (playerColor == PLAYER_COLOR_RED) then
			return 0x00
		elseif (playerColor == PLAYER_COLOR_BLUE) then
			return 0x00
		elseif (playerColor == PLAYER_COLOR_CYAN) then
			return 0xB6
		elseif (playerColor == PLAYER_COLOR_PURPLE) then
			return 0x00
		elseif (playerColor == PLAYER_COLOR_YELLOW) then
			return 0xFF
		elseif (playerColor == PLAYER_COLOR_ORANGE) then
			return 0x80
		elseif (playerColor == PLAYER_COLOR_GREEN) then
			return 0xFF
		elseif (playerColor == PLAYER_COLOR_PINK) then
			return 0x80
		elseif (playerColor == PLAYER_COLOR_LIGHT_GRAY) then
			return 0xC0
		elseif (playerColor == PLAYER_COLOR_LIGHT_BLUE) then
			return 0x80
		elseif (playerColor == PLAYER_COLOR_AQUA) then
			return 0x62
		elseif (playerColor == PLAYER_COLOR_BROWN) then
			return 0x40
		endif
		return 0
	endfunction

	function GetPlayerColorBlue takes playercolor playerColor returns integer
		if (playerColor == PLAYER_COLOR_RED) then
			return 0x00
		elseif (playerColor == PLAYER_COLOR_BLUE) then
			return 0xFF
		elseif (playerColor == PLAYER_COLOR_CYAN) then
			return 0x19
		elseif (playerColor == PLAYER_COLOR_PURPLE) then
			return 0x80
		elseif (playerColor == PLAYER_COLOR_YELLOW) then
			return 0x00
		elseif (playerColor == PLAYER_COLOR_ORANGE) then
			return 0x00
		elseif (playerColor == PLAYER_COLOR_GREEN) then
			return 0x00
		elseif (playerColor == PLAYER_COLOR_PINK) then
			return 0xC0
		elseif (playerColor == PLAYER_COLOR_LIGHT_GRAY) then
			return 0xC0
		elseif (playerColor == PLAYER_COLOR_LIGHT_BLUE) then
			return 0xFF
		elseif (playerColor == PLAYER_COLOR_AQUA) then
			return 0x46
		elseif (playerColor == PLAYER_COLOR_BROWN) then
			return 0x00
		endif
		return 0
	endfunction

	function GetBar takes real value, real maxValue, integer length, string colour returns string
		local integer i
		local integer colouredPart
		local string result = ""
		debug if (maxValue == 0.0) then
			debug call Print("GetBar: Invalid maxValue parameter with value " + R2S(maxValue) + ".")
			debug return null
		debug endif
		set colouredPart = R2I(value * I2R(length) / maxValue)
		//coloured part exists
		if (colouredPart > 0.0) then
			set result = "|c00" + colour
		endif
		set i = 0
		loop
			exitwhen(i == length)
			set result = result + "|"
			//set end of coloured part
			if ((i == colouredPart) and (colouredPart > 0.0) and (colouredPart != length)) then
				set result = result +  " |c00ffffff"
			endif
			set i = i + 1
		endloop
		return result
	endfunction

	/// \todo test please
	function SetUnitVertexColourForPlayer takes player whichPlayer, unit whichUnit, real red, real green, real blue, real transparency returns nothing
		local player localPlayer = GetLocalPlayer()
		if (whichPlayer == localPlayer) then
			call SetUnitVertexColorBJ(whichUnit, red, green, blue, transparency)
		endif
		set localPlayer = null
	endfunction

	/**
	 * Shows or hides \p whichUnit for player \p whichPlayer.
	 * \param show If this value is true, unit is shown, otherwise it's hidden.
	 * \author Tamino Dauth
	 */
	function ShowUnitForPlayer takes player whichPlayer, unit whichUnit, boolean show returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call ShowUnit(whichUnit, show)
		endif
	endfunction

	globals
		private sound error
	endglobals

	/// \author Vexorian
	/// <a href="http://www.wc3c.net/showthread.php?t=101260">source</a>
	function SimError takes player whichPlayer, string message returns nothing
		local player localPlayer = GetLocalPlayer()
		set message = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n|cffffcc00" + message + "|r"
		if (localPlayer == whichPlayer) then
			call ClearTextMessages()
			call DisplayTimedTextToPlayer(whichPlayer, 0.52, 0.96, 2.00, message)
			call StartSound(error)
		endif
		set localPlayer = null
	endfunction

	private function init takes nothing returns nothing
		set error = CreateSoundFromLabel("InterfaceError",false,false,false,10,10)
		//call StartSound( error ) //apparently the bug in which you play a sound for the first time
        //and it doesn't work is not there anymore in patch 1.22
	endfunction
	
	function QuestMessageForPlayer takes player whichPlayer, integer messageType, string message returns nothing
		call QuestMessageBJ(bj_FORCE_PLAYER[GetPlayerId(whichPlayer)], messageType, message)
	endfunction

endlibrary