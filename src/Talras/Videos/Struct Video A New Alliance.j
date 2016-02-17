library StructMapVideosVideoANewAlliance requires Asl, StructGameGame, StructMapQuestsQuestANewAlliance

	struct VideoANewAlliance extends AVideo
		private integer m_actorHeimrich
		private integer m_actorMarkward

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(16.0)
			call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_0, true, 0.0)

			set this.m_actorHeimrich = this.saveUnitActor(gg_unit_n013_0116)
			call SetUnitPositionRect(this.unitActor(this.m_actorHeimrich), gg_rct_video_a_new_alliance_heimrichs_position)

			set this.m_actorMarkward = this.saveUnitActor(gg_unit_n014_0117)
			call SetUnitPositionRect(this.unitActor(this.m_actorMarkward), gg_rct_video_a_new_alliance_markwards_position)

			call SetUnitPositionRect(this.actor(), gg_rct_video_a_new_alliance_actors_position)

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorHeimrich), this.actor())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorMarkward), this.actor())
			call SetUnitFacingToFaceUnit(this.actor(), this.unitActor(this.m_actorHeimrich))
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call TransmissionFromUnit(this.unitActor(this.m_actorHeimrich), tre("Was haben sie mir zu berichten?", "What do they have to tell me?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_1, true, 0.0)
			call TransmissionFromUnit(this.actor(), tre("Die Nordmänner sind bereit sich mit Euch zu verbünden. Sie werden Euch beim Kampf gegen die Dunkelelfen und Orks unterstützen￼.", "The norsemen are ready to ally with you. They will support you in the fight against the Dark Elves and Orcs."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_0, true, 0.0)
			call TransmissionFromUnit(this.unitActor(this.m_actorHeimrich), tre("Dies freut mich zu hören. Jedoch brauche ich noch mehr Verbündete, um eine echte Chance gegen unseren Feind zu haben. Markward wird ihnen ihren nächsten Auftrag erteilen und sie für ih￼r￼e Dienste entlohnen.", "I am glad to hear this. However, I still need more allies to have a real chance against our enemy. Markward will give them their next mission and pay them for their services."), gg_snd_Heimrich19)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich19))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_2, true, 0.0)

			call IssueRectOrder(this.unitActor(this.m_actorHeimrich), "move", gg_rct_video_a_new_alliance_heimrichs_new_position)

			if (wait(2.0)) then
				return
			endif

			call SetUnitLookAt(this.actor(), "bone_head", this.unitActor(this.m_actorMarkward), 0.0, 0.0, 90.0)
			call IssueRectOrder(this.unitActor(this.m_actorMarkward), "move", gg_rct_video_a_new_alliance_markwards_new_position)

			loop
				exitwhen (RectContainsUnit(gg_rct_video_a_new_alliance_markwards_new_position, this.unitActor(this.m_actorMarkward)))
				if (wait(1.0)) then
					return
				endif
			endloop

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorMarkward), this.actor())
			call SetUnitFacingToFaceUnit(this.actor(), this.unitActor(this.m_actorMarkward))
			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_0, true, 0.0)
			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tre("Das war gute Arbeit. Mir ist von dem Kampf zu Ohren gekommen. Mit den Nordmännern haben wir ein paar starke Verbündete gewonnen.", "That was good work. It has come to my ears from the battle. With the norsemen we have gained some strong allies."), gg_snd_Markward33)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward33))) then
				return
			endif

			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tre("Leider reicht das dem Herzog nicht aus. Er möchte absolut sicher gehen und deshalb benötigt er noch mehr Unterstützung. Uns ist von einer Hochelfin zu Ohren gekommen, die durch diese Ländereien zieht. Durch sie könnten wir Kontakte zu den Hochelfen knüpfen.", "Unfortunately, it is enough for the duke. He wants to be absolutely sure and that's why he still needs more support. A high elf came to our attention who runs through these lands. Through her we could make contact with the High Elves."), gg_snd_Markward34)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward34))) then
				return
			endif

			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tre("Mir scheint es so als würden unsere eigenen Leute uns in diesem Kampf gar im Stich lassen. Der König hat bis jetzt keinerlei Unterstützung gesandt.", "It seems to me as if our own people leave us in the lurch in this struggle. The king has not sent any support so far."), gg_snd_Markward35)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward35))) then
				return
			endif
			
			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tr("Doch bald werden die Orks und Dunkelelfen mit einem größeren Heer die Grenze überschreiten. Dieses kleine Gefecht war erst der Anfang."), gg_snd_Markward36)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward36))) then
				return
			endif
			
			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tr("Wir erhielten Berichte von Überfällen an der Grenze und sogar von größeren Truppenbewegungen. Uns bleibt nun keine Zeit mehr und den König oder den restlichen Adel vom Ernst der Lage zu überzeugen scheint zwecklos."), gg_snd_Markward37)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward37))) then
				return
			endif

			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tr("Findet die Hochelfin und bringt sie um jeden Preis hier her. Hier habt ihr noch den Lohn für eure treuen Dienste. Viel Glück!"), gg_snd_Markward38)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward38))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
			call QuestANewAlliance.quest().enable()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapData.neutralPassivePlayer)
			
			return this
		endmethod
	endstruct

endlibrary