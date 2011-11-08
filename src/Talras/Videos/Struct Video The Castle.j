library StructMapVideosVideoTheCastle requires Asl, StructGameGame

	struct VideoTheCastle extends AVideo

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(12.00)
			call PlayThematicMusic("Music\\TheCastle.mp3")
			call CameraSetupApplyForceDuration(gg_cam_the_castle_0, true, 0.0)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call CameraSetupApplyForceDuration(gg_cam_the_castle_1, true, 10.0)
			if (wait(9.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_castle_2, true, 10.0)
			if (wait(9.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_castle_3, true, 10.0)
			if (wait(9.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_castle_4, true, 10.0)
			if (wait(9.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_castle_5, true, 10.0)
			if (wait(9.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_castle_6, true, 10.0)
			if (wait(9.0)) then
				return
			endif
			//character 0 talks
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call EndThematicMusic()
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary