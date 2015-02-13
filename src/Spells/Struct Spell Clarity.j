/// Cleric
library StructSpellsSpellClarity requires Asl, StructGameClasses, StructGameSpell

	/**
	 * Der Kleriker befreit einen Verbündeten von allen negativen Effekten.
	 * Die Abklingzeit sinkt pro Stufe.
	 */
	struct SpellClarity extends Spell
		public static constant integer abilityId = 'A052'
		public static constant integer favouriteAbilityId = 'A053'
		public static constant integer maxLevel = 5

		private method action takes nothing returns nothing
			call UnitRemoveBuffs(GetSpellTargetUnit(), false, true)
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary