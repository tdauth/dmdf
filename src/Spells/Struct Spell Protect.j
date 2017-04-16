/// Cleric
library StructSpellsSpellProtect requires Asl, StructGameClasses, StructGameSpell

	/**
	 * Ein befreundetes Ziel erleidet X% weniger Schaden. Kanalisierter Zauber. Max. 10 Sekunden.
	 * Mittelmäßig viel, soll kein Notknopf sein.
	 */
	struct SpellProtect extends Spell
		public static constant integer abilityId = 'A050'
		public static constant integer favouriteAbilityId = 'A051'
		public static constant integer classSelectionAbilityId = 'A1MZ'
		public static constant integer classSelectionGrimoireAbilityId = 'A1N0'
		public static constant integer maxLevel = 5
		private static constant real damageLevelValue = 0.15
		private static constant real damageLevelFactor = 0.05
		private static constant real time = 10.0

		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local unit target = damageRecorder.target()
			local real damage = GetEventDamage() * DmdfGlobalHashTable.global().real(DMDF_HASHTABLE_GLOBAL_KEY_DAMAGERECORDER, damageRecorder)
			call SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE) + damage)
			call Spell.showDamageAbsorbationTextTag(target, damage)
			set target = null
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local real damage = thistype.damageLevelValue + this.level() * thistype.damageLevelFactor
			local real time = thistype.time
			local effect targetEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET,  target, "chest")
			local ADynamicLightning whichLightning = ADynamicLightning.create(null, "HWPB", caster, target)
			local ADamageRecorder damageRecorder = ADamageRecorder.create(target)
			call damageRecorder.setOnDamageAction(thistype.onDamageAction)
			call DmdfGlobalHashTable.global().setReal(DMDF_HASHTABLE_GLOBAL_KEY_DAMAGERECORDER, damageRecorder, damage)
			loop
				exitwhen (time <= 0.0 or AUnitSpell.allyChannelLoopCondition(caster) or AUnitSpell.allyTargetLoopCondition(target) or GetUnitCurrentOrder(caster) != OrderId("ambush"))
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			call DmdfGlobalHashTable.global().removeReal(DMDF_HASHTABLE_GLOBAL_KEY_DAMAGERECORDER, damageRecorder)
			call damageRecorder.destroy()
			call whichLightning.destroy()
			call DestroyEffect(targetEffect)
			set targetEffect = null
			set caster = null
			set target = null
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A1MZ', 'A1N0')
			call this.addGrimoireEntry('A091', 'A0LE')
			call this.addGrimoireEntry('A0LA', 'A0LF')
			call this.addGrimoireEntry('A0LB', 'A0LG')
			call this.addGrimoireEntry('A0LC', 'A0LH')
			call this.addGrimoireEntry('A0LD', 'A0LI')

			return this
		endmethod
	endstruct

endlibrary