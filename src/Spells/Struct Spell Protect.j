/// Cleric
library StructSpellsSpellProtect requires Asl, StructGameClasses, StructGameSpell

	/**
	* Ein befreundetes Ziel erleidet X% weniger Schaden. Kanalisierter Zauber. Max. 10 Sekunden.
	* Mittelmäßig viel, soll kein Notknopf sein.
	*/
	struct SpellProtect extends Spell
		public static constant integer abilityId = 'A050'
		public static constant integer favouriteAbilityId = 'A051'
		public static constant integer maxLevel = 5
		private static constant real damageLevelValue = 0.20
		private static constant real damageLevelFactor = 0.10
		private static constant real time = 10.0

		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local unit target = damageRecorder.target()
			local real damage = GetEventDamage() * DmdfHashTable.global().real("SpellProtect" + I2S(damageRecorder), "damage")
			call SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE) + damage)
			call Spell.showDamageAbsorbationTextTag(target, damage)
			set target = null
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local real damage = thistype.damageLevelValue + this.level() * thistype.damageLevelFactor
			local real time = thistype.time
			local ADamageRecorder damageRecorder = ADamageRecorder.create(target)
			call damageRecorder.setOnDamageAction(thistype.onDamageAction)
			call DmdfHashTable.global().setReal("SpellProtect" + I2S(damageRecorder), "damage", damage)
			loop
				exitwhen (time <= 0.0 or ASpell.allyChannelLoopCondition(caster) or ASpell.allyTargetLoopCondition(target))
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			call DmdfHashTable.global().removeReal("SpellProtect" + I2S(damageRecorder), "damage")
			call damageRecorder.destroy()
			set caster = null
			set target = null
		endmethod

		public static method create takes ACharacter character returns thistype
			return thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary