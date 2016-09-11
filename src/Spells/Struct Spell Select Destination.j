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
			call WaygateSetDestination(GetTriggerUnit(), GetSpellTargetX(), GetSpellTargetY())
			if (not WaygateIsActive(GetTriggerUnit())) then
				call WaygateActivate(GetTriggerUnit(), true)
			endif
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_spellTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_spellTrigger, EVENT_PLAYER_UNIT_SPELL_CAST)
			call TriggerAddCondition(thistype.m_spellTrigger, Condition(function thistype.triggerConditionSpell))
			call TriggerAddAction(thistype.m_spellTrigger, function thistype.triggerActionSpell)
		endmethod
	endstruct

endlibrary