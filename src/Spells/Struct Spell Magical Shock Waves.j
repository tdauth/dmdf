/// Wizard
library StructSpellsSpellMagicalShockWaves requires Asl, StructGameClasses, StructGameSpell

	/**
	* Gegeben:
	* Name					Variiert pro Stufe
	* Umkreis				Nein
	* Zeit					Nein
	* prozentualer Schadensanteil		Ja
	*/
	/// Gegner im Umkreis von 600, die über kein Mana verfügen, erleiden 30 Sekunden lang X % mehr Schaden. Gegner mit Mana erleiden Y % Schaden, das anhand des maximalen Manas der Einheit berechnet wird.
	struct SpellMagicalShockWaves extends Spell
		public static constant integer abilityId = 'A05W'
		public static constant integer favouriteAbilityId = 'A05X'
		public static constant integer classSelectionAbilityId = 'A100'
		public static constant integer classSelectionGrimoireAbilityId = 'A105'
		public static constant integer maxLevel = 5
		private static constant real range = 600.0
		private static constant real time = 30.0
		private static constant real damagePercentageStartValueMana = 4.0
		private static constant real damagePercentageLevelValueMana = 2.0
		private static constant real damagePercentageStartValue = 5.0
		private static constant real damagePercentageLevelValue = 10.0

		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local thistype this
			local unit caster
			local unit target
			local real damage
			if (DmdfHashTable.global().hasInteger("SpellMagicalShockWaves:" + I2S(damageRecorder), "this")) then
				set this = DmdfHashTable.global().integer("SpellMagicalShockWaves:" + I2S(damageRecorder), "this")
				if (this != 0) then
					set caster = this.character().unit()
					set target = damageRecorder.target()
					if (GetUnitState(target, UNIT_STATE_MAX_MANA) > 0.0) then
						set damage = GetUnitState(target, UNIT_STATE_MAX_MANA) * ((thistype.damagePercentageStartValueMana + this.level() * thistype.damagePercentageLevelValueMana) / 100.0)
					else
						set damage = GetEventDamage() * ((thistype.damagePercentageStartValue + this.level() * thistype.damagePercentageLevelValue) / 100.0)
					endif
					/*
					 * Disable to prevent endless events.
					 */
					call damageRecorder.disable()
					call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC)
					call damageRecorder.enable()
					call ShowBashTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(damage))
					set caster = null
					set target = null
				debug else
					debug call Print("Magical Shock Waves: this is 0")
				endif
			debug else
				debug call Print("Magical Shock Waves: no attached value")
			endif
		endmethod
		
		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit)
			set filterUnit = null
			return result
		endmethod
		
		/**
		 * \return Returns a newly created group instance with all valid targets.
		 */
		private method targets takes nothing returns AGroup
			local unit caster = this.character().unit()
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets = AGroup.create()
			call GroupEnumUnitsInRange(targetGroup, GetUnitX(caster), GetUnitY(caster), thistype.range, filter)
			call targets.addGroup(targetGroup, true, false)
			set targetGroup = null
			call targets.removeAlliesOfUnit(caster)
			set caster = null
			call DestroyFilter(filter)
			set filter = null
			return targets
		endmethod
		
		private method condition takes nothing returns boolean
			local AGroup targets = this.targets()
			local boolean result
			debug call Print("Before removing allies: " + I2S(targets.units().size()))
			set result = not targets.units().empty()
			call targets.destroy()
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Keine gültigen Ziele in der Nähe.", "No valid targets in range."))
			endif
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local AGroup targets = this.targets()
			local AIntegerVector damageRecorders
			local ADamageRecorder damageRecorder
			local integer i
			local unit target
			local real time
			local real angle
			local terraindeformation array terrainDeformation
			if (not targets.units().empty()) then
				set damageRecorders = AIntegerVector.create()
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units()[i]
					debug call Print("Creating damage recorder for unit " + GetUnitName(target))
					set damageRecorder = ADamageRecorder.create(target)
					call DmdfHashTable.global().setInteger("SpellMagicalShockWaves:" + I2S(damageRecorder), "this", this)
					call damageRecorder.setOnDamageAction(thistype.onDamageAction)
					call damageRecorders.pushBack(damageRecorder)
					set target = null
					set i = i + 1
				endloop

				set time = thistype.time
				loop
					exitwhen (time <= 0.0 or targets.units().empty() or IsUnitDeadBJ(caster))
					call TriggerSleepAction(1.0)
					/*
					 * Check all targets and filter out invalid targets.
					 */
					set i = 0
					loop
						exitwhen (i == targets.units().size())
						set target = targets.units()[i]
						if (ASpell.enemyTargetLoopCondition(target)) then
							debug call Print("Target dropped out: " + GetUnitName(target))
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