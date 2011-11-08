/// Elemental Mage
library StructSpellsSpellFreeze requires Asl, StructGameClasses, StructGameSpell

	/// Alle Gegner in einem Umkreis von X Metern um den Magier werden Y Sekunden lang betäubt.
	struct SpellFreeze extends Spell
		public static constant integer abilityId = 'A019'
		public static constant integer favouriteAbilityId = 'A03J'
		public static constant integer buffId = 'B00F'
		public static constant integer maxLevel = 5
		private static constant real rangeStartValue = 500.0
		private static constant real rangeLevelValue = 100.0 //ab Stufe 1
		private static constant real timeLevelSummand = 2.0 //wird zur Stufe addiert

		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit)
			set filterUnit = null
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = GetTriggerUnit()
			local effect spellEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "origin")
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets
			local integer i
			local unit target
			local real time
			call GroupEnumUnitsInRange(targetGroup, GetUnitX(caster), GetUnitY(caster), thistype.rangeStartValue + thistype.rangeLevelValue * this.level(), filter)
			if (not IsUnitGroupEmptyBJ(targetGroup)) then
				set targets = AGroup.create()
				call targets.addGroup(targetGroup, true, false) //destroys the group
				set targetGroup = null
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units()[i]
					if (GetUnitAllianceStateToUnit(caster, target) != bj_ALLIANCE_UNALLIED or IsUnitSpellImmune(target)) then
						call targets.units().erase(i)
					else
						set i = i + 1
					endif
					set target = null
				endloop
				if (not targets.units().empty()) then
					set i = 0
					loop
						exitwhen (i == targets.units().size())
						set target = targets.units()[i]
						debug call Print("Stunning "  + GetUnitName(target))
						call PauseUnit(target, true)
						call UnitAddAbility(target, thistype.buffId)
						call UnitMakeAbilityPermanent(target, true, thistype.buffId)
						set target = null
						set i = i + 1
					endloop
					/// @todo Remove after disspell, check after each interval.
					set time = thistype.timeLevelSummand + this.level()
					loop
						exitwhen (time <= 0.0 or targets.isDead())
						set i = 0
						loop
							exitwhen (i == targets.units().size())
							set target = targets.units()[i]
							if (ASpell.enemyTargetLoopCondition(target)) then
								debug call Print("Destunning "  + GetUnitName(target))
								call PauseUnit(target, false)
								call UnitRemoveAbility(target, thistype.buffId)
								call targets.units().erase(i)
							else
								set i = i + 1
							endif
							set target = null
						endloop
						call TriggerSleepAction(1.0)
						set time = time - 1.0
					endloop
					set i = 0
					loop
						exitwhen (i == targets.units().size())
						set target = targets.units()[i]
						debug call Print("Destunning "  + GetUnitName(target))
						call PauseUnit(target, false)
						call UnitRemoveAbility(target, thistype.buffId)
						set target = null
						set i = i + 1
					endloop
					call targets.destroy()
				endif
			else
				call DestroyGroup(targetGroup)
				set targetGroup = null
			endif
			set caster = null
			call DestroyEffect(spellEffect)
			set spellEffect = null
			call DestroyFilter(filter)
			set filter = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary