library StructMapVideosVideoWieland requires Asl, StructGameGame

	struct VideoWieland extends AVideo
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
			call SetUnitAnimation(this.m_actorWieland, "Attack First")

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
			

			if (wait(1.0)) then
				return
			endif
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_wieland_wieland_view, true, 0.0)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorWieland, tr("Was gibt es?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Der Herzog braucht Waffen für einen eroberten Außenposten der Orks und Dunkelelfen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			// TODO Finish dialog, drum cave iron.

			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorWieland = null

			call Game.resetVideoSettings()
			call QuestWar.quest.evaluate().enableIronFromTheDrumCave.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary