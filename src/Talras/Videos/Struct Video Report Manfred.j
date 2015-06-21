library StructMapVideosVideoReportManfred requires Asl, StructGameGame

	/**
	 * Uses the same rects as video \ref VideoManfred.
	 */
	struct VideoReportManfred extends AVideo
		private unit m_actorManfred
		private unit m_actorManfredsDog

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_manfred_initial_view, true, 0.0)

			set this.m_actorManfred = thistype.unitActor(thistype.saveUnitActor(Npcs.manfred()))
			call SetUnitPositionRect(this.m_actorManfred, gg_rct_video_manfred_manfred)
			
			set this.m_actorManfredsDog = thistype.unitActor(thistype.saveUnitActor(Npcs.manfredsDog()))
			call SetUnitPositionRect(this.m_actorManfredsDog, gg_rct_video_manfred_dog)

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_manfred_actor)
			
			call SetUnitFacingToFaceUnit(thistype.actor(), this.m_actorManfred)
			call SetUnitFacingToFaceUnit(this.m_actorManfred, thistype.actor())
			call SetUnitFacingToFaceUnit(this.m_actorManfredsDog, thistype.actor())
		endmethod

		public stub method onPlayAction takes nothing returns nothing
		
			call TransmissionFromUnit(thistype.actor(), tr("Bauer Manfred!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			// TODO Finish dialog, drum cave iron.

			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorManfred = null
			set this.m_actorManfredsDog = null

			call Game.resetVideoSettings()
			
			call QuestWar.quest.evaluate().questItem.evaluate(QuestWar.questItemReportManfred).complete()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary