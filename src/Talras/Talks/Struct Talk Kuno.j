library StructMapTalksTalkKuno requires Asl, StructMapMapFerryBoat, StructMapQuestsQuestKunosDaughter, StructMapQuestsQuestTheBeast, StructMapQuestsQuestWoodForTheHut

	struct TalkKuno extends ATalk

		implement Talk

		private method startPageAction takes nothing returns nothing
			call this.showUntil(6)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Hallo."), null)
			call speech(info, true, tr("￼Hallo. Was führt dich in diesen Wald?"), null)
			call speech(info, true, tr("Warte, lass mich raten! Das Holz? Oder ist es einfach nur der Anblick der wunderbaren Bäume hier? Schon gut, ich heiße Kuno und bin Holzfäller, wie man sieht."), null)
			call info.talk().showStartPage()
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Fühlst du dich nicht einsam?
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Fühlst du dich nicht einsam?"), null)
			call speech(info, true, tr("Nein. Ich habe ja meine Tochter. Sie ist inzwischen schon vierzehn und hilft mir beim Haushalt. Ohne sie wäre ich wohl aufgeschmissen und tatsächlich einsam."), null)
			call speech(info, true, tr("Ich mache mir nur Sorgen darum, was mit ihr geschehen soll, falls ich nicht mehr bin. Am Ende muss sie noch für die Bauern oder diesen verdammten Herzog und sein Gesindel arbeiten und schufftet sich wund."), null)
			call info.talk().showRange(7, 8)
		endmethod

		// (Charakter steht auf der Fähre)
		private static method infoCondition2 takes AInfo info returns boolean
			return FerryBoat.containsCharacter(info.talk().character())
		endmethod

		// Fährst du hier öfter?
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Fährst du hier öfter?"), null)
			call speech(info, true, tr("￼Ja, zweimal täglich. Trommon ist ein guter Freund von mir. Na ja, trotzdem ist das nicht umsonst, aber bei den Bauernhöfen verdien' ich wenigstens noch was und da sind die Leute nicht so unfreundlich wie in der Burg."), null)
			call speech(info, true, tr("Die Wachen da solltest du dir mal ansehen. Nur weil sie bewaffnet sind, glauben sie, sie könnten jeden niedermachen. Verdammte Schweine!"), null)
			call speech(info, true, tr("Aber ich will ja nichts gesagt haben, am Ende werde ich noch eingesperrt (lacht)."), null)
			call info.talk().showStartPage()
		endmethod

		// (Auftragsziel 1 des Auftrags „Holz für die Hütte“ ist aktiv)￼
		private static method infoCondition3 takes AInfo info returns boolean
			return QuestWoodForTheHut.characterQuest(info.talk().character()).questItem(0).isNew()
		endmethod

		// Du kennst doch Trommon …
		private static method infoAction3 takes AInfo info returns nothing
			call speech(info, false, tr("Du kennst doch Trommon …"), null)
			call speech(info, true, tr("Klar, ist ja mein Freund."), null)
			call speech(info, false, tr("Hast du dir mal seine Hütte angeschaut? Noch ein paar Unwetter und er kann sich eine neue bauen."), null)
			call speech(info, true, tr("Ja, hast ja Recht. Vielleicht sollte ich ihm mal bei der Reparatur helfen …"), null)
			call speech(info, false, tr("Ich mache dir einen Vorschlag: Du gibst  mir ein paar Bretter mit und ich geb' sie ihm dann. Ich schätze mal, das würde schon reichen."), null)
			call speech(info, true, tr("Gute Idee, hier hast du deine Bretter. Ich habe sowieso zu viele."), null)
			call QuestWoodForTheHut.characterQuest(info.talk().character()).questItem(0).complete()
			call info.talk().showStartPage()
		endmethod

		// (Auftragsziel 1 des Auftrags „Die Bestie“ ist aktiv und Charakter hat den Hinweis noch nicht erhalten)
		private static method infoCondition4 takes AInfo info returns boolean
			return QuestTheBeast.characterQuest(info.talk().character()).questItem(0).isNew() and not QuestTheBeast(QuestTheBeast.characterQuest(info.talk().character())).talkedToKuno()
		endmethod

		// Hast du in letzter Zeit irgendwas Auffälliges bemerkt?
		private static method infoAction4 takes AInfo info returns nothing
			call speech(info, false, tr("Hast du in letzter Zeit irgendwas Auffälliges bemerkt?"), null)
			call speech(info, true, tr("Wie meinst du das?"), null)
			call speech(info, false, tr("Hast du vielleicht irgendein großes Tier, eine Bestie oder etwas Ähnliches hier in der Nähe gesehen?"), null)
			call speech(info, true, tr("Jetzt da du es sagst. Vor einigen Tagen lag ich tief schlafend im Bett in meiner Hütte als ich durch ein lautes Geräusch aufgewacht bin. Irgendein Schnaufen oder so."), null)
			call speech(info, true, tr("Ich habe mich vorsichtig zum Fenster geschlichen und in die dunkle Nacht hinaus geblickt."), null)
			call speech(info, true, tr("Da war ein großer Schatten, sah wie ein riesiges, haariges Viech aus, irgendeine miese Kreatur."), null)
			call speech(info, true, tr("Da hab ich's mit der Angst zu tun bekommen und mich leise, aber schnell wieder hingelegt."), null)
			call speech(info, true, tr("Das Viech hat hier anscheinend irgendwas gesucht, ist dann aber nach einer Weile wieder abgehauen."), null)
			call speech(info, false, tr("Und wohin?"), null)
			call speech(info, true, tr("In Richtung Süden, glaube ich. Aber wenn ich du wäre, würde ich es nicht aufsuchen. Das Viech stank nach Tod und Verderben. Ich habe so etwas noch nie erlebt und bin auch nicht gerade scharf darauf, mir das nochmal anzutun."), null)
			call speech(info, true, tr("Ich hoffe nur, es kommt nicht wieder und tut meiner Tochter was."), null)
			call QuestTheBeast(QuestTheBeast.characterQuest(info.talk().character())).talkToKuno() // detects automatically if completed
			call info.talk().showStartPage()
		endmethod

		// (Auftragsziel 2 des Auftrags „Kunos Tochter“ ist aktiv)
		private static method infoCondition5 takes AInfo info returns boolean
			return QuestKunosDaughter.characterQuest(info.talk().character()).questItem(1).isNew()
		endmethod

		// Der Jäger Björn wird deiner Tochter etwas beibringen.
		private static method infoAction5 takes AInfo info returns nothing
			call speech(info, false, tr("Der Jäger Björn wird deiner Tochter etwas beibringen."), null)
			call speech(info, true, tr("Björn? Ich kenne ihn, zumindest vom Sehen. Tatsächlich? Hätte nicht gedacht, dass sich jemand aus der Burg bereit erklärt. Hört sich gut an. Ich werde es ihr gleich nachher sagen. Vielen Dank! Hier hast du ein paar leckere Pilze."), null)
			/// @todo Give mushrooms! -> see quest document
			call QuestKunosDaughter.characterQuest(info.talk().character()).complete()
			call info.talk().showStartPage()
		endmethod

		// Was will sie denn später mal machen?
		private static method infoAction1_0 takes AInfo info returns nothing
			call speech(info, false, tr("Was will sie denn später mal machen?"), null)
			call speech(info, true, tr("Sie redet immer davon, wegzugehen und sich irgendwo in der Wildnis selbst durchzuschlagen."), null)
			call speech(info, true, tr("Mein Gerede über den Herzog und die Ungerechtigkeit in diesem Königreich haben sie zu sehr beeinflusst. Ich muss ihr das ständig wieder ausreden, aber ich fürchte, bald wird sie ihren eigenen Kopf durchsetzen."), null)
			call speech(info, true, tr("Ich wünschte, jemand könnte ihr wenigstens etwas über das Jagen beibringen, denn ich selbst habe mein Leben lang nur Bäume gefällt. Ich weiß nicht mal, wie man einem Tier das Fell abzieht."), null)
			// Neuer Auftrag „Kunos Tochter“
			call QuestKunosDaughter.characterQuest(info.talk().character()).enable()
			call info.talk().showStartPage()
		endmethod

		// Sie packt das schon.
		private static method infoAction1_1 takes AInfo info returns nothing
			call speech(info, false, tr("Sie packt das schon."), null)
			call speech(info, true, tr("Das hoffe ich auch."), null)
			call info.talk().showStartPage()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n022_0009, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Fühlst du dich nicht einsam?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Fährst du hier öfter?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Du kennst doch Trommon ...")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tr("Hast du in letzter Zeit irgendwas Auffälliges bemerkt?")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tr("Der Jäger Björn wird deiner Tochter etwas beibringen.")) // 5
			call this.addExitButton() // 6

			// info 1
			call this.addInfo(false, false, 0, thistype.infoAction1_0, tr("Was will sie denn später mal machen?")) // 7
			call this.addInfo(false, false, 0, thistype.infoAction1_1, tr("Sie packt das schon.")) // 8

			return this
		endmethod
	endstruct

endlibrary