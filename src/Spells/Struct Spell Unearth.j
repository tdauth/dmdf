/// \todo Sometimes computer controller earths units automatically when they have too little life.
library StructSpellsSpellUnearth requires Asl, StructGameDmdfHashTable

	private struct SpellData
		private static constant real range = 300.0
		private static constant integer abilityId = 'A047'
		private static constant real interval = 30.0
		private unit m_unit
		private boolean m_isUnearthed
		private trigger m_rangeTrigger
		private trigger m_deathTrigger
		private timer m_timer

		private static method timerFunctionCheck takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), 0))
			local group whichGroup = CreateGroup()
			local AGroup unitGroup = AGroup.create()
			call GroupEnumUnitsInRange(whichGroup, GetUnitX(this.m_unit), GetUnitY(this.m_unit), thistype.range, null)
			call unitGroup.addGroup(whichGroup, true, false)
			if (not unitGroup.hasEnemiesOfUnit(this.m_unit)) then
				call PauseTimer(GetExpiredTimer())
				call IssueImmediateOrder(this.m_unit, "burrow")
				set this.m_isUnearthed = false
			endif
			set whichGroup = null
			call unitGroup.destroy()
		endmethod

		private static method triggerConditionRange takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			debug call Print("Checking range of spell unearth")
			return GetUnitAllianceStateToUnit(this.m_unit, GetTriggerUnit()) == bj_ALLIANCE_UNALLIED and not this.m_isUnearthed
		endmethod

		private static method triggerActionRange takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			debug call Print("UNEARTH: " + GetUnitName(this.m_unit))
			call IssueImmediateOrder(this.m_unit, "unburrow")
			set this.m_isUnearthed = true
			call TimerStart(this.m_timer, thistype.interval, true, function thistype.timerFunctionCheck)
		endmethod

		private static method triggerActionDeath takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.destroy()
		endmethod

		public static method create takes unit whichUnit returns thistype
			local thistype this = thistype.allocate()
			set this.m_unit = whichUnit
			set this.m_isUnearthed = false
			set this.m_rangeTrigger = CreateTrigger()
			call TriggerRegisterUnitInRange(this.m_rangeTrigger, whichUnit, thistype.range, null)
			call TriggerAddCondition(this.m_rangeTrigger, Condition(function thistype.triggerConditionRange))
			call TriggerAddAction(this.m_rangeTrigger, function thistype.triggerActionRange)
			call DmdfHashTable.global().setHandleInteger(this.m_rangeTrigger, 0, this)
			set this.m_deathTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_deathTrigger, whichUnit, EVENT_UNIT_DEATH)
			call TriggerAddAction(this.m_deathTrigger, function thistype.triggerActionDeath)
			call DmdfHashTable.global().setHandleInteger(this.m_deathTrigger, 0, this)
			set this.m_timer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_timer, 0, this)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			set this.m_unit = null
			call DmdfHashTable.global().destroyTrigger(this.m_rangeTrigger)
			set this.m_rangeTrigger = null
			call DmdfHashTable.global().destroyTrigger(this.m_deathTrigger)
			set this.m_deathTrigger = null
			call PauseTimer(this.m_timer)
			call DmdfHashTable.global().destroyTimer(this.m_timer)
			set this.m_timer = null
		endmethod
	endstruct

	/**
	* Ditch spiders have the ability to unearth themselves. Unfortunately they won't recognize
	* automatically when an enemy crosses paths. Therefore this spell struct exists. You can
	* add all units which are created during map initialization. All later units will be
	* recognized automatically when entering the map rect.
	* Additionally you can add more than one unit type id.
	*/
	struct SpellUnearth
		private static AIntegerVector m_unitTypeIds
		private static region m_region
		private static trigger m_enterTrigger

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method triggerConditionEnter takes nothing returns boolean
			local boolean result = false
			local integer i = 0
			loop
				exitwhen (i == thistype.m_unitTypeIds.size())
				if (GetUnitTypeId(GetTriggerUnit()) == thistype.m_unitTypeIds[i]) then
					set result = true
					exitwhen (true)
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		private static method triggerActionEnter takes nothing returns nothing
			call SpellData.create(GetTriggerUnit())
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_unitTypeIds = AIntegerVector.create()
			set thistype.m_region = CreateRegion()
			call RegionAddRect(thistype.m_region, GetPlayableMapRect())
			set thistype.m_enterTrigger = CreateTrigger()
			call TriggerRegisterEnterRegion(thistype.m_enterTrigger, thistype.m_region, null)
			call TriggerAddCondition(thistype.m_enterTrigger, Condition(function thistype.triggerConditionEnter))
			call TriggerAddAction(thistype.m_enterTrigger, function thistype.triggerActionEnter)
		endmethod

		public static method addUnitTypeId takes integer unitTypeId returns nothing
			call thistype.m_unitTypeIds.pushBack(unitTypeId)
		endmethod

		/**
		* Use this method to add initializing units which aren't registered by the map entering event yet.
		*/
		public static method addUnit takes unit whichUnit returns nothing
			call SpellData.create(whichUnit)
		endmethod
	endstruct

endlibrary