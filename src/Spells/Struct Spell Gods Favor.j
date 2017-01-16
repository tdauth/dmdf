/// Cleric
library StructSpellsSpellGodsFavor requires Asl, StructGameClasses, StructGameSpell

	/// Erhöht die Rüstung eines Verbündeten um X.
	struct SpellGodsFavor extends Spell
		public static constant integer abilityId = 'A0QB'
		public static constant integer favouriteAbilityId = 'A0QC'
		public static constant integer classSelectionAbilityId = 'A1L9'
		public static constant integer classSelectionGrimoireAbilityId = 'A1LA'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)

			call this.addGrimoireEntry('A1L9', 'A1LA')
			call this.addGrimoireEntry('A0QD', 'A0QI')
			call this.addGrimoireEntry('A0QE', 'A0QJ')
			call this.addGrimoireEntry('A0QF', 'A0QK')
			call this.addGrimoireEntry('A0QG', 'A0QL')
			call this.addGrimoireEntry('A0QH', 'A0QM')

			return this
		endmethod
	endstruct

endlibrary