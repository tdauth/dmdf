library StructMapQuestsQuestShitOnTheThrone requires Asl, Game, StructMapMapNpcs

	struct QuestShitOnTheThrone extends AQuest
		public static constant integer questItemPlaceShit = 0
		public static constant integer questItemTalkToWotan = 1
		public static constant integer questItemReport = 2

		public stub method enable takes nothing returns boolean
			local Character character = Character(this.character())
			call character.giveQuestItem('I03Q')
			// TODO Add ability for the mission.
			//call character.options().missions().addMission('A1R8', 'A1RK', this)
			return super.enableUntil(thistype.questItemReport)
		endmethod

		private static method stateEventCompletedPlaceShit takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_shit_on_the_throne_throne)
		endmethod

		private static method stateConditionCompletedPlaceShit takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local Character character = Character(this.character())
			return GetTriggerUnit() == this.character().unit() and character.inventory().totalItemTypeCharges('I03Q') >= 1
		endmethod

		private static method stateActionCompletedPlaceShit takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			local Character character = Character(this.character())
			call character.inventory().removeItemType('I03Q')
			call this.displayState()
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Scheiße auf dem Thron", "Shit on the Throne"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNShit.blp")
			call this.setDescription(tre("Ralph will es Wotan dem irren Dorfältesten heimzahlen. Er hat einen Beutel vollgeschissen, den du auf Wotans Thron platzieren sollst, damit die Überraschung möglichst groß ist.", "Ralph wants pay it back Wotan the village elders. He shitted into a bag which you have to place on Wotan's throne that the surprise is as big as possible."))
			call this.setReward(thistype.rewardExperience, 40)
			// item 0
			set questItem = AQuestItem.create(this, tre("Platziere den mit Scheiße gefüllten Lederbeutel auf dem Thron.", "Place the leather bag filled with shit on the throne."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedPlaceShit)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedPlaceShit)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedPlaceShit)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_shit_on_the_throne_throne)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			// item 1
			set questItem = AQuestItem.create(this, tre("Sprich mit Wotan, dem Dorfältesten.", "Talk to Wotan the village elders."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.wotan())
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