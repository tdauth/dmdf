library StructMapTalksTalkKuno requires Asl, StructMapQuestsQuestKunosDaughter, StructMapQuestsQuestTheBeast, StructMapQuestsQuestWoodForTheHut, StructMapQuestsQuestReinforcementForTalras, StructMapQuestsQuestWar

	struct TalkKuno extends Talk
		private AInfo m_hi
		private AInfo m_lonely
		private AInfo m_knowsTrommon
		private AInfo m_beast
		private AInfo m_kunosDaughter
		private AInfo m_markwardNeedsLumber
		private AInfo m_exit

		private AInfo m_lonely_0
		private AInfo m_lonely_1
		private AInfo m_busy

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
			call speech(info, character, true, tre("Nicht jetzt, ich habe zu tun!", "Not now, I am busy!"), gg_snd_Kuno1)
			call this.close(character)
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			if (not this.showInfo(this.m_busy.index(), character)) then
				call this.showUntil(this.m_exit.index(), character)
			endif
		endmethod

		// Hallo.
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("￼Hallo. Was führt dich in diesen Wald?", "Hello. What brings you in this forest?"), gg_snd_Kuno2)
			call speech(info, character, true, tre("Warte, lass mich raten! Das Holz? Oder ist es einfach nur der Anblick der wunderbaren Bäume hier? Schon gut, ich heiße Kuno und bin Holzfäller, wie man sieht.", "Wait, let me guess! The wood? Or is it just the sight of the wonderful trees here? All right, I'm Kuno and I am a lumberjack, as you can see."), gg_snd_Kuno3)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionLonely takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		// Fühlst du dich nicht einsam?
		private static method infoActionLonely takes AInfo info, ACharacter character returns nothing
			local thistype talk = thistype(info.talk())
			call speech(info, character, false, tre("Fühlst du dich nicht einsam?", "Don't you feel lonely?"), null)
			call speech(info, character, true, tre("Nein. Ich habe ja meine Tochter. Sie ist inzwischen schon vierzehn und hilft mir beim Haushalt. Ohne sie wäre ich wohl aufgeschmissen und tatsächlich einsam.", "No. I have my daughter. She is by now fourteen and helps me with the housekeeping. Without her I would probably be stuck and really lonely."), gg_snd_Kuno4)
			call speech(info, character, true, tre("Ich mache mir nur Sorgen darum, was mit ihr geschehen soll, falls ich nicht mehr bin. Am Ende muss sie noch für die Bauern oder diesen verdammten Herzog und sein Gesindel arbeiten und schufftet sich wund.", "I'm just worried about what will happen to her, if I am no longer. At the end she still needs to work for the farmers or this damned duke and his rabble."), gg_snd_Kuno5)
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
			call speech(info, character, false, tre("Du kennst doch Trommon …", "You know Trommon …"), null)
			call speech(info, character, true, tre("Sicher, wir beide sind gute Freunde.", "Sure, we're both good friends."), gg_snd_Kuno10)
			call speech(info, character, false, tre("Hast du dir mal seine Hütte angeschaut? Noch ein paar Unwetter und er kann sich eine neue bauen.", "Have you viewed his hut? A few more storms and he can build a new one."), null)
			call speech(info, character, true, tre("Ja, du hast ja Recht. Vielleicht sollte ich ihm mal bei der Reparatur helfen …", "Yes, you're right. Maybe I should help him once in the repair …"), gg_snd_Kuno11)
			call speech(info, character, false, tre("Ich mache dir einen Vorschlag: Du gibst  mir ein paar Bretter mit und ich gebe sie dann ihm. Ich schätze mal, das würde schon reichen.", "I'll make a suggestion. You give me a few boards with me and I give them to him then. I guess that would be enough."), null)
			call speech(info, character, true, tre("Gute Idee, hier hast du deine Bretter. Ich habe sowieso ein paar übrig.", "Good idea, here you have your boards. I have a few left anyway."), gg_snd_Kuno12)
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
			call speech(info, character, false, tre("Hast du in letzter Zeit irgendwas Auffälliges bemerkt?", "Have you noticed something conspicuous lately?"), null)
			call speech(info, character, true, tre("Wie meinst du das?", "How do you mean?"), gg_snd_Kuno13)
			call speech(info, character, false, tre("Hast du vielleicht irgendein großes Tier, eine Bestie oder etwas Ähnliches hier in der Nähe gesehen?", "Have you maybe seen some great animal, beast or something similar around here?"), null)
			call speech(info, character, true, tre("Jetzt da du es sagst. Vor einigen Tagen lag ich tief schlafend im Bett in meiner Hütte als ich durch ein lautes Geräusch aufgewacht bin. Irgendein Schnaufen oder so.", "Now that you mention it. A few days ago I was asleep in bed in my hut when I woke up by a loude noise. Some snort or something like that."), gg_snd_Kuno14)
			call speech(info, character, true, tre("Ich habe mich vorsichtig zum Fenster geschlichen und in die dunkle Nacht hinaus geblickt.", "I snuck carefully to the window and looked into the dark night beyond."), gg_snd_Kuno15)
			call speech(info, character, true, tre("Da war ein großer Schatten, sah wie ein riesiges, haariges Viech aus, irgendeine miese Kreatur.", "There was a large shadow, looked like a huge, hairy creature, some lousy creature."), gg_snd_Kuno16)
			call speech(info, character, true, tre("Da hab ich's mit der Angst zu tun bekommen und mich leise, aber schnell wieder hingelegt.", "Then I got the fear and lied down quietly and quickly again."), gg_snd_Kuno17)
			call speech(info, character, true, tre("Das Viech hat hier anscheinend irgendwas gesucht, ist dann aber nach einer Weile wieder abgehauen.", "The creature apparently wanted something here, but then took off again after a while."), gg_snd_Kuno18)
			call speech(info, character, false, tre("Und wohin?", "And where?"), null)
			call speech(info, character, true, tre("In Richtung Süden, glaube ich. Aber wenn ich du wäre, würde ich es nicht aufsuchen. Das Viech stank nach Tod und Verderben. Ich habe so etwas noch nie erlebt und bin auch nicht gerade scharf darauf, mir das nochmal anzutun.", "In the south, I think. But if I were you, I would not seek it. The creature stank of death and destruction. I've never experienced anything like this and I'm not exactly keen to do this again to myself."), gg_snd_Kuno19)
			call speech(info, character, true, tre("Ich hoffe nur, es kommt nicht wieder und tut meiner Tochter was.", "I just hope it does not come back and does something to my daughter."), gg_snd_Kuno20)
			call QuestTheBeast(QuestTheBeast.characterQuest(character)).talkToKuno() // detects automatically if completed
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Kunos Tochter“ ist abgeschlossen und Auftragsziel 2 des Auftrags „Kunos Tochter“ ist aktiv)
		private static method infoConditionKunosDaughter takes AInfo info, ACharacter character returns boolean
			return QuestKunosDaughter.characterQuest(character).questItem(0).isCompleted() and QuestKunosDaughter.characterQuest(character).questItem(1).isNew()
		endmethod

		// Der Jäger Björn wird deiner Tochter etwas beibringen.
		private static method infoActionKunosDaughter takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Der Jäger Björn wird deiner Tochter etwas beibringen.", "The hunter Björn will teack your daughter something."), null)
			call speech(info, character, true, tre("Björn? Ich kenne ihn, zumindest vom Sehen. Tatsächlich? Hätte nicht gedacht, dass sich jemand aus der Burg bereit erklärt.", "Björn? I know him, at least by sight. Indeed? Had not thought that someone from the castle agreed."), gg_snd_Kuno21)
			call speech(info, character, false, tre("Er verlangt nichts dafür. Du musst sie nur vorbeischicken.", "He demands nothing in return. You have only to send here by."), null)
			call speech(info, character, true, tre("Wirklich? Na das nenne ich Glück! In letzter Zeit habe ich sowieso nicht gerade große Geschäfte gemacht. Dieser Björn scheint schwer in Ordnung zu sein.", "Really? Well that's what I call luck! Lately I have not made big business anyway. This Björn really seems to be all right."), gg_snd_Kuno22)
			call speech(info, character, true, tre("Ich werde meiner Tochter gleich davon erzählen. Hab vielen Dank! Hier hast du ein paar leckere Pilze aus dem Wald.", "I'll tell my daughter just thereof. My thanks! Here you have some tasty mushrooms from the forest."), gg_snd_Kuno23)
			call QuestKunosDaughter.characterQuest(character).complete()
			call character.giveItem('I01L')
			call character.giveItem('I01L')
			call character.giveItem('I01L')
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Die Befestigung von Talras“ ist aktiv und Auftragsziel 2 ist noch nicht aktiviert)
		private static method infoConditionMarkwardNeedsLumber takes AInfo info, ACharacter character returns boolean
			return QuestReinforcementForTalras.characterQuest(character).questItem(0).isNew() and not QuestReinforcementForTalras.characterQuest(character).questItem(1).isNew()
		endmethod

		// Markward benötigt Holz für die Burg.
		private static method infoActionMarkwardNeedsLumber takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Markward benötigt Holz für die Burg.", "Markward needs wood for the castle."), null)
			// (Auftragsziel 6 des Auftrags „Krieg“ ist aktiv oder abgeschlossen)
			if (QuestWar.quest().isNew() or QuestWar.quest().isCompleted()) then
				call speech(info, character, true, tre("Noch mehr Holz und dies mal für die Burg?", "Even more wood and this time for the castle?"), gg_snd_Kuno24)
			endif
			call speech(info, character, true, tre("Die scheinen sich dort oben ja gewaltig in die Hosen zu machen. Das passiert eben wenn der eine Herrscher dem anderen Herrscher eins auf die Mütze geben will.", "They really seem pissing in there pans up there. That's what happens when the one ruler wants to give the other ruler one on the cap."), gg_snd_Kuno25)
			call speech(info, character, true, tre("Ich habe es meiner Tochter immer gesagt, dieser Herzog ist …", "I have always said it to my daughter, this duke is ..."), gg_snd_Kuno26)
			call speech(info, character, false, tre("…", "..."), null)
			call speech(info, character, true, tre("Aber gut bevor sie meine Hütte dem Erdboden gleichmachen komme ich seinem Wunsch lieber nach. Allerdings hat das seinen Preis, wenn sie mir schon nichts zahlen wollen.", "But well before they make my hut to the ground, I better do what he wishes. However, there's a price if they don't want to pay me anything already."), gg_snd_Kuno27)
			call speech(info, character, true, tre("Allerdings werde ich mir nicht die Arbeit machen und es zu Heimrich schleppen. Ich krieche doch nicht vor diesem eingebildeten Schnösel. Du kannst das Holz zu Manfred bringen und er schickt es dann den Berg hinauf.", "However, I'm not going to make work and haul it to Heimrich. I don't crawl in front of this conceited snob. You can bring the wood to Manfred and he then sends it up the hill."), gg_snd_Kuno28)
			call speech(info, character, true, tre("Das ist ein gerechter Handel und du hast nicht ganze Arbeit.", "This is a fair trade and you do not have all the work."), gg_snd_Kuno29)
			// Auftragsziel 2 des Auftrags „Die Befestigung von Talras“ wird aktiviert.
			call QuestReinforcementForTalras.characterQuest(character).questItem(1).setState(AAbstractQuest.stateNew)
			call QuestReinforcementForTalras.characterQuest(character).displayUpdate()
			// Charakter erhält das Holz.
			call character.giveItem('I051')
			call info.talk().showStartPage(character)
		endmethod

		// Was will sie denn später mal machen?
		private static method infoActionLonely_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was will sie denn später mal machen?", "What does she want to do later?"), null)
			call speech(info, character, true, tre("Sie redet immer davon, wegzugehen und sich irgendwo in der Wildnis selbst durchzuschlagen.", "She is always talking about going away and to chop through herself somewhere in the wilderness."), gg_snd_Kuno6)
			call speech(info, character, true, tre("Mein Gerede über den Herzog und die Ungerechtigkeit in diesem Königreich haben sie zu sehr beeinflusst. Ich muss ihr das ständig wieder ausreden, aber ich fürchte, bald wird sie ihren eigenen Kopf durchsetzen.", "My talk of the duke and the injustice in this kingdom have influenced here too much. I have to talk to her constantly that she won't do it but I fear that soon she will enforce her own head."), gg_snd_Kuno7)
			call speech(info, character, true, tre("Ich wünschte, jemand könnte ihr wenigstens etwas über das Jagen beibringen, denn ich selbst habe mein Leben lang nur Bäume gefällt. Ich weiß nicht mal, wie man einem Tier das Fell abzieht.", "I wish someone could teach something about hunting to her at least, because I myself have only cut trees my whole life. I do not even know how to skin an animal."), gg_snd_Kuno8)
			// Neuer Auftrag „Kunos Tochter“
			call QuestKunosDaughter.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Sie packt das schon.
		private static method infoActionLonely_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Sie packt das schon.", "She will do fine."), null)
			call speech(info, character, true, tre("Das hoffe ich auch.", "I hope that too."), gg_snd_Kuno9)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n022_0009, thistype.startPageAction)

			// start page
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tre("Hallo.", "Hello.")) // 0
			set this.m_lonely = this.addInfo(false, false, thistype.infoConditionLonely, thistype.infoActionLonely, tre("Fühlst du dich nicht einsam?", "Don't you feel lonely?")) // 1
			set this.m_knowsTrommon = this.addInfo(false, false, thistype.infoConditionKnowsTrommon, thistype.infoActionKnowsTrommon, tre("Du kennst doch Trommon …", "You know Trommon …")) // 2
			set this.m_beast = this.addInfo(false, false, thistype.infoConditionBeast, thistype.infoActionBeast, tre("Hast du in letzter Zeit irgendwas Auffälliges bemerkt?", "Have you noticed something conspicuous lately?")) // 3
			set this.m_kunosDaughter = this.addInfo(false, false, thistype.infoConditionKunosDaughter, thistype.infoActionKunosDaughter, tre("Der Jäger Björn wird deiner Tochter etwas beibringen.", "The hunter Björn will teack your daughter something.")) // 4
			set this.m_markwardNeedsLumber = this.addInfo(false, false, thistype.infoConditionMarkwardNeedsLumber, thistype.infoActionMarkwardNeedsLumber, tre("Markward benötigt Holz für die Burg.", "Markward needs wood for the castle.")) // 4
			set this.m_exit = this.addExitButton() // 5

			// info 1
			set this.m_lonely_0 = this.addInfo(false, false, 0, thistype.infoActionLonely_0, tre("Was will sie denn später mal machen?", "What does she want to do later?")) // 6
			set this.m_lonely_1 = this.addInfo(false, false, 0, thistype.infoActionLonely_1, tre("Sie packt das schon.", "She will do fine.")) // 7

			set this.m_busy = this.addInfo(true, true, thistype.infoConditionBusy, thistype.infoActionBusy, null)

			return this
		endmethod

		implement Talk
	endstruct

endlibrary