/// Elemental Mage
library StructSpellsSpellInferno requires Asl, StructSpellsSpellElementalMageDamageSpell

	/// Auf dem Boden unter dem Magier entsteht ein Flammenmeer, das Gegner für X/Sekunde verbrennt.
	struct SpellInferno extends SpellElementalMageDamageSpell
		public static constant integer abilityId = 'A01A'
		public static constant integer favouriteAbilityId = 'A03N'
		public static constant integer maxLevel = 5
		private static constant real time = 10.0
		private static constant real radius = 400.0
		private static constant real damageLevelValue = 50.0

		private static method filterCondition takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit)
			set filterUnit = null
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "origin")
			local real time = thistype.time
			local group targets = CreateGroup()
			local conditionfunc condition = Condition(function thistype.filterCondition)
			local unit firstOfGroup
			local real damage = thistype.damageLevelValue * this.level()
			local real newDamage
			loop
				exitwhen (time <= 0.0 or ASpell.allyTargetLoopCondition(caster))
				call GroupEnumUnitsInRange(targets, GetUnitX(caster), GetUnitY(caster), thistype.radius, condition)
				loop
					exitwhen (IsUnitGroupEmptyBJ(targets))
					set firstOfGroup = FirstOfGroupSave(targets)
					if (GetUnitAllianceStateToUnit(caster, firstOfGroup) == bj_ALLIANCE_UNALLIED) then
						//Zeit vergeht - Schaden neu berechnen
						set newDamage = damage + damage * SpellElementalMageDamageSpell(this).damageBonusFactor()
						call UnitDamageTargetBJ(caster, firstOfGroup, newDamage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE)
						call ShowBashTextTagForPlayer(null, GetWidgetX(firstOfGroup), GetWidgetY(firstOfGroup), R2I(newDamage))
					endif
					call GroupRemoveUnit(targets, firstOfGroup)
					set firstOfGroup = null
				endloop
				call GroupClear(targets)
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			set caster = null
			call DestroyEffect(casterEffect)
			set casterEffect = null
			call DestroyGroup(targets)
			set targets = null
			call DestroyCondition(condition)
			set condition = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary