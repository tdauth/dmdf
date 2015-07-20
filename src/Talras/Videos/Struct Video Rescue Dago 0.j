library StructMapVideosVideoRescueDago0 requires Asl, StructGameGame, StructGameTutorial, StructMapMapFellows, StructMapMapNpcs, StructMapQuestsQuestRescueDago

	struct VideoRescueDago0 extends AVideo
		private unit m_actorBear0
		private unit m_actorBear1
		private unit m_actorDago

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call CameraSetupApplyForceDuration(gg_cam_rescue_dago_0, true, 0.0)
			call PlayThematicMusic("Music\\RescueDago.mp3")

			// bears
			set this.m_actorBear0 = thistype.unitActor(thistype.saveUnitActor(gg_unit_n008_0083))
			call PauseUnit(this.m_actorBear0, true)
			set this.m_actorBear1 = thistype.unitActor(thistype.saveUnitActor(gg_unit_n008_0027))
			call PauseUnit(this.m_actorBear1, true)

			// Dago
			set this.m_actorDago = thistype.unitActor(thistype.saveUnitActor(Npcs.dago()))
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			if (wait(1.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_rescue_dago_1, true, 0.0)
			if (wait(1.0)) then
				return
			endif
			call TransmissionFromUnitWithName(this.m_actorDago, tr("Dago"), tr("Verdammte Mistviecher!"), gg_snd_DagoRescueDago1)
			if (wait(GetSimpleTransmissionDuration(gg_snd_DagoRescueDago1))) then
				return
			endif
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorBear0 = null
			set this.m_actorBear1 = null
			set this.m_actorDago = null

			call QuestRescueDago.quest().questItem(0).setState(AAbstractQuest.stateNew)

			call PauseUnit(Npcs.dago(), false)
			call Fellows.dago().shareWith(0)
			call Tutorial.printTip(tr("Dago kann nun von allen Spielern gemeinsam kontrolliert werden. Es gibt verschiedene Gefährten, die sich im Spielverlauf anschließen und die Gruppe wieder verlassen."))

			// bears
			call SetUnitOwner(gg_unit_n008_0083, Player(PLAYER_NEUTRAL_AGGRESSIVE), false)
			call PauseUnit(gg_unit_n008_0083, false)
			call SetUnitInvulnerable(gg_unit_n008_0083, false)
			call SetUnitOwner(gg_unit_n008_0027, Player(PLAYER_NEUTRAL_AGGRESSIVE), false)
			call PauseUnit(gg_unit_n008_0027, false)
			call SetUnitInvulnerable(gg_unit_n008_0027, false)
			call IssueTargetOrder(Npcs.dago(), "attack", gg_unit_n008_0083)
			call IssueTargetOrder(gg_unit_n008_0083, "attack", Npcs.dago())
			call IssueTargetOrder(gg_unit_n008_0027, "attack", Npcs.dago())
			call EndThematicMusic()

			call Game.resetVideoSettings()

			call PanCameraToTimedUnit(Npcs.dago(), 0.0)
		endmethod

		private static method create takes nothing returns thistype
			call PauseUnit(Npcs.dago(), true)
			call SetUnitInvulnerable(Npcs.dago(), true)
			call PauseUnit(gg_unit_n008_0083, true)
			call SetUnitInvulnerable(gg_unit_n008_0083, true)
			call PauseUnit(gg_unit_n008_0027, true)
			call SetUnitInvulnerable(gg_unit_n008_0027, true)
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary