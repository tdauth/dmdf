library StructMapQuestsQuestCatsForBrogo requires Asl, StructMapMapNpcs

	struct QuestCatsForBrogo extends AQuest
		public static constant integer maxCats = 5

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Katzen für Brogo", "Cats for Brogo"))
			local AQuestItem questItem0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNblacktabbycat.blp")
			call this.setDescription(tre("Brogo, der Bärenmensch, möchte gerne Katzen haben, damit er diese streicheln kann.", "Brogo, the bear man, would like to have cats, so he can caress them."))
			call this.setReward(AAbstractQuest.rewardExperience, 500)
			//item 0
			set questItem0 = AQuestItem.create(this, tre("Bringe Brogo fünf Katzen.", "Bring Brogo five cats."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.brogo())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			return this
		endmethod
	endstruct

endlibrary