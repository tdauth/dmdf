/// Necromancer
library StructSpellsSpellViolentDeath requires Asl, StructGameClasses, StructGameSpell

	/**
	* Das Ziel erhält X Punkte Schaden und wird für 3 Sekunden betäubt. 3 Minuten Abklingzeit.
	* Sehr viel Schaden, mehr als Parasit, ca das Doppelte.
	*/
	struct SpellViolentDeath extends Spell
		public static constant integer abilityId = 'A06E'
		public static constant integer favouriteAbilityId = 'A06F'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary