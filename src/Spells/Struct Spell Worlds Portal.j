/// Necromancer
library StructSpellsSpellWorldsPortal requires Asl, StructGameClasses, StructGameSpell

	struct SpellWorldsPortal extends Spell
		public static constant integer abilityId = 'A0EX'
		public static constant integer favouriteAbilityId = 'A0EY'
		public static constant integer classSelectionAbilityId = 'A1ON'
		public static constant integer classSelectionGrimoireAbilityId = 'A1OO'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1ON', 'A1OO')
			call this.addGrimoireEntry('A0EZ', 'A0F4')
			call this.addGrimoireEntry('A0F0', 'A0F5')
			call this.addGrimoireEntry('A0F1', 'A0F6')
			call this.addGrimoireEntry('A0F2', 'A0F7')
			call this.addGrimoireEntry('A0F3', 'A0F8')

			return this
		endmethod
	endstruct

endlibrary