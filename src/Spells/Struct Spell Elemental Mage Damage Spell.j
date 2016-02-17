/// Elemental Mage
library StructSpellsSpellElementalMageDamageSpell requires Asl, StructGameClasses, StructGameSpell

	struct SpellElementalMageDamageSpell extends Spell
		private real m_damageBonusFactor

		public method addDamageBonusFactor takes real damageBonusFactor returns nothing
			set this.m_damageBonusFactor = this.m_damageBonusFactor + damageBonusFactor
		endmethod

		public method removeDamageBonusFactor takes real damageBonusFactor returns nothing
			set this.m_damageBonusFactor = RMaxBJ(this.m_damageBonusFactor - damageBonusFactor, 0.0)
		endmethod

		public method damageBonusFactor takes nothing returns real
			return this.m_damageBonusFactor
		endmethod

		public static method spellIsDamageSpell takes ASpell spell returns boolean
			return spell.ability() == SpellBlaze.abilityId or spell.ability() == SpellIceAge.abilityId or spell.ability() == SpellFireMissile.abilityId or spell.ability() == SpellIceMissile.abilityId or spell.ability() == SpellInferno.abilityId or spell.ability() == SpellPureEnergy.abilityId or spell.ability() == SpellLightning.abilityId
		endmethod

		public static method create takes Character character, integer spellType, integer maxLevel, integer abilityId, integer favouriteAbilityId, ASpellUpgradeAction upgradeAction, ASpellCastCondition castCondition, ASpellCastAction castAction returns thistype
			return thistype.allocate(character, Classes.elementalMage(), spellType, maxLevel, abilityId, favouriteAbilityId, upgradeAction, castCondition, castAction)
		endmethod
		
		public static method createWithEventDamageSpell takes Character character, integer spellType, integer maxLevel, integer abilityId, integer favouriteAbilityId, ASpellUpgradeAction upgradeAction, ASpellCastCondition castCondition, ASpellCastAction castAction, playerunitevent unitEvent returns thistype
			return thistype.createWithEvent(character, Classes.elementalMage(), spellType, maxLevel, abilityId, favouriteAbilityId, upgradeAction, castCondition, castAction, unitEvent)
		endmethod
	endstruct

endlibrary