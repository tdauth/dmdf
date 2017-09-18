library ALibraryCoreInterfaceTrackable

	/// <a href="http://www.wc3jass.com/">source</a>
	function CreateTrackableForPlayer takes player whichPlayer, string modelPath, real x, real y, real facingAngle returns trackable
		local string localPath = ""
		if (whichPlayer == GetLocalPlayer()) then
			set localPath = modelPath
		endif
		return CreateTrackable(localPath, x, y, facingAngle)
	endfunction

	/**
	 * This creates a trackable at the given coordinates that floats above the ground with the height specified by z.
	 * It works by creating an invisible platform, creating the trackable and removing the platform again.
	 * This function is extra since it uses more memory and isn't always required.
	 * \author KaTTaNa
	 * <a href="http://www.wc3jass.com/">source</a>
	 */
	function CreateTrackableForPlayerZ takes player whichPlayer, string modelPath, real x, real y, real z, real facingAngle returns trackable
		local destructable heightDestructable = CreateDestructableZ('OTip', x, y, z, 0.0, 1.0, 0)
		local trackable whichTrackable = CreateTrackableForPlayer(whichPlayer, modelPath, x, y, facingAngle)
		call RemoveDestructable(heightDestructable)
		set heightDestructable = null
		return whichTrackable
	endfunction

	function CreateTrackableZ takes string modelPath, real x, real y, real z, real facingAngle returns trackable
		local destructable heightDestructable = CreateDestructableZ('OTip', x, y, z, 0.0, 1.0, 0)
		local trackable whichTrackable = CreateTrackable(modelPath, x, y, facingAngle)
		call RemoveDestructable(heightDestructable)
		set heightDestructable = null
		return whichTrackable
	endfunction

endlibrary