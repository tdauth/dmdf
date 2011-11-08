/// Cleric
library StructSpellsSpellHolyPower requires Asl, StructGameClasses, StructGameSpell

	/// Stellt 50 % des maximal Manas wieder her. 5 Minuten Abklingzeit.
	struct SpellHolyPower extends Spell
		public static constant integer abilityId = 'A01Y'
		public static constant integer favouriteAbilityId = 'A032'
		public static constant integer maxLevel = 1
		private static constant real manaFactor = 0.50

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "chest")
			local real mana = GetUnitState(caster, UNIT_STATE_MAX_MANA) * thistype.manaFactor
			call SetUnitManaBJ(caster, GetUnitState(caster, UNIT_STATE_MANA) + mana)
			call Spell.showManaTextTag(caster, mana)
			set caster = null
			call DestroyEffect(casterEffect)
			set casterEffect = null
		endmethod

		public static method create takes ACharacter character returns thistype
			return  thistype.allocate(character, Classes.cleric(), Spell.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary