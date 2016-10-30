library StructMapQuestsQuestMother requires Asl, Game, StructMapMapNpcs

	struct QuestMother extends AQuest
		public static constant integer questItemTalk = 0
		public static constant integer questItemGoods = 1
		public static constant integer questItemBring = 2
		public static constant integer questItemGotlinde = 3
		private trigger m_hintTriggerHans

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			local Character character = Character(this.character())
			//call character.giveQuestItem(thistype.itemTypeId)
			//call character.options().missions().addMission('A1R8', 'A1RK', this)
			return super.enableUntil(thistype.questItemTalk)
		endmethod

		private static method stateEventCompletedFood takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_PICKUP_ITEM)
		endmethod

		/**
		 * Wenn der Charakter die Gegenstände verliert/verkauft/zerstört macht das nichts.
		 * Im Gespräch wird nochmal überprüft, ob er ihn dabei hat.
		 */
		private static method stateConditionCompletedFood takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local integer count0 = 0
			local integer count1 = 0
			if (GetTriggerUnit() == this.character().unit() and (GetItemTypeId(GetManipulatedItem()) == 'I016' or GetItemTypeId(GetManipulatedItem()) == 'I03O')) then
				set count0 = this.character().inventory().totalItemTypeCharges('I016')
				set count1 = this.character().inventory().totalItemTypeCharges('I03O')

				call this.displayUpdateMessage(Format(tre("%1% von %2% Brotlaiben. %3% von %4% Äpfeln.", "%1% of %2% loafs of bread. %3% of %4% of apples.")).i(count0).i(3).i(count1).i(4).result())

				if (count0 >= 3 and count1 >= 4) then
					return true
				endif
			endif
			return false
		endmethod

		private static method stateActionCompletedFood takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.questItem(thistype.questItemBring).setState(thistype.stateNew)
			call this.displayState()
		endmethod

		private static method triggerConditionHintHans takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			local Character character = Character(this.character())

			if (this.questItem(thistype.questItemGoods).isNew()) then
				// TODO narrator please.
				call character.displayHint(tr("Klicken Sie mit Links auf den Laden um die Waren zu kaufen. Falls Sie nicht genügend Goldmünzen haben sollten, können Sie Kräuter in der Umgebung sammeln und bei Hans verkaufen. Die Kräuter wachsen nach einiger Zeit nach."))

				call DisableTrigger(GetTriggeringTrigger())
			endif

			return false
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Mutter", "Mother"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNVillagerWoman.blp")
			call this.setDescription(tre("Mutter will noch mit mir sprechen, bevor ich aufbreche.", "Mother wants to talk to me before I start off."))
			call this.setReward(thistype.rewardExperience, 200)
			// item 0
			set questItem = AQuestItem.create(this, tre("Sprich mit Mutter.", "Talk to mother."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.mother())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 50)

			// item 1
			set questItem = AQuestItem.create(this, tre("Besorge drei Laibe Brot und vier Äpfel von Hans.", "Get three loafs of bread and four apples from Hans."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedFood)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedFood)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedFood)
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.hans())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 50)

			// item 2
			set questItem = AQuestItem.create(this, tre("Bringe die Waren zu Mutter.", "Bring the goods to mother."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.mother())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 50)

			// item 3
			set questItem = AQuestItem.create(this, tre("Sage Gotlinde Lebwohl.", "Say Farewell to Gotlinde."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.gotlinde())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 50)

			set this.m_hintTriggerHans = CreateTrigger()
			call TriggerRegisterEnterRectSimple(this.m_hintTriggerHans, gg_rct_quest_mother_hans)
			call TriggerAddCondition(this.m_hintTriggerHans, Condition(function thistype.triggerConditionHintHans))
			call DmdfHashTable.global().setHandleInteger(this.m_hintTriggerHans, 0, this)

			return this
		endmethod
	endstruct

endlibrary