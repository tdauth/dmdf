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
			local AQuestItem questItem2
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNPandarenBrewmaster.blp")
			call this.setDescription(tr("Der Schamane Tellborn hat aus Versehen seinen Freund Fulco in einen Bären verwandelt. Besorge ihm die Zutaten für seinen Zaubertrank. damit er Fulco wieder in einen Menschen zurückverwandeln kann."))
			call this.setReward(AAbstractQuest.rewardExperience, 2000)
			call this.setReward(AAbstractQuest.rewardGold, 1200)
			//item 0
			set questItem0 = AQuestItem.create(this, tr("Suche nach Dämonenasche"))
			//item 1
			set questItem1 = AQuestItem.create(this, tr("Suche nach Engelslocken"))
			//item 1
			set questItem2 = AQuestItem.create(this, tr("Suche nach Schamanenkraut"))
			
			return this
		endmethod
	endstruct

endlibrary
