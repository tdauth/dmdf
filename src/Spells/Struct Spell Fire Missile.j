/// Elemental Mage
library StructSpellsSpellFireMissile requires Asl, StructSpellsSpellElementalMageDamageSpell

	struct SpellFireMissile extends SpellElementalMageDamageSpell
		public static constant integer abilityId = 'A014'
		public static constant integer favouriteAbilityId = 'A03K'
		public static constant integer maxLevel = 5
		private static constant real damageStartValue = 35.0
		private static constant real damageFactor = 15.0 // Schadens-Stufenfaktor (ab Stufe 1)
		private static constant real burnDamageStartValue = 2.0
		private static constant real burnDamageFactor = 2.0 // Schadens-Stufenfaktor (ab Stufe 1)
		private static constant real time = 3.0 // Zeitkonstante (unverändert)

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local real damage = thistype.damageStartValue + this.level() * thistype.damageFactor
			local real time
			local effect burnEffect
			debug call Print("Fire missile on " + GetUnitName(target))
			set damage = damage +  SpellElementalMageDamageSpell(this).damageBonusFactor() * damage
			call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE)
			call ShowBashTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(damage))
			//burn target
			set burnEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "chest")
			set time = thistype.time
			loop
				exitwhen (time <= 0.0 or ASpell.enemyTargetLoopCondition(target))
				set damage = thistype.burnDamageStartValue + this.level() * thistype.burnDamageFactor
				set damage = damage + SpellElementalMageDamageSpell(this).damageBonusFactor() * damage
				call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE)
				call Spell.showDamageTextTag(target, damage)
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			set caster = null
			set target = null
			call DestroyEffect(burnEffect)
			set burnEffect = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A0KP', 'A0KU')
			call this.addGrimoireEntry('A0KQ', 'A0KV')
			call this.addGrimoireEntry('A0KR', 'A0KW')
			call this.addGrimoireEntry('A0KS', 'A0KX')
			call this.addGrimoireEntry('A0KT', 'A0KY')
			
			return this
		endmethod
	endstruct

endlibrary