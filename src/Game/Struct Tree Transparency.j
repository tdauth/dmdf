/**
 * The tree transparency system allows you to register Doodad types for which all Doodads will be animated to "Stand Alternate" if they are in range of registered units.
 * http://www.hiveworkshop.com/forums/triggers-scripts-269/tree-transparency-270310/#post2736405
 */
library StructGameTreeTransparency initializer init requires Asl

	private struct Unit
		public real x = 0.0
		public real y = 0.0
		public unit whichUnit = null
	endstruct

	globals
		private constant real OCCLUSION_RADIUS = 800.0 //defines the radius around the unit in which doodads are occluded
		private constant real CAMERA_TARGET_RADIUS = 1200.0 //defines the radius around the camera target in which doodads are occluded

		private timer Timer
		private integer array raw
		private integer rawcount = 0
		private AIntegerList units
		private real cameraX = 0.0
		private real cameraY = 0.0
	endglobals

	/**
	 * Adds doodad type \p rawcode to the tree transparency system.
	 * All doodads of this type will be set transparent if a registered unit moves near them and the doodad is in the player's view.
	 */
	function AddDoodadOcclusion takes integer rawcode returns nothing
		set raw[rawcount] = rawcode
		set rawcount = rawcount+1
	endfunction

	/**
	 * Adds unit \p u to the tree transparency system.
	 * Whenever the unit comes near a registered doodad in range of \ref OCCLUSION_RADIUS and the doodad is in the player's view, it will be set transparent.
	 */
	function AddUnitOcclusion takes unit u returns nothing
		local Unit data = Unit.create()
		set data.whichUnit = u
		set data.x = GetUnitX(u)
		set data.y = GetUnitY(u)
		call units.pushBack(data)
	endfunction
	
	function RemoveUnitOcclusion takes unit u returns boolean
		local AIntegerListIterator iterator = units.begin()
		loop
			exitwhen (not iterator.isValid())
			if (Unit(iterator.data()).whichUnit == u) then
				call units.erase(iterator).destroy()
				return true
			endif
			call iterator.next()
		endloop
		
		call iterator.destroy()
		
		return false
	endfunction
	
	private function ResetTransparency takes nothing returns nothing
		//local AIntegerListIterator iterator = units.begin()
		local integer j
		//loop
		//	exitwhen not iterator.isValid()
			set j = 0
			loop
				exitwhen j >= rawcount
				//call SetDoodadAnimation(Unit(iterator.data()).x, Unit(iterator.data()).y, OCCLUSION_RADIUS, raw[j], false, "stand", false)
				call SetDoodadAnimation(cameraX, cameraY, OCCLUSION_RADIUS, raw[j], false, "stand", false)
				set j = j + 1
			endloop
		//	call iterator.next()
		//endloop
		
		//call iterator.destroy()
	endfunction
	
	private function periodic takes nothing returns nothing
		local AIntegerListIterator iterator
		local integer j
		local real camX = GetCameraTargetPositionX()
		local real camY = GetCameraTargetPositionY()
		call ResetTransparency()
		set cameraX = camX
		set cameraY = camY
		/*
		set iterator = units.begin()
		loop
			exitwhen not iterator.isValid()
			// allow corpses as well
			if (GetUnitTypeId(Unit(iterator.data()).whichUnit) != 0 and IsUnitInRangeXY(Unit(iterator.data()).whichUnit, camX, camY, CAMERA_TARGET_RADIUS)) then
				set Unit(iterator.data()).x = GetUnitX(Unit(iterator.data()).whichUnit)
				set Unit(iterator.data()).y = GetUnitY(Unit(iterator.data()).whichUnit)
				*/
				set j = 0
				loop
					exitwhen j >= rawcount
					//call SetDoodadAnimation(Unit(iterator.data()).x, Unit(iterator.data()).y, OCCLUSION_RADIUS, raw[j], false, "stand alternate", false)
					call SetDoodadAnimation(cameraX, cameraY, OCCLUSION_RADIUS, raw[j], false, "stand alternate", false)
					set j = j + 1
				endloop
			//endif
		//	call iterator.next()
		//endloop
		
		//call iterator.destroy()
	endfunction
	
	function EnableTransparency takes nothing returns nothing
		if (Timer == null) then
			set Timer = CreateTimer()
			call TimerStart(Timer, 0.1, true, function periodic)
		endif
		debug call Print("Enable transparency")
	endfunction
	
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
		set units = AIntegerList.create()
		set Timer = CreateTimer()
		call TimerStart(Timer, 0.1, true, function periodic)
	endfunction

endlibrary