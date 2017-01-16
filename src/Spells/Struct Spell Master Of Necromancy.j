/// Necromancer
library StructSpellsSpellMasterOfNecromancy requires Asl, StructGameClasses, StructGameSpell

	/**
	 * Increases stats of summoned units.
	 * Since researchs cannot be undone it must be triggered on the summon event.
	 */
	struct SpellMasterOfNecromancy extends Spell
		public static constant integer abilityId = 'A0SG'
		public static constant integer favouriteAbilityId = 'A0SH'
		public static constant integer classSelectionAbilityId = 'A1MF'
		public static constant integer classSelectionGrimoireAbilityId = 'A1MG'
		public static constant integer maxLevel = 5
		public static constant integer damageAbilityId = 'A0WH'
		public static constant integer defenseAbilityId = 'A0WG'
		private trigger m_summonTrigger

		private static method triggerConditionSummon takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return GetOwningPlayer(GetSummoningUnit()) == this.character().player() and IsUnitType(GetSummonedUnit(), UNIT_TYPE_UNDEAD) and GetUnitAbilityLevel(this.character().unit(), thistype.abilityId) > 0 // TODO does not work if the spell is not in favorites?
		endmethod

		private static method triggerActionSummon takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call UnitAddAbility(GetSummonedUnit(), thistype.damageAbilityId)
			call SetUnitAbilityLevel(GetSummonedUnit(), thistype.damageAbilityId, this.level())

			call UnitAddAbility(GetSummonedUnit(), thistype.defenseAbilityId)
			call SetUnitAbilityLevel(GetSummonedUnit(), thistype.defenseAbilityId, this.level())
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			set this.m_summonTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_summonTrigger, EVENT_PLAYER_UNIT_SUMMON)
			call TriggerAddCondition(this.m_summonTrigger, Condition(function thistype.triggerConditionSummon))
			call TriggerAddAction(this.m_summonTrigger, function thistype.triggerActionSummon)
			call DmdfHashTable.global().setHandleInteger(this.m_summonTrigger, 0, this)

			call this.addGrimoireEntry('A1MF', 'A1MG')
			call this.addGrimoireEntry('A0SI', 'A0SN')
			call this.addGrimoireEntry('A0SJ', 'A0SO')
			call this.addGrimoireEntry('A0SK', 'A0SP')
			call this.addGrimoireEntry('A0SL', 'A0SQ')
			call this.addGrimoireEntry('A0SM', 'A0SR')

			call this.setIsPassive(true)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_summonTrigger)
			set this.m_summonTrigger = null
		endmethod
	endstruct

endlibrary