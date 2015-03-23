/// Wizard
library StructSpellsSpellMultiply requires Asl, StructGameClasses, StructGameSpell

	/// Vervielfachung - Spiegelbild.
	struct SpellMultiply extends Spell
		public static constant integer abilityId = 'A08T'
		public static constant integer favouriteAbilityId = 'A08U'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.wizard(), thistype.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0WI', 'A0WN')
			call this.addGrimoireEntry('A0WJ', 'A0WO')
			call this.addGrimoireEntry('A0WK', 'A0WP')
			call this.addGrimoireEntry('A0WL', 'A0WQ')
			call this.addGrimoireEntry('A0WM', 'A0WR')
			
			return this
		endmethod
	endstruct

endlibrary