library StructMapVideosVideoWelcome requires Asl, StructGameGame, StructMapMapNpcs

	struct VideoWelcome extends AVideo
		private integer m_actorGardonar

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(6.00)
			
			set this.m_actorGardonar = this.saveUnitActor(Npcs.gardonar())
			
			call CameraSetupApplyForceDuration(gg_cam_welcome_0, true, 0.00)
		endmethod

		public stub method onPlayAction takes nothing returns nothing

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorGardonar), tre("Gardonar", "Gardonar"), tr("Ich grüße euch, meine werten Krieger. Tapfer habt ihr euch geschlagen bisher. Ich bin Gardonar, Fürst der Dämonen."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
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