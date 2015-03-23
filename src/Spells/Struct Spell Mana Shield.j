/// Wizard
library StructSpellsSpellManaShield requires Asl, StructGameClasses, StructGameSpell

	/// Der Zauberer erschafft ein Manaschild um sich herum, das Schaden absorbiert. Verbraucht X Mana pro Schadenspunt und absorbiert maximal Y Schaden.
	struct SpellManaShield extends Spell
		public static constant integer abilityId = 'A03A'
		public static constant integer favouriteAbilityId = 'A03E'
		public static constant integer maxLevel = 5
		private static constant integer buffId = 'B00G'
		private static constant real absorbedDamageManaCostStartValue = 6.0 /// Costs per damage point.
		private static constant real absorbedDamageManaCostLevelValue = 1.0 /// Costs per damage point.
		private static constant real maxAbsorbedDamageLevelValue = 100.0
		private ADamageRecorder m_damageRecorder
		private real m_absorbedDamage
		private effect m_effect

		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local thistype spell = DmdfHashTable.global().integer("SpellManaShield" + I2S(damageRecorder), "spell")
			local unit caster = damageRecorder.target()
			local real maxAbsorbedDamage = spell.level() * thistype.maxAbsorbedDamageLevelValue
			local real absorbedDamage
			local real manaCostPerDamagePoint = thistype.absorbedDamageManaCostStartValue - thistype.absorbedDamageManaCostLevelValue * spell.level()
			local real manaCost = GetEventDamage() * manaCostPerDamagePoint
			local boolean disable = false

			if (manaCost > GetUnitState(caster, UNIT_STATE_MANA)) then
				set absorbedDamage = GetUnitState(caster, UNIT_STATE_MANA) / manaCostPerDamagePoint
			else
				set absorbedDamage = GetEventDamage()
			endif

			if (spell.m_absorbedDamage + absorbedDamage > maxAbsorbedDamage) then
				set absorbedDamage = maxAbsorbedDamage - spell.m_absorbedDamage
				set disable = true
			endif

			set manaCost = absorbedDamage * manaCostPerDamagePoint
			/// @todo Show casting effect
			call SetUnitState(caster, UNIT_STATE_MANA, GetUnitState(caster, UNIT_STATE_MANA) - manaCost)
			
			if (GetUnitState(caster, UNIT_STATE_MANA) <= 0.0) then
				set disable = true
			endif
			
			call SetUnitState(caster, UNIT_STATE_LIFE, GetUnitState(caster, UNIT_STATE_LIFE) + absorbedDamage)
			call thistype.showDamageAbsorbationTextTag(caster, absorbedDamage)

			if (disable) then
				call damageRecorder.disable()
				set spell.m_absorbedDamage = 0.0
				call DestroyEffect(spell.m_effect)
				set spell.m_effect = null
			else
				set spell.m_absorbedDamage = spell.m_absorbedDamage + absorbedDamage
			endif

			set caster = null
		endmethod

		private method action takes nothing returns nothing
			debug call Print("Casting mana shield.")
			if (this.m_damageRecorder == 0) then
				debug call Print("Creating damage recorder.")
				set this.m_damageRecorder = ADamageRecorder.create(this.character().unit())
				call this.m_damageRecorder.setOnDamageAction(thistype.onDamageAction)
				call DmdfHashTable.global().setInteger("SpellManaShield" + I2S(this.m_damageRecorder), "spell", this)
				call this.m_damageRecorder.disable()
			endif
			if (this.m_damageRecorder.isEnabled()) then
				debug call Print("Disable mana shield.")
				call this.m_damageRecorder.disable()
				set this.m_absorbedDamage = 0.0
				call DestroyEffect(this.m_effect)
				set this.m_effect = null
			else
				debug call Print("Enable mana shield.")
				call this.m_damageRecorder.enable()
				set this.m_effect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, this.character().unit(), "chest")
			endif
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			set this.m_damageRecorder = 0
			set this.m_absorbedDamage = 0.0
			set this.m_effect = null
			
			call this.addGrimoireEntry('A0W6', 'A0WB')
			call this.addGrimoireEntry('A0W7', 'A0WC')
			call this.addGrimoireEntry('A0W8', 'A0WD')
			call this.addGrimoireEntry('A0W9', 'A0WE')
			call this.addGrimoireEntry('A0WA', 'A0WF')

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			if (this.m_damageRecorder != 0) then
				call DmdfHashTable.global().flushKey("SpellManaShield" + I2S(this.m_damageRecorder))
				call this.m_damageRecorder.destroy()
			endif
			if (this.m_effect != null) then
				call DestroyEffect(this.m_effect)
				set this.m_effect = null
			endif
		endmethod
	endstruct

endlibrary