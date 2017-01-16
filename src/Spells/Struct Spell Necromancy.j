/// Necromancer
library StructSpellsSpellNecromancy requires Asl, StructGameClasses, StructGameSpell

	struct SpellNecromancy extends Spell
		public static constant integer abilityId = 'A0FJ'
		public static constant integer favouriteAbilityId = 'A0FK'
		public static constant integer classSelectionAbilityId = 'A1MP'
		public static constant integer classSelectionGrimoireAbilityId = 'A1MQ'
		public static constant integer maxLevel = 5
		public static constant integer maxUnits = 6
		private AUnitList m_units
		private trigger m_summonTrigger
		private trigger m_deathTrigger

		private static method isUnitOfType takes unit whichUnit returns boolean
			return (GetUnitTypeId(whichUnit) == 'n03N' or GetUnitTypeId(whichUnit) == 'n03W' or GetUnitTypeId(whichUnit) == 'n03X' or GetUnitTypeId(whichUnit) == 'n03Y' or GetUnitTypeId(whichUnit) == 'n03Z')
		endmethod

		private static method triggerConditionSummon takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local unit frontUnit = null

			 if (GetSummoningUnit() == this.character().unit() and thistype.isUnitOfType(GetSummonedUnit())) then
				/*
				 * While the spell is canceled if alreay 6 minions exist it might be that the spell summons more than one minion and therefore the limit is reached.
				 * In this case the longest existing minions are killed and removed from the group.
				 */
				if (this.m_units.size() >= thistype.maxUnits) then
					set frontUnit = this.m_units.front()
					call this.m_units.popFront()
					// Kill AFTER removing from group to NOT trigger the death trigger!
					call KillUnit(frontUnit)
					set frontUnit = null
				endif

				call this.m_units.pushBack(GetSummonedUnit())

				debug call Print("Summoned " + GetUnitName(GetSummonedUnit()) + " with " + I2S(this.m_units.size()) + " minions.")
			endif

			return false
		endmethod

		private static method triggerConditionDeath takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)

			if (thistype.isUnitOfType(GetTriggerUnit()) and this.m_units.contains(GetTriggerUnit())) then
				call this.m_units.remove(GetTriggerUnit())
				debug call Print("Removed summoned " + GetUnitName(GetTriggerUnit()))
			endif

			return false
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1MP', 'A1MQ')
			call this.addGrimoireEntry('A0FL', 'A0FQ')
			call this.addGrimoireEntry('A0FM', 'A0FR')
			call this.addGrimoireEntry('A0FN', 'A0FS')
			call this.addGrimoireEntry('A0FO', 'A0FT')
			call this.addGrimoireEntry('A0FP', 'A0FU')

			set this.m_units = AUnitList.create()

			set this.m_summonTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_summonTrigger, EVENT_PLAYER_UNIT_SUMMON)
			call TriggerAddCondition(this.m_summonTrigger, Condition(function thistype.triggerConditionSummon))
			call DmdfHashTable.global().setHandleInteger(this.m_summonTrigger, 0, this)

			set this.m_deathTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_deathTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(this.m_deathTrigger, Condition(function thistype.triggerConditionDeath))
			call DmdfHashTable.global().setHandleInteger(this.m_deathTrigger, 0, this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_units.destroy()
			set this.m_units = 0
			call DmdfHashTable.global().destroyTrigger(this.m_summonTrigger)
			set this.m_summonTrigger = null
			call DmdfHashTable.global().destroyTrigger(this.m_deathTrigger)
			set this.m_deathTrigger = null
		endmethod
	endstruct

endlibrary