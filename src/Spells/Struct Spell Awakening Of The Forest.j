/// Druid
library StructSpellsSpellAwakeningOfTheForest requires Asl, StructGameClasses, StructGameSpell

	struct SpellAwakeningOfTheForest extends Spell
		public static constant integer abilityId = 'A09Z'
		public static constant integer favouriteAbilityId = 'A0A0'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary