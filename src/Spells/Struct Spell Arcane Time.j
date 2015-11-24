/// Wizard
library StructSpellsSpellArcaneTime requires Asl, StructGameClasses, StructGameSpell

	/**
	* Entfernt nach X Sekunden alle negativen Zauberverstärker eines Verbündeten oder alle positiven Zauberverstärker eines Gegners. Setzt die Dauer beschworener Verbündeter auf Y Sekunden oder beschworener Gegner auf Z Sekunden. Die Abklingzeit nimmt mit der Stufe ab.
	*/
	struct SpellArcaneTime extends Spell
		public static constant integer abilityId = 'A08V'
		public static constant integer favouriteAbilityId = 'A08W'
		public static constant integer classSelectionAbilityId = 'A10M'
		public static constant integer classSelectionGrimoireAbilityId = 'A10R'
		public static constant integer maxLevel = 5
		private static constant real summonedTimeStartValue = 40.0
		private static constant real summonedTimeLevelValue = 10.0
		private static constant real summonedRemovalTimeStartValue = 25.0
		private static constant real summonedRemovalTimeLevelValue = -5.0
		private static constant real timeStartValue = 30.0
		private static constant real timeLevelValue = -5.0
		
		private method condition takes nothing returns boolean
			if (IsUnitType(GetSpellTargetUnit(), UNIT_TYPE_SUMMONED)) then
				return true
			elseif (GetUnitAllianceStateToUnit(this.character().unit(), GetSpellTargetUnit()) == bj_ALLIANCE_UNALLIED) then
				// TODO all negative magic stuff
				if (UnitHasBuffsEx(GetSpellTargetUnit(), true, false, true, true, false, false, false)) then
					return true
				else
					call this.character().displayMessage(ACharacter.messageTypeError, tre("Gegner hat keine positiven Zauberverstärker.", "Opponent has no positive buffs."))
				endif
			else
				// TODO all positive magic stuff
				if (UnitHasBuffsEx(GetSpellTargetUnit(), false, true, true, true, false, false, false)) then
					return true
				else
					call this.character().displayMessage(ACharacter.messageTypeError, tre("Verbündeter hat keine negativen Zauberverstärker.", "Ally does not have any negative buffs."))
				endif
			endif
			
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel muss eine beschworene Einheit oder eine Einheit mit Zauberverstärkern sein.", "Target has to be a summoned unit or a unit with buffs."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			local real time
			debug call Print("Arcane Time!")
			if (IsUnitType(GetSpellTargetUnit(), UNIT_TYPE_SUMMONED)) then
				if (GetUnitAllianceStateToUnit(this.character().unit(), GetSpellTargetUnit()) == bj_ALLIANCE_UNALLIED) then
					set time = thistype.summonedRemovalTimeStartValue + (thistype.summonedRemovalTimeLevelValue * this.level())
					debug call Print("Arcane Time: Start timer for timed life removal!")
					/// \todo Instead of simply checking for spell resistance add buff and check for buff when time expired
					loop
						exitwhen (time <= 0.0 or thistype.enemyTargetLoopConditionResistant(GetSpellTargetUnit()))
						call TriggerSleepAction(1.0)
						set time = time - 1.0
					endloop
					if (not thistype.enemyTargetLoopConditionResistant(GetSpellTargetUnit())) then
						debug call Print("Arcane Time: Remove timed life!")
						call UnitRemoveBuffsEx(GetSpellTargetUnit(), true, false, false, false, true, false, false) // remove timed life!
					endif
				
				else
					set time = thistype.summonedTimeStartValue + (thistype.summonedTimeLevelValue * this.level())
					debug call Print("Arcane Time: Start pausing timed life!")
					call UnitPauseTimedLife(GetSpellTargetUnit(), true)
					loop
						exitwhen (time <= 0.0 or thistype.allyTargetLoopCondition(GetSpellTargetUnit()))
						call TriggerSleepAction(1.0)
						set time = time - 1.0
					endloop
					debug call Print("Arcane Time: End pausing timed life!")
					if (not thistype.allyTargetLoopCondition(GetSpellTargetUnit())) then
						call UnitPauseTimedLife(GetSpellTargetUnit(), false)
					endif
				endif
			
			else
				debug call Print("Arcane Time: Start of buff spell!")
				set time = thistype.timeStartValue + (thistype.timeLevelValue * this.level())
				if (GetUnitAllianceStateToUnit(this.character().unit(), GetSpellTargetUnit()) == bj_ALLIANCE_UNALLIED) then
					loop
						exitwhen (time <= 0.0 or thistype.enemyTargetLoopConditionResistant(GetSpellTargetUnit()))
						call TriggerSleepAction(1.0)
						debug call Print("Arcane Time: 1 second.")
						set time = time - 1.0
					endloop
					if (not thistype.enemyTargetLoopConditionResistant(GetSpellTargetUnit())) then
						call UnitRemoveBuffs(GetSpellTargetUnit(), true, false)
						debug call Print("Arcane Timer: Remove positive buffs of enemy!")
					debug else
						debug call Print("Arcane Timer: Enemy condition is wrong.")
					endif
				else
					loop
						exitwhen (time <= 0.0 or thistype.allyTargetLoopCondition(GetSpellTargetUnit()))
						call TriggerSleepAction(1.0)
						set time = time - 1.0
					endloop
					if (not thistype.allyTargetLoopCondition(GetSpellTargetUnit())) then
						call UnitRemoveBuffs(GetSpellTargetUnit(), false, true)
						debug call Print("Arcane Timer: Remove negative buffs of ally!")
					debug else
						debug call Print("Arcane Timer: Ally condition is wrong.")
					endif
				endif
			endif
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
	endstruct

endlibrary