library StructMapVideosVideoANewAlliance requires Asl, StructGameGame

	struct VideoANewAlliance extends AVideo
		private integer m_actorHeimrich
		private integer m_actorMarkward

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(16.0)
			call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_0, true, 0.0)

			set this.m_actorHeimrich = AVideo.saveUnitActor(gg_unit_n013_0116)
			call SetUnitPositionRect(AVideo.unitActor(this.m_actorHeimrich), gg_rct_video_a_new_alliance_heimrichs_position)

			set this.m_actorMarkward = AVideo.saveUnitActor(gg_unit_n014_0117)
			call SetUnitPositionRect(AVideo.unitActor(this.m_actorMarkward), gg_rct_video_a_new_alliance_markwards_position)

			call SetUnitPositionRect(AVideo.actor(), gg_rct_video_a_new_alliance_actors_position)

			call SetUnitFacingToFaceUnit(AVideo.unitActor(this.m_actorHeimrich), AVideo.actor())
			call SetUnitFacingToFaceUnit(AVideo.unitActor(this.m_actorMarkward), AVideo.actor())
			call SetUnitFacingToFaceUnit(AVideo.actor(), AVideo.unitActor(this.m_actorHeimrich))
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call TransmissionFromUnit(AVideo.unitActor(this.m_actorHeimrich), tr("Was haben sie zu mir berichten?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_1, true, 0.0)
			call TransmissionFromUnit(AVideo.actor(), tr("Die Nordmänner sind bereit sich mit Euch zu verbünden. Sie werden Euch beim Kampf gegen die Dunkelelfen und Orks unterstützen￼."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_0, true, 0.0)
			call TransmissionFromUnit(AVideo.unitActor(this.m_actorHeimrich), tr("Dies freut mich zu hören. Jedoch brauche ich noch mehr Verbündete, um eine echte Chance gegen unseren Feind zu haben. Markward wird ihnen ihren nächsten Auftrag erteilen und sie für ih￼r￼e Dienste entlohnen."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_2, true, 0.0)

			call IssueRectOrder(AVideo.unitActor(this.m_actorHeimrich), "move", gg_rct_video_a_new_alliance_heimrichs_new_position)

			if (wait(2.0)) then
				return
			endif

			call SetUnitLookAt(AVideo.actor(), "bone_head", AVideo.unitActor(this.m_actorMarkward), 0.0, 0.0, 90.0)
			call IssueRectOrder(AVideo.unitActor(this.m_actorMarkward), "move", gg_rct_video_a_new_alliance_markwards_new_position)

			loop
				exitwhen (RectContainsUnit(gg_rct_video_a_new_alliance_markwards_new_position, AVideo.unitActor(this.m_actorMarkward)))
				if (wait(1.0)) then
					return
				endif
			endloop

			call SetUnitFacingToFaceUnit(AVideo.unitActor(this.m_actorMarkward), AVideo.actor())
			call SetUnitFacingToFaceUnit(AVideo.actor(), AVideo.unitActor(this.m_actorMarkward))
			call CameraSetupApplyForceDuration(gg_cam_a_new_alliance_0, true, 0.0)
			call TransmissionFromUnit(AVideo.unitActor(this.m_actorMarkward), tr("Das war gute Arbeit. Mir ist von dem Kampf zu Ohren gekommen. Mit den Nordmännern haben wir ein paar starke Verbündete gewonnen."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(AVideo.unitActor(this.m_actorMarkward), tr("Leider reicht das dem Herzog nicht aus. Er möchte absolut sicher gehen und deshalb benötigt er noch mehr Unterstützung. Flussaufwärts befindet sich eine Stadt namens Holzbruck. Sie ist eine reiche, unabhängige Handelsstadt, gut befestigt und mit einer Vielzahl von Kriegsleuten."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(AVideo.unitActor(this.m_actorMarkward), tr("Deren Stadtrat kö￼n￼nte uns weitere Unterstützung schicken. Nun könntet ihr euch natürlich einfach auf den W￼eg machen, jedoch ist dieser sehr lang und beschwerl￼ich, da es außer dem Fluss keine direkte Verbi￼ndung nach Holzbruck gibt."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(AVideo.unitActor(this.m_actorMarkward), tr("Dabei kommt euch das Langboot der Nordmänner sehr gelegen, allerdings müsstet ihr sie natürlich auch davon überzeugen￼, euch nach Holzbruck zu bringen. Wie ihr das anstellt oder ob ihr doch lieber den Fußweg nehmt, soll euch überlassen sein. Hier ist euer Lohn für eure bisherigen Dienste. Abermals wünsche ich euch viel Glück!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
			call QuestTheWayToHolzbruck.quest().enable()
			call Character.displayHintToAll(tr("Die aktuelle Version von “Die Macht des Feuers” endet hier. Sobald die Reise nach Holzbruck angetreten wird, ist das Spiel zu Ende."))
			/// @todo Play sound with spoken message text.
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary