/// Knight
library StructSpellsSpellBlock requires Asl, StructGameClasses, StructGameSpell

	/**
	* Passiv. Der Ritter hat eine 5%ige Chance, Angriffe auf ihn abzublocken und ihren Schaden um 20/40/60/80/100% zu verringern.
	* Sollte durch Gegenstände beeinflusst werden.
	*/
	struct SpellBlock extends Spell
		public static constant integer abilityId = 'A01P'
		public static constant integer favouriteAbilityId = 'A035'
		public static constant integer maxLevel = 5
		private static constant integer chance = 5
		private static constant real damageLevelFactor = 0.20
		private ADamageRecorder m_damageRecorder

		private method action takes nothing returns nothing
			local real randomValue
			local unit characterUnit
			local real damage
			set characterUnit = this.m_damageRecorder.target()
			if (GetUnitAbilityLevel(characterUnit, thistype.abilityId) > 0) then
				if (GetRandomInt(1, 100) <= thistype.chance) then
					set damage = GetEventDamage() * thistype.damageLevelFactor * GetUnitAbilityLevel(characterUnit, thistype.abilityId)
					call SetUnitLifeBJ(characterUnit, GetUnitState(characterUnit, UNIT_STATE_LIFE) + damage)
					call Spell.showDamageAbsorbationTextTag(characterUnit, damage)
				endif
			endif
			set characterUnit = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			set this.m_damageRecorder = ADamageRecorder.create(character.unit())
			call this.m_damageRecorder.setOnDamageAction(thistype.action)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_damageRecorder.destroy()
		endmethod
	endstruct

endlibrary