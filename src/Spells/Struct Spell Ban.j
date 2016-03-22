/// Wizard
library StructSpellsSpellBan requires Asl, StructGameClasses, StructGameSpell

	struct SpellBan extends Spell
		public static constant integer abilityId = 'A0A6'
		public static constant integer favouriteAbilityId = 'A0A7'
		public static constant integer classSelectionAbilityId = 'A0UB'
		public static constant integer classSelectionGrimoireAbilityId = 'A0UC'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0UB', 'A0UC')
			call this.addGrimoireEntry('A0WS', 'A0WX')
			call this.addGrimoireEntry('A0WT', 'A0WY')
			call this.addGrimoireEntry('A0WU', 'A0WZ')
			call this.addGrimoireEntry('A0WV', 'A0X0')
			call this.addGrimoireEntry('A0WW', 'A0X1')
			
			return this
		endmethod
	endstruct

endlibrary