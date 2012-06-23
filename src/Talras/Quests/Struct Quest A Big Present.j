library StructMapQuestsQuestABigPresent requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestABigPresent extends AQuest
		/// @todo FIXME -> großer Honigtopf
		public static constant integer itemTypeId = 0

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			call Character(this.character()).giveQuestItem(thistype.itemTypeId)
			return super.enableUntil(1)
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tr("Ein großes Geschenk"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("") /// @todo fixme
			call this.setDescription(tr("Da Lothar mit Mathildas Reaktion auf sein Geschenk nicht zufrieden war, hat er dir nun aufgetragen, ihr einen noch größeren Honigtopf zu überreichen, um seiner Liebe zu ihr noch größeren Ausdruck zu verleihen."))
			call this.setReward(AAbstractQuest.rewardExperience, 200)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Überreiche Mathilda Lothars großen Honigtopf."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.mathilda())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(AAbstractQuest.rewardExperience, 50)
			// item 1
			set questItem1 = AQuestItem.create(this, tr("Berichte Lothar davon."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(Npcs.lothar())
			call questItem1.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary