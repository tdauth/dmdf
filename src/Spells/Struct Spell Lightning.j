/// Elemental Mage
library StructSpellsSpellLightning requires Asl, StructSpellsSpellElementalMageDamageSpell

	/// Ein Blitzschlag erfasst das Ziel, verursacht X Punkte Schaden.
	struct SpellLightning extends SpellElementalMageDamageSpell
		public static constant integer abilityId = 'A018'
		public static constant integer favouriteAbilityId = 'A02C'
		public static constant integer maxLevel = 5
		private static constant real startDamageValue = 0.0
		private static constant real levelDamageFactor = 100.0

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
			local thistype this = thistype.allocate(character, Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A0UL', 'A0UQ')
			call this.addGrimoireEntry('A0UM', 'A0UR')
			call this.addGrimoireEntry('A0UN', 'A0US')
			call this.addGrimoireEntry('A0UO', 'A0UT')
			call this.addGrimoireEntry('A0UP', 'A0UU')
			
			return this
		endmethod
	endstruct

endlibrary