/// Cleric
library StructSpellsSpellHolyWill requires Asl, StructGameClasses, StructGameSpell

	/// Die ausgewählte Einheit absorbiert 10 Sekunden lang 95% des ihr zugefügten Schadens. 5 Minuten Abklingzeit.
	struct SpellHolyWill extends Spell
		public static constant integer abilityId = 'A08D'
		public static constant integer favouriteAbilityId = 'A08E'
		public static constant integer maxLevel = 1
		private static constant integer time = 10
		private static constant integer percentage = 95

		private static method onDamageAction takes DamageProtector damageProtector returns nothing
			call Spell.showDamageAbsorbationTextTag(damageProtector.target(), damageProtector.lastPreventedDamage())
		endmethod

		public stub method onCastAction takes nothing returns nothing
			local DamageProtector damageProtector = DamageProtector.create(GetSpellTargetUnit())
			local effect targetEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, GetSpellTargetUnit(), "origin")
			local integer i
			call damageProtector.setProtectedDamagePercentage(thistype.percentage)
			call damageProtector.setOnDamageAction(thistype.onDamageAction)
			set i = thistype.time
			loop
				exitwhen (thistype.allyTargetLoopCondition(GetSpellTargetUnit()) or i == 0)
				call TriggerSleepAction(1.0)
				set i = i - 1
			endloop
			call damageProtector.destroy()
			call DestroyEffect(targetEffect)
			set targetEffect = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.cleric(), thistype.spellTypeUltimate1, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary