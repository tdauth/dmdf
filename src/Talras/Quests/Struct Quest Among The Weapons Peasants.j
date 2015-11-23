library StructMapQuestsQuestAmongTheWeaponsPeasants requires Asl, StructMapMapNpcs

	struct QuestAmongTheWeaponsPeasants extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Zu den Waffen, Bauern!", "To Arms, Peasants!"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNMilitia.blp")
			call this.setDescription(tr("Der Bauer Manfred beschwert sich darüber, dass der Herzog keine Wachen zu seinem Hof schickt, die diesen im Falle eines Angriffs beschützen könnten. Außerdem beklagt er sich über den von ihm und seinen Leuten geforderten einjährigen Kriegsdienst."))
			call this.setReward(thistype.rewardExperience, 500)
			call this.setReward(thistype.rewardGold, 300)
			// item 0
			set questItem0 = AQuestItem.create(this, tre("Sprich mit Manfred, dem Bauern.", "Speak to Manfred, the peasant."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.manfred())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem1 = AQuestItem.create(this, tre("Berichte Ferdinand von dem Gespräch.", "Report to Ferdinand about the conversation."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(Npcs.ferdinand())
			call questItem1.setPingColour(100.0, 100.0, 100.0)
			return this
		endmethod
	endstruct

endlibrary