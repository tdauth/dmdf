library StructMapTalksTalkRalph requires Asl, StructMapMapNpcs, StructMapQuestsQuestMother

	struct TalkRalph extends Talk

		implement Talk

		private AInfo m_hi
		private AInfo m_exit

		private AInfo m_hi_yes
		private AInfo m_hi_no

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Hallo Ralph!", "Hello Ralph!"), null)
			call speech(info, character, true, tre("Hallo, alles klar?", "Hello, is everything fine?"), null)

			call this.showRange(this.m_hi_yes.index(), this.m_hi_no.index(), character)
		endmethod

		private static method giveQuest takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, true, tre("Ich glaube deine Mutter wollte noch mit dir sprechen, bevor du aufbrichst.", "I believe your mother wanted to talk to you before you start off."), null)
			call QuestMother.characterQuest(character).enable()
			call this.showStartPage(character)
		endmethod

		private static method infoActionHi_Yes takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ja.", "Yes."), null)
			call speech(info, character, true, tre("Schön, das freut mich.", "Great, I am glad for you."), null)
			call thistype.giveQuest(info, character)
		endmethod

		private static method infoActionHi_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Nein.", "No."), null)
			call speech(info, character, true, tre("Ach das wird schon.", "Oh, it's gonna be alright."), null)
			call thistype.giveQuest(info, character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.ralph(), thistype.startPageAction)
			call this.setName(tre("Ralph", "Ralph"))

			// start page
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tre("Hallo Ralph!", "Hello Ralph!"))
			set this.m_exit = this.addExitButton()

			set this.m_hi_yes =  this.addInfo(true, false, 0, thistype.infoActionHi_Yes, tre("Ja.", "Yes."))
			set this.m_hi_no =  this.addInfo(true, false, 0, thistype.infoActionHi_No, tre("Nein.", "No."))

			return this
		endmethod
	endstruct

endlibrary