library StructMapVideosVideoReportManfred requires Asl, StructGameGame

	/**
	 * Uses the same rects as video \ref VideoManfred.
	 */
	struct VideoReportManfred extends AVideo
		private unit m_actorManfred
		private unit m_actorManfredsDog

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_manfred_initial_view, true, 0.0)

			set this.m_actorManfred = this.unitActor(this.saveUnitActor(Npcs.manfred()))
			call SetUnitPositionRect(this.m_actorManfred, gg_rct_video_manfred_manfred)

			set this.m_actorManfredsDog = this.unitActor(this.saveUnitActor(Npcs.manfredsDog()))
			call SetUnitPositionRect(this.m_actorManfredsDog, gg_rct_video_manfred_dog)

			call SetUnitPositionRect(this.actor(), gg_rct_video_manfred_actor)

			call SetUnitFacingToFaceUnit(this.actor(), this.m_actorManfred)
			call SetUnitFacingToFaceUnit(this.m_actorManfred, this.actor())
			call SetUnitFacingToFaceUnit(this.m_actorManfredsDog, this.actor())
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_manfred_initial_view)

			call TransmissionFromUnit(this.actor(), tre("Die Kornfresser sind tot.", "The corn eaters are dead."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.m_actorManfred, tre("Manfred", "Manfred"), tre("Sehr gut! Damit hast du mir einen großen Gefallen erwiesen. Warte bis ich die Nahrung aufgeladen habe. Du kannst sie dann mitnehmen. Erteilt diesen verdammten Orks und Dunkelelfen eine ordentliche Lektion. Ich hoffe sie lassen sich dann nicht mehr hier blicken.", "Very good! Thus you have done me a great favor. Wait until I have loaded the food up. You can take it then. Let those damn Orcs and Dark Elves learn their lesson. I hope they won't show up anymore after that."), gg_snd_Manfred39)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Manfred39))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorManfred = null
			set this.m_actorManfredsDog = null

			call Game.resetVideoSettings()

			call QuestWarSupplyFromManfred.quest.evaluate().questItem.evaluate(QuestWarSupplyFromManfred.questItemReportManfred).setState(QuestWarSupplyFromManfred.stateCompleted) // don't complete, otherwise the update message is shown twice
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary