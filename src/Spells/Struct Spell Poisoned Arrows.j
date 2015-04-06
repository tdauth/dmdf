/// Ranger
library StructSpellsSpellPoisonedArrows requires Asl, StructGameClasses, StructGameSpell

	struct SpellPoisonedArrows extends Spell
		public static constant integer abilityId = 'A0HX'
		public static constant integer favouriteAbilityId = 'A0GI'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0C6', 'A0GN')
			call this.addGrimoireEntry('A0GJ', 'A0GO')
			call this.addGrimoireEntry('A0GK', 'A0GP')
			call this.addGrimoireEntry('A0GL', 'A0GQ')
			call this.addGrimoireEntry('A0GM', 'A0GR')
			
			return this
		endmethod
	endstruct

endlibrary