/// Elemental Mage
library StructSpellsSpellIceAge requires Asl, StructGameClasses, StructGameSpell

	/**
	* Der Elementarmagier vereist das Gebiet in einem Umkreis von 20 Metern um sich herum für 20 Sekunden, fügt alle 10 Sekunden X Punkte Schaden zu und verringert Bewegungs- und Angriffsgeschwindigkeit aller Gegner um 50 %.
	* Erhöht erlittenen Frostschaden um Y. 3 Minuten Abklingzeit.
	*/
	struct SpellIceAge extends SpellElementalMageDamageSpell
		public static constant integer abilityId = 'A01D'
		public static constant integer favouriteAbilityId = 'A03G'
		public static constant integer maxLevel = 5
		private static constant real radius = 600.0 // 20 Meter
		private static constant real time = 20.0 // 20 Sekunden
		private static constant real damageInterval = 10.0 // alle 10 Sekunden
		private static constant real damageLevelValue = 50.0
		private static constant real movementValue = 0.50

		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit)
			set filterUnit = null
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets
			local integer i
			local unit target
			local real damage
			local real time
			call GroupEnumUnitsInRange(targetGroup, GetSpellTargetX(), GetSpellTargetY(), thistype.radius, filter)
			if (not IsUnitGroupEmptyBJ(targetGroup)) then
				set targets = AGroup.create()
				call targets.addGroup(targetGroup, true, false) // destroys the group
				set targetGroup = null
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units()[i]
					if (GetUnitAllianceStateToUnit(caster, target) != bj_ALLIANCE_UNALLIED) then
						call targets.units().erase(i)
					else
						set i = i + 1
					endif
					set target = null
				endloop
				if (not targets.units().empty()) then
					set damage = this.level() * thistype.damageLevelValue
					set damage = SpellElementalMageDamageSpell(this).damageBonusFactor() * damage
					set time = thistype.time
					loop
						exitwhen (time <= 0.0 or targets.units().empty())
						set i = 0
						loop
							exitwhen (i == targets.units().size())
							set target = targets.units()[i]
							if (not ASpell.enemyTargetLoopCondition(target)) then
								call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE)
								call ShowBashTextTagForPlayer(null, GetWidgetX(target), GetWidgetY(target), R2I(damage))
								set i = i + 1
							else
								call targets.units().erase(i)
							endif
							set target = null
						endloop
						call TriggerSleepAction(thistype.damageInterval)
						set time = time - thistype.damageInterval
					endloop
				endif
				call targets.destroy()
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
			call this.addGrimoireEntry('A0TH', 'A0TM')
			call this.addGrimoireEntry('A0TI', 'A0TN')
			call this.addGrimoireEntry('A0TJ', 'A0TO')
			call this.addGrimoireEntry('A0TK', 'A0TP')
			call this.addGrimoireEntry('A0TL', 'A0TQ')
			
			return this
		endmethod
	endstruct

endlibrary