library StructMapQuestsQuestTheKingsCrown requires Asl

	struct QuestTheKingsCrown extends AQuest
		public static constant integer crownItemTypeId = 'I01A'

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(0)
		endmethod

		private static method stateEventCompleted0 takes AQuestItem questItem, trigger whichTrigger returns nothing
			local player owner = Player(PLAYER_NEUTRAL_AGGRESSIVE)
			local event triggerEvent = TriggerRegisterPlayerUnitEvent(whichTrigger, owner, EVENT_PLAYER_UNIT_DEATH, null)
			set owner = null
			set triggerEvent = null
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			local unit triggerUnit = GetTriggerUnit()
			local boolean result = GetUnitTypeId(triggerUnit) == 'n01P'
			local unit characterUnit
			if (result) then
				set characterUnit = questItem.quest().character().unit()
				set result = RectContainsUnit(gg_rct_quest_the_kings_crown_target_0_area, characterUnit)
				set characterUnit = null
			endif
			set triggerUnit = null
			return result
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			local unit characterUnit = questItem.quest().character().unit()
			local item whichItem = CreateItem(thistype.crownItemTypeId, 0.0, 0.0)
			call UnitAddItem(characterUnit, whichItem)
			call questItem.quest().questItem(1).enable()
			set characterUnit = null
			set whichItem = null
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tr("Des Königs Krone"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNSkeletonKing.blp")
			call this.setDescription(tr("Der Schmied Wieland aus Talras möchte, dass du den König der Untoten findest und ihm seine Krone abnimmst. Wieland möchte sie seinem Sohn schenken, sobald dieser vom Kriegsdienst zurückkehrt."))
			call this.setReward(AAbstractQuest.rewardExperience, 800)
			call this.setReward(AAbstractQuest.rewardGold, 200)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Finde den König der Untoten und nimm ihm seine Krone ab."))
			call questItem0.setStateEvent(AAbstractQuest.stateCompleted, thistype.stateEventCompleted0)
			call questItem0.setStateCondition(AAbstractQuest.stateCompleted, thistype.stateConditionCompleted0)
			call questItem0.setStateAction(AAbstractQuest.stateCompleted, thistype.stateActionCompleted0)
			call questItem0.setPing(true)
			call questItem0.setPingCoordinatesFromRect(gg_rct_quest_the_kings_crown_target_0_ping)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem1 = AQuestItem.create(this, tr("Bring die Krone zu Wieland."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(gg_unit_n01J_0154)
			call questItem1.setPingColour(100.0, 100.0, 100.0)
			return this
		endmethod
	endstruct

endlibrary