/// Waygate
library StructSpellsSpellSelectDestination requires Asl

	struct SpellSelectDestination
		public static constant integer abilityId = 'A04H'
		private static trigger m_spellTrigger

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method triggerConditionSpell takes nothing returns boolean
			return GetSpellAbilityId() == thistype.abilityId
		endmethod

		private static method triggerActionSpell takes nothing returns nothing
			local unit triggerUnit = GetTriggerUnit()
			call WaygateSetDestination(triggerUnit, GetSpellTargetX(), GetSpellTargetY())
			if (not WaygateIsActive(triggerUnit)) then
				call WaygateActivate(triggerUnit, true)
			endif
			set triggerUnit = null
		endmethod

		public static method init takes nothing returns nothing
			local conditionfunc conditionFunction
			local triggercondition triggerCondition
			local triggeraction triggerAction
			set thistype.m_spellTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_spellTrigger, EVENT_PLAYER_UNIT_SPELL_CAST)
			set conditionFunction = Condition(function thistype.triggerConditionSpell)
			set triggerCondition = TriggerAddCondition(thistype.m_spellTrigger, conditionFunction)
			set triggerAction = TriggerAddAction(thistype.m_spellTrigger, function thistype.triggerActionSpell)
			set conditionFunction = null
			set triggerCondition = null
			set triggerAction = null
		endmethod
	endstruct

endlibrary