library ALibraryCoreEnvironmentTerrainFog

	/**
	 * \author dataangel
	 * <a href="http://www.wc3jass.com/">source</a>
	 */
	function ResetTerrainFogForPlayer takes player whichPlayer returns nothing
		local player localPlayer = GetLocalPlayer()
		if (localPlayer == whichPlayer) then
			call ResetTerrainFog()
		endif
		set localPlayer = null
	endfunction

	/**
	 * \author Tamino Dauth
	 <a href="http://www.mappedia.de/wiki/Tutorial:Gel%C3%A4ndenebel">source</a>
	 */
	function SetTerrainFogNight takes nothing returns nothing
		call SetTerrainFogEx(0, 0, 5000.0, 0.0, 0.0, 0.0, 0.1961)
	endfunction

	/**
	 * \author Tamino Dauth
	 <a href="http://www.mappedia.de/wiki/Tutorial:Gel%C3%A4ndenebel">source</a>
	 */
	function SetTerrainFogSunny takes nothing returns nothing
		call SetTerrainFogEx(0, 0, 10000.0, 0.0, 1.0, 1.0, 0.3922)
	endfunction

	/**
	 * \author Tamino Dauth
	 <a href="http://www.mappedia.de/wiki/Tutorial:Gel%C3%A4ndenebel">source</a>
	 */
	function SetTerrainFogForest takes nothing returns nothing
		call SetTerrainFogEx(0, 0, 5000.0, 0.0, 0.0, 0.3137, 0.1961)
	endfunction

	/**
	 * \author Tamino Dauth
	 <a href="http://www.mappedia.de/wiki/Tutorial:Gel%C3%A4ndenebel">source</a>
	 */
	function SetTerrainFogFoggy takes nothing returns nothing
		call SetTerrainFogEx(0, 0, 4000.0, 0.0, 0.7843, 0.7843, 0.7843)
	endfunction

endlibrary