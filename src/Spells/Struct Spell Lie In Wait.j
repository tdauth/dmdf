/// Ranger
library StructSpellsSpellLieInWait requires Asl, StructGameClasses, StructGameSpell

	struct SpellLieInWait extends Spell
		public static constant integer abilityId = 'A12R'
		public static constant integer favouriteAbilityId = 'A12S'
		public static constant integer classSelectionAbilityId = 'A1LZ'
		public static constant integer classSelectionGrimoireAbilityId = 'A1M0'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1LZ', 'A1M0')
			call this.addGrimoireEntry('A12T', 'A12Y')
			call this.addGrimoireEntry('A12U', 'A12Z')
			call this.addGrimoireEntry('A12V', 'A130')
			call this.addGrimoireEntry('A12W', 'A131')
			call this.addGrimoireEntry('A12X', 'A132')

			return this
		endmethod
	endstruct

endlibrary