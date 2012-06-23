library StructMapTalksTalkGuntrich requires Asl, StructMapMapNpcs, StructMapQuestsQuestWitchingHour

	struct TalkGuntrich extends ATalk

		implement Talk

		private method startPageAction takes nothing returns nothing
			call this.showUntil(5)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Hallo."), null)
			call speech(info, true, tr("Hallo Fremder. Kannst du mir vielleicht weiterhelfen?"), null)
			call info.talk().showRange(6, 7)
		endmethod

		// (Nach der Begrüßung)
		private static method infoCondition1 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Verkaufst du auch irgendwas?
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Verkaufst du auch irgendwas?"), null)
			call speech(info, true, tr("Natürlich, ich bin ja nicht umsonst Müller. Außer Mehl noch ein paar andere nützliche Dinge, um mir etwas dazu zu verdienen."), null)
			call info.talk().showStartPage()
		endmethod

		// (Auftrag „Geisterstunde“ ist aktiv)
		private static method infoCondition2 takes AInfo info returns boolean
			return QuestWitchingHour.characterQuest(info.talk().character()).isNew()
		endmethod

		// Was genau machen denn die Geister?
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Was genau machen denn die Geister?"), null)
			call speech(info, true, tr("Ich höre sie trommeln und Schlachtengetümmel. Ich sag's dir, der Berg ist verflucht!"), null)
			call speech(info, true, tr("Es klingt als ob zwei Heere aufeinander zustürmten und ewig gegeneinander kämpften. Einmal hab ich mir das angetan, ein zweites Mal kriegt mich keiner auf diesen verfluchten Berg!"), null)
			call info.talk().showStartPage()
		endmethod

		// (Auftragsziel 2 des Auftrags „Geisterstunde“ ist aktiv)
		private static method infoCondition3 takes AInfo info returns boolean
			return QuestWitchingHour.characterQuest(info.talk()).questItem(0).isCompleted() and QuestWitchingHour.characterQuest(info.talk()).questItem(1).isNew()
		endmethod

		// Ich war bei Osman …
		private static method infoAction3 takes AInfo info returns nothing
			call speech(info, false, tr("Ich war bei Osman. Er denkt nicht daran dir zu helfen."), null)
			call speech(info, true, tr("War doch klar! Dieser miese Hund hat nur böses im Sinn. Seine Habgier wird ihm nochmal zum Verhängnis werden."), null)
			call speech(info, true, tr("Trotzdem danke für die Mühe. Hier hast du ein paar Goldmünzen."), null)
			// Auftragsziel 2 des Auftrags „Geisterstunde“ abgeschlossen
			call QuestWitchingHour.characterQuest(info.talk().character()).questItem(1).setState(AAbstractQuest.stateCompleted)
			call speech(info, false, tr("Ich könnte mich ja mal bei der Mühle umschauen."), null)
			call speech(info, true, tr("Wenn du das machen würdest, wäre ich dir sehr verbunden. Ich werde dich aber sicher nicht als einen Feigling bezeichnen, wenn du es dir nicht zutraust."), null)
			// Auftragsziel 3 des Auftrags „Geisterstunde“ aktiv
			call QuestWitchingHour.characterQuest(info.talk().character()).questItem(2).setState(AAbstractQuest.stateNew)
			call QuestWitchingHour.characterQuest(info.talk().character()).displayUpdate()
			call info.talk().showStartPage()
		endmethod

		// (Auftragsziel 4 des Auftrags „Geisterstunde“ ist aktiv und Charakter war auf dem Schlachtfeld in der Trommelhöhle)
		private static method infoCondition4 takes AInfo info returns boolean
			return QuestWitchingHour.characterQuest(info.talk()).questItem(2).isCompleted() and QuestWitchingHour.characterQuest(info.talk()).questItem(3).isNew()
		endmethod

		// Ich war in der Trommelhöhle im Berg.
		private static method infoAction4 takes AInfo info returns nothing
			call speech(info, false, tr("Ich war in der Trommelhöhle im Berg."), null)
			call speech(info, true, tr("In der Trommelhöhle? Ich habe Geschichten darüber gehört. Angeblich nur ein böses Kindermärchen. Es gibt sie also wirklich?"), null)
			call speech(info, false, tr("Ja und die Geräusche kommen aus ihr, aber das ist eine lange Geschichte. Jedenfalls brauchst du dich nicht zu fürchten. Es sind keine bösen Geister, nur ein paar Verrückte, die sich gegenseitig die Köpfe einhauen."), null)
			call speech(info, true, tr("Hm ... gut, ich vertraue dir. Vielen Dank. Jetzt kann ich wieder beruhigt zu meiner Mühle gehen, auch wenn mich diese Geräusche stören. Hier hast du eine kleine Stärkung und ein paar Goldmünzen."), null)
			// Auftrag „Geisterstunde“ abgeschlossen
			call QuestWitchingHour.characterQuest(info.talk()).complete()
			call info.talk().showStartPage()
		endmethod

		// Worum geht’s?
		private static method infoAction0_0 takes AInfo info returns nothing
			call speech(info, false, tr("Worum geht’s?"), null)
			call speech(info, true, tr("Erstmal hallo. Ich bin Guntrich, der Müller hier. Eigentlich wäre ich ja jetzt auch bei meiner Mühle."), null)
			call speech(info, true, tr("Leider ist der Berg anscheinend von bösen Geistern umgeben und die spuken dort Tag und Nacht. Darum bin ich jetzt hier, auf der Suche nach Hilfe."), null)
			call speech(info, true, tr("Ich war schon bei diesem verdammten Burgkleriker und der hat mir was von beten erzählt. Mit Beten bekämpft man aber doch keine Geister."), null)
			call speech(info, true, tr("Vielleicht kannst du ja mal mit ihm reden. Wenn ich nicht zu meiner Mühle kann, kann ich auch kein Mehl herstellen und das ist mein Ruin!"), null)
			// Neuer Auftrag „Geisterstunde“
			call QuestWitchingHour.characterQuest(info.talk()).enable()
			call info.talk().showStartPage()
		endmethod

		// Nein.
		private static method infoAction0_1 takes AInfo info returns nothing
			call speech(info, false, tr("Nein."), null)
			call speech(info, true, tr("Verdammt! Du bist auch nicht anders als die Anderen."), null)
			call info.talk().showStartPage()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.guntrich(), thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Verkaufst du auch irgendwas?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Was genau machen denn die Geister?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Ich war bei Osman …")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tr("Ich war in der Trommelhöhle im Berg.")) // 4
			call this.addExitButton() // 5

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Worum geht’s?")) // 6
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Nein.")) // 7

			return this
		endmethod
	endstruct

endlibrary