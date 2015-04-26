/// Druid
library StructSpellsSpellForestCastle requires Asl, StructGameClasses, StructGameSpell

	struct SpellForestCastle extends Spell
		public static constant integer abilityId = 'A0F9'
		public static constant integer favouriteAbilityId = 'A0FB'
		public static constant integer classSelectionAbilityId = 'A0FC'
		public static constant integer classSelectionGrimoireAbilityId = 'A0FD'
		public static constant integer maxLevel = 1

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeUltimate1, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0FC', 'A0FD')
			
			return this
		endmethod
	endstruct

endlibrary