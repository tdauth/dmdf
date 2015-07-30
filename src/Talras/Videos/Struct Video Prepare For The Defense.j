library StructMapVideosVideoPrepareForTheDefense requires Asl, StructGameGame

	struct VideoPrepareForTheDefense extends AVideo
		private integer m_actorHeimrich
		private integer m_actorMarkward
		private integer m_actorOsman
		private integer m_actorFerdinand
		// TODO add Wigberht, Ricman and Dragon Slayer

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(12.0)
			call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_0, true, 0.0)

			set this.m_actorHeimrich = thistype.saveUnitActor(gg_unit_n013_0116)
			call SetUnitPositionRect(thistype.unitActor(this.m_actorHeimrich), gg_rct_video_the_duke_of_talras_heimrichs_position)

			set this.m_actorMarkward = thistype.saveUnitActor(gg_unit_n014_0117)
			call SetUnitPositionRect(thistype.unitActor(this.m_actorMarkward), gg_rct_video_the_duke_of_talras_markwards_position)
			
			set this.m_actorOsman = thistype.saveUnitActor(Npcs.osman())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorOsman), gg_rct_video_the_duke_of_talras_osmans_position)
			call SetUnitFacing(thistype.unitActor(this.m_actorOsman), 290.39)
			
			set this.m_actorFerdinand = thistype.saveUnitActor(Npcs.ferdinand())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorFerdinand), gg_rct_video_the_duke_of_talras_ferdinands_position)
			call SetUnitFacing(thistype.unitActor(this.m_actorFerdinand), 257.48)

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_the_duke_of_talras_actors_position)

			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorHeimrich), thistype.actor())
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorMarkward), thistype.actor())

			call SetUnitFacingToFaceUnit(thistype.actor(), thistype.unitActor(this.m_actorHeimrich))
			call SetUnitLookAt(thistype.actor(), "bone_head", thistype.unitActor(this.m_actorHeimrich), 0.0, 0.0, 90.0)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call TransmissionFromUnit(thistype.actor(), tr("Wir haben den Auftrag erfüllt."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
		
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorHeimrich), tr("Heimrich"), tr("Macht euch bereit!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			// TODO Finish this video

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
			
			call QuestWar.quest.evaluate().complete()
			call QuestTheDefenseOfTalras.quest.evaluate().enable.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary