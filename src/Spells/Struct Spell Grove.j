/// Druid
library StructSpellsSpellGrove requires Asl, StructGameClasses, StructGameSpell

	struct SpellGrove extends Spell
		public static constant integer abilityId = 'A0D4'
		public static constant integer favouriteAbilityId = 'A0D5'
		public static constant integer classSelectionAbilityId = 'A0D6'
		public static constant integer classSelectionGrimoireAbilityId = 'A0DB'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0D6', 'A0DB')
			call this.addGrimoireEntry('A0D7', 'A0DC')
			call this.addGrimoireEntry('A0D8', 'A0DD')
			call this.addGrimoireEntry('A0D9', 'A0DE')
			call this.addGrimoireEntry('A0DA', 'A0DF')
			
			return this
		endmethod
	endstruct

endlibrary