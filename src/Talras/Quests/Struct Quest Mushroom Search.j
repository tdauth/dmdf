library StructMapQuestsQuestMushroomSearch requires Asl, StructGameCharacter

	struct QuestMushroomSearch extends AQuest
		private static constant integer requiredMushrooms = 4
		private integer m_mushrooms

		public method addMushroom takes nothing returns boolean
			set this.m_mushrooms = this.m_mushrooms + 1
			return this.m_mushrooms == thistype.requiredMushrooms
		endmethod

		public method displayMushrooms takes nothing returns nothing
			call this.displayUpdateMessage(Format(trpe("%1%/%2% Pilz", "%1%/%2% Pilze", "%1%/%2% Mushroom", "%1%/%2% Mushrooms", this.m_mushrooms)).i(this.m_mushrooms).i(thistype.requiredMushrooms).result())
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
			set questItem = AQuestItem.create(this, tre(Format("Sammle %1% essbare Pilze für Dago.").i(thistype.requiredMushrooms).result(), Format("Collect %1% ediable mushrooms for Dago.").i(thistype.requiredMushrooms).result()))

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary