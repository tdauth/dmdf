/// Cleric
library StructSpellsSpellTorment requires Asl, StructGameClasses, StructGameSpell

	/// Fügt feindlichen Wesen X Punkte Schaden zu. Wenig, Kleriker sind Heiler.
	struct SpellTorment extends Spell
		public static constant integer abilityId = 'A04Y'
		public static constant integer favouriteAbilityId = 'A04Z'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod
	endstruct

endlibrary