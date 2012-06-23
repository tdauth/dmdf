/// Knight
library StructSpellsSpellStab requires Asl, StructGameClasses, StructGameSpell

	/// Fügt dem angewählten Ziel X Punkte Schaden zu.
	struct SpellStab extends Spell
		public static constant integer abilityId = 'A027'
		public static constant integer favouriteAbilityId = 'A041'
		public static constant integer maxLevel = 5
		private static constant real damageFactor = 80.0 //Schadens-Stufenfaktor (ab Stufe 1)

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local real damage = this.level() * thistype.damageFactor
			call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
			call Spell.showDamageTextTag(target, damage)
			set target = null
			set caster = null
		endmethod

		public static method create takes ACharacter character returns thistype
			return thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary
