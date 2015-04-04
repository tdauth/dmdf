/// Cleric
library StructSpellsSpellPreventIll requires Asl, StructGameClasses, StructGameSpell

	/**
	 * Kann auf Untote und Dämonen angewandt werden und verlangsamt ihre Bewegungs- und Angriffsgeschwindigkeit auf X %. Hält Y Sekunden.
	 */
	struct SpellPreventIll extends Spell
		public static constant integer abilityId = 'A055'
		public static constant integer favouriteAbilityId = 'A054'
		public static constant integer maxLevel = 5
		private static constant real speedStartValue = 0.20
		private static constant real speedLevelValue = 0.10
		private static constant real timeStartValue = 10.0
		private static constant real timeLevelValue = 2.0

		private method condition takes nothing returns boolean
			local unit target = GetSpellTargetUnit()
			local race unitRace = GetUnitRace(target)
			local boolean result = unitRace == RACE_DEMON or IsUnitType(target, UNIT_TYPE_UNDEAD)
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Ziel muss ein Dämon oder Untoter sein."))
			endif
			set target = null
			set unitRace = null
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit target = GetSpellTargetUnit()
			local effect targetEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "chest")
			local real speed = (thistype.speedStartValue + thistype.speedLevelValue * this.level()) * GetUnitMoveSpeed(target)
			local real oldSpeed = GetUnitMoveSpeed(target)
			local real time = thistype.timeStartValue + thistype.timeLevelValue * this.level()
			call SetUnitMoveSpeed(target, speed)
			loop
				exitwhen (time <= 0.0 or ASpell.enemyTargetLoopCondition(target))
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			call SetUnitMoveSpeed(target, oldSpeed)
			set target = null
			call DestroyEffect(targetEffect)
			set targetEffect = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			
			call this.addGrimoireEntry('A0QN', 'A0QS')
			call this.addGrimoireEntry('A0QO', 'A0QT')
			call this.addGrimoireEntry('A0QP', 'A0QU')
			call this.addGrimoireEntry('A0QQ', 'A0QV')
			call this.addGrimoireEntry('A0QR', 'A0QW')
			
			return this
		endmethod
	endstruct

endlibrary