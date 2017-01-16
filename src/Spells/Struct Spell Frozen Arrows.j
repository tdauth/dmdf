/// Ranger
library StructSpellsSpellFrozenArrows requires Asl, StructGameClasses, StructGameSpell

	struct SpellFrozenArrows extends Spell
		public static constant integer abilityId = 'A0MT'
		public static constant integer favouriteAbilityId = 'A0MU'
		public static constant integer classSelectionAbilityId = 'A1L5'
		public static constant integer classSelectionGrimoireAbilityId = 'A1L6'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1L5', 'A1L6')
			call this.addGrimoireEntry('A0MV', 'A0N0')
			call this.addGrimoireEntry('A0MW', 'A0N1')
			call this.addGrimoireEntry('A0MX', 'A0N2')
			call this.addGrimoireEntry('A0MY', 'A0N3')
			call this.addGrimoireEntry('A0MZ', 'A0N4')

			return this
		endmethod
	endstruct

endlibrary