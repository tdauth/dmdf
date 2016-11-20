library StructMapVideosVideoWelcome requires Asl, StructGameGame, StructMapMapNpcs

	struct VideoWelcome extends AVideo
		private integer m_actorGardonar
		private integer m_actorDeranor
		private integer m_actorGammar
		private integer m_actorBarade

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(6.00)

			set this.m_actorGardonar = this.saveUnitActor(Npcs.gardonar())
			set this.m_actorDeranor = this.saveUnitActor(Npcs.deranor())
			set this.m_actorGammar = this.saveUnitActor(Npcs.gammar())
			set this.m_actorBarade = this.saveUnitActor(Npcs.barade())

			call SetUnitX(this.actor(), GetRectCenterX(gg_rct_video_welcome_actor))
			call SetUnitY(this.actor(), GetRectCenterY(gg_rct_video_welcome_actor))

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorGardonar), this.actor())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorDeranor), this.actor())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorGammar), this.actor())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorBarade), this.actor())
			call SetUnitFacingToFaceUnit(this.actor(), this.unitActor(this.m_actorGardonar))

			call CameraSetupApplyForceDuration(gg_cam_welcome_0, true, 0.00)
		endmethod

		public stub method onPlayAction takes nothing returns nothing

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorGardonar), tre("Gardonar", "Gardonar"), tr("Ich grüße euch, meine werten Krieger. Tapfer habt ihr euch geschlagen bisher. Ich bin Gardonar, Fürst der Dämonen."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorGardonar), tre("Gardonar", "Gardonar"), tr("Wir haben bereits viel von euch gehört, aber zunächst einmal möchte ich euch mit den Anwesenden bekannt machen."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_welcome_1, true, 0.00)
			call Game.fadeInWithWait()

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorGardonar), tre("Gardonar", "Gardonar"), tr("Dies ist Deranor der Schreckliche, der Herr der Untoten. Ihm seid ihr ja bereits begegnet. Er freut sich euch wiederzusehen."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDeranor), tre("Deranor der Schreckliche", "Deranor the Terrible"), tr("So sieht man sich also wieder. Sorgt euch nicht darum, was geschehen ist. Ich bin nicht zornig auf euch."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorGardonar), tre("Gardonar", "Gardonar"), tr("Dort steht Gammar, der oberste Kriegsherr der Orks. Seine Krieger habt ihr bereits getötet."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorGammar), tre("Gammar der Kriegsherr der Orks", "Gammar Warlord of the Orcs"), tr("Viele meiner Krieger habt ihr abgeschlachtet, doch will ich euch vergeben, wenn ihr den rechten Weg beschreitet."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorGardonar), tre("Gardonar", "Gardonar"), tr("Und ganz rechts steht Baradé der Fürst der Dunkelelfen, auch seine Krieger habt ihr bereits getroffen."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorBarade), tre("Baradé, Fürst der Dunkelelfen", "Baradé, Lord of the Dark Elves"), tr("Die Zeit der Hochelfen neigt sich dem Ende. Die Zeit der Dunkelelfen ist angebrochen."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorGardonar), tre("Gardonar", "Gardonar"), tr("Ich selbst habe mich bereits vorgestellt, also lasst uns keine Zeit mehr verlieren. Wir sind beeindruckt von euren Fähigkeiten. Leider scheint ihr sie für die falsche Seite einzusetzen. Auch wenn euch die Menschen etwas anderes erzählen, gibt es in kaum einem Krieg die Guten und die Bösen. Wir haben auch unsere Gründe für unser vorgehen."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorGardonar), tre("Gardonar", "Gardonar"), tr("Wir haben euch hier her berufen, um euch ein Angebot zu machen: Kämpft für unsere Seite!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			// TODO Die Drachentöterin unterbricht ihn, sie weiß über Gardonar usw. bescheid

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorGardonar), tre("Gardonar", "Gardonar"), tr("Wie dem auch sei: Um euch Bedenkzeit zu geben und euch unsere Macht zu demonstieren stellen wir euch ein kleine Prüfung. Ihr werden den Fluss erst wieder erreichen, wenn ihr euch durch diese Welt geschlagen habt. Viel Glück große Krieger!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary