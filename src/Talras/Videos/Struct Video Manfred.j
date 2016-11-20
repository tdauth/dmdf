library StructMapVideosVideoManfred requires Asl, StructGameGame

	struct VideoManfred extends AVideo
		private unit m_actorManfred
		private unit m_actorManfredsDog

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_manfred_initial_view, true, 0.0)

			set this.m_actorManfred = this.unitActor(this.saveUnitActor(Npcs.manfred()))
			call SetUnitPositionRect(this.m_actorManfred, gg_rct_video_manfred_manfred)

			set this.m_actorManfredsDog = this.unitActor(this.saveUnitActor(Npcs.manfredsDog()))
			call SetUnitPositionRect(this.m_actorManfredsDog, gg_rct_video_manfred_dog)

			call SetUnitPositionRect(this.actor(), gg_rct_video_manfred_actor)

			call SetUnitFacingToFaceUnit(this.actor(), this.m_actorManfred)
			call SetUnitFacingToFaceUnit(this.m_actorManfred, this.actor())
			call SetUnitFacingToFaceUnit(this.m_actorManfredsDog, this.actor())
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_manfred_initial_view)

			call TransmissionFromUnit(this.actor(), tre("Bauer Manfred!", "Farmer Manfred!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.m_actorManfred, tre("Manfred", "Manfred"), tre("Was gibt es?", "What is it?"), gg_snd_Manfred35)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Manfred35))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Der Herzog benötigt Nahrungsmittel für einen besetzten Außenposten im Norden.", "The duke needs food for an occupied outpost in the north."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.m_actorManfred, tre("Manfred", "Manfred"), tre("Sonst noch etwas? Denkt der Herzog vielleicht, dass wir hier genug zu essen haben? Wenn der Winter kommt werden wir noch allesamt verhungern!", "Is there anything else? Does the duke perhaps think that we have enough to eat? When the winter comes we will all starve!"), gg_snd_Manfred36)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Manfred36))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Ist es dir lieber, dass die Orks und Dunkelelfen hier einfallen und dich töten?", "Would you rather prefer that the Orcs and Dark Elves come here and kill you?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.m_actorManfred, tre("Manfred", "Manfred"), tre("(Ängstlich) Nein, sicher nicht ... Also gut, wenn du mir einen Gefallen tust, kannst du die Nahrungsmittel haben.", "(Anxiously) No, certainly not ... All right, if you do me a favor, you can have the food."), gg_snd_Manfred37)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Manfred37))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Was soll ich tun?", "What should I do?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.m_actorManfred, tre("Manfred", "Manfred"), tre("Auf unseren Feldern treibt sich großes Ungeziefer herum. Die Kornfresser fressen nicht nur den Weizen, sondern auch meine Knechte. So fällt ein Teil der Ernte aus und ich verliere meine Arbeiter! Töte die Kornfresser und ich kümmere mich um die Nahrungsmittel.", "In our fields large bugs are hanging around. The Corn Eaters devour not only the wheat but also my servants. So part of the harvest is missing and I lose my workers! Kill the Corn Eaters and I take care of the food."), gg_snd_Manfred38)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Manfred38))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Abgemacht.", "Agreed."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif


			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorManfred = null
			set this.m_actorManfredsDog = null

			call Game.resetVideoSettings()
			call QuestWarSupplyFromManfred.quest.evaluate().enableKillTheCornEaters.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary