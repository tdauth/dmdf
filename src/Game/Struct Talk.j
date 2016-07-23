library StructGameTalk requires Asl

	/**
	 * Talks can be activated via a special unit which is sold by NPCs who have talks.
	 * Additionally they sell a unit which is the button for skipping single informations.
	 * This helps players who don't know that they could use the smart order and the escape button to find these options.
	 */
	struct Talk extends ATalk
		/**
		 * This trigger handles sellings of non talk NPCs and removes the sold units for them as well.
		 */
		private static trigger m_sellTriggerForNonTalks
		private trigger m_sellTrigger
		
		private static method triggerConditionSell takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			
			if (GetSellingUnit() == this.unit() and (GetUnitTypeId(GetSoldUnit()) == 'n05E' or GetUnitTypeId(GetSoldUnit()) == 'n077')) then
				return true
			endif
			
			return false
		endmethod
		
		private static method timerFunctionOpenForCharacter takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), 0))
			local unit soldUnit = DmdfHashTable.global().handleUnit(GetExpiredTimer(), 1)
			
			//if (ACharacter.isUnitCharacter(GetBuyingUnit())) then
			if (GetUnitTypeId(soldUnit) == 'n05E') then
				if (GetPlayerController(GetOwningPlayer(soldUnit)) == MAP_CONTROL_USER and ACharacter.playerCharacter(GetOwningPlayer(soldUnit)) != 0 and IsUnitInRange(ACharacter.playerCharacter(GetOwningPlayer(soldUnit)).unit(), this.unit(), 600.0) and ACharacter.playerCharacter(GetOwningPlayer(soldUnit)).talk() == 0 and this.isEnabled()) then
					call this.openForCharacter(ACharacter.playerCharacter(GetOwningPlayer(soldUnit)))
				debug else
					debug call this.print("No character!")
				endif
			elseif (GetUnitTypeId(soldUnit) == 'n077') then
				call playerSkipsInfo(GetOwningPlayer(soldUnit))
			endif
			
			call RemoveUnit(soldUnit)
			call PauseTimer(GetExpiredTimer())
			call DmdfHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod
		
		private static method triggerActionSell takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			local timer whichTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(whichTimer, 0, this) 
			call DmdfHashTable.global().setHandleUnit(whichTimer, 1, GetSoldUnit()) 
			
			debug call Print("Trigger unit: " + GetUnitName(GetTriggerUnit()))
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
			call this.setEffectPath("UI\\TalkTarget.mdl")
			call this.setTextExit(tre("Ende", "Exit"))
			call this.setTextBack(tre("Zurück", "Back"))
			call this.setOrderId(0) // don't allow order
			set this.m_sellTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_sellTrigger, whichUnit, EVENT_UNIT_SELL)
			call TriggerAddCondition(this.m_sellTrigger, Condition(function thistype.triggerConditionSell))
			call TriggerAddAction(this.m_sellTrigger, function thistype.triggerActionSell)
			call DmdfHashTable.global().setHandleInteger(this.m_sellTrigger, 0, this)
			
			call UnitAddAbility(whichUnit, 'A19X')
			call UnitAddAbility(whichUnit, 'Asud') // sell units
			// removing units from stock does not work
			//call RemoveUnitFromStock(whichUnit, 'n05E') // remove from units which do already sell it
			call AddUnitToStock(whichUnit, 'n05E', 1, 1)
			call AddUnitToStock(whichUnit, 'n077', 1, 1)
			
			/*
			 * Store the talk on the unit to detect if the unit has a talk.
			 * This is necessary for the trigger m_sellTriggerForNonTalks.
			 */
			call DmdfHashTable.global().setHandleInteger(whichUnit, DMDF_HASHTABLE_KEY_TALK, this)
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_sellTrigger)
			set this.m_sellTrigger = null
			
			call DmdfHashTable.global().removeHandleInteger(this.unit(), DMDF_HASHTABLE_KEY_TALK)
		endmethod
		
		private static method triggerConditionSellForNonTalks takes nothing returns boolean
			if ((GetUnitTypeId(GetSoldUnit()) == 'n05E' or GetUnitTypeId(GetSoldUnit()) == 'n077') and not DmdfHashTable.global().hasHandleInteger(GetSellingUnit(), DMDF_HASHTABLE_KEY_TALK)) then
				return true
			endif
			
			return false
		endmethod
		
		private static method triggerActionSellForNonTalks takes nothing returns nothing
			debug call Print("Trigger unit: " + GetUnitName(GetTriggerUnit()))
			debug call Print("Selling unit: " + GetUnitName(GetSellingUnit()))
			debug call Print("Buying unit " + GetUnitName(GetBuyingUnit()))
			call SetUnitInvulnerable(GetSoldUnit(), true)
			call ShowUnit(GetSoldUnit(), false)
			call PauseUnit(GetSoldUnit(), true)
			call RemoveUnit(GetSoldUnit())
		endmethod
		
		private static method onInit takes nothing returns nothing
			set thistype.m_sellTriggerForNonTalks = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_sellTriggerForNonTalks, EVENT_PLAYER_UNIT_SELL)
			call TriggerAddCondition(thistype.m_sellTriggerForNonTalks, Condition(function thistype.triggerConditionSellForNonTalks))
			call TriggerAddAction(thistype.m_sellTriggerForNonTalks, function thistype.triggerActionSellForNonTalks)
		endmethod
	
	endstruct

endlibrary