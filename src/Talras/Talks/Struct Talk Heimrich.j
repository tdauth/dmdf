library StructMapTalksTalkHeimrich requires Asl, StructMapMapNpcs, StructMapQuestsQuestTheNorsemen

	struct TalkHeimrich extends ATalk

		implement Talk

		private method startPageAction takes nothing returns nothing
			call this.showUntil(4)
		endmethod

		// Ich grüße Euch.
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Ich grüße Euch."), null)
			call speech(info, true, tr("Hat Er nicht einen Auftrag? Falls es Schwierigkeiten gibt, sollte Er sich zunächst an meinen getreuen Ritter Markward oder meinen Vogt Ferdinand wenden."), null)
			call info.talk().showStartPage()
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1And2And3 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Was ist mit Eurer Frau und Euren Nachkommen?
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Was ist mit Eurer Frau und Euren Nachkommen?"), null)
			call speech(info, true, tr("Sie befinden sich bei meinem Vetter, in Sicherheit. Ich würde sie niemals der Gefahr hier aussetzen. Aber Er soll mir erklären, weshalb es Ihn interessiert."), null)
			call speech(info, false, tr("Ich war nur besorgt um Euch …"), null)
			call speech(info, true, tr("So? Dann danke ich Ihm für Seine Anteilnahme, jedoch sollte Er sich nun wieder um die benötigte Verstärkung kümmern."), null)
			call info.talk().showStartPage()
		endmethod

		// Habt Ihr diese Burg errichtet?
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Habt Ihr diese Burg errichtet?"), null)
			call speech(info, true, tr("Talras wird von meinem Geschlecht seit drei Generationen bewohnt. Mein Großvater bekam dieses Land und den Titel eines Ritters vom König für seine Tapferkeit im Krieg."), null)
			call speech(info, true, tr("Er ließ die einfache Holzbefestigung ausbauen, mit Stein und heute ist es eine stattliche Burg. Zusammen mit der Zeit vor meinem Großvater ist sie fast zweihundert Jahre alt."), null)
			call speech(info, true, tr("Ebenfalls ein stattliches Alter. Ich fürchte jedoch dieser Tage um mein Erbe. Falls die Feinde es mir nehmen sollten, bin ich ein armer Mann, wie es einst mein Großvater war."), null)
			call speech(info, false, tr("So so …"), null)
			call info.talk().showStartPage()
		endmethod

		// Was geschieht nun?
		private static method infoAction3 takes AInfo info returns nothing
			call speech(info, false, tr("Was geschieht nun?"), null)
			// (Auftrag „Die Nordmänner“ ist aktiv)
			if (QuestTheNorsemen.quest().isNew()) then
				call speech(info, true, tr("Sorgt Er nur dafür, dass jene wilden Nordmänner sich meiner anschließen, damit wir aus dem Krieg als Sieger hervorgehen."), null)
			// (Auftrag „Der Weg nach Holzbruck“ ist aktiv)
			else
				call speech(info, true, tr("Er muss mit den Seefahrern Richtung Norden nach Holzbruck ziehen, um dort mehr Kriegsfähige zu finden, damit wir eine Chance gegen den Feind haben."), null)
			endif

			call info.talk().showStartPage()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.heimrich(), thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Ich grüße Euch.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1And2And3, thistype.infoAction1, tr("Was ist mit Eurer Frau und Euren Nachkommen?")) // 1
			call this.addInfo(false, false, thistype.infoCondition1And2And3, thistype.infoAction2, tr("Habt Ihr diese Burg errichtet?")) // 2
			call this.addInfo(true, false, thistype.infoCondition1And2And3, thistype.infoAction3, tr("Was geschieht nun?")) // 3
			call this.addExitButton() // 4

			return this
		endmethod
	endstruct

endlibrary