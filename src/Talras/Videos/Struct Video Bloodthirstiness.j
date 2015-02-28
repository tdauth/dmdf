library StructMapVideosVideoBloodthirstiness requires Asl, StructGameGame, StructMapQuestsQuestDeranor

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
			
			if (wait(2.0)) then
				return
			endif
			
			// TODO kill
			call QueueUnitAnimation(this.m_actorDragonSlayer, "Spell")
			
			if (wait(2.0)) then
				return
			endif
			
			//call SetUnitExploded(this.m_actorDeacon, true)
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
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Dieser Diakon war nichts weiter als ein einfacher Diener. Der Diener eines Meisters, dessen Name seit Urzeiten bei uns Hochelfen für das pure Grauen steht."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Deranor der Schreckliche, das ist sein Name. Er kam von den Todessümpfen, vermutlich um seinen eigenen Vorteil im Chaos zu suchen, das dieses Königreich bald überziehen wird. Genaues wissen jedoch auch wir Hochelfen nicht darüber."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Es ist nicht nur die pure Kampfeslust, die mich hier her trieb, nein es war ein Auftrag. Ein Auftrag von König Dararos ganz persönlich."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Wir erhielten die Information, dass Deranor sich im Grenzland dieses Königreiches aufhalten sollte und dort sein Unwesen trieb. Er steckt auch hinter diesem Kult und vermutlich hinter jeder untoten Kreatur in diesem verfluchten Land."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Doch nun können wir dem Schrecklichen ein Ende bereiten, denn er sitzt in der Falle! Dort hinten in der Todesgruft befindet sich eine Tür. Durch sie gelangt man in ein riesiges Gewölbe unter der Erde. Dort muss er sich aufhalten und dort wird er uns in die Falle gehen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Woher wisst Ihr das alles und wie könnt Ihr Euch da so sicher sein?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Wenn die Hochelfen eine große stärke besitzen sollten, dann wäre es die des Wissens. Wir haben schon seit langer Zeit die Geschehnisse in dieser Welt beeinflusst. Auch die Menschen stehen gewissermaßen unter unserer Obhut. Wir sind gut versorgt mit Informationen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Vertraut mir und ihr werden dafür belohnt. Ich will euch nichts Böses, mein Auftrag ist es diesen Deranor aufzuhalten und eine Gefahr mehr, die dieses Königreich bedroht zu bannen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Doch nehmt euch in Acht! Ich weiß, dass ihr große Krieger seid, doch Deranor der Schreckliche ist einer der stärksten Nekromanten, die diese Welt je gesehen hat. Wenn ihr mir nun folgt, dann tut es mit dem Wissen, dass ihr vielleicht niemals lebend zurückkehren werden."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorDragonSlayer, tr("Nehmt aber zunächst diese Belohnung als Zeichen meiner Dankbarkeit entgegen. Ohne euch hätte ich diesen Kampf nicht überstanden."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.showSpawnPointUnits(SpawnPoints.medusa())
			call Game.showSpawnPointUnits(SpawnPoints.deathVault())
			call Game.resetVideoSettings()
			
			call QuestDeranor.quest().enable()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary