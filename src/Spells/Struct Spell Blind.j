/// Cleric
library StructSpellsSpellBlind requires Asl, StructGameClasses, StructGameSpell

	struct SpellBlind extends Spell
		public static constant integer abilityId = 'A0NP'
		public static constant integer favouriteAbilityId = 'A0NQ'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0NR', 'A0NW')
			call this.addGrimoireEntry('A0NS', 'A0NX')
			call this.addGrimoireEntry('A0NT', 'A0NY')
			call this.addGrimoireEntry('A0NU', 'A0NZ')
			call this.addGrimoireEntry('A0NV', 'A0O0')
			
			return this
		endmethod
	endstruct

endlibrary