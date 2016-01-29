library StructMapQuestsQuestTheOaksPower requires Asl, StructGameCharacter

	struct QuestTheOaksPower extends AQuest
		public static constant integer unitTypeId = 'n02Q'
		public static constant integer itemTypeId = 'I01O'
		public static constant integer rewardItemTypeId = 'I05D'
		private static constant integer abilityId = 'A067'

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(0)
		endmethod

		private static method stateActionCompleted takes AQuest whichQuest returns nothing
			local Character charater = Character(whichQuest.character())
			call charater.giveItem(thistype.rewardItemTypeId)
			call Character(whichQuest.character()).displayItemAcquired(tre("Ursulas Totem", "Ursula's Totem"), tre("Beschwört eine wilde Kreatur.", "Summons a wild creature."))
		endmethod

		private static method stateEventCompleted0 takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_SPELL_CAST)
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			if (GetTriggerUnit() == questItem.character().unit() and GetSpellAbilityId() == thistype.abilityId) then
				if (GetUnitTypeId(GetSpellTargetUnit()) != thistype.unitTypeId) then
					call questItem.quest().character().displayMessage(ACharacter.messageTypeError, tre("Der Zauber kann nur auf wilde Kreaturen angewandt werden.", "The spell can only be applied to wild creatures."))
				elseif (questItem.quest().questItem(0).state() == thistype.stateCompleted) then
					call questItem.quest().character().displayMessage(ACharacter.messageTypeError, tre("Sie haben bereits eine Seele eingefangen.", "You have already captured a soul."))
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
			local thistype this = thistype.allocate(character, tre("Die Kraft der Eiche", "The Power of the Oak"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNTreeOfEternity.blp")
			call this.setDescription(tre("Ursula möchte, dass du die Seele einer wilden Kreatur unter einer alten Eiche einfängst und sie ihr bringst, damit sie die wilden Kreaturen, die sich seit Neustem bei der Eiche aufhalten verstehen lernen kann. Dazu hat sie dir ein Totem mitgegeben, mit welchem du die Seele einfangen kannst.", "Ursula wants you to capture the soul of a wild creature under an old oak tree and to bring it to her, so that she can learn to understand the wild creatures which reside most recently near to the oak. For this purpose she has given you a totem with which you can capture the soul."))
			call this.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted)
			call this.setReward(thistype.rewardExperience, 500)
			call this.setReward(thistype.rewardGold, 300)
			// item 0
			set questItem0 = AQuestItem.create(this, tre("Fange die Seele einer der wilden Kreaturen bei der alten Eiche ein.", "Catch the soul of a wild creature at the old oak."))
			call questItem0.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem0.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem0.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			call questItem0.setPing(true)
			call questItem0.setPingCoordinatesFromRect(gg_rct_quest_the_oaks_power_quest_item_0)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem1 = AQuestItem.create(this, tre("Bringe die eingefangene Seele zu Ursula.", "Bring the catched soul to Ursula."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(gg_unit_n01U_0203)
			call questItem1.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

	endstruct

endlibrary