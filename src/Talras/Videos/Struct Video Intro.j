library StructMapVideosVideoIntro requires Asl, StructGameGame

	struct VideoIntro extends AVideo
		private integer m_worker0
		private integer m_worker1
		private integer m_worker2
		private integer m_actorMathilda
		private integer m_actorLothar
		private integer m_actorManfred
		private integer m_actorManfredsDog
		private integer m_actorHeimrich
		private integer m_actorMarkward

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(6.00)
			
			call SetSpeechVolumeGroupsBJ()
			
			call SetSkyModel("Environment\\Sky\\LordaeronSummerSky\\LordaeronSummerSky.mdl")
			call CameraSetupApplyForceDuration(gg_cam_intro_orc, true, 0.00)
			call SetUnitPositionRect(thistype.actor(), gg_rct_video_intro_character)
			call SetUnitFacing(thistype.actor(), 0.0)
			
			set this.m_worker0 = thistype.saveUnitActor(gg_unit_n02J_0013)
			call SetUnitPositionRect(thistype.unitActor(this.m_worker0), gg_rct_video_intro_worker_0)
			call SetUnitFacing(thistype.unitActor(this.m_worker0), 168.59)
			call QueueUnitAnimation(thistype.unitActor(this.m_worker0), "Stand Work")
			
			set this.m_worker1 = thistype.saveUnitActor(gg_unit_n02J_0157)
			call SetUnitPositionRect(thistype.unitActor(this.m_worker1), gg_rct_video_intro_worker_1)
			call SetUnitFacing(thistype.unitActor(this.m_worker1), 322.41)
			call QueueUnitAnimation(thistype.unitActor(this.m_worker1), "Stand Work")
			
			set this.m_worker2 = thistype.saveUnitActor(gg_unit_n02J_0159)
			call SetUnitPositionRect(thistype.unitActor(this.m_worker2), gg_rct_video_intro_worker_2)
			call SetUnitFacing(thistype.unitActor(this.m_worker2), 24.72)
			call QueueUnitAnimation(thistype.unitActor(this.m_worker2), "Stand Work")
			
			// gg_unit_n02J_0158
			
			set this.m_actorMathilda = thistype.saveUnitActor(Npcs.mathilda())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorMathilda), gg_rct_video_intro_mathilda)
			call SetUnitFacing(thistype.unitActor(this.m_actorMathilda), 74.69)
			
			set this.m_actorManfred = thistype.saveUnitActor(Npcs.manfred())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorManfred), gg_rct_video_intro_manfred)
			call SetUnitFacing(thistype.unitActor(this.m_actorManfred), 338.19)
			
			set this.m_actorManfredsDog = thistype.saveUnitActor(Npcs.manfredsDog())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorManfredsDog), gg_rct_video_intro_manfreds_dog)
			call SetUnitFacing(thistype.unitActor(this.m_actorManfredsDog), 281.27)
			
			/*
			private integer m_actorMathilda
			private integer m_actorLothar
			private integer m_actorManfred
			private integer m_actorManfredsDog
			private integer m_actorHeimrich
			private integer m_actorMarkward
			*/
			
			call VolumeGroupSetVolume(SOUND_VOLUMEGROUP_MUSIC, 1.0) /// @todo test!
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			local player user = Player(PLAYER_NEUTRAL_PASSIVE)
			local unit characterUnit
			call PlayThematicMusic("Music\\Intro.mp3")
			if (wait(0.50)) then
				return
			endif
			call TransmissionFromUnitType('n00W', user, tre("Erzähler", "Narrator"), tre("Nachdem die Orks und Dunkelelfen in das Königreich der Menschen eingefallen waren, wussten viele der Adeligen, von denen die meisten in den Frieden hineingeboren wurden, nicht wie sie auf die vermeintliche Invasion reagieren sollten.", "After the Orcs and Dark Elves invaded the kingdom of the humans, many of the aristocrats, of whom most were born into peace, did not know how to react to the supposed invasion."), gg_snd_ErzaehlerIntro1)
			if (wait(GetSimpleTransmissionDuration(gg_snd_ErzaehlerIntro1))) then
				return
			endif
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_intro_start_0, true, 0.00)
			call CameraSetupApplyForceDuration(gg_cam_intro_start_1, true, GetSimpleTransmissionDuration(gg_snd_ErzaehlerIntro2) + 3.0)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(1.50)) then
				return
			endif
			call TransmissionFromUnitType('n00W', user, tre("Erzähler", "Narrator"), tre("Da der König, der selbst einen schwachen Willen hatte, keine Truppen an die Grenze seines Reiches entsandt, mussten die dort ansäßigen Fürsten und Herzöge selbst mit dem neuen Feind zurechtkommen.", "Since the king, who himself had a weak will, did not send troops to the border of his empire, the local resident princes and dukes had to deal with the new enemies by themselves."), gg_snd_ErzaehlerIntro2)
			if (wait(GetSimpleTransmissionDuration(gg_snd_ErzaehlerIntro2))) then
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

			call TransmissionFromUnitType('n00W', user, tre("Erzähler", "Narrator"), tre("Doch auch das einfachere Volk sah in dem bevorstehenden Krieg viele Veränderungen auf sich zu kommen.", "But the simple people as well saw many changes coming by the forthcoming war."), gg_snd_ErzaehlerIntro3)
			if (wait(GetSimpleTransmissionDuration(gg_snd_ErzaehlerIntro3))) then // wait until "So kämpften die einen dafür ..."
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

			call TransmissionFromUnitType('n00W', user, tre("Erzähler", "Narrator"), tre("So kämpften die einen dafür, ihr bisheriges Leben wie gewohnt fortzusetzen …", "Hence some fought to continue their present life as usual …"), gg_snd_ErzaehlerIntro4)
			if (wait(GetSimpleTransmissionDuration(gg_snd_ErzaehlerIntro4))) then // wait until "während die anderen …"
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

			call TransmissionFromUnitType('n00W', user, tre("Erzähler", "Narrator"), tre("… während die anderen den eigenen Vorteil aus der Sache zogen.", "… while others took their own advantage of it."), gg_snd_ErzaehlerIntro5)
			if (wait(GetSimpleTransmissionDuration(gg_snd_ErzaehlerIntro5))) then // wait until end
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
			call TransmissionFromUnitType('n00W', user, tre("Erzähler", "Narrator"), tre("Unsere Geschichte beginnt unweit der Burg Talras, deren Herzog sich, wie viele andere Adelige, von der feindlichen Übermacht bedroht fühlt.", "Our story begins not far from the castle Talras of which its duke, like many other aristocrats, feels threatened by the hostile superiority."), gg_snd_ErzaehlerIntro6)
			if (wait(GetSimpleTransmissionDuration(gg_snd_ErzaehlerIntro6))) then
				return
			endif

			set user = null
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call EndThematicMusic()
			call Game.resetVideoSettings()
			
			// now start the game
			// call by .evaluate() since after the onStopAction() which is also called with .evaluate() there are some further actions
			call MapData.startAfterIntro.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setPlayFilterTime(0.0)
			
			return this
		endmethod
	endstruct

endlibrary