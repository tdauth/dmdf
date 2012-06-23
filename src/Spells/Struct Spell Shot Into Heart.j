/// Ranger
library StructSpellsSpellShotIntoHeart requires Asl, StructGameClasses, StructGameSpell

	/// Der Waldläufer schießt ins Herz seines Ziels und fügt X Punkte Schaden zu.
	struct SpellShotIntoHeart extends Spell
		public static constant integer abilityId = 'A06Q'
		public static constant integer favouriteAbilityId = 'A06R'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.ranger(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary