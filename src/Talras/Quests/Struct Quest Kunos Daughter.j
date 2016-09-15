library StructMapQuestsQuestKunosDaughter requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestKunosDaughter extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Kunos Tochter", "Kuno's Daughter"))
			local AQuestItem questItem = 0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNImprovedBows.blp")
			call this.setDescription(tre("Die Tochter des Holzfällers Kuno will sich später einmal alleine durch die Wildnis schlagen, kennt sich aber nicht mit der Jagd aus.", "The daughter of the woodcutter Kuno wants to fend herself in the wilderness later in life but doesn't know anything about the hunt."))
			call this.setReward(AAbstractQuest.rewardExperience, 200)
			// item 0
			set questItem = AQuestItem.create(this, tre("￼￼Finde einen Jagd-Lehrer für Kunos Tochter.", "Find a hunting teacher for Kuno's daughter."))
			call questItem.setReward(AAbstractQuest.rewardExperience, 50)

			// item 1
			set questItem = AQuestItem.create(this, tre("Berichte Kuno davon.", "Report to Kuno about it."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.kuno())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(AAbstractQuest.rewardExperience, 50)

			return this
		endmethod
	endstruct

endlibrary