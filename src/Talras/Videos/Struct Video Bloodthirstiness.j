library StructMapVideosVideoBloodthirstiness requires Asl, StructGameGame

	struct VideoBloodthirstiness extends AVideo
		private unit m_actorDragonSlayer
		private unit m_actorDeacon

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call Game.hideSpawnPointUnits(SpawnPoints.medusa())
			call Game.hideSpawnPointUnits(SpawnPoints.deathVault())
			call SetTimeOfDay(0.0)
			call CameraSetupApplyForceDuration(gg_cam_bloodthirstiness_0, true, 0.0)

			set this.m_actorDragonSlayer = thistype.unitActor(thistype.saveUnitActor(Npcs.dragonSlayer()))
			call SetUnitPositionRect(this.m_actorDragonSlayer, gg_rct_video_bloodthirstiness_dragon_slayer)

			set this.m_actorDeacon = thistype.unitActor(thistype.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.deacon, gg_rct_video_bloodthirstiness_deacon, 0.0))

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_bloodthirstiness_actor)

			call SetUnitFacingToFaceUnit(this.m_actorDragonSlayer, this.m_actorDeacon)
			call SetUnitFacingToFaceUnit(this.m_actorDeacon, this.m_actorDragonSlayer)
			call SetUnitFacingToFaceUnit(thistype.actor(), this.m_actorDeacon)

			call PauseUnit(this.m_actorDragonSlayer, true)
			call PauseUnit(thistype.actor(), true)
			call PauseUnit(thistype.actor(), true)

		endmethod

		public stub method onPlayAction takes nothing returns nothing
			if (wait(1.00)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_bloodthirstiness_1, true, 0.0)

			if (wait(2.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_bloodthirstiness_2, true, 3.50)

			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Verfluchte Missgeburt!"), null)

			if (wait(GetSimpleTransmissionDuration(null) + 1.0)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_bloodthirstiness_3, true, 0.0)
			
			// TODO kill
			call QueueUnitAnimation(this.m_actorDragonSlayer, "Spell")
			
			if (wait(2.0)) then
				return
			endif
			
			call SetUnitExploded(this.m_actorDeacon, true)
			call KillUnit(this.m_actorDeacon)
			set this.m_actorDeacon = null


			if (wait(1.0)) then
				return
			endif
			
			call ResetUnitAnimation(this.m_actorDragonSlayer)
			call SetUnitFacingToFaceUnitTimed(this.m_actorDragonSlayer, thistype.actor(), 0.50)
			call SetUnitFacingToFaceUnitTimed(thistype.actor(), this.m_actorDragonSlayer, 0.50)
			
			if (wait(0.50)) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Ich frage mich was dieser dunkle Kult hier getrieben hat, aber vermutlich  werden wir es nie erfahren."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Wie dem auch sei, ich danke euch vielmals! Ohne euch hätte ich es vermutlich nicht überlebt, auch wenn das natürlich nicht meine Absicht war."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Dieses Königreich wird von Ungetier und Krieg überzogen bis am Ende nur noch Schutt und Asche davon übrig bleibt."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Nehmt eure Belohnung entgegen, ihr habt sie euch verdient! Ich werde mich nun zur Burg begeben und hoffe darauf, dass ihr meine Taten schriftlich festhalten werdet. Meldet euch bei mir, wenn ihr soweit seid."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.showSpawnPointUnits(SpawnPoints.medusa())
			call Game.showSpawnPointUnits(SpawnPoints.deathVault())
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary