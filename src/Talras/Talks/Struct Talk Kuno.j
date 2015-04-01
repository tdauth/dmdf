library StructMapTalksTalkKuno requires Asl, StructMapQuestsQuestKunosDaughter, StructMapQuestsQuestTheBeast, StructMapQuestsQuestWoodForTheHut

	struct TalkKuno extends ATalk
		private AInfo m_lonely_0
		private AInfo m_lonely_1
		private AInfo m_busy

		implement Talk

		private static method isInForest takes nothing returns boolean
			return RectContainsUnit(gg_rct_kuno_forest, Npcs.kuno())
		endmethod
		
		// (Falls Kuno nicht im Wald ist)
		private static method infoConditionBusy takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return not thistype.isInForest()
		endmethod
		
		private static method infoActionBusy takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, true, tr("Nicht jetzt, ich habe zu tun!"), null)
			call this.close(character)
		endmethod
		
		private method startPageAction takes ACharacter character returns nothing
			if (not this.showInfo(this.m_busy.index(), character)) then
				call this.showUntil(5, character)
			endif
		endmethod

		// Hallo.
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("￼Hallo. Was führt dich in diesen Wald?"), null)
			call speech(info, character, true, tr("Warte, lass mich raten! Das Holz? Oder ist es einfach nur der Anblick der wunderbaren Bäume hier? Schon gut, ich heiße Kuno und bin Holzfäller, wie man sieht."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionLonely takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Fühlst du dich nicht einsam?
		private static method infoActionLonely takes AInfo info, ACharacter character returns nothing
			local thistype talk = thistype(info.talk())
			call speech(info, character, false, tr("Fühlst du dich nicht einsam?"), null)
			call speech(info, character, true, tr("Nein. Ich habe ja meine Tochter. Sie ist inzwischen schon vierzehn und hilft mir beim Haushalt. Ohne sie wäre ich wohl aufgeschmissen und tatsächlich einsam."), null)
			call speech(info, character, true, tr("Ich mache mir nur Sorgen darum, was mit ihr geschehen soll, falls ich nicht mehr bin. Am Ende muss sie noch für die Bauern oder diesen verdammten Herzog und sein Gesindel arbeiten und schufftet sich wund."), null)
			call talk.m_lonely_0.show(character)
			call talk.m_lonely_1.show(character)
			call talk.show(character.player())
		endmethod

		// (Auftragsziel 1 des Auftrags „Holz für die Hütte“ ist aktiv)￼
		private static method infoConditionKnowsTrommon takes AInfo info, ACharacter character returns boolean
			return QuestWoodForTheHut.characterQuest(character).questItem(0).isNew()
		endmethod

		// Du kennst doch Trommon …
		private static method infoActionKnowsTrommon takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Du kennst doch Trommon …"), null)
			call speech(info, character, true, tr("Sicher, wir beide sind gute Freunde."), null)
			call speech(info, character, false, tr("Hast du dir mal seine Hütte angeschaut? Noch ein paar Unwetter und er kann sich eine neue bauen."), null)
			call speech(info, character, true, tr("Ja, du hast ja Recht. Vielleicht sollte ich ihm mal bei der Reparatur helfen …"), null)
			call speech(info, character, false, tr("Ich mache dir einen Vorschlag: Du gibst  mir ein paar Bretter mit und ich gebe sie dann ihm. Ich schätze mal, das würde schon reichen."), null)
			call speech(info, character, true, tr("Gute Idee, hier hast du deine Bretter. Ich habe sowieso ein paar übrig."), null)
			// Charakter erhält Bretter
			call character.giveQuestItem('I03P')
			call QuestWoodForTheHut.characterQuest(character).questItem(0).complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Die Bestie“ ist aktiv und Charakter hat den Hinweis noch nicht erhalten)
		private static method infoConditionBeast takes AInfo info, ACharacter character returns boolean
			return QuestTheBeast.characterQuest(character).questItem(0).isNew() and not QuestTheBeast.characterQuest(character).talkedToKuno()
		endmethod

		// Hast du in letzter Zeit irgendwas Auffälliges bemerkt?
		private static method infoActionBeast takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hast du in letzter Zeit irgendwas Auffälliges bemerkt?"), null)
			call speech(info, character, true, tr("Wie meinst du das?"), null)
			call speech(info, character, false, tr("Hast du vielleicht irgendein großes Tier, eine Bestie oder etwas Ähnliches hier in der Nähe gesehen?"), null)
			call speech(info, character, true, tr("Jetzt da du es sagst. Vor einigen Tagen lag ich tief schlafend im Bett in meiner Hütte als ich durch ein lautes Geräusch aufgewacht bin. Irgendein Schnaufen oder so."), null)
			call speech(info, character, true, tr("Ich habe mich vorsichtig zum Fenster geschlichen und in die dunkle Nacht hinaus geblickt."), null)
			call speech(info, character, true, tr("Da war ein großer Schatten, sah wie ein riesiges, haariges Viech aus, irgendeine miese Kreatur."), null)
			call speech(info, character, true, tr("Da hab ich's mit der Angst zu tun bekommen und mich leise, aber schnell wieder hingelegt."), null)
			call speech(info, character, true, tr("Das Viech hat hier anscheinend irgendwas gesucht, ist dann aber nach einer Weile wieder abgehauen."), null)
			call speech(info, character, false, tr("Und wohin?"), null)
			call speech(info, character, true, tr("In Richtung Süden, glaube ich. Aber wenn ich du wäre, würde ich es nicht aufsuchen. Das Viech stank nach Tod und Verderben. Ich habe so etwas noch nie erlebt und bin auch nicht gerade scharf darauf, mir das nochmal anzutun."), null)
			call speech(info, character, true, tr("Ich hoffe nur, es kommt nicht wieder und tut meiner Tochter was."), null)
			call QuestTheBeast(QuestTheBeast.characterQuest(character)).talkToKuno() // detects automatically if completed
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Kunos Tochter“ ist abgeschlossen und Auftragsziel 2 des Auftrags „Kunos Tochter“ ist aktiv)
		private static method infoConditionKunosDaughter takes AInfo info, ACharacter character returns boolean
			return QuestKunosDaughter.characterQuest(character).questItem(0).isCompleted() and QuestKunosDaughter.characterQuest(character).questItem(1).isNew()
		endmethod

		// Der Jäger Björn wird deiner Tochter etwas beibringen.
		private static method infoActionKunosDaughter takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Der Jäger Björn wird deiner Tochter etwas beibringen."), null)
			call speech(info, character, true, tr("Björn? Ich kenne ihn, zumindest vom Sehen. Tatsächlich? Hätte nicht gedacht, dass sich jemand aus der Burg bereit erklärt."), null)
			call speech(info, character, false, tr("Er verlangt nichts dafür. Du musst sie nur vorbeischicken."), null)
			call speech(info, character, true, tr("Wirklich? Na das nenne ich Glück! In letzter Zeit habe ich sowieso nicht gerade große Geschäfte gemacht. Dieser Björn scheint schwer in Ordnung zu sein."), null)
			call speech(info, character, true, tr("Ich werde meiner Tochter gleich davon erzählen. Hab vielen Dank! Hier hast du ein paar leckere Pilze aus dem Wald."), null)
			call QuestKunosDaughter.characterQuest(character).complete()
			call character.giveItem('I01L')
			call character.giveItem('I01L')
			call character.giveItem('I01L')
			call info.talk().showStartPage(character)
		endmethod

		// Was will sie denn später mal machen?
		private static method infoActionLonely_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was will sie denn später mal machen?"), null)
			call speech(info, character, true, tr("Sie redet immer davon, wegzugehen und sich irgendwo in der Wildnis selbst durchzuschlagen."), null)
			call speech(info, character, true, tr("Mein Gerede über den Herzog und die Ungerechtigkeit in diesem Königreich haben sie zu sehr beeinflusst. Ich muss ihr das ständig wieder ausreden, aber ich fürchte, bald wird sie ihren eigenen Kopf durchsetzen."), null)
			call speech(info, character, true, tr("Ich wünschte, jemand könnte ihr wenigstens etwas über das Jagen beibringen, denn ich selbst habe mein Leben lang nur Bäume gefällt. Ich weiß nicht mal, wie man einem Tier das Fell abzieht."), null)
			// Neuer Auftrag „Kunos Tochter“
			call QuestKunosDaughter.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Sie packt das schon.
		private static method infoActionLonely_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Sie packt das schon."), null)
			call speech(info, character, true, tr("Das hoffe ich auch."), null)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n022_0009, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoActionHi, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoConditionLonely, thistype.infoActionLonely, tr("Fühlst du dich nicht einsam?")) // 1
			call this.addInfo(false, false, thistype.infoConditionKnowsTrommon, thistype.infoActionKnowsTrommon, tr("Du kennst doch Trommon ...")) // 2
			call this.addInfo(false, false, thistype.infoConditionBeast, thistype.infoActionBeast, tr("Hast du in letzter Zeit irgendwas Auffälliges bemerkt?")) // 3
			call this.addInfo(false, false, thistype.infoConditionKunosDaughter, thistype.infoActionKunosDaughter, tr("Der Jäger Björn wird deiner Tochter etwas beibringen.")) // 4
			call this.addExitButton() // 5

			// info 1
			set this.m_lonely_0 = this.addInfo(false, false, 0, thistype.infoActionLonely_0, tr("Was will sie denn später mal machen?")) // 6
			set this.m_lonely_1 = this.addInfo(false, false, 0, thistype.infoActionLonely_1, tr("Sie packt das schon.")) // 7
			
			set this.m_busy = this.addInfo(true, true, thistype.infoConditionBusy, thistype.infoActionBusy, null)

			return this
		endmethod
	endstruct

endlibrary