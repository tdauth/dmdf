/// Sprung durch die Luft auf bestimmten Punkt. Knockback für alle Einheiten im Umkreis.
library StructSpellsSpellJumpAttack requires Asl

	struct SpellJumpAttack
		public static constant integer abilityId = 'A02Q'
		private static trigger m_castTrigger

		private static method create takes nothing returns SpellJumpAttack
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method triggerCondition takes nothing returns boolean
			return GetSpellAbilityId() == thistype.abilityId
		endmethod

		private static method alightAction takes unit usedUnit returns nothing
			//Knockback
			call SetUnitAnimation(usedUnit, "Attack Slam")
			call ResetUnitAnimation(usedUnit)
		endmethod

		private static method triggerAction takes nothing returns nothing
			local unit caster = GetTriggerUnit()
			local unit target = GetSpellTargetUnit()
			call IssueImmediateOrder(caster, "stop")
			call AJump.create(caster, 800.0, GetUnitX(target), GetUnitY(target), thistype.alightAction, 100.0)
			set caster = null
			set target = null
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_castTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_castTrigger, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
			call TriggerAddCondition(thistype.m_castTrigger, Condition(function thistype.triggerCondition))
			call TriggerAddAction(thistype.m_castTrigger, function thistype.triggerAction)
		endmethod
	endstruct

endlibrary