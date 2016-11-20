library StructMapVideosVideoBjoern requires Asl, StructGameGame

	struct VideoBjoern extends AVideo
		private unit m_actorBjoern
		private unit m_actorBjoernsWife

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_bjoern_initial_view, true, 0.0)

			set this.m_actorBjoern = this.unitActor(this.saveUnitActor(Npcs.bjoern()))
			call SetUnitPositionRect(this.m_actorBjoern, gg_rct_video_bjoern_bjoern)

			set this.m_actorBjoernsWife = this.unitActor(this.saveUnitActor(Npcs.bjoernsWife()))
			call SetUnitPositionRect(this.m_actorBjoernsWife, gg_rct_video_bjoern_bjoerns_wife)

			call SetUnitPositionRect(this.actor(), gg_rct_video_bjoern_actor)

			call SetUnitFacingToFaceUnit(this.actor(), this.m_actorBjoern)
			call SetUnitFacingToFaceUnit(this.m_actorBjoern, this.actor())
			call SetUnitFacingToFaceUnit(this.m_actorBjoernsWife, this.actor())
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_bjoern_initial_view)

			call TransmissionFromUnit(this.actor(), tre("Jäger Björn!", "Hunter Björn!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorBjoern, tre("Was gibt es?", "What is it?"), gg_snd_Bjoern67)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Bjoern67))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Der Herzog benötigt Fallen zur Verteidigung eines Außenpostens.", "The duke needs traps for the defense of an outpost."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorBjoern, tre("Ist es etwa schon soweit? Ist der Feind so nah?", "Has the time already come? Is the enemy so close?"), gg_snd_Bjoern68)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Bjoern68))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Ja uns bleibt keine Zeit mehr!", "Yes we have no more time!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorBjoern, tre("Verdammt! Ich werde dir so viele Fallen geben wie du brauchst. Hoffentlich besiegen wir diesen verfluchten Feind so bald wie möglich. Meine Frau macht sich schon Sorgen.", "Damn it! I will give you as many traps as you need. Hopefully we defeat this cursed enemy as soon as possible. My wife is already worried."), gg_snd_Bjoern69)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Bjoern69))) then
				return
			endif


			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorBjoern = null
			set this.m_actorBjoernsWife = null

			call Game.resetVideoSettings()
			call QuestWarTrapsFromBjoern.quest.evaluate().enablePlaceTraps.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary