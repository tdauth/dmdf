library StructMapTalksTalkTobias requires Asl

	struct TalkTobias extends ATalk

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(3, character)
		endmethod

		// Was machst du da?
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was machst du da?"), null)
			call speech(info, character, true, tr("Was? Wer bist du? Was willst du hier? Bist du gekommen, um mich zu erlösen?"), null)
			call speech(info, character, false, tr("Erlösen, wovon?"), null)
			call speech(info, character, true, tr("Die Kartoffel hat mir prophezeit, dass ein sprechender Esel kommen wird, der dann wieder geht!"), null)
			call speech(info, character, false, tr("Sprechender Esel, Kartoffel, wovon sprichst du überhaupt?"), null)
			call speech(info, character, true, tr("Sag bloß, du kennst die heilige Kartoffel nicht. Sie ist die Gottheit unserer Welt. Aus ihr wurden wir alle geschaffen und sie besiegte das Huhn mit ihren Kochtopf! Du solltest dankbar sein, dass es sie gibt."), null)
			call speech(info, character, false, tr("Hast du einen an der Waffel?"), null)
			call speech(info, character, true, tr("Nein, das Zeitalter ist noch nicht gekommen."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nachdem der Charakter ihn gefragt hat, was er da macht)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Deine Kartoffel ist ein verfaulter Apfel.
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Deine Kartoffel ist ein verfaulter Apfel."), null)
			call speech(info, character, true, tr("Nein, das ist nicht möglich! Wie konnte das geschehen? Das Huhn muss zurückgekommen sein als ich geschlafen habe."), null)
			call speech(info, character, false, tr("Wann hast du denn geschlafen?"), null)
			call speech(info, character, true, tr("Noch nie."), null)
			call speech(info, character, false, tr("Ach so."), null)
			call speech(info, character, true, tr("Was soll ich nur tun? Mein Leben ist sinnlos!"), null)
			call info.talk().showRange(4, 5, character)
		endmethod

		// Hast du was zu verkaufen?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hast du was zu verkaufen?"), null)
			call speech(info, character, true, tr("Nein, aber nur das Beste. Holzbaummann mit Hölzern dran."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Das war es vorher auch schon.
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Das war es vorher auch schon."), null)
			call speech(info, character, true, tr("Verräter, du bist also der runde Kreis!"), null)
			call speech(info, character, false, tr("Möglich ..."), null)
			call speech(info, character, true, tr("Dann verschwinde bevor ich meine magischen Kräfte gegen dich einsetze und dich in einen Menschen verwandle!"), null)
			call speech(info, character, false, tr("Ich bin ein Mensch."), null)
			call speech(info, character, true, tr("Dann wirst du eben noch einer."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Soll ich dir helfen?
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Soll ich dir helfen?"), null)
			call speech(info, character, true, tr("Würdest du das tun? Die Kartoffel wird dich reich belohnen!"), null)
			call speech(info, character, false, tr("Schon gut, was muss ich tun?"), null)
			call speech(info, character, true, tr("Gar nichts."), null)
			call QuestTheHolyPotato.characterQuest(character).enable()
			call speech(info, character, false, tr("Erledigt."), null)
			call speech(info, character, true, tr("Du hast es tatsächlich geschafft. Ich danke dir!"), null)
			call QuestTheHolyPotato.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n01C_0064, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Was machst du da?")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Deine Kartoffel ist ein verfaulter Apfel.")) // 1
			call this.addInfo(false, false, 0, thistype.infoAction2, tr("Hast du was zu verkaufen?")) // 2
			call this.addExitButton() // 3

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Das war es vorher auch schon.")) // 4
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Soll ich dir helfen?")) // 5

			return this
		endmethod
	endstruct

endlibrary