/// Wizard
library StructSpellsSpellCurb requires Asl, StructGameClasses, StructGameSpell

	/// Der Zauberer erzeugt eine Kuppel und verringert den von ihm und seinen Verbündeten erlittenen magischen Schaden 15 Sekunden lang um X %.
	struct SpellCurb extends Spell
		public static constant integer abilityId = 'A03B'
		public static constant integer favouriteAbilityId = 'A03F'
		public static constant integer classSelectionAbilityId = 'A0BA'
		public static constant integer classSelectionGrimoireAbilityId = 'A0B9'
		public static constant integer maxLevel = 5
		private static constant integer buffId = 'B00H'
		private static constant real time = 15.0
		private static constant real damageLevelValue = 0.10
		private static constant real range = 600.0
		private AUnitVector m_units
		private AIntegerVector m_damageRecorders
		private region m_region
		private trigger m_enterTrigger
		private trigger m_leaveTrigger

		/// @todo Check if it is magical damage (check units damage type)
		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local thistype spell = thistype(DmdfHashTable.global().integer(DMDF_HASHTABLE_KEY_DAMAGERECORDER, damageRecorder))
			local real reducedDamage = GetEventDamage() * spell.level() * thistype.damageLevelValue
			local unit target = damageRecorder.target()
			call SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE) + reducedDamage)
			debug call Print("Reduced damage of " + GetUnitName(target) + ": " + R2S(reducedDamage))
			set target = null
		endmethod

		private method addUnit takes unit whichUnit returns nothing
			local ADamageRecorder damageRecorder = ADamageRecorder.create(whichUnit)
			call damageRecorder.setOnDamageAction(thistype.onDamageAction)
			call DmdfHashTable.global().setInteger(DMDF_HASHTABLE_KEY_DAMAGERECORDER, damageRecorder, this)
			debug call Print(GetUnitName(whichUnit) + " enters curb region.")
			call this.m_units.pushBack(whichUnit)
			call this.m_damageRecorders.pushBack(damageRecorder)
			call UnitAddAbility(whichUnit, thistype.buffId)
			call UnitMakeAbilityPermanent(whichUnit, true, thistype.buffId)
		endmethod

		private method removeUnit takes unit whichUnit returns nothing
			local integer index = this.m_units.find(whichUnit)
			debug if (index == -1) then
				debug call Print("Index shouldn't be -1")
			debug endif
			call DmdfHashTable.global().removeInteger(DMDF_HASHTABLE_KEY_DAMAGERECORDER, this.m_damageRecorders[index])
			debug call Print(GetUnitName(whichUnit) + " leaves curb region.")
			call ADamageRecorder(this.m_damageRecorders[index]).destroy()
			call this.m_damageRecorders.erase(index)
			call this.m_units.erase(index)
			call UnitRemoveAbility(whichUnit, thistype.buffId)
		endmethod

		private static method triggerConditionIsAllied takes nothing returns boolean
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = DmdfHashTable.global().handleInteger(triggeringTrigger, 0)
			local unit caster = this.character().unit()
			local unit triggerUnit = GetTriggerUnit()
			local boolean result = GetUnitAllianceStateToUnit(caster, triggerUnit) == bj_ALLIANCE_ALLIED
			set triggeringTrigger = null
			set caster = null
			set triggerUnit = null
			return result
		endmethod

		private static method triggerActionEnter takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = DmdfHashTable.global().handleInteger(triggeringTrigger, 0)
			local unit triggerUnit = GetTriggerUnit()
			call this.addUnit(triggerUnit)
			set triggeringTrigger = null
			set triggerUnit = null
		endmethod

		private method createEnterTrigger takes nothing returns nothing
			set this.m_enterTrigger = CreateTrigger()
			call TriggerRegisterEnterRegionSimple(this.m_enterTrigger, this.m_region)
			call TriggerAddCondition(this.m_enterTrigger, Condition(function thistype.triggerConditionIsAllied))
			call TriggerAddAction(this.m_enterTrigger, function thistype.triggerActionEnter)
			call DmdfHashTable.global().setHandleInteger(this.m_enterTrigger, 0, this)
		endmethod

		private static method triggerActionLeave takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = DmdfHashTable.global().handleInteger(triggeringTrigger, 0)
			local unit triggerUnit = GetTriggerUnit()
			call this.removeUnit(triggerUnit)
			set triggeringTrigger = null
			set triggerUnit = null
		endmethod

		private method createLeaveTrigger takes nothing returns nothing
			set this.m_leaveTrigger = CreateTrigger()
			call TriggerRegisterLeaveRegionSimple(this.m_leaveTrigger, this.m_region)
			call TriggerAddCondition(this.m_leaveTrigger, Condition(function thistype.triggerConditionIsAllied))
			call TriggerAddAction(this.m_leaveTrigger, function thistype.triggerActionLeave)
			call DmdfHashTable.global().setHandleInteger(this.m_leaveTrigger, 0, this)
		endmethod

		private method destroyEnterTrigger takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_enterTrigger)
			set this.m_enterTrigger = null
		endmethod

		private method destroyLeaveTrigger takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_leaveTrigger)
			set this.m_leaveTrigger = null
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local real time = thistype.time
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "chest")
			local real i
			local real j
			local integer k
			local AGroup unitGroup
			local location center
			local rect whichRect
			debug call Print("Casting spell Curb.")
			if (this.m_units == 0) then
				debug call Print("Creating unit and damage recorder vector.")
				set this.m_units = AUnitVector.create()
				set this.m_damageRecorders = AIntegerVector.create()
			endif
			debug call Print("Creating region and adding cells.")
			set this.m_region = CreateRegion()
			set center = Location(GetUnitX(caster), GetUnitY(caster))
			// rect is still a square!
			set whichRect = GetRectFromCircleBJ(center, thistype.range)
			call RegionAddRect(this.m_region, whichRect)
			debug call Print("After creating region")
			// add units in rect
			set unitGroup = AGroup.create()
			call unitGroup.addUnitsInRange(GetUnitX(caster), GetUnitY(caster), thistype.range, null)
			call unitGroup.removeEnemiesOfUnit(caster)
			debug call Print("After removing enemies of unit.")
			set k = 0
			loop
				exitwhen (k == unitGroup.units().size())
				call this.addUnit(unitGroup.units()[k])
				set k = k + 1
			endloop
			call unitGroup.destroy()
			debug call Print("Creating triggers.")
			call this.createEnterTrigger()
			call this.createLeaveTrigger()
			loop
				exitwhen (time <= 0.0 or ASpell.allyChannelLoopCondition(caster))
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			debug call Print("Clean up spell.")
			call RemoveRegion(this.m_region)
			set this.m_region = null
			call this.destroyEnterTrigger()
			call this.destroyLeaveTrigger()
			set caster = null
			call DestroyEffect(casterEffect)
			set casterEffect = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			set this.m_units = 0
			call this.addGrimoireEntry('A0BA', 'A0B9')
			call this.addGrimoireEntry('A0BD', 'A0AQ')
			call this.addGrimoireEntry('A0BE', 'A0BC')
			call this.addGrimoireEntry('A0BF', 'A0AC')
			call this.addGrimoireEntry('A0BG', 'A0BB')
			return this
		endmethod

		private method destroyDamageRecorders takes nothing returns nothing
			local integer i = this.m_damageRecorders.backIndex()
			loop
				exitwhen (i < 0)
				call DmdfHashTable.global().removeInteger(DMDF_HASHTABLE_KEY_DAMAGERECORDER, this.m_damageRecorders[i])
				call ADamageRecorder(this.m_damageRecorders[i]).destroy()
				call this.m_damageRecorders.popBack()
				set i = i - 1
			endloop
		endmethod

		public method onDestroy takes nothing returns nothing
			if (this.m_units != 0) then
				call this.m_units.destroy()
				call this.destroyDamageRecorders()
				call this.m_damageRecorders.destroy()
			endif
		endmethod
	endstruct

endlibrary