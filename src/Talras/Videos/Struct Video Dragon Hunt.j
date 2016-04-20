library StructMapVideosVideoDragonHunt requires Asl, StructGameGame

	struct VideoDragonHunt extends AVideo
		private unit m_actorDragonSlayer

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(0.0)
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_0, true, 0.00)

			call SetUnitPositionRect(this.actor(), gg_rct_video_dragon_hunt_actor)
			call SetUnitFacing(this.actor(), 90.0)
			call IssueRectOrder(this.actor(), "move", gg_rct_video_dragon_hunt_actor_target_0)

			set this.m_actorDragonSlayer = this.unitActor(this.saveUnitActor(Npcs.dragonSlayer()))
			//call SetUnitPositionRect(this.m_actorDragonSlayer, gg_rct_video_dragon_hunt_dragon_slayer) use initial rect
			//call SetUnitFacing(this.m_actorDragonSlayer, 90.0) use initial facing.


		endmethod

		public stub method onPlayAction takes nothing returns nothing
			if (wait(1.0)) then
				return
			endif
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_1, true, 0.0)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(1.0)) then
				return
			endif
			call SetUnitFacingToFaceUnitTimed(this.m_actorDragonSlayer, this.actor(), 0.50)

			if (wait(0.50)) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Warte Mensch!", "Wait human!"), gg_snd_DragonSlayer1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayer1) + 1.0)) then
				return
			endif
			
			loop
				exitwhen (RectContainsUnit(gg_rct_video_dragon_hunt_actor_target_0, this.actor()))
				if (wait(1.0)) then
					return
				endif
			endloop

			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_2, true, 0.0)
			call SetUnitFacingToFaceUnitTimed(this.actor(), this.m_actorDragonSlayer, 0.50)

			if (wait(1.50)) then
				return
			endif

			call IssueRectOrder(this.actor(), "move", gg_rct_video_dragon_hunt_actor_target_1)

			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_3, true, 4.0)

			loop
				exitwhen (RectContainsUnit(gg_rct_video_dragon_hunt_actor_target_1, this.actor()))
				if (wait(1.0)) then
					return
				endif
			endloop

			call SetUnitFacingToFaceUnit(this.m_actorDragonSlayer, this.actor())
			call SetUnitFacingToFaceUnit(this.actor(), this.m_actorDragonSlayer)

			call TransmissionFromUnit(this.actor(), tre("Was gibt es?", "What is it?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Wer bist du?", "Who are you?"), gg_snd_DragonSlayer3)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayer3))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_4, true, 0.0)

			call TransmissionFromUnit(this.actor(), tre("Meine Gefährten und ich ...", "My fellows and I ..."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_3, true, 0.0)

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Willst du schlachten, töten, ins Verderben stürzen?", "Do you want to slaughter, kill, bring ruin?"), gg_snd_DragonSlayer2)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayer2))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_1, true, 0.0)

			call TransmissionFromUnit(this.actor(), tre("Was?", "What?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_4, true, 0.0)

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Ich kam hierher, aus Tfjahn, dem Königreich der Hochelfen, um einen Drachen zu besiegen. Man sagte mir, in Mittilant, diesem Königreich, gäbe es davon noch wenige. Aber hier habe ich nur einfache Feldarbeiter und untotes Vieh gefunden.", "I came here from Tfjahn, the kingdom of the High Elves, to defat a dragon. They sold me in Mittilant, this kingdom, there were only few. But here I have found only simple field workers and undead beasts."), gg_snd_DragonSlayer4)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayer4))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("In dem Wald dort hinten tummeln sich die Bestien dicht an dicht, aber keine Spur eines Drachen. Das beschäftigt mich schwer, denn ich habe seit Tagen kein Blut mehr gesehen.", "In the forest back there, the beasts frolicking densley packed but no trace of a dragon. This is on my mind heavily for I have seen no more blood for days."), gg_snd_DragonSlayer5)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayer5))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Interessant.", "Interesting."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_3, true, 0.0)

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Ich muss schlachten, ich will alles vernichten, töten! Dieses verfluchte Königreich!", "I have to slaughter, I want to destroy everything, to kill! This cursed kingdom!"), gg_snd_DragonSlayer6)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayer6))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_1, true, 0.0)

			call TransmissionFromUnit(this.actor(), tre("Wieso gehst du nicht in den Wald und tust es? Von uns Menschen hindert dich sicher keiner daran.", "Why don't you go into the woods and do it? From us humans nobody will prevent you for sure."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_3, true, 0.0)

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Ah! Jede Heldin braucht einen Barden, der ihre Taten an die einfachen Sterblichen weitergibt, denen das Heldentum nicht vergönnt ist. Du, du und deine Gefährten, ihr müsst mich begleiten und der Welt von meinen Taten berichten!", "Ah! Each hero needs a bard who passes on her actions to the mere mortals whom heroism is not granted. You, you and your fellows, you must come with me and tell the world of my deeds!"), gg_snd_DragonSlayer7)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayer7))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_1, true, 0.0)

			call TransmissionFromUnit(this.actor(), tre("Ach so ...", "Oh ..."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_dragon_hunt_4, true, 0.0)

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Erweist mir diesen Gefallen, sodass ich ein letztes Mal Blut an meiner Klinge sehe.", "Do me this favor, so I see one last time blood on my blade."), gg_snd_DragonSlayer8)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayer8))) then
				return
			endif


			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorDragonSlayer = null
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapData.neutralPassivePlayer)
			
			return this
		endmethod
	endstruct

endlibrary