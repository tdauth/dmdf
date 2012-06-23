/// Cleric
library StructSpellsSpellAstralSource requires Asl, StructGameClasses, StructGameSpell

	/**
	* Passiv. Die Manaregeneration des Klerikers wird um X % erhöht.
	* Zum Schluss 20 % oder sowas.
	*/
	struct SpellAstralSource extends Spell
		public static constant integer abilityId = 'A06C'
		public static constant integer favouriteAbilityId = 'A06D'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.cleric(), thistype.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary