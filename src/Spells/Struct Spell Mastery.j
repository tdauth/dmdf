/// Elemental Mage
library StructSpellsSpellMastery requires Asl, StructGameClasses, StructGameSpell

	/// Grundfähigkeit: Passiv. Der Elementarmagier regeneriert alle 60 Sekunden X Mana.
	struct SpellMastery extends Spell
		public static constant integer abilityId = 'A01F'
		public static constant integer favouriteAbilityId = 'A034'
		public static constant integer maxLevel = 5
		private static constant real interval = 60.0 //constant, does not change per level.
		private static constant real manaLevelValue = 10.0 //changes per level.
		private timer m_effectTimer

		private static method timerFunction takes nothing returns nothing
			local timer expiredTimer = GetExpiredTimer()
			local thistype this = DmdfHashTable.global().handleInteger(expiredTimer, "this")
			local unit caster
			local real mana
			local effect spellEffect
			if (this.level() > 0) then
				set mana = this.level() * thistype.manaLevelValue
				debug call Print("Mastery with " + R2S(mana) + " Mana.")
				if (mana > 0) then
					set caster = this.character().unit()
					call SetUnitState(caster, UNIT_STATE_MANA, GetUnitState(caster, UNIT_STATE_MANA) + mana)
					if (not IsUnitHidden(caster)) then
						set spellEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "chest")
						call Spell.showManaTextTag(caster, mana)
						call DestroyEffect(spellEffect)
						set spellEffect = null
					endif
					set caster = null
				endif
			endif
			set expiredTimer = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			set this.m_effectTimer = CreateTimer()
			call TimerStart(this.m_effectTimer, thistype.interval, true, function thistype.timerFunction)
			call DmdfHashTable.global().setHandleInteger(this.m_effectTimer, "this", this)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call PauseTimer(this.m_effectTimer)
			call DmdfHashTable.global().destroyTimer(this.m_effectTimer)
			set this.m_effectTimer = null
		endmethod
	endstruct

endlibrary