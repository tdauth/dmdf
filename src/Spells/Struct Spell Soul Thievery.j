/// Necromancer
library StructSpellsSpellSoulThievery requires Asl, StructGameClasses, StructGameSpell

	/**
	* Stiehlt dem feindlichen Ziel seine Seele und entzieht ihm pro Sekunde X Leben und Mana. Hält 5 Sekunden lang an.
	* Etwas mehr Schaden als Qualen.
	*/
	struct SpellSoulThievery extends Spell
		public static constant integer abilityId = 'A06J'
		public static constant integer favouriteAbilityId = 'A06K'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary