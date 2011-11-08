library StructMapQuestsQuestMushroomSearch requires Asl

	struct QuestMushroomSearch extends AQuest
		private static constant integer requiredMushrooms = 6
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
			local thistype this = thistype.allocate(character, tr("Pilzsuche"))
			local AQuestItem questItem0

			set this.m_mushrooms = 0

			call this.setIconPath("") /// @todo FIXME
			call this.setDescription(tr("Der Jäger Dago benötigt einige essbare Pilze für den Herzog von Talras."))
			call this.setReward(AAbstractQuest.rewardExperience, 50)
			call this.setReward(AAbstractQuest.rewardGold, 10)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Sammle einige essbare Pilze für Dago."))

			return this
		endmethod
	endstruct

endlibrary