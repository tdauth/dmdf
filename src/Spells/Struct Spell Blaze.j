/// Elemental Mage
library StructSpellsSpellBlaze requires Asl, StructSpellsSpellElementalMageDamageSpell

	struct SpellBlaze extends SpellElementalMageDamageSpell
		public static constant integer abilityId = 'A01E'
		public static constant integer favouriteAbilityId = 'A03L'
		public static constant integer maxLevel = 5
		private static constant real radius = 300.0
		private static constant real damageStartValue = 20.0
		private static constant real damageLevelValue = 10.0
		private static constant real damageLevelBonus = 2.0

		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit)
			set filterUnit = null
			return result
		endmethod

		/// Eine Feuersbrunst erfasst ein Gebiet mit einem Durchmesser von 30 Metern und fügt Feinden in diesem Gebiet X Punkte Schaden plus Y Punkte Schaden für jeden Gegner, den sie erfasst, zu. 3 Minuten Abklingzeit.
		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets
			local AEffectVector spellEffects
			local integer i
			local unit target
			local real damage
			call GroupEnumUnitsInRange(targetGroup, GetSpellTargetX(), GetSpellTargetY(), thistype.radius, filter)
			if (not IsUnitGroupEmptyBJ(targetGroup)) then
				set targets = AGroup.create()
				call targets.addGroup(targetGroup, true, false)
				set targetGroup = null
				set damage = 0.0
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units().at(i)
					if (GetUnitAllianceStateToUnit(caster, target) == bj_ALLIANCE_UNALLIED) then
						set damage = damage + this.level() * thistype.damageLevelBonus
						set i = i + 1
					else
						call targets.units().erase(i)
					endif
					set target = null
				endloop
				set damage = damage + thistype.damageStartValue + this.level() * thistype.damageLevelValue
				set spellEffects = AEffectVector.create()
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units().at(i)
					call UnitDamageTargetBJ(caster, target, damage + this.damageBonusFactor() * damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE)
					call ShowBashTextTagForPlayer(null, GetWidgetX(target), GetWidgetY(target), R2I(damage))
					call spellEffects.pushBack(AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "chest"))
					set target = null
					set i = i + 1
				endloop
				call TriggerSleepAction(1.0)
				set i = spellEffects.backIndex()
				loop
					exitwhen (i < 0)
					call DestroyEffect(spellEffects[i])
					call spellEffects.popBack()
					set i = i - 1
				endloop
				call targets.destroy()
				call spellEffects.destroy()
			else
				call DestroyGroup(targetGroup)
				set targetGroup = null
			endif
			set caster = null
			call DestroyFilter(filter)
			set filter = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A0U1', 'A0U6')
			call this.addGrimoireEntry('A0U2', 'A0U7')
			call this.addGrimoireEntry('A0U3', 'A0U8')
			call this.addGrimoireEntry('A0U4', 'A0U9')
			call this.addGrimoireEntry('A0U5', 'A0UA')
			
			return this
		endmethod
	endstruct

endlibrary