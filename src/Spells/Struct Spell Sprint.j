/// Ranger
library StructSpellsSpellSprint requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Der Waldläufer sprintet und erhöht sein Bewegungstempo 3 + X Sekunden lang um 80 %.
	struct SpellSprint extends Spell
		public static constant integer abilityId = 'A1EK'
		public static constant integer favouriteAbilityId = 'A03U'
		public static constant integer classSelectionAbilityId = 'A1NZ'
		public static constant integer classSelectionGrimoireAbilityId = 'A1O0'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			
			call this.addGrimoireEntry('A1NZ', 'A1O0')
			call this.addGrimoireEntry('A10W', 'A111')
			call this.addGrimoireEntry('A10X', 'A112')
			call this.addGrimoireEntry('A10Y', 'A113')
			call this.addGrimoireEntry('A10Z', 'A114')
			call this.addGrimoireEntry('A110', 'A115')
			
			return this
		endmethod
	endstruct

endlibrary