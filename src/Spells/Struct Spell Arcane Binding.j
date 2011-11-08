/// Wizard
library StructSpellsSpellArcaneBinding requires Asl, StructGameClasses, StructGameSpell

	/// Alle Gegner in einem Umkreis von X Metern werden für Y Sekunden an Ort und Stelle festgewurzelt.
	struct SpellArcaneBinding extends Spell
		public static constant integer abilityId = 'A05M'
		public static constant integer favouriteAbilityId = 'A05N'
		public static constant integer maxLevel = 5
		private static constant integer buffId = 0 /// @todo FIXME
		private static constant real rangeStartValue = 600.0
		private static constant real rangeLevelValue = 100.0
		private static constant real timeStartValue = 5.0
		private static constant real timeLevelValue = 2.0

		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit)
			set filterUnit = null
			return result
		endmethod

		/// @todo Buff should contain target effect or add target effects manually.
		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets = AGroup.create()
			local integer i
			local unit target
			local real time
			call GroupEnumUnitsInRange(targetGroup, GetUnitX(caster), GetUnitY(caster), thistype.rangeStartValue + this.level() * thistype.rangeLevelValue, filter)
			call targets.addGroup(targetGroup, true, false) // destroys group
			call GroupClear(targetGroup)
			if (not targets.units().empty()) then
				call targets.removeAlliesOfUnit(caster)
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units()[i]
					call PauseUnit(target, true)
					/// @todo Add buff.
					set i = i + 1
				endloop
				set time = thistype.timeStartValue + this.level() * thistype.timeLevelValue
				loop
					exitwhen (time <= 0.0 or targets.units().empty())
					call TriggerSleepAction(1.0)
					set i = 0
					loop
						exitwhen (i == targets.units().size())
						set target = targets.units()[i]
						if (ASpell.enemyTargetLoopCondition(target)) then
							call PauseUnit(target, false)
							/// @todo Remove buff.
							call targets.units().erase(i)
						else
							set i = i + 1
						endif
						set target = null
					endloop
					set time = time - 1.0
				endloop
			debug else
				debug call Print("No targets.")
			endif
			set caster = null
			call DestroyFilter(filter)
			set filter = null
			loop
				exitwhen (targets.units().empty())
				set target = targets.units().back()
				call PauseUnit(target, false)
				/// @todo Remove buff.
				call targets.units().popBack()
			endloop
			call targets.destroy()
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary