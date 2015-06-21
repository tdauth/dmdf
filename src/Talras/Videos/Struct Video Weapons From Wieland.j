library StructMapVideosVideoWeaponsFromWieland requires Asl, StructGameGame

	struct VideoWeaponsFromWieland extends AVideo
		private unit m_actorWieland

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_wieland_forge_view, true, 0.0)

			set this.m_actorWieland = thistype.unitActor(thistype.saveUnitActor(Npcs.wieland()))
			call SetUnitPositionRect(this.m_actorWieland, gg_rct_video_wieland_wieland)
			call SetUnitFacing(this.m_actorWieland, 227.57)
			call QueueUnitAnimation(this.m_actorWieland, "Attack First")

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_wieland_actor)
			call SetUnitFacingToFaceUnit(thistype.actor(), this.m_actorWieland)
			call IssueRectOrder(thistype.actor(), "move", gg_rct_video_wieland_actor_target)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			loop
				exitwhen (RectContainsUnit(gg_rct_video_wieland_actor_target, thistype.actor()))
				if (wait(1.0)) then
					return
				endif
			endloop
		
			call TransmissionFromUnit(thistype.actor(), tr("Schmied Wieland!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call ResetUnitAnimation(this.m_actorWieland)
			call SetUnitFacingToFaceUnit(this.m_actorWieland, thistype.actor())
			
			// TODO Finish dialog, drum cave iron.

			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorWieland = null

			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary