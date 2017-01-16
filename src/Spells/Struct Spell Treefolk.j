/// Druid
library StructSpellsSpellTreefolk requires Asl, StructGameClasses, StructGameSpell

	struct SpellTreefolk extends Spell
		public static constant integer abilityId = 'A0E1'
		public static constant integer favouriteAbilityId = 'A0B7'
		public static constant integer classSelectionAbilityId = 'A1OH'
		public static constant integer classSelectionGrimoireAbilityId = 'A1OI'
		public static constant integer maxLevel = 5
		private static trigger m_summonTrigger

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)

			call this.addGrimoireEntry('A1OH', 'A1OI')
			call this.addGrimoireEntry('A0DH', 'A0DM')
			call this.addGrimoireEntry('A0DI', 'A0DN')
			call this.addGrimoireEntry('A0DJ', 'A0DO')
			call this.addGrimoireEntry('A0DK', 'A0DP')
			call this.addGrimoireEntry('A0DL', 'A0DQ')

			return this
		endmethod

		private static method triggerConditionSummon takes nothing returns boolean
			if (GetUnitTypeId(GetSummonedUnit()) == 'e000' or GetUnitTypeId(GetSummonedUnit()) == 'e002' or GetUnitTypeId(GetSummonedUnit()) == 'e003' or GetUnitTypeId(GetSummonedUnit()) == 'e004' or GetUnitTypeId(GetSummonedUnit()) == 'e005') then
				// the model is summoned with a birth animation
				call SetUnitAnimation(GetSummonedUnit(), "Stand")
			endif
			return false
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.m_summonTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_summonTrigger, EVENT_PLAYER_UNIT_SUMMON)
			call TriggerAddCondition(thistype.m_summonTrigger, Condition(function thistype.triggerConditionSummon))
		endmethod
	endstruct

endlibrary