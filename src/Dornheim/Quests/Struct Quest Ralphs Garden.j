library StructMapQuestsQuestRalphsGarden requires Asl, Game, StructMapMapNpcs

	struct QuestRalphsGarden extends AQuest
		public static constant integer questItemBuyRake = 0
		public static constant integer questItemGarden = 1
		public static constant integer questItemReport = 2
		private trigger m_hintTriggerHans

		private static method onAddItemToBackpackRuke takes AUnitInventory inventory, integer index, boolean firstTime returns nothing
			local thistype this = thistype.characterQuest.evaluate(ACharacterInventory(inventory).character())
			if (this.questItem(thistype.questItemBuyRake).isNew()) then
				if (firstTime and inventory.backpackItemData(index) != 0 and inventory.backpackItemData(index).itemTypeId() == 'I02F') then
					call this.questItem(thistype.questItemBuyRake).setState(thistype.stateCompleted)
				endif
			endif
		endmethod

		public stub method enable takes nothing returns boolean
			local Character character = Character(this.character())
			// TODO Add ability for the mission.
			//call character.options().missions().addMission('A1R8', 'A1RK', this)

			call character.inventory().addOnAddToBackpackFunction(thistype.onAddItemToBackpackRuke)

			return super.enableUntil(thistype.questItemGarden)
		endmethod

		private static method stateActionCompletedBuyRake takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.displayState()
		endmethod

		private static method stateEventCompletedGarden takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_ralphs_garden_garden)
		endmethod

		private static method stateConditionCompletedGarden takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local Character character = Character(this.character())
			return GetTriggerUnit() == this.character().unit() and character.inventory().totalItemTypeCharges('I02F') >= 1
		endmethod

		private static method stateActionCompletedGarden takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.questItem(thistype.questItemReport).setState(thistype.stateNew)
			call this.displayState()
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Ralphs Garten", "Ralph's Garden"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNShimmerWeed.blp")
			call this.setDescription(tre("Ralph braucht Hilfe beim Umgraben des Gartens. Besorge dir eine Harke beim Händler Hans und grabe den Garten damit um.", "Ralph needs help digging over the garden. Get a ruke from the merchant Hans and dig over the garden with it."))
			call this.setReward(thistype.rewardExperience, 30)
			// item 0
			set questItem = AQuestItem.create(this, tre("Besorge dir eine Harke beim Händler Hans.", "Get a ruke from the merchant Hans."))
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedBuyRake)
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.hans())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			// item 1
			set questItem = AQuestItem.create(this, tre("Grabe den Garten mit der Harke um.", "Dig over the garden with the ruke."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedGarden)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedGarden)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedGarden)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_ralphs_garden_garden)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			// item 2
			set questItem = AQuestItem.create(this, tre("Berichte Ralph davon.", "Report to Ralph about it."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.ralph())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary