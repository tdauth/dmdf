/// Wizard
library StructSpellsSpellMagicalShockWaves requires Asl, StructGameClasses, StructGameSpell

	/**
	* Gegeben:
	* Name					Variiert pro Stufe
	* Umkreis				Nein
	* Zeit					Nein
	* prozentualer Schadensanteil		Ja
	*/
	/// Gegner im Umkreis von 600, die über kein Mana verfügen, erleiden 30 Sekunden lang X% mehr Schaden. 
	struct SpellMagicalShockWaves extends Spell
		public static constant integer abilityId = 'A05W'
		public static constant integer favouriteAbilityId = 'A05X'
		public static constant integer maxLevel = 5
		private static constant real range = 600.0
		private static constant real time = 30.0
		private static constant real damagePercentageStartValue = 5.0
		private static constant real damagePercentageLevelValue = 10.0

		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit) and not (GetUnitState(filterUnit, UNIT_STATE_MAX_MANA) > 0.0)
			set filterUnit = null
			return result
		endmethod

		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local thistype this = DmdfHashTable.global().integer("SpellMagicalShockWaves:" + I2S(damageRecorder), "this")
			local unit caster = this.character().unit()
			local unit target = damageRecorder.target()
			//GetEventDamageSource
			local real damage = GetEventDamage() * (thistype.damagePercentageStartValue + this.level() * thistype.damagePercentageLevelValue) / 100.0
			call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC)
			call ShowBashTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(damage))
			set caster = null
			set target = null
		endmethod
		
		private method condition takes nothing returns boolean
			local unit caster = this.character().unit()
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets = AGroup.create()
			local boolean result
			call GroupEnumUnitsInRange(targetGroup, GetUnitX(caster), GetUnitY(caster), thistype.range, filter)
			call targets.addGroup(targetGroup, true, false)
			set targetGroup = null
			debug call Print("Before removing allies: " + I2S(targets.units().size()))
			call targets.removeAlliesOfUnit(caster)
			set result = not targets.units().empty()
			call targets.destroy()
			set caster = null
			call DestroyFilter(filter)
			set filter = null
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Keine gültigen Ziele in der Nähe."))
			endif
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets = AGroup.create()
			local AIntegerVector damageRecorders
			local ADamageRecorder damageRecorder
			local integer i
			local unit target
			local real time
			call GroupEnumUnitsInRange(targetGroup, GetUnitX(caster), GetUnitY(caster), thistype.range, filter)
			call targets.addGroup(targetGroup, true, false)
			set targetGroup = null
			call targets.removeAlliesOfUnit(caster)
			if (not targets.units().empty()) then
				set damageRecorders = AIntegerVector.create()
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units()[i]
					set damageRecorder = ADamageRecorder.create(target)
					call damageRecorder.setOnDamageAction(thistype.onDamageAction)
					call DmdfHashTable.global().setInteger("SpellMagicalShockWaves:" + I2S(damageRecorder), "this", this)
					call damageRecorders.pushBack(damageRecorder)
					set target = null
					set i = i + 1
				endloop

				set time = thistype.time
				loop
					exitwhen (time <= 0.0 or targets.units().empty())
					call TriggerSleepAction(1.0)
					set i = 0
					loop
						exitwhen (i == targets.units().size())
						set target = targets.units()[i]
						if (ASpell.enemyTargetLoopCondition(target)) then
							call targets.units().erase(i)
							call DmdfHashTable.global().removeInteger("SpellMagicalShockWaves:" + I2S(damageRecorders[i]), "this")
							call ADamageRecorder(damageRecorders[i]).destroy()
							call damageRecorders.erase(i)
						else
							set i = i + 1
						endif
						set target = null
					endloop
					set time = time - 1.0
				endloop

				set i = 0
				loop
					exitwhen (i == damageRecorders.size())
					set damageRecorder = ADamageRecorder(damageRecorders[i])
					call DmdfHashTable.global().removeInteger("SpellMagicalShockWaves:" + I2S(damageRecorder), "this")
					call damageRecorder.destroy()
					set i = i + 1
				endloop

				call damageRecorders.destroy()
			endif
			set caster = null
			call DestroyFilter(filter)
			set filter = null
			call targets.destroy()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A100', 'A105')
			call this.addGrimoireEntry('A101', 'A106')
			call this.addGrimoireEntry('A102', 'A107')
			call this.addGrimoireEntry('A103', 'A108')
			call this.addGrimoireEntry('A104', 'A109')
			
			return this
		endmethod
	endstruct

endlibrary