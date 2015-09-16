library StructMapVideosVideoHolzbruck requires Asl, StructGameGame

/*
Szene 5 - Der Charakter und der Herzog:
C: Wir haben den Außenposten erfolgreich verteidigt.
Heimrich: Freude, Jubel, jauchzet und frohlocket, es ist vollbracht! Der Feind ist niedergestreckt, besiegt, die Hochelfen sind eingetroffen. Es hätte nicht schöner ausgehen können. Markward wird ihnen alle erdenklichen Wünsche erfüllen und sie mit ihrer nächsten Mission vertraut machen. Das war wirklich ausgezeichnete Arbeit! gg_snd_Heimrich30
*/
	struct VideoHolzbruck extends AVideo
		private integer m_actorHeimrich
		private integer m_actorMarkward
		private integer m_actorOsman
		private integer m_actorFerdinand
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(20.0)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			// TODO Finish this video
			
			if (wait(4.0)) then // wait until end
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary