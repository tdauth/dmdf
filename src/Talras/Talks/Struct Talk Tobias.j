library StructMapTalksTalkTobias requires Asl, StructMapQuestsQuestTheHolyPotato

	struct TalkTobias extends Talk

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(3, character)
		endmethod

		// Was machst du da?
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was machst du da?", "What are you doing here?"), null)
			call speech(info, character, true, tre("Was? Wer bist du? Was willst du hier? Bist du gekommen, um mich zu erlösen?", "What? Who are you? What do you want here? Have you come to save me?"), gg_snd_Tobias1)
			call speech(info, character, false, tre("Erlösen, wovon?", "Save from what?"), null)
			call speech(info, character, true, tre("Die Kartoffel hat mir prophezeit, dass ein sprechender Esel kommen wird, der dann wieder geht!", "The potato has prophesied to me that a speaking donkey will come, who will leave again!"), gg_snd_Tobias2)
			call speech(info, character, false, tre("Sprechender Esel, Kartoffel, wovon sprichst du überhaupt?", "Talking donkey, potato, what are you talking about?"), null)
			call speech(info, character, true, tre("Sag bloß, du kennst die heilige Kartoffel nicht. Sie ist die Gottheit unserer Welt. Aus ihr wurden wir alle geschaffen und sie besiegte das Huhn mit ihrem Kochtopf! Du solltest dankbar sein, dass es sie gibt.", "Just say you do not know the holy potato. It is the divinity of our world. From it we were all created and it defeated the chicken with its cooking pot! You should be grateful that it exists."), gg_snd_Tobias3)
			call speech(info, character, false, tre("Hast du einen an der Waffel?", "Are you crazy?"), null)
			call speech(info, character, true, tre("Nein, das Zeitalter ist noch nicht gekommen.", "No, the age has not yet come."), gg_snd_Tobias4)
			call info.talk().showStartPage(character)
		endmethod

		// (Nachdem der Charakter ihn gefragt hat, was er da macht)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Deine Kartoffel ist ein verfaulter Apfel.
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Deine Kartoffel ist ein verfaulter Apfel.", "Your potato is a rotten apple."), null)
			call speech(info, character, true, tre("Nein, das ist nicht möglich! Wie konnte das geschehen? Das Huhn muss zurückgekommen sein als ich geschlafen habe.", "No, that's impossible! How could this happen? The chicken must have come back when I slept."), gg_snd_Tobias5)
			call speech(info, character, false, tre("Wann hast du denn geschlafen?", "When did you sleep?"), null)
			call speech(info, character, true, tre("Noch nie.", "Never."), gg_snd_Tobias14)
			call speech(info, character, false, tre("Ach so.", "Alright."), null)
			call speech(info, character, true, tre("Was soll ich nur tun? Mein Leben ist sinnlos!", "What should I do? My life is meaningless!"), gg_snd_Tobias6)
			call info.talk().showRange(4, 5, character)
		endmethod

		// Hast du was zu verkaufen?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hast du was zu verkaufen?", "Do you have something to sell?"), null)
			call speech(info, character, true, tre("Nein, aber nur das Beste. Holzbaummann mit Hölzern dran.", "No, but only the best. Wood tree man with wood on him."), gg_snd_Tobias13)
			call info.talk().showStartPage(character)
		endmethod

		// Das war es vorher auch schon.
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Das war es vorher auch schon.", "That's what it has already been before."), null)
			call speech(info, character, true, tre("Verräter, du bist also der runde Kreis!", "Traitor, you are the round circle!"), gg_snd_Tobias7)
			call speech(info, character, false, tre("Möglich ...", "Possible ..."), null)
			call speech(info, character, true, tre("Dann verschwinde bevor ich meine magischen Kräfte gegen dich einsetze und dich in einen Menschen verwandle!", "Then disappear before I use my magical powers against you and transform you into a human being."), gg_snd_Tobias8)
			call speech(info, character, false, tre("Ich bin ein Mensch.", "I am a human being."), null)
			call speech(info, character, true, tre("Dann wirst du eben noch einer.", "Then you will be just another one."), gg_snd_Tobias9)
			call info.talk().showStartPage(character)
		endmethod

		// Soll ich dir helfen?
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Soll ich dir helfen?", "Should I help you?"), null)
			call speech(info, character, true, tre("Würdest du das tun? Die Kartoffel wird dich reich belohnen!", "Would you do that? The potato will reward you richly!"), gg_snd_Tobias10)
			call speech(info, character, false, tre("Schon gut, was muss ich tun?", "Alright, what do I have to do?"), null)
			call speech(info, character, true, tre("Gar nichts.", "Nothing at all."), gg_snd_Tobias11)
			call QuestTheHolyPotato.characterQuest(character).enable()
			call speech(info, character, false, tre("Erledigt.", "Done."), null)
			call speech(info, character, true, tre("Du hast es tatsächlich geschafft. Ich danke dir!", "You actually did it. I thank you!"), gg_snd_Tobias12)
			call QuestTheHolyPotato.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n01C_0064, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tre("Was machst du da?", "What are you doing here?")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tre("Deine Kartoffel ist ein verfaulter Apfel.", "Your potato is a rotten apple.")) // 1
			call this.addInfo(false, false, 0, thistype.infoAction2, tre("Hast du was zu verkaufen?", "Do you have something to sell?")) // 2
			call this.addExitButton() // 3

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tre("Das war es vorher auch schon.", "That's what it has already been before.")) // 4
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tre("Soll ich dir helfen?", "Should I help you?")) // 5

			return this
		endmethod

		implement Talk
	endstruct

endlibrary