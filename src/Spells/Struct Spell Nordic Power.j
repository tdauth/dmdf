/// Spell from Ricman
library StructSpellsSpellNordicPower requires Asl, StructGameSpell

	struct SpellNordicPower extends Spell
		public static constant integer abilityId = 'A07J'
		public static constant integer favouriteAbilityId = 'A1PF'
		public static constant integer maxLevel = 1

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, 0, thistype.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1P6', 'A1P7')
			call this.addGrimoireEntry('A1P8', 'A1P9')

			return this
		endmethod
	endstruct

endlibrary