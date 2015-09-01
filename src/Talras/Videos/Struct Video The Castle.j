library StructMapVideosVideoTheCastle requires Asl, StructGameGame

	struct VideoTheCastle extends AVideo

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(16.00)
			call PlayThematicMusic("Music\\TheCastle.mp3")
			call SetSkyModel("Environment\\Sky\\LordaeronSummerSky\\LordaeronSummerSky.mdl")
			call CameraSetupApplyForceDuration(gg_cam_new_the_castle_0, true, 0.0)
			
			// actor
			call SetUnitPositionRect(thistype.actor(), gg_rct_video_the_castle_character)
			call SetUnitFacing(thistype.actor(), 182.64)
			call IssuePointOrder(thistype.actor(), "move", GetRectCenterX(gg_rct_video_the_castle_character_target), GetRectCenterY(gg_rct_video_the_castle_character_target))
			call SetUnitMoveSpeed(thistype.actor(), 200.0)
		endmethod

		/*
		   call CameraSetupApplyForPlayer( true, gg_cam_new_the_castle_0, Player(0), 0 )
    call TriggerSleepAction( 0.50 )
    call CameraSetupApplyForPlayer( true, gg_cam_new_the_castle_1, Player(0), 0.00 )
    call TriggerSleepAction( 4.00 )
    call CameraSetupApplyForPlayer( true, gg_cam_new_the_castle_2, Player(0), 0.00 )
    call TriggerSleepAction( 4.00 )
    call CameraSetupApplyForPlayer( true, gg_cam_new_the_castle_3, Player(0), 0.00 )
    call TriggerSleepAction( 4.00 )
    call CameraSetupApplyForPlayer( true, gg_cam_new_the_castle_4, Player(0), 4.50 )
    call TriggerSleepAction( 4.00 )
    call CameraSetupApplyForPlayer( true, gg_cam_new_the_castle_5, Player(0), 4.50 )
    call TriggerSleepAction( 4.00 )
    call CameraSetupApplyForPlayer( true, gg_cam_new_the_castle_6, Player(0), 4.50 )
    call TriggerSleepAction( 4.00 )
    call CameraSetupApplyForPlayer( true, gg_cam_new_the_castle_7, Player(0), 0.00 )
    call TriggerSleepAction( 4.00 )
    */
    
    /*
     * Erzähler:
     * So betraten unsere Helden die alte Burg Talras um dem Herzog die Treue zu schwören, doch was ihnen durch den Kopf ging war nicht etwa die Treue zu ihren Artgenossen, sondern viel mehr wie viele Goldmünzen der Herzog locker machen würde.
     * 
     * Die Burg Talras schützte das umliegende Land vor Überfällen doch würde sie auch einer Invasion der Orks und Dunkelelfen stand halten?
     *
     * Eines war unseren Freunden jedoch klar: Es gab viel zu tun.
     */
		public stub method onPlayAction takes nothing returns nothing
			local player user = Player(PLAYER_NEUTRAL_PASSIVE)
			
			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr("So betraten unsere Helden die alte Burg Talras um dem Herzog die Treue zu schwören, doch was ihnen durch den Kopf ging war nicht etwa die Treue zu ihren Artgenossen, sondern viel mehr wie viele Goldmünzen der Herzog locker machen würde."), gg_snd_ErzaehlerDieBurg1)
		
			call SetDoodadAnimationRect(gg_rct_gate_0, 'D085', "Death", false)

			if (wait(2.50)) then
				return
			endif
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call TriggerSleepAction(2.50)
			call CameraSetupApplyForceDuration(gg_cam_new_the_castle_1, true, 0.0)
			call TriggerSleepAction(0.50)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			
			if (wait(RMaxBJ(GetSimpleTransmissionDuration(gg_snd_ErzaehlerDieBurg1) - 2.50 - 2.50 - 0.5, 0.0))) then
				return
			endif
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call TriggerSleepAction(2.50)
			call CameraSetupApplyForceDuration(gg_cam_new_the_castle_2, true, 0.0)
			call TriggerSleepAction(0.50)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			
			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr("Die Burg Talras schützte das umliegende Land vor Überfällen doch würde sie auch einer Invasion der Orks und Dunkelelfen stand halten?"), gg_snd_ErzaehlerDieBurg2)
			
			if (wait(5.0)) then // TODO Transmission duration
				return
			endif
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call TriggerSleepAction(2.50)
			call CameraSetupApplyForceDuration(gg_cam_new_the_castle_3, true, 0.0)
			call TriggerSleepAction(0.50)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			
			call CameraSetupApplyForceDuration(gg_cam_new_the_castle_4, true, 3.50)
			
			if (wait(3.0)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_new_the_castle_5, true, 3.50)
			
			if (wait(3.0)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_new_the_castle_6, true, 3.50)
			
			if (wait(3.0)) then
				return
			endif
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call TriggerSleepAction(2.50)
			
			// make sure the sound played to the end before the next one starts
			call TriggerSleepAction(RMaxBJ(GetSimpleTransmissionDuration(gg_snd_ErzaehlerDieBurg2) - 5.0 - 2.50 -0.50 - 3.0 - 3.0 - 3.0 - 2.50, 0.0))
			
			call CameraSetupApplyForceDuration(gg_cam_new_the_castle_7, true, 0.0)
			call TriggerSleepAction(0.50)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			
			call SetDoodadAnimationRect(gg_rct_gate_1, 'D085', "Death", false)
			call SetDoodadAnimationRect(gg_rct_gate_2, 'D053', "Death", false)
			
			call TransmissionFromUnitType('n00W', user, tr("Erzähler"), tr(" Eines war unseren Freunden jedoch klar: Es gab viel zu tun."), gg_snd_ErzaehlerDieBurg3)
			
			if (wait(GetSimpleTransmissionDuration(gg_snd_ErzaehlerDieBurg3))) then
				return
			endif
			
			call this.stop()
			
			set user = null
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call EndThematicMusic()
			call Game.resetVideoSettings()
			
			call SetDoodadAnimationRect(gg_rct_gate_0, 'D085', "Death", false)
			call SetDoodadAnimationRect(gg_rct_gate_1, 'D085', "Death", false)
			call SetDoodadAnimationRect(gg_rct_gate_2, 'D053', "Death", false)
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary