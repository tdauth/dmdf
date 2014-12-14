/// Necromancer
library StructSpellsSpellWorldsPortal requires Asl, StructGameClasses, StructGameSpell

	struct SpellWorldsPortal extends Spell
		public static constant integer abilityId = 'A0EX'
		public static constant integer favouriteAbilityId = 'A0EY'
		public static constant integer maxLevel = 5
		
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0EZ', 'A0F4')
			call this.addGrimoireEntry('A0F0', 'A0F5')
			call this.addGrimoireEntry('A0F1', 'A0F6')
			call this.addGrimoireEntry('A0F2', 'A0F7')
			call this.addGrimoireEntry('A0F3', 'A0F8')

			return this
		endmethod
	endstruct

endlibrary