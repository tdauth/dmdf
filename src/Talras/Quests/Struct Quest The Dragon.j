library StructMapQuestsQuestTheDragon requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestTheDragon extends AQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(1)
		endmethod

		private static method questItem0CompletedEvent takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterPlayerUnitEvent(whichTrigger, questItem.character().player(), EVENT_PLAYER_UNIT_SUMMON, null)
		endmethod

		private static method questItem0CompletedCondition takes AQuestItem questItem returns boolean
			return GetSummoningUnit() == questItem.character().unit() and (GetUnitTypeId(GetSummonedUnit()) == 'n01L' or GetUnitTypeId(GetSummonedUnit()) == 'n01M')
		endmethod

		private static method questItem0CompletedAction takes AQuestItem questItem returns nothing
			call questItem.quest().displayUpdate()
		endmethod

		private static method questItem2CompletedEvent takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterPlayerUnitEvent(whichTrigger, questItem.quest().character().player(), EVENT_PLAYER_UNIT_LOADED, null)
		endmethod

		private static method questItem2CompletedCondition takes AQuestItem questItem returns boolean
			return GetLoadedUnit() == questItem.character().unit() and (GetUnitTypeId(GetTransportUnit()) == 'n01L' or GetUnitTypeId(GetTransportUnit()) == 'n01M')
		endmethod

		private static method questItem2CompletedAction takes AQuestItem questItem returns nothing
			call questItem.quest().displayUpdate()
		endmethod

		private static method questItem4CompletedEvent takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_the_dragon_discover_eggs)
		endmethod

		private static method questItem4CompletedCondition takes AQuestItem questItem returns boolean
			return GetTriggerUnit() == questItem.character().unit()
		endmethod

		private static method questItem4CompletedAction takes AQuestItem questItem returns nothing
			call questItem.quest().questItem(5).setState(thistype.stateNew)
			call questItem.quest().displayUpdate()
			call Character(questItem.character()).giveQuestItem('I03Z')
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Der gezähmte Drache", "The Tamed Dragon"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNGreenDragon.blp")
			call this.setDescription(tre("Ricman hat mir zur Belohnung den „Stab der Unsterblichkeit“ überreicht. Der Legende nach soll man mit diesem Stab einen gezähmten Drachen beschwören können. Ricman hat mich gebeten, den Stab auszuprobieren und ihm davon zu berichten.", "Ricman gave me as a reward the \"Staff of Immortality\". According to the legend one should be able to summon a dragon with this staff. Ricman asked me to try out the staff and tell him about it."))
			call this.setReward(thistype.rewardExperience, 800)
			// item 0
			set questItem = AQuestItem.create(this, tre("Beschwöre mit Hilfe des „Stabs der Unsterblichkeit“ einen gezähmten Drachen.", "Summon a tamed dragon using the \"Staff of Immortality\"."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.questItem0CompletedEvent)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.questItem0CompletedCondition)
			call questItem.setStateAction(thistype.stateCompleted, thistype.questItem0CompletedAction)

			// item 1
			set questItem = AQuestItem.create(this, tre("Berichte Ricman davon.", "Report to Ricman thereof."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.ricman())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 2
			set questItem = AQuestItem.create(this, tre("Reite auf dem gezähmten Drachen.", "Ride on the tamed dragon."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.questItem2CompletedEvent)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.questItem2CompletedCondition)
			call questItem.setStateAction(thistype.stateCompleted, thistype.questItem2CompletedAction)

			// item 3
			set questItem = AQuestItem.create(this, tre("Berichte Ricman davon.", "Report to Ricman thereof."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.ricman())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 4
			set questItem = AQuestItem.create(this, tre("Finde den verlassenen Drachenhorst und suche dort nach Dracheneiern.", "Find the abandoned dragon nest and search there for the dragon eggs."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.questItem4CompletedEvent)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.questItem4CompletedCondition)
			call questItem.setStateAction(thistype.stateCompleted, thistype.questItem4CompletedAction)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_dragon_discover_eggs)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 5
			set questItem = AQuestItem.create(this, tre("Bringe die Dracheneier zu Ricman.", "Bring the dragon eggs to Ricman."))

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary