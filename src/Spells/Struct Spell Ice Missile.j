/// Elemental Mage
library StructSpellsSpellIceMissile requires Asl, StructSpellsSpellElementalMageDamageSpell

	private struct SpellIceMissileType extends AMissileType
		private Character m_character
		private unit m_targetUnit
		
		private static method freezeTarget takes SpellIceMissile spell, unit caster, unit target returns nothing
			local real oldMoveSpeed = GetUnitMoveSpeed(target)
			local real moveSpeedDifference = oldMoveSpeed * spell.level() * SpellIceMissile.speedFactor
			local real moveSpeed = oldMoveSpeed - moveSpeedDifference
			local real time
			local effect freezeEffect = AddSpellEffectTargetById(SpellIceMissile.abilityId, EFFECT_TYPE_TARGET, target, "chest")
			call SetUnitMoveSpeed(target, moveSpeed)
			call Spell.showMoveSpeedTextTag(target, -moveSpeedDifference)
			debug call Print("New move speed: " + R2S(moveSpeed) + " and old move speed " + R2S(oldMoveSpeed))
			set time = SpellIceMissile.time
			loop
				exitwhen (time <= 0.0 or ASpell.enemyTargetLoopCondition(target))
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			debug call Print("Resetting old move speed")
			call SetUnitMoveSpeed(target, oldMoveSpeed)
			call DestroyEffect(freezeEffect)
			set freezeEffect = null
		endmethod
		
		private static method damage takes AMissile missile returns nothing
			local thistype this = thistype(missile.missileType())
			local unit caster = this.m_character.unit()
			local integer level = GetUnitAbilityLevel(caster, SpellIceMissile.abilityId)
			local SpellIceMissile spell = SpellIceMissile(this.m_character.spellByAbilityId(SpellIceMissile.abilityId)) // TODO slow
			local unit target = this.m_targetUnit
			local real damage = spell.level() * SpellIceMissile.damageFactor
			set damage = damage + SpellElementalMageDamageSpell(this).damageBonusFactor() * damage
			call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_COLD)
			call ShowBashTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(damage))
			// execute since this method is called by .evaluate and the missile is destroyed afterwards
			call thistype.freezeTarget.execute(spell, caster, target)
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
			call this.setUnitType('n06M')
			call this.setSpeed(700.0)
			call this.setTargetSeeking(true)
			call this.setDestroyOnDeath(true)
			call this.setOnDeathFunction(thistype.customOnDeathFunction)
			
			return this
		endmethod
		
	endstruct

	/// Wirft ein Eisgeschoss auf den Gegner, verursacht X Punkte Schaden und verringert die Bewegungs- und Angriffsgeschwindigkeit um Y %.
	struct SpellIceMissile extends SpellElementalMageDamageSpell
		public static constant integer abilityId = 'A017'
		public static constant integer favouriteAbilityId = 'A039'
		public static constant integer classSelectionAbilityId = 'A0T7'
		public static constant integer classSelectionGrimoireAbilityId = 'A0TC'
		public static constant integer maxLevel = 5
		public static constant real damageFactor = 50.0 // Schadens-Stufenfaktor (ab Stufe 1)
		public static constant real speedFactor = 0.10 // Angriffs- und Bewegungsgeschwindigkeitsfaktor (ab Stufe 1, prozentual also 10 %)
		public static constant real time = 3.0 // Zeitkonstante (unverändert)

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local SpellIceMissileType missileType = SpellIceMissileType.create(this.character(), target)
			local AMissile missile = AMissile.create()
			call missile.setMissileType(missileType)
			call missile.setTargetWidget(target)
			call missile.startFromUnit(caster)
			debug call Print("Ice missile on " + GetUnitName(target))
			set caster = null
			set target = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			
			call this.addGrimoireEntry('A0T7', 'A0TC')
			call this.addGrimoireEntry('A0T8', 'A0TD')
			call this.addGrimoireEntry('A0T9', 'A0TE')
			call this.addGrimoireEntry('A0TA', 'A0TF')
			call this.addGrimoireEntry('A0TB', 'A0TG')
			
			return this
		endmethod
	endstruct

endlibrary