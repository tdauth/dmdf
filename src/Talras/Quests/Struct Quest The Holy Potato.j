library StructMapQuestsQuestTheHolyPotato requires Asl, StructGameCharacter

	struct QuestTheHolyPotato extends AQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Die heilige Kartoffel", "The Holy Potato"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNSelectHeroOff.blp")
			call this.setDescription(tre("Tobias will, dass du ihm hilfst, indem du gar nichts tust.", "Tobias wants you to help him by doing nothing."))
			call this.setReward(AAbstractQuest.rewardExperience, 50)
			// item 0
			set questItem = AQuestItem.create(this, tre("Tue gar nichts.", "Do nothing."))

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary
