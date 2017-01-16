/// Druid
library StructSpellsSpellDryadSource requires Asl, StructGameClasses, StructGameSpell

	struct SpellDryadSource extends Spell
		public static constant integer abilityId = 'A0D3'
		public static constant integer favouriteAbilityId = 'A0CS'
		public static constant integer classSelectionAbilityId = 'A1K9'
		public static constant integer classSelectionGrimoireAbilityId = 'A1KA'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1K9', 'A1KA')
			call this.addGrimoireEntry('A0CT', 'A0CV')
			call this.addGrimoireEntry('A0CW', 'A0CU')
			call this.addGrimoireEntry('A0CX', 'A0D0')
			call this.addGrimoireEntry('A0CY', 'A0D1')
			call this.addGrimoireEntry('A0CZ', 'A0D2')

			return this
		endmethod
	endstruct

endlibrary