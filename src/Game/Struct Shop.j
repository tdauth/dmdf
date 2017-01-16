library StructGameShop requires Asl

	/**
	 * \brief Shops belong to an NPC and can be chosen via the NPC's buttons.
	 */
	struct Shop
		private unit m_npc
		private unit m_shop
		private static trigger m_sellTrigger
		private static AIntegerList m_shops

		/**
		 * Creates a new shop instance for an NPC.
		 * \param npc The NPC who has the action button to select the corresponding shop.
		 * \param shop The corresponding shop.
		 */
		public static method create takes unit npc, unit shop returns thistype
			local thistype this = thistype.allocate()
			set this.m_npc = npc
			set this.m_shop = shop
			return this
		endmethod

		private static method triggerConditionSell takes nothing returns boolean
			if (GetUnitTypeId(GetSoldUnit()) == 'n05Y') then
				return true
			endif

			return false
		endmethod

		private static method timerFunctionSelectShop takes nothing returns nothing
			local unit sellingUnit = thistype(DmdfHashTable.global().handleUnit(GetExpiredTimer(), 0))
			local unit soldUnit = DmdfHashTable.global().handleUnit(GetExpiredTimer(), 1)
			local thistype shop = 0
			local AIntegerListIterator iterator = thistype.m_shops.begin()
			loop
				exitwhen (not iterator.isValid())
				set shop = thistype(iterator.data())
				if (sellingUnit == shop.m_npc) then
					call SmartCameraPanWithZForPlayer(GetOwningPlayer(soldUnit), GetUnitX(shop.m_shop), GetUnitY(shop.m_shop), 0.0, 0.0)
					call SelectUnitForPlayerSingle(shop.m_shop, GetOwningPlayer(soldUnit))
				endif
				call iterator.next()
			endloop
			call iterator.destroy()

			set sellingUnit = null
			call RemoveUnit(soldUnit)
			set soldUnit = null

			call PauseTimer(GetExpiredTimer())
			call DmdfHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod

		private static method triggerActionSell takes nothing returns nothing
			local timer whichTimer = CreateTimer()
			call DmdfHashTable.global().setHandleUnit(whichTimer, 0, GetSellingUnit())
			call DmdfHashTable.global().setHandleUnit(whichTimer, 1, GetSoldUnit())

			debug call Print("Trigger unit: " + GetUnitName(GetTriggerUnit()))
			debug call Print("Selling unit: " + GetUnitName(GetSellingUnit()))
			debug call Print("Buying unit " + GetUnitName(GetBuyingUnit()))
			call SetUnitInvulnerable(GetSoldUnit(), true)
			call ShowUnit(GetSoldUnit(), false)
			call PauseUnit(GetSoldUnit(), true)

			// wait since the selling unit is being paused
			call TimerStart(whichTimer, 0.0, false, function thistype.timerFunctionSelectShop)
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_sellTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_sellTrigger, EVENT_PLAYER_UNIT_SELL)
			call TriggerAddCondition(thistype.m_sellTrigger, Condition(function thistype.triggerConditionSell))
			call TriggerAddAction(thistype.m_sellTrigger, function thistype.triggerActionSell)
			set thistype.m_shops = AIntegerList.create()
		endmethod
	endstruct

endlibrary