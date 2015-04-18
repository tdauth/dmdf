library StructMapSpellsSpellScrollOfTheRealmOfTheDead requires Asl, StructMapMapMapData

	struct SpellScrollOfTheRealmOfTheDead extends ASpell
		public static constant integer abilityId = 'A066'
		public static constant real distance = 400.0

		// http://www.hiveworkshop.com/forums/triggers-scripts-269/does-getspelltargetx-y-work-177175/
		// GetSpellTargetX() etc. does not work in conditions but in actions?
		private method condition takes nothing returns boolean
			local integer i
			local Shrine shrine
			local real dist
			local boolean result = false
			if (IsMaskedToPlayer(GetSpellTargetX(), GetSpellTargetY(), this.character().player())) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Ziel-Punkt muss sichtbar sein."))
				return false
			endif
			set i = 0
			loop
				exitwhen (i == Shrine.shrines().size())
				set shrine = Shrine(Shrine.shrines()[i])
				set dist = GetDistanceBetweenPointsWithoutZ(GetRectCenterX(shrine.revivalRect()), GetRectCenterY(shrine.revivalRect()), GetSpellTargetX(), GetSpellTargetY())
				// pings all available shrines
				if (not IsMaskedToPlayer(GetRectCenterX(shrine.revivalRect()), GetRectCenterY(shrine.revivalRect()), this.character().player())) then
					call PingMinimapExForPlayer(Player(0), GetRectCenterX(shrine.revivalRect()), GetRectCenterY(shrine.revivalRect()), 10.0, 100, 200, 100, false)
				endif
				if (dist <= thistype.distance) then
					set result = true
				endif
				set i = i + 1
			endloop
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Ziel-Punkt muss sich in der Nähe eines Wiederbelebungsschreins befinden."))
			endif
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "chest")
			local effect targetEffect = AddSpellEffectById(thistype.abilityId, EFFECT_TYPE_TARGET, GetSpellTargetX(), GetSpellTargetY())
			debug call Print("Spell Scroll Of The Realm!")
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