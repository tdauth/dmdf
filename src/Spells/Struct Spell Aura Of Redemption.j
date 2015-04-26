/// Knight
library StructSpellsSpellAuraOfRedemption requires Asl, StructGameClasses, StructGameSpell

	// TODO Whenever a unit with the buff deals damage it gets the percentage back as mana as well
	struct SpellAuraOfRedemption extends Spell
		public static constant integer abilityId = 'A0M5'
		public static constant integer favouriteAbilityId = 'A0M6'
		public static constant integer classSelectionAbilityId = 'A0M7'
		public static constant integer classSelectionGrimoireAbilityId = 'A0MC'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0M7', 'A0MC')
			call this.addGrimoireEntry('A0M8', 'A0MD')
			call this.addGrimoireEntry('A0M9', 'A0ME')
			call this.addGrimoireEntry('A0MA', 'A0MF')
			call this.addGrimoireEntry('A0MB', 'A0MG')
			
			return this
		endmethod
	endstruct

endlibrary