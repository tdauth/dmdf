library StructMapVideosVideoDeranorsDeath requires Asl, StructGameGame

	struct VideoDeranorsDeath extends AVideo
		private unit m_actorDragonSlayer
		private unit m_actorDeranor

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(0.0)
			call CameraSetupApplyForceDuration(gg_cam_deranors_death_0, true, 0.0)

			set this.m_actorDragonSlayer = thistype.unitActor(thistype.saveUnitActor(Npcs.dragonSlayer()))
			call SetUnitPositionRect(this.m_actorDragonSlayer, gg_rct_video_deranors_death_dragon_slayer)
			call SetUnitFacing(this.m_actorDragonSlayer, 270.0)

			set this.m_actorDeranor = thistype.unitActor(thistype.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.deranor, gg_rct_video_deranors_death_deranor, 75.0))
			
			
			call SetUnitPositionRect(thistype.actor(), gg_rct_video_deranors_death_actor)
			call SetUnitFacing(thistype.actor(), 270.0)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call TransmissionFromUnit(this.m_actorDeranor, tr("\"Ein König fällt in Dunkelheit, doch bleibt des Reiches altes Leid.\" Mein Geist wird zu meiner Burg zurückkehren. Wenn ihr den Mut habt, dann kommt dorthin und wir werden uns wieder sehen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call QueueUnitAnimation(this.m_actorDeranor, "Death")
			
			if (wait(2.0)) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Verdammt! Ein Zauber muss ihn am Leben halten. Dennoch wird seine Macht hier nun schwinden."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_deranors_death_1, true, 0)
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			
			if (wait(2.0)) then
				return
			endif
			
			call SetUnitFacingToFaceUnitTimed(this.m_actorDragonSlayer, thistype.actor(), 0.50)
			call SetUnitFacingToFaceUnitTimed(thistype.actor(), this.m_actorDragonSlayer, 0.50)
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Ihr ahnt nicht welchen Gefallen ihr eurem Königreich damit getan habt. Lieder sollte man über diese Heldentat singen, doch vermutlich wird sie der Welt dort draußen unbekannt bleiben. Der Ruhm Einzelner gerät in Vergessenheit. Stattdessen schlachten sich nun die großen Völker."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Ihr habt eine Belohnung versprochen ..."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Natürlich und die sollt ihr bekommen. Jeder von euch bekommt einen Zacken von Deranors Krone. Die Zacken sind verzaubert und könne euch von Nutzen sein."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Außerdem bekommt jeder von euch ein paar mächtige Artefakte, um euch auf eurer weiteren Reise zu beschützen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Mein Werk hier aber ist getan. Ich werde nun nach Talras gehen und dort andere Geschäfte verfolgen. Passt gut auf euch auf und vergesst niemals, welchen Heldenmut ihr bewiesen habt."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
			// move her to Talras
			call SetUnitX(Npcs.dragonSlayer(), GetRectCenterX(gg_rct_quest_a_new_alliance))
			call SetUnitY(Npcs.dragonSlayer(), GetRectCenterY(gg_rct_quest_a_new_alliance))
			call SetUnitFacing(Npcs.dragonSlayer(), 265.36)
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary