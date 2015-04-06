library StructMapQuestsQuestTheDragon requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestTheDragon extends AQuest

		implement CharacterQuest

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
			local thistype this = thistype.allocate(character, tr("Der gezähmte Drache"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNGreenDragon.blp")
			call this.setDescription(tr("Ricman hat mir zur Belohnung den „Stab der Unsterblichkeit“ überreicht. Der Legende nach soll man mit diesem Stab einen gezähmten Drachen beschwören können. Ricman hat mich gebeten, den Stab auszuprobieren und ihm davon zu berichten."))
			call this.setReward(AAbstractQuest.rewardExperience, 800)
			// item 0
			set questItem = AQuestItem.create(this, tr("Beschwöre mit Hilfe des „Stabs der Unsterblichkeit“ einen gezähmten Drachen."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.questItem0CompletedEvent)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.questItem0CompletedCondition)
			call questItem.setStateAction(thistype.stateCompleted, thistype.questItem0CompletedAction)
			
			// item 1
			set questItem = AQuestItem.create(this, tr("Berichte Ricman davon."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.ricman())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// item 2
			set questItem = AQuestItem.create(this, tr("Reite auf dem gezähmten Drachen."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.questItem2CompletedEvent)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.questItem2CompletedCondition)
			call questItem.setStateAction(thistype.stateCompleted, thistype.questItem2CompletedAction)
			
			// item 3
			set questItem = AQuestItem.create(this, tr("Berichte Ricman davon."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.ricman())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// item 4
			set questItem = AQuestItem.create(this, tr("Finde den verlassenen Drachenhorst und suche dort nach Dracheneiern."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.questItem4CompletedEvent)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.questItem4CompletedCondition)
			call questItem.setStateAction(thistype.stateCompleted, thistype.questItem4CompletedAction)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_dragon_discover_eggs)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// item 5
			set questItem = AQuestItem.create(this, tr("Bringe die Dracheneier zu Ricman."))
			
			return this
		endmethod
	endstruct

endlibrary