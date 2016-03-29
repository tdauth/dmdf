/// Druid
library StructSpellsSpellTreefolk requires Asl, StructGameClasses, StructGameSpell

	struct SpellTreefolk extends Spell
		public static constant integer abilityId = 'A0E1'
		public static constant integer favouriteAbilityId = 'A0B7'
		public static constant integer classSelectionAbilityId = 'A1OH'
		public static constant integer classSelectionGrimoireAbilityId = 'A1OI'
		public static constant integer maxLevel = 5
		private trigger m_summonTrigger
		
		private static method triggerConditionSummon takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return GetSummoningUnit() == this.character().unit() and (GetUnitTypeId(GetSummonedUnit()) == 'e000' or GetUnitTypeId(GetSummonedUnit()) == 'e002' or GetUnitTypeId(GetSummonedUnit()) == 'e003' or GetUnitTypeId(GetSummonedUnit()) == 'e004' or GetUnitTypeId(GetSummonedUnit()) == 'e005')
		endmethod
		
		private static method triggerActionSummon takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			debug call Print("Unroot treefolk " + GetUnitName(GetSummonedUnit()))
			call IssueImmediateOrder(GetSummonedUnit(), "unroot")
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			set this.m_summonTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_summonTrigger, EVENT_PLAYER_UNIT_SUMMON)
			call TriggerAddCondition(this.m_summonTrigger, Condition(function thistype.triggerConditionSummon))
			call TriggerAddAction(this.m_summonTrigger, function thistype.triggerActionSummon)
			call DmdfHashTable.global().setHandleInteger(this.m_summonTrigger, 0, this)
			
			call this.addGrimoireEntry('A1OH', 'A1OI')
			call this.addGrimoireEntry('A0DH', 'A0DM')
			call this.addGrimoireEntry('A0DI', 'A0DN')
			call this.addGrimoireEntry('A0DJ', 'A0DO')
			call this.addGrimoireEntry('A0DK', 'A0DP')
			call this.addGrimoireEntry('A0DL', 'A0DQ')
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_summonTrigger)
			set this.m_summonTrigger = null
		endmethod
	endstruct

endlibrary