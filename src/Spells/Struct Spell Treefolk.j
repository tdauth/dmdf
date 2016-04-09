/// Druid
library StructSpellsSpellTreefolk requires Asl, StructGameClasses, StructGameSpell

	struct SpellTreefolk extends Spell
		public static constant integer abilityId = 'A0E1'
		public static constant integer favouriteAbilityId = 'A0B7'
		public static constant integer classSelectionAbilityId = 'A1OH'
		public static constant integer classSelectionGrimoireAbilityId = 'A1OI'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			
			call this.addGrimoireEntry('A1OH', 'A1OI')
			call this.addGrimoireEntry('A0DH', 'A0DM')
			call this.addGrimoireEntry('A0DI', 'A0DN')
			call this.addGrimoireEntry('A0DJ', 'A0DO')
			call this.addGrimoireEntry('A0DK', 'A0DP')
			call this.addGrimoireEntry('A0DL', 'A0DQ')
			
			return this
		endmethod
	endstruct

endlibrary