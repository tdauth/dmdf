library StructMapVideosVideoIntro requires Asl, StructGameGame

	struct VideoIntro extends AVideo

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(6.00)
			call CameraSetupApplyForceDuration(gg_cam_intro_orc, true, 0.00)
			call SetUnitPositionRect(AVideo.actor(), gg_rct_character_0_start)
			call SetUnitFacing(AVideo.actor(), 0.0)
			call VolumeGroupSetVolume(SOUND_VOLUMEGROUP_MUSIC, 1.0) /// @todo test!
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			local player user = Player(PLAYER_NEUTRAL_PASSIVE)
			local unit characterUnit
			call PlayThematicMusic("Music\\Intro.mp3")
			if (wait(0.50)) then
				return
			endif
			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr("Nachdem die Orks und Dunkelelfen in das Königreich der Menschen eingefallen waren, wussten viele der Adeligen, von denen die meisten in den Frieden hineingeboren wurden, nicht wie sie auf die vermeintliche Invasion reagieren sollten."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_intro_start_0, true, 0.00)
			call CameraSetupApplyForceDuration(gg_cam_intro_start_1, true, GetSimpleTransmissionDuration(null) + 3.0)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(1.50)) then
				return
			endif
			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr("Da der König, der selbst einen schwachen Willen hatte, keine Truppen an die Grenze seines Reiches entsandt, mussten die dort ansäßigen Fürsten und Herzöge selbst mit dem neuen Feind zurechtkommen."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_intro_village, true, 0.0)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif

			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr("Doch auch das einfachere Volk sahen in dem bevorstehenden Krieg viele Veränderungen auf sich zu kommen."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then // wait until "So kämpften die einen dafür ..."
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_intro_norsemen, true, 0.0)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif

			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr("So kämpften die einen dafür, ihr bisheriges Leben wie gewohnt fortzusetzen …"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then // wait until "während die anderen …"
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_intro_characters, true, 0.0)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then // wait until end
				return
			endif

			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr("… während die anderen den eigenen Vorteil aus der Furcht der Beteiligten zogen."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then // wait until end
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_intro_duke, true, 0.00)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr("Unsere Geschichte beginnt unweit der Burg Talras, deren Herzog sich, wie so viele, von der feindlichen Übermacht enorm bedroht fühlt."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			set user = null
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call EndThematicMusic()
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary