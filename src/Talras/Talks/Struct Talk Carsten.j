library StructMapTalksTalkCarsten requires Asl, StructMapQuestsQuestTheAuthor

	/**
	 * \brief Carsten is a hidden character placed on a lonely island. He is based on a real author.
	 * \note If you overlook him in the game he will be suffering on his island forever!
	 */
	struct TalkCarsten extends Talk

		implement Talk
		
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
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo, ich bin Carsten. Ich bin Autor. Kannst du mir helfen von dieser Insel weg zu kommen?"), null)
			call speech(info, character, false, tr("Wie bist du überhaupt hier her gekommen?"), null)
			call speech(info, character, true, tr("Mein Verleger hat mich auf diese Insel verbannt, solange bis ich mein Buch vollendet habe. Ich fürchte aber, dass er in der Zwischenzeit verstorben ist."), null)
			call speech(info, character, false, tr("Und hast du dein Buch vollendet?"), null)
			call speech(info, character, true, tr("Sicher. Es heißt \"Die Dunkelmagierchroniken\" und wird bestimmt das meistverkaufte Werk in den Klöstern des Königreichs. Die einfachen Leute können sowieso nicht lesen, was bedeutet, dass ich es entsprechend den Vorgaben der meisten Klöster schreiben musste."), null)
			call speech(info, character, false, tr("Und was bedeutet das genau?"), null)
			call speech(info, character, true, tr("Wenig Tiefgründiges und viel Versautes. Das ist doch, was die ganzen Kleriker und Priester wollen. Also hilfst du mir?"), null)
			
			call info.talk().showStartPage(character)
		endmethod
		
		private static method infoConditionHelp takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod
		
		private static method infoActionHelp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wie kann ich dir helfen?"), null)
			call speech(info, character, true, tr("Ganz einfach. Besorge mir eine Sprucholle des Weges. Damit sollte ich mich von hier weg teleportieren können."), null)
			call QuestTheAuthor.characterQuest(character).enable()
			
			call info.talk().showStartPage(character)
		endmethod
		
		private static method infoConditionScroll takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return character.inventory().hasItemType('I037') and QuestTheAuthor.characterQuest(character).isNew()
		endmethod
		
		private static method infoActionScroll takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hier ist eine Spruchrolle des Weges."), null)
			call speech(info, character, true, tr("Ich danke dir. Wenn ich mich bereit fühle, werde ich es wagen die Spruchrolle anzuwenden. Diese Insel hat mich beinahe zermürbt. Dafür ist mein Werk umso besser geworden. Hier hast du ein paar Goldmünzen zur Belohnung."), null)
			call character.inventory().removeItemType('I037')
			call QuestTheAuthor.characterQuest(character).complete()
			
			call info.talk().showStartPage(character)
		endmethod
		
		private static method infoConditionRead takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod
		
		private static method infoActionRead takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Lies mir etwas aus deinem Buch vor."), null)
			call speech(info, character, true, tr("Was? Bist du des Wahnsinns? Aus meinem vollkommenen, perfekten Werk soll ich DIR vorlesen? Erst wenn es von den Dienern des Klosters vervielfacht wurde, kannst du es vielleicht zu einem Preis von 10 000 Goldmünzen erwerben und dieser Preis läge noch weit unter dem eigentlichen Marktwert."), null)
			call speech(info, character, true, tr("In dieses Buch ist meine Leidenschaft geflossen. Zwanzig Jahre musste ich auf dieser Insel verweilen, bis du schließlich kamst. Es ist ein Werk der Zukunft, der Veränderung, es wird eine neue Religion begründen, den Frieden bringen. Es ist ..."), null)
			call speech(info, character, false, tr("Schon gut."), null)
			
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.carsten(), thistype.startPageAction)

			// start page
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tr("Hallo."))
			set this.m_help = this.addInfo(false, false, thistype.infoConditionHelp, thistype.infoActionHelp, tr("Wie kann ich dir helfen?"))
			set this.m_scroll = this.addInfo(false, false, thistype.infoConditionScroll, thistype.infoActionScroll, tr("Hier ist eine Spruchrolle des Weges."))
			set this.m_read = this.addInfo(true, false, thistype.infoConditionRead, thistype.infoActionRead, tr("Lies mir etwas aus deinem Buch vor."))
			set this.m_exit = this.addExitButton()
			
			return this
		endmethod
	endstruct

endlibrary