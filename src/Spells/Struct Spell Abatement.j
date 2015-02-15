/// Cleric
library StructSpellsSpellAbatement requires Asl, StructGameClasses, StructGameSpell

	/// Heilt ein befreundetes Ziel um X Lebenspunkte. Relativ hohe Sofortheilung.
	struct SpellAbatement extends Spell
		public static constant integer abilityId = 'A04W'
		public static constant integer favouriteAbilityId = 'A04X'
		public static constant integer maxLevel = 5
		private static constant real healStartValue = 50.0
		private static constant real healLevelValue = 50.0

		private method action takes nothing returns nothing
			local unit target = GetSpellTargetUnit()
			local effect targetEffect =  AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "origin")
			local real life = thistype.healStartValue + this.level() * thistype.healLevelValue
			call SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE) + life)
			call thistype.showLifeTextTag(target, life)
			call TriggerSleepAction(1.0)
			set target = null
			call DestroyEffect(targetEffect)
			set targetEffect = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			
			call this.addGrimoireEntry('A0OD', 'A0OI')
			call this.addGrimoireEntry('A0OE', 'A0OJ')
			call this.addGrimoireEntry('A0OF', 'A0OK')
			call this.addGrimoireEntry('A0OG', 'A0OL')
			call this.addGrimoireEntry('A0OH', 'A0OM')
			
			return this
		endmethod
	endstruct

endlibrary