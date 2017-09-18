library ALibraryCoreInterfaceMinimap

	/**
	 * Doesn't use a force.
	 * \sa PingMinimapForForce()
	 * \sa PingMinimapLocForForce()
	 * \sa PingMinimapForForceEx()
	 * \sa PingMinimapForPlayer()
	 * \sa PingMinimapLocForPlayer()
	 */
	function PingMinimapExForPlayer takes player whichPlayer, real x, real y, real duration, real red, real green, real blue, boolean extraEffect returns nothing
		if (whichPlayer == GetLocalPlayer()) then
			call PingMinimapEx(x, y, duration, PercentTo255(red), PercentTo255(green), PercentTo255(blue), extraEffect)
		endif
	endfunction

endlibrary