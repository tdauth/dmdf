library StructMapVideosVideoIntro requires Asl, StructGameGame

	struct VideoIntro extends AVideo
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(6.00)

			call CameraSetupApplyForceDuration(gg_cam_intro_0, true, 0.00)

			set this.m_actorWigberht = this.saveUnitActor(Npcs.wigberht())
			set this.m_actorDragonSlayer = this.saveUnitActor(Npcs.dragonSlayer())
			set this.m_actorRicman = this.saveUnitActor(Npcs.ricman())

			call SetUnitPositionRect(this.actor(), gg_rct_video_intro_actor)

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorWigberht), this.actor())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorDragonSlayer), this.actor())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorRicman), this.actor())

			call SetUnitFacingToFaceUnit(this.actor(), this.unitActor(this.m_actorRicman))


			call SetSpeechVolumeGroupsBJ()
		endmethod

		public stub method onPlayAction takes nothing returns nothing

			if (wait(2.0)) then
				return
			endif

			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_intro_1, true, 0.00)
			call Game.fadeInWithWait()

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDragonSlayer), tre("Drachentöterin", "Dragon Slayer"), tre("Wenn ihr dem Weg weiter folgt, kommt ihr zu einem Tor, das von Dämonen bewacht wird. Weiß der Teufel wo wir hier gelandet sind. Ihr solltet erst einmal die Gegend erkunden.", "If you continue to follow the path, you reach a gate which is guarded by demons. The devil knows where we ended up here. You should first explore this area."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorWigberht), tre("Wigberht", "Wigberht"), tr("Unser Boot können wir nicht weiter benutzen. Daher müsst ihr einen Weg über Land finden. Ich bezweifle jedoch, dass wir einfach so wieder in unsere Welt zurückgelangen."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorWigberht), tre("Wigberht", "Wigberht"), tr("Wir stehen euch natürlich jederzeit zur Verfügung."), null)

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
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod
	endstruct

endlibrary