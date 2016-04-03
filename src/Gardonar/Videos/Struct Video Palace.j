library StructMapVideosVideoPalace requires Asl, StructGameGame

	struct VideoPalace extends AVideo

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(6.00)
			
			call CameraSetupApplyForceDuration(gg_cam_the_gate_0, true, 0.00)
			call CameraSetupApplyForceDuration(gg_cam_the_gate_1, true, 4.00)
			call SetSpeechVolumeGroupsBJ()
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			if (wait(3.50)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_gate_2, true, 4.00)
			if (wait(3.50)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_gate_3, true, 4.00)
			if (wait(3.50)) then
				return
			endif
			// Die Wächterinnen machen sich über die Ankömmlinge lustig, lassen sie aber passieren
			if (wait(3.50)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_gate_4, true, 4.00)
			if (wait(3.50)) then
				return
			endif
			if (wait(3.50)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_gate_5, true, 0.00)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_gate_6, true, 1.50)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_gate_7, true, 1.50)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_gate_8, true, 1.50)
			if (wait(2.0)) then
				return
			endif
		
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapData.neutralPassivePlayer)
			
			return this
		endmethod
	endstruct

endlibrary