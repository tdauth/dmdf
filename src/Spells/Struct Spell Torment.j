/// Cleric
library StructSpellsSpellTorment requires Asl, StructGameClasses, StructGameSpell

	/// Fügt feindlichen Wesen X Punkte Schaden zu. Wenig, Kleriker sind Heiler.
	struct SpellTorment extends Spell
		public static constant integer abilityId = 'A04Y'
		public static constant integer favouriteAbilityId = 'A04Z'
		public static constant integer classSelectionAbilityId = 'A0PL'
		public static constant integer classSelectionGrimoireAbilityId = 'A0PQ'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			
			call this.addGrimoireEntry('A0PL', 'A0PQ')
			call this.addGrimoireEntry('A0PM', 'A0PR')
			call this.addGrimoireEntry('A0PN', 'A0PS')
			call this.addGrimoireEntry('A0PO', 'A0PT')
			call this.addGrimoireEntry('A0PP', 'A0PU')
			
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod
	endstruct

endlibrary