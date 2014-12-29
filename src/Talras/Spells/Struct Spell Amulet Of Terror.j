library StructMapSpellsSpellAmuletOfTerror requires Asl

	/**
	* Einheiten im Umkreis werden durch Feinde nicht mehr alamiert und greifen diese daher nicht einfach an.
	* Gilt nicht für Gebäude!
	*/
	struct SpellAmuletOfTerror extends ASpell
		public static constant integer abilityId = 'A062'
		private static constant real range = 1200.0
		private static constant real time = 10.0

		private static method filter takes nothing returns boolean
			return not IsUnitDeadBJ(GetFilterUnit()) and not IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE)
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local filterfunc filter = Filter(function thistype.filter)
			local group whichGroup = CreateGroup()
			local AGroup unitGroup = AGroup.create()
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "chest")
			local integer i
			call GroupEnumUnitsInRange(whichGroup, GetUnitX(caster), GetUnitY(caster), thistype.range, filter)
			call unitGroup.addGroup(whichGroup, true, false)
			call unitGroup.removeAlliesOfUnit(caster)
			set caster = null
			set whichGroup = null
			debug call Print("Amulet of Terror (no deads, no structures): " + I2S(unitGroup.units().size()) + " enemies.")
			set i = 0
			loop
				exitwhen (i == unitGroup.units().size())
				if (UnitIgnoreAlarmToggled(unitGroup.units()[i])) then
					call unitGroup.units().erase(i)
				else
					debug call Print("Unit " + GetUnitName(unitGroup.units()[i]) + " ignores alarm.")
					call UnitIgnoreAlarm(unitGroup.units()[i], true)
					set i = i + 1
				endif
			endloop
			call TriggerSleepAction(thistype.time)
			loop
				exitwhen (unitGroup.units().empty())
				debug call Print("Unit " + GetUnitName(unitGroup.units()[i]) + " recognizes alarm.")
				call UnitIgnoreAlarm(unitGroup.units().back(), false)
				call unitGroup.units().popBack()
			endloop
			call DestroyFilter(filter)
			set filter = null
			call unitGroup.destroy()
			call DestroyEffect(casterEffect)
			set casterEffect = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, 0, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

endlibrary