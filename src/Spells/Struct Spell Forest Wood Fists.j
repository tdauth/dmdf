/// Druid
library StructSpellsSpellForestWoodFists requires Asl, StructGameClasses, StructGameSpell

	struct SpellForestWoodFists extends Spell
		public static constant integer abilityId = 'A0A1'
		public static constant integer favouriteAbilityId = 'A0A2'
		public static constant integer classSelectionAbilityId = 'A1L1'
		public static constant integer classSelectionGrimoireAbilityId = 'A1L2'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1L1', 'A1L2')
			call this.addGrimoireEntry('A0DR', 'A0DW')
			call this.addGrimoireEntry('A0DS', 'A0DX')
			call this.addGrimoireEntry('A0DT', 'A0DY')
			call this.addGrimoireEntry('A0DU', 'A0DZ')
			call this.addGrimoireEntry('A0DV', 'A0E0')

			return this
		endmethod
	endstruct

endlibrary