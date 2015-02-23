/// Necromancer
library StructSpellsSpellDemonServant requires Asl, StructGameClasses, StructGameSpell

	struct SpellDemonServant extends Spell
		public static constant integer abilityId = 'A0RU'
		public static constant integer favouriteAbilityId = 'A037'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A023', 'A0I2')
			call this.addGrimoireEntry('A0HY', 'A0I3')
			call this.addGrimoireEntry('A0HZ', 'A0I4')
			call this.addGrimoireEntry('A0I0', 'A0I5')
			call this.addGrimoireEntry('A0I1', 'A0I6')
			
			return this
		endmethod
	endstruct

endlibrary