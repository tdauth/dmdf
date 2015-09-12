/*
Ricman: Männer, macht euch bereit für euer letztes Gefecht. Heute mag der Tag gekommen sein, da wir allesamt das Zeitliche segnen, doch vorher zahlen wir es diesen Bastarden heim.
Ricman: Wenn ihr sterben solltet, seid euch gewiss ihr seid ehrenvoll gestorben wenn eure Klinge vom Blute von mindestens zwanzig Dunkelelfen bedeckt ist.
Ricman: Ihr wisst sie haben uns unseren König genommen, dafür nehmen wir ihnen das Leben! Schlachtet sie ab, lasst keinen am Leben!
Ricman: Auf dann, ein letztes Mal vor dem Morgengrauen! Kämpft für euren König, für seinen Sohn Wigberht, für die Ehre und für den Norden!

Wigberht: Du denkst, du könntest mir Angst machen? Höre, ich habe den Tod gesehen und er ließ mich kalt. Ich sah den Schrecken, den deine Sippe über mein Volk brachte, doch er ließ mich kalt. Dein Tod aber wird mir Freude bereiten!
*/

library StructMapVideosVideoTheDefenseOfTalras requires Asl, StructGameGame

	struct VideoTheDefenseOfTalras extends AVideo
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