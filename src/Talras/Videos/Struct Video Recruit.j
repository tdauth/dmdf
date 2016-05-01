library StructMapVideosVideoRecruit requires Asl, StructGameGame

	struct VideoRecruit extends AVideo
		private unit m_actorFerdinand
		private unit m_actorManfred
		private unit m_actorGuard0
		private unit m_actorGuard1
		private unit m_actorGuard2
		private unit m_actorWorker0
		private unit m_actorWorker1
		private unit m_actorWorker2
		private unit m_actorWorker3
		private unit m_actorWorker4

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_recruit_initial_view, true, 0.0)

			set this.m_actorFerdinand = this.unitActor(this.saveUnitActor(Npcs.ferdinand()))
			call SetUnitPositionRect(this.m_actorFerdinand, gg_rct_video_recruit_ferdinand)
			
			set this.m_actorManfred = this.unitActor(this.saveUnitActor(Npcs.manfred()))
			call SetUnitPositionRect(this.m_actorManfred, gg_rct_video_recruit_manfred)
			
			set this.m_actorGuard0 = this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n015', gg_rct_video_recruit_guard_0, 90.0))
			set this.m_actorGuard1 = this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n015', gg_rct_video_recruit_guard_1, 90.0))
			set this.m_actorGuard2 = this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n015', gg_rct_video_recruit_guard_2, 90.0))
			
			set this.m_actorWorker0 = this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n02J', gg_rct_video_recruit_worker_0, 90.0))
			set this.m_actorWorker1 = this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n02J', gg_rct_video_recruit_worker_1, 90.0))
			set this.m_actorWorker2 = this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n02J', gg_rct_video_recruit_worker_2, 90.0))
			set this.m_actorWorker3 = this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n02J', gg_rct_video_recruit_worker_3, 90.0))
			set this.m_actorWorker4 = this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n02J', gg_rct_video_recruit_worker_4, 90.0))

			call SetUnitPositionRect(this.actor(), gg_rct_video_recruit_actor)
			
			call SetUnitFacingToFaceUnit(this.m_actorFerdinand, this.m_actorManfred)
			call SetUnitFacingToFaceUnit(this.actor(), this.m_actorManfred)
			call SetUnitFacingToFaceUnit(this.m_actorManfred, this.m_actorFerdinand)
			call SetUnitFacingToFaceUnit(this.m_actorWorker0, this.m_actorFerdinand)
			call SetUnitFacingToFaceUnit(this.m_actorWorker1, this.m_actorFerdinand)
			call SetUnitFacingToFaceUnit(this.m_actorWorker2, this.m_actorFerdinand)
			call SetUnitFacingToFaceUnit(this.m_actorWorker3, this.m_actorFerdinand)
			call SetUnitFacingToFaceUnit(this.m_actorWorker4, this.m_actorFerdinand)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
		
			call TransmissionFromUnit(this.m_actorFerdinand, tr("Hört mich an Bauern!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorFerdinand, tr("Die Zeit ist nun gekommen da der Herzog eure Dienste einfordert. Lange Zeit durftet ihr wie König leben vom Lande eures Herzogs. Er ließ euch teilhaben an seinem Reichtum und ihr konntet in Frieden leben."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorManfred, tr("Heuchler!"), null)
			call QueueUnitAnimation(this.m_actorManfred, "Attack First")
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorWorker0, tr("Scharlatan!"), null)
			call QueueUnitAnimation(this.m_actorWorker0, "Attack")
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			// TODO Obst werfen!
			
			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_recruit_0, true, 0.0)
			call CameraSetupApplyForceDuration(gg_cam_recruit_1, true, 10.0)
			call Game.fadeInWithWait()
			
			call TransmissionFromUnit(this.m_actorFerdinand, tr("Das ist ja unerhört! Ich verbitte mir das oder wollt ihr etwa am Pranger landen? Das gemeine Volk taugt eben nichts. Sie beschweren sich immerzu."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorFerdinand, tr("Wie dem auch sei, der Herzog fordert eure Dienste ein! Meldet euch freiwillig oder ihr werden mit Gewalt dazu gebracht, eure Pflicht zu erfüllen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorFerdinand = null
			set this.m_actorManfred = null

			call Game.resetVideoSettings()
			call QuestWarRecruit.quest.evaluate().enableGetRecruits.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapData.neutralPassivePlayer)
			
			return this
		endmethod
	endstruct

endlibrary