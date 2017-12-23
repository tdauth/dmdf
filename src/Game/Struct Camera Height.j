library StructGameCameraHeight requires Asl, StructGameCharacter

	/**
	 * \brief Adjusts the camera height add registered rects to a Z value.
	 * Every rect can be registred using \ref addRect() with a certain height value.
	 * This height value is used to set the player's camera Z offset value when his camera target is in the rect.
	 * This helps certain rects to produce a correct camera Z offset which is otherwise not recognized. For example when a Doodad is
	 * in the air but there is no corresponding cliff level the camera might be too low.
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
			local Character character = 0
			set j = 0
			loop
				exitwhen (j == MapSettings.maxPlayers())
				set character = Character(ACharacter.playerCharacter(Player(i)))
				// make sure it is not always set otherwise the camera might move strangely in class selection or other GUIs
				if (not thistype.m_rects.isEmpty() and not character.isViewEnabled() and ClassSelection.playerClassSelection(Player(i)) == 0 and not AGui.playerGui(Player(i)).isShown() and GetLocalPlayer() == Player(j)) then
					set found = false
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

		/**
		 * Pauses the updating timer and resets the Z offset for all players to 0.
		 * Therefore after calling this method the camera height is not updated anymore for any player.
		 */
		public static method pause takes nothing returns nothing
			call PauseTimer(thistype.m_timer)
			// reset z offset for safety, reset immediately, otherwise it might move in video sequences!
			call SetCameraField(CAMERA_FIELD_ZOFFSET, 0.0, 0.0)
			call StopCamera() // for safety
			call ResetToGameCamera(0.0) // for safety
		endmethod

		/**
		 * Resumes the timer which updates the Z offset of the camera for all players.
		 */
		public static method resume takes nothing returns nothing
			call thistype.start()
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.m_timer = CreateTimer()
			set thistype.m_rects = ARectVector.create()
			set thistype.m_heights = ARealVector.create()
		endmethod

	endstruct

endlibrary