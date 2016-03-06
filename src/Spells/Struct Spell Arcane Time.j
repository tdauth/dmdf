/// Wizard
library StructSpellsSpellArcaneTime requires Asl, StructGameClasses, StructGameSpell

	/**
	 * Entfernt nach X Sekunden alle negativen Zauberverstärker eines Verbündeten oder alle positiven Zauberverstärker eines Gegners. Setzt die Dauer beschworener Verbündeter auf Y Sekunden oder beschworener Gegner auf Z Sekunden. Die Abklingzeit nimmt mit der Stufe ab.
	 * \note Is an area effect now with a group of targets. Otherwise the spell is too weak.
	 */
	struct SpellArcaneTime extends Spell
		public static constant integer abilityId = 'A08V'
		public static constant integer favouriteAbilityId = 'A08W'
		public static constant integer classSelectionAbilityId = 'A10M'
		public static constant integer classSelectionGrimoireAbilityId = 'A10R'
		public static constant integer positiveBuffAbilityId = 'A1IX'
		public static constant integer negativeBuffAbilityId = 'A1IW'
		public static constant integer maxLevel = 5
		private static constant real radius = 300.0
		private static constant real summonedTimeStartValue = 40.0
		private static constant real summonedTimeLevelValue = 10.0
		private static constant real summonedRemovalTimeStartValue = 25.0
		private static constant real summonedRemovalTimeLevelValue = -5.0
		private static constant real illusionTimeStartValue = 0.0
		private static constant real illusionTimeLevelValue = 5.0
		private static constant real illusionRemovalTimeStartValue = 10.0
		private static constant real illusionRemovalTimeLevelValue = -2.0
		private static constant real timeStartValue = 30.0
		private static constant real timeLevelValue = -5.0
		private static sound whichSound
		
		private static method filter takes nothing returns boolean
			if (IsUnitDeadBJ(GetFilterUnit())) then
				return false
			endif
			
			return true
		endmethod
		
		private method targets takes real x, real y returns AGroup
			local AGroup result = AGroup.create()
			local integer i
			call result.addUnitsInRange(x, y, thistype.radius, Filter(function thistype.filter))
			set i = 0
			loop
				exitwhen (i == result.units().size())
				// can last his illusions longer
				if (GetUnitAbilityLevel(result.units()[i], thistype.positiveBuffAbilityId) == 0 and GetUnitAbilityLevel(result.units()[i], thistype.negativeBuffAbilityId) == 0 and not IsUnitType(result.units()[i], UNIT_TYPE_SUMMONED) and not IsUnitIllusion(result.units()[i]) and ((GetUnitAllianceStateToUnit(this.character().unit(), result.units()[i]) == bj_ALLIANCE_UNALLIED and not UnitHasBuffsEx(result.units()[i], false, true, true, true, false, false, false)) or (GetUnitAllianceStateToUnit(this.character().unit(), result.units()[i]) != bj_ALLIANCE_UNALLIED and not UnitHasBuffsEx(result.units()[i], true, false, true, true, false, false, false)))) then
					call result.units().erase(i)
				else
					set i = i + 1
				endif
			endloop
			
			return result
		endmethod
		
		private method condition takes nothing returns boolean
			local AGroup targets = this.targets(GetSpellTargetX(), GetSpellTargetY())
			local boolean result = not targets.units().isEmpty()
			
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel muss eine beschworene Einheit oder eine Einheit mit Zauberverstärkern sein.", "Target has to be a summoned unit or a unit with buffs."))
			endif
			
			call targets.destroy()
			
			return result
		endmethod
		
		private method removeTimedLifeAfter takes real time, unit target returns nothing
			local effect whichEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "chest")
			call UnitAddAbility(target, thistype.negativeBuffAbilityId)
			call thistype.showTimeTextTag(target, -time)
			debug call Print("Arcane Time: Start timer for timed life removal!")
			/// \todo Instead of simply checking for spell resistance add buff and check for buff when time expired
			loop
				exitwhen (time <= 0.0 or thistype.enemyTargetLoopConditionResistant(target))
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			if (not thistype.enemyTargetLoopConditionResistant(target)) then
				debug call Print("Arcane Time: Remove timed life!")
				call UnitRemoveBuffsEx(target, true, false, false, false, true, false, false) // remove timed life!
			endif
			call UnitRemoveAbility(target, thistype.negativeBuffAbilityId)
			call DestroyEffect(whichEffect)
			set whichEffect = null
		endmethod
		
		private method pauseTimedLifeFor takes real time, unit target returns nothing
			local effect whichEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "chest")
			call UnitAddAbility(target, thistype.positiveBuffAbilityId)
			call thistype.showTimeTextTag(target, time)
			debug call Print("Arcane Time: Start pausing timed life!")
			call UnitPauseTimedLife(target, true)
			loop
				exitwhen (time <= 0.0 or thistype.allyTargetLoopCondition(target))
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			debug call Print("Arcane Time: End pausing timed life!")
			if (not thistype.allyTargetLoopCondition(target)) then
				call UnitPauseTimedLife(target, false)
			endif
			call UnitRemoveAbility(target, thistype.positiveBuffAbilityId)
			call DestroyEffect(whichEffect)
			set whichEffect = null
		endmethod
		
		private method removePositiveBuffsAfter takes real time, unit target returns nothing
			local effect whichEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "chest")
			call UnitAddAbility(target, thistype.negativeBuffAbilityId)
			call thistype.showTimeTextTag(target, -time)
			loop
				exitwhen (time <= 0.0 or thistype.enemyTargetLoopConditionResistant(target))
				call TriggerSleepAction(1.0)
				debug call Print("Arcane Time: 1 second.")
				set time = time - 1.0
			endloop
			if (not thistype.enemyTargetLoopConditionResistant(target)) then
				call UnitRemoveBuffs(target, true, false)
				debug call Print("Arcane Timer: Remove positive buffs of enemy!")
			debug else
				debug call Print("Arcane Timer: Enemy condition is wrong.")
			endif
			call UnitRemoveAbility(target, thistype.negativeBuffAbilityId)
			call DestroyEffect(whichEffect)
			set whichEffect = null
		endmethod
		
		private method removeNegativeBuffsAfter takes real time, unit target returns nothing
			local effect whichEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "chest")
			call UnitAddAbility(target, thistype.positiveBuffAbilityId)
			call thistype.showTimeTextTag(target, time)
			loop
				exitwhen (time <= 0.0 or thistype.allyTargetLoopCondition(target))
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			if (not thistype.allyTargetLoopCondition(target)) then
				call UnitRemoveBuffs(target, false, true)
				debug call Print("Arcane Timer: Remove negative buffs of ally!")
			debug else
				debug call Print("Arcane Timer: Ally condition is wrong.")
			endif
			call UnitRemoveAbility(target, thistype.positiveBuffAbilityId)
			call DestroyEffect(whichEffect)
			set whichEffect = null
		endmethod
		
		private method action takes nothing returns nothing
			local AGroup targets = this.targets(GetSpellTargetX(), GetSpellTargetY())
			local unit target
			local real time
			local integer i
			debug call Print("Arcane Time!")
			if (not targets.units().isEmpty()) then
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units()[i]
					call PlaySoundOnUnitBJ(thistype.whichSound, 100.0, target)
					if (IsUnitType(target, UNIT_TYPE_SUMMONED)) then
						if (GetUnitAllianceStateToUnit(this.character().unit(), target) == bj_ALLIANCE_UNALLIED) then
							set time = thistype.summonedRemovalTimeStartValue + (thistype.summonedRemovalTimeLevelValue * this.level())
							call this.removeTimedLifeAfter.execute(time, target)
						
						else
							set time = thistype.summonedTimeStartValue + (thistype.summonedTimeLevelValue * this.level())
							call this.pauseTimedLifeFor.execute(time, target)
						endif
					elseif (IsUnitIllusion(target)) then
						if (GetUnitAllianceStateToUnit(this.character().unit(), target) == bj_ALLIANCE_UNALLIED) then
							set time = thistype.illusionRemovalTimeStartValue + (thistype.illusionRemovalTimeLevelValue * this.level())
							call this.removeTimedLifeAfter.execute(time, target)
						
						else
							set time = thistype.illusionTimeStartValue + (thistype.illusionTimeLevelValue * this.level())
							call this.pauseTimedLifeFor.execute(time, target)
						endif
					else
						debug call Print("Arcane Time: Start of buff spell!")
						set time = thistype.timeStartValue + (thistype.timeLevelValue * this.level())
						if (GetUnitAllianceStateToUnit(this.character().unit(), GetSpellTargetUnit()) == bj_ALLIANCE_UNALLIED) then
							call this.removePositiveBuffsAfter.execute(time, target)
						else
							call this.removeNegativeBuffsAfter.execute(time, target)
						endif
					endif
					set target = null
					set i = i + 1
				endloop
			endif
			call targets.destroy()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A10M', 'A10R')
			call this.addGrimoireEntry('A10N', 'A10S')
			call this.addGrimoireEntry('A10O', 'A10T')
			call this.addGrimoireEntry('A10P', 'A10U')
			call this.addGrimoireEntry('A10Q', 'A10V')
			
			return this
		endmethod
		
		private static method onInit takes nothing returns nothing
			set thistype.whichSound = CreateSound("Abilities\\Spells\\Undead\\ReplenishMana\\SpiritTouch.wav", false, false, true, 12700, 12700, "")
		endmethod
	endstruct

endlibrary