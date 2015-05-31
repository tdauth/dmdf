library StructMapQuestsQuestArenaChampion requires Asl, StructMapMapNpcs

	struct QuestArenaChampion extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(0)
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tr("Arenameister"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNFootman.blp")
			call this.setDescription(tr("Agihard gibt jedem, der es schafft mindestens fünf Gegner in seiner Arena zu besiegen, eine besondere Belohnung."))
			call this.setReward(thistype.rewardExperience, 200)
			call this.setReward(thistype.rewardGold, 60)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Besiege mindestens fünf Gegner in der Arena."))
			call questItem0.setPing(true)
			call questItem0.setPingCoordinatesFromRect(gg_rct_arena_0)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem1 = AQuestItem.create(this, tr("Berichte Agihard von deinem Erfolg."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(Npcs.agihard())
			call questItem1.setPingColour(100.0, 100.0, 100.0)
			return this
		endmethod
	endstruct

endlibrary