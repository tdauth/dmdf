library StructMapTalksTalkGuntrich requires Asl, StructMapMapNpcs, StructMapQuestsQuestWitchingHour

	struct TalkGuntrich extends Talk

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(5, character)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Hallo Fremder. Kannst du mir vielleicht weiterhelfen?", "Hello stranger. Can you help me out, maybe?"), gg_snd_Guntrich1)
			call info.talk().showRange(6, 7, character)
		endmethod

		// (Nach der Begrüßung)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Verkaufst du auch irgendwas?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Verkaufst du auch irgendwas?", "Are you selling something too?"), null)
			call speech(info, character, true, tre("Natürlich, ich bin ja nicht umsonst Müller. Außer Mehl noch ein paar andere nützliche Dinge, um mir etwas dazu zu verdienen.", "Of course, I'm not a miller for nothing. Besides flour a few other useful things to earn something additionally."), gg_snd_Guntrich7)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Geisterstunde“ ist aktiv)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			return QuestWitchingHour.characterQuest(character).isNew()
		endmethod

		// Was genau machen denn die Geister?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was genau machen denn die Geister?", "What exactly do the spirits?"), null)
			call speech(info, character, true, tre("Ich höre sie trommeln und Schlachtengetümmel. Ich sag's dir, der Berg ist verflucht!", "I hear them drumming and fray. I'll tell you, the mountain is cursed!"), gg_snd_Guntrich8)
			call speech(info, character, true, tre("Es klingt als ob zwei Heere aufeinander zustürmten und ewig gegeneinander kämpften. Einmal hab ich mir das angetan, ein zweites Mal kriegt mich keiner auf diesen verfluchten Berg!", "It sounds as if two armies storm each other and fought each other forever. Once I did this to me, a second time nobody will get me on that cursed moutain."), gg_snd_Guntrich9)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 2 des Auftrags „Geisterstunde“ ist aktiv)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return QuestWitchingHour.characterQuest(character).questItem(0).isCompleted() and QuestWitchingHour.characterQuest(character).questItem(1).isNew()
		endmethod

		// Ich war bei Osman …
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich war bei Osman. Er denkt nicht daran dir zu helfen.", "I was with Osman. He has no intention of helping you."), null)
			call speech(info, character, true, tre("War doch klar! Dieser miese Hund hat nur Böses im Sinn. Seine Habgier wird ihm nochmal zum Verhängnis werden.", "I knew it! This lousy dog has only evil in his mind. His greed will be his undoing once."), gg_snd_Guntrich10)
			call speech(info, character, true, tre("Trotzdem danke für die Mühe. Hier hast du ein paar Goldmünzen.", "Nevertheless, thanks for the effort. Here you have a few gold coins."), gg_snd_Guntrich11)
			// Auftragsziel 2 des Auftrags „Geisterstunde“ abgeschlossen
			call QuestWitchingHour.characterQuest(character).questItem(1).setState(AAbstractQuest.stateCompleted)
			call speech(info, character, false, tre("Ich könnte mich ja mal bei der Mühle umschauen.", "I could look around at the mill sometime."), null)
			call speech(info, character, true, tre("Wenn du das machen würdest, wäre ich dir sehr verbunden. Ich werde dich aber sicher nicht als einen Feigling bezeichnen, wenn du es dir nicht zutraust.", "If you were to do that, I would be much obliged. But I will certainly call you a coward if you do not trust yourself to do that."), gg_snd_Guntrich12)
			// Auftragsziel 3 des Auftrags „Geisterstunde“ aktiv
			call QuestWitchingHour.characterQuest(character).questItem(2).setState(AAbstractQuest.stateNew)
			call QuestWitchingHour.characterQuest(character).displayUpdate()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 4 des Auftrags „Geisterstunde“ ist aktiv und Charakter war auf dem Schlachtfeld in der Trommelhöhle)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return QuestWitchingHour.characterQuest(character).questItem(2).isCompleted() and QuestWitchingHour.characterQuest(character).questItem(3).isNew()
		endmethod

		// Ich war in der Trommelhöhle im Berg.
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich war in der Trommelhöhle im Berg.", "I was in the Drum Cave in the mountain."), null)
			call speech(info, character, true, tre("In der Trommelhöhle? Ich habe Geschichten darüber gehört. Angeblich nur ein böses Kindermärchen. Es gibt sie also wirklich?", "The Drum Cave? I've heard stories about it. Supposedly only a bad children's story. So it is real?"), gg_snd_Guntrich13)
			call speech(info, character, false, tre("Ja und die Geräusche kommen aus ihr, aber das ist eine lange Geschichte. Jedenfalls brauchst du dich nicht zu fürchten. Es sind keine bösen Geister, nur ein paar Verrückte, die sich gegenseitig die Köpfe einhauen.", "Yes, and the sounds coming from it, but that's a long story. Anyway, you need not to fear yourself. There are no evil spirits, only a few madmen who mutually hew their heads."), null)
			call speech(info, character, true, tre("Hm ... gut, ich vertraue dir. Vielen Dank. Jetzt kann ich wieder beruhigt zu meiner Mühle gehen, auch wenn mich diese Geräusche stören. Hier hast du eine kleine Stärkung und ein paar Goldmünzen.", "Hm ... well, I trust you. Thank you very much. Now I can go calmly to my mill again, although these sounds do bother me. Here you have a snack and a few gold coins."), gg_snd_Guntrich14)
			// Auftrag „Geisterstunde“ abgeschlossen
			call QuestWitchingHour.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// Worum geht’s?
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Worum geht’s?", "What's the matter?"), null)
			call speech(info, character, true, tre("Erstmal hallo. Ich bin Guntrich, der Müller hier. Eigentlich wäre ich ja jetzt auch bei meiner Mühle.", "First hello. I am Guntrich, the miller here. Actually I would be in my mill now."), gg_snd_Guntrich2)
			call speech(info, character, true, tre("Leider ist der Berg anscheinend von bösen Geistern umgeben und die spuken dort Tag und Nacht. Darum bin ich jetzt hier, auf der Suche nach Hilfe.", "Unfortunately, the mountain is apparently surrounded by evil spirits and they are haunting there day and night. That's why I'm here now, looking for help."), gg_snd_Guntrich3)
			call speech(info, character, true, tre("Ich war schon bei diesem verdammten Burgkleriker und der hat mir was von beten erzählt. Mit Beten bekämpft man aber doch keine Geister.", "I have been at this damn castle cleric and he told me something about praying. But with praying you don't fight spirits."), gg_snd_Guntrich4)
			call speech(info, character, true, tre("Vielleicht kannst du ja mal mit ihm reden. Wenn ich nicht zu meiner Mühle kann, kann ich auch kein Mehl herstellen und das ist mein Ruin!", "Maybe you can talk to him even once. If I cannot go to my mill, I cannot produce any flour and that is my ruin!"), gg_snd_Guntrich5)
			// Neuer Auftrag „Geisterstunde“
			call QuestWitchingHour.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Nein.
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Nein.", "No."), null)
			call speech(info, character, true, tre("Verdammt! Du bist auch nicht anders als die Anderen.", "Damn it! You are no different that the others."), gg_snd_Guntrich6)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.guntrich(), thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tre("Hallo.", "Hello.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tre("Verkaufst du auch irgendwas?", "Are you selling something too?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tre("Was genau machen denn die Geister?", "What exactly do the spirits?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tre("Ich war bei Osman …", "I was with Osman …")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tre("Ich war in der Trommelhöhle im Berg.", "I was in the Drum Cave in the mountain.")) // 4
			call this.addExitButton() // 5

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tre("Worum geht’s?", "What's the matter?")) // 6
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tre("Nein.", "No.")) // 7

			return this
		endmethod

		implement Talk
	endstruct

endlibrary