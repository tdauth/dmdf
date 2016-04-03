library StructMapVideosVideoWelcome requires Asl, StructGameGame

	struct VideoWelcome extends AVideo

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(6.00)
			
			call CameraSetupApplyForceDuration(gg_cam_welcome_0, true, 0.00)
		endmethod

		public stub method onPlayAction takes nothing returns nothing

			if (wait(4.0)) then
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