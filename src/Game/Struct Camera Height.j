library StructGameCameraHeight requires Asl
	/**
	 * \brief Adjusts the camera height add registered rects to a Z value.
	 */
	struct CameraHeight
		public static real period = 1.0
		private static timer m_timer
		private static ARectVector m_rects
		private static ARealVector m_heights
		
		public static method addRect takes rect whichRect, real height returns nothing
			call thistype.m_rects.pushBack(whichRect)
			call thistype.m_heights.pushBack(height)
		endmethod
		
		private static method timerFunctionUpdateCameraHeight takes nothing returns nothing
			local integer i = 0
			local integer j
			local real height = 0.0
			local boolean found = false
			//debug call Print("run")
			//debug call Print("Terrain cliff level: " + I2S(GetTerrainCliffLevel(GetCameraTargetPositionX(), GetCameraTargetPositionY())) + " with distance " + R2S(GetCameraField(CAMERA_FIELD_ZOFFSET)))
			
			set j = 0
			loop
				exitwhen (j == MapData.maxPlayers)
				if (GetLocalPlayer() == Player(j)) then
					set i = 0
					loop
						exitwhen (i == thistype.m_rects.size() or found)
						set height = thistype.m_heights[i]
						
						if (RectContainsCoords(thistype.m_rects[i], GetCameraTargetPositionX(), GetCameraTargetPositionY())) then
							call SetCameraField(CAMERA_FIELD_ZOFFSET, height, thistype.period)
							debug call Print("Applying height: " + R2S(height))
							set found = true
						endif

						set i = i + 1
					endloop
					
					// reset
					if (not found) then
						call SetCameraField(CAMERA_FIELD_ZOFFSET, 0.0, thistype.period)
					endif
				endif
				set j = j + 1
			endloop
		endmethod
		
		public static method start takes nothing returns nothing
			call TimerStart(thistype.m_timer, thistype.period, true, function thistype.timerFunctionUpdateCameraHeight)
		endmethod
		
		public static method pause takes nothing returns nothing
			call PauseTimer(thistype.m_timer)
		endmethod
		
		public static method resume takes nothing returns nothing
			call TimerStart(thistype.m_timer, thistype.period, true, function thistype.timerFunctionUpdateCameraHeight)
		endmethod
		
		private static method onInit takes nothing returns nothing
			set thistype.m_timer = CreateTimer()
			set thistype.m_rects = ARectVector.create()
			set thistype.m_heights = ARealVector.create()
		endmethod
		
	endstruct
	
endlibrary