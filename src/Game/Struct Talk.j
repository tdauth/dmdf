library StructGameTalk requires Asl, StructGameFellow

	/**
	 * \brief Custom implementation of talks for the modification.
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
			local Character character = Character(ACharacter.playerCharacter(GetOwningPlayer(soldUnit)))
			local Fellow fellow = Fellow.getByUnit(this.unit())

			//if (ACharacter.isUnitCharacter(GetBuyingUnit())) then
			if (GetUnitTypeId(soldUnit) == 'n05E') then
				if (GetPlayerController(GetOwningPlayer(soldUnit)) == MAP_CONTROL_USER and character != 0 and IsUnitInRange(character.unit(), this.unit(), 600.0) and character.talk() == 0 and this.isEnabled()) then
					/*
					 * Don't allow talking to NPCs if they are fellows of other characters only. This would stop them which would be annoying as hell for the owner of the character.
					 */
					if (fellow == 0 or not fellow.isShared() or not fellow.isSharedToCharacter() or fellow.character() == character) then
						call this.openForCharacter(character)
					else
						call character.displayMessage(Character.messageTypeError, tre("Ziel ist mit einem anderen Spieler unterwegs.", "Target is traveling with another player."))
					endif
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

			call SetUnitInvulnerable(GetSoldUnit(), true)
			call ShowUnit(GetSoldUnit(), false)
			call PauseUnit(GetSoldUnit(), true)

			// wait since the selling unit is being paused
			call TimerStart(whichTimer, 0.0, false, function thistype.timerFunctionOpenForCharacter)
		endmethod

		public stub method onOpenForCharacter takes Character character returns nothing
			local Fellow fellow = Fellow.getByUnit(this.unit())

			// first character, disable routines otherwise the NPC walks away at certain times of day
			if (this.characters().size() == 1) then
				// stopping the routines prevents the NPC from walking away.
				call AUnitRoutine.disableAll(this.unit())
				// don't pause, otherwise the NPC cannot sell anything
			endif

			call Routines.stopSoundsForPlayer(character.player()) // silence the talk sounds
			call Routines.hideTexttagsForPlayer(character.player()) // hide text tags

			/*
			 * When talking to a shared fellow the fellow should become invulnerable. Otherwise the fellow could die during the talk.
			 */
			if (fellow != 0 and fellow.isShared()) then
				call SetUnitInvulnerable(this.unit(), true)
			endif
		endmethod

		public stub method onCloseForCharacter takes Character character returns nothing
			local Fellow fellow = Fellow.getByUnit(this.unit())
			/*
			 * When there is no character left to talk to the NPC can go on working on anything.
			 */
			if (this.characters().empty() and (fellow == 0 or not fellow.isShared())) then
				// stopping the routines prevents the NPC from walking away.
				call AUnitRoutine.enableAll(this.unit())
				// don't pause, otherwise the NPC cannot sell anything
			endif

			/*
			 * When talking to a shared fellow the fellow should become invulnerable. Otherwise the fellow could die during the talk.
			 * Therefore the fellow has to become vulnerable again here
			 */
			if (fellow != 0 and fellow.isShared()) then
				call SetUnitInvulnerable(this.unit(), false)
			endif
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

			// TODO removing units from stock does not work
			//call RemoveUnitFromStock(whichUnit, 'n05E') // remove from units which do already sell it
			// dont add units in code to stock since hotkeys won't work
			//call AddUnitToStock(whichUnit, 'n05E', 1, 1)
			//call AddUnitToStock(whichUnit, 'n077', 1, 1)

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