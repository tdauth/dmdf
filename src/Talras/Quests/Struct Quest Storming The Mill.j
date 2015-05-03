library StructMapQuestsQuestStormingTheMill requires Asl, StructMapMapNpcs, StructMapMapSpawnPoints

	struct QuestStormingTheMill extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(2)
		endmethod
		
		private static method stateEventCompleted0 takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_SELL_ITEM)
		endmethod

		/*
		 * Sheep boy must sell the sheep item to any unit of the character's owner.
		 */
		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			return GetSellingUnit() == Npcs.sheepBoy() and GetOwningPlayer(GetBuyingUnit()) == questItem.character().player() and GetItemTypeId(GetSoldItem()) == 'I04U'
		endmethod
		
		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			call questItem.quest().displayUpdate()
		endmethod

		private static method stateEventCompleted1 takes AQuestItem questItem, trigger whichTrigger returns nothing
			// the units owner might be different due to abilities
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DEATH)
		endmethod

		private static method stateConditionCompleted1 takes AQuestItem questItem returns boolean
			return SpawnPoints.banditsAtGuntrichsMill().countUnits() == 0 and GetUnitTypeId(questItem.character().unit()) == 'H01J' // TODO add unit types for all classes
		endmethod
		
		private static method stateActionCompleted1 takes AQuestItem questItem returns nothing
			call questItem.quest().displayUpdate()
		endmethod
		
		private static method stateActionCompleted takes AQuest whichQuest returns nothing
			// 6 mal Wolle
			call UnitAddItemById(whichQuest.character().unit(), 'I04X')
			call UnitAddItemById(whichQuest.character().unit(), 'I04X')
			call UnitAddItemById(whichQuest.character().unit(), 'I04X')
			call UnitAddItemById(whichQuest.character().unit(), 'I04X')
			call UnitAddItemById(whichQuest.character().unit(), 'I04X')
			call UnitAddItemById(whichQuest.character().unit(), 'I04X')
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tr("Sturm auf die Mühle"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNSheep.blp")
			call this.setDescription(tr("Der Schafsjunge auf dem Mühlberg westlich vom Bauernhof hat den Verstand verloren. Er will, dass die Wegelagerer bei Guntrichs Mühle weiter nördlich auf dem Berg in einem Angriff auf einem Schaf vernichtet werden.
Achtung: Die Wegelagerer müssen vom Schaf herab getötet werden."))
	
			call this.setReward(thistype.rewardExperience, 900)
			call this.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted)
			// item 0
			set questItem = AQuestItem.create(this, tr("Kaufe ein Schaf vom Schafsjungen für einen „Freundschaftspreis“."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.sheepBoy())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// item 1
			set questItem = AQuestItem.create(this, tr("Reite auf dem Schaf in die Schlacht und töte alle Wegelagerer bei der Mühle."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted1)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted1)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted1)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_supply_for_talras_supply_1)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// item 2
			set questItem = AQuestItem.create(this, tr("Berichte dem Schafsjungen davon."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.sheepBoy())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary