/// Ranger
library StructSpellsSpellTrap requires Asl, StructGameClasses, StructGameSpell

	/// Falle - Goblin-Landmine - Der Waldläufer stellt seinen Gegnern eine Falle, die sie lähmt und ihnen Schaden zufügt.
	// TODO limit time.
	struct SpellTrap extends Spell
		public static constant integer abilityId = 'A184'
		public static constant integer favouriteAbilityId = 'A185'
		public static constant integer classSelectionAbilityId = 'A1OF'
		public static constant integer classSelectionGrimoireAbilityId = 'A1OG'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.ranger(), thistype.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1OF', 'A1OG')
			call this.addGrimoireEntry('A186', 'A18B')
			call this.addGrimoireEntry('A187', 'A18C')
			call this.addGrimoireEntry('A188', 'A18D')
			call this.addGrimoireEntry('A189', 'A18E')
			call this.addGrimoireEntry('A18A', 'A18F')

			return this
		endmethod
	endstruct

endlibrary