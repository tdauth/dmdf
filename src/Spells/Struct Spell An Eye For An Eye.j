/// Dragon Slayer
library StructSpellsSpellAnEyeForAnEye requires Asl, StructGameClasses, StructGameSpell

	/// Der Drachentöter kontert die nächsten zwei Nahkampfangriffe eines Gegners und lenkt X % des Schadens auf ihn zurück. Der Drachentöter erleidet keinen Schaden. 1 Minute Abklingzeit.
	struct SpellAnEyeForAnEye extends Spell
		public static constant integer abilityId = 'A1G8'
		public static constant integer favouriteAbilityId = 'A1G9'
		public static constant integer classSelectionAbilityId = 'A1GA'
		public static constant integer classSelectionGrimoireAbilityId = 'A1GF'
		public static constant integer maxLevel = 5
		private static constant integer maxCount = 4
		private static constant real damageLevelFactor = 0.05
		private static constant string damageKey = "SpellAnEyeForAnEye:Damage"
		private ADamageRecorder m_damageRecorder
		private integer m_count
		private unit m_target
		
		private method disable takes nothing returns nothing
			call DmdfHashTable.global().flushKey("SpellAnEyeForAnEye" + I2S(this.m_damageRecorder))
			call this.m_damageRecorder.destroy()
			set this.m_damageRecorder = 0
			set this.m_count = 0
			set this.m_target = null
		endmethod

		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local thistype spell = DmdfHashTable.global().integer("SpellAnEyeForAnEye" + I2S(damageRecorder), "this")
			local unit caster = damageRecorder.target()
			local unit target = GetEventDamageSource()
			local real damage = GetEventDamage() * thistype.damageLevelFactor
			
			if (not DmdfHashTable.global().hasHandleBoolean(GetEventDamageSource(), thistype.damageKey)) then
				if (spell.m_count == 0 or target == spell.m_target) then
					debug call Print("Damage: " + R2S(GetEventDamage()) + " and percentage damage; " + R2S(damage))
					call SetUnitState(caster, UNIT_STATE_LIFE, GetUnitState(caster, UNIT_STATE_LIFE) + GetEventDamage())
					
					call Spell.showDamageAbsorbationTextTag(caster, GetEventDamage())
					
					call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), thistype.damageKey, true)
					call UnitDamageTargetBJ(target, caster, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
					call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), thistype.damageKey, false)

					call ShowBashTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(damage))
					set spell.m_count = spell.m_count + 1
					
					// remember target
					if (spell.m_count == 1) then
						set spell.m_target = target
					endif
					
					if (spell.m_count == thistype.maxCount) then
						call spell.disable()
					endif
				endif
			endif
			
			set caster = null
			set target = null
		endmethod
		
		private method condition takes nothing returns boolean
			return true
		endmethod
		
		private static method timerFunctionDisable takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), "this"))
			call this.disable()
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local ADamageRecorder damageRecorder = ADamageRecorder.create(caster)
			// reset old running effect
			set this.m_count = 0
			if (this.m_damageRecorder != 0) then
				call this.m_damageRecorder.destroy()
			endif
			call damageRecorder.setOnDamageAction(thistype.onDamageAction)
			call DmdfHashTable.global().setInteger("SpellAnEyeForAnEye" + I2S(damageRecorder), "this", this)
			set this.m_damageRecorder = damageRecorder
			set caster = null
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			set this.m_damageRecorder = 0
			set this.m_count = 0
			set this.m_target = null
			
			call this.addGrimoireEntry('A04Y', 'A04Z')
			call this.addGrimoireEntry('A1GA', 'A1GF')
			call this.addGrimoireEntry('A1GB', 'A1GG')
			call this.addGrimoireEntry('A1GC', 'A1GH')
			call this.addGrimoireEntry('A1GD', 'A1GI')
			call this.addGrimoireEntry('A1GE', 'A1GJ')
			
			return this
		endmethod
	endstruct

endlibrary