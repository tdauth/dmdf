/// Elemental Mage
library StructSpellsSpellElementalCreatures requires Asl, StructSpellsSpellElementalMageDamageSpell

	struct SpellElementalCreatures extends Spell
		public static constant integer abilityId = 'A1I8'
		public static constant integer favouriteAbilityId = 'A1I9'
		public static constant integer classSelectionAbilityId = 'A1KF'
		public static constant integer classSelectionGrimoireAbilityId = 'A1KG'
		public static constant integer maxLevel = 5

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.elementalMage(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1KF', 'A1KG')
			call this.addGrimoireEntry('A1IA', 'A1IF')
			call this.addGrimoireEntry('A1IB', 'A1IG')
			call this.addGrimoireEntry('A1IC', 'A1IH')
			call this.addGrimoireEntry('A1ID', 'A1II')
			call this.addGrimoireEntry('A1IE', 'A1IJ')

			return this
		endmethod
	endstruct

endlibrary