/// Cleric
library StructSpellsSpellMaertyrer requires Asl, StructGameClasses, StructGameSpell

	struct SpellMaertyrer extends Spell
		public static constant integer abilityId = 'A0NC'
		public static constant integer favouriteAbilityId = 'A0ND'
		public static constant integer maxLevel = 5
		private static constant real radius = 600.0
		private static constant real healStartValue = 0.20
		private static constant real healLevelValue = 0.10
		private static constant real manaStartValue = 0.50
		private static constant real manaLevelValue = 0.10

		private method action takes nothing returns nothing
			local unit caster = GetTriggerUnit()
			local effect casterEffect =  AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "origin")
			local AGroup alliesInRange = AGroup.create()
			local integer i
			local real value
			call alliesInRange.addUnitsInRange(GetUnitX(caster), GetUnitY(caster), thistype.radius, null)
			set i = 0
			loop
				exitwhen (i == alliesInRange.units().size())
				if (GetUnitAllianceStateToUnit(caster, alliesInRange.units()[i]) != bj_ALLIANCE_ALLIED or caster == alliesInRange.units()[i]) then
					call alliesInRange.units().erase(i)
				else
					set value = (GetUnitState(alliesInRange.units()[i], UNIT_STATE_MAX_LIFE) * (thistype.healStartValue + thistype.healLevelValue * this.level()))
					call SetUnitLifeBJ(alliesInRange.units()[i], GetUnitState(alliesInRange.units()[i], UNIT_STATE_LIFE) + value)
					call Spell.showLifeTextTag(alliesInRange.units()[i], value)
					set value = (GetUnitState(alliesInRange.units()[i], UNIT_STATE_MAX_MANA) * (thistype.manaStartValue + thistype.manaLevelValue * this.level()))
					call SetUnitManaBJ(alliesInRange.units()[i], GetUnitState(alliesInRange.units()[i], UNIT_STATE_MANA) + value)
					call Spell.showManaTextTag(alliesInRange.units()[i], value)
					set i = i + 1
				endif
			endloop
			call KillUnit(caster)
			set caster = null
			call DestroyEffect(casterEffect)
			set casterEffect = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A0NE', 'A0NJ')
			call this.addGrimoireEntry('A0NF', 'A0NK')
			call this.addGrimoireEntry('A0NG', 'A0NL')
			call this.addGrimoireEntry('A0NH', 'A0MM')
			call this.addGrimoireEntry('A0NI', 'A0MN')
			
			return this
		endmethod
	endstruct

endlibrary