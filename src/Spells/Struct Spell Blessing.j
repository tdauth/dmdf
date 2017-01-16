/// Cleric
library StructSpellsSpellBlessing requires Asl, StructGameClasses, StructGameSpell

	struct SpellBlessing extends Spell
		public static constant integer abilityId = 'A0H4'
		public static constant integer favouriteAbilityId = 'A0H5'
		public static constant integer classSelectionAbilityId = 'A0UJ'
		public static constant integer classSelectionGrimoireAbilityId = 'A0UK'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A0UJ', 'A0UK')
			call this.addGrimoireEntry('A0H6', 'A0HB')
			call this.addGrimoireEntry('A0H7', 'A0HC')
			call this.addGrimoireEntry('A0H8', 'A0HD')
			call this.addGrimoireEntry('A0H9', 'A0HE')
			call this.addGrimoireEntry('A0HA', 'A0HF')

			return this
		endmethod
	endstruct

endlibrary