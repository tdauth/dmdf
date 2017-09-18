library ALibraryCoreEnvironmentSound

	/**
	 * Plays sound \p whichSound for player \p whichPlayer.
	 * \author Tamino Dauth
	 * \param whichPlayer Player who the sound is played for.
	 * \param whichSound Played sound.
	 * \sa StartSound()
	 * \sa PlaySound()
	 * \sa PlaySoundFileForPlayer()
	 */
	function PlaySoundForPlayer takes player whichPlayer, sound whichSound returns nothing
		if (GetLocalPlayer() == whichPlayer) then
			call StartSound(whichSound)
		endif
	endfunction

	/**
	 * Similar to function \ref PlaySound().
	 */
	function PlaySoundFile takes string filePath returns nothing
		call PlaySound(filePath)
	endfunction

	/**
	 * Plays sound from file path \p filePath at position with coordinates \p x, \p y, \p z.
	 * \note Note that sound paths has to be preloaded before they can be played first time (\ref PreloadSoundFile()).
	 * \author Tamino Dauth
	 * \param filePath Path of the played sound file.
	 * \param x x coordinate.
	 * \param y y coordinate.
	 * \param x z coordinate.
	 * \sa PlaySoundFileAtForPlayer()
	 */
	function PlaySoundFileAt takes string filePath, real x, real y, real z returns nothing
		local sound whichSound = CreateSound(filePath, false, true, true, 12700, 12700, "") // has to be 3d
		call SetSoundPosition(whichSound, x, y, z)
		call StartSound(whichSound)
		call KillSoundWhenDone(whichSound)
		set whichSound = null
	endfunction

	function PlaySoundFileOnUnit takes string filePath, unit whichUnit returns nothing
		local sound whichSound = CreateSound(filePath, false, true, true, 12700, 12700, "") // has to be 3d
		call AttachSoundToUnit(whichSound, whichUnit)
		call StartSound(whichSound)
		call KillSoundWhenDone(whichSound)
		set whichSound = null
	endfunction

	/**
	 * Plays sound from file path \p filePath for player \p whichPlayer.
	 * \note Note that sound paths has to be preloaded before they can be played first time (\ref PreloadSoundFile()).
	 * \author Tamino Dauth
	 * \param whichPlayer Player who the sound is played for.
	 * \param filePath Path of the played sound file.
	 * \sa PlaySoundForPlayer()
	 */
	function PlaySoundFileForPlayer takes player whichPlayer, string filePath returns nothing
		local sound whichSound = CreateSound(filePath, false, false, true, 12700, 12700, "")
		call PlaySoundForPlayer(whichPlayer, whichSound)
		call KillSoundWhenDone(whichSound)
		set whichSound = null
	endfunction

	function PlaySoundFileAtForPlayer takes player whichPlayer, string filePath, real x, real y, real z returns nothing
		local sound whichSound = CreateSound(filePath, false, true, true, 12700, 12700, "") // has to be 3d
		call SetSoundPosition(whichSound, x, y, z)
		call PlaySoundForPlayer(whichPlayer, whichSound)
		call KillSoundWhenDone(whichSound)
		set whichSound = null
	endfunction

	/**
	 * Preloads sound file with file path \p filePath.
	 * \note Note that sound files has to be preloaded before they can be played first time.
	 * \author Tamino Dauth
	 * \param filePath Preloaded sound file.
	 */
	function PreloadSoundFile takes string filePath returns nothing
		local sound whichSound = CreateSound(filePath, false, false, false, 10, 10, "")
		call SetSoundVolume(whichSound, 0)
		call StartSound(whichSound)
		call KillSoundWhenDone(whichSound)
		set whichSound = null
	endfunction

endlibrary