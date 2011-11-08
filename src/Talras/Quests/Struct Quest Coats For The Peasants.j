library StructMapQuestsQuestCoatsForThePeasants requires Asl

	/// @todo Auftragsziel 1 abschließen, wenn der Charakter drei Riesen-Felle hat
	/// @todo Auftragsziel 2 entfernt bei Abschluss drei Riesen-Felle aus dem Inventar
	struct QuestCoatsForThePeasants extends AQuest
		private static constant integer itemTypeId = 'I01Z'

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		public stub method disable takes nothing returns boolean
			return super.disable()
		endmethod

		/// @todo Register event which is fired when unit keeps item (AInventory).
		private static method stateEventCompleted0 takes AQuestItem questItem, trigger whichTrigger returns nothing
			local event triggerEvent = TriggerRegisterUnitEvent(whichTrigger, questItem.character().unit(),  EVENT_UNIT_PICKUP_ITEM)
			set triggerEvent = null
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			return GetItemTypeId(GetManipulatedItem()) == thistype.itemTypeId
		endmethod

		private static method stateActionCompleted1 takes AQuestItem questItem returns nothing
			/// @todo Remove three items from inventory!
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Felle für die Bauern"))
			local AQuestItem questItem
			local AQuestItem questItem1
			call this.setIconPath("") /// @todo fixme
			call this.setDescription(tr("Der Jäger Björn möchte ein paar Riesen-Felle, um sie an die Bauern zu verkaufen, jedoch traut er sich nicht, selbst einen Riesen zu töten."))
			call this.setReward(AAbstractQuest.rewardExperience, 500)
			call this.setReward(AAbstractQuest.rewardSkillPoints, 2)
			// item 0
			set questItem = AQuestItem.create(this, tr("Erbeute drei Riesen-Felle."))
			call questItem.setReward(AAbstractQuest.rewardExperience, 200)
			call questItem.setPing(true)
			call questItem.setPingCoordinatesFromRect(gg_rct_spawn_point_giants_0)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			// item 1
			set questItem = AQuestItem.create(this, tr("Bringe die Felle Björn."))
			call questItem.setPing(true)
			call questItem.setPingUnit(gg_unit_n02U_0142)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted1)

			return this
		endmethod
	endstruct

endlibrary
