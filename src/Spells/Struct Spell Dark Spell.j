/// Necromancer
library StructSpellsSpellDarkSpell requires Asl, StructGameClasses, StructGameSpell

	struct SpellDarkSpell extends Spell
		public static constant integer abilityId = 'A0I7'
		public static constant integer favouriteAbilityId = 'A0I8'
		public static constant integer classSelectionAbilityId = 'A1JZ'
		public static constant integer classSelectionGrimoireAbilityId = 'A1K0'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1JZ', 'A1K0')
			call this.addGrimoireEntry('A0I9', 'A0IE')
			call this.addGrimoireEntry('A0IA', 'A0IF')
			call this.addGrimoireEntry('A0IB', 'A0IG')
			call this.addGrimoireEntry('A0IC', 'A0IH')
			call this.addGrimoireEntry('A0ID', 'A0II')

			return this
		endmethod
	endstruct

endlibrary