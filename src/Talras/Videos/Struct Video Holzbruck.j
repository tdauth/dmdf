library StructMapVideosVideoHolzbruck requires Asl, StructGameGame

/*
Szene 5 - Der Charakter und der Herzog:
C: Wir haben den Außenposten erfolgreich verteidigt.
Heimrich: Freude, Jubel, jauchzet und frohlocket, es ist vollbracht! Der Feind ist niedergestreckt, besiegt, die Hochelfen sind eingetroffen. Es hätte nicht schöner ausgehen können. Markward wird ihnen alle erdenklichen Wünsche erfüllen und sie mit ihrer nächsten Mission vertraut machen. Das war wirklich ausgezeichnete Arbeit! gg_snd_Heimrich30

Markward: Ausgezeichnete Arbeit. Von dieser Schlacht wird man noch sehr lange in Talras sprechen. Ihr habt dem Herzog und allen anderen in Talras neue Hoffung geschenkt. gg_snd_Markward44
Markward: Leider ist die Gefahr damit nur vorerst gebannt. Uns kam von weiteren Truppenbewegungen zu Ohren. Anscheinend haben die Orks und Dunkelelfen nun vor, die weiter nördlich gelegene Stadt Holzbruck anzugreifen. gg_snd_Markward45
Markward: Ich konnte den Herzog davon überzeugen euch nach Holzbruck zu schicken, um die Stadt bei ihrem Kampf zu unterstützen. Da die Nordmänner sowieso weiter in Richtung Norden segeln wollen, können sie euch sicherlich dorthin bringen. gg_snd_Markward46
Markward: Wir sind dank der Hochelfen erst einmal sicher. gg_snd_Markward47

Drachentöterin: Mein König hat mir gestattet euch auf eurer weiteren Reise zu begleiten. Er sieht großen Nutzen darin, mehr über die Orks und Dunkelelfen in Erfahrung zu bringen. Das bedeutet, wir werden gemeinsam nach Holzbruck aufbrechen.

Markward: Sehr gut. Wenn ihr Holzbruck erfolgreich verteidigt habt, könnt ihr zurückkehren. Der Herzog wird euch reich belohnen, die Bewohner von Holzbruck selbst jedoch vermutlich noch reicher. Es handelt sich um eine sehr wohlhabende Stadt. Ich hoffe, wir verlieren euch nicht an sie. gg_snd_Markward48
Markward: Hier habt ihr noch die Belohnung für den zuletzt erfolgreich abgeschlossenen Auftrag. Es war mir eine große Ehre euch zu treffen. Ich wünsche euch viel Glück auf eurer Reise! gg_snd_Markward49
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