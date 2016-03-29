/// Necromancer
library StructSpellsSpellSoulThievery requires Asl, StructGameClasses, StructGameSpell

	/**
	* Stiehlt dem feindlichen Ziel seine Seele und entzieht ihm pro Sekunde X Leben und Mana. Hält 5 Sekunden lang an.
	* Etwas mehr Schaden als Qualen.
	*/
	struct SpellSoulThievery extends Spell
		public static constant integer abilityId = 'A06J'
		public static constant integer favouriteAbilityId = 'A06K'
		public static constant integer classSelectionAbilityId = 'A1NX'
		public static constant integer classSelectionGrimoireAbilityId = 'A1NY'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			
			call this.addGrimoireEntry('A1NX', 'A1NY')
			call this.addGrimoireEntry('A01V', 'A0RZ')
			call this.addGrimoireEntry('A0RV', 'A0S0')
			call this.addGrimoireEntry('A0RW', 'A0S1')
			call this.addGrimoireEntry('A0RX', 'A0S2')
			call this.addGrimoireEntry('A0RY', 'A0S3')
			
			return this
		endmethod
	endstruct

endlibrary