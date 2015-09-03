library StructMapVideosVideoBjoern requires Asl, StructGameGame

	struct VideoBjoern extends AVideo
		private unit m_actorBjoern
		private unit m_actorBjoernsWife

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_bjoern_initial_view, true, 0.0)

			set this.m_actorBjoern = thistype.unitActor(thistype.saveUnitActor(Npcs.bjoern()))
			call SetUnitPositionRect(this.m_actorBjoern, gg_rct_video_bjoern_bjoern)
			
			set this.m_actorBjoernsWife = thistype.unitActor(thistype.saveUnitActor(Npcs.bjoernsWife()))
			call SetUnitPositionRect(this.m_actorBjoernsWife, gg_rct_video_bjoern_bjoerns_wife)

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_bjoern_actor)
			
			call SetUnitFacingToFaceUnit(thistype.actor(), this.m_actorBjoern)
			call SetUnitFacingToFaceUnit(this.m_actorBjoern, thistype.actor())
			call SetUnitFacingToFaceUnit(this.m_actorBjoernsWife, thistype.actor())
		endmethod

		public stub method onPlayAction takes nothing returns nothing
		
			call TransmissionFromUnit(thistype.actor(), tr("Jäger Björn!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorBjoern, tr("Was gibt es?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorBjoern, tr("Der Herzog benötigt Fallen zur Verteidigung eines Außenpostens."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorBjoern, tr("Ist es etwa schon soweit? Ist der Feind so nah?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorBjoern, tr("Ja uns bleibt keine Zeit mehr!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorBjoern, tr("Verdammt! Ich werde so viele Fallen geben wie du brauchst. Hoffentlich besiegen wir diesen verfluchten Feind so bald wie möglich. Meine Frau macht sich schon Sorgen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorBjoern = null
			set this.m_actorBjoernsWife = null

			call Game.resetVideoSettings()
			call QuestWar.quest.evaluate().enablePlaceTraps.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary