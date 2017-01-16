/// Wizard
library StructSpellsSpellFeedBack requires Asl, StructGameClasses, StructGameSpell

	/**
	 * Rückkopplung.
	 */
	struct SpellFeedBack extends Spell
		public static constant integer abilityId = 'A0VU'
		public static constant integer favouriteAbilityId = 'A0VV'
		public static constant integer classSelectionAbilityId = 'A1KT'
		public static constant integer classSelectionGrimoireAbilityId = 'A1KU'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1KT', 'A1KU')
			call this.addGrimoireEntry('A0VW', 'A0W1')
			call this.addGrimoireEntry('A0VX', 'A0W2')
			call this.addGrimoireEntry('A0VY', 'A0W3')
			call this.addGrimoireEntry('A0VZ', 'A0W4')
			call this.addGrimoireEntry('A0W0', 'A0W5')

			call this.setIsPassive(true)

			return this
		endmethod
	endstruct

endlibrary