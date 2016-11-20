library StructMapQuestsQuestCoatsForThePeasants requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestCoatsForThePeasants extends AQuest
		private static constant integer itemTypeId = 'I01Z'

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		public stub method disable takes nothing returns boolean
			return super.disable()
		endmethod

		private static method stateEventCompleted0 takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterAnyUnitEventBJ(whichTrigger,  EVENT_PLAYER_UNIT_PICKUP_ITEM)
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			if (GetTriggerUnit() == questItem.character().unit() and GetItemTypeId(GetManipulatedItem()) == thistype.itemTypeId) then
				call questItem.quest().displayUpdateMessage(Format(tre("%1%/%2% Riesen-Felle", "%1%/2% Giant Furs")).i(questItem.character().inventory().totalItemTypeCharges(thistype.itemTypeId)).i(3).result())

				return questItem.character().inventory().totalItemTypeCharges(thistype.itemTypeId) == 3
			endif

			return false
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Felle für die Bauern", "Furs for the Peasants"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNOgreLord.blp")
			call this.setDescription(tre("Der Jäger Björn möchte ein paar Riesen-Felle, um sie an die Bauern zu verkaufen, jedoch traut er sich nicht, selbst einen Riesen zu töten.", "The hunter Björn wants a few giant furs to sell them to the peasants but he does not dare even to kill a giant."))
			call this.setReward(thistype.rewardExperience, 500)
			call this.setReward(thistype.rewardSkillPoints, 2)
			// item 0
			set questItem = AQuestItem.create(this, tre("Erbeute drei Riesen-Felle.", "Loot three giant furs."))
			call questItem.setReward(thistype.rewardExperience, 200)
			call questItem.setPing(true)
			call questItem.setPingCoordinatesFromRect(gg_rct_spawn_point_giants_0)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			// item 1
			set questItem = AQuestItem.create(this, tre("Bringe die Felle Björn.", "Bring the furs to Björn."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.bjoern())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary
