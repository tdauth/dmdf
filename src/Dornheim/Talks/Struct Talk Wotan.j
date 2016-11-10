library StructMapTalksTalkWotan requires Asl, StructMapMapNpcs, StructMapQuestsQuestShitOnTheThrone

	struct TalkWotan extends Talk

		implement Talk

		private AInfo m_hi
		private AInfo m_shit
		private AInfo m_exit

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Ich grüße dich, Wotan."), null)
			call speech(info, character, true, tr("Du bist derjenige, der aufbricht, in eine andere Welt."), null)

			call this.showStartPage(character)
		endmethod

		private static method infoConditionShit takes AInfo info, ACharacter character returns boolean
			local QuestShitOnTheThrone characterQuest = QuestShitOnTheThrone.characterQuest(character)
			return characterQuest.questItem(QuestShitOnTheThrone.questItemPlaceShit).isCompleted() and characterQuest.questItem(QuestShitOnTheThrone.questItemTalkToWotan).isNew()
		endmethod

		private static method infoActionShit takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			local QuestShitOnTheThrone characterQuest = QuestShitOnTheThrone.characterQuest(character)
			call speech(info, character, false, tr("Wie sitzt es sich auf dem Thron?"), null)
			call speech(info, character, true, tr("Wer hat es gewagt meinen Thron mit dieser Wurst zu beflecken? Möge der Frevler hervortreten auf dass ich ihn verzaubere, in ein elendes Huhn!"), null)
			call speech(info, character, true, tr("Sprich, wer ist es, der mir dieses braune Gemisch unter meinem Arsch platzierte!"), null)
			call speech(info, character, false, tr("Ich weiß nicht wovon du sprichst."), null)
			call speech(info, character, true, tr("Ich warne dich! Denk ja nicht, dass jede Tat vergessen ist, wenn du wiederkehrst!"), null)

			call characterQuest.questItem(QuestShitOnTheThrone.questItemTalkToWotan).complete()

			call this.showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.wotan(), thistype.startPageAction)
			call this.setName(tre("Wotan", "Wotan"))

			// start page
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tr("Ich grüße dich, Wotan."))
			set this.m_shit = this.addInfo(false, false, thistype.infoConditionShit, thistype.infoActionShit, tr("Wie sitzt es sich auf dem Thron?"))
			set this.m_exit = this.addExitButton()

			return this
		endmethod
	endstruct

endlibrary