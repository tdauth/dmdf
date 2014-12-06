/// Druid
library StructSpellsSpellForestFaeriesSpell requires Asl, StructGameClasses, StructGameSpell

	struct SpellForestFaeriesSpell extends Spell
		public static constant integer abilityId = 'A0AL'
		public static constant integer favouriteAbilityId = 'A0AM'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)

			return this
		endmethod
	endstruct

endlibrary