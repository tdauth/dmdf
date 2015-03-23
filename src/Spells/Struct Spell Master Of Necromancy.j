/// Necromancer
library StructSpellsSpellMasterOfNecromancy requires Asl, StructGameClasses, StructGameSpell

	/**
	 * Increases stats of summoned units.
	 * Since researchs cannot be undone it must be triggered on the summon event.
	 */
	struct SpellMasterOfNecromancy extends Spell
		public static constant integer abilityId = 'A0SG'
		public static constant integer favouriteAbilityId = 'A0SH'
		public static constant integer maxLevel = 5
		public static constant integer damageAbilityId = 'A0WH'
		public static constant integer defenseAbilityId = 'A0WG'
		private trigger m_summonTrigger
		
		public stub method setLevel takes integer level returns nothing
			call super.setLevel(level)
			
			/*
			NOTE cannot be undone!
			call SetPlayerTechResearched(this.character().player(), 'R009', level)
			call SetPlayerTechResearched(this.character().player(), 'R008', level)
			*/
		endmethod
	
		private static method triggerConditionSummon takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return GetSummoningUnit() == this.character().unit() and IsUnitType(GetSummonedUnit(), UNIT_TYPE_UNDEAD)
		endmethod
		
		private static method triggerActionSummon takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			call UnitAddAbility(GetSummonedUnit(), thistype.damageAbilityId)
			call SetUnitAbilityLevel(GetSummonedUnit(), thistype.damageAbilityId, this.level())
			
			call UnitAddAbility(GetSummonedUnit(), thistype.defenseAbilityId)
			call SetUnitAbilityLevel(GetSummonedUnit(), thistype.defenseAbilityId, this.level())
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			set this.m_summonTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_summonTrigger, character.unit(), EVENT_UNIT_SUMMON)
			call TriggerAddCondition(this.m_summonTrigger, Condition(function thistype.triggerConditionSummon))
			call TriggerAddAction(this.m_summonTrigger, function thistype.triggerActionSummon)
			call DmdfHashTable.global().setHandleInteger(this.m_summonTrigger, "this", this)
			
			call this.addGrimoireEntry('A0SI', 'A0SN')
			call this.addGrimoireEntry('A0SJ', 'A0SO')
			call this.addGrimoireEntry('A0SK', 'A0SP')
			call this.addGrimoireEntry('A0SL', 'A0SQ')
			call this.addGrimoireEntry('A0SM', 'A0SR')
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_summonTrigger)
			set this.m_summonTrigger = null
		endmethod
	endstruct

endlibrary