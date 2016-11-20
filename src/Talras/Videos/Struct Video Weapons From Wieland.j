library StructMapVideosVideoWeaponsFromWieland requires Asl, StructGameGame

	struct VideoWeaponsFromWieland extends AVideo
		private unit m_actorWieland
		private AGroup m_imps

		public stub method onInitAction takes nothing returns nothing
			local integer i
			call Game.initVideoSettings(this)
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_wieland_forge_view, true, 0.0)

			set this.m_actorWieland = this.unitActor(this.saveUnitActor(Npcs.wieland()))
			call SetUnitPositionRect(this.m_actorWieland, gg_rct_video_wieland_wieland)
			call SetUnitFacing(this.m_actorWieland, 227.57)
			call QueueUnitAnimation(this.m_actorWieland, "Attack First")

			call SetUnitPositionRect(this.actor(), gg_rct_video_wieland_actor)
			call SetUnitFacingToFaceUnit(this.actor(), this.m_actorWieland)
			call IssueRectOrder(this.actor(), "move", gg_rct_video_wieland_actor_target)

			// The Imps need a new home now! It is shown in the video.
			set this.m_imps = AGroup.create()
			call this.m_imps.units().pushBack(this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'u00C', gg_rct_video_weapons_from_wieland_imp_0, 0.0)))
			call this.m_imps.units().pushBack(this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'u00C', gg_rct_video_weapons_from_wieland_imp_1, 0.0)))
			call this.m_imps.units().pushBack(this.unitActor(this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'u00C', gg_rct_video_weapons_from_wieland_imp_1, 0.0)))

			set i = 0
			loop
				exitwhen (i == this.m_imps.units().size())
				call SetUnitFacingToFaceUnit(this.m_imps.units()[i], this.m_actorWieland)
				set i = i + 1
			endloop
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_wieland_forge_view)

			call TransmissionFromUnit(this.actor(), tre("Schmied Wieland!", "Blacksmith Wieland!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call ResetUnitAnimation(this.m_actorWieland)
			call SetUnitFacingToFaceUnit(this.m_actorWieland, this.actor())

			call TransmissionFromUnit(this.m_actorWieland, tre("Was sind das für Kreaturen?", "What are these creatures?"), gg_snd_Wieland_g)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wieland_g))) then
				return
			endif

			call TransmissionFromUnit(this.m_imps.units().front(), tre("Bereit zur Arbeit!", "Ready to work!"), gg_snd_PeonReady1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_PeonReady1))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Das sind deine neuen Gehilfen!", "These are your new assistants!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorWieland, tre("Was zum ...", "What the ..."), gg_snd_Wieland_h)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wieland_h))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Sieh Wieland, es ist so: Sie bringen dir das Eisen, das du brauchst. Du kannst nun deine Waffen schmieden. Frag erst gar nicht woher sie kommen, das ist unwichtig. Du musst nur wissen, dass sie mir teure Dienste erwiesen haben. Nimm sie einfach als deine Gehilfen an.", "Look Wieland, it is like that: They bring you the iron you need. You can forge your weapons now. Don't even ask where they come from, that's not important. You just have to know that they have proven costly services to me. Just take them as your assistants."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorWieland, tre("Aber ...", "But ..."), gg_snd_Wieland_i)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wieland_i))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Sie kommen sogar ohne Nahrung aus ... denke ich. Sie werden alles tun, was du ihnen befiehlst. Ihr Meister hat sie ... er braucht sie nicht mehr.", "They don't even need food ... I think. They will do everything you order them to do. Their master has ... he no longer needs them."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call SetUnitFacingToFaceUnit(this.actor(), this.m_imps.units().front())

			call TransmissionFromUnit(this.actor(), tre("Nicht wahr?", "Isn't it like that?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_imps.units().front(), tre("Meister?", "Master?"), gg_snd_GruntWhat3)

			if (wait(GetSimpleTransmissionDuration(gg_snd_GruntWhat3))) then
				return
			endif

			call SetUnitFacingToFaceUnit(this.actor(), this.m_actorWieland)

			call TransmissionFromUnit(this.m_actorWieland, tre("Schon gut, aber dass sie mir hier nichts durcheinander bringen. Sie sollen das Eisen dort hinten ablegen. Ich werde eine Weile brauchen, bis die Waffen fertig sind. Warte einfach solange.", "All right, but they should not disorganize anything here. They should put the iron back there. I will need some time until the weapons are ready. Just wait that time."), gg_snd_Wieland_j)

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
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary