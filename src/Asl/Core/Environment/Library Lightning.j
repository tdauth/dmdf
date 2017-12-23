library ALibraryCoreEnvironmentLightning

	/**
	 * Creates a single lightning which only can be seen by the \p whichPlayer.
	 * \author Tamino Dauth
	 * \param whichPlayer Player who can see the lightning.
	 * \param codeName For furhter information look into the "Splats/LightningData.slk" file of the original Warcraft III: The Frozen Throne MPQ archives.
	 * \param x0 Start x coordinate.
	 * \param y0 Start y coordinate.
	 * \param z0 Start z coordinate.
	 * \param x1 End x coordinate.
	 * \param y1 End y coordinate.
	 * \param z1 End z coordinate.
	 * \return Returns the created lightning.
	 * \sa AddLightningEx()
	 */
	function CreateLightningForPlayer takes player whichPlayer, string codeName, real x0, real y0, real z0, real x1, real y1, real z1 returns lightning
		local string localCode = ""
		if (whichPlayer == GetLocalPlayer()) then
			set localCode = codeName
		endif
		return AddLightningEx(localCode, false, x0, y0, z0, x1, y1, z1)
	endfunction

endlibrary