/// Druid
library StructSpellsSpellAwakeningOfTheForest requires Asl, StructGameClasses, StructGameSpell

	struct SpellAwakeningOfTheForest extends Spell
		public static constant integer abilityId = 'A09Z'
		public static constant integer favouriteAbilityId = 'A0A0'
		public static constant integer classSelectionAbilityId = 'A0PT'
		public static constant integer classSelectionGrimoireAbilityId = 'A0PU'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A0PT', 'A0PU')
			call this.addGrimoireEntry('A0JP', 'A0JU')
			call this.addGrimoireEntry('A0JQ', 'A0JV')
			call this.addGrimoireEntry('A0JR', 'A0JW')
			call this.addGrimoireEntry('A0JS', 'A0JX')
			call this.addGrimoireEntry('A0JT', 'A0JY')

			return this
		endmethod
	endstruct

endlibrary