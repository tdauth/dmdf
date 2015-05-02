/// Knight
library StructSpellsSpellTaunt requires Asl, StructGameClasses, StructGameSpell

	struct BuffTaunt
		private trigger m_orderTrigger
		private Spell m_spell
		private unit m_target
		private ADamageRecorder m_damageRecorder
		
		public method start takes real time returns nothing
			local real elapsedTime = 0.0
			call DmdfHashTable.global().setHandleInteger(this.m_target, "tauntBuff", this)
			call EnableTrigger(this.m_orderTrigger)
			call this.m_damageRecorder.enable()
			loop
				exitwhen (elapsedTime >= time or IsUnitDeadBJ(this.m_target) or IsUnitSpellImmune(this.m_target))
				call TriggerSleepAction(1.0)
				set elapsedTime = elapsedTime - 1.0
			endloop
			call DisableTrigger(this.m_orderTrigger)
			call this.m_damageRecorder.disable()
			call DmdfHashTable.global().removeHandleInteger(this.m_target, "tauntBuff")
		endmethod
		
		/// @todo Just block if damaging unit is ability target?
		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local unit target = damageRecorder.target()
			local thistype this = DmdfHashTable.global().handleInteger(target, "tauntBuff")
			local real blockedDamage = GetEventDamage() * this.m_spell.level() * SpellTaunt.damageLevelFactor
			call SetUnitLifeBJ(target, GetUnitState(target, UNIT_STATE_LIFE) + blockedDamage)
			call Spell.showDamageAbsorbationTextTag(target, blockedDamage)
			set target = null
		endmethod
		
		/// @todo Just if it's an attack order?
		private static method triggerConditionOrder takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local boolean result = false
			if (GetTriggerUnit() == this.m_target and GetIssuedOrderId() == OrderId("attack")) then
				if (GetOrderTargetUnit() != this.m_spell.character().unit()) then
					debug call Print("Want attack another one!")
					set result = true
				endif
			endif
			return result
		endmethod

		private static method triggerActionOrder takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = DmdfHashTable.global().handleInteger(triggeringTrigger, "this")
			local unit triggerUnit = GetTriggerUnit() //or this.m_target
			local unit caster = this.m_spell.character().unit()
			call ShowGeneralFadingTextTagForPlayer(null, tr("Greife den Ritter an!"), GetUnitX(triggerUnit), GetUnitY(triggerUnit), 255, 255, 255, 255)
			call IssueTargetOrder(triggerUnit, "attack", caster)
			set triggeringTrigger = null
			set triggerUnit = null
			set caster = null
		endmethod

		private method createOrderTrigger takes nothing returns nothing
			call TriggerRegisterAnyUnitEventBJ(this.m_orderTrigger, EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER)
			call TriggerAddCondition(this.m_orderTrigger, Condition(function thistype.triggerConditionOrder))
			call TriggerAddAction(this.m_orderTrigger, function thistype.triggerActionOrder)
			call DmdfHashTable.global().setHandleInteger(this.m_orderTrigger, "this", this)
			call DisableTrigger(this.m_orderTrigger)
		endmethod
		
		public static method create takes Spell spell, unit target, real time returns thistype
			local thistype this = thistype.allocate()
			set this.m_spell = spell
			set this.m_target = target
			set this.m_damageRecorder = ADamageRecorder.create(target)
			call this.m_damageRecorder.setOnDamageAction(thistype.onDamageAction)
			call this.m_damageRecorder.disable()

			call this.createOrderTrigger()
			
			return this
		endmethod
		
		private method destroyOrderTrigger takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_orderTrigger)
			set this.m_orderTrigger = null
		endmethod

		public method onDestroy takes nothing returns nothing
			set this.m_target = null

			call this.destroyOrderTrigger()
			
			if (this.m_damageRecorder != 0) then
				call this.m_damageRecorder.destroy()
			endif
		endmethod
	endstruct

	/// Das angewählte Ziel greift 5 Sekunden lang nur den Ritter an.
	/// Bei höheren Stufen noch Schadensreduzierung.
	/// TODO wird der Zauber zerstört, so sollten alle Buffs sofort gelöscht werden?
	struct SpellTaunt extends Spell
		public static constant integer abilityId = 'A02O'
		public static constant integer favouriteAbilityId = 'A042'
		public static constant integer classSelectionAbilityId = 'A0LV'
		public static constant integer classSelectionGrimoireAbilityId = 'A0M0'
		public static constant integer maxLevel = 5
		public static constant real timeStartValue = 4.0
		public static constant real timeLevelFactor = 1.0
		public static constant real damageStartValue = 90.0
		public static constant real damageLevelFactor = 0.10
		
		private method condition takes nothing returns boolean
			if (IsUnitType(GetSpellTargetUnit(), UNIT_TYPE_RESISTANT)) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Ziel ist magieressistent."))
				return false
			elseif (IsUnitType(GetSpellTargetUnit(), UNIT_TYPE_MAGIC_IMMUNE)) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Ziel ist zauberimmun."))
				return false
			endif
			
			return true
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local real time = thistype.timeStartValue + thistype.timeLevelFactor * this.level()
			local BuffTaunt buffTaunt = BuffTaunt.create(this, target, time) 
			debug call Print("Taunt on target: " + GetUnitName(target) + " with time " + R2S(time))
			call ShowGeneralFadingTextTagForPlayer(null, tr("Verspotten"), GetUnitX(target), GetUnitY(target), 255, 255, 255, 255)
			call buffTaunt.start(time)
			call buffTaunt.destroy()
			set caster = null
			set target = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A0LV', 'A0M0')
			call this.addGrimoireEntry('A0LW', 'A0M1')
			call this.addGrimoireEntry('A0LX', 'A0M2')
			call this.addGrimoireEntry('A0LY', 'A0M3')
			call this.addGrimoireEntry('A0LZ', 'A0M4')
			
			return this
		endmethod
	endstruct

endlibrary