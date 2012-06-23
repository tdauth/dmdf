library StructMapVideosVideoBloodthirstiness requires Asl, StructGameGame

	struct VideoBloodthirstiness extends AVideo
		private unit m_actorDragonSlayer

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary