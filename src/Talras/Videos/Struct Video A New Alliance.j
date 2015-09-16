library StructMapVideosVideoANewAlliance requires Asl, StructGameGame, StructMapQuestsQuestANewAlliance

	struct VideoANewAlliance extends AVideo
		private integer m_actorHeimrich
		private integer m_actorMarkward

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(16.0)
			call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_0, true, 0.0)

			set this.m_actorHeimrich = thistype.saveUnitActor(gg_unit_n013_0116)
			call SetUnitPositionRect(thistype.unitActor(this.m_actorHeimrich), gg_rct_video_a_new_alliance_heimrichs_position)

			set this.m_actorMarkward = thistype.saveUnitActor(gg_unit_n014_0117)
			call SetUnitPositionRect(thistype.unitActor(this.m_actorMarkward), gg_rct_video_a_new_alliance_markwards_position)

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_a_new_alliance_actors_position)

			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorHeimrich), thistype.actor())
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorMarkward), thistype.actor())
			call SetUnitFacingToFaceUnit(thistype.actor(), thistype.unitActor(this.m_actorHeimrich))
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call TransmissionFromUnit(thistype.unitActor(this.m_actorHeimrich), tr("Was haben sie zu mir berichten?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_1, true, 0.0)
			call TransmissionFromUnit(thistype.actor(), tr("Die Nordmänner sind bereit sich mit Euch zu verbünden. Sie werden Euch beim Kampf gegen die Dunkelelfen und Orks unterstützen￼."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_0, true, 0.0)
			call TransmissionFromUnit(thistype.unitActor(this.m_actorHeimrich), tr("Dies freut mich zu hören. Jedoch brauche ich noch mehr Verbündete, um eine echte Chance gegen unseren Feind zu haben. Markward wird ihnen ihren nächsten Auftrag erteilen und sie für ih￼r￼e Dienste entlohnen."), gg_snd_Heimrich19)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich19))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_2, true, 0.0)

			call IssueRectOrder(thistype.unitActor(this.m_actorHeimrich), "move", gg_rct_video_a_new_alliance_heimrichs_new_position)

			if (wait(2.0)) then
				return
			endif

			call SetUnitLookAt(thistype.actor(), "bone_head", thistype.unitActor(this.m_actorMarkward), 0.0, 0.0, 90.0)
			call IssueRectOrder(thistype.unitActor(this.m_actorMarkward), "move", gg_rct_video_a_new_alliance_markwards_new_position)

			loop
				exitwhen (RectContainsUnit(gg_rct_video_a_new_alliance_markwards_new_position, thistype.unitActor(this.m_actorMarkward)))
				if (wait(1.0)) then
					return
				endif
			endloop

			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorMarkward), thistype.actor())
			call SetUnitFacingToFaceUnit(thistype.actor(), thistype.unitActor(this.m_actorMarkward))
			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_0, true, 0.0)
			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Das war gute Arbeit. Mir ist von dem Kampf zu Ohren gekommen. Mit den Nordmännern haben wir ein paar starke Verbündete gewonnen."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Leider reicht das dem Herzog nicht aus. Er möchte absolut sicher gehen und deshalb benötigt er noch mehr Unterstützung. Uns ist von einer Hochelfin zu Ohren gekommen, die durch diese Ländereien zieht. Durch sie könnten wir Kontakte zu den Hochelfen knüpfen."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Mir scheint es so als würden unsere eigenen Leute uns in diesem Kampf gar im Stich lassen. Der König hat bis jetzt keinerlei Unterstützung gesandt."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Doch bald werden die Orks und Dunkelelfen mit einem größeren Heer die Grenze überschreiten. Dieses kleine Gefecht war erst der Anfang."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Wir erhielten Berichte von Überfällen an der Grenze und sogar von größeren Truppenbewegungen. Uns bleibt nun keine Zeit mehr und den König oder den restlichen Adel vom Ernst der Lage zu überzeugen scheint zwecklos."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Findet die Hochelfin und bringt sie um jeden Preis hier her. Hier habt ihr noch den Lohn für eure treuen Dienste. Viel Glück!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
			call QuestANewAlliance.quest().enable()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary