library StructMapVideosVideoManfred requires Asl, StructGameGame

	struct VideoManfred extends AVideo
		private unit m_actorManfred
		private unit m_actorManfredsDog

		implement Video

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
		
			call TransmissionFromUnit(this.actor(), tr("Bauer Manfred!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorManfred, tr("Manfred"), tr("Was gibt es?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.actor(), tr("Der Herzog benötigt Nahrungsmittel für einen besetzten Außenposten im Norden."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorManfred, tr("Manfred"), tr("Sonst noch etwas? Denkt der Herzog vielleicht, dass wir hier genug zu essen haben? Wenn der Winter kommt werden wir noch allesamt verhungern!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.actor(), tr("Ist es dir lieber, dass die Orks und Dunkelelfen hier einfallen und dich töten?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorManfred, tr("Manfred"), tr("(Ängstlich) Nein, sicher nicht ... Also gut, wenn du mir einen Gefallen tust, kannst du die Nahrungsmittel haben."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.actor(), tr("Was soll ich tun?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorManfred, tr("Manfred"), tr("Auf unseren Feldern treibt sich großes Ungeziefer herum. Die Kornfresser fressen nicht nur den Weizen, sondern auch meine Knechte. So fällt ein Teil der Ernte aus und ich verliere meine Arbeiter! Töte die Kornfresser und ich kümmere mich um die Nahrungsmittel."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.actor(), tr("Abgemacht."), null)
			
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
			call this.setActorOwner(MapData.neutralPassivePlayer)
			
			return this
		endmethod
	endstruct

endlibrary