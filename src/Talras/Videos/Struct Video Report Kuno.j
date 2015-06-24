library StructMapVideosVideoReportKuno requires Asl, StructGameGame

	struct VideoReportKuno extends AVideo
		private unit m_actorKuno
		private unit m_actorKunosDaughter

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_kuno_initial_view, true, 0.0)

			set this.m_actorKuno = thistype.unitActor(thistype.saveUnitActor(Npcs.kuno()))
			call SetUnitPositionRect(this.m_actorKuno, gg_rct_video_kuno_kuno)
			
			set this.m_actorKunosDaughter = thistype.unitActor(thistype.saveUnitActor(Npcs.kunosDaughter()))
			call SetUnitPositionRect(this.m_actorKunosDaughter, gg_rct_video_kuno_kunos_daughter)

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_kuno_actor)
			
			call SetUnitFacingToFaceUnit(thistype.actor(), this.m_actorKuno)
			call SetUnitFacingToFaceUnit(this.m_actorKuno, thistype.actor())
			call SetUnitFacingToFaceUnit(this.m_actorKunosDaughter, thistype.actor())
		endmethod

		public stub method onPlayAction takes nothing returns nothing
		
			call TransmissionFromUnit(thistype.actor(), tr("Holzfäller Kuno!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorKuno = null
			set this.m_actorKunosDaughter = null

			call Game.resetVideoSettings()
			call QuestWar.quest.evaluate().enableMoveKunosLumberToTheCamp.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary