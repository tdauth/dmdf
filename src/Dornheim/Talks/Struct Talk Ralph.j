library StructMapTalksTalkRalph requires Asl, StructMapMapNpcs

	struct TalkRalph extends Talk

		implement Talk

		private AInfo m_hi
		private AInfo m_exit

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		// Hi.
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hallo Ralph!", "Hello Ralph!"), null)
			call speech(info, character, true, tre("Hallo, alles klar?", "Hello, is everything fine?."), null)

			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.ralph(), thistype.startPageAction)
			call this.setName(tre("Ralph", "Ralph"))

			// start page
			set this.m_hi = this.addInfo(true, false, 0, thistype.infoActionHi, tre("Hallo Ralph!", "Hello Ralph!"))
			set this.m_exit = this.addExitButton()

			return this
		endmethod
	endstruct

endlibrary