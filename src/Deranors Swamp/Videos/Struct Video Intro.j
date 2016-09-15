library StructMapVideosVideoIntro requires Asl, StructGameGame

	struct VideoIntro extends AVideo
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer
		private integer m_actorDeranor

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(0.00)

			call CameraSetupApplyForceDuration(gg_cam_intro_move_0, true, 0.00)

			set this.m_actorWigberht = this.saveUnitActor(Npcs.wigberht())
			set this.m_actorDragonSlayer = this.saveUnitActor(Npcs.dragonSlayer())
			set this.m_actorRicman = this.saveUnitActor(Npcs.ricman())

			call SetUnitPositionRect(this.actor(), gg_rct_video_intro_actor)
			call SetUnitPositionRect(this.unitActor(this.m_actorWigberht), gg_rct_video_intro_wigberht)
			call SetUnitPositionRect(this.unitActor(this.m_actorDragonSlayer), gg_rct_video_intro_dragon_slayer)
			call SetUnitPositionRect(this.unitActor(this.m_actorRicman), gg_rct_video_intro_ricman)

			call SetUnitFacing(this.actor(), 0.0)
			call SetUnitFacing(this.unitActor(this.m_actorWigberht), 0.0)
			call SetUnitFacing(this.unitActor(this.m_actorDragonSlayer), 0.0)
			call SetUnitFacing(this.unitActor(this.m_actorRicman), 0.0)

			// TODO send them to their target rects
			call IssuePointOrder(this.actor(), "move", GetRectCenterX(gg_rct_video_intro_actor_target), GetRectCenterY(gg_rct_video_intro_actor_target))


			call SetSpeechVolumeGroupsBJ()

			call CameraSetupApplyForceDuration(gg_cam_intro_move_1, true, 3.50)
		endmethod

		public stub method onPlayAction takes nothing returns nothing

			if (wait(3.0)) then
				return
			endif

			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_intro_deranor, true, 0.00)
			call Game.fadeInWithWait()

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDragonSlayer), tre("Drachentöterin", "Dragon Slayer"), tre("Wenn ihr dem Weg weiter folgt, kommt ihr zu einem Tor, das von Dämonen bewacht wird. Weiß der Teufel wo wir hier gelandet sind. Ihr solltet erst einmal die Gegend erkunden.", "If you continue to follow the path, you reach a gate which is guarded by demons. The devil knows where we ended up here. You should first explore this area."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()

			// now start the game
			// call by .evaluate() since after the onStopAction() which is also called with .evaluate() there are some further actions
			call MapData.startAfterIntro.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setPlayFilterTime(0.0)
			call this.setActorOwner(MapData.neutralPassivePlayer)

			return this
		endmethod
	endstruct

endlibrary