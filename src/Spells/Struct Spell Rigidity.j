/// Knight
library StructSpellsSpellRigidity requires Asl, StructGameClasses, StructGameSpell

	struct SpellRigidity extends Spell
		public static constant integer abilityId = 'A0JZ'
		public static constant integer favouriteAbilityId = 'A0K0'
		public static constant integer classSelectionAbilityId = 'A1NJ'
		public static constant integer classSelectionGrimoireAbilityId = 'A1NK'
		public static constant integer maxLevel = 1

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.knight(), Spell.spellTypeUltimate1, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1NJ', 'A1NK')
			call this.addGrimoireEntry('A0K1', 'A0K2')

			return this
		endmethod
	endstruct

endlibrary