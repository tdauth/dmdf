library StructMapTalksTalkManfred requires Asl

	struct TalkManfred extends ATalk
		implement Talk

		private method startPageAction takes nothing returns nothing
			call this.showUntil(4)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Hallo."), null)
			call speech(info, true, tr("Hallo. Suchst du zufällig Arbeit?"), null)
			call info.talk().showRange(5, 6)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Was hältst du vom Herzog?
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Was hältst du vom Herzog?"), null)
			call speech(info, true, tr("Er hat dich doch nicht etwa geschickt oder? Sonst würde ich wohl meine Zunge hüten."), null)
			call speech(info, false, tr("Nein."), null)
			call speech(info, true, tr("Na ja, eigentlich kann's mir auch egal sein. Ohne mich und meine Leute hat er kaum etwas zu essen und falls es zur Belagerung käme, würde er schon nach ein paar Tagen verhungern."), null)
			call speech(info, true, tr("Vor einer Weile waren seine Leute hier und haben sich nach der Ernte erkundigt. Ich wette, die nehmen sich einfach alles, wenn es hart auf hart kommt, aber mir bleibt keine Wahl."), null)
			call speech(info, true, tr("Ich hab mir das hier nach und nach aufgebaut. Meine Eltern waren hart arbeitende Leute und hatten kaum genug zum Leben. Eigentlich müsste ich mit dem zufrieden sein, was ich habe."), null)
			call speech(info, true, tr("Aber dieser verdammte Adel macht es einem ja nicht gerade leicht. Also, ich halte vom Herzog nicht allzu viel. Er sollte mir lieber mal ein paar Leute schicken, die auf meine Felder und Leute aufpassen, wenn es wirklich stimmt, dass der Feind schon recht nah ist."), null)
			call speech(info, true, tr("Am Ende lassen die uns wahrscheinlich nicht mal in die Burg. Der Herzog hat jetzt auch noch unseren Kriegsdienst auf ein Jahr eingefordert, falls der Feind hier aufkreuzt. Als ob ich nicht genug zu tun hätte."), null)
			call info.talk().showRange(7, 8)
		endmethod

		// (Nachdem der Charakter mit Mathilda darüber gesprochen hat)
		/// @todo FIXME
		private static method infoCondition2 takes AInfo info returns boolean
			return true
		endmethod

		// Du lässt Mathilda in deiner Scheune pennen?
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Du lässt Mathilda in deiner Scheune pennen?"), null)
			call speech(info, true, tr("Klar, wieso nicht? Sie hat mir dafür auch schon ein paar wirklich gute Geschichten erzählt. Sonst gibt's hier ja keine Unterhaltung und für's Herumreisen fehlen mir die nötigen Goldmünzen und die Zeit."), null)
			call speech(info, true, tr("Außerdem ist sie doch wirklich nett. Dass musst du doch zugeben."), null)
			call speech(info, false, tr("Na ja ..."), null)
			call speech(info, true, tr("Komm schon. Meine Frau ist vor drei Jahren an irgend so einer Krankheit gestorben. Was weiß ich? Ist schon lange her, dass ich was mit einer hatte. Die Mathilda wär genau die Richtige."), null)
			call speech(info, true, tr("Zusammen könnten wir hier den Hof führen. Das wär doch was! (Lacht) Ich hab wohl zu viel gearbeitet. Na ja, nimm's nicht so ernst."), null)
			call info.talk().showStartPage()
		endmethod

		// (Auftragsziel 1 des Auftrags „Schutz dem Volke“ abgeschlossen oder Auftrag „Zu den Waffen, Bauern!“ aktiv)
		private static method infoCondition3 takes AInfo info returns boolean
			return QuestProtectThePeople.characterQuest(info.talk().character()).questItem(0).isCompleted() or QuestAmongTheWeaponsPeasants.characterQuest(info.talk().character()).isNew()
		endmethod

		// Ich habe mit dem Vogt gesprochen.
		private static method infoAction3 takes AInfo info returns nothing
			call speech(info, false, tr("Ich habe mit dem Vogt gesprochen."), null)
			call speech(info, true, tr("Und?"), null)
			if (QuestProtectThePeople.characterQuest(info.talk().character()).questItem(0).isCompleted()) then
				call speech(info, false, tr("Er überlegt sich das mit dem Kriegsdienst nochmal und er wird ein paar Leute herschicken."), null)
				call speech(info, true, tr("Donnerwetter! Wie hast du das angestellt? Obwohl, ich frag besser nicht. Das sind gute Neuigkeiten, mein Freund!"), null)
				call speech(info, true, tr("Dafür werde ich dich auch gut entlohnen."), null)
				// Auftrag „Schutz dem Volke“ abgeschlossen.
				call QuestProtectThePeople.characterQuest(info.talk().character()).complete()
			// (Auftrag „Zu den Waffen, Bauern!“ aktiv)
			else
				call speech(info, false, tr("Sieht schlecht aus, Freundchen. Du wirst gefälligst deinen Kriegsdienst leisten und deine Leute ebenso oder ich reiß dir deine Eingeweide heraus und verfüttere deine Leute an den Feind."), null)
				call speech(info, false, tr("Und wegen den Leuten, die dein Hab und Gut bewachen sollen, wirst du dich auch nicht mehr beschweren, klar?"), null)
				call speech(info, true, tr("Oh Mann, komm mal wieder runter. Schon gut, ich ... ich denke, das geht schon in Ordnung."), null)
				call speech(info, false, tr("Das will ich auch hoffen."), null)
				// Auftragsziel 1 des Auftrags „Zu den Waffen, Bauern!“ abgeschlossen
				call QuestAmongTheWeaponsPeasants.characterQuest(info.talk().character()).questItem(0).complete()
			endif
			call info.talk().showStartPage()
		endmethod

		// Ja.
		private static method infoAction0_0 takes AInfo info returns nothing
			call speech(info, false, tr("Ja."), null)
			call speech(info, true, tr("Gut, ich kann jeden Helfer gebrauchen. Falls du also Lust hast, dir ein paar Goldmünzen dazuzuverdienen, dann melde dich einfach bei mir."), null)
			call speech(info, true, tr("Gerade ist Erntezeit und da kann man nicht genug Leute haben. Ich will ja schließlich noch ernten, bevor unser Feind hier auftaucht."), null)
			call info.talk().showStartPage()
		endmethod

		// Nein.
		private static method infoAction0_1 takes AInfo info returns nothing
			call speech(info, false, tr("Nein."), null)
			call speech(info, true, tr("Schade. In diesen harten Zeiten findet man nur noch selten Leute, die Arbeit suchen."), null)
			call speech(info, true, tr("Die Meisten wollen doch sowieso nur weg von der Grenze. Krieg, Krieg, das ist das Einzige, was sie noch interessiert. Aber ich muss meinen Hof führen. Die Leute in der Burg brauchen ja auch was zu beißen."), null)
			call speech(info, true, tr("Aber auf uns Bauern wird sowieso nur rumgehackt, dabei lastet auf uns der ganze Rest."), null)
			call info.talk().showStartPage()
		endmethod

		// Ich kümmere mich drum.
		private static method infoAction1_0 takes AInfo info returns nothing
			call speech(info, false, tr("Ich kümmere mich drum."), null)
			call speech(info, true, tr("Wirklich? Das würdest du tun? Du musst mit dem Vogt in der Burg sprechen. Ferdinand ist sein Name. Ich war schon mal bei ihm, aber hat mich abgewiesen."), null)
			call speech(info, true, tr("Verdammter Arschkriecher des Herzogs. Der Sack sitzt in der Burg mit ihren dicken Mauern und bekommt ne Menge Goldmünzen für's Faulenzen."), null)
			call speech(info, true, tr("Lass dich nicht von ihm unterkriegen!"), null)
			call QuestProtectThePeople.characterQuest(info.talk().character()).enable()
			call info.talk().showStartPage()
		endmethod

		// Wirst schon nicht draufgehen.
		private static method infoAction1_1 takes AInfo info returns nothing
			call speech(info, false, tr("Wirst schon nicht draufgehen."), null)
			call speech(info, true, tr("Hmm, wenn nicht ich, dann ein anderer. Das ist auch nicht viel besser. Ich wünschte, der Krieg wäre schon vorbei und wir würden gemeinsam etwas Neues aufbauen. Eine Welt ohne Adel, in der jeder nach seiner wirklichen Leistung beurteilt werden würde."), null)
			call speech(info, true, tr("Ich wette, in einer solchen Welt wäre das Ansehen des Herzogs ganz unten."), null)
			call info.talk().showStartPage()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n01H_0148, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Was hältst du vom Herzog?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Du lässt Mathilda in deiner Scheune pennen?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Ich habe mit dem Vogt gesprochen.")) // 3
			call this.addExitButton() // 4

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Ja.")) // 5
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Nein.")) // 6

			// info 1
			call this.addInfo(false, false, 0, thistype.infoAction1_0, tr("Ich kümmere mich drum.")) // 7
			call this.addInfo(false, false, 0, thistype.infoAction1_1, tr("Wirst schon nicht draufgehen.")) // 8

			return this
		endmethod
	endstruct

endlibrary