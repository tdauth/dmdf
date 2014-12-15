/// Necromancer
library StructSpellsSpellNecromancy requires Asl, StructGameClasses, StructGameSpell

	struct SpellNecromancy extends Spell
		public static constant integer abilityId = 'A0FJ'
		public static constant integer favouriteAbilityId = 'A0FK'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0FL', 'A0FQ')
			call this.addGrimoireEntry('A0FM', 'A0FR')
			call this.addGrimoireEntry('A0FN', 'A0FS')
			call this.addGrimoireEntry('A0FO', 'A0FT')
			call this.addGrimoireEntry('A0FP', 'A0FU')
			
			return this
		endmethod
	endstruct

endlibrary