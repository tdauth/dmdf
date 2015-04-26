/// Druid
library StructSpellsSpellRelief requires Asl, StructGameClasses, StructGameSpell

	struct SpellRelief extends Spell
		public static constant integer abilityId = 'A0A4'
		public static constant integer favouriteAbilityId = 'A0A5'
		public static constant integer classSelectionAbilityId = 'A0JF'
		public static constant integer classSelectionGrimoireAbilityId = 'A0JK'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0JF', 'A0JK')
			call this.addGrimoireEntry('A0JG', 'A0JL')
			call this.addGrimoireEntry('A0JH', 'A0JM')
			call this.addGrimoireEntry('A0JI', 'A0JN')
			call this.addGrimoireEntry('A0JJ', 'A0JO')
			
			return this
		endmethod
	endstruct

endlibrary