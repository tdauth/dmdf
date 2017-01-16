/// Druid
library StructSpellsSpellGrove requires Asl, StructGameClasses, StructGameSpell

	struct SpellGrove extends Spell
		public static constant integer abilityId = 'A0D4'
		public static constant integer favouriteAbilityId = 'A0D5'
		public static constant integer classSelectionAbilityId = 'A1LB'
		public static constant integer classSelectionGrimoireAbilityId = 'A1LC'
		public static constant integer maxLevel = 5
		private static trigger m_summonTrigger

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1LB', 'A1LC')
			call this.addGrimoireEntry('A0D6', 'A0DB')
			call this.addGrimoireEntry('A0D7', 'A0DC')
			call this.addGrimoireEntry('A0D8', 'A0DD')
			call this.addGrimoireEntry('A0D9', 'A0DE')
			call this.addGrimoireEntry('A0DA', 'A0DF')

			return this
		endmethod

		private static method triggerConditionSummon takes nothing returns boolean
			if (GetUnitTypeId(GetSummonedUnit()) == 'n03K' or GetUnitTypeId(GetSummonedUnit()) == 'n064' or GetUnitTypeId(GetSummonedUnit()) == 'n065' or GetUnitTypeId(GetSummonedUnit()) == 'n066' or GetUnitTypeId(GetSummonedUnit()) == 'n067') then
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