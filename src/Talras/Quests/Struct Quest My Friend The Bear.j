library StructMapQuestsQuestMyFriendTheBear requires Asl

	struct QuestMyFriendTheBear extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Mein Freund der Bär", "My Friend the Bear"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			local AQuestItem questItem2
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNPandarenBrewmaster.blp")
			call this.setDescription(tre("Der Schamane Tellborn hat aus Versehen seinen Freund Fulco in einen Bären verwandelt. Besorge ihm die Zutaten für seinen Zaubertrank. damit er Fulco wieder in einen Menschen zurückverwandeln kann.", "The shaman Tellborn transformed his friend Fulco into a bear by mistake. Procure him the ingredients for his potions, so that he can retransform Fulco into a human again."))
			call this.setReward(AAbstractQuest.rewardExperience, 2000)
			call this.setReward(AAbstractQuest.rewardGold, 1200)
			//item 0
			set questItem0 = AQuestItem.create(this, tre("Suche nach Dämonenasche.", "Search demon ashes."))
			//item 1
			set questItem1 = AQuestItem.create(this, tre("Suche nach Engelslocken.", "Search angel curls."))
			//item 1
			set questItem2 = AQuestItem.create(this, tre("Suche nach Schamanenkraut.", "Search shaman herb."))
			
			return this
		endmethod
	endstruct

endlibrary
