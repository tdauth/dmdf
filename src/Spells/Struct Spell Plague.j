/// Necromancer
library StructSpellsSpellPlague requires Asl, StructGameClasses, StructGameSpell

	struct SpellPlague extends Spell
		public static constant integer abilityId = 'A0HG'
		public static constant integer favouriteAbilityId = 'A0HM'
		public static constant integer classSelectionAbilityId = 'A0HN'
		public static constant integer classSelectionGrimoireAbilityId = 'A0HS'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0HN', 'A0HS')
			call this.addGrimoireEntry('A0HO', 'A0HT')
			call this.addGrimoireEntry('A0HP', 'A0HU')
			call this.addGrimoireEntry('A0HQ', 'A0HV')
			call this.addGrimoireEntry('A0HR', 'A0HW')
			
			return this
		endmethod
	endstruct

endlibrary