library StructSpellsSpellMultiShot requires Asl, StructGameClasses, StructGameSpell

	struct SpellMultiShot extends Spell
		public static constant integer abilityId = 'A182'
		public static constant integer favouriteAbilityId = 'A17R'
		public static constant integer classSelectionAbilityId = 'A1ML'
		public static constant integer classSelectionGrimoireAbilityId = 'A1MM'
		public static constant integer maxLevel = 1

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.ranger(), thistype.spellTypeUltimate1, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1ML', 'A1MM')
			call this.addGrimoireEntry('A17S', 'A17X')

			call this.setIsPassive(true)

			return this
		endmethod
	endstruct

endlibrary