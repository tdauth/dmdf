/// Ranger
library StructSpellsSpellAgility requires Asl, StructGameClasses, StructGameSpell

	/// Passiv. Der Waldläufer weicht Angriffen mit einer X %igen Chance aus.
	struct SpellAgility extends Spell
		public static constant integer abilityId = 'A06O'
		public static constant integer favouriteAbilityId = 'A06P'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary