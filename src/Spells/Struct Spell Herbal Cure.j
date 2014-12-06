/// Druid
library StructSpellsHerbalCure requires Asl, StructGameClasses, StructGameSpell

	/// Heilt X Leben eines nicht-mechanischen Verbündeten während Y Sekunden. Hat eine Reichweite von Z.
	struct SpellHerbalCure extends Spell
		public static constant integer abilityId = 'A0AJ'
		public static constant integer favouriteAbilityId = 'A0AK'
		public static constant integer maxLevel = 1
		
		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.druid(), Spell.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary