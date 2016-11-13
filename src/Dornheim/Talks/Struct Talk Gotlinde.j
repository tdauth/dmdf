library StructMapTalksTalkGotlinde requires Asl, StructMapMapNpcs, StructMapQuestsQuestMother

	struct TalkGotlinde extends Talk

		implement Talk

		private AInfo m_hi
		private AInfo m_exit

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		private static method infoConditionHi takes AInfo info, ACharacter character returns boolean
			return QuestMother.characterQuest(character).questItem(QuestMother.questItemGotlinde).isNew()
		endmethod

		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Hallo Gotlinde!", "Hello Gotlinde!"), null)
			call speech(info, character, true, tre("Hallo, ich höre du brichst auf.", "Hello, I've heard you start off."), null)
			call speech(info, character, false, tre("Ja, ich wollte mich von dir verabschieden.", "Yes, I wanted to say goodbye to you."), null)
			call speech(info, character, true, tre("Ach, das ist aber nett von dir. Ich wünsche dir viel Glück auf deiner Reise und pass gut auf dich auf!", "Ah, that is nice of you. I wish you good luck on your journey and take care of yourself!"), null)
			call speech(info, character, false, tre("Das werde ich.", "I will."), null)

			call QuestMother.characterQuest(character).questItem(QuestMother.questItemGotlinde).complete()
			call MapData.enableZoneTalras()

			call this.showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.gotlinde(), thistype.startPageAction)
			call this.setName(tre("Gotlinde", "Gotlinde"))

			// start page
			set this.m_hi = this.addInfo(false, false, thistype.infoConditionHi, thistype.infoActionHi, tre("Hallo Gotlinde!", "Hello Gotlinde!"))
			set this.m_exit = this.addExitButton()

			return this
		endmethod
	endstruct

endlibrary