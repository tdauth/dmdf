/// Knight
library StructSpellsSpellConcentration requires Asl, StructGameClasses, StructGameSpell

	/// Passiv. Der Ritter regeneriert alle 10 Sekunden 1/2/3/4/5% seiner maximalen Lebenspunkte.
	struct SpellConcentration extends Spell
		public static constant integer abilityId = 'A02A'
		public static constant integer favouriteAbilityId = 'A03Z'
		public static constant integer maxLevel = 5
		private static constant real interval = 10.0 //constant, does not change per level.
		private static constant integer lifeLevelValue = 1 // percentage
		private timer effectTimer

		private static method timerFunction takes nothing returns nothing
			local timer expiredTimer = GetExpiredTimer()
			local thistype this = DmdfHashTable.global().handleInteger(expiredTimer, "this")
			local unit caster = this.character().unit()
			local real life
			if (this.level() > 0 and GetUnitMissingLife(caster) > 0.0) then
				set life = this.level() * thistype.lifeLevelValue * GetUnitState(caster, UNIT_STATE_MAX_LIFE) / 100.0
				call SetUnitState(caster, UNIT_STATE_LIFE, GetUnitState(caster, UNIT_STATE_LIFE) + life)
				call Spell.showLifeTextTag(caster, life)
			endif
			set expiredTimer = null
			set caster = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this =  thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			set this.effectTimer = CreateTimer()
			call TimerStart(this.effectTimer, thistype.interval, true, function thistype.timerFunction)
			call DmdfHashTable.global().setHandleInteger(this.effectTimer, "this", this)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call PauseTimer(this.effectTimer)
			call DmdfHashTable.global().destroyTimer(this.effectTimer)
			set this.effectTimer = null
		endmethod
	endstruct

endlibrary