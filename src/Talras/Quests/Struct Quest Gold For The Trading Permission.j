library StructMapQuestsQuestGoldForTheTradingPermission requires Asl, StructMapMapNpcs

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
			local AQuestItem questItem0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNChestOfGold.blp")
			call this.setDescription(tr("Der Händler Haid darf seine Waren nicht in der Burg Talras verkaufen, da ihm die benötigte Handelsgenehmigung fehlt. Leider fehlen ihm die nötigen Goldmünzen, um sich beim Vogt eine solche Handelsgenehmigung zu erwerben."))
			call this.setReward(thistype.rewardExperience, 400)
			//item 0
			set questItem0 = AQuestItem.create(this, tre("Gib Händler Haid die benötigten Goldmünzen für eine Handelsgenehmigung in Talras.", "Give merchant Haid the required gold coins for the trading permission in Talras."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.haid())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			return this
		endmethod
	endstruct

endlibrary