/// Ranger
library StructSpellsSpellMultiShot requires Asl, StructGameClasses, StructGameSpell

	/// Mehrfachschuss - Sperrfeuer - Der Waldläufer feuert X Pfeile gleichzeitig ab. 1 Minute Abklingzeit.
	struct SpellMultiShot extends Spell
		public static constant integer abilityId = 'A182'
		public static constant integer favouriteAbilityId = 'A17R'
		public static constant integer classSelectionAbilityId = 'A17S'
		public static constant integer classSelectionGrimoireAbilityId = 'A17X'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.ranger(), thistype.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A17S', 'A17X')
			call this.addGrimoireEntry('A17T', 'A17Y')
			call this.addGrimoireEntry('A17U', 'A17Z')
			call this.addGrimoireEntry('A17V', 'A180')
			call this.addGrimoireEntry('A17W', 'A181')
			
			return this
		endmethod
	endstruct

endlibrary