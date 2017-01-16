/// Knight
library StructSpellsSpellConcentration requires Asl, StructGameClasses, StructGameSpell

	/// Passiv. Der Ritter regeneriert alle 10 Sekunden 1/2/3/4/5% seiner maximalen Lebenspunkte.
	struct SpellConcentration extends Spell
		public static constant integer abilityId = 'A02A'
		public static constant integer favouriteAbilityId = 'A03Z'
		public static constant integer classSelectionAbilityId = 'A1JI'
		public static constant integer classSelectionGrimoireAbilityId = 'A1JJ'
		public static constant integer maxLevel = 5
		private static constant real interval = 10.0 //constant, does not change per level.
		private static constant integer lifeLevelValue = 5 // percentage
		private static sound whichSound
		private timer effectTimer

		private static method timerFunction takes nothing returns nothing
			local timer expiredTimer = GetExpiredTimer()
			local thistype this = thistype(DmdfHashTable.global().handleInteger(expiredTimer, 0))
			local unit caster = this.character().unit()
			local effect spellEffect = null
			local real life
			if (this.level() > 0 and GetUnitState(caster, UNIT_STATE_LIFE) < GetUnitState(caster, UNIT_STATE_MAX_LIFE)) then
				set life = this.level() * thistype.lifeLevelValue * GetUnitState(caster, UNIT_STATE_MAX_LIFE) / 100.0
				call SetUnitState(caster, UNIT_STATE_LIFE, GetUnitState(caster, UNIT_STATE_LIFE) + life)
				if (not IsUnitHidden(caster)) then
					call PlaySoundOnUnitBJ(thistype.whichSound, 60.0, caster)
					set spellEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, caster, "chest")
					call Spell.showLifeTextTag(caster, life)
					call DestroyEffect(spellEffect)
					set spellEffect = null
				endif
			endif
			set expiredTimer = null
			set caster = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			set this.effectTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.effectTimer, 0, this)
			call TimerStart(this.effectTimer, thistype.interval, true, function thistype.timerFunction)

			call this.addGrimoireEntry('A1JI', 'A1JJ')
			call this.addGrimoireEntry('A0XI', 'A0XN')
			call this.addGrimoireEntry('A0XJ', 'A0XO')
			call this.addGrimoireEntry('A0XK', 'A0XP')
			call this.addGrimoireEntry('A0XL', 'A0XQ')
			call this.addGrimoireEntry('A0XM', 'A0XR')

			call this.setIsPassive(true)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call PauseTimer(this.effectTimer)
			call DmdfHashTable.global().destroyTimer(this.effectTimer)
			set this.effectTimer = null
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.whichSound = CreateSound("Abilities\\Spells\\Items\\AIre\\RestorationPotion.wav", false, false, true, 12700, 12700, "")
		endmethod
	endstruct

endlibrary