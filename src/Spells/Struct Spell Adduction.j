/// Wizard
library StructSpellsSpellAdduction requires Asl, StructGameClasses, StructGameSpell

	/// Der Zauberer zieht Gegner aus einem Umkreis von 10 Metern zu sich heran und fügt ihnen X Punkte Schaden zu. 10 Sekunden Abklingzeit.
	struct SpellAdduction extends Spell
		public static constant integer abilityId = 'A01O'
		public static constant integer favouriteAbilityId = 'A03Y'
		public static constant integer maxLevel = 5
		private static constant real range = 800.0 //10 Meter
		private static constant real effectTime = 15.0 // this value is used by spell repulsion to see whether this spell was casted on the unit before
		private static constant real timeStartValue = 5.0
		private static constant real timeLevelValue = 2.0
		private static constant real damageStartValue = 100.0
		private static constant real damageLevelValue = 100.0

		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit)
			set filterUnit = null
			return result
		endmethod

		// note that you needn't to hook the native RemoveUnit since timer should always expire
		private static method timerFunctionResetEffect takes nothing returns nothing
			local timer expiredTimer = GetExpiredTimer()
			local unit target = DmdfHashTable.global().handleUnit(expiredTimer, "SpellAdduction:target")
			call DmdfHashTable.global().removeHandleBoolean(target, "SpellAdduction:isTarget")
			call DmdfHashTable.global().removeHandleTimer(target, "SpellAdduction:timer")
			call DmdfHashTable.global().removeHandleUnit(expiredTimer, "SpellAdduction:target")
			set target = null
			call PauseTimer(expiredTimer)
			call DestroyTimer(expiredTimer)
			set expiredTimer = null
		endmethod

		/// @todo Lighting effects and moves.
		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets = AGroup.create()
			local AIntegerVector dynamicLightnings
			local integer i
			local unit target
			local real time
			local timer effectTimer
			local real damage
			call GroupEnumUnitsInRange(targetGroup, GetUnitX(caster), GetUnitY(caster), thistype.range, filter)
			call targets.addGroup(targetGroup, true, false)
			set targetGroup = null
			call targets.removeAlliesOfUnit(caster)
			if (not targets.units().empty()) then
				set dynamicLightnings = AIntegerVector.create()
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units()[i]
					call dynamicLightnings.pushBack(ADynamicLightning.create(null, "DRAM", 0.01, caster, target))
					if (DmdfHashTable.global().hasHandleBoolean(target, "SpellAdduction:isTarget")) then
						set effectTimer = DmdfHashTable.global().handleTimer(target, "SpellAdduction:timer")
						call PauseTimer(effectTimer)
						call DestroyTimer(effectTimer)
						set effectTimer = null
						call DmdfHashTable.global().removeHandleTimer(target, "SpellAdduction:timer")
					else
						call DmdfHashTable.global().setHandleBoolean(target, "SpellAdduction:isTarget", true)
					endif
					set effectTimer = CreateTimer()
					call DmdfHashTable.global().setHandleUnit(effectTimer, "SpellAdduction:target", target)
					call DmdfHashTable.global().setHandleTimer(target, "SpellAdduction:timer", effectTimer)
					call TimerStart(effectTimer, thistype.effectTime, false, function thistype.timerFunctionResetEffect)
					set effectTimer = null
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
				debug call Print("Adduction: " + I2S(targets.units().size()) + " targets left and " + I2S(dynamicLightnings.size()) + " dynamic lightnings.")
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					call ADynamicLightning(dynamicLightnings[i]).destroy()
					set target = targets.units()[i]
					set damage = thistype.damageStartValue + this.level() * thistype.damageLevelValue
					call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC)
					call Spell.showDamageTextTag(target, damage)
					set target = null
					set i = i + 1
				endloop

				call dynamicLightnings.destroy()
			endif
			set caster = null
			call DestroyFilter(filter)
			set filter = null
			call targets.destroy()
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod

		public static method isTarget takes unit whichUnit returns boolean
			return DmdfHashTable.global().hasHandleBoolean(whichUnit, "SpellAdduction:isTarget")
		endmethod
	endstruct

endlibrary