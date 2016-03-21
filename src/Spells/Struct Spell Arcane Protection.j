/// Wizard
library StructSpellsSpellArcaneProtection requires Asl, StructGameClasses, StructGameSpell

	struct SpellArcaneProtection extends Spell
		public static constant integer abilityId = 'A0A8'
		public static constant integer favouriteAbilityId = 'A0A9'
		public static constant integer classSelectionAbilityId = 'A06C'
		public static constant integer classSelectionGrimoireAbilityId = 'A06D'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			
			call this.addGrimoireEntry('A06C', 'A06D')
			call this.addGrimoireEntry('A0G7', 'A0GC')
			call this.addGrimoireEntry('A0G8', 'A0GD')
			call this.addGrimoireEntry('A0G9', 'A0GE')
			call this.addGrimoireEntry('A0GA', 'A0GF')
			call this.addGrimoireEntry('A0GB', 'A0GG')
			
			return this
		endmethod
	endstruct

endlibrary