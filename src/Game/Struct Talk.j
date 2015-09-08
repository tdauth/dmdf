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
		
		private static method triggerActionSell takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this"))
			
			debug call Print("Buying unit " + GetUnitName(GetBuyingUnit()))
				
			//if (ACharacter.isUnitCharacter(GetBuyingUnit())) then
			if (GetPlayerController(GetOwningPlayer(GetSoldUnit())) == MAP_CONTROL_USER and ACharacter.playerCharacter(GetOwningPlayer(GetSoldUnit())) != 0 and IsUnitInRange(ACharacter.playerCharacter(GetOwningPlayer(GetSoldUnit())).unit(), this.unit(), 600.0)) then
				call this.openForCharacter(ACharacter.playerCharacter(GetOwningPlayer(GetSoldUnit())))
			endif
			
			call SetUnitInvulnerable(GetSoldUnit(), true)
			call PauseUnit(GetSoldUnit(), true)
			call RemoveUnit(GetSoldUnit())
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
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_sellTrigger)
			set this.m_sellTrigger = null
		endmethod
	
	endstruct

endlibrary