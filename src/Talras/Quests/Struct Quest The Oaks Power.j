library StructMapQuestsQuestTheOaksPower requires Asl

	struct QuestTheOaksPower extends AQuest
		public static constant integer unitTypeId = 'n02Q'
		public static constant integer itemTypeId = 'I01O'
		private static constant integer abilityId = 'A067'

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(0)
		endmethod

		private static method stateActionCompleted takes AQuest whichQuest returns nothing
			call UnitAddItemById(whichQuest.character().unit(), thistype.itemTypeId)
		endmethod

		private static method stateEventCompleted0 takes AQuestItem questItem, trigger whichTrigger returns nothing
			local player owner = Player(PLAYER_NEUTRAL_AGGRESSIVE)
			local event triggerEvent = TriggerRegisterUnitEvent(whichTrigger, questItem.quest().character().unit(), EVENT_UNIT_SPELL_CAST)
			set owner = null
			set triggerEvent = null
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			if (GetSpellAbilityId() == thistype.abilityId) then
				if (GetUnitTypeId(GetSpellTargetUnit()) != thistype.unitTypeId) then
					call questItem.quest().character().displayMessage(ACharacter.messageTypeError, tr("Der Zauber kann nur auf wilde Kreaturen angewandt werden."))
				elseif (questItem.quest().questItem(0).state() == thistype.stateCompleted) then
					call questItem.quest().character().displayMessage(ACharacter.messageTypeError, tr("Sie haben bereits eine Seele eingefangen."))
				else
					return true
				endif
			endif
			return false
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			/// @todo Cast spell
			debug call Print("The Oaks Power unit: " + GetUnitName(GetSpellTargetUnit()))
			call RemoveUnit(GetSpellTargetUnit())
			call questItem.quest().questItem(1).enable()
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tr("Die Kraft der Eiche"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNTreeOfEternity.blp")
			call this.setDescription(tr("Ursula möchte, dass du die Seele einer wilden Kreatur unter einer alten Eiche einfängst und sie ihr bringst, damit sie wilden Kreaturen, die sich seit Neustem bei der Eiche aufhalten verstehen lernen kann. Dazu hat sie dir ein Totem mitgegeben, mit welchem du die Seele einfangen kannst."))
			call this.setStateAction(AAbstractQuest.stateCompleted, thistype.stateActionCompleted)
			call this.setReward(AAbstractQuest.rewardExperience, 500)
			call this.setReward(AAbstractQuest.rewardGold, 300)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Fang die Seele einer der wilden Kreaturen bei der alten Eiche ein."))
			call questItem0.setStateEvent(AAbstractQuest.stateCompleted, thistype.stateEventCompleted0)
			call questItem0.setStateCondition(AAbstractQuest.stateCompleted, thistype.stateConditionCompleted0)
			call questItem0.setStateAction(AAbstractQuest.stateCompleted, thistype.stateActionCompleted0)
			call questItem0.setPing(true)
			call questItem0.setPingCoordinatesFromRect(gg_rct_quest_the_oaks_power_quest_item_0)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem1 = AQuestItem.create(this, tr("Bring die eingefangene Seele zu Ursula."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(gg_unit_n01U_0203)
			call questItem1.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

	endstruct

endlibrary