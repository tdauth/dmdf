/// Ranger
library StructSpellsSpellFrozenArrows requires Asl, StructGameClasses, StructGameSpell

	struct SpellFrozenArrows extends Spell
		public static constant integer abilityId = 'A0MT'
		public static constant integer favouriteAbilityId = 'A0MU'
		public static constant integer classSelectionAbilityId = 'A0MV'
		public static constant integer classSelectionGrimoireAbilityId = 'A0N0'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0MV', 'A0N0')
			call this.addGrimoireEntry('A0MW', 'A0N1')
			call this.addGrimoireEntry('A0MX', 'A0N2')
			call this.addGrimoireEntry('A0MY', 'A0N3')
			call this.addGrimoireEntry('A0MZ', 'A0N4')
			
			return this
		endmethod
	endstruct

endlibrary