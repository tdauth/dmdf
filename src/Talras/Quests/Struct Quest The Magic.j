library StructMapQuestsQuestTheMagic requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestTheMagic extends AQuest
		public static constant integer itemTypeId = 'I00Z'
		private trigger m_hintTrigger

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			call Character(this.character()).giveQuestItem(thistype.itemTypeId)
			call EnableTrigger(this.m_hintTrigger)
			return super.enableUntil(0)
		endmethod

		private static method stateEvent0 takes AQuestItem questItem, trigger usedTrigger returns nothing
			call TriggerRegisterAnyUnitEventBJ(usedTrigger, EVENT_PLAYER_UNIT_USE_ITEM)
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			local item manipulatedItem = GetManipulatedItem()
			local unit triggerUnit = GetTriggerUnit()
			local boolean result = triggerUnit == questItem.character().unit() and GetItemTypeId(manipulatedItem) == thistype.itemTypeId and RectContainsUnit(gg_rct_weather_rune_circle, triggerUnit)
			set manipulatedItem = null
			set triggerUnit = null
			return result
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call DmdfHashTable.global().destroyTrigger(this.m_hintTrigger)
			set this.m_hintTrigger = null
			call this.displayUpdateMessage(tre("Es passiert nichts ...", "Nothing happens ..."))
			call this.questItem(1).enable()
		endmethod
		
		private static method triggerConditionHint takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			if (GetTriggerUnit() == this.character().unit()) then
				call this.displayUpdateMessage(tre("Runensteinkreis gefunden.", "Found runic stone circle."))
			endif
			return false
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Die Zauberkunst", "The Sorcery"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNSnazzyScroll.blp")
			call this.setDescription(tre("Sisgard, die Zauberin, möchte, dass du ihr beweist, dass du der Zauberkunst mächtig bist. Vorher ist sie nicht bereit mit dir umher zu ziehen. Dazu hat sie dir eine Zauberspruchrolle mitgegeben, welche du in einem Runensteinkreis im Dunkelwald benutzen sollst.", "SIsgard, the sorceress, wants you to prove to her that you're able to use magic. Before that she is not ready to go with you around. For this purpose she has given you a scroll which you should use in a rune stone circle in the Dark Forest."))
			call this.setReward(AAbstractQuest.rewardExperience, 500)
			// item 0
			set questItem0 = AQuestItem.create(this, tre("Suche nach dem Runensteinkreis und benutze dort die Zauberspruchrolle.", "Search for the runic stone circle and use the scroll there."))
			call questItem0.setStateEvent(AAbstractQuest.stateCompleted, thistype.stateEvent0)
			call questItem0.setStateCondition(AAbstractQuest.stateCompleted, thistype.stateConditionCompleted0)
			call questItem0.setStateAction(AAbstractQuest.stateCompleted, thistype.stateActionCompleted0)
			call questItem0.setPing(true)
			call questItem0.setPingCoordinatesFromRect(gg_rct_weather_rune_circle)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem1 = AQuestItem.create(this, tre("Berichte Sisgard davon.", "Report to Sigard about it."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(Npcs.sisgard())
			call questItem1.setPingColour(100.0, 100.0, 100.0)
			//call questItem1.setState(AAbstractQuest.stateNew)
			
			set this.m_hintTrigger = CreateTrigger()
			call TriggerRegisterEnterRectSimple(this.m_hintTrigger, gg_rct_weather_rune_circle)
			call TriggerAddCondition(this.m_hintTrigger, Condition(function thistype.triggerConditionHint))
			call DmdfHashTable.global().setHandleInteger(this.m_hintTrigger, 0, this)
			call DisableTrigger(this.m_hintTrigger)
			
			return this
		endmethod
	endstruct

endlibrary