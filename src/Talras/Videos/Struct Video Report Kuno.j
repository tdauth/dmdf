library StructMapVideosVideoReportKuno requires Asl, StructGameGame

	struct VideoReportKuno extends AVideo
		private unit m_actorKuno
		private unit m_actorKunosDaughter

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_kuno_initial_view, true, 0.0)

			set this.m_actorKuno = this.unitActor(this.saveUnitActor(Npcs.kuno()))
			call SetUnitPositionRect(this.m_actorKuno, gg_rct_video_kuno_kuno)
			
			set this.m_actorKunosDaughter = this.unitActor(this.saveUnitActor(Npcs.kunosDaughter()))
			call SetUnitPositionRect(this.m_actorKunosDaughter, gg_rct_video_kuno_kunos_daughter)

			call SetUnitPositionRect(this.actor(), gg_rct_video_kuno_actor)
			
			call SetUnitFacingToFaceUnit(this.actor(), this.m_actorKuno)
			call SetUnitFacingToFaceUnit(this.m_actorKuno, this.actor())
			call SetUnitFacingToFaceUnit(this.m_actorKunosDaughter, this.actor())
		endmethod

		public stub method onPlayAction takes nothing returns nothing
		
			call TransmissionFromUnit(this.actor(), tr("Holzfäller Kuno!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.actor(), tr("Die Hexen sind tot."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorKuno, tr("Kuno"), tr("Ich danke euch vielmahls. Endlich kann ich wieder ruhig schlafen. Ich werde das Holz für euch aufladen."), gg_snd_Kuno38)
			
			if (wait(GetSimpleTransmissionDuration(gg_snd_Kuno38))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorKuno, tr("Kuno"), tr("Hoffen wir dass der Herzog im Stande ist den Feind aufzuhalten. Noch mehr Unruhe kann ich nicht gebrauchen."), gg_snd_Kuno39)
			
			if (wait(GetSimpleTransmissionDuration(gg_snd_Kuno39))) then
				return
			endif
			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorKuno = null
			set this.m_actorKunosDaughter = null

			call Game.resetVideoSettings()
			call QuestWarLumberFromKuno.quest.evaluate().enableMoveKunosLumberToTheCamp.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapData.neutralPassivePlayer)
			
			return this
		endmethod
	endstruct

endlibrary