/// Dragon Slayer
library StructSpellsSpellColossus requires Asl, StructGameClasses, StructGameSpell

	struct SpellColossus extends Spell
		public static constant integer abilityId = 'A0K5'
		public static constant integer favouriteAbilityId = 'A0FW'
		public static constant integer classSelectionAbilityId = 'A1JG'
		public static constant integer classSelectionGrimoireAbilityId = 'A1JH'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.dragonSlayer(), thistype.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1JG', 'A1JH')
			call this.addGrimoireEntry('A0FX', 'A0G2')
			call this.addGrimoireEntry('A0FY', 'A0G3')
			call this.addGrimoireEntry('A0FZ', 'A0G4')
			call this.addGrimoireEntry('A0G0', 'A0G5')
			call this.addGrimoireEntry('A0G1', 'A0G6')

			call this.setIsPassive(true)

			return this
		endmethod
	endstruct

endlibrary