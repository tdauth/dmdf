/// Elemental Mage
library StructSpellsSpellFireMissile requires Asl, StructSpellsSpellElementalMageDamageSpell

	private struct SpellFireMissileType extends AMissileType
		private Character m_character
		private unit m_targetUnit
		
		private static method burnTarget takes SpellFireMissile spell, unit caster, unit target returns nothing
			local real damage = 0.0
			local effect burnEffect = AddSpellEffectTargetById(SpellFireMissile.abilityId, EFFECT_TYPE_TARGET, target, "chest")
			local real time = SpellFireMissile.time
			loop
				call TriggerSleepAction(1.0)
				set time = time - 1.0
				exitwhen (time <= 0.0 or ASpell.enemyTargetLoopCondition(target))
				set damage = SpellFireMissile.burnDamageStartValue + spell.level() * SpellFireMissile.burnDamageFactor
				set damage = damage + spell.damageBonusFactor() * damage
				call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE)
				call Spell.showDamageTextTag(target, damage)
			endloop
			
			set caster = null
			set target = null
			call DestroyEffect(burnEffect)
			set burnEffect = null
		endmethod
		
		private static method damage takes AMissile missile returns nothing
			local thistype this = thistype(missile.missileType())
			local unit caster = this.m_character.unit()
			local integer level = GetUnitAbilityLevel(caster, SpellFireMissile.abilityId)
			local SpellFireMissile spell = SpellFireMissile(this.m_character.spellByAbilityId(SpellFireMissile.abilityId)) // TODO slow function
			local unit target = this.m_targetUnit
			local real damage = SpellFireMissile.damageStartValue + level * SpellFireMissile.damageFactor
			set damage = damage + spell.damageBonusFactor() * damage
			call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE)
			call ShowBashTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(damage))
			// execute since this method is called by .evaluate and the missile is destroyed afterwards
			call thistype.burnTarget.execute(spell, caster, target)
			set caster = null
			set target = null
		endmethod
	
		private static method customOnDeathFunction takes AMissile missile returns nothing
			local thistype this = thistype(missile.missileType())
			if (not IsUnitDeadBJ(this.m_targetUnit)) then
				call thistype.damage(missile)
			endif
		endmethod
		
		public static method create takes Character character, unit targetUnit returns thistype
			local thistype this = thistype.allocate()
			
			set this.m_character = character
			set this.m_targetUnit = targetUnit
			
			call this.setOwner(character.player())
			call this.setUnitType('n00E')
			call this.setSpeed(700.0)
			call this.setTargetSeeking(true)
			call this.setDestroyOnDeath(true)
			call this.setOnDeathFunction(thistype.customOnDeathFunction)
			
			return this
		endmethod
		
	endstruct

	struct SpellFireMissile extends SpellElementalMageDamageSpell
		public static constant integer abilityId = 'A014'
		public static constant integer favouriteAbilityId = 'A03K'
		public static constant integer classSelectionAbilityId = 'A0KP'
		public static constant integer classSelectionGrimoireAbilityId = 'A0KU'
		public static constant integer maxLevel = 5
		public static constant real damageStartValue = 35.0
		public static constant real damageFactor = 15.0 // Schadens-Stufenfaktor (ab Stufe 1)
		public static constant real burnDamageStartValue = 2.0
		public static constant real burnDamageFactor = 2.0 // Schadens-Stufenfaktor (ab Stufe 1)
		public static constant real time = 3.0 // Zeitkonstante (unverändert)

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local SpellFireMissileType missileType = SpellFireMissileType.create(this.character(), target)
			local AMissile missile = AMissile.create()
			call missile.setMissileType(missileType)
			call missile.setTargetWidget(target)
			call missile.startFromUnit(caster)
			debug call Print("Fire missile on " + GetUnitName(target))
			set caster = null
			set target = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, thistype.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A0KP', 'A0KU')
			call this.addGrimoireEntry('A0KQ', 'A0KV')
			call this.addGrimoireEntry('A0KR', 'A0KW')
			call this.addGrimoireEntry('A0KS', 'A0KX')
			call this.addGrimoireEntry('A0KT', 'A0KY')
			
			return this
		endmethod
	endstruct

endlibrary