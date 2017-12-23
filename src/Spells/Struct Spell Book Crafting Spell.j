library StructSpellsSpellBookCraftingSpell requires Asl, StructGameCharacter, StructGameSpell

	struct SpellBookCraftingSpell extends ASpell

		public static method create takes Character character, integer abilityId, AUnitSpellCastCondition castCondition, AUnitSpellCastAction castAction returns thistype
			return thistype.allocate(character, abilityId, 0, castCondition, castAction, EVENT_PLAYER_UNIT_SPELL_CHANNEL, false, true)
		endmethod
	endstruct

endlibrary