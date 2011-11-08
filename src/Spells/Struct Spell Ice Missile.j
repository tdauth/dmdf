/// Elemental Mage
library StructSpellsSpellIceMissile requires Asl, StructSpellsSpellElementalMageDamageSpell

	/// Wirft ein Eisgeschoss auf den Gegner, verursacht X Punkte Schaden und verringert die Bewegungs- und Angriffsgeschwindigkeit um Y %.
	struct SpellIceMissile extends SpellElementalMageDamageSpell
		public static constant integer abilityId = 'A017'
		public static constant integer favouriteAbilityId = 'A039'
		public static constant integer maxLevel = 5
		private static constant real damageFactor = 50.0 // Schadens-Stufenfaktor (ab Stufe 1)
		private static constant real speedFactor = 0.10 // Angriffs- und Bewegungsgeschwindigkeitsfaktor (ab Stufe 1, prozentual also 10 %)
		private static constant real time = 3.0 // Zeitkonstante (unverändert)

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local real damage = this.level() * thistype.damageFactor
			local real oldMoveSpeed = GetUnitMoveSpeed(target)
			local real moveSpeed = GetUnitMoveSpeed(target) + GetUnitMoveSpeed(target) * this.level() * thistype.speedFactor
			local real time
			local effect freezeEffect
			set damage = damage +  SpellElementalMageDamageSpell(this).damageBonusFactor() * damage
			call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_COLD)
			call ShowBashTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(damage))
			// freeze
			set freezeEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "chest")
			call SetUnitMoveSpeed(target, moveSpeed)
			set time = thistype.time
			loop
				exitwhen (time <= 0.0 or ASpell.enemyTargetLoopCondition(target))
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			call SetUnitMoveSpeed(target, oldMoveSpeed)
			set caster = null
			set target = null
			call DestroyEffect(freezeEffect)
			set freezeEffect = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary