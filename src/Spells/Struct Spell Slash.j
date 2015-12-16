/// Dragon Slayer
library StructSpellsSpellSlash requires Asl, StructGameClasses, StructGameSpell

	/// Der Drachentöter schlägt kraftvoll zu und fügt dem angewählten Ziel X Punkte Schaden zu.
	struct SpellSlash extends Spell
		public static constant integer abilityId = 'A070'
		public static constant integer favouriteAbilityId = 'A071'
		public static constant integer classSelectionAbilityId = 'A157'
		public static constant integer classSelectionGrimoireAbilityId = 'A15C'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), thistype.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A157', 'A15C')
			call this.addGrimoireEntry('A158', 'A15D')
			call this.addGrimoireEntry('A159', 'A15E')
			call this.addGrimoireEntry('A15A', 'A15F')
			call this.addGrimoireEntry('A15B', 'A15G')
			
			return this
		endmethod
	endstruct

endlibrary