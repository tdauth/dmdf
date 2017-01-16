/// Ranger
library StructSpellsSpellShotIntoHeart requires Asl, StructGameClasses, StructGameSpell

	/// Der Waldläufer schießt ins Herz seines Ziels und fügt X Punkte Schaden zu.
	struct SpellShotIntoHeart extends Spell
		public static constant integer abilityId = 'A06Q'
		public static constant integer favouriteAbilityId = 'A06R'
		public static constant integer classSelectionAbilityId = 'A1NT'
		public static constant integer classSelectionGrimoireAbilityId = 'A1NU'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1NT', 'A1NU')
			call this.addGrimoireEntry('A116', 'A11B')
			call this.addGrimoireEntry('A117', 'A11C')
			call this.addGrimoireEntry('A118', 'A11D')
			call this.addGrimoireEntry('A119', 'A11E')
			call this.addGrimoireEntry('A11A', 'A11F')

			return this
		endmethod
	endstruct

endlibrary