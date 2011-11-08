/// Cleric
library StructSpellsSpellRecovery requires Asl, StructGameClasses, StructGameSpell

	/**
	* Heilt ein befreundetes Ziel 10 Sekunden lang um X Lebenspunkte pro Sekunde.
	* Insgesamt etwas mehr geheilt als Linderung.
	*/
	struct SpellRecovery extends Spell
		public static constant integer abilityId = 'A06A'
		public static constant integer favouriteAbilityId = 'A06B'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary