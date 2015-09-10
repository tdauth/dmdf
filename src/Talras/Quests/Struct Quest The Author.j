library StructMapQuestsQuestTheAuthor requires Asl

	struct QuestTheAuthor extends AQuest
	
		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Der Autor"))
			local AQuestItem questItem0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNBanditMage.blp")
			call this.setDescription(tr("Auf einer kleinen Insel nördlich von Talras befindet sich der Autor Carsten, der gerne von dieser Insel weg kommen möchte, auf der er schon sehr lange verweilt."))
			call this.setReward(AAbstractQuest.rewardExperience, 150)
			call this.setReward(AAbstractQuest.rewardGold, 120) // costs of 100 + 20 reward
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Besorge Carsten eine Spruchrolle des Weges."))

			return this
		endmethod
	endstruct

endlibrary