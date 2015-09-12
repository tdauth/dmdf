/*
Szene 1 - Dararos und die Drachentöterin:
Drachentöterin: Mein König, ich wusste nicht, dass Ihr Euch persönlich auf den Weg macht.
Dararos: <Name> (aus Buch) es musste sein. Deranors Verschwinden hat den Fürsten der Dunkelelfen aus seiner Festung gelockt. Ich konnte nicht zögern mir diese Chance entgehen zu lassen.
Dararos: Wir werden jedoch erst mehr Männer sammeln und dann in Richtung Norden ziehen. Vielleicht können wir ihn auf offenem Felde stellen.
Drachentöterin: Ihr wollt Euren Bruder ... ich meine ihren Fürsten schließlich angreifen?
Dararos: So ist es. Du hast sehr gute Dienste geleistet. Deranor war eine große Bedrohung für uns. Nun da er sich vermutlich für sehr lange Zeit erst einmal zurückziehen musste, ist mein Bruder geschwächt.
Dararos: Deine Verbündeten hier haben sehr tapfer gekämpft. Mir scheint ich habe die Menschen unterschätzt. Wenn Sie nur wüssten, dass der König der Dunkelelfen selbst ein Mensch ist, dann ...
Dararos: Nun denn, ich habe entschieden, dass du die Menschen weiter unterstützt. Mir kam zu Ohren, dass die Nordmänner ebenfalls in Richtung Norden ziehen wollen. Vielleicht kannst du schon einiges in Erfahrung bringen lange bevor mein Heer aufgestellt ist.
Dararos: Schließ dich den Nordmännern an und berichte mir von Zeit zu Zeit weiter wie bisher.
Drachentöterin: Wie Ihr wünscht mein König.


Szene 2 - Wigberht, die Nordmänner und die Charaktere:
Wigberht: Ihr habt Tapfer gekämpft. Diese Schlacht hätte auch anders ausgehen können. Wir kehren nun zu unserem Lager zurück.
Wigberht: Warten wir ab, ob der Herzog noch unsere Hilfe braucht. Ricman kümmere dich darum, dass wir bald aufbrechen können!
Ricman: Ich werde das Boot beladen lassen, mein Heer.


Szene 3 - Das Schlachtfeld und der Fürst der Dunkelelfen:
Erzähler: So siegten die Menschen über die Orks und Dunkelelfen in einer Schlacht von der man sich in Talras noch lange danach erzählen wird, wenn sich die Nachricht erst verbreitet hat.

Erzähler: Ich aber hatte die Verwundeten zu versorgen, die Verwundeten meiner Artgenossen - den Dunkelelfen. Doch genug von mir.

Szene 4 - Die Drachentöterin, der Charakter und die Nordmänner: 
Drachentöterin: Mein König hat mir gestattet euch auf eurer weiteren Reise zu begleiten. Er sieht großen Nutzen darin, mehr über die Orks und Dunkelelfen in Erfahrung zu bringen. Das bedeutet, wir werden gemeinsam nach Holzbruck aufbrechen.
*/
library StructMapVideosVideoVictory requires Asl, StructGameGame

	struct VideoVictory extends AVideo
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