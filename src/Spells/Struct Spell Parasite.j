/// Necromancer
library StructSpellsSpellParasite requires Asl, StructGameClasses, StructGameSpell

	struct SpellParasite extends Spell
		public static constant integer abilityId = 'A0S4'
		public static constant integer favouriteAbilityId = 'A0S5'
		public static constant integer classSelectionAbilityId = 'A1MR'
		public static constant integer classSelectionGrimoireAbilityId = 'A1MS'
		public static constant integer maxLevel = 5

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1MR', 'A1MS')
			call this.addGrimoireEntry('A0S6', 'A0SB')
			call this.addGrimoireEntry('A0S7', 'A0SC')
			call this.addGrimoireEntry('A0S8', 'A0SD')
			call this.addGrimoireEntry('A0S9', 'A0SE')
			call this.addGrimoireEntry('A0SA', 'A0SF')

			return this
		endmethod
	endstruct

endlibrary