/// Cleric
library StructSpellsSpellAbatement requires Asl, StructGameClasses, StructGameSpell

	/// Heilt ein befreundetes Ziel um X Lebenspunkte. Relativ hohe Sofortheilung.
	struct SpellAbatement extends Spell
		public static constant integer abilityId = 'A04W'
		public static constant integer favouriteAbilityId = 'A04X'
		public static constant integer maxLevel = 5
		private static constant real healLevelValue = 400.0

		private method action takes nothing returns nothing
			local unit target = GetSpellTargetUnit()
			local effect targetEffect =  AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "origin")
			local real life = this.level() * thistype.healLevelValue
			call SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE) + life)
			call TriggerSleepAction(1.0)
			set target = null
			call DestroyEffect(targetEffect)
			set targetEffect = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary