/// Necromancer
library StructSpellsSpellDarkServant requires Asl, StructGameClasses, StructGameSpell

	/**
	* Erschafft für 2 Minuten einen schwachen Zombie Stufe X mit Y Leben, Z Schaden und A Rüstung, der sich durch Kadaver regenerieren kann.
	*/
	struct SpellDarkServant extends Spell
		public static constant integer abilityId = 'A01U'
		public static constant integer favouriteAbilityId = 'A036'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary