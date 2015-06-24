library StructMapVideosVideoRecruit requires Asl, StructGameGame

	struct VideoRecruit extends AVideo
		private unit m_actorFerdinand
		private unit m_actorManfred

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_recruit_initial_view, true, 0.0)

			set this.m_actorFerdinand = thistype.unitActor(thistype.saveUnitActor(Npcs.ferdinand()))
			call SetUnitPositionRect(this.m_actorFerdinand, gg_rct_video_recruit_ferdinand)
			
			set this.m_actorManfred = thistype.unitActor(thistype.saveUnitActor(Npcs.manfred()))
			call SetUnitPositionRect(this.m_actorManfred, gg_rct_video_recruit_manfred)

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_recruit_actor)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
		
			call TransmissionFromUnit(this.m_actorFerdinand, tr("Hört mich an Bauern!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			// TODO Finish dialog, drum cave iron.

			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorFerdinand = null
			set this.m_actorManfred = null

			call Game.resetVideoSettings()
			call QuestWar.quest.evaluate().enableGetRecruits.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary