/// Druid
library StructSpellsSpellZoology requires Asl, StructGameClasses, StructGameSpell

	struct SpellZoology extends Spell
		public static constant integer abilityId = 'A09T'
		public static constant integer favouriteAbilityId = 'A09U'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)

			return this
		endmethod
	endstruct

endlibrary