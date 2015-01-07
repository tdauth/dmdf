/// Elemental Mage
library StructSpellsSpellLightning requires Asl, StructSpellsSpellElementalMageDamageSpell

	/// Ein Blitzschlag erfasst das Ziel, verursacht X Punkte Schaden.
	struct SpellLightning extends SpellElementalMageDamageSpell
		public static constant integer abilityId = 'A018'
		public static constant integer favouriteAbilityId = 'A02C'
		public static constant integer maxLevel = 5
		private static constant real startDamageValue = 60.0
		private static constant real levelDamageFactor = 40.0

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local effect targetEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "chest") //AddSpecialEffectTarget("Models\\Effects\\Blitzschlag.mdl", target, "chest")
			local real damage = thistype.startDamageValue + this.level() * thistype.levelDamageFactor
			set damage = damage + SpellElementalMageDamageSpell(this).damageBonusFactor() * damage
			call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_LIGHTNING)
			call ShowBashTextTagForPlayer(null, GetWidgetX(target), GetWidgetY(target), R2I(damage))
			set caster = null
			set target = null
			call DestroyEffect(targetEffect)
			set targetEffect = null
		endmethod

		public static method create takes ACharacter character returns thistype
			return thistype.allocate(character, Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary