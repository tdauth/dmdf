library StructMapQuestsQuestMyFriendTheBear requires Asl

	struct QuestMyFriendTheBear extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Mein Freund der Bär"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNPandarenBrewmaster.blp")
			call this.setDescription(tr("Der Schamane Tellborn hat aus Versehen seinen Freund Fulco in einen Bären verwandelt. Besorge ihm die Zutaten für seinen Zaubertrank. damit er Fulco wieder in einen Menschen zurückverwandeln kann."))
			//item 0
			set questItem0 = AQuestItem.create(this, tr("Suche nach einem ..."))
			//item 1
			set questItem1 = AQuestItem.create(this, tr("Suche nach einem ..."))
			return this
		endmethod
	endstruct

endlibrary
