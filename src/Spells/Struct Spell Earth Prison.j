/// Elemental Mage
library StructSpellsSpellEarthPrison requires Asl, StructGameClasses, StructGameSpell

	/**
	* Der Elementarmagier schließt einen Gegner bis zu X Sekunden in einem Erdgefängnis ein. In dieser Zeit kann er nicht agieren. Das Gefängnis entfernt alle negativen Effekte auf dem Ziel und wird durch Schaden gebrochen.
	*/
	struct SpellEarthPrison extends Spell
		public static constant integer abilityId = 'A01H'
		public static constant integer favouriteAbilityId = 'A03I'
		public static constant integer classSelectionAbilityId = 'A1KD'
		public static constant integer classSelectionGrimoireAbilityId = 'A1KE'
		public static constant integer maxLevel = 5
		public static constant integer buffId = 'B005'
		private static constant real timeStartValue = 1.5
		private static constant real timeLevelValue = 0.5 // Zeit-Stufenfaktor (ab Stufe 1)

		private method action takes nothing returns nothing
			local unit target = GetSpellTargetUnit()
			local ADamageRecorder damageRecorder
			local real time = thistype.timeStartValue + thistype.timeLevelValue * this.level()
			local effect targetEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "overhead")
			call UnitRemoveBuffs(target, false, true)
			call PauseUnit(target, true)
			call UnitAddAbility(target, thistype.buffId)
			call UnitMakeAbilityPermanent(target, true, thistype.buffId)
			set damageRecorder = ADamageRecorder.create(target)
			loop
				exitwhen (time <= 0.0 or ASpell.enemyTargetLoopCondition(target) or damageRecorder.totalDamage() > 0.0)
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			call UnitRemoveAbility(target, thistype.buffId)
			call damageRecorder.destroy()
			call PauseUnit(target, false)
			call DestroyEffect(targetEffect)
			set targetEffect = null
			set target = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			
			call this.addGrimoireEntry('A1KD', 'A1KE')
			call this.addGrimoireEntry('A0ZA', 'A0ZF')
			call this.addGrimoireEntry('A0ZB', 'A0ZG')
			call this.addGrimoireEntry('A0ZC', 'A0ZH')
			call this.addGrimoireEntry('A0ZD', 'A0ZI')
			call this.addGrimoireEntry('A0ZE', 'A0ZJ')
			
			return this
		endmethod
	endstruct

endlibrary