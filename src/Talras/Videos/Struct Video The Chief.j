library StructMapVideosVideoTheChief requires Asl, StructGameGame

	struct VideoTheChief extends AVideo
		private unit m_actorWigberht
		private unit m_actorRicman
		private unit m_actorNorseman0
		private unit m_actorNorseman1

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(6.00)
			call PlayThematicMusic("Music\\TheChief.mp3")
			call CameraSetupApplyForceDuration(gg_cam_the_chief_0, true, 0.0)

			set this.m_actorWigberht = thistype.unitActor(thistype.saveUnitActor(gg_unit_n004_0038))
			call SetUnitPositionRect(this.m_actorWigberht, gg_rct_video_the_chief_wigberhts_position)
			call SetUnitFacing(this.m_actorWigberht, 257.38)

			set this.m_actorRicman = thistype.unitActor(thistype.saveUnitActor(gg_unit_n016_0016))
			call SetUnitPositionRect(this.m_actorRicman, gg_rct_video_the_chief_ricmans_position)
			call SetUnitFacing(this.m_actorRicman, 299.92)
			
			set this.m_actorNorseman0 = thistype.unitActor(thistype.saveUnitActor(gg_unit_n01I_0150))
			call SetUnitPositionRect(this.m_actorNorseman0, gg_rct_video_the_chief_norseman_0)
			call SetUnitFacing(this.m_actorRicman, 303.74)
			
			set this.m_actorNorseman1 = thistype.unitActor(thistype.saveUnitActor(gg_unit_n01I_0151))
			call SetUnitPositionRect(this.m_actorRicman, gg_rct_video_the_chief_norseman_1)
			call SetUnitFacing(this.m_actorRicman, 168.10)
			
			
			// hide other norsemen
			call ShowUnit(gg_unit_n01I_0153, false)
			call ShowUnit(gg_unit_n01I_0152, false)

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_the_chief_actors_position)
			call SetUnitFacing(thistype.actor(), 123.64)
			call SetUnitMoveSpeed(thistype.actor(), 200.0)
		endmethod

		private static method conditionActorIsInTargetRect takes AVideo this returns boolean
			return RectContainsUnit(gg_rct_video_the_chief_actors_target, AVideo.actor())
		endmethod

		private static method conditionWigberhtIsInRicmansRect takes thistype this returns boolean
			return RectContainsUnit(gg_rct_video_the_chief_ricmans_position,this.m_actorWigberht)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call CameraSetupApplyForceDuration(gg_cam_the_chief_1, true, 10.0)
			call IssueRectOrder(thistype.actor(), "move", gg_rct_video_the_chief_actors_target)
			debug if (IsUnitPaused(thistype.actor())) then
				debug call Print("Actor is paused!")
			debug endif
			if (waitForCondition(1.0, thistype.conditionActorIsInTargetRect)) then
				return
			endif
			if (wait(1.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_2, true, 0.0)
			call TransmissionFromUnit(this.m_actorRicman, tr("Was wollt ihr hier?"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call TransmissionFromUnit(AVideo.actor(), tr("Wir wollen mit Eurem Anführer sprechen. Der Herzog von Talras schickt uns."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call TransmissionFromUnit(this.m_actorRicman, tr("Der Herzog von Talras? Wieso kommt er nicht persönlich? Macht dass ihr wegkommt!"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_3, true, 0.0)
			call TransmissionFromUnit(this.m_actorWigberht, tr("Lass sie!"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call SetUnitFacingToFaceUnit(this.m_actorWigberht,  this.m_actorRicman)
			call CameraSetupApplyForceDuration(gg_cam_the_chief_4, true, 6.0)
			if (wait(5.0)) then
				return
			endif
			call IssueRectOrder(this.m_actorRicman, "move", gg_rct_video_the_chief_ricmans_new_position)
			if (wait(2.0)) then
				return
			endif
			call IssueRectOrder(this.m_actorWigberht, "move", gg_rct_video_the_chief_ricmans_position)
			call CameraSetupApplyForceDuration(gg_cam_the_chief_5, true, 5.0)
			if (waitForCondition(1.0, thistype.conditionWigberhtIsInRicmansRect)) then
				return
			endif
			call SetUnitFacingToFaceUnit(this.m_actorRicman, this.m_actorWigberht)
			call SetUnitFacingToFaceUnit(this.m_actorWigberht, thistype.actor())
			call CameraSetupApplyForceDuration(gg_cam_the_chief_6, true, 0.0)
			call TransmissionFromUnit(this.m_actorWigberht, tr("Was wollt ihr von mir?"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_7, true, 0.0)
			call TransmissionFromUnit(thistype.actor(), tr("Heimrich, der Herzog von Talras, möchte wissen, ob er ein Bündnis mit Euch und Euren Männern eingehen kann. Er braucht Unterstützung im Kampf gegen den Feind."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_6, true, 0.0)
			call TransmissionFromUnit(this.m_actorWigberht, tr("Wieso sollte ich ein Bündnis mit ihm eingehen?"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_7, true, 0.0)
			call TransmissionFromUnit(thistype.actor(), tr("Gemeinsam habt ihr eine größere Chance den Feind zu bezwingen."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_6, true, 0.0)
			call TransmissionFromUnit(this.m_actorWigberht, tr("Den Feind zu bezwingen? Seht, ich werde euch erklären, warum meine Männer und ich hier sind. Mein Vater, ein Kriegsherr des Nordens, wurde von Dunkelfelfen verschleppt. Wir folgten ihnen bis hier her."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call TransmissionFromUnit(this.m_actorWigberht, tr("Wir machen hier Rast, um herauszufinden wie groß das Heer der Orks ist, das in dieses Land eingefallen ist und dann greifen wir es an. Wir müssen uns durch ihre Linien schlagen, um den Dunkelelfen weiter folgen zu können."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_7, true, 0.0)
			call TransmissionFromUnit(thistype.actor(), tr("Ihr paar wollt das Heer der Orks angreifen? Das ist Wahnsinn."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_6, true, 0.0)
			call TransmissionFromUnit(this.m_actorWigberht, tr("Der einzige Weg führt durch die Reihen der Orks. Wir haben keine Wahl. Dieser Herzog, der euch schickt, harrt in seiner Burg aus bis der Feind ihn angreift oder aushungern lässt. Wir sind keine Feiglinge, wir stellen uns dem Feind."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_7, true, 0.0)
			call TransmissionFromUnit(thistype.actor(), tr("Und wann wollt ihr angreifen?"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_6, true, 0.0)
			call TransmissionFromUnit(this.m_actorWigberht, tr("Einer unserer Späher hat gestern eine Vorhut der Orks entdeckt. Sie befindet sich irgendwo im nördlichen Wald. Sobald wir bereit sind, schlagen wir zu. Wenn es euch beliebt dann kommt mit. Ihr seht aus, als würdet ihr gerne ein paar Orks abschlachten."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_7, true, 0.0)
			call TransmissionFromUnit(thistype.actor(), tr("Und was wird aus dem Bündnis?"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_6, true, 0.0)
			call TransmissionFromUnit(this.m_actorWigberht, tr("Beweist mir, dass ihr kampfstark seid und ich werde mir überlegen, ob wir noch eine Weile hier bleiben, um den Herzog zu unterstützen."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_7, true, 0.0)
			call TransmissionFromUnit(thistype.actor(), tr("Sieht aus als hätten wir keine Wahl."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_6, true, 0.0)
			call TransmissionFromUnit(this.m_actorWigberht, tr("Exakt."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorWigberht = null
			set this.m_actorRicman = null
			
			// show other norsemen
			call ShowUnit(gg_unit_n01I_0153, true)
			call ShowUnit(gg_unit_n01I_0152, true)
			
			call Game.resetVideoSettings()
			call QuestTheNorsemen.quest().questItem(1).setState(AAbstractQuest.stateNew)
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, tr("Sprechen Sie Wigberht an, um die Vorhut der Orks anzugreifen."))
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary