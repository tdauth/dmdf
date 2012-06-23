library StructMapSpellsSpellScrollOfTheRealmOfTheDead requires Asl, StructMapMapMapData

	struct SpellScrollOfTheRealmOfTheDead extends ASpell
		public static constant integer abilityId = 'A066'
		public static constant real distance = 300.0

		private method condition takes nothing returns boolean
			local integer i
			if (IsMaskedToPlayer(GetSpellTargetX(), GetSpellTargetY(), this.character().player())) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Ziel-Punkt muss sichtbar sein."))
				return false
			endif
			set i = 0
			loop
				exitwhen (i == Shrine.shrines().size())
				if (GetDistanceBetweenPointsWithoutZ(GetDestructableX(Shrine(Shrine.shrines()[i]).destructable()), GetDestructableY(Shrine(Shrine.shrines()[i]).destructable()), GetSpellTargetX(), GetSpellTargetY()) <= thistype.distance) then
					return true
				endif
				set i = i + 1
			endloop
			call this.character().displayMessage(ACharacter.messageTypeError, tr("Ziel-Punkt muss sich in der Nähe eines Wiederbelebungsschreins befinden."))
			return false
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "chest")
			debug call Print("Spell Scroll Of The Realm!")
			call SetUnitPosition(caster, GetSpellTargetX(), GetSpellTargetY())
			call TriggerSleepAction(0.0)
			call IssueImmediateOrder(caster, "stop")
			set caster = null
			call DestroyEffect(casterEffect)
			set casterEffect = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action)
		endmethod
	endstruct

endlibrary