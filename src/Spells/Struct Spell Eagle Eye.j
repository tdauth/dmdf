library StructSpellsSpellEagleEye requires Asl, StructGameClasses, StructGameSpell

	/// Passiv. Der Waldläufer hat eine X%ige Chance, doppelten Schaden anzurichten.
	struct SpellEagleEye extends Spell
		public static constant integer abilityId = 'A068'
		public static constant integer favouriteAbilityId = 'A069'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary