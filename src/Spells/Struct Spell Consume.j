/// Necromancer
library StructSpellsSpellConsume requires Asl, StructGameClasses, StructGameSpell

	struct SpellConsume extends Spell
		public static constant integer abilityId = 'A0IJ'
		public static constant integer favouriteAbilityId = 'A0IK'
		public static constant integer classSelectionAbilityId = 'A1JM'
		public static constant integer classSelectionGrimoireAbilityId = 'A1JN'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1JM', 'A1JN')
			call this.addGrimoireEntry('A0IL', 'A0IQ')
			call this.addGrimoireEntry('A0IM', 'A0IR')
			call this.addGrimoireEntry('A0IN', 'A0IS')
			call this.addGrimoireEntry('A0IO', 'A0IT')
			call this.addGrimoireEntry('A0IP', 'A0IU')

			return this
		endmethod
	endstruct

endlibrary