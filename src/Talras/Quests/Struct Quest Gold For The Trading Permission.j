library StructMapQuestsQuestGoldForTheTradingPermission requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestGoldForTheTradingPermission extends AQuest

		implement CharacterQuest

		public method improveReward takes nothing returns nothing
			call this.setReward(thistype.rewardExperience, 50)
		endmethod

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Gold für die Handelserlaubnis", "Gold for the Trading Permission"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNChestOfGold.blp")
			call this.setDescription(tre("Der Händler Haid darf seine Waren nicht in der Burg Talras verkaufen, da ihm die benötigte Handelsgenehmigung fehlt. Leider fehlen ihm die nötigen Goldmünzen, um sich beim Vogt eine solche Handelsgenehmigung zu erwerben.", "The merchant Haid may not sell his goods in the castle Talras because he lacks the required distribution authorization. Unfortunately, he lacks the necessary gold coins to acquire such a distribution authorization at the bailiff."))
			call this.setReward(thistype.rewardExperience, 150)
			// item 0
			set questItem = AQuestItem.create(this, tre("Gib Händler Haid die benötigten Goldmünzen für eine Handelsgenehmigung in Talras.", "Give merchant Haid the required gold coins for the trading permission in Talras."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.haid())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary