library StructGameTalk requires Asl

	struct Talk extends ATalk
		private trigger m_sellTrigger
		
		private static method triggerConditionSell takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this"))
			
			if (GetSellingUnit() == this.unit() and GetUnitTypeId(GetSoldUnit()) == 'n05E') then
				return true
			endif
			
			return false
		endmethod
		
		private static method timerFunctionOpenForCharacter takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), "this"))
			local unit soldUnit = DmdfHashTable.global().handleUnit(GetExpiredTimer(), "soldunit")
			
			//if (ACharacter.isUnitCharacter(GetBuyingUnit())) then
			if (GetPlayerController(GetOwningPlayer(soldUnit)) == MAP_CONTROL_USER and ACharacter.playerCharacter(GetOwningPlayer(soldUnit)) != 0 and IsUnitInRange(ACharacter.playerCharacter(GetOwningPlayer(soldUnit)).unit(), this.unit(), 600.0) and this.isEnabled()) then
				call this.openForCharacter(ACharacter.playerCharacter(GetOwningPlayer(soldUnit)))
			endif
			
			call RemoveUnit(soldUnit)
			call PauseTimer(GetExpiredTimer())
			call DmdfHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod
		
		private static method triggerActionSell takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this"))
			local timer whichTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(whichTimer, "this", this) 
			call DmdfHashTable.global().setHandleUnit(whichTimer, "soldunit", GetSoldUnit()) 
			
			debug call Print("Selling unit: " + GetUnitName(GetSellingUnit()))
			debug call Print("Buying unit " + GetUnitName(GetBuyingUnit()))
			call SetUnitInvulnerable(GetSoldUnit(), true)
			call ShowUnit(GetSoldUnit(), false)
			call PauseUnit(GetSoldUnit(), true)
			
			// wait since the selling unit is being paused
			call TimerStart(whichTimer, 0.0, false, function thistype.timerFunctionOpenForCharacter)
		endmethod
		
		public static method create takes unit whichUnit, ATalkStartAction startAction returns thistype
			local thistype this = thistype.allocate(whichUnit, startAction)
			call this.setEffectPath(null)
			set this.m_sellTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_sellTrigger, whichUnit, EVENT_UNIT_SELL)
			call TriggerAddCondition(this.m_sellTrigger, Condition(function thistype.triggerConditionSell))
			call TriggerAddAction(this.m_sellTrigger, function thistype.triggerActionSell)
			call DmdfHashTable.global().setHandleInteger(this.m_sellTrigger, "this", this)
			
			call UnitAddAbility(whichUnit, 'A19X')
			//call AddUnitToStock(whichUnit, 'n05E', 1, 1)
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_sellTrigger)
			set this.m_sellTrigger = null
		endmethod
	
	endstruct

endlibrary