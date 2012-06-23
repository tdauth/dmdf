/// Dragon Slayer
library StructSpellsSpellWeakPoint requires Asl, StructGameClasses, StructGameSpell

	/// Passiv. Der Drachentöter hat eine Chance von X%, doppelten Schaden zuzufügen.
	struct SpellWeakPoint extends Spell
		public static constant integer abilityId = 'A06Y'
		public static constant integer favouriteAbilityId = 'A06Z'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary