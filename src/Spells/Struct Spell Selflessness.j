/// Knight
library StructSpellsSpellSelflessness requires Asl, StructGameClasses, StructGameDmdfHashTable, StructGameSpell

	/// Der Ritter kann sich mit einem Verbündeten verbinden, und erleidet 15 Sekunden lang 160% dessen erlittenen Schadens. Der Verbündete erleidet während dieser Zeit 60% weniger Schaden. Der Effekt kann nicht unterbrochen werden. 5 Minuten Abklingzeit.
	struct SpellSelflessness extends Spell
		public static constant integer abilityId = 'A073'
		public static constant integer favouriteAbilityId = 'A074'
		public static constant integer classSelectionAbilityId = 'A1NP'
		public static constant integer classSelectionGrimoireAbilityId = 'A1NQ'
		public static constant integer maxLevel = 5
		// TODO base buff on slow aura tornado ability
		private static constant integer casterBuffId = 'B014'
		private static constant integer targetBuffId = 'B013'
		private static constant integer time = 15 // 15 seconds
		private static constant real damageBonusFactor = 1.60
		private static constant real damageReductionStartValueFactor = 0.60
		private static constant real damageReductionLevelBonus = 0.10 // ab Stufe 2!
		private static ABuff casterBuff
		private static ABuff targetBuff

		/// @todo Create effect.
		private static method onCasterDamageAction takes ADamageRecorder damageRecorder returns nothing
			local real damage = GetEventDamage() * thistype.damageBonusFactor
			call SetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE, GetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE) - damage)
			call Spell.showLifeCostTextTag(GetTriggerUnit(), damage)
		endmethod

		/// @todo Create effect.
		private static method onTargetDamageAction takes ADamageRecorder damageRecorder returns nothing
			local integer level = Spell(DmdfGlobalHashTable.global().integer(DMDF_HASHTABLE_GLOBAL_KEY_DAMAGERECORDER, damageRecorder)).level()
			local real damage = GetEventDamage() * (thistype.damageReductionStartValueFactor + (level - 1) * thistype.damageReductionLevelBonus)
			call SetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE, GetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE) + damage)
			call Spell.showDamageAbsorbationTextTag(GetTriggerUnit(), damage)
		endmethod

		/// @todo Create lightning.
		private method action takes nothing returns nothing
			local integer casterBuffIndex = thistype.casterBuff.add(GetTriggerUnit(), GetTriggerUnit())
			local integer targetBuffIndex = thistype.targetBuff.add(GetTriggerUnit(), GetSpellTargetUnit())
			local integer counter = 0
			local ADamageRecorder casterDamageRecorder = ADamageRecorder.create(GetTriggerUnit())
			local ADamageRecorder targetDamageRecorder = ADamageRecorder.create(GetSpellTargetUnit())
			call casterDamageRecorder.setSaveData(false)
			call casterDamageRecorder.setOnDamageAction(thistype.onCasterDamageAction)
			call targetDamageRecorder.setSaveData(false)
			call targetDamageRecorder.setOnDamageAction(thistype.onTargetDamageAction)
			call DmdfGlobalHashTable.global().setInteger(DMDF_HASHTABLE_GLOBAL_KEY_DAMAGERECORDER, targetDamageRecorder, this)
			loop
				exitwhen (counter == thistype.time or not ASpell.allyTargetLoopCondition(GetSpellTargetUnit()) or not ASpell.allyTargetLoopCondition(GetTriggerUnit()))
				call TriggerSleepAction(1.0)
				set counter = counter + 1
			endloop
			call casterDamageRecorder.destroy()
			call DmdfGlobalHashTable.global().removeInteger(DMDF_HASHTABLE_GLOBAL_KEY_DAMAGERECORDER, targetDamageRecorder)
			call targetDamageRecorder.destroy()
			call thistype.casterBuff.remove(GetTriggerUnit(), GetTriggerUnit())
			call thistype.targetBuff.remove(GetTriggerUnit(), GetSpellTargetUnit())
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A1NP', 'A1NQ')
			call this.addGrimoireEntry('A0LL', 'A0LQ')
			call this.addGrimoireEntry('A0LM', 'A0LR')
			call this.addGrimoireEntry('A0LN', 'A0LS')
			call this.addGrimoireEntry('A0LO', 'A0LT')
			call this.addGrimoireEntry('A0LP', 'A0LU')

			if (thistype.casterBuff == 0) then
				set thistype.casterBuff = ABuff.create(thistype.casterBuffId)
			endif
			if (thistype.targetBuff == 0) then
				set thistype.targetBuff = ABuff.create(thistype.targetBuffId)
			endif
			return this
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.casterBuff = 0
			set thistype.targetBuff = 0
		endmethod
	endstruct

endlibrary