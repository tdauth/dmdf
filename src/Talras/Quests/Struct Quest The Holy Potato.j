library StructMapQuestsQuestTheHolyPotato requires Asl

	struct QuestTheHolyPotato extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Die heilige Kartoffel"))
			local AQuestItem questItem0
			call this.setIconPath("") /// @todo fixme
			call this.setDescription(tr("Tobias will, dass du ihm hilfst, indem du gar nichts tust."))
			call this.setReward(AAbstractQuest.rewardExperience, 50)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Tu gar nichts."))

			return this
		endmethod
	endstruct

endlibrary
