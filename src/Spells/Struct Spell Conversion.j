/// Cleric
library StructSpellsSpellConversion requires Asl, StructGameClasses, StructGameSpell

	struct SpellConversionBuff
		private SpellConversion m_spell
		private unit m_target
		private player m_oldOwner
		private timer m_timer
		
		private static method timerFunction takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), 0))
			call UnitRemoveBuffBJ(SpellConversion.buffId, this.m_target)
			call SetUnitOwner(this.m_target, this.m_oldOwner, true)
			call this.destroy()
		endmethod
		
		public method start takes real time returns nothing
			call TimerStart(this.m_timer, time, false, function thistype.timerFunction)
			call UnitApplyTimedLife(this.m_target, SpellConversion.buffId, time + 2.0)
		endmethod
		
		public static method create takes SpellConversion spell, unit target, player oldOwner returns thistype
			local thistype this = thistype.allocate()
			set this.m_spell = spell
			set this.m_target = target
			set this.m_oldOwner = oldOwner
			set this.m_timer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_timer, 0, this)
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			set this.m_target = null
			set this.m_oldOwner = null
			call PauseTimer(this.m_timer)
			call DmdfHashTable.global().destroyTimer(this.m_timer)
			set this.m_timer = null
		endmethod
	endstruct

	/// Bekehrt eine gegnerische Einheit 30 Sekunden lang. Bezauberung.
	struct SpellConversion extends Spell
		public static constant integer abilityId = 'A0PZ'
		public static constant integer favouriteAbilityId = 'A0Q0'
		public static constant integer classSelectionAbilityId = 'A1OT'
		public static constant integer classSelectionGrimoireAbilityId = 'A1OU'
		public static constant integer buffId = 'B02F'
		public static constant integer maxLevel = 5
		
		private method condition takes nothing returns boolean
			if (UnitHasBuffBJ(GetSpellTargetUnit(), thistype.buffId)) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel-Einheit wurde bereits bekehrt.", "Target unit has already been converted."))
			
				return false
			endif
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call SpellConversionBuff.create(this, GetSpellTargetUnit(), GetOwningPlayer(GetSpellTargetUnit())).start(30.0)
		endmethod
		

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			
			call this.addGrimoireEntry('A1OT', 'A1OU')
			call this.addGrimoireEntry('A0Q1', 'A0Q6')
			call this.addGrimoireEntry('A0Q2', 'A0Q7')
			call this.addGrimoireEntry('A0Q3', 'A0Q8')
			call this.addGrimoireEntry('A0Q4', 'A0Q9')
			call this.addGrimoireEntry('A0Q5', 'A0QA')
			
			return this
		endmethod
	endstruct

endlibrary