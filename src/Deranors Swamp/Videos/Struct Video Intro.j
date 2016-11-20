library StructMapVideosVideoIntro requires Asl, StructGameGame

	struct VideoIntro extends AVideo
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer
		private integer m_actorDeranor
		private weathereffect array m_weatherEffect[4]
		private effect m_effect

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

			// send them to their target rects
			call IssuePointOrder(this.actor(), "move", GetRectCenterX(gg_rct_video_intro_actor_target), GetRectCenterY(gg_rct_video_intro_actor_target))
			call IssuePointOrder(this.unitActor(this.m_actorWigberht), "move", GetRectCenterX(gg_rct_video_intro_wigberht_target), GetRectCenterY(gg_rct_video_intro_wigberht_target))
			call IssuePointOrder(this.unitActor(this.m_actorDragonSlayer), "move", GetRectCenterX(gg_rct_video_intro_dragon_slayer_target), GetRectCenterY(gg_rct_video_intro_dragon_slayer_target))
			call IssuePointOrder(this.unitActor(this.m_actorRicman), "move", GetRectCenterX(gg_rct_video_intro_ricman_target), GetRectCenterY(gg_rct_video_intro_ricman_target))


			set this.m_weatherEffect[0] = AddWeatherEffect(gg_rct_quest_gate_activator_0_weather, 'MEds')
			call EnableWeatherEffect(this.m_weatherEffect[0], true)
			set this.m_weatherEffect[1] = AddWeatherEffect(gg_rct_quest_gate_activator_1_weather, 'MEds')
			call EnableWeatherEffect(this.m_weatherEffect[1], true)
			set this.m_weatherEffect[2] = AddWeatherEffect(gg_rct_quest_gate_activator_2_weather, 'MEds')
			call EnableWeatherEffect(this.m_weatherEffect[2], true)
			set this.m_weatherEffect[3] = AddWeatherEffect(gg_rct_quest_gate_weather, 'MEds')
			call EnableWeatherEffect(this.m_weatherEffect[3], true)

			call SetSpeechVolumeGroupsBJ()

			call CameraSetupApplyForceDuration(gg_cam_intro_move_1, true, 3.50)
		endmethod

		private static method conditionActorIsInTargetRect takes thistype this returns boolean
			return RectContainsUnit(gg_rct_video_intro_actor_target, this.actor())
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			local effect whichEffect = null

			if (wait(3.0)) then
				return
			endif

			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_intro_deranor, true, 0.00)
			call Game.fadeInWithWait()

			if (waitForCondition(1.0, thistype.conditionActorIsInTargetRect)) then
				return
			endif

			// spawn deranor
			set this.m_effect = AddSpecialEffect("Abilities\\Spells\\Undead\\Darksummoning\\DarkSummonTarget.mdl", GetRectCenterX(gg_rct_video_intro_deranor), GetRectCenterY(gg_rct_video_intro_deranor))
			set this.m_actorDeranor = this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'u00A', gg_rct_video_intro_deranor, GetRandomFacing())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorDeranor), this.actor())
			call QueueUnitAnimation(this.unitActor(this.m_actorDeranor), "Stand Channel")

			if (wait(1.667)) then
				return
			endif

			call ResetUnitAnimation(this.unitActor(this.m_actorDeranor))
			call DestroyEffect(this.m_effect)
			set this.m_effect = null

			call TransmissionFromUnit(this.unitActor(this.m_actorDeranor), tr("Willkommen in den Todessümpfen. Dies ist mein Reich. Eure erste Prüfung, Gardonars Hölle zu durchqueren, habt ihr erfolgreich bestanden. Doch nun widmet euch eurer nächsten Prüfung. Durchquert meine Todessümpfe."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_intro_0, true, 0.00)
			call CameraSetupApplyForceDuration(gg_cam_intro_1, true, 3.50)
			call Game.fadeInWithWait()

			call TransmissionFromUnit(this.unitActor(this.m_actorDeranor), tr("Um das versiegelte Tor zu öffnen, müsst ihr drei magische Kraftfelder deaktiviern. Dies muss jedoch gleichzeitig geschehen. Daher müsst ihr euch aufteilen. Werden alle drei Kraftfelder gleichzeitig deaktiviert, so öffnet sich auch die Versiegelung meines Tors."), null)

			if (wait(2.0)) then
				return
			endif

			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_intro_2, true, 0.00)
			call CameraSetupApplyForceDuration(gg_cam_intro_3, true, 3.50)
			call Game.fadeInWithWait()

			if (wait(2.0)) then
				return
			endif

			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_intro_4, true, 0.00)
			call CameraSetupApplyForceDuration(gg_cam_intro_5, true, 3.50)
			call Game.fadeInWithWait()

			if (wait(2.0)) then
				return
			endif

			// TODO substract the passed time
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_intro_exit, true, 0.00)
			call CameraSetupApplyForceDuration(gg_cam_intro_exit_boss, true, 3.50)
			call Game.fadeInWithWait()

			call TransmissionFromUnit(this.unitActor(this.m_actorDeranor), tr("Doch nehmt euch vor dem Wächter des Tors in Acht. Er besitzt die Macht alle eure Feinde auf einmal wiederzuerwecken."), null)

			if (wait(2.0)) then
				return
			endif

			// TODO substract the passed time
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_intro_deranor, true, 0.00)
			call Game.fadeInWithWait()

			call TransmissionFromUnit(this.unitActor(this.m_actorDeranor), tr("Mögen die Spiele beginnen!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call QueueUnitAnimation(this.unitActor(this.m_actorDeranor), "Stand Channel")
			set this.m_effect = AddSpecialEffect("Abilities\\Spells\\Undead\\Darksummoning\\DarkSummonTarget.mdl", GetRectCenterX(gg_rct_video_intro_deranor), GetRectCenterY(gg_rct_video_intro_deranor))

			if (wait(1.667)) then
				return
			endif

			call ShowUnit(this.unitActor(this.m_actorDeranor), false)
			call DestroyEffect(this.m_effect)
			set this.m_effect = null

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			local integer i = 0
			call Game.resetVideoSettings()

			if (this.m_effect != null) then
				call DestroyEffect(this.m_effect)
				set this.m_effect = null
			endif

			loop
				exitwhen (i == 4)
				call RemoveWeatherEffect(this.m_weatherEffect[i])
				set this.m_weatherEffect[i] = null
				set i = i + 1
			endloop

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