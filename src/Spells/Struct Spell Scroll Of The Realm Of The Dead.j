library StructSpellsSpellScrollOfTheRealmOfTheDead requires Asl, StructGameShrine

	/**
	 * \brief The scroll of the realm of the dead allows characters to teleport to any visible revival shrine on the map.
	 * This item is given to the characters from the start on. It allows much faster traveling to already visible areas.
	 */
	struct SpellScrollOfTheRealmOfTheDead extends ASpell
		public static constant integer abilityId = 'A066'
		public static constant real distance = 1200.0

		public static method getNearestShrine takes player whichPlayer, real x, real y returns Shrine
			local integer i
			local Shrine shrine = 0
			local real dist
			local Shrine result = 0
			set i = 0
			loop
				exitwhen (i == Shrine.shrines().size())
				set shrine = Shrine(Shrine.shrines()[i])
				if (not IsMaskedToPlayer(GetRectCenterX(shrine.revivalRect()), GetRectCenterY(shrine.revivalRect()), whichPlayer)) then
					set dist = GetDistanceBetweenPointsWithoutZ(GetRectCenterX(shrine.revivalRect()), GetRectCenterY(shrine.revivalRect()), x, y)
					if (dist <= thistype.distance) then
						set result = shrine
					endif
				endif
				set i = i + 1
			endloop

			return result
		endmethod

		// http://www.hiveworkshop.com/forums/triggers-scripts-269/does-getspelltargetx-y-work-177175/
		// GetSpellTargetX() etc. does not work in conditions but in actions?
		private method condition takes nothing returns boolean
			local Shrine shrine = thistype.getNearestShrine(this.character().player(), GetSpellTargetX(), GetSpellTargetY())
			if (shrine == 0) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel-Punkt muss sich in der Nähe eines erkundeten Wiederbelebungsschreins befinden.", "Target location has to be in the range of a discovered revival shrine."))

				return false
			endif
	
			return true
		endmethod

		private method action takes nothing returns nothing
			local Shrine shrine = thistype.getNearestShrine(this.character().player(), GetSpellTargetX(), GetSpellTargetY())
			local real x = GetRectCenterX(shrine.revivalRect())
			local real y = GetRectCenterY(shrine.revivalRect())
			local unit caster = this.character().unit()
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "origin")
			local effect targetEffect = AddSpellEffectById(thistype.abilityId, EFFECT_TYPE_TARGET, x, y)
			debug call Print("Spell Scroll Of The Realm!")
			call SetUnitPosition(caster, x, y)
			call TriggerSleepAction(0.0) // TODO might interupt something else?
			call IssueImmediateOrder(caster, "stop")
			set caster = null
			call DestroyEffect(casterEffect)
			set casterEffect = null
			call DestroyEffect(targetEffect)
			set targetEffect = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

endlibrary