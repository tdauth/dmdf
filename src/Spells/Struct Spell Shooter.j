/// Ranger
library StructSpellsSpellShooter requires Asl, StructGameClasses, StructGameSpell

	/// Grundfähigkeit: Schütze - Passiv. Mit Fernwaffen verursachter Schaden wird um 50% erhöht.
	struct SpellShooter extends Spell
		public static constant integer abilityId = 'A03S'
		public static constant integer favouriteAbilityId = 'A03T'
		public static constant integer classSelectionAbilityId = 'A11G'
		public static constant integer classSelectionGrimoireAbilityId = 'A11H'
		public static constant integer maxLevel = 1

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.ranger(), Spell.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A11G', 'A11H')
			
			call this.setIsPassive(true)
			
			return this
		endmethod
	endstruct

endlibrary