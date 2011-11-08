/// Wizard
library StructSpellsSpellArcaneProtection requires Asl, StructGameClasses, StructGameSpell

	struct SpellArcaneProtection extends Spell
		public static constant integer abilityId = 'A0A8'
		public static constant integer favouriteAbilityId = 'A0A9'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary