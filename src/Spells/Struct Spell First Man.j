/// Spell from Ricman
library StructSpellsSpellFirstMan requires Asl, StructGameSpell

	struct SpellFirstMan extends Spell
		public static constant integer abilityId = 'A07I'
		public static constant integer favouriteAbilityId = 'A1PA'
		public static constant integer maxLevel = 1

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, 0, thistype.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1PB', 'A1PC')
			call this.addGrimoireEntry('A1PD', 'A1PE')

			return this
		endmethod
	endstruct

endlibrary