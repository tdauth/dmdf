library StructMapVideosVideoBloodthirstiness requires Asl, StructGameGame, StructMapQuestsQuestDeranor

	struct VideoBloodthirstiness extends AVideo
		private unit m_actorDragonSlayer
		private unit m_actorDeacon

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call Game.hideSpawnPointUnits(SpawnPoints.deathVault())
			call SetTimeOfDay(0.0)
			call CameraSetupApplyForceDuration(gg_cam_bloodthirstiness_1, true, 0.0)
			call CameraSetupApplyForceDuration(gg_cam_bloodthirstiness_2, true, 5.50)

			set this.m_actorDragonSlayer = this.unitActor(this.saveUnitActor(Npcs.dragonSlayer()))
			call SetUnitPositionRect(this.m_actorDragonSlayer, gg_rct_video_bloodthirstiness_dragon_slayer)
			call SetUnitOwner(this.m_actorDragonSlayer, Player(PLAYER_NEUTRAL_PASSIVE), false)
			call SetUnitColor(this.m_actorDragonSlayer, GetPlayerColor(MapSettings.alliedPlayer()))

			set this.m_actorDeacon = this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.deacon, gg_rct_video_bloodthirstiness_deacon, 0.0))

			call SetUnitPositionRect(this.actor(), gg_rct_video_bloodthirstiness_actor)

			call SetUnitFacingToFaceUnit(this.m_actorDragonSlayer, this.m_actorDeacon)
			call SetUnitFacingToFaceUnit(this.m_actorDeacon, this.m_actorDragonSlayer)
			call SetUnitFacingToFaceUnit(this.actor(), this.m_actorDeacon)

			call IssueImmediateOrder(this.m_actorDragonSlayer, "holdposition")
			call IssueImmediateOrder(this.m_actorDeacon, "holdposition")
			call IssueImmediateOrder(this.actor(), "holdposition")
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_bloodthirstiness_1)
			call CameraSetupApplyForceDuration(gg_cam_bloodthirstiness_2, true, 5.50)

			if (wait(2.50)) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Verfluchte Missgeburt!", "Damn freak!"), null)

			if (wait(GetSimpleTransmissionDuration(null) + 1.0)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_bloodthirstiness_3, true, 0.0)

			if (wait(2.0)) then
				return
			endif

			call SetUnitAnimation(this.m_actorDragonSlayer, "Spell")

			if (wait(1.0)) then
				return
			endif

			//call SetUnitExploded(this.m_actorDeacon, true)
			call KillUnit(this.m_actorDeacon)
			set this.m_actorDeacon = null
			call ResetUnitAnimation(this.m_actorDragonSlayer)


			if (wait(1.0)) then
				return
			endif

			call ResetUnitAnimation(this.m_actorDragonSlayer)
			call SetUnitFacingToFaceUnitTimed(this.m_actorDragonSlayer, this.actor(), 0.50)
			call SetUnitFacingToFaceUnitTimed(this.actor(), this.m_actorDragonSlayer, 0.50)

			if (wait(0.50)) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Dieser Diakon war nichts weiter als ein einfacher Diener. Der Diener eines Meisters, dessen Name seit Urzeiten bei uns Hochelfen für das pure Grauen steht.", "This deacon was nothing more than a simple servant. The servant of a master whose name represents the pure horror for us High Elves for ages."), gg_snd_DragonSlayerBloodthirstiness6)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerBloodthirstiness6))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Deranor der Schreckliche, das ist sein Name. Er kam von den Todessümpfen, vermutlich um seinen eigenen Vorteil im Chaos zu suchen, das dieses Königreich bald überziehen wird. Genaues wissen jedoch auch wir Hochelfen nicht darüber.", "Deranor the Terrible, that's his name. He came from the Death Swamps, presumably to seek his own advantage in the chaos that will impact upon this kingdom soon. But even we High Elves don't know exact things about it."), gg_snd_DragonSlayerBloodthirstiness7)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerBloodthirstiness7))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Es ist nicht nur die pure Kampfeslust, die mich hier her trieb, nein es war ein Auftrag. Ein Auftrag von König Dararos höchst persönlich.", "It is not only the pure belligerence that made me moving here, no, it was an order. An order of the king Dararos himself."), gg_snd_DragonSlayerBloodthirstiness8)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerBloodthirstiness8))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Wir erhielten die Information, dass Deranor sich im Grenzland dieses Königreiches aufhalten sollte und dort sein Unwesen trieb. Er steckt auch hinter diesem Kult und vermutlich hinter jeder untoten Kreatur in diesem verfluchten Land.", "We received the information that Deranor should reside in the border region of this kingdom and was doing his worst there. He is also behind this cult and presumably behind every undead creature in this coursed land."), gg_snd_DragonSlayerBloodthirstiness9)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerBloodthirstiness9))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Doch nun können wir dem Schrecklichen ein Ende bereiten, denn er sitzt in der Falle! Dort hinten in der Todesgruft befindet sich eine Tür. Durch sie gelangt man in ein riesiges Gewölbe unter der Erde. Dort muss er sich aufhalten und dort wird er uns in die Falle gehen.", "But now can we put an end to the terrible, because he is trapped! There is a door in the back of the death tomb. Though it you get into a huge vaulted underground. There he must reside there he wil go into the trap."), gg_snd_DragonSlayerBloodthirstiness1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerBloodthirstiness1))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Woher wisst Ihr das alles und wie könnt Ihr Euch da so sicher sein?", "How do you know all this, and how can you be so sure about it?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Wenn die Hochelfen eine große Stärke besitzen sollten, dann wäre es die des Wissens. Wir haben schon seit langer Zeit die Geschehnisse in dieser Welt beeinflusst. Auch die Menschen stehen gewissermaßen unter unserer Obhut. Wir sind gut versorgt mit Informationen.", "If the High Elves should have a great strength it would be the knowledge. We have influenced the events in this world for a long time. The humans are so to speak under our care as well. We are well supplied with information."), gg_snd_DragonSlayerBloodthirstiness2)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerBloodthirstiness2))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Vertraut mir und ihr werden dafür belohnt. Ich will euch nichts Böses, mein Auftrag ist es diesen Deranor aufzuhalten und eine Gefahr mehr, die dieses Königreich bedroht, zu bannen.", "Trust me and you will be rewarded. I want you no harm, my mission is to stop this Deranor and banish a danger more threatening this kingdom."), gg_snd_DragonSlayerBloodthirstiness3)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerBloodthirstiness3))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Doch nehmt euch in Acht! Ich weiß, dass ihr große Krieger seid, doch Deranor der Schreckliche ist einer der stärksten Nekromanten, den diese Welt je gesehen hat. Wenn ihr mir nun folgt, dann tut es mit dem Wissen, dass ihr vielleicht niemals lebend zurückkehren werdet.", "But take care! I know that you are great warriors but Deranor the Terrible is one of the strongest necromancers who has ever seen this world. If you follow me now do it with the knowledge that you will probably never return alive."), gg_snd_DragonSlayerBloodthirstiness4)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerBloodthirstiness4))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Nehmt aber zunächst diese Belohnung als Zeichen meiner Dankbarkeit entgegen. Ohne euch hätte ich diesen Kampf nicht überstanden.", "But first take this reward as sign of my gratitude towards you. Without you I would not have survived this battle."), gg_snd_DragonSlayerBloodthirstiness5)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerBloodthirstiness5))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.showSpawnPointUnits(SpawnPoints.deathVault())
			call Game.resetVideoSettings()

			call QuestDeranor.quest().enable()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary