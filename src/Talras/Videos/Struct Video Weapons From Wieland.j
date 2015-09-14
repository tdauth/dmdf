library StructMapVideosVideoWeaponsFromWieland requires Asl, StructGameGame

	struct VideoWeaponsFromWieland extends AVideo
		private unit m_actorWieland
		private AGroup m_imps

		implement Video

		public stub method onInitAction takes nothing returns nothing
			local integer i
			call Game.initVideoSettings()
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_wieland_forge_view, true, 0.0)

			set this.m_actorWieland = thistype.unitActor(thistype.saveUnitActor(Npcs.wieland()))
			call SetUnitPositionRect(this.m_actorWieland, gg_rct_video_wieland_wieland)
			call SetUnitFacing(this.m_actorWieland, 227.57)
			call QueueUnitAnimation(this.m_actorWieland, "Attack First")

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_wieland_actor)
			call SetUnitFacingToFaceUnit(thistype.actor(), this.m_actorWieland)
			call IssueRectOrder(thistype.actor(), "move", gg_rct_video_wieland_actor_target)
			
			// The Imps need a new home now! It is shown in the video.
			set this.m_imps = AGroup.create()
			call this.m_imps.units().pushBack(thistype.unitActor(thistype.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'u00C', gg_rct_video_weapons_from_wieland_imp_0, 0.0)))
			call this.m_imps.units().pushBack(thistype.unitActor(thistype.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'u00C', gg_rct_video_weapons_from_wieland_imp_1, 0.0)))
			call this.m_imps.units().pushBack(thistype.unitActor(thistype.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'u00C', gg_rct_video_weapons_from_wieland_imp_1, 0.0)))
			
			set i = 0
			loop
				exitwhen (i == this.m_imps.units().size())
				call SetUnitFacingToFaceUnit(this.m_imps.units()[i], this.m_actorWieland)
				set i = i + 1
			endloop
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call TransmissionFromUnit(thistype.actor(), tr("Schmied Wieland!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call ResetUnitAnimation(this.m_actorWieland)
			call SetUnitFacingToFaceUnit(this.m_actorWieland, thistype.actor())
			
			call TransmissionFromUnit(this.m_actorWieland, tr("Was sind das für Kreaturen?"), gg_snd_Wieland_g)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wieland_g))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_imps.units().front(), tr("Bereit zur Arbeit!"), gg_snd_PeonReady1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_PeonReady1))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Das sind deine neuen Gehilfen!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorWieland, tr("Was zum ..."), gg_snd_Wieland_h)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wieland_h))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Sieh Wieland, es ist so: Sie bringen dir das Eisen, das du brauchst. Du kannst nun deine Waffen schmieden. Frag erst gar nicht woher sie kommen, das ist unwichtig. Du musst nur wissen, dass sie mir teure Dienste erwiesen haben. Nimm sie einfach als deine Gehilfen an."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorWieland, tr("Aber ..."), gg_snd_Wieland_i)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wieland_i))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Sie kommen sogar ohne Nahrung aus ... denke ich. Sie werden alles tun, was du ihnen befiehlst. Ihr Meister hat sie ... er braucht sie nicht mehr."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call SetUnitFacingToFaceUnit(thistype.actor(), this.m_imps.units().front())
			
			call TransmissionFromUnit(thistype.actor(), tr("Nicht wahr?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_imps.units().front(), tr("Meister?"), gg_snd_GruntWhat3)

			if (wait(GetSimpleTransmissionDuration(gg_snd_GruntWhat3))) then
				return
			endif
			
			call SetUnitFacingToFaceUnit(thistype.actor(), this.m_actorWieland)
			
			call TransmissionFromUnit(this.m_actorWieland, tr("Schon gut, aber dass sie mir hier nichts durcheinander bringen. Sie sollen das Eisen dort hinten ablegen. Ich werde eine Weile brauchen, bis die Waffen fertig sind. Warte einfach solange."), gg_snd_Wieland_j)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wieland_j))) then
				return
			endif
			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorWieland = null
			call this.m_imps.destroy()
			set this.m_imps = 0

			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary