/// Wizard
library StructSpellsSpellRepulsion requires Asl, StructGameClasses, StructGameSpell

	/**
	* Auf das Ziel darf maximal 15 Sekunden vorher der Zauber Anziehung gewirkt worden sein, damit der Bonus hinzukommt.
	* Der Zauberer stößt alle Gegner um sich herum von sich weg und fügt ihnen X Punkte Schaden zu. Sollte er sie zuvor angezogen haben, erleiden sie weitere X * 2 Punkte Schaden und büßen 10 % ihres Manas ein. 8 Sekunden Abklingzeit.
	*/
	struct SpellRepulsion extends Spell
		public static constant integer abilityId = 'A05Z'
		public static constant integer favouriteAbilityId = 'A05Y'
		public static constant integer maxLevel = 5
		private static constant real range = 300.0
		private static constant real timeStartValue = 5.0
		private static constant real timeLevelValue = 2.0
		private static constant real damageStartValue = 300.0
		private static constant real damageLevelValue = 100.0
		private static constant real manaPercentage = 10.0

		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit)
			set filterUnit = null
			return result
		endmethod

		/// @todo Lighting effects and moves.
		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets = AGroup.create()
			local AIntegerVector dynamicLightnings
			local ABooleanVector wasAdducted
			local integer i
			local unit target
			local real time
			local real damage
			call GroupEnumUnitsInRange(targetGroup, GetUnitX(caster), GetUnitY(caster), thistype.range, filter)
			call targets.addGroup(targetGroup, true, false)
			set targetGroup = null
			call targets.removeAlliesOfUnit(caster)
			if (not targets.units().empty()) then
				set dynamicLightnings = AIntegerVector.create()
				set wasAdducted = ABooleanVector.create()
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units()[i]
					call dynamicLightnings.pushBack(ADynamicLightning.create(null, "DRAM", 0.01, caster, target))
					call wasAdducted.pushBack(SpellAdduction.isTarget(target))
					set target = null
					set i = i + 1
				endloop

				set time = thistype.timeStartValue + this.level() * thistype.timeLevelValue
				loop
					exitwhen (time <= 0.0 or targets.units().empty())
					call TriggerSleepAction(1.0)
					set i = 0
					loop
						exitwhen (i == targets.units().size())
						set target = targets.units()[i]
						if (ASpell.enemyTargetLoopCondition(target)) then
							call targets.units().erase(i)
							call ADynamicLightning(dynamicLightnings[i]).destroy()
							call dynamicLightnings.erase(i)
						else
							/// @todo move?
							set i = i + 1
						endif
						set target = null
					endloop
					set time = time - 1.0
				endloop

				set i = 0
				loop
					exitwhen (i == targets.units().size())
					call ADynamicLightning(dynamicLightnings[i]).destroy()
					set target = targets.units()[i]
					set damage = thistype.damageStartValue + this.level() * thistype.damageLevelValue
					call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC)
					call ShowBashTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(damage))
					if (wasAdducted[i]) then
						set damage = damage * 2
						call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC)
						call ShowBashTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(damage))
						set damage = RMinBJ(GetUnitState(target, UNIT_STATE_MAX_MANA) * thistype.manaPercentage / 100.0, GetUnitState(target, UNIT_STATE_MANA))
						call SetUnitState(target, UNIT_STATE_MANA, GetUnitState(target, UNIT_STATE_MANA) - damage)
						call ShowManaBurnTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(damage))
					endif
					set target = null
					set i = i + 1
				endloop

				call dynamicLightnings.destroy()
				call wasAdducted.destroy()
			endif
			set caster = null
			call DestroyFilter(filter)
			set filter = null
			call targets.destroy()
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary