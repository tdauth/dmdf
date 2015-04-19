/// Knight
library StructSpellsSpellAuraOfIronSkin requires Asl, StructGameClasses, StructGameSpell

	struct SpellAuraOfIronSkin extends Spell
		public static constant integer abilityId = 'A029'
		public static constant integer favouriteAbilityId = 'A038'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A134', 'A139')
			call this.addGrimoireEntry('A135', 'A13A')
			call this.addGrimoireEntry('A136', 'A13B')
			call this.addGrimoireEntry('A137', 'A13C')
			call this.addGrimoireEntry('A138', 'A13D')
			
			return this
		endmethod
	endstruct

endlibrary