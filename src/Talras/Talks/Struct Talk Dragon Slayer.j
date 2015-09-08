library StructMapTalksTalkDragonSlayer requires Asl, StructGameClasses, StructMapMapArena, StructMapMapNpcs

	struct TalkDragonSlayer extends Talk
		private AInfo m_exit

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.dragonSlayer(), thistype.startPageAction)
			call this.setName(tr("Drachentöterin"))
			
			set this.m_exit = this.addExitButton()

			return this
		endmethod
	endstruct

endlibrary
