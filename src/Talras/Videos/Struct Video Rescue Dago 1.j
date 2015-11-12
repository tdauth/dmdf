library StructMapVideosVideoRescueDago1 requires Asl, StructGameGame, StructMapMapFellows, StructMapMapNpcs, StructMapQuestsQuestRescueDago

	struct VideoRescueDago1 extends AVideo
		private unit m_actorBear0
		private unit m_actorBear1
		private unit m_actorDago

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call Game.setDefaultMapMusic()

			// bears
			set this.m_actorBear0 = thistype.unitActor(thistype.saveUnitActor(gg_unit_n008_0083))
			call SetUnitPositionRect(this.m_actorBear0, gg_rct_video_rescue_dago_bear_0_position)
			call SetUnitFacing(this.m_actorBear0, 56.02)
			call UnitSuspendDecay(this.m_actorBear0, true)
			call SetUnitLifeBJ(this.m_actorBear0, 0.0)

			set this.m_actorBear1 = thistype.unitActor(thistype.saveUnitActor(gg_unit_n008_0027))
			call SetUnitPositionRect(this.m_actorBear1, gg_rct_video_rescue_dago_bear_1_position)
			call SetUnitFacing(this.m_actorBear1, 116.66)
			call UnitSuspendDecay(this.m_actorBear1, true)
			call SetUnitLifeBJ(this.m_actorBear1, 0.0)



			// Dago
			set this.m_actorDago = thistype.unitActor(thistype.saveUnitActor(Npcs.dago()))
			call SetUnitPositionRect(this.m_actorDago, gg_rct_video_rescue_dago_dagos_position)
			call SetUnitOwner(this.m_actorDago, Player(PLAYER_NEUTRAL_PASSIVE), true) // change owner since he's shared

			// actor
			call SetUnitPositionRect(thistype.actor(), gg_rct_video_rescue_dago_actors_position)

			call SetUnitFacingToFaceUnit(this.m_actorDago, thistype.actor())
			call SetUnitFacingToFaceUnit(thistype.actor(), this.m_actorDago)

			call CameraSetupApplyForceDuration(gg_cam_rescue_dago_2, true, 0.0)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			// fade delay to skip death animations of bears!!!
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 0.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif


			call TransmissionFromUnitWithName(this.m_actorDago, tre("Dago", "Dago"), tre("Danke, dass Ihr mir geholfen habt! Diese Scheißbären können einen den Kopf kosten, wenn man nicht aufpasst. Aber sagt mal, wer seid ihr überhaupt?", "Thank you for helping me! This damned bears can cost somebody their head if you are not careful. Who are you, anyway?"), gg_snd_DagoRescueDago2)
			if (wait(GetSimpleTransmissionDuration(gg_snd_DagoRescueDago2))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_rescue_dago_3, true, 0.0)
			call TransmissionFromUnit(thistype.actor(), tre("Wir sind Söldner aus dem Süden, auf dem Weg nach Talras.", "We are mercenaries from the south on the way to Talras."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_rescue_dago_2, true, 0.0)
			call TransmissionFromUnitWithName(this.m_actorDago, tre("Dago", "Dago"), tre("Süden? Na da wärt ihr wohl besser geblieben, jetzt da wohl erneut ein Krieg ausbrechen wird. Aber gut, ihr seid ja Söldner.", "South? You should better have stayed there now that probably there will be war again. But anyway, you are mercenaries."), gg_snd_DagoRescueDago3)
			if (wait(GetSimpleTransmissionDuration(gg_snd_DagoRescueDago3))) then
				return
			endif
			call TransmissionFromUnitWithName(this.m_actorDago, tre("Dago", "Dago"), tre("Mein Name ist übrigens Dago. Ich komme aus Talras und bin Jäger, wie man unschwer erkennen kann. Eigentlich sollte ich ein Tier für den Herzog erlegen.", "By the way, may name is Dago. I am from Talras and I am a hunter as you can easily see. Actually, I should hunt down an animal for the duke."), gg_snd_DagoRescueDago4)
			if (wait(GetSimpleTransmissionDuration(gg_snd_DagoRescueDago4))) then
				return
			endif
			call TransmissionFromUnitWithName(this.m_actorDago, tre("Dago", "Dago"), tre("Mit den beiden Pelzviechern hier ist mir mehr als genug geholfen! Also trödeln wir nicht lange herum. Folgt mir einfach, ich führe euch zum Burgeingang.", "These two fur animals are more than enough help to me! So do not waste much time. Just follow me, I lead you to the castle's gate."), gg_snd_DagoRescueDago5)
			if (wait(GetSimpleTransmissionDuration(gg_snd_DagoRescueDago5))) then
				return
			endif
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorBear0 = null
			set this.m_actorBear1 = null
			set this.m_actorDago = null

			// remove bear corpses
			call RemoveUnit(gg_unit_n008_0083)
			set gg_unit_n008_0083 = null
			call RemoveUnit(gg_unit_n008_0027)
			set gg_unit_n008_0027 = null

			call Fellows.dago().reset()
			call Fellows.dago().destroy()

			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setFadeIn(false) // don't fade in to skip death of bears
			return this
		endmethod
	endstruct

endlibrary