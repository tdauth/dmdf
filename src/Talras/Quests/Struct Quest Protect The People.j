library StructMapQuestsQuestProtectThePeople requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestProtectThePeople extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(0)
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Schutz dem Volke", "Protecting the People"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNVillagerMan1.blp")
			call this.setDescription(tre("Der Bauer Manfred beschwert sich darüber, dass der Herzog keine Wachen zu seinem Hof schickt, die diesen im Falle eines Angriffs beschützen könnten. Außerdem beklagt er sich über den von ihm und seinen Leuten geforderten einjährigen Kriegsdienst.", "The farmer Manfred complains that the Duke does not send guards to his farm who could protect it in the event of an attack. He also complains about the one year military service which is required of him and his people."))
			call this.setReward(thistype.rewardExperience, 500)
			call this.setReward(thistype.rewardGold, 300)
			// item 0
			set questItem = AQuestItem.create(this, tre("Sprich mit Ferdinand, dem Vogt von Talras.", "Speak with Ferdinand the bailiff of Talras."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.ferdinand())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem = AQuestItem.create(this, tre("Berichte Manfred von dem Gespräch.", "Report to Manfred of the conversation."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.manfred())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary