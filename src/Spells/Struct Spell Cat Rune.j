/// Item
library StructSpellsSpellCatRune requires Asl

	/// Note that there only can be one spell which bases on "Mechanical Critter"!
	struct SpellCatRune
		public static constant integer chaosAbilityId = 'S000'
		private static trigger m_summonTrigger

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method triggerConditionSummonCat takes nothing returns boolean
			local unit summoningUnit = GetSummoningUnit()
			local boolean result = GetUnitTypeId(summoningUnit) == 'nalb' or GetUnitTypeId(summoningUnit) == 'ndwm' or GetUnitTypeId(summoningUnit) == 'nhmc' or GetUnitTypeId(summoningUnit) == 'nfro' or GetUnitTypeId(summoningUnit) == 'nvul' or GetUnitTypeId(summoningUnit) == 'necr' or GetUnitTypeId(summoningUnit) == 'nder' or GetUnitTypeId(summoningUnit) == 'nech' or GetUnitTypeId(summoningUnit) == 'ndog' or GetUnitTypeId(summoningUnit) == 'ncrb' or GetUnitTypeId(summoningUnit) == 'npng' or GetUnitTypeId(summoningUnit) == 'nrat' or GetUnitTypeId(summoningUnit) == 'nsea' or GetUnitTypeId(summoningUnit) == 'nshe' or GetUnitTypeId(summoningUnit) == 'nsno' or GetUnitTypeId(summoningUnit) == 'npig' or GetUnitTypeId(summoningUnit) == 'nske' or GetUnitTypeId(summoningUnit) == 'nskk' or GetUnitTypeId(summoningUnit) == 'nfbr' or GetUnitTypeId(summoningUnit) == 'nrac'
			set summoningUnit = null
			return result
		endmethod

		private static method triggerActionSummonCat takes nothing returns nothing
			local unit summoningUnit = GetSummoningUnit()
			call UnitAddAbility(summoningUnit, thistype.chaosAbilityId)
			set summoningUnit = null
		endmethod

		public static method init takes nothing returns nothing
			local conditionfunc conditionFunction
			local triggercondition triggerCondition
			local triggeraction triggerAction
			set thistype.m_summonTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_summonTrigger, EVENT_PLAYER_UNIT_SUMMON)
			set conditionFunction = Condition(function thistype.triggerConditionSummonCat)
			set triggerCondition = TriggerAddCondition(thistype.m_summonTrigger, conditionFunction)
			set triggerAction = TriggerAddAction(thistype.m_summonTrigger, function thistype.triggerActionSummonCat)
			set conditionFunction = null
			set triggerCondition = null
			set triggerAction = null
		endmethod
	endstruct

endlibrary