/// Druid
library StructSpellsSpellForestCastle requires Asl, StructGameClasses, StructGameSpell

	struct SpellForestCastle extends Spell
		public static constant integer abilityId = 'A0F9'
		public static constant integer favouriteAbilityId = 'A0FB'
		public static constant integer classSelectionAbilityId = 'A1KX'
		public static constant integer classSelectionGrimoireAbilityId = 'A1KY'
		public static constant integer maxLevel = 1

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.druid(), Spell.spellTypeUltimate1, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1KX', 'A1KY')
			call this.addGrimoireEntry('A0FC', 'A0FD')

			return this
		endmethod
	endstruct

endlibrary