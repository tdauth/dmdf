library StructMapVideosVideoRescueDago0 requires Asl, StructGameGame, StructGameTutorial, StructMapMapFellows, StructMapMapNpcs, StructMapQuestsQuestRescueDago

	struct VideoRescueDago0 extends AVideo
		private unit m_actorBear0
		private unit m_actorBear1
		private unit m_actorDago
		private trigger m_damageTrigger

		private static method triggerConditionDamage takes nothing returns nothing
			call SetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE, GetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE) + GetEventDamage())
		endmethod

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call CameraSetupApplyForceDuration(gg_cam_rescue_dago_0, true, 0.0)
			//call PlayThematicMusic("Music\\RescueDago.mp3")

			call PlayThematicMusic("Sound\\Music\\mp3Music\\PursuitTheme.mp3")

			// bears
			set this.m_actorBear0 = this.unitActor(this.saveUnitActor(gg_unit_n008_0083))
			call IssueImmediateOrder(this.m_actorBear0, "stop")
			call SetUnitInvulnerable(this.m_actorBear0, false)
			//call SetUnitMoveSpeed(this.m_actorBear0, 150.0)
			set this.m_actorBear1 = this.unitActor(this.saveUnitActor(gg_unit_n008_0027))
			call IssueImmediateOrder(this.m_actorBear1, "stop")
			call SetUnitInvulnerable(this.m_actorBear1, false)
			//call SetUnitMoveSpeed(this.m_actorBear1, 150.0)

			// Dago
			set this.m_actorDago = this.unitActor(this.saveUnitActor(Npcs.dago()))
			call IssueImmediateOrder(this.m_actorDago, "stop")
			call SetUnitInvulnerable(this.m_actorDago, false)

			call ShowUnit(this.actor(), false)
			call SetUnitInvulnerable(this.actor(), true)
			call PauseUnit(this.actor(), true)

			set this.m_damageTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_damageTrigger, this.m_actorBear0, EVENT_UNIT_DAMAGED)
			call TriggerRegisterUnitEvent(this.m_damageTrigger, this.m_actorBear1, EVENT_UNIT_DAMAGED)
			call TriggerRegisterUnitEvent(this.m_damageTrigger, this.m_actorDago, EVENT_UNIT_DAMAGED)
			call TriggerAddCondition(this.m_damageTrigger, Condition(function thistype.triggerConditionDamage))

			call IssueTargetOrder(this.m_actorBear0, "attack", this.m_actorDago)
			call IssueTargetOrder(this.m_actorBear1, "attack", this.m_actorDago)
			call IssueTargetOrder(this.m_actorDago, "attack", this.m_actorBear0)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_rescue_dago_0)

			call PlaySoundBJ(gg_snd_GrizzlyBearReady1)
			if (wait(1.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_rescue_dago_1, true, 0.0)
			if (wait(1.0)) then
				return
			endif
			call TransmissionFromUnitWithName(this.m_actorDago, tre("Dago", "Dago"), tre("Verdammte Mistviecher!", "Damned animals!"), gg_snd_DagoRescueDago1)
			if (wait(GetSimpleTransmissionDuration(gg_snd_DagoRescueDago1))) then
				return
			endif
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorBear0 = null
			set this.m_actorBear1 = null
			set this.m_actorDago = null
			if (this.m_damageTrigger != null) then
				call DestroyTrigger(this.m_damageTrigger)
				set this.m_damageTrigger = null
			endif

			call QuestRescueDago.quest().questItem(0).setState(AAbstractQuest.stateNew)

			call PauseUnit(Npcs.dago(), false)
			call Fellows.dago().shareWith(0)
			call Tutorial.printTip(tre("Dago kann nun von allen Spielern gemeinsam kontrolliert werden. Es gibt verschiedene Gefährten, die sich im Spielverlauf anschließen und die Gruppe wieder verlassen.", "Dago can now be controlled by all players together. There is different fellows who join you during the game and then leave the group again."))

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

			call Game.resetVideoSettings()

			call PanCameraToTimedUnit(Npcs.dago(), 0.0)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())
			call PauseUnit(Npcs.dago(), true)
			call SetUnitInvulnerable(Npcs.dago(), true)
			call PauseUnit(gg_unit_n008_0083, true)
			call SetUnitInvulnerable(gg_unit_n008_0083, true)
			call PauseUnit(gg_unit_n008_0027, true)
			call SetUnitInvulnerable(gg_unit_n008_0027, true)

			return this
		endmethod

		implement Video
	endstruct

endlibrary