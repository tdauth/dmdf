library StructGuisCommandButtons requires Asl, StructGameDmdfHashTable

	/**
	 * \brief A command button which is shown in the current player's camera view and can be clicked to trigger a custom action.
	 * \note Every command button requires a custom destructable using the required icon as replaceable texture ID.
	 * \note Since the selection event of destructables cannot be recognized it has to be a dummy unit without health bar (selection scale 0.0 in object editor) which is played on the position.
	 * \note The dummy unit can always be the same as long as it has the same size of the destructable.
	 */
	struct CommandButton
		public static constant real timeout = 1.0
		private static AIntegerVector m_buttons
		private static timer m_updateTimer

		private player m_player
		private integer m_destructableId
		private integer m_dummyUnitId
		private real m_x // relative
		private real m_y // relative
		private destructable m_destructable
		private unit m_dummyUnit
		private trigger m_clickTrigger

		public method player takes nothing returns player
			return this.m_player
		endmethod

		public method destructableId takes nothing returns integer
			return this.m_destructableId
		endmethod

		public method x takes nothing returns real
			return this.m_x
		endmethod

		public method y takes nothing returns real
			return this.m_y
		endmethod

		public stub method onTrigger takes nothing returns nothing
			debug call Print("Click!!!!")
		endmethod

		// TODO sync values with other players! Otherwise desync
		private method relativeX takes nothing returns real
			return GetCameraEyePositionX() + this.x()
		endmethod

		public method relativeY takes nothing returns real
			return GetCameraEyePositionY() + this.y()
		endmethod

		public method relativeZ takes nothing returns real
			return GetCameraEyePositionZ()
		endmethod

		private method updateDummyUnit takes nothing returns nothing
			local real x = this.relativeX()
			local real y = this.relativeY()
			local real z = this.relativeZ()
			call SetUnitX(this.m_dummyUnit, x)
			call SetUnitY(this.m_dummyUnit, y)
			call SetUnitZ(this.m_dummyUnit, z)

			debug call Print("Update unit with coordinates: (" + R2S(x) + " | " + R2S(y) + " | " + R2S(z) + ")")
		endmethod

		private method updateDestructable takes nothing returns nothing
			local real x = this.relativeX()
			local real y = this.relativeY()
			local real z = this.relativeZ()

			if (this.m_destructable != null) then
				call RemoveDestructable(this.m_destructable)
				set this.m_destructable = null
			endif

			set this.m_destructable = CreateDestructableZ(this.destructableId(), x, y, z, 0.0, 1.0, 0)
		endmethod

		private method updatePosition takes nothing returns nothing
			call this.updateDummyUnit()
			call this.updateDestructable()
		endmethod

		private static method triggerConditionClick takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			return GetTriggerUnit() == this.m_dummyUnit
		endmethod

		private static method triggerActionClick takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			call this.onTrigger.execute()
		endmethod

		public static method create takes player whichPlayer, integer destructableId, integer dummyUnitId, real x, real y returns thistype
			local thistype this = thistype.allocate()
			set this.m_player = whichPlayer
			set this.m_destructableId = destructableId
			set this.m_dummyUnitId = dummyUnitId
			set this.m_x = x
			set this.m_y = y
			call this.updateDestructable()
			set this.m_dummyUnit = CreateUnit(whichPlayer, dummyUnitId, this.relativeX(), this.relativeY(), 0.0)
			set this.m_clickTrigger = CreateTrigger()
			call TriggerRegisterPlayerUnitEvent(this.m_clickTrigger, whichPlayer, EVENT_PLAYER_UNIT_SELECTED, null)
			call TriggerAddCondition(this.m_clickTrigger, Condition(function thistype.triggerConditionClick))
			call TriggerAddAction(this.m_clickTrigger, function thistype.triggerActionClick)
			call DmdfHashTable.global().setHandleInteger(this.m_clickTrigger, 0, this)

			return this
		endmethod

		private static method updateAllButtons takes nothing returns nothing
			local thistype whichButton = 0
			local integer i = 0
			loop
				exitwhen (i == thistype.m_buttons.size())
				set whichButton = thistype(thistype.m_buttons[i])
				call whichButton.updatePosition()
				set i = i + 1
			endloop
			//debug call Print("Updated all buttons")
		endmethod

		/**
		 * Initializes the whole system and starts the movement timer.
		 */
		public static method init takes nothing returns nothing
			set thistype.m_buttons = AIntegerVector.create()
			set thistype.m_updateTimer = CreateTimer()
			call TimerStart(thistype.m_updateTimer, thistype.timeout, true, function thistype.updateAllButtons)
		endmethod
	endstruct

endlibrary