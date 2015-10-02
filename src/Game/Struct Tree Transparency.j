// http://www.hiveworkshop.com/forums/triggers-scripts-269/tree-transparency-270310/#post2736405
library StructGameTreeTransparency initializer init requires Asl

	globals
		 private constant real OCCLUSION_RADIUS = 150 //defines the radius around the unit in which doodads are occluded
		private constant real CAMERA_TARGET_RADIUS = 1000 //defines the radius around the camera target in which doodads are occluded

		private integer array raw
		private integer rawcount = 0
		private real array X
		private real array Y
		private unit array U
		private integer unitcount = 0
	endglobals

	function AddDoodadOcclusion takes integer rawcode returns nothing
		set raw[rawcount] = rawcode
		set rawcount = rawcount+1
	endfunction

	function AddUnitOcclusion takes unit u returns nothing
		set U[unitcount] = u
		set unitcount = unitcount+1
	endfunction

	private function periodic takes nothing returns nothing
		 local integer i = 0
		local integer j
		local real camX = GetCameraTargetPositionX()
		local real camY = GetCameraTargetPositionY()
		loop
			exitwhen i >= unitcount
			set j = 0
			loop
				exitwhen j >= rawcount
				call SetDoodadAnimation(X[i], Y[i], OCCLUSION_RADIUS, raw[j], false, "stand", false)
				set j = j+1
			endloop
			set i = i+1
		endloop
		set i = 0
		loop
			exitwhen i >= unitcount
			if GetUnitTypeId(U[i]) == 0 then
				//clean up removed units
				set unitcount = unitcount-1
				set U[i] = U[unitcount]
				set X[i] = X[unitcount]
				set Y[i] = Y[unitcount]
				set U[unitcount] = null
				set X[unitcount] = 0
				set Y[unitcount] = 0
				set i = i-1
				else
				if IsUnitInRangeXY(U[i], camX, camY, CAMERA_TARGET_RADIUS) then
					if GetUnitX(U[i]) != X[i] or GetUnitY(U[i]) != Y[i] then
						set X[i] = GetUnitX(U[i])
						set Y[i] = GetUnitY(U[i])
						set j = 0
						loop
							exitwhen j >= rawcount
							call SetDoodadAnimation(X[i], Y[i], OCCLUSION_RADIUS, raw[j], false, "stand alternate", false)
							set j = j+1
						endloop
					endif
				endif
			endif
			set i = i+1
		endloop
	endfunction

	private function init takes nothing returns nothing
		call TimerStart(CreateTimer(), 2.0, true, function periodic)
	endfunction

endlibrary