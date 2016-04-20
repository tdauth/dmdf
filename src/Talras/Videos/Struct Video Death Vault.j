library StructMapVideosVideoDeathVault requires Asl, StructGameGame, StructMapMapSpawnPoints

	struct VideoDeathVault extends AVideo
		private unit m_actorDragonSlayer
		private unit m_actorMedusa
		private unit m_actorDeacon
		private AGroup m_thunderCreatures
		private AGroup m_actorsDegenerateSouls
		private AGroup m_actorsRavenJugglers
		private AGroup m_actorsDoomedMen

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call Game.hideSpawnPointUnits(SpawnPoints.deathVault())
			call SetTimeOfDay(0.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_death_vault_0, true, 0.0)
			call CameraSetupApplyForceDuration(gg_cam_death_vault_1, true, 3.0)

			set this.m_actorDragonSlayer = this.unitActor(this.saveUnitActor(Npcs.dragonSlayer()))
			call SetUnitPositionRect(this.m_actorDragonSlayer, gg_rct_video_death_vault_dragon_slayer)
			call SetUnitFacing(this.m_actorDragonSlayer, 90.0)
			call ShowUnit(this.m_actorDragonSlayer, false)

			call SetUnitPositionRect(this.actor(), gg_rct_video_death_vault_actor)
			call SetUnitFacing(this.actor(), 90.0)
			call ShowUnit(this.actor(), false)

			set this.m_actorMedusa = this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.medusa, gg_rct_video_death_vault_medusa, 245.38))

			set this.m_thunderCreatures = AGroup.create()
			call this.m_thunderCreatures.units().pushBack(this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.thunderCreature, gg_rct_video_death_vault_thunder_creature_0, 272.22)))
			call this.m_thunderCreatures.units().pushBack(this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.thunderCreature, gg_rct_video_death_vault_thunder_creature_1, 249.86)))
			call this.m_thunderCreatures.units().pushBack(this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.thunderCreature, gg_rct_video_death_vault_thunder_creature_2, 196.11)))
			call this.m_thunderCreatures.units().pushBack(this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.thunderCreature, gg_rct_video_death_vault_thunder_creature_3, 131.72)))

			set this.m_actorDeacon = this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.deacon, gg_rct_video_death_vault_deacon, 359.37))


			set this.m_actorsDoomedMen = AGroup.create()
			call this.m_actorsDoomedMen.units().pushBack(this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.doomedMan, gg_rct_video_death_vault_doomed_man_0, 11.59)))
			call this.m_actorsDoomedMen.units().pushBack(this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.doomedMan, gg_rct_video_death_vault_doomed_man_1, 356.32)))

			/// \todo Create groups
			//private unit m_actorDeacon
			//private AGroup m_actorsDegenerateSouls
			//private AGroup m_actorsRavenJugglers
			//private AGroup m_actorsDoomedMen
			//doomedMan = 'n037'
			//public static constant integer deacon = 'n035'
			//public static constant integer ravenJuggler = 'n036'
			//public static constant integer degenerateSoul = 'n038'
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("In dieser Gruft befinden sich zwei starke böse Kreaturen. Zum Einen eine mächtige Medusa und zum Anderen der „Diakon der Finsternis“.", "In this crypt there is two powerful evil creatures. On the ne hand a powerful Medusa and on the other hand the \"Deacon of Darkness\"."), null) // TODO DragonSlayerSound

			if (wait(0.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_2, true, 1.0)

			if (wait(0.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_3, true, 1.0)

			if (wait(0.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_4, true, 1.0)

			if (wait(0.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_5, true, 2.0)

			if (wait(1.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_6, true, 2.0)

			if (wait(1.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_7, true, 2.0)

			if (wait(1.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_8, true, 2.0)

			if (wait(1.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_9, true, 3.0)

			if (wait(3.00)) then // kurzes Standbild auf Medusa
				return
			endif
			
			// Animation der Medusa
			call QueueUnitAnimation(this.m_actorMedusa, "Spell")
			
			if (wait(3.50)) then // kurzes Standbild auf Medusa
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_death_vault_10, true, 0.0)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_11, true, 1.0)

			if (wait(0.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_12, true, 1.0)

			if (wait(0.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_13, true, 1.0)

			if (wait(0.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_14, true, 1.0)

			if (wait(0.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_15, true, 1.0)

			if (wait(0.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_16, true, 1.0)

			if (wait(0.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_17, true, 1.0)

			if (wait(0.50)) then
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			/// \todo Start talking!
			call CameraSetupApplyForceDuration(gg_cam_death_vault_18, true, 0.0) // from behind
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_19, true, 0.0) // front
			call QueueUnitAnimation(this.m_actorDeacon, "Spell")
			//call SetUnitAnimation(this.m_actorDeacon, "Spell")

			if (wait(2.0)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_death_vault_19, true, 0.0) // start ritual
			call QueueUnitAnimation(this.m_actorDeacon, "Spell Slam")
			//call SetUnitAnimation(this.m_actorDeacon, "Spell Slam")
			call CameraSetupApplyForceDuration(gg_cam_death_vault_ritual, true, 3.0)

			if (wait(2.50)) then
				return
			endif

			/// \todo Create effect
			//gg_rct_video_death_vault_ritual

			if (wait(2.0)) then
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_death_vault_entering, true, 0.0)
			call ShowUnit(this.m_actorDragonSlayer, true)
			call ShowUnit(this.actor(), true)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Nun aber auf in die Schlacht. Lasst keinen am Leben, hackt alle in Stücke und lasst uns für Ruhm und Ehre sterben!", "But now into the battle. Let nobody stay alive, slay all to pieces and let us die for honor and glory!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call this.setActorsMoveSpeed(200.0) // gleich schnell für normale Bewegung

			call IssueTargetOrder(this.actor(), "move", this.m_actorDragonSlayer)
			call IssueRectOrder(this.m_actorDragonSlayer, "move", gg_rct_video_death_vault_target)

			if (wait(4.0)) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call this.m_thunderCreatures.destroy()
			call this.m_actorsDoomedMen.destroy()

			call Game.showSpawnPointUnits(SpawnPoints.deathVault())
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapData.neutralPassivePlayer)
			
			return this
		endmethod
	endstruct

endlibrary