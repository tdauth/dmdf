/// Cleric
library StructSpellsSpellMaertyrer requires Asl, StructGameClasses, StructGameSpell

	struct SpellMaertyrer extends Spell
		public static constant integer abilityId = 'A0NC'
		public static constant integer favouriteAbilityId = 'A0ND'
		public static constant integer classSelectionAbilityId = 'A1M5'
		public static constant integer classSelectionGrimoireAbilityId = 'A1M6'
		public static constant integer maxLevel = 5
		private static constant real radius = 800.0
		private static constant real healStartValue = 0.20
		private static constant real healLevelValue = 0.10
		private static constant real manaStartValue = 0.50
		private static constant real manaLevelValue = 0.10
		
		private method targets takes nothing returns AGroup
			local unit caster = GetTriggerUnit()
			local AGroup alliesInRange = AGroup.create()
			local integer i
			call alliesInRange.addUnitsInRange(GetUnitX(caster), GetUnitY(caster), thistype.radius, null)
			set i = 0
			loop
				exitwhen (i == alliesInRange.units().size())
				// no buildings, not himself because he dies, no mechanicals
				if (GetUnitAllianceStateToUnit(caster, alliesInRange.units()[i]) != bj_ALLIANCE_ALLIED or caster == alliesInRange.units()[i] or IsUnitType(alliesInRange.units()[i], UNIT_TYPE_STRUCTURE) or IsUnitType(alliesInRange.units()[i], UNIT_TYPE_MECHANICAL)) then
					call alliesInRange.units().erase(i)
				elseif (not (GetUnitState(alliesInRange.units()[i], UNIT_STATE_LIFE) < GetUnitState(alliesInRange.units()[i], UNIT_STATE_MAX_LIFE)) and not (GetUnitState(alliesInRange.units()[i], UNIT_STATE_MANA) < GetUnitState(alliesInRange.units()[i], UNIT_STATE_MAX_MANA))) then
					call alliesInRange.units().erase(i)
				else
					set i = i + 1
				endif
			endloop
			set caster = null
			
			return alliesInRange
		endmethod
		
		private method condition takes nothing returns boolean
			local AGroup targets = this.targets()
			local boolean result = not targets.units().isEmpty()
			call targets.destroy()
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Keine Verbündeten mit nicht aufgefüllten Werten in Reichweite.", "No allies with not full values within reach."))
			endif
			return result
		endmethod
			

		private method action takes nothing returns nothing
			local unit caster = GetTriggerUnit()
			local effect casterEffect
			local AGroup alliesInRange = this.targets()
			local integer i
			local real value
			set i = 0
			loop
				exitwhen (i == alliesInRange.units().size())
				// no buildings, not himself because he dies, no mechanicals
				if (not (GetUnitAllianceStateToUnit(caster, alliesInRange.units()[i]) != bj_ALLIANCE_ALLIED or caster == alliesInRange.units()[i] or IsUnitType(alliesInRange.units()[i], UNIT_TYPE_STRUCTURE) or IsUnitType(alliesInRange.units()[i], UNIT_TYPE_MECHANICAL))) then
					if (GetUnitState(alliesInRange.units()[i], UNIT_STATE_LIFE) < GetUnitState(alliesInRange.units()[i], UNIT_STATE_MAX_LIFE)) then
						set value = (GetUnitState(alliesInRange.units()[i], UNIT_STATE_MAX_LIFE) * (thistype.healStartValue + thistype.healLevelValue * this.level()))
						call SetUnitLifeBJ(alliesInRange.units()[i], GetUnitState(alliesInRange.units()[i], UNIT_STATE_LIFE) + value)
						call Spell.showLifeTextTag(alliesInRange.units()[i], value)
					endif
					
					if (GetUnitState(alliesInRange.units()[i], UNIT_STATE_MANA) < GetUnitState(alliesInRange.units()[i], UNIT_STATE_MAX_MANA)) then
						set value = (GetUnitState(alliesInRange.units()[i], UNIT_STATE_MAX_MANA) * (thistype.manaStartValue + thistype.manaLevelValue * this.level()))
						call SetUnitManaBJ(alliesInRange.units()[i], GetUnitState(alliesInRange.units()[i], UNIT_STATE_MANA) + value)
						call Spell.showManaTextTag(alliesInRange.units()[i], value)
					endif
					set i = i + 1
				endif
			endloop
			
			set casterEffect =  AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "origin")
			call KillUnit(caster)
			set caster = null
			call DestroyEffect(casterEffect)
			set casterEffect = null
			call alliesInRange.destroy()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A1M5', 'A1M6')
			call this.addGrimoireEntry('A0NE', 'A0NJ')
			call this.addGrimoireEntry('A0NF', 'A0NK')
			call this.addGrimoireEntry('A0NG', 'A0NL')
			call this.addGrimoireEntry('A0NH', 'A0NM')
			call this.addGrimoireEntry('A0NI', 'A0NN')
			
			return this
		endmethod
	endstruct

endlibrary