library StructMapQuestsQuestMushroomSearch requires Asl, StructGameCharacter

	struct QuestMushroomSearch extends AQuest
		private static constant integer requiredMushrooms = 4
		private integer m_mushrooms

		implement CharacterQuest

		public method addMushroom takes nothing returns boolean
			set this.m_mushrooms = this.m_mushrooms + 1
			return this.m_mushrooms == thistype.requiredMushrooms
		endmethod

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Pilzsuche", "Mushroom Search"))
			local AQuestItem questItem = 0

			set this.m_mushrooms = 0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNMushroom.blp")
			call this.setDescription(tre("Der Jäger Dago benötigt einige essbare Pilze für den Herzog von Talras.", "The hunter Dago needs some edible mushrooms for the duke of Talras."))
			call this.setReward(thistype.rewardExperience, 200)
			call this.setReward(thistype.rewardGold, 30)
			// item 0
			set questItem = AQuestItem.create(this, tre("Sammle einige essbare Pilze für Dago.", "Collect some ediable mushrooms for Dago."))

			return this
		endmethod
	endstruct

endlibrary