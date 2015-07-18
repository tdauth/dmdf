library StructMapVideosVideoRecruitTheHighElf requires Asl, StructGameGame, StructMapQuestsQuestWar

	struct VideoRecruitTheHighElf extends AVideo
		private integer m_actorDragonSlayer
		private integer m_actorWorker
		private integer m_actorManfred
		// Place Manfred's dog. Otherwise he might block the way to the high elf.
		private integer m_actorManfredsDog
		private integer m_actorGuntrich
		private integer m_actorHeimrich
		private integer m_actorMarkward
		private integer m_actorFerdinand
	
		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(12.0)
			// TODO Music
			
			set this.m_actorDragonSlayer = thistype.saveUnitActor(Npcs.dragonSlayer())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorDragonSlayer), gg_rct_video_recruit_the_high_elf_dragon_slayer)
			
			call SetUnitPositionRect(thistype.actor(), gg_rct_video_recruit_the_high_elf_character)
			
			call SetUnitFacingToFaceUnit(thistype.actor(), thistype.unitActor(this.m_actorDragonSlayer))
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorDragonSlayer), thistype.actor())
			
			set this.m_actorWorker = thistype.saveUnitActor(gg_unit_n02J_0159)
			call SetUnitPositionRect(thistype.unitActor(this.m_actorWorker), gg_rct_waypoint_menial_3)
			call SetUnitFacing(thistype.unitActor(this.m_actorWorker), 210.68)
			call SetUnitAnimation(thistype.unitActor(this.m_actorWorker), "Stand Work")
			
			set this.m_actorManfred = thistype.saveUnitActor(Npcs.manfred())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorManfred), gg_rct_video_recruit_the_high_elf_manfred)
			
			set this.m_actorManfredsDog = thistype.saveUnitActor(Npcs.manfredsDog())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorManfredsDog), gg_rct_video_recruit_the_high_elf_manfreds_dog)
			
			set this.m_actorGuntrich = thistype.saveUnitActor(Npcs.guntrich())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorGuntrich), gg_rct_video_recruit_the_high_elf_guntrich)
			
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorManfred), thistype.unitActor(this.m_actorGuntrich))
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorManfredsDog), thistype.unitActor(this.m_actorGuntrich))
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorGuntrich), thistype.unitActor(this.m_actorManfred))
			
			set this.m_actorHeimrich = thistype.saveUnitActor(Npcs.heimrich())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorHeimrich), gg_rct_video_recruit_the_high_elf_heimrich)
			
			set this.m_actorMarkward = thistype.saveUnitActor(Npcs.markward())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorMarkward), gg_rct_video_recruit_the_high_elf_markward)
			
			set this.m_actorFerdinand = thistype.saveUnitActor(Npcs.ferdinand())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorFerdinand), gg_rct_video_recruit_the_high_elf_ferdinand)
			
			call CameraSetupApplyForceDuration(gg_cam_recruit_the_high_elf_initial_view, true, 0.0)
			
			call IssueRectOrder(thistype.actor(), "move", gg_rct_video_recruit_the_high_elf_character_target)
		endmethod
		
		public stub method onPlayAction takes nothing returns nothing
			loop
				exitwhen (RectContainsUnit(gg_rct_video_recruit_the_high_elf_character_target,  thistype.actor()))
				if (wait(1.0)) then
					return
				endif
			endloop
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call TriggerSleepAction(2.50)
			call CameraSetupApplyForceDuration(gg_cam_recruit_the_high_elf_talk_view, true, 0.0)
			
			call TriggerSleepAction(0.50)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			
			
			if (wait(2.5)) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorDragonSlayer), tr("Sieh an, wie schnell wir uns wieder sehen. Was habt Ihr mir zu berichten, Mensch? Habt Ihr etwa schon wieder eine Heldentat vollbracht?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Der Herzog benötigt eure Hilfe."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorDragonSlayer), tr("Der Herzog Heimrich von Talras? Meine Hilfe? Wie kommt er zu diesem Schluss? Er kennt weder mich noch meine Absichten."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorDragonSlayer), tr("Habt Ihr ihm bereits von unserer Metzelei berichtet und will er mich nun vorladen, damit ich Rechenschaft ablege?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_recruit_the_high_elf_character_view, true, 0.0)
			
			if (wait(1.0)) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Nein, nichts davon. Er braucht mehr Verbündete im Kampf gegen die Orks und Dunkelelfen. Der König schickt ihm keine Hilfe."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorDragonSlayer), tr("Der König? Das sieht ihm ähnlich. Dararos, der König der Hochelfen bestimmt praktisch über dieses Königreich Mittillant."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorDragonSlayer), tr("Er behandelt es als wäre es eine seiner zahlreichen Provinzen. Der König der Menschen ist schwach. Er weiß nicht wie er auf einen bevorstehenden Krieg reagieren soll."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(thistype.unitActor(this.m_actorDragonSlayer), tr("Doch wie sollte ich dem Herzog von Hilfe sein. Mein Auftrag ist erfüllt und bald kehre ich in unsere Hauptstadt zurück und erstatte König Dararos Bericht."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Heimrich fürchtet den baldigen Einmarsch der Orks und Dunkelelfen. Wenn sein König ihm keine Unterstützung schickt, wird Talras bald in der Hand des Feindes sein."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Könnt ihr nicht Unterstützung von eurer Heimat fordern?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorDragonSlayer), tr("In der Tat. Diese Burg würde einem ganzen Heer nicht lange Stand halten. Die Menschen hier sind freundlich zu mir. Es würde mir ganz und gar missfallen sie im Stich zu lassen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_recruit_the_high_elf_from_behind, true, 0.0)
			
			if (wait(1.0)) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorDragonSlayer), tr("Ich selbst habe jedoch keinen großen Einfluss auf meinen König, genauso wenig wie Heimrich auf den seinen. Was ich euch anbieten kann ist jedoch meine eigene Hilfe hier und jetzt."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorDragonSlayer), tr("Auch kann ich zumindest versuchen in meiner Heimat Hilfe zu ersuchen. Ihr habt mir geholfen Deranor den Schrecklichen zu besiegen! Ihr solltet in meiner Heimat als Helden gefeiert werden."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Dann kommt mit zum Herzog und erzählt ihm davon!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorDragonSlayer), tr("Nun gut, lasst uns keine Zeit mehr verlieren."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call TriggerSleepAction(2.50)
			call CameraSetupApplyForceDuration(gg_cam_recruit_the_high_elf_castle_view, true, 0.0)
			call SetUnitX(thistype.actor(), GetRectCenterX(gg_rct_video_recruit_the_high_elf_character_in_castle))
			call SetUnitY(thistype.actor(), GetRectCenterY(gg_rct_video_recruit_the_high_elf_character_in_castle))
			
			call SetUnitX(thistype.unitActor(this.m_actorDragonSlayer), GetRectCenterX(gg_rct_video_recruit_the_high_elf_dragon_slayer_in_castle))
			call SetUnitY(thistype.unitActor(this.m_actorDragonSlayer), GetRectCenterY(gg_rct_video_recruit_the_high_elf_dragon_slayer_in_castle))
			
			call SetUnitFacingToFaceUnit(thistype.actor(), thistype.unitActor(this.m_actorHeimrich))
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorDragonSlayer), thistype.unitActor(this.m_actorHeimrich))
			
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorHeimrich), thistype.unitActor(this.m_actorDragonSlayer))
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorMarkward), thistype.unitActor(this.m_actorDragonSlayer))
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorFerdinand), thistype.unitActor(this.m_actorDragonSlayer))
			
			call TriggerSleepAction(0.50)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			
			
			if (wait(2.5)) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorHeimrich), tr("Ich grüße Euch Hochelfin, seid willkommen in meiner Burg Talras."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorDragonSlayer), tr("Habt Dank werter Herzog. Es ist mir eine Ehre."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorHeimrich), tr("Ich hoffe sie denkt nichts Falsches von uns. Keineswegs wollen wir sie ausnutzen, doch bleibt uns in dieser schwierigen Zeit nichts anderes mehr übrig."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorDragonSlayer), tr("Ich verstehe Eure Lage durchaus. Noch heute werde ich ein Schreiben an meine Heimat verfassen und um Hilfe bitten. Eure Gefährten hier haben mir treue Dienste erwiesen. Nie würde ich ihnen einen Wunsch verwehren."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorHeimrich), tr("Nun gut, habt Dank! Ritter Markward wird alles weitere mit ihr besprechen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call IssueRectOrder(thistype.unitActor(this.m_actorHeimrich), "move", gg_rct_video_recruit_the_high_elf_heimrich_target)
			
			if (wait(2.0)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_recruit_the_high_elf_character_view_castle, true, 0.0)
			
			if (wait(1.0)) then
				return
			endif
			
			call SetUnitAnimationByIndex(thistype.actor(), 4)
			
			if (wait(4.5)) then
				return
			endif
			
			call SetUnitFacingToFaceUnit(thistype.actor(), thistype.unitActor(this.m_actorMarkward))
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorDragonSlayer), thistype.unitActor(this.m_actorMarkward))
			call CameraSetupApplyForceDuration(gg_cam_recruit_the_high_elf_castle_view, true, 0.0)
			
			if (wait(2.0)) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Wir haben mit Hilfe der Nordmänner das Lager der Orks und Dunkelelfen besetzt. Sogar Dorfbewohner haben sich kampfbereit gemacht um auf eigene Faust gegen die Feinde vorzugehen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Wir müssen den Kampfgeist der Männer und die Gunst der Stunde nutzen bevor es zu spät ist."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Unser Plan sieht vor das eroberte Lager zu befestigen und einen starken Vorposten zu errichten, der die Feinde solange wie möglich aufhalten wird."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Zunächst müsst ihr dazu das Lager mit Waffen, Nahrung und Holz versorgen. Danach sollten Fallen vor den Mauern aufgestellt werden. Außerdem müssen mehr kriegstaugliche Leute auf dem Bauernhof rekrutiert werden."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Selbstverständlich wird der Herzog euch für eure Dienste wieder entsprechend entlohnen. Viel Glück!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
			call QuestWar.quest().enable()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary