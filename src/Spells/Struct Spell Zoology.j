/// Druid
library StructSpellsSpellZoology requires Asl, StructGameClasses, StructGameSpell

	struct SpellZoology extends Spell
		public static constant integer abilityId = 'A09T'
		public static constant integer favouriteAbilityId = 'A09U'
		public static constant integer classSelectionAbilityId = 'A1OR'
		public static constant integer classSelectionGrimoireAbilityId = 'A1OS'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A1OR', 'A1OS')
			call this.addGrimoireEntry('A0EN', 'A0ES')
			call this.addGrimoireEntry('A0EO', 'A0ET')
			call this.addGrimoireEntry('A0EP', 'A0EU')
			call this.addGrimoireEntry('A0EQ', 'A0EV')
			call this.addGrimoireEntry('A0ER', 'A0EW')
			
			call this.setIsPassive(true)
			
			return this
		endmethod
	endstruct

endlibrary