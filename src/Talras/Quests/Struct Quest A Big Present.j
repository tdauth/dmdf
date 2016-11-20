library StructMapQuestsQuestABigPresent requires Asl, Game, StructMapMapNpcs

	struct QuestABigPresent extends AQuest
		public static constant integer itemTypeId = 'I03X'

		public stub method enable takes nothing returns boolean
			local Character character = Character(this.character())
			call character.giveQuestItem(thistype.itemTypeId)
			call character.options().missions().addMission('A1R8', 'A1RK', this)
			return super.enableUntil(1)
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Ein großes Geschenk", "A Big Present"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNBarrel.blp")
			call this.setDescription(tre("Da Lothar mit Mathildas Reaktion auf sein Geschenk nicht zufrieden war, hat er dir nun aufgetragen, ihr einen noch größeren Honigtopf zu überreichen, um seiner Liebe zu ihr noch größeren Ausdruck zu verleihen.", "Since Lothar is unhappy with Mathilda's reaction to his present he has now told you to give her an even bigger honeypot to impart his love for her even greater expression."))
			call this.setReward(thistype.rewardExperience, 200)
			// item 0
			set questItem = AQuestItem.create(this, tre("Überreiche Mathilda Lothars großen Honigtopf.", "Present Mathilda Lothar's big honeypot."))
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

		implement CharacterQuest
	endstruct

endlibrary