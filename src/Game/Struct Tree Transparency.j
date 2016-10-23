/**
 * The tree transparency system allows you to register Doodad types for which all Doodads will be animated to "Stand Alternate" if they are in range of the camera target.
 * http://www.hiveworkshop.com/forums/triggers-scripts-269/tree-transparency-270310/#post2736405
 */
library StructGameTreeTransparency initializer init requires Asl

	globals
		private constant real OCCLUSION_RADIUS = 800.0 // Defines the radius around the camera target in which doodads are occluded.

		private timer Timer
		private integer array raw
		private integer rawcount = 0
		private real cameraX = 0.0
		private real cameraY = 0.0
	endglobals

	/**
	 * Adds doodad type \p rawcode to the tree transparency system.
	 * All doodads of this type will be set transparent if they appear close enough in the player's view.
	 */
	function AddDoodadOcclusion takes integer rawcode returns nothing
		set raw[rawcount] = rawcode
		set rawcount = rawcount+1
	endfunction

	private function ResetTransparency takes nothing returns nothing
		local integer j
		set j = 0
		loop
			exitwhen j >= rawcount
			call SetDoodadAnimation(cameraX, cameraY, OCCLUSION_RADIUS, raw[j], false, "stand", false)
			set j = j + 1
		endloop
	endfunction

	private function periodic takes nothing returns nothing
		local AIntegerListIterator iterator
		local integer j
		local real camX = GetCameraTargetPositionX()
		local real camY = GetCameraTargetPositionY()
		call ResetTransparency()
		set cameraX = camX
		set cameraY = camY
		set j = 0
		loop
			exitwhen j >= rawcount
			call SetDoodadAnimation(cameraX, cameraY, OCCLUSION_RADIUS, raw[j], false, "stand alternate", false)
			set j = j + 1
		endloop
	endfunction

	/**
	 * Enables the tree transparency system which means that all trees will become transparent to all players if they are in range.
	 */
	function EnableTransparency takes nothing returns nothing
		if (Timer == null) then
			set Timer = CreateTimer()
			call TimerStart(Timer, 0.1, true, function periodic)
		endif
		debug call Print("Enable transparency")
	endfunction

	/**
	 * Disables the tree transparency system which means that no tree will become transparent anymore and all transparency of trees is reset immediately.
	 */
	function DisableTransparency takes nothing returns nothing
		if (Timer != null) then
			call PauseTimer(Timer)
			call DestroyTimer(Timer)
			set Timer = null
			call ResetTransparency()
		endif
		debug call Print("Disable transparency")
	endfunction

	private function init takes nothing returns nothing
		set Timer = CreateTimer()
		call TimerStart(Timer, 0.1, true, function periodic)
	endfunction

endlibrary