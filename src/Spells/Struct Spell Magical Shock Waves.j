/// Wizard
library StructSpellsSpellMagicalShockWaves requires Asl, StructGameClasses, StructGameSpell

	private struct Buff
		private unit m_target
		private ADamageRecorder m_damageRecorder
		private effect m_effect
		private ADynamicLightning m_lightning
		private sound m_sound

		public method target takes nothing returns unit
			return this.m_target
		endmethod

		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local SpellMagicalShockWaves this
			local unit caster
			local unit target
			local real damage
			if (DmdfGlobalHashTable.global().hasInteger(DMDF_HASHTABLE_GLOBAL_KEY_DAMAGERECORDER, damageRecorder)) then
				set this = DmdfGlobalHashTable.global().integer(DMDF_HASHTABLE_GLOBAL_KEY_DAMAGERECORDER, damageRecorder)
				if (this != 0) then
					set caster = this.character().unit()
					set target = damageRecorder.target()
					if (GetUnitState(target, UNIT_STATE_MAX_MANA) > 0.0) then
						set damage = GetUnitState(target, UNIT_STATE_MAX_MANA) * ((SpellMagicalShockWaves.damagePercentageStartValueMana + this.level() * SpellMagicalShockWaves.damagePercentageLevelValueMana) / 100.0)
					else
						set damage = GetEventDamage() * ((SpellMagicalShockWaves.damagePercentageStartValue + this.level() * SpellMagicalShockWaves.damagePercentageLevelValue) / 100.0)
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

		public static method create takes Spell spell, unit caster, unit target, real time returns thistype
			local thistype this = thistype.allocate()
			set this.m_target = target
			debug call Print("Creating damage recorder for unit " + GetUnitName(target))
			set this.m_damageRecorder = ADamageRecorder.create(target)
			call DmdfGlobalHashTable.global().setInteger(DMDF_HASHTABLE_GLOBAL_KEY_DAMAGERECORDER, this.m_damageRecorder, this)
			call this.m_damageRecorder.setOnDamageAction(thistype.onDamageAction)
			set this.m_effect = AddSpellEffectTargetById(SpellMagicalShockWaves.abilityId, EFFECT_TYPE_TARGET, target, "origin")
			set this.m_lightning = ADynamicLightning.create(null, "DRAM", caster, target)
			set this.m_sound = CreateSound("Abilities\\Spells\\Other\\Drain\\SiphonManaLoop.wav", true, false, true, 12700, 12700, "")
			call SetSoundChannel(this.m_sound, GetHandleId(SOUND_VOLUMEGROUP_SPELLS))
			call PlaySoundOnUnitBJ(this.m_sound, 100.0, target)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call DmdfGlobalHashTable.global().removeInteger(DMDF_HASHTABLE_GLOBAL_KEY_DAMAGERECORDER, this.m_damageRecorder)
			call this.m_damageRecorder.destroy()
			call DestroyEffect(this.m_effect)
			set this.m_effect = null
			call this.m_lightning.destroy()
			call StopSound(this.m_sound, true, false)
			set this.m_sound = null
		endmethod

	endstruct

	struct SpellMagicalShockWaves extends Spell
		public static constant integer abilityId = 'A05W'
		public static constant integer favouriteAbilityId = 'A05X'
		public static constant integer classSelectionAbilityId = 'A1M7'
		public static constant integer classSelectionGrimoireAbilityId = 'A1M8'
		public static constant integer maxLevel = 5
		public static constant real range = 600.0
		public static constant real time = 30.0
		public static constant real damagePercentageStartValueMana = 4.0
		public static constant real damagePercentageLevelValueMana = 2.0
		public static constant real damagePercentageStartValue = 5.0
		public static constant real damagePercentageLevelValue = 10.0
		private static sound castSound

		private static method filter takes nothing returns boolean
			return not IsUnitDeadBJ(GetFilterUnit()) and not IsUnitType(GetFilterUnit(), UNIT_TYPE_MECHANICAL) // don't include mechanical boxes
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
			local AIntegerList buffs = 0
			local AIntegerListIterator iterator = 0
			local integer i
			local unit target
			local real time = thistype.time
			call PlaySoundOnUnitBJ(thistype.castSound, 100.0, caster)
			if (not targets.units().empty()) then
				set buffs = AIntegerList.create()
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					call buffs.pushBack(Buff.create(this, caster, targets.units()[i], thistype.time))
					set i = i + 1
				endloop

				loop
					exitwhen (time <= 0.0 or targets.units().empty() or IsUnitDeadBJ(caster))
					call TriggerSleepAction(1.0)
					/*
					 * Check all targets and filter out invalid targets.
					 */
					set iterator = buffs.begin()
					loop
						exitwhen (not iterator.isValid())
						if (AUnitSpell.enemyTargetLoopCondition(Buff(iterator.data()).target())) then
							debug call Print("Target dropped out: " + GetUnitName(Buff(iterator.data()).target()))
							call Buff(iterator.data()).destroy()
							set iterator = buffs.erase(iterator)
						else
							call iterator.next()
						endif
					endloop
					call iterator.destroy()
					set time = time - 1.0
				endloop

				set iterator = buffs.begin()
				loop
					exitwhen (not iterator.isValid())
					call Buff(iterator.data()).destroy()
					call iterator.next()
				endloop
				call iterator.destroy()
			endif
			set caster = null
			call targets.destroy()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A1M7', 'A1M8')
			call this.addGrimoireEntry('A100', 'A105')
			call this.addGrimoireEntry('A101', 'A106')
			call this.addGrimoireEntry('A102', 'A107')
			call this.addGrimoireEntry('A103', 'A108')
			call this.addGrimoireEntry('A104', 'A109')

			return this
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.castSound = CreateSound("Abilities\\Spells\\Other\\Drain\\SiphonMana.wav", false, false, true, 12700, 12700, "")
			call SetSoundChannel(thistype.castSound, GetHandleId(SOUND_VOLUMEGROUP_SPELLS))
		endmethod
	endstruct

endlibrary