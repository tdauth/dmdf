library StructMapQuestsQuestTheAuthor requires Asl

	struct QuestTheAuthor extends AQuest
	
		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Der Autor", "The Author"))
			local AQuestItem questItem0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNBanditMage.blp")
			call this.setDescription(tre("Auf einer kleinen Insel nördlich von Talras befindet sich der Autor Carsten, der gerne von dieser Insel weg kommen möchte, auf der er schon sehr lange verweilt.", "On a small island in the north of Talras there is the author Carsten who wants to get away from this island on which he dewlls for a long time."))
			call this.setReward(thistype.rewardExperience, 150)
			call this.setReward(thistype.rewardGold, 120) // costs of 100 + 20 reward
			// item 0
			set questItem0 = AQuestItem.create(this, tre("Besorge Carsten eine Spruchrolle des Weges.", "Get Carsten a Scroll of the Way."))

			return this
		endmethod
	endstruct

endlibrary