/// Dragon Slayer
library StructSpellsSpellWeakPoint requires Asl, StructGameClasses, StructGameSpell

	/// Passiv. Der Drachentöter hat eine Chance von X%, doppelten Schaden zuzufügen.
	struct SpellWeakPoint extends Spell
		public static constant integer abilityId = 'A06Y'
		public static constant integer favouriteAbilityId = 'A06Z'
		public static constant integer classSelectionAbilityId = 'A0SS'
		public static constant integer classSelectionGrimoireAbilityId = 'A0SX'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A0SS', 'A0SX')
			call this.addGrimoireEntry('A0ST', 'A0SY')
			call this.addGrimoireEntry('A0SU', 'A0SZ')
			call this.addGrimoireEntry('A0SV', 'A0T0')
			call this.addGrimoireEntry('A0SW', 'A0T1')
			
			return this
		endmethod
	endstruct

endlibrary