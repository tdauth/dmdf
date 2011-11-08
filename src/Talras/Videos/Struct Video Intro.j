library StructMapVideosVideoIntro requires Asl, StructGameGame

	struct VideoIntro extends AVideo

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(12.00)
			call CameraSetupApplyForceDuration(gg_cam_intro_0, true, 0.00)
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
			call CameraSetupApplyForceDuration(gg_cam_intro_1, true, 25.00)
			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr("Nachdem die Orks und Dunkelelfen in das Königreich der Menschen eingefallen waren, schickte man Boten zum König, die diesem von der vermeintlichen Invasion berichteten."), null)
			if (wait(24.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_intro_2, true, 25.00)
			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr("Der König aber, der in den Frieden hineingeboren worden war und nicht die Kraft besaß, selbst an der Spitze seiner Truppen in die Schlacht zu ziehen, hielt es nicht für notwendig Truppen an die Grenze seines Reichs zu schicken."), null)
			if (wait(24.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_intro_3, true, 25.00)
			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr("Stattdessen schickte er die Boten zurück, damit diese sich ein besseres Bild von der Situation machten und erst um Hilfe ersuchen sollten, wenn es denn tatsächlich notwendig wäre."), null)
			if (wait(24.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_intro_4, true, 25.00)
			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr("Viele Bewohner des Reichs waren anderer Meinung als der König und so zogen sie an die Grenze, um den Feind auf eigene Faust aufzuhalten und in dem Glauben, dass wenn ihnen dies nicht gelänge, womöglich ihre Heimat in Schutt und Asche gelegt würde."), null)
			if (wait(24.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_intro_5, true, 25.00)
			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr("Unter diesen Kriegsleuten befanden sich auch ein paar Vasallen, die ihr Geschäft mit den bevorstehenden Kämpfen machen wollten. Sie zogen zur Burg Talras, die sich nahe der Grenze befand, um dem dortigen Herzog ihre Dienste anzubieten."), null)
			if (wait(24.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_intro_6, true, 25.00)
			if (wait(24.00)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_intro_end, true, 22.00)
			if (wait(22.00)) then
				return
			endif
			//character 0 talks
			call TransmissionFromUnit(AVideo.actor(), tr("Das ist der Weg. Direkt vor uns liegt vermutlich die Burg. Wer weiß? Vielleicht steht sie auch schon in Flammen."), null)
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