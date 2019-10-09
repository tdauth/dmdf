/// Wizard
library StructSpellsSpellManaStream requires Asl, StructGameClasses, StructGameSpell

	/// Der Zauberer sendet seine Manaenergien 5 Sekunden lang in den Gegner und verursacht so pro Sekunde X Schaden und nach 5 Sekunden Y Schaden.
	struct SpellManaStream extends Spell
		public static constant integer abilityId = 'A08Q'
		public static constant integer favouriteAbilityId = 'A08R'
		public static constant integer classSelectionAbilityId = 'A1MD'
		public static constant integer classSelectionGrimoireAbilityId = 'A1ME'
		public static constant integer maxLevel = 5
		/// @todo FIXME
		private static constant integer buffId = 0
		private static constant real time = 5.0
		private static constant real loopDamageStartValue = 10.0
		private static constant real loopDamageLevelValue = 5.0
		private static constant real damageStartValue = 100.0
		private static constant real damageLevelValue = 50.0
		private static constant real range = 900.0

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local ADynamicLightning dynamicLightning = ADynamicLightning.create(null, "DRAM", caster, target)
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "chest")
			local effect targetEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "chest")
			local effect areaEffect
			local real loopDamage = thistype.loopDamageStartValue + this.level() * thistype.loopDamageLevelValue
			local real damage = thistype.damageStartValue + this.level() * thistype.damageLevelValue
			local real time = thistype.time
			call dynamicLightning.setDestroyOnDeath(false) // prevent double free
			loop
				exitwhen (AUnitSpell.enemyTargetLoopCondition(target) or time <= 0.0 or IsUnitType(caster, UNIT_TYPE_STUNNED) or IsUnitDeadBJ(caster) or GetDistanceBetweenUnitsWithoutZ(caster, target) > thistype.range)
				call UnitDamageTargetBJ(caster, target, loopDamage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC)
				call ShowBashTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(loopDamage))
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			if (not AUnitSpell.enemyTargetLoopCondition(target) and not IsUnitDeadBJ(caster) and not IsUnitType(caster, UNIT_TYPE_STUNNED)) then
				set areaEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_AREA_EFFECT, target, "origin")
				call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC)
				call ShowBashTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(damage))
				call DestroyEffect(areaEffect)
				set areaEffect = null
			endif
			set caster = null
			set target = null
			call dynamicLightning.destroy()
			call DestroyEffect(casterEffect)
			set casterEffect = null
			call DestroyEffect(targetEffect)
			set targetEffect = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithEvent(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action, EVENT_PLAYER_UNIT_SPELL_EFFECT) // if the event channel is used, the cooldown and mana costs are ignored if UnitDamageTargetBJ() kills the target
			call this.addGrimoireEntry('A1MD', 'A1ME')
			call this.addGrimoireEntry('A15H', 'A15M')
			call this.addGrimoireEntry('A15I', 'A15N')
			call this.addGrimoireEntry('A15J', 'A15O')
			call this.addGrimoireEntry('A15K', 'A15P')
			call this.addGrimoireEntry('A15L', 'A15Q')

			return this
		endmethod
	endstruct

endlibrary
