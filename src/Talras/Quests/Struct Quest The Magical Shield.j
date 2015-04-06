library StructMapQuestsQuestTheMagicalShield requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestTheMagicalShield extends AQuest
		public static constant integer shieldItemTypeId = 'I042'
		public static constant integer arrowsItemTypeId = 'I043'
		private boolean m_shieldEnabled
		private effect m_shieldEffect

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			call Character(this.character()).giveQuestItem(thistype.shieldItemTypeId)
			call Character(this.character()).giveQuestItem(thistype.arrowsItemTypeId)
			return super.enableUntil(0)
		endmethod
		
		private static method stateEventCompleted0 takes AQuestItem questItem, trigger usedTrigger returns nothing
			call TriggerRegisterUnitEvent(usedTrigger, questItem.character().unit(), EVENT_UNIT_USE_ITEM)
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			if (GetItemTypeId(GetManipulatedItem()) == thistype.shieldItemTypeId) then
				if (not this.m_shieldEnabled) then
					set this.m_shieldEnabled = true
					set this.m_shieldEffect = AddSpecialEffectTarget("war3mapImported\\SlowTime.mdx", GetTriggerUnit(), "chest")
				endif
			elseif (GetItemTypeId(GetManipulatedItem()) == thistype.arrowsItemTypeId) then
				// TODO use arrow effect
				call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Demon\\RainOfFire\\RainOfFireTarget.mdl", GetTriggerUnit(), "overhead"))
				if (this.m_shieldEnabled) then
					call DestroyEffect(this.m_shieldEffect)
					set this.m_shieldEffect = null
					return true
				else
					call UnitDamageTargetBJ(GetTriggerUnit(), GetTriggerUnit(), 5000.0, ATTACK_TYPE_PIERCE, DAMAGE_TYPE_NORMAL)
				endif
			endif
			
			return false
		endmethod
		
		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			call questItem.quest().questItem(1).enable()
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tr("Der magische Schild"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNCurb.blp")
			call this.setDescription(tr("Sisgard hat einen Zauberspruch kreiert, der einen magischen Schild erschaffen soll, welcher den Zaubernden vor Pfeilen schützt. Da sie den Zauber nicht selbst ausprobieren will, hat sie dir zwei Zauberspruchrollen gegeben, um dich darum zu kümmern."))
			call this.setReward(AAbstractQuest.rewardExperience, 500)
			// item 0
			set questItem = AQuestItem.create(this, tr("Beschwöre den magischen Schild und die Pfeile."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			// item 1
			set questItem = AQuestItem.create(this, tr("Berichte Sisgard von deinem Erfolg."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.sisgard())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary