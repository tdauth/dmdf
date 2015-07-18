// Knight
library StructSpellsSpellStab requires Asl, StructGameClasses, StructGameSpell

	/// Fügt dem angewählten Ziel X Punkte Schaden zu.
	struct SpellStab extends Spell
		public static constant integer abilityId = 'A027'
		public static constant integer favouriteAbilityId = 'A041'
		public static constant integer classSelectionAbilityId = 'A0Y2'
		public static constant integer classSelectionGrimoireAbilityId = 'A0Y7'
		public static constant integer maxLevel = 5
		private static constant real damageFactor = 80.0

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local real damage = this.level() * thistype.damageFactor
			call TriggerSleepAction(0.0) // killing the unit with stab prevents the cooldown!
			call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
			call Spell.showDamageTextTag(target, damage)
			set target = null
			set caster = null
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			
			call this.addGrimoireEntry('A0Y2', 'A0Y7')
			call this.addGrimoireEntry('A0Y3', 'A0Y8')
			call this.addGrimoireEntry('A0Y4', 'A0Y9')
			call this.addGrimoireEntry('A0Y5', 'A0YA')
			call this.addGrimoireEntry('A0Y6', 'A0YB')
			
			return this
		endmethod
	endstruct

endlibrary
