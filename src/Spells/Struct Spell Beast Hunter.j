/// Dragon Slayer
library StructSpellsSpellBeastHunter requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Grundfähigkeit: Bestienjäger - Passiv. Schaden gegen wilde Kreaturen wird um 10% erhöht.
	struct SpellBeastHunter extends Spell
		public static constant integer abilityId = 'A0T2'
		public static constant integer favouriteAbilityId = 'A076'
		public static constant integer classSelectionAbilityId = 'A0UF'
		public static constant integer classSelectionGrimoireAbilityId = 'A0UG'
		public static constant integer maxLevel = 1

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), thistype.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0UF', 'A0UG')
			call this.addGrimoireEntry('A14V', 'A14W')
			
			call this.setIsPassive(true)
			
			return this
		endmethod
	endstruct

endlibrary