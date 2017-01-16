/// Ranger
library StructSpellsSpellHailOfArrows requires Asl, StructGameClasses, StructGameSpell

	///
	struct SpellHailOfArrows extends Spell
		public static constant integer abilityId = 'A12E'
		public static constant integer favouriteAbilityId = 'A12F'
		public static constant integer classSelectionAbilityId = 'A1LD'
		public static constant integer classSelectionGrimoireAbilityId = 'A1LE'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)

			call this.addGrimoireEntry('A1LD', 'A1LE')
			call this.addGrimoireEntry('A12H', 'A12M')
			call this.addGrimoireEntry('A12I', 'A12N')
			call this.addGrimoireEntry('A12J', 'A12O')
			call this.addGrimoireEntry('A12K', 'A12P')
			call this.addGrimoireEntry('A12L', 'A12Q')

			return this
		endmethod
	endstruct

endlibrary