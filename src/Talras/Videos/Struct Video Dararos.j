library StructMapVideosVideoDararos requires Asl, StructGameGame

	// TODO Dararos erscheint mit einer Armee von Hochelfen im letzten Moment.
	struct VideoDararos extends AVideo
		private integer m_actorHeimrich
		private integer m_actorMarkward
		private integer m_actorOsman
		private integer m_actorFerdinand
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(24.0)
			call CameraSetupApplyForceDuration(gg_cam_dararos_0, true, 0.0)
			call CameraSetupApplyForceDuration(gg_cam_dararos_1, true, 4.0)
			
			// TODO the final ultimate battle
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			
			if (wait(2.0)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_dararos_2, true, 4.0)
			
			if (wait(3.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_dararos_3, true, 4.0)
			
			if (wait(3.50)) then
				return
			endif
			
			// TODO arrival of the highelves
			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary