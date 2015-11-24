library StructMapSpellsSpellScrollOfAncestors requires Asl, StructMapMapMapData

	/**
	 * This scroll is similar to \ref ScrollOfTheRealmOfTheDead but teleports multiple allied units to a shrine.
	 */
	struct SpellScrollOfAncestors extends ASpell
		public static constant integer abilityId = 'A19H'
		public static constant real distance = 400.0

		// http://www.hiveworkshop.com/forums/triggers-scripts-269/does-getspelltargetx-y-work-177175/
		// GetSpellTargetX() etc. does not work in conditions but in actions?
		private method condition takes nothing returns boolean
			local integer i
			local Shrine shrine
			local real dist
			local boolean result = false
			if (IsMaskedToPlayer(GetSpellTargetX(), GetSpellTargetY(), this.character().player())) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel-Punkt muss sichtbar sein.", "Target location has to be visible."))
				return false
			endif
			set i = 0
			loop
				exitwhen (i == Shrine.shrines().size())
				set shrine = Shrine(Shrine.shrines()[i])
				set dist = GetDistanceBetweenPointsWithoutZ(GetRectCenterX(shrine.revivalRect()), GetRectCenterY(shrine.revivalRect()), GetSpellTargetX(), GetSpellTargetY())
				if (dist <= thistype.distance) then
					set result = true
				endif
				set i = i + 1
			endloop
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel-Punkt muss sich in der Nähe eines Wiederbelebungsschreins befinden.", "Target location has to be in the range of a revival shrine."))
			endif
			return result
		endmethod
		
		private static method filter takes nothing returns boolean
			return not IsUnitType(GetFilterUnit(), UNIT_TYPE_MECHANICAL) and GetOwningPlayer(GetFilterUnit()) != MapData.neutralPassivePlayer
		endmethod
		
		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local AGroup whichGroup = AGroup.create()
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "chest")
			local effect targetEffect = AddSpellEffectById(thistype.abilityId, EFFECT_TYPE_TARGET, GetSpellTargetX(), GetSpellTargetY())
			local integer i = 0
			debug call Print("Spell Scroll Of The Realm!")
			call whichGroup.addUnitsInRange(GetUnitX(caster), GetUnitY(caster), 700.0, Filter(function thistype.filter))
			call whichGroup.removeEnemiesOfUnit(caster)
			call whichGroup.units().remove(caster)
			
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
				exitwhen (i == 12 or i == whichGroup.units().size())
				call SetUnitPosition(whichGroup.units()[i], GetSpellTargetX(), GetSpellTargetY())
				set i = i + 1
			endloop
			call whichGroup.destroy()
			set whichGroup = 0
			
			call SetUnitPosition(caster, GetSpellTargetX(), GetSpellTargetY())
			call TriggerSleepAction(0.0)
			call IssueImmediateOrder(caster, "stop")
			set caster = null
			call DestroyEffect(casterEffect)
			set casterEffect = null
			call DestroyEffect(targetEffect)
			set targetEffect = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

endlibrary