/**
 * These functions extend Blizzard's music functions by new ones which can be used on players and forces only.
 * They all have been tested and shouldn't lead to a desync!
 */
library ALibraryCoreInterfaceMusic

	/**
	 * \param musicList File paths should be separated by ; character.
	 */
	function SetMapMusicForPlayer takes player whichPlayer, string musicList, boolean random, integer index returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call SetMapMusic(musicList, random, index)
		endif
	endfunction

	/**
	 * <a href="http://www.wc3jass.com/viewtopic.php?t=141&sid=13329920bf4c51dc914b774abe5838de">Source</a>
	 */
	function SetMapMusicForForce takes force whichForce, string musicList, boolean random, integer index returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call SetMapMusic(musicList, random, index)
		endif
	endfunction

	function SetMapMusicIndexedForPlayer takes player whichPlayer, string musicList, integer index returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call SetMapMusicIndexedBJ(musicList, index)
		endif
	endfunction

	function SetMapMusicIndexedForForce takes force whichForce, string musicList, integer index returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call SetMapMusicIndexedBJ(musicList, index)
		endif
	endfunction

	function SetMapMusicRandomForPlayer takes player whichPlayer, string musicList returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call SetMapMusicRandomBJ(musicList)
		endif
	endfunction

	function SetMapMusicRandomForForce takes force whichForce, string musicList returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call SetMapMusicRandomBJ(musicList)
		endif
	endfunction

	function ClearMapMusicForPlayer takes player whichPlayer returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call ClearMapMusic()
		endif
	endfunction

	function ClearMapMusicForForce takes force whichForce returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call ClearMapMusic()
		endif
	endfunction

	function PlayMusicForPlayer takes player whichPlayer, string musicName returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call PlayMusic(musicName)
		endif
	endfunction

	function PlayMusicForForce takes force whichForce, string musicName returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call PlayMusic(musicName)
		endif
	endfunction

	function PlayMusicExForPlayer takes player whichPlayer, string musicName, integer fromMilliseconds, integer fadeInMilliseconds returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call PlayMusicEx(musicName, fromMilliseconds, fadeInMilliseconds)
		endif
	endfunction

	function PlayMusicExForForce takes force whichForce, string musicName, integer fromMilliseconds, integer fadeInMilliseconds returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call PlayMusicEx(musicName, fromMilliseconds, fadeInMilliseconds)
		endif
	endfunction

	function StopMusicForPlayer takes player whichPlayer, boolean fadeOut returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call StopMusic(fadeOut)
		endif
	endfunction

	function StopMusicForForce takes force whichForce, boolean fadeOut returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call StopMusic(fadeOut)
		endif
	endfunction

	function ResumeMusicForPlayer takes player whichPlayer returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call ResumeMusic()
		endif
	endfunction

	function ResumeMusicForForce takes force whichForce returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call ResumeMusic()
		endif
	endfunction

	function PlayThematicMusicForPlayer takes player whichPlayer, string musicFileName returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call PlayThematicMusic(musicFileName)
		endif
	endfunction

	function PlayThematicMusicForForce takes force whichForce, string musicFileName returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call PlayThematicMusic(musicFileName)
		endif
	endfunction

	function PlayThematicMusicExForPlayer takes player whichPlayer, string musicFileName, integer fromMilliseconds returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call PlayThematicMusicEx(musicFileName, fromMilliseconds)
		endif
	endfunction

	function PlayThematicMusicExForForce takes force whichForce, string musicFileName, integer fromMilliseconds returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call PlayThematicMusicEx(musicFileName, fromMilliseconds)
		endif
	endfunction

	function EndThematicMusicForPlayer takes player whichPlayer returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call EndThematicMusic()
		endif
	endfunction

	function EndThematicMusicForForce takes force whichForce returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call EndThematicMusic()
		endif
	endfunction

	/**
	 * \param volume 0-127
	 */
	function SetMusicVolumeForPlayer takes player whichPlayer, integer volume returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call SetMusicVolume(volume)
		endif
	endfunction

	function SetMusicVolumeForForce takes force whichForce, integer volume returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call SetMusicVolume(volume)
		endif
	endfunction

	function SetMusicPlayPositionForPlayer takes player whichPlayer, integer milliseconds returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call SetMusicPlayPosition(milliseconds)
		endif
	endfunction

	function SetMusicPlayPositionForForce takes force whichForce, integer milliseconds returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call SetMusicPlayPosition(milliseconds)
		endif
	endfunction

	function SetThematicMusicPlayPositionForPlayer takes player whichPlayer, integer milliseconds returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call SetThematicMusicPlayPosition(milliseconds)
		endif
	endfunction

	function SetThematicMusicPlayPositionForForce takes force whichForce, integer milliseconds returns nothing
		if (IsPlayerInForce(GetLocalPlayer(), whichForce)) then
			call SetThematicMusicPlayPosition(milliseconds)
		endif
	endfunction

endlibrary