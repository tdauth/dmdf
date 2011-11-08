/// Knight
library StructSpellsSpellTaunt requires Asl, StructGameClasses, StructGameSpell

	/// Das angewählte Ziel greift 5 Sekunden lang nur den Ritter an.
	/// Bei höheren Stufen noch Schadensreduzierung.
	struct SpellTaunt extends Spell
		public static constant integer abilityId = 'A02O'
		public static constant integer favouriteAbilityId = 'A042'
		public static constant integer maxLevel = 5
		private static constant real damageLevelFactor = 0.10
		private trigger m_orderTrigger
		private unit m_target
		private ADamageRecorder m_damageRecorder

		/// @todo Just block if damaging unit is ability target?
		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local unit target = damageRecorder.target()
			local real blockedDamage = GetEventDamage() * GetUnitAbilityLevel(target, thistype.abilityId) * thistype.damageLevelFactor
			call SetUnitLifeBJ(target, GetUnitState(target, UNIT_STATE_LIFE) + blockedDamage)
			call Spell.showDamageAbsorbationTextTag(target, blockedDamage)
			set target = null
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local real time = 5.0
			call ShowGeneralFadingTextTagForPlayer(null, tr("Verspotten"), GetUnitX(target), GetUnitY(target), 255, 255, 255, 255)
			set this.m_target = target
			call IssueTargetOrder(target, "attack", caster)
			call EnableTrigger(this.m_orderTrigger)
			if (this.level() > 1) then
				if (this.m_damageRecorder == 0) then
					set this.m_damageRecorder = ADamageRecorder.create(caster)
					call this.m_damageRecorder.setOnDamageAction(thistype.onDamageAction)
				else
					call this.m_damageRecorder.enable()
				endif
			endif
			loop
				exitwhen (time <= 0.0 or IsUnitDeadBJ(target) or IsUnitSpellImmune(target) or IsUnitDeadBJ(caster) or not this.isLearned())
				set time = time - 1.0
				call TriggerSleepAction(5.0)
			endloop
			call DisableTrigger(this.m_orderTrigger)
			set this.m_target = null
			if (this.level() > 1) then
				call this.m_damageRecorder.disable()
			endif
			set caster = null
			set target = null
		endmethod

		/// @todo Just if it's an attack order?
		private static method triggerConditionOrder takes nothing returns boolean
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = DmdfHashTable.global().handleInteger(triggeringTrigger, "this")
			local unit triggerUnit = GetTriggerUnit()
			local unit targetUnit
			local unit caster
			local boolean result = false
			if (triggerUnit == this.m_target and GetIssuedOrderId() == OrderId("attack")) then
				set targetUnit = GetOrderTargetUnit()
				set caster = this.character().unit()
				if (targetUnit != caster) then
					debug call this.print("Want attack another one!")
					set result = true
				endif
				set caster = null
				set targetUnit = null
			endif
			set triggeringTrigger = null
			set triggerUnit = null
			return result
		endmethod

		private static method triggerActionOrder takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = DmdfHashTable.global().handleInteger(triggeringTrigger, "this")
			local unit triggerUnit = GetTriggerUnit() //or this.m_target
			local unit caster = this.character().unit()
			call IssueTargetOrder(triggerUnit, "attack", caster)
			set triggeringTrigger = null
			set triggerUnit = null
			set caster = null
		endmethod

		private method createOrderTrigger takes nothing returns nothing
			local conditionfunc conditionFunction
			local triggercondition triggerCondition
			local triggeraction triggerAction
			call TriggerRegisterAnyUnitEventBJ(this.m_orderTrigger, EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER)
			set conditionFunction = Condition(function thistype.triggerConditionOrder)
			set triggerCondition = TriggerAddCondition(this.m_orderTrigger, conditionFunction)
			set triggerAction = TriggerAddAction(this.m_orderTrigger, function thistype.triggerActionOrder)
			call DmdfHashTable.global().setHandleInteger(this.m_orderTrigger, "this", this)
			call DisableTrigger(this.m_orderTrigger)
			set conditionFunction = null
			set triggerCondition = null
			set triggerAction = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			set this.m_damageRecorder = 0

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

endlibrary