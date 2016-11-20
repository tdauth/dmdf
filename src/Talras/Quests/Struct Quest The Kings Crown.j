library StructMapQuestsQuestTheKingsCrown requires Asl, Game

	struct QuestTheKingsCrown extends AQuest
		public static constant integer crownItemTypeId = 'I01A'

		public stub method enable takes nothing returns boolean
			return super.enableUntil(0)
		endmethod

		private static method stateEventCompleted0 takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DEATH)
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == 'n01P' and RectContainsUnit(gg_rct_quest_the_kings_crown_target_0_area, questItem.quest().character().unit())
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			call Character(questItem.character()).giveQuestItem(thistype.crownItemTypeId)
			call questItem.quest().questItem(1).enable()
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Des Königs Krone", "The King's Crown"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNSkeletonKing.blp")
			call this.setDescription(tre("Der Schmied Wieland aus Talras möchte, dass du den König der Untoten findest und ihm seine Krone abnimmst. Wieland möchte sie seinem Sohn schenken, sobald dieser vom Kriegsdienst zurückkehrt.", "The blacksmith Wieland from Talras wants you to find the king of the undead and to take his crown. Wieland wants to give the crown to his son as soon as he returns from military service."))
			call this.setReward(thistype.rewardExperience, 800)
			call this.setReward(thistype.rewardGold, 200)
			// item 0
			set questItem = AQuestItem.create(this, tre("Finde den König der Untoten und nimm ihm seine Krone ab.", "Find the king of the undead and take from him his crown."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			call questItem.setPing(true)
			call questItem.setPingCoordinatesFromRect(gg_rct_quest_the_kings_crown_target_0_ping)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem = AQuestItem.create(this, tre("Bringe die Krone zu Wieland.", "Bring the crown to Wieland."))
			call questItem.setPing(true)
			call questItem.setPingUnit(gg_unit_n01J_0154)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary