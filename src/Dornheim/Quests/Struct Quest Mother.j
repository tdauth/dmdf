library StructMapQuestsQuestMother requires Asl, Game, StructMapMapNpcs

	struct QuestMother extends AQuest
		public static constant integer questItemTalk = 0
		public static constant integer questItemGoods = 1
		public static constant integer questItemBring = 2
		public static constant integer questItemGotlinde = 3
		public static constant integer maxBread = 3
		public static constant integer maxApples = 4
		private trigger m_hintTriggerHans

		private static method onAddItemToBackpackFood takes AUnitInventory inventory, integer index, boolean firstTime returns nothing
			local thistype this = thistype.characterQuest.evaluate(ACharacterInventory(inventory).character())
			local integer breadCount = 0
			local integer applesCount = 0
			if (this.questItem(thistype.questItemGoods).isNew()) then
				if (firstTime and inventory.backpackItemData(index) != 0 and (inventory.backpackItemData(index).itemTypeId() == 'I016' or inventory.backpackItemData(index).itemTypeId() == 'I03O')) then
					set breadCount = this.character().inventory().totalItemTypeCharges('I016')
					set applesCount = this.character().inventory().totalItemTypeCharges('I03O')

					call this.displayUpdateMessage(Format(tre("%1% von %2% Brotlaiben. %3% von %4% Äpfeln.", "%1% of %2% loafs of bread. %3% of %4% of apples.")).i(breadCount).i(thistype.maxBread).i(applesCount).i(thistype.maxApples).result())

					if (breadCount >= thistype.maxBread and applesCount >= thistype.maxApples) then
						call this.questItem(thistype.questItemGoods).setState(thistype.stateCompleted)
					endif
				endif
			endif
		endmethod

		public stub method enable takes nothing returns boolean
			local Character character = Character(this.character())
			// TODO add mission ability
			//call character.options().missions().addMission('A1R8', 'A1RK', this)

			call character.inventory().addOnAddToBackpackFunction(thistype.onAddItemToBackpackFood)

			return super.enableUntil(thistype.questItemTalk)
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
				call character.displayHint(tre("Klicken Sie mit Links auf den Laden um die Waren zu kaufen. Falls Sie nicht genügend Goldmünzen haben sollten, können Sie Kräuter in der Umgebung sammeln und bei Hans verkaufen. Die Kräuter wachsen nach einiger Zeit nach.", "Click on the shop with the left mouse button to buy the goods. If you do not have enough gold coins, you can collect herbs in the area and sell them to Hans. THe herbs regrow after some time."))

				call DisableTrigger(GetTriggeringTrigger())
			endif

			return false
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Mutter", "Mother"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNVillagerWoman.blp")
			call this.setDescription(tre("Mutter will noch mit mir sprechen, bevor ich aufbreche.", "Mother wants to talk to me before I start off."))
			call this.setReward(thistype.rewardExperience, 50)
			// item 0
			set questItem = AQuestItem.create(this, tre("Sprich mit Mutter.", "Talk to mother."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.mother())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			// item 1
			set questItem = AQuestItem.create(this, tre("Besorge drei Laibe Brot und vier Äpfel von Hans.", "Get three loafs of bread and four apples from Hans."))
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedFood)
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.hans())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			// item 2
			set questItem = AQuestItem.create(this, tre("Bringe die Waren zu Mutter.", "Bring the goods to mother."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.mother())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			// item 3
			set questItem = AQuestItem.create(this, tre("Sage Gotlinde Lebwohl.", "Say Farewell to Gotlinde."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.gotlinde())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			set this.m_hintTriggerHans = CreateTrigger()
			call TriggerRegisterEnterRectSimple(this.m_hintTriggerHans, gg_rct_quest_mother_hans)
			call TriggerAddCondition(this.m_hintTriggerHans, Condition(function thistype.triggerConditionHintHans))
			call DmdfHashTable.global().setHandleInteger(this.m_hintTriggerHans, 0, this)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary