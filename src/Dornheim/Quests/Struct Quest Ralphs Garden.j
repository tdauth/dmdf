library StructMapQuestsQuestRalphsGarden requires Asl, Game, StructMapMapNpcs

	struct QuestRalphsGarden extends AQuest
		public static constant integer questItemBuyRake = 0
		public static constant integer questItemGarden = 1
		public static constant integer questItemReport = 2
		private trigger m_hintTriggerHans

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			local Character character = Character(this.character())
			//call character.giveQuestItem(thistype.itemTypeId)
			//call character.options().missions().addMission('A1R8', 'A1RK', this)
			return super.enableUntil(thistype.questItemGarden)
		endmethod

		private static method stateEventCompletedBuyRake takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_PICKUP_ITEM)
		endmethod

		/**
		 * Wenn der Charakter die Gegenstände verliert/verkauft/zerstört macht das nichts.
		 * Im Gespräch wird nochmal überprüft, ob er ihn dabei hat.
		 */
		private static method stateConditionCompletedBuyRake takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			if (GetTriggerUnit() == this.character().unit() and GetItemTypeId(GetManipulatedItem()) == 'I02F') then
				return true
			endif
			return false
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
			call this.setDescription(tr("Ralph braucht Hilfe beim Umgraben des Gartens. Besorge dir eine Harke beim Händler Hans und grabe den Garten damit um."))
			call this.setReward(thistype.rewardExperience, 30)
			// item 0
			set questItem = AQuestItem.create(this, tre("Besorge dir eine Harke beim Händler Hans.", "Get a ruke from the merchant Hans."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedBuyRake)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedBuyRake)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedBuyRake)
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.hans())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			// item 1
			set questItem = AQuestItem.create(this, tr("Grabe den Garten mit der Harke um."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedGarden)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedGarden)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedGarden)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_ralphs_garden_garden)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			// item 2
			set questItem = AQuestItem.create(this, tr("Berichte Ralph davon."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.ralph())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			return this
		endmethod
	endstruct

endlibrary