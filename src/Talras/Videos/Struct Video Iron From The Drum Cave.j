library StructMapVideosVideoIronFromTheDrumCave requires Asl, StructGameGame

	struct VideoIronFromTheDrumCave extends AVideo
		private unit m_actorBaldar
		private unit m_actorImp

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_baldar, true, 0.0)

			set this.m_actorBaldar = thistype.unitActor(thistype.saveUnitActor(Npcs.baldar()))
			call SetUnitPositionRect(this.m_actorBaldar, gg_rct_video_iron_from_the_drum_cave_baldar)
			
			set this.m_actorImp = thistype.unitActor(thistype.saveUnitActor(gg_unit_u001_0190))
			call SetUnitPositionRect(this.m_actorImp, gg_rct_video_iron_from_the_drum_cave_imp)
			call QueueUnitAnimation(this.m_actorImp , "Attack")
			
			call SetUnitPositionRect(thistype.actor(), gg_rct_video_iron_from_the_drum_cave_actor)
			call SetUnitFacingToFaceUnit(thistype.actor(), this.m_actorBaldar)
			call SetUnitFacingToFaceUnit(this.m_actorBaldar, thistype.actor())
		endmethod

		public stub method onPlayAction takes nothing returns nothing
		
			call TransmissionFromUnit(this.m_actorBaldar, tr("Was sagt ihr? Ihr braucht Eisen aus meinen Minen?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("So ist es."), null)
			

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorBaldar, tr("Was habe ich davon mein Eisen euch zu geben anstatt meine eigenen Krieger damit auszurüsten, um meinen Bruder endlich zu besiegen?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Die Orks und Dunkelelfen werden sonst bald hier einfallen und alles dem Erdboden gleich machen. Ist Euch das lieber?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorBaldar, tr("Nein. Die Menschen lassen uns zumindest in Ruhe. Sie haben vermutlich viel zu viel Angst als dass sie diese Höhle betreten würden. Alle bis auf euch."), null)
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			// TODO working imps?
			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_mine_0, true, 0.0)
			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_mine_1,  true, 4.00)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			
			call TransmissionFromUnit(this.m_actorBaldar, tr("Ich kann euch einen Teil meines Eisens geben. Meine Imps können es für euch zur Burg transportieren, jedoch brauche ich die kräftigsten Imps hier bei mir. Ich schicke euch also die schwachen Imps. Ihr müsst sie auf ihrem Weg beschützen, ansonsten werden sie vermutlich von wilden Kreaturen umgebracht."), null)
			
			if (wait(1.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_mine_2, true, 4.00)
			
			if (wait(3.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_mine_3, true, 4.00)
			
			if (wait(3.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_mine_4, true, 4.00)
			
			if (wait(3.50)) then
				return
			endif
			
			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_mine_5, true, 4.00)
			
			if (wait(3.50)) then
				return
			endif
			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorBaldar = null
			set this.m_actorImp = null

			call Game.resetVideoSettings()

			call QuestWar.quest.evaluate().enableImpSpawn.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary