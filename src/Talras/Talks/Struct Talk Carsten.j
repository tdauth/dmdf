library StructMapTalksTalkCarsten requires Asl, StructMapQuestsQuestTheAuthor

	/**
	 * \brief Carsten is a hidden character placed on a lonely island. He is based on a real author.
	 * \note If you overlook him in the game he will be suffering on his island forever!
	 */
	struct TalkCarsten extends Talk
		private AInfo m_hi
		private AInfo m_help
		private AInfo m_scroll
		private AInfo m_read
		private AInfo m_exit

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		// Hallo.
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Hallo, ich bin Carsten. Ich bin Autor. Kannst du mir helfen von dieser Insel weg zu kommen?", "Hello, I'm Carsten. I'm an author. Can you help me to get off this island?"), gg_snd_Carsten1)
			call speech(info, character, false, tre("Wie bist du überhaupt hier her gekommen?", "How did you get here, anyway?"), null)
			call speech(info, character, true, tre("Mein Verleger hat mich auf diese Insel verbannt, solange bis ich mein Buch vollendet habe. Ich fürchte aber, dass er in der Zwischenzeit verstorben ist.", "My publisher has banished me to this island, until I have completed my book. But I fear that he has passed away in the meantime."), gg_snd_Carsten2)
			call speech(info, character, false, tre("Und hast du dein Buch vollendet?", "And have you completed your book?"), null)
			call speech(info, character, true, tre("Sicher. Es heißt \"Die Dunkelmagierchroniken\" und wird bestimmt das meistverkaufte Werk in den Klöstern des Königreichs. Die einfachen Leute können sowieso nicht lesen, was bedeutet, dass ich es entsprechend den Vorgaben der meisten Klöster schreiben musste.", "Sure. It is called \"The Dark Mage Chronicles\" and will certainly become the best-selling work in the monasteries of the kingdom. Ordinary people cannot read anyway which means that I ahd to write it according to the specifications of most monasteries."), gg_snd_Carsten3)
			call speech(info, character, false, tre("Und was bedeutet das genau?", "And what exactly does that mean?"), null)
			call speech(info, character, true, tre("Wenig Tiefgründiges und viel Versautes. Das ist doch, was die ganzen Kleriker und Priester wollen. Also hilfst du mir?", "Little profound and much perverted. That's what all the clerics and priests want. So will you help me?"), gg_snd_Carsten4)

			call info.talk().showStartPage(character)
		endmethod

		private static method infoConditionHelp takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		private static method infoActionHelp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wie kann ich dir helfen?", "How can I help you?"), null)
			call speech(info, character, true, tre("Ganz einfach. Besorge mir eine Sprucholle des Weges. Damit sollte ich mich von hier weg teleportieren können.", "That's simple. Get me a Scroll of the Way. With this I should be able to teleport myself away from here."), gg_snd_Carsten5)
			call QuestTheAuthor.characterQuest(character).enable()

			call info.talk().showStartPage(character)
		endmethod

		private static method infoConditionScroll takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return character.inventory().hasItemType('I037') and QuestTheAuthor.characterQuest(character).isNew()
		endmethod

		private static method infoActionScroll takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hier ist eine Spruchrolle des Weges.", "Here is your Scroll of the Way."), null)
			call speech(info, character, true, tre("Ich danke dir. Wenn ich mich bereit fühle, werde ich es wagen die Spruchrolle anzuwenden. Diese Insel hat mich beinahe zermürbt. Dafür ist mein Werk umso besser geworden. Hier hast du ein paar Goldmünzen zur Belohnung.", "I thank you. When I feel ready, I'll venture to use the scroll. This island has almost demoralized me. But my work has become all the better. Here you have a few gold coins as a reward."), gg_snd_Carsten6)
			call character.inventory().removeItemType('I037')
			call QuestTheAuthor.characterQuest(character).complete()

			call info.talk().showStartPage(character)
		endmethod

		private static method infoConditionRead takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		private static method infoActionRead takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Lies mir etwas aus deinem Buch vor.", "Read something from your book."), null)
			call speech(info, character, true, tre("Was? Bist du des Wahnsinns? Aus meinem vollkommenen, perfekten Werk soll ich DIR vorlesen? Erst wenn es von den Dienern des Klosters vervielfacht wurde, kannst du es vielleicht zu einem Preis von 10 000 Goldmünzen erwerben und dieser Preis läge noch weit unter dem eigentlichen Marktwert.", "What? Are you of madness? I should read from my complete, perfect work to YOU? Only when it has been multiplied by the servants of the monastery, perhaps you can purchase it at a price of 10 000 gold coins and this price would still be far below the actual market value."), gg_snd_Carsten7)
			call speech(info, character, true, tre("In dieses Buch ist meine Leidenschaft geflossen. Zwanzig Jahre musste ich auf dieser Insel verweilen, bis du schließlich kamst. Es ist ein Werk der Zukunft, der Veränderung, es wird eine neue Religion begründen, den Frieden bringen. Es ist ...", "In this book has flowed my passion. Twenty years I had to stay on this island until you finally came. It is a work of the future, of change, it will etablish a new religion, bring peace. It is ..."), gg_snd_Carsten8)
			call speech(info, character, false, tre("Schon gut.", "All right!"), null)

			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.carsten(), thistype.startPageAction)

			// start page
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tre("Hallo.", "Hello."))
			set this.m_help = this.addInfo(false, false, thistype.infoConditionHelp, thistype.infoActionHelp, tre("Wie kann ich dir helfen?", "How can I help you?"))
			set this.m_scroll = this.addInfo(false, false, thistype.infoConditionScroll, thistype.infoActionScroll, tre("Hier ist eine Spruchrolle des Weges.", "Here is your Scroll of the Way."))
			set this.m_read = this.addInfo(true, false, thistype.infoConditionRead, thistype.infoActionRead, tre("Lies mir etwas aus deinem Buch vor.", "Read something from your book."))
			set this.m_exit = this.addExitButton()

			return this
		endmethod

		implement Talk
	endstruct

endlibrary