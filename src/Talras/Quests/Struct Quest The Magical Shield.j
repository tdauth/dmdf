library StructMapQuestsQuestTheMagicalShield requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestTheMagicalShield extends AQuest
		public static constant integer shieldItemTypeId = 'I042'
		public static constant integer arrowsItemTypeId = 'I043'
		private boolean m_shieldEnabled
		private effect m_shieldEffect

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
					set this.m_shieldEffect = AddSpecialEffectTarget("Abilities\\ForceFieldNocolour\\FieldBASE.mdx", GetTriggerUnit(), "chest")
				endif
			elseif (GetItemTypeId(GetManipulatedItem()) == thistype.arrowsItemTypeId) then
				call DestroyEffect(AddSpecialEffectTarget("Abilities\\ArrowVolley\\ArrowVolleyV2.MDX", GetTriggerUnit(), "overhead"))
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
			local thistype this = thistype.allocate(character, tre("Der magische Schild", "The Magical Shield"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNCurb.blp")
			call this.setDescription(tre("Sisgard hat einen Zauberspruch kreiert, der einen magischen Schild erschaffen soll, welcher den Zaubernden vor Pfeilen schützt. Da sie den Zauber nicht selbst ausprobieren will, hat sie dir zwei Zauberspruchrollen gegeben, um dich darum zu kümmern.", "Sisgard has crafted a spell which should create a magical shield which protects the caster from arrows. Sinceshe does not want to try out the spell for herself, she gave you two scrolls to take care of it."))
			call this.setReward(thistype.rewardExperience, 500)
			// item 0
			set questItem = AQuestItem.create(this, tre("Beschwöre den magischen Schild und die Pfeile.", "Summon a magical shield and the arrows."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			// item 1
			set questItem = AQuestItem.create(this, tre("Berichte Sisgard von deinem Erfolg.", "Report to Sisgard about your success."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.sisgard())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary