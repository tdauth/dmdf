/// Ranger
library StructSpellsSpellKennels requires Asl, StructGameClasses, StructGameSpell

	struct SpellKennels extends Spell
		public static constant integer abilityId = 'A1BG'
		public static constant integer favouriteAbilityId = 'A1BN'
		public static constant integer classSelectionAbilityId = 'A1LV'
		public static constant integer classSelectionGrimoireAbilityId = 'A1LW'
		public static constant integer maxLevel = 5
		public static constant integer buffId = 'B02Q'
		public static constant integer summonAbilityId = 'B02Q'
		public static constant integer dogBuffId = 'B02R'
		public static constant real duration = 2.0
		public static constant real dogDuration = 30.0
		private trigger m_summonTrigger
		private trigger m_summonDogTrigger

		private static method isUnitOfType takes unit whichUnit returns boolean
			return (GetUnitTypeId(whichUnit) == 'n05O' or GetUnitTypeId(whichUnit) == 'n05P' or GetUnitTypeId(whichUnit) == 'n05Q' or GetUnitTypeId(whichUnit) == 'n05R' or GetUnitTypeId(whichUnit) == 'n05S')
		endmethod

		private static method triggerConditionSummon takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)

			if (thistype.isUnitOfType(GetSummonedUnit())) then
				call UnitApplyTimedLife(GetSummonedUnit(), thistype.buffId, thistype.duration)
			endif

			return false
		endmethod

		private static method isUnitOfTypeDog takes unit whichUnit returns boolean
			return (GetUnitTypeId(whichUnit) == 'n05T' or GetUnitTypeId(whichUnit) == 'n05U' or GetUnitTypeId(whichUnit) == 'n05V' or GetUnitTypeId(whichUnit) == 'n05W' or GetUnitTypeId(whichUnit) == 'n05X')
		endmethod

		private static method triggerConditionSummonDog takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)

			if (thistype.isUnitOfType(GetSummoningUnit()) and thistype.isUnitOfTypeDog(GetSummonedUnit())) then
				call UnitApplyTimedLife(GetSummonedUnit(), thistype.dogBuffId, thistype.dogDuration)
			endif

			return false
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)

			call this.addGrimoireEntry('A1LV', 'A1LW')
			call this.addGrimoireEntry('A1BO', 'A1BT')
			call this.addGrimoireEntry('A1BP', 'A1BU')
			call this.addGrimoireEntry('A1BQ', 'A1BV')
			call this.addGrimoireEntry('A1BR', 'A1BW')
			call this.addGrimoireEntry('A1BS', 'A1BX')

			set this.m_summonTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_summonTrigger, EVENT_PLAYER_UNIT_SUMMON)
			call TriggerAddCondition(this.m_summonTrigger, Condition(function thistype.triggerConditionSummon))
			call DmdfHashTable.global().setHandleInteger(this.m_summonTrigger, 0, this)

			set this.m_summonDogTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_summonDogTrigger, EVENT_PLAYER_UNIT_SUMMON)
			call TriggerAddCondition(this.m_summonDogTrigger, Condition(function thistype.triggerConditionSummonDog))
			call DmdfHashTable.global().setHandleInteger(this.m_summonDogTrigger, 0, this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_summonTrigger)
			set this.m_summonTrigger = null

			call DmdfHashTable.global().destroyTrigger(this.m_summonDogTrigger)
			set this.m_summonDogTrigger = null
		endmethod
	endstruct

endlibrary