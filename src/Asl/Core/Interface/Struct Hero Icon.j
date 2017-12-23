library AStructCoreInterfaceHeroIcon requires ALibraryCoreDebugMisc, ALibraryCoreGeneralUnit, ALibraryCoreInterfaceCamera, AStructCoreEnvironmentUnitCopy, AStructCoreGeneralHashTable

	/**
	 * \brief AHeroIcon provides the feature to add custom hero icons of user-defined units which do not have necessarily to be real heros.
	 * Customly added hero icons can be used to refer to heroes of allied players if you have no
	 * shared advanced control (alliance type \ref ALLIANCE_SHARED_ADVANCED_CONTROL).
	 * There will be usual hero icons in the left of screen and all unit orders targeting the icons
	 * will be forwarded automatically to the actual hero.
	 * Besides selections and selections by double clicks will be forwarded correctly (double clicks move trigger player's camera to the actual hero).
	 */
	struct AHeroIcon extends AUnitCopy
		// dynamic members
		private boolean m_recognizeAllianceChanges
		// construction members
		private player m_player
		// members
		private integer m_selectionCounter
		private trigger m_selectionTrigger
		private trigger m_orderTrigger
		private trigger m_allianceTrigger

		// dynamic members

		/**
		 * \param recognizeAllianceChanges This value is initially true if icon owner is not the same as unit owner. If this value is true hero icon will be disabled automatically when alliance is changed to shared advaned control (\ref ALLIANCE_SHARED_ADVANCED_CONTROL) and unit is a hero that there aren't two hero icons.
		 */
		public method setRecognizeAllianceChanges takes boolean recognizeAllianceChanges returns nothing
			set this.m_recognizeAllianceChanges = recognizeAllianceChanges
		endmethod

		public method recognizeAllianceChanges takes nothing returns boolean
			return this.m_recognizeAllianceChanges
		endmethod

		// construction members

		public method player takes nothing returns player
			return this.m_player
		endmethod

		// methods


		public stub method enable takes nothing returns nothing
			if (this.isEnabled()) then
				return
			endif
			// change owner that hero icon is displayed again
			call SetUnitOwner(this.unitCopy(), this.player(), false)
			call super.enable()
			call EnableTrigger(this.m_selectionTrigger)
			call EnableTrigger(this.m_orderTrigger)
		endmethod

		public stub method disable takes nothing returns nothing
			if (not this.isEnabled()) then
				return
			endif
			call super.disable()
			call DisableTrigger(this.m_selectionTrigger)
			call DisableTrigger(this.m_orderTrigger)
			// change owner that hero icon is not displayed anymore
			call SetUnitOwner(this.unitCopy(), Player(PLAYER_NEUTRAL_PASSIVE), false)
			// do never disable alliance trigger
		endmethod

		public stub method onSelect takes nothing returns nothing
			call SelectUnitForPlayerSingle(this.unit(), this.player())
		endmethod

		public stub method onDoubleSelect takes nothing returns nothing
			call SmartCameraPanWithZForPlayer(this.player(), GetUnitX(this.unit()), GetUnitY(this.unit()), 0.0, 0.0)
		endmethod

		public stub method onOrder takes nothing returns nothing
			call IssueImmediateOrder(GetTriggerUnit(), "stop")
			call IssueTargetOrderById(GetTriggerUnit(), GetIssuedOrderId(), this.unit())
		endmethod

		private static method triggerConditionSelection takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			if (GetTriggerUnit() == this.unitCopy()) then
				return GetTriggerPlayer() == GetOwningPlayer(this.unitCopy())
			endif
			if (GetTriggerUnit() != this.unit()) then // unit is always selected automatically!
				set this.m_selectionCounter = 0 // selecting other unit, no double click!
			endif
			return false
		endmethod

		private static method triggerActionSelection takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			set this.m_selectionCounter = this.m_selectionCounter + 1
			call this.onSelect.evaluate()
			if (this.m_selectionCounter == 2) then
				set this.m_selectionCounter = 0
				call this.onDoubleSelect.evaluate()
			endif
		endmethod

		private static method triggerConditionOrder takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return GetOrderTarget() == this.unitCopy()
		endmethod

		private static method triggerActionOrder takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.onOrder.evaluate()
		endmethod

		private static method triggerConditionAlliance takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return IsUnitType(this.unitCopy(), UNIT_TYPE_HERO) and this.recognizeAllianceChanges()
		endmethod

		private method enableByRecognition takes nothing returns nothing
			call this.setEnabled(not GetPlayerAlliance(GetOwningPlayer(this.unit()), this.player(), ALLIANCE_SHARED_ADVANCED_CONTROL))
		endmethod

		private static method triggerActionAlliance takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.enableByRecognition()
		endmethod

		public static method create takes unit whichUnit, player whichPlayer, real refreshTime, real x, real y, real facing returns thistype
			local thistype this = thistype.allocate(whichUnit, refreshTime, x, y, facing)
			// dynamic members
			set this.m_recognizeAllianceChanges = not (GetOwningPlayer(whichUnit) == whichPlayer)
			// construction members
			set this.m_player = whichPlayer
			// members
			set this.m_selectionCounter = 0

			// unit has to be hero that it can be shown as icon
			if (not IsUnitType(this.unitCopy(), UNIT_TYPE_HERO)) then
				//call UnitAddType(this.unitCopy(), UNIT_TYPE_HERO) /// \todo Hero icon isn't shown
				debug call this.print("WARNING: AHeroIcon - Unit is not a hero. Icon will be missing.")
			endif

			call this.setCopyVisibility(false)
			call this.setCopyPause(false)
			call this.setCopyVulnerbility(false)
			call this.setCopyDeath(false)
			//call ShowUnit(this.unit(), false) // starting enabled, has to be visible!
			call SetUnitOwner(this.unitCopy(), whichPlayer, false)
			//call SetUnitInvulnerable(this.unitCopy(), true) // has to be attackable!
			call SetUnitPathing(this.unitCopy(), false)

			set this.m_selectionTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_selectionTrigger, EVENT_PLAYER_UNIT_SELECTED)
			call TriggerAddCondition(this.m_selectionTrigger, Condition(function thistype.triggerConditionSelection))
			call TriggerAddAction(this.m_selectionTrigger, function thistype.triggerActionSelection)
			call AHashTable.global().setHandleInteger(this.m_selectionTrigger, 0, this)

			set this.m_orderTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_orderTrigger, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
			call TriggerAddCondition(this.m_orderTrigger, Condition(function thistype.triggerConditionOrder))
			call TriggerAddAction(this.m_orderTrigger, function thistype.triggerActionOrder)
			call AHashTable.global().setHandleInteger(this.m_orderTrigger, 0, this)

			set this.m_allianceTrigger = CreateTrigger()
			call TriggerRegisterPlayerAllianceChange(this.m_allianceTrigger, GetOwningPlayer(whichUnit), ALLIANCE_SHARED_CONTROL)
			call TriggerAddCondition(this.m_allianceTrigger, Condition(function thistype.triggerConditionAlliance))
			call TriggerAddAction(this.m_allianceTrigger, function thistype.triggerActionAlliance)
			call AHashTable.global().setHandleInteger(this.m_allianceTrigger, 0, this)

			if (this.m_recognizeAllianceChanges) then
				call this.enableByRecognition()
			endif

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// construction members
			set this.m_player = null
			// members
			call AHashTable.global().destroyTrigger(this.m_selectionTrigger)
			set this.m_selectionTrigger = null
			call AHashTable.global().destroyTrigger(this.m_orderTrigger)
			set this.m_orderTrigger = null
			call AHashTable.global().destroyTrigger(this.m_allianceTrigger)
			set this.m_allianceTrigger = null
		endmethod
	endstruct

endlibrary