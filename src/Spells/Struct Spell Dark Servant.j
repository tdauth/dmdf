/// Necromancer
library StructSpellsSpellDarkServant requires Asl, StructGameClasses, StructGameSpell

	/**
	* Erschafft für 2 Minuten einen schwachen Zombie Stufe X mit Y Leben, Z Schaden und A Rüstung, der sich durch Kadaver regenerieren kann.
	*/
	struct SpellDarkServant extends Spell
		public static constant integer abilityId = 'A01U'
		public static constant integer favouriteAbilityId = 'A036'
		public static constant integer classSelectionAbilityId = 'A1JX'
		public static constant integer classSelectionGrimoireAbilityId = 'A1JY'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1JX', 'A1JY')
			call this.addGrimoireEntry('A0IV', 'A0J0')
			call this.addGrimoireEntry('A0IW', 'A0J1')
			call this.addGrimoireEntry('A0IX', 'A0J2')
			call this.addGrimoireEntry('A0IY', 'A0J3')
			call this.addGrimoireEntry('A0IZ', 'A0J4')

			return this
		endmethod
	endstruct

endlibrary