library StructMapQuestsQuestALittlePresent requires Asl, Game, StructMapMapNpcs

	struct QuestALittlePresent extends AQuest
		public static constant integer itemTypeId = 'I03W'

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			local Character character = Character(this.character())
			call character.giveQuestItem(thistype.itemTypeId)
			call character.options().missions().addMission('A1R9', 'A1RL', this)
			return super.enableUntil(1)
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Ein kleines Geschenk", "A Small Present"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNBarrel.blp")
			call this.setDescription(tre("Der dicke Händler Lothar hat dich gebeten, Mathilda einen Topf seines besten Honigs als Zeichen seiner Liebe zu ihr zu überreichen.", "The fat merchant Lothar asked you to hand over a pot of his best honey to Mathilda as a sign of his love for her."))
			call this.setReward(thistype.rewardExperience, 200)
			// item 0
			set questItem = AQuestItem.create(this, tre("Überreiche Mathilda Lothars Honigtopf.", "Present Mathilda Lothar's honeypot."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.mathilda())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 50)
			// item 1
			set questItem = AQuestItem.create(this, tre("Berichte Lothar davon.", "Report to Lothar about it."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.lothar())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary