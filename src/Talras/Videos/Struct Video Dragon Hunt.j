library StructMapVideosVideoDragonHunt requires Asl, StructGameGame

	struct VideoDragonHunt extends AVideo
		private unit m_actorDragonSlayer

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(0.0)
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_0, true, 0.00)
			
			call SetUnitPositionRect(thistype.actor(), gg_rct_video_dragon_hunt_actor)
			call SetUnitFacing(thistype.actor(), 90.0)
			
			set this.m_actorDragonSlayer = thistype.unitActor(thistype.saveUnitActor(Npcs.dragonSlayer()))
			//call SetUnitPositionRect(this.m_actorDragonSlayer, gg_rct_video_dragon_hunt_dragon_slayer) use initial rect
			//call SetUnitFacing(this.m_actorDragonSlayer, 90.0) use initial facing.
			
			
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			if (wait(3.0)) then
				return
			endif
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_1, true, 0.0)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(1.0)) then
				return
			endif
			call SetUnitFacingToFaceUnitTimed(this.m_actorDragonSlayer, thistype.actor(), 4.0)
			
			if (wait(4.0)) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Warte Mensch!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null) + 1.0)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_2, true, 0.0)
			call SetUnitFacingToFaceUnitTimed(thistype.actor(), this.m_actorDragonSlayer, 2.0)
			
			if (wait(2.50)) then
				return
			endif
			
			call IssueRectOrder(thistype.actor(), "move", gg_rct_video_dragon_hunt_actor_target)
			
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_3, true, 4.0)
			
			loop
				exitwhen (RectContainsUnit(gg_rct_video_dragon_hunt_actor_target, thistype.actor()))
				if (wait(1.0)) then
					return
				endif
			endloop
			
			call SetUnitFacingToFaceUnit(this.m_actorDragonSlayer, thistype.actor())
			call SetUnitFacingToFaceUnit(thistype.actor(), this.m_actorDragonSlayer)
			
			call TransmissionFromUnit(thistype.actor(), tr("Was gibt es?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Wer bist du?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_4, true, 0.0)
			
			call TransmissionFromUnit(thistype.actor(), tr("Meine Gefährten und ich ..."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_3, true, 0.0)
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Willst du schlachten, töten, ins Verderben stürzen?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_1, true, 0.0)
			
			call TransmissionFromUnit(thistype.actor(), tr("Was?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_4, true, 0.0)
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Ich kam hierher, aus Tfjahn, dem Königreich der Hochelfen, um einen Drachen zu besiegen. Man sagte mir, in Mittilant, diesem Königreich, gäbe es davon noch wenige. Aber hier habe ich nur stinkende Feldarbeiter und untotes Vieh gefunden."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("In dem Wald dort hinten tummeln sich die Bestien dicht an dicht, aber keine Spur eines Drachen. Das beschäftigt mich schwer, denn ich habe seit Tagen kein Blut mehr gesehen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Interessant."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_3, true, 0.0)
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Ich muss schlachten, ich will alles vernichten, töten, dieses verfluchte Königreich!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_1, true, 0.0)
			
			call TransmissionFromUnit(thistype.actor(), tr("Wieso gehst du nicht in den Wald und tust es? Von uns Menschen hindert dich sicher keiner daran."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_3, true, 0.0)
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Ah! Jede Heldin braucht einen Barden, der ihre Taten an die einfachen Sterblichen weitergibt, denen das Heldentum nicht vergönnt ist. Du, du und deine Gefährten, ihr müsst mich begleiten und der Welt von meinen Taten berichten!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_1, true, 0.0)
			
			call TransmissionFromUnit(thistype.actor(), tr("Aber ansonsten ..."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_4, true, 0.0)
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Erweist mir diesen Gefallen, sodass ich ein letztes Mal Blut an meiner Klinge sehe."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorDragonSlayer = null
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary