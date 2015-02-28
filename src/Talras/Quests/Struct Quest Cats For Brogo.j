library StructMapQuestsQuestCatsForBrogo requires Asl

	struct QuestCatsForBrogo extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Katzen für Brogo"))
			local AQuestItem questItem0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNblacktabbycat.blp")
			call this.setDescription(tr("Brogo, der Bärenmensch, möchte gerne Katzen haben, damit er diese streicheln kann."))
			call this.setReward(AAbstractQuest.rewardExperience, 500)
			//item 0
			set questItem0 = AQuestItem.create(this, tr("Bring Brogo ein paar Katzen."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(gg_unit_n020_0012)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			return this
		endmethod
	endstruct

endlibrary