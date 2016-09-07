library StructMapSpellsSpellOpenGate requires Asl

	struct SpellOpenGate
		private static trigger m_castTrigger

		private static method triggerCondition takes nothing returns boolean
			if (GetSpellAbilityId() == 'A18G') then
				if (GetUnitUserData(GetTriggerUnit()) == 0) then
					debug call Print("Open " + GetUnitName(GetTriggerUnit()))
					call SetUnitUserData(GetTriggerUnit(), 1)
					call SetUnitPathing(GetTriggerUnit(), false)
					call SetUnitAnimation(GetTriggerUnit(), "death alternate")
				else
					debug call Print("Close " + GetUnitName(GetTriggerUnit()))
					call SetUnitUserData(GetTriggerUnit(), 0)
					call SetUnitPathing(GetTriggerUnit(), true)
					call SetUnitAnimation(GetTriggerUnit(), "stand")
				endif
			endif

			return false
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.m_castTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_castTrigger, EVENT_PLAYER_UNIT_SPELL_CAST)
			call TriggerAddCondition(thistype.m_castTrigger, Condition(function thistype.triggerCondition))
		endmethod
	endstruct

endlibrary