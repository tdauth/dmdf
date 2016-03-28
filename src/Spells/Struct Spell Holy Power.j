/// Cleric
library StructSpellsSpellHolyPower requires Asl, StructGameClasses, StructGameSpell

	/// Stellt 50 % des maximal Manas wieder her. 5 Minuten Abklingzeit.
	struct SpellHolyPower extends Spell
		public static constant integer abilityId = 'A01Y'
		public static constant integer favouriteAbilityId = 'A032'
		public static constant integer classSelectionAbilityId = 'A1LH'
		public static constant integer classSelectionGrimoireAbilityId = 'A1LI'
		public static constant integer maxLevel = 1
		private static constant real manaFactor = 0.50
		
		private method condition takes nothing returns boolean
			local unit caster = this.character().unit()
			local boolean result = GetUnitState(caster, UNIT_STATE_MANA) < GetUnitState(caster, UNIT_STATE_MAX_MANA)
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Hat bereits volles Mana.", "Does already have full mana."))
			endif
			set caster = null
			return result
		endmethod

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
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			
			call this.addGrimoireEntry('A1LH', 'A1LI')
			call this.addGrimoireEntry('A0X4', 'A0X5')
			
			return this
		endmethod
	endstruct

endlibrary