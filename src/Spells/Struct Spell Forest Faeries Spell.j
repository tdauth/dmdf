/// Druid
library StructSpellsSpellForestFaeriesSpell requires Asl, StructGameClasses, StructGameSpell

	struct SpellForestFaeriesSpell extends Spell
		public static constant integer abilityId = 'A0AL'
		public static constant integer favouriteAbilityId = 'A0AM'
		public static constant integer classSelectionAbilityId = 'A1KZ'
		public static constant integer classSelectionGrimoireAbilityId = 'A1L0'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1KZ', 'A1L0')
			call this.addGrimoireEntry('A0J5', 'A0JA')
			call this.addGrimoireEntry('A0J6', 'A0JB')
			call this.addGrimoireEntry('A0J7', 'A0JC')
			call this.addGrimoireEntry('A0J8', 'A0JD')
			call this.addGrimoireEntry('A0J9', 'A0JE')

			return this
		endmethod
	endstruct

endlibrary