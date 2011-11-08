/// Necromancer
library StructSpellsSpellDemonServant requires Asl, StructGameClasses, StructGameSpell

	struct SpellDemonServant extends Spell
		public static constant integer abilityId = 'A01V'
		public static constant integer favouriteAbilityId = 'A037'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary