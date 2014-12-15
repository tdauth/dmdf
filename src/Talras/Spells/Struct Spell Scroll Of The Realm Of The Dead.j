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
			// TEST
			debug call Print("Location 1: " + R2S(GetLocationX(GetSpellTargetLoc())) + " and " + R2S(GetLocationY(GetSpellTargetLoc())))
			debug call Print("Location 2: " + R2S(GetSpellTargetX()) + " and " + R2S(GetSpellTargetY()))
			debug call Print("Ability name: " + GetObjectName(GetSpellAbilityId()))
			debug call Print("Instance " + I2S(this))
			debug call Print("Player: " + GetPlayerName(Player(0)))
			call PingMinimapExForPlayer(Player(0), GetSpellTargetX(), GetSpellTargetY(), 10.0, 100, 100, 100, false)
			if (IsMaskedToPlayer(GetSpellTargetX(), GetSpellTargetY(), this.character().player())) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Ziel-Punkt muss sichtbar sein."))
				return false
			endif
			debug call Print("Shrines: " + I2S(Shrine.shrines().size()))
			set i = 0
			loop
				exitwhen (i == Shrine.shrines().size())
				set shrine = Shrine(Shrine.shrines()[i])
				set dist = GetDistanceBetweenPointsWithoutZ(GetRectCenterX(shrine.revivalRect()), GetRectCenterY(shrine.revivalRect()), GetSpellTargetX(), GetSpellTargetY())
				// TEST
				call PingMinimapExForPlayer(Player(0), GetRectCenterX(shrine.revivalRect()), GetRectCenterY(shrine.revivalRect()), 10.0, 100, 200, 100, false)
				if (dist <= thistype.distance) then
					return true
				endif
				debug call Print("Checked shrine: " + I2S(shrine) + " with distance " + R2S(dist))
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