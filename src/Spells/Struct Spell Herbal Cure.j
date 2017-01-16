/// Druid
library StructSpellsHerbalCure requires Asl, StructGameClasses, StructGameSpell

	/// Heilt X Leben eines nicht-mechanischen Verbündeten während Y Sekunden. Hat eine Reichweite von Z.
	struct SpellHerbalCure extends Spell
		public static constant integer abilityId = 'A0AJ'
		public static constant integer favouriteAbilityId = 'A0AK'
		public static constant integer classSelectionAbilityId = 'A1LF'
		public static constant integer classSelectionGrimoireAbilityId = 'A1LG'
		public static constant integer maxLevel = 1

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.druid(), Spell.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1LF', 'A1LG')
			call this.addGrimoireEntry('A0X2', 'A0X3')

			return this
		endmethod
	endstruct

endlibrary