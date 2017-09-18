library ALibraryCoreInterfaceCinematicFilter

	/**
	 * \author KaTTaNa
	 * \todo Crashes the game?!
	 */
	function ShowGenericCinematicFilterForPlayer takes player whichPlayer, real duration, blendmode bmode, string tex, real red0, real green0, real blue0, real trans0, real red1, real green1, real blue1, real trans1 returns nothing
		if (GetLocalPlayer() == whichPlayer) then
			call SetCineFilterTexture(tex)
			call SetCineFilterBlendMode(bmode)
			call SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
			call SetCineFilterStartUV(0, 0, 1, 1)
			call SetCineFilterEndUV(0, 0, 1, 1)
			call SetCineFilterStartColor(PercentTo255(red0), PercentTo255(green0), PercentTo255(blue0), PercentTo255(100-trans0))
			call SetCineFilterEndColor(PercentTo255(red1), PercentTo255(green1), PercentTo255(blue1), PercentTo255(100-trans1))
			call SetCineFilterDuration(duration)
			call DisplayCineFilter(true)
		endif
	endfunction

	/// \author Tamino Dauth
	function ShowBlackScreenCinematicFilterForPlayer takes player whichPlayer, real duration returns nothing
		if (GetLocalPlayer() == whichPlayer) then
			call SetCineFilterTexture("ReplaceableTextures\\CameraMasks\\Black_mask.blp")
			call SetCineFilterBlendMode(BLEND_MODE_NONE)
			call SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
			call SetCineFilterStartUV(0, 0, 1, 1)
			call SetCineFilterEndUV(0, 0, 1, 1)
			call SetCineFilterStartColor(255, 255, 255, 0)
			call SetCineFilterEndColor(255, 255, 255, 0)
			call SetCineFilterDuration(duration)
			call DisplayCineFilter(true)
		endif
	endfunction

	/// \author Tamino Dauth
	function ShowBlackScreenCinematicFilter takes real duration returns nothing
		call SetCineFilterTexture("ReplaceableTextures\\CameraMasks\\Black_mask.blp")
		call SetCineFilterBlendMode(BLEND_MODE_NONE)
		call SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
		call SetCineFilterStartUV(0, 0, 1, 1)
		call SetCineFilterEndUV(0, 0, 1, 1)
		call SetCineFilterStartColor(255, 255, 255, 0)
		call SetCineFilterEndColor(255, 255, 255, 0)
		call SetCineFilterDuration(duration)
		call DisplayCineFilter(true)
	endfunction

endlibrary