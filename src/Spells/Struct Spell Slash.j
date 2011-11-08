/// Dragon Slayer
library StructSpellsSpellSlash requires Asl, StructGameClasses, StructGameSpell

	/// Der Drachentöter schlägt kraftvoll zu und fügt dem angewählten Ziel X Punkte Schaden zu.
	struct SpellSlash extends Spell
		public static constant integer abilityId = 'A070'
		public static constant integer favouriteAbilityId = 'A071'
		public static constant integer maxLevel = 5

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary