library StructSpellsSpellScrollOfAncestors requires Asl, StructGameShrine, StructSpellsSpellScrollOfTheRealmOfTheDead

	/**
	 * This scroll is similar to \ref ScrollOfTheRealmOfTheDead but teleports multiple allied units to a shrine.
	 */
	struct SpellScrollOfAncestors extends ASpell
		public static constant integer abilityId = 'A19H'
		public static constant real rangeOfAllies = 700.0
		public static constant integer maximumAllies = 12

		// http://www.hiveworkshop.com/forums/triggers-scripts-269/does-getspelltargetx-y-work-177175/
		// GetSpellTargetX() etc. does not work in conditions but in actions?
		private method condition takes nothing returns boolean
			local Shrine shrine = SpellScrollOfTheRealmOfTheDead.getNearestShrine(this.character().player(), GetSpellTargetX(), GetSpellTargetY())

			if (shrine == 0) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel-Punkt muss sich in der Nähe eines erkundeten Wiederbelebungsschreins befinden.", "Target location has to be in the range of a discovered revival shrine."))
				debug call Print("Return false")

				return false
			endif

			return true
		endmethod

		private static method filter takes nothing returns boolean
			return not IsUnitType(GetFilterUnit(), UNIT_TYPE_MECHANICAL) and GetOwningPlayer(GetFilterUnit()) != MapSettings.neutralPassivePlayer() and not MapSettings.isUnitTypeIdExcludedFromTeleports(GetUnitTypeId(GetFilterUnit()))
		endmethod

		private static method removeEffect takes effect whichEffect returns nothing
			call DestroyEffect(whichEffect)
		endmethod

		private method action takes nothing returns nothing
			local Shrine shrine = SpellScrollOfTheRealmOfTheDead.getNearestShrine(this.character().player(), GetSpellTargetX(), GetSpellTargetY())
			local real x = GetRectCenterX(shrine.revivalRect())
			local real y = GetRectCenterY(shrine.revivalRect())
			local unit caster = this.character().unit()
			local AGroup whichGroup = AGroup.create()
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "origin")
			local effect targetEffect = AddSpellEffectById(thistype.abilityId, EFFECT_TYPE_TARGET, x, y)
			local AEffectVector casterEffects = AEffectVector.create()
			local integer i = 0
			debug call Print("Spell Scroll Of The Realm! at pos " + R2S(x) + " | " + R2S(y))
			call whichGroup.addUnitsInRange(GetUnitX(caster), GetUnitY(caster), thistype.rangeOfAllies, Filter(function thistype.filter))
			call thistype.removeEnemiesOfUnitNewOpLimit.evaluate(whichGroup, caster) // Use a new OpLimit for safety.
			// Caster is moved separately.
			call whichGroup.units().remove(caster)
			debug call Print("Remaining units: " + I2S(whichGroup.units().size()))

			set i = 0
			loop
				exitwhen (i == whichGroup.units().size())
				/*
				 * Only leave allies with shared control.
				 */
				if (GetOwningPlayer(whichGroup.units()[i]) != GetOwningPlayer(caster) and not GetPlayerAlliance(GetOwningPlayer(whichGroup.units()[i]), GetOwningPlayer(caster), ALLIANCE_SHARED_CONTROL)) then
					call whichGroup.units().erase(i)
				else
					set i = i + 1
				endif
			endloop

			set i = 0
			loop
				exitwhen (i == thistype.maximumAllies or i == whichGroup.units().size())
				call casterEffects.pushBack(AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, whichGroup.units()[i], "chest"))
				call SetUnitPosition(whichGroup.units()[i], x, y)
				set i = i + 1
			endloop
			call whichGroup.destroy()
			set whichGroup = 0

			// Move caster separately.
			call SetUnitPosition(caster, x, y)
			call TriggerSleepAction(0.0)
			call IssueImmediateOrder(caster, "stop")
			set caster = null
			call DestroyEffect(casterEffect)
			set casterEffect = null
			call DestroyEffect(targetEffect)
			set targetEffect = null
			call casterEffects.forEach(thistype.removeEffect)
			call casterEffects.destroy()
		endmethod

		private static method removeEnemiesOfUnitNewOpLimit takes AGroup whichGroup , unit whichUnit returns nothing
			call whichGroup.removeEnemiesOfUnit(whichUnit)
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL, false, true)
		endmethod
	endstruct

endlibrary