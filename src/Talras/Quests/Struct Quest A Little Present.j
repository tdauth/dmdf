library StructMapQuestsQuestALittlePresent requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestALittlePresent extends AQuest
		public static constant integer itemTypeId = 'I03W'

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			call Character(this.character()).giveQuestItem(thistype.itemTypeId)
			return super.enableUntil(1)
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Ein kleines Geschenk", "A Small Present"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNBarrel.blp")
			call this.setDescription(tre("Der dicke Händler Lothar hat dich gebeten, Mathilda einen Topf seines besten Honigs als Zeichen seiner Liebe zu ihr zu überreichen.", "The fat merchant Lothar asked you to hand over a pot of his best honey to Mathilda as a sign of his love for her."))
			call this.setReward(AAbstractQuest.rewardExperience, 200)
			// item 0
			set questItem0 = AQuestItem.create(this, tre("Überreiche Mathilda Lothars Honigtopf.", "Present Mathilda Lothar's honeypot."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.mathilda())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(AAbstractQuest.rewardExperience, 50)
			// item 1
			set questItem1 = AQuestItem.create(this, tre("Berichte Lothar davon.", "Report to Lothar about it."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(Npcs.lothar())
			call questItem1.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary