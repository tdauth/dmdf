library StructMapQuestsQuestBurnTheBearsDown requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestBurnTheBearsDown extends AQuest
		public static constant integer maxWood = 5
		public static constant integer itemTypeIdScroll = 'I00R'
		public static constant integer itemTypeIdPotion = 'I01F'
		public static constant integer itemTypeIdWood = 'I02P'
		public static constant integer itemTypeIdDagger = 'I02O'
		public static constant integer xpBonus = 100
		private trigger m_pickupTrigger

		public stub method enable takes nothing returns boolean
			call EnableTrigger(this.m_pickupTrigger)
			return super.enableUntil(0)
		endmethod

		public stub method onStateAction takes integer state returns nothing
			//call super.onStateAction(state)
			// TODO vJass bug, warning we cannot use any state action for the quest itself!
			if (state == thistype.stateCompleted or state == thistype.stateFailed) then
				call DisableTrigger(this.m_pickupTrigger)
			endif
		endmethod

		/**
		 * Wenn der Charakter die Gegenstände verliert/verkauft/zerstört macht das nichts.
		 * Im Gespräch wird nochmal überprüft, ob er ihn dabei hat.
		 * Ziel 1 und 2 werden nur einmal aktiviert.
		 */
		private static method triggerConditionPickup takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local integer count = 0
			local boolean completed = false
			local boolean new = false
			if (GetTriggerUnit() == this.character().unit()) then
				if ((GetItemTypeId(GetManipulatedItem()) == thistype.itemTypeIdScroll or GetItemTypeId(GetManipulatedItem()) == thistype.itemTypeIdPotion) and this.questItem(1).isNotUsed()) then
					if (this.questItem(0).isNew()) then
						call this.questItem(0).setState(thistype.stateCompleted)
					endif
					call this.questItem(1).setState(thistype.stateNew)
					call this.displayUpdate()
				elseif (GetItemTypeId(GetManipulatedItem()) == thistype.itemTypeIdWood) then
					if (this.questItem(0).isNew()) then
						call this.questItem(0).setState(thistype.stateCompleted)
						set completed = true
					endif
					if (this.questItem(2).isNotUsed()) then
						call this.questItem(2).setState(thistype.stateNew)
						set new = true
					endif
					if (new or completed) then
						call this.displayUpdate()
					endif
					set count = this.character().inventory().totalItemTypeCharges(thistype.itemTypeIdWood)
					if (count <= thistype.maxWood or new) then
						call this.displayUpdateMessage(Format(tre("%1% von %2% Holzbrettern.", "%1% of %2% wooden boards.")).i(count).i(thistype.maxWood).result())
					endif
				endif
			endif
			return false
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Brennt die Bären nieder!", "Burn Down the Bears!"))
			local AQuestItem questItem = 0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNLiquidFire.blp")
			call this.setDescription(tre("Dago, der Jäger, möchte gerne in der Bärenhöhle Feuer legen, um die dort verbliebenen Bären zu töten. Allerdings benötigt er dafür entsprechende Mittel.", "Dago the hunter would like to set fire in the bear cave to kill the remaining bears there. However he needs the corresponding resources."))
			call this.setReward(thistype.rewardExperience, 500)
			call this.setReward(thistype.rewardGold, 200)
			// item 0
			set questItem = AQuestItem.create(this, tre("Suche entweder nach Holz oder einem Zauberspruch, mit welchem Dago Feuer legen kann.", "Search either for wood or for a spell which can be used by Dago to set fire."))
			// item 1
			set questItem = AQuestItem.create(this, tre("Bringe den Zauberspruch zu Dago.", "Bring the spell to Dago."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.dago())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// item 2
			set questItem = AQuestItem.create(this, tre("Bringe das Holz zu Dago.", "Bring the wood to Dago."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.dago())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			set this.m_pickupTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_pickupTrigger, EVENT_PLAYER_UNIT_PICKUP_ITEM)
			call TriggerAddCondition(this.m_pickupTrigger, Condition(function thistype.triggerConditionPickup))
			call DmdfHashTable.global().setHandleInteger(this.m_pickupTrigger, 0, this)
			call DisableTrigger(this.m_pickupTrigger)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_pickupTrigger)
			set this.m_pickupTrigger = null
		endmethod

		implement CharacterQuest
	endstruct

endlibrary
