library StructMapVideosVideoDeranorsDeath requires Asl, StructGameGame, StructMapMapNpcs

	struct VideoDeranorsDeath extends AVideo
		private unit m_actorDragonSlayer
		private unit m_actorDeranor

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(0.0)
			call CameraSetupApplyForceDuration(gg_cam_deranors_death_0, true, 0.0)

			set this.m_actorDragonSlayer = this.unitActor(this.saveUnitActor(Npcs.dragonSlayer()))
			call SetUnitPositionRect(this.m_actorDragonSlayer, gg_rct_video_deranors_death_dragon_slayer)
			call SetUnitOwner(this.m_actorDragonSlayer, Player(PLAYER_NEUTRAL_PASSIVE), false)
			call SetUnitColor(this.m_actorDragonSlayer, GetPlayerColor(MapSettings.alliedPlayer()))
			call SetUnitFacing(this.m_actorDragonSlayer, 270.0)

			call ShowUnit(Npcs.deranor(), false)
			set this.m_actorDeranor = this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.deranor, gg_rct_video_deranors_death_deranor, 75.0))


			call SetUnitPositionRect(this.actor(), gg_rct_video_deranors_death_actor)
			call SetUnitFacing(this.actor(), 270.0)

			call IssueImmediateOrder(this.actor(), "stop")
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_deranors_death_0)

			call TransmissionFromUnit(this.m_actorDeranor, tre("\"Ein König fällt in Dunkelheit, doch bleibt des Reiches altes Leid.\" Mein Geist wird zu meiner Burg zurückkehren. Wenn ihr den Mut habt, dann kommt dorthin und wir werden uns wieder sehen.", "\"A king falls in darkness, but the empires old suffering remains.\" My spirit will return to my castle. If you have the courage, then get there and we will see each other again."), gg_snd_Deranor2Mod)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Deranor2Mod))) then
				return
			endif

			call QueueUnitAnimation(this.m_actorDeranor, "Spell Channel")

			if (wait(2.0)) then
				return
			endif

			call ResetUnitAnimation(this.m_actorDeranor)
			call QueueUnitAnimation(this.m_actorDeranor, "Death")

			if (wait(2.0)) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Verdammt! Ein Zauber muss ihn am Leben halten. Dennoch wird seine Macht hier nun schwinden.", "Damn it! A spell must keep him alive. Yet his power here is now dwindling."), gg_snd_DragonSlayerDeranorsDeath1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerDeranorsDeath1))) then
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

			call SetUnitFacingToFaceUnitTimed(this.m_actorDragonSlayer, this.actor(), 0.50)
			call SetUnitFacingToFaceUnitTimed(this.actor(), this.m_actorDragonSlayer, 0.50)

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Ihr ahnt nicht welchen Gefallen ihr eurem Königreich damit getan habt. Lieder sollte man über diese Heldentat singen, doch vermutlich wird sie der Welt dort draußen unbekannt bleiben. Der Ruhm Einzelner gerät in Vergessenheit. Stattdessen schlachten sich nun die großen Völker.", "You cannot guess what service you did for your kingdom with this. Songs should be sung about this heroic act, but probably it will remain unknow for the world out there. The glory of individuals will become forgotten. Instead, now the great nations are slaughtering each other."), gg_snd_DragonSlayerDeranorsDeath2)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerDeranorsDeath2))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Ihr habt eine Belohnung versprochen ...", "You have promised a reward ..."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Natürlich und die sollt ihr bekommen. Jeder von euch bekommt einen Zacken von Deranors Krone. Die Zacken sind verzaubert und können euch von Nutzen sein.", "Of course, and you shall receive it. Each of you gets a tad of Deranor's crown. The tads are enchanted and can be of service to you."), gg_snd_DragonSlayerDeranorsDeath3)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerDeranorsDeath3))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Außerdem bekommt jeder von euch ein paar mächtige Artefakte, um euch auf eurer weiteren Reise zu beschützen.", "Besides each of you gets some powerful artifacts in order to protect you on your further travel."), gg_snd_DragonSlayerDeranorsDeath4)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerDeranorsDeath4))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Mein Werk hier aber ist getan. Ich werde nun nach Talras gehen und dort andere Geschäfte verfolgen. Passt gut auf euch auf und vergesst niemals, welchen Heldenmut ihr bewiesen habt.", "My work here is done. I will now go to Talras and follow other business there. Take good care of you and never forget what heroism you have proved."), gg_snd_DragonSlayerDeranorsDeath5)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerDeranorsDeath5))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			local unit shop
			call Game.resetVideoSettings()
			// move her to Talras
			call SetUnitX(Npcs.dragonSlayer(), GetRectCenterX(gg_rct_quest_a_new_alliance))
			call SetUnitY(Npcs.dragonSlayer(), GetRectCenterY(gg_rct_quest_a_new_alliance))
			call SetUnitFacing(Npcs.dragonSlayer(), 265.36)
			set shop = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'n04E', GetRectCenterX(gg_rct_dragon_slayer_shop), GetRectCenterY(gg_rct_dragon_slayer_shop), 0.0)
			call SetUnitInvulnerable(shop, true)
			call ShowUnit(Npcs.deranor(), true)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary