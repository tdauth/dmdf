/// Knight
library StructSpellsSpellResolution requires Asl, StructGameClasses, StructGameSpell

	struct SpellResolution extends Spell
		public static constant integer abilityId = 'A028'
		public static constant integer favouriteAbilityId = 'A040'
		public static constant integer maxLevel = 5

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			call UnitRemoveBuffsEx(caster, false, true, true, false, true, true, false)
			set caster = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary