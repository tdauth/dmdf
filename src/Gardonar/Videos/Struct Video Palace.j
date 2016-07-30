library StructMapVideosVideoPalace requires Asl, StructGameGame

	struct VideoPalace extends AVideo
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer
		
		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(6.00)
			
			set this.m_actorWigberht = this.saveUnitActor(Npcs.wigberht())
			set this.m_actorDragonSlayer = this.saveUnitActor(Npcs.dragonSlayer())
			set this.m_actorRicman = this.saveUnitActor(Npcs.ricman())
			
			call SetUnitPositionRect(this.actor(), gg_rct_video_palace_actor)
			call SetUnitPositionRect(this.unitActor(this.m_actorWigberht), gg_rct_video_palace_wigberht)
			call SetUnitPositionRect(this.unitActor(this.m_actorDragonSlayer), gg_rct_video_palace_dragon_slayer)
			call SetUnitPositionRect(this.unitActor(this.m_actorRicman), gg_rct_video_palace_ricman)
			call SetUnitFacing(this.actor(), 90.0)
			call SetUnitFacing(this.unitActor(this.m_actorWigberht), 90.0)
			call SetUnitFacing(this.unitActor(this.m_actorDragonSlayer), 90.0)
			call SetUnitFacing(this.unitActor(this.m_actorRicman), 90.0)
			
			call CameraSetupApplyForceDuration(gg_cam_the_gate_0, true, 0.00)
			call CameraSetupApplyForceDuration(gg_cam_the_gate_1, true, 4.00)
			call SetSpeechVolumeGroupsBJ()
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			if (wait(3.50)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_gate_2, true, 2.00)
			if (wait(1.50)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_gate_3, true, 2.00)
			if (wait(1.50)) then
				return
			endif
			// Die Wächterinnen machen sich über die Ankömmlinge lustig, lassen sie aber passieren
			call CameraSetupApplyForceDuration(gg_cam_the_gate_4, true, 2.00)
			if (wait(1.50)) then
				return
			endif
			if (wait(3.50)) then
				return
			endif
		
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapData.neutralPassivePlayer)
			
			return this
		endmethod
	endstruct

endlibrary