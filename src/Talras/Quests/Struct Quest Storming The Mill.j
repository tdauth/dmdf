library StructMapQuestsQuestStormingTheMill requires Asl, StructGameCharacter, StructMapMapNpcs, StructMapMapSpawnPoints

	struct QuestStormingTheMill extends AQuest

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

		private static method unitLives takes unit whichUnit returns boolean
			return not IsUnitDeadBJ(whichUnit)
		endmethod

		private static method stateConditionCompleted1 takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local Character character = Character(this.character())
			local integer unitTypeId = GetUnitTypeId(character.unit())
			local integer count = 0
			debug call Print("Quest storming the mill: Kill!")
			debug if SpawnPoints.banditsAtGuntrichsMill().contains(GetTriggerUnit()) then // TODO is not true!!! Maybe because he died already?
				debug call Print("Belongs to bandits.")
			debug endif
			debug if GetDistanceBetweenUnitsWithoutZ(GetTriggerUnit(), character.unit()) <= 1800.0 then
				debug call Print("Is in distance.")
			debug endif
			debug if (unitTypeId == 'H01K' or unitTypeId == 'H01J' or unitTypeId == 'H01P' or unitTypeId == 'H01Q' or unitTypeId == 'H01W' or unitTypeId == 'H01V' or unitTypeId == 'H01M' or unitTypeId == 'H01L' or unitTypeId == 'H01O' or unitTypeId == 'H01N' or unitTypeId == 'H01S' or unitTypeId == 'H01R' or unitTypeId == 'H01U' or unitTypeId == 'H01T' or unitTypeId == 'H01Y' or unitTypeId == 'H01X') then
				debug call Print("Character is on sheep.")
			debug endif
			// the character does not need to be the killing unit, it is enough when he is on a sheep and near the killing
			if (SpawnPoints.banditsAtGuntrichsMill().contains(GetTriggerUnit()) and GetDistanceBetweenUnitsWithoutZ(GetTriggerUnit(), character.unit()) <= 1800.0) then
				if (unitTypeId == 'H01K' or unitTypeId == 'H01J' or unitTypeId == 'H01P' or unitTypeId == 'H01Q' or unitTypeId == 'H01W' or unitTypeId == 'H01V' or unitTypeId == 'H01M' or unitTypeId == 'H01L' or unitTypeId == 'H01O' or unitTypeId == 'H01N' or unitTypeId == 'H01S' or unitTypeId == 'H01R' or unitTypeId == 'H01U' or unitTypeId == 'H01T' or unitTypeId == 'H01Y' or unitTypeId == 'H01X') then
					set count = SpawnPoints.banditsAtGuntrichsMill().countUnitsIf(thistype.unitLives)
					call this.displayUpdateMessage(Format(tre("%1%/%2% Wegelagerer", "%1%/%2% Highwaymen")).i(SpawnPoints.banditsAtGuntrichsMill().countMembers() - count).i(SpawnPoints.banditsAtGuntrichsMill().countMembers()).result())

					return count == 0
				else
					call this.displayUpdateMessage(tre("Sie müssen die Wegelagerer von einem Schaf aus töten.", "You have to kill the highwaymen from a sheep."))
				endif
			endif

			return false
		endmethod

		private static method stateActionCompleted1 takes AQuestItem questItem returns nothing
			call questItem.quest().displayState()
		endmethod

		private static method stateActionCompleted takes AQuest whichQuest returns nothing
			local Character character = Character(whichQuest.character())
			// 6 mal Wolle
			call character.giveItem('I04X')
			call character.giveItem('I04X')
			call character.giveItem('I04X')
			call character.giveItem('I04X')
			call character.giveItem('I04X')
			call character.giveItem('I04X')
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Sturm auf die Mühle", "Storm on the Mill"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNSheep.blp")
			call this.setDescription(tre("Der Schafshirte auf dem Mühlberg westlich vom Bauernhof hat den Verstand verloren. Er will, dass die Wegelagerer bei Guntrichs Mühle weiter nördlich auf dem Berg in einem Angriff auf einem Schaf vernichtet werden.
Achtung: Die Wegelagerer müssen vom Schaf herab getötet werden.", "The shepherd on the mill hill west of the farm has gone mad. He wants that the brigands at Guntrich's mill further north on the hill will be destroyed during an attack on a sheep. Warning: The brigands have to be killed from a sheep."))

			call this.setReward(thistype.rewardExperience, 450)
			call this.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted)
			// item 0
			set questItem = AQuestItem.create(this, tre("Kaufe ein Schaf vom Schafshirten für einen „Freundschaftspreis“.", "Buy a sheep from the shepherd for a \"friendship price\"."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.sheepBoy())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 1
			set questItem = AQuestItem.create(this, tre("Reite auf dem Schaf in die Schlacht und töte alle Wegelagerer bei der Mühle.", "Ride on the sheep into the battle and kill all highwaymen at the mill."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted1)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted1)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted1)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_supply_for_talras_supply_1)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 2
			set questItem = AQuestItem.create(this, tre("Berichte dem Schafshirten davon.", "Report to the shepherd about it."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.sheepBoy())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary