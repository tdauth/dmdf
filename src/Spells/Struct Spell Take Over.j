/// Astral Modifier
library StructSpellsSpellTakeOver requires Asl, StructGameClasses, StructGameSpell

	/**
	* Der Astralwandler versetzt sich in die Astralebene, dringt für X Sekunden in den Körper eines Feindes ein und unterwirft ihn seinem Willen. Nach Ablauf des Effekts erleidet der Astralwandler Y % des Schadens, den der übernommene Gegner erlitten hat.
	* Der Gegner darf höchstens die Stufe Z haben.
	* Dauer erhöhen, erlittenen Schaden auf bis zu 60 % verringern.
	* Z errechnet sich aus der Stufe des Charakters + (2 * die Stufe des Zaubers).
	*/
	struct SpellTakeOver extends Spell
		public static constant integer abilityId = 'A01K'
		public static constant integer favouriteAbilityId = 'A044'
		public static constant integer buffId = 'B002'
		public static constant integer maxLevel = 5
		private static constant integer levelFactor = 2
		private static constant real timeFactor = 12.0 // Zeit-Stufenfaktor (ab Stufe 1)
		private static constant real startDamageRatio = 1.0 // Prozentwert des erlittenen Schadens
		private static constant real damageRatioConstant = 0.10 //abzuziehender Stufenfaktor des Prozentwertes (ab Stufe 2)

		private method condition takes nothing returns boolean
			local unit target = GetSpellTargetUnit()
			local integer level =  GetHeroLevel(this.character().unit()) + thistype.levelFactor * this.level()
			local boolean result = GetUnitLevel(target) <= level
			debug call Print("TARGET: " + GetUnitName(target))
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, IntegerArg(tre("Ziel-Einheit darf maximal Stufe %i haben.", "Target unit must have level %i at most."), level))
			elseif (IsUnitSpellResistant(target)) then
				set result = false
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel-Einheit ist zauberressistent", "Target unit is spell resistant."))
			endif
			set target = null
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local player oldUser
			local unit oldUnit
			local real time = this.level() * thistype.timeFactor
			local real facing = GetAngleBetweenUnits(this.character().unit(), target)
			local ADamageRecorder recorder
			local real damage
			//replacement
			call ShowUnit(caster, false)
			call SetUnitInvulnerable(caster, true)
			call PauseUnit(caster, true)
			debug call Print("Caster: " + GetUnitName(caster))
			debug call Print("Target: " + GetUnitName(target))
			set oldUser = GetOwningPlayer(target)
			call SetUnitOwner(target, this.character().player(), true)
			set oldUnit = this.character().unit()
			call this.character().replaceUnit(target)
			call this.character().select(false)
			call UnitApplyTimedLife(target, thistype.buffId, time + 2.0)
			call ShowGeneralFadingTextTagForPlayer(null, tre("Übernehmen!", "Take over!"), GetUnitX(target), GetUnitY(target), 255, 255, 255, 255)
			//wait
			set recorder = ADamageRecorder.create(target)
			debug call Print("After recorder creation")
			loop
				exitwhen (time <= 0.0 or IsUnitDeadBJ(target) or not this.isLearned())
				debug call Print("Loop before sleep action")
				call TriggerSleepAction(1.0)
				debug call Print("Loop after sleep action")
				set time = time - 1.0
			endloop
			call UnitPauseTimedLife(target, true)
			debug call Print("AFFFTTERRR")
			set damage = recorder.totalDamage() * (thistype.startDamageRatio - (this.level() - 1) * thistype.damageRatioConstant)
			call ADamageRecorder.destroy(recorder)
			//replacement
			call this.character().replaceUnit(oldUnit)
			call ShowUnit(caster, true)
			call SetUnitInvulnerable(caster, false)
			call PauseUnit(caster, false)
			call SetUnitXYIfNotBlocked(oldUnit, GetUnitX(target), GetUnitY(target), GetUnitPolarProjectionX(target, facing, 800.0), GetUnitPolarProjectionY(target, facing, 800.0))
			call SetUnitOwner(target, oldUser, true)
			// erlittenen Schaden übernehmen
			if (damage > 0.0) then
				call SetUnitLifeBJ(oldUnit, GetUnitState(oldUnit, UNIT_STATE_LIFE) - damage)
				call thistype.showDamageTextTag(oldUnit, damage)
			endif
			set caster = null
			set target = null
			set oldUser = null
			set oldUnit = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.astralModifier(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
		endmethod
	endstruct

endlibrary
