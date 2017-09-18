library AStructCoreInterfaceArrowKeys

	/**
	 * Functions following this function interface can be used as keypress event responses.
	 * \param key Parameter values: \p AArrowKeys.keyUp, \p AArrowKeys.keyDown, \p AArrowKeys.keyLeft, \p AArrowKeys.keyRight
	 * \param pressed true-key was pressed, false-key was released
	 */
	function interface AArrowKeysOnPressAction takes AArrowKeys arrowKeys, integer key, boolean pressed returns nothing

	/**
	 * Use \ref playerArrowKeys() to refer to each player's instance.
	 * \author Anitarf
	 * \author Tamino Dauth (only the adaption for the ASL)
	 * <a href="http://www.wc3c.net/showthread.php?t=101271">source</a>
	 */
	struct AArrowKeys
		public static constant integer keyUp = 0
		public static constant integer keyDown = 1
		public static constant integer keyLeft = 2
		public static constant integer keyRight = 3
		/**
		* the following constant determines the behaviour of the vertical and horizontal
		* variables. For example, if a player presses the up key and then presses the down
		* key afterwards while still holding the up key, the vertical variable will be set
		* to -1. Then, if the player releases the down key while still keeping the up key
		* pressed, if RESUME_PREVIOUS_KEY is true the vertical variable will be set back
		* to 1, else it will be set to 0.
		*/
		// static construction members
		private static boolean m_resumePreviousKey
		// static dynamic members
		/**
		* these are the external functions that get called when an arrow key is pressed/released
		* you can set these variables to your functions that follow the Event function interface
		* you don't need a different function for each event, you can set all these variables to
		* a single function, since the function's parameters tell you what event occured.
		*/
		private static AArrowKeysOnPressAction m_onPressUpAction
		private static AArrowKeysOnPressAction m_onReleaseUpAction
		private static AArrowKeysOnPressAction m_onPressDownAction
		private static AArrowKeysOnPressAction m_onReleaseDownAction
		private static AArrowKeysOnPressAction m_onPressLeftAction
		private static AArrowKeysOnPressAction m_onReleaseLeftAction
		private static AArrowKeysOnPressAction m_onPressRightAction
		private static AArrowKeysOnPressAction m_onReleaseRightAction
		// static members
		private static trigger m_pressUpTrigger
		private static trigger m_releaseUpTrigger
		private static trigger m_pressDownTrigger
		private static trigger m_releaseDownTrigger
		private static trigger m_pressLeftTrigger
		private static trigger m_releaseLeftTrigger
		private static trigger m_pressRightTrigger
		private static trigger m_releaseRightTrigger
		private static thistype array m_playerArrowKeys[12] /// \todo Use \ref bj_MAX_PLAYERS, vJass bug.
		// dynamic members
		// these are the "quick press" variables. They work similarly to the variables above,
		// except that they aren't set to 0/false when a key is released. If you are checking
		// the above variables on a periodic timer, you could miss a keypress if a player
		// quickly presses and releases a key, the variables below allow you to catch such
		// quick keypresses. Note that you must set these variables to 0/false yourself once
		// you check them or they'll remain permanently set to 1/-1/true. Basicaly these
		// variables tell you if a key has been pressed since you last set them to 0/false.
		private integer m_verticalQuickPress
		private integer m_horizontalQuickPress
		private boolean m_upQuickPress
		private boolean m_downQuickPress
		private boolean m_leftQuickPress
		private boolean m_rightQuickPress
		// construction members
		private player m_player
		//members
		// this tells you the status of the arrow keys in the two directions for each player
		// index 0 holds the values for player 1 (red), index 11 for player 12 (brown)
		// a value of 0 means no keys pressed, 1 means right/up, -1 means left/down
		 // do not change the value of these variables
		private integer m_vertical
		private integer m_horizontal
		// this tells you the status of each arrow key individualy for each player
		// index 0 holds the values for player 1 (red), index 11 for player 12 (brown)
		// this is basicaly the same as vertical/horizontal, you can use whichever you want
		// do not change the value of these variables
		private boolean m_up
		private boolean m_down
		private boolean m_left
		private boolean m_right

		// dynamic members

		public method setVerticalQuickPress takes integer verticalQuickPress returns nothing
			set this.m_verticalQuickPress = verticalQuickPress
		endmethod

		public method verticalQuickPress takes nothing returns integer
			return this.m_verticalQuickPress
		endmethod

		public method setHorizontalQuickPress takes integer horizontalQuickPress returns nothing
			set this.m_horizontalQuickPress = horizontalQuickPress
		endmethod

		public method horizontalQuickPress takes nothing returns integer
			return this.m_horizontalQuickPress
		endmethod

		public method setUpQuickPress takes boolean upQuickPress returns nothing
			set this.m_upQuickPress = upQuickPress
		endmethod

		public method upQuickPress takes nothing returns boolean
			return this.m_upQuickPress
		endmethod

		public method setDownQuickPress takes boolean downQuickPress returns nothing
			set this.m_downQuickPress = downQuickPress
		endmethod

		public method downQuickPress takes nothing returns boolean
			return this.m_downQuickPress
		endmethod

		public method setLeftQuickPress takes boolean leftQuickPress returns nothing
			set this.m_leftQuickPress = leftQuickPress
		endmethod

		public method leftQuickPress takes nothing returns boolean
			return this.m_leftQuickPress
		endmethod

		public method setRightQuickPress takes boolean rightQuickPress returns nothing
			set this.m_rightQuickPress = rightQuickPress
		endmethod

		public method rightQuickPress takes nothing returns boolean
			return this.m_rightQuickPress
		endmethod

		// construction members

		public method player takes nothing returns player
			return this.m_player
		endmethod

		// members

		public method vertical takes nothing returns integer
			return this.m_vertical
		endmethod

		public method horizontal takes nothing returns integer
			return this.m_horizontal
		endmethod

		public method up takes nothing returns boolean
			return this.m_up
		endmethod

		public method down takes nothing returns boolean
			return this.m_down
		endmethod

		public method left takes nothing returns boolean
			return this.m_left
		endmethod

		public method right takes nothing returns boolean
			return this.m_right
		endmethod

		public static method create takes player user returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_verticalQuickPress = 0
			set this.m_horizontalQuickPress = 0
			set this.m_upQuickPress = false
			set this.m_downQuickPress = false
			set this.m_leftQuickPress = false
			set this.m_rightQuickPress = false
			// construction members
			set this.m_player = user
			// members
			set this.m_vertical = 0
			set this.m_horizontal = 0
			set this.m_up = false
			set this.m_down = false
			set this.m_left = false
			set this.m_right = false
			return this
		endmethod

		// members

		private static method triggerActionKeyPressDown takes nothing returns nothing
			local player triggerPlayer = GetTriggerPlayer()
			local thistype this = thistype.m_playerArrowKeys[GetPlayerId(triggerPlayer)]
			set this.m_down = true
			set this.m_vertical = -1
			set this.m_downQuickPress = true
			set this.m_verticalQuickPress = -1
			if (thistype.m_onPressDownAction != 0) then
				call thistype.m_onPressDownAction.execute(this, thistype.keyDown, true)
			endif
			set triggerPlayer = null
		endmethod

		private static method triggerActionKeyReleaseDown takes nothing returns nothing
			local player triggerPlayer = GetTriggerPlayer()
			local thistype this = thistype.m_playerArrowKeys[GetPlayerId(triggerPlayer)]
			set this.m_down = false
			if (thistype.m_resumePreviousKey and this.m_up) then
				set this.m_vertical = 1
			else
				set this.m_vertical = 0
			endif
			if (thistype.m_onReleaseDownAction != 0) then
				call thistype.m_onReleaseDownAction.execute(this, thistype.keyDown, false)
			endif
			set triggerPlayer = null
		endmethod

		private static method triggerActionKeyPressUp takes nothing returns nothing
			local player triggerPlayer = GetTriggerPlayer()
			local thistype this = thistype.m_playerArrowKeys[GetPlayerId(triggerPlayer)]
			set this.m_up = true
			set this.m_vertical = 1
			set this.m_upQuickPress = true
			set this.m_verticalQuickPress = 1
			if (thistype.m_onPressUpAction != 0) then
				call thistype.m_onPressUpAction.execute(this, thistype.keyUp, true)
			endif
			set triggerPlayer = null
		endmethod

		private static method triggerActionKeyReleaseUp takes nothing returns nothing
			local player triggerPlayer = GetTriggerPlayer()
			local thistype this = thistype.m_playerArrowKeys[GetPlayerId(triggerPlayer)]
			set this.m_up = false
			if (thistype.m_resumePreviousKey and this.m_down) then
				set this.m_vertical = -1
			else
				set this.m_vertical = 0
			endif
			if (thistype.m_onReleaseUpAction != 0) then
				call thistype.m_onReleaseUpAction.execute(this, thistype.keyUp, false)
			endif
			set triggerPlayer = null
		endmethod

		private static method triggerActionKeyPressLeft takes nothing returns nothing
			local player triggerPlayer = GetTriggerPlayer()
			local thistype this = thistype.m_playerArrowKeys[GetPlayerId(triggerPlayer)]
			set this.m_left = true
			set this.m_horizontal = -1
			set this.m_leftQuickPress = true
			set this.m_horizontalQuickPress = -1
			if (thistype.m_onPressLeftAction != 0) then
				call thistype.m_onPressLeftAction.execute(this, thistype.keyLeft, true)
			endif
			set triggerPlayer = null
		endmethod

		private static method triggerActionKeyReleaseLeft takes nothing returns nothing
			local player triggerPlayer = GetTriggerPlayer()
			local thistype this = thistype.m_playerArrowKeys[GetPlayerId(triggerPlayer)]
			set this.m_left = false
			if (thistype.m_resumePreviousKey and this.m_right) then
				set this.m_horizontal = 1
			else
				set this.m_horizontal = 0
			endif
			if (thistype.m_onReleaseLeftAction != 0) then
				call thistype.m_onReleaseLeftAction.execute(this, thistype.keyLeft, false)
			endif
			set triggerPlayer = null
		endmethod

		private static method triggerActionKeyPressRight takes nothing returns nothing
			local player triggerPlayer = GetTriggerPlayer()
			local thistype this = thistype.m_playerArrowKeys[GetPlayerId(triggerPlayer)]
			set this.m_right = true
			set this.m_horizontal = 1
			set this.m_rightQuickPress = true
			set this.m_horizontalQuickPress = 1
			if (thistype.m_onPressRightAction != 0) then
				call thistype.m_onPressRightAction.execute(this, thistype.keyRight, true)
			endif
			set triggerPlayer = null
		endmethod

		private static method triggerActionKeyReleaseRight takes nothing returns nothing
			local player triggerPlayer = GetTriggerPlayer()
			local thistype this = thistype.m_playerArrowKeys[GetPlayerId(triggerPlayer)]
			set this.m_right = false
			if (thistype.m_resumePreviousKey and this.m_left) then
				set this.m_horizontal = -1
			else
				set this.m_horizontal = 0
			endif
			if (thistype.m_onReleaseRightAction != 0) then
				call thistype.m_onReleaseRightAction.execute(this, thistype.keyRight, false)
			endif
			set triggerPlayer = null
		endmethod

		public static method init takes boolean resumePreviousKey returns nothing
			local triggeraction triggerAction
			local integer i
			local player user
			local event triggerEvent
			// static dynamic members
			set thistype.m_onPressUpAction = 0
			set thistype.m_onReleaseUpAction = 0
			set thistype.m_onPressDownAction = 0
			set thistype.m_onReleaseDownAction = 0
			set thistype.m_onPressLeftAction = 0
			set thistype.m_onReleaseLeftAction = 0
			set thistype.m_onPressRightAction = 0
			set thistype.m_onReleaseRightAction = 0
			// static construction members
			set thistype.m_resumePreviousKey = resumePreviousKey
			// static members
			set thistype.m_pressUpTrigger = CreateTrigger()
			set triggerAction = TriggerAddAction(thistype.m_pressUpTrigger, function thistype.triggerActionKeyPressUp)
			set triggerAction = null
			set thistype.m_releaseUpTrigger = CreateTrigger()
			set triggerAction = TriggerAddAction(thistype.m_releaseUpTrigger, function thistype.triggerActionKeyReleaseUp)
			set triggerAction = null
			set thistype.m_pressDownTrigger = CreateTrigger()
			set triggerAction = TriggerAddAction(thistype.m_pressDownTrigger, function thistype.triggerActionKeyPressDown)
			set triggerAction = null
			set thistype.m_releaseDownTrigger = CreateTrigger()
			set triggerAction = TriggerAddAction(thistype.m_releaseDownTrigger, function thistype.triggerActionKeyReleaseDown)
			set triggerAction = null
			set thistype.m_pressLeftTrigger = CreateTrigger()
			set triggerAction = TriggerAddAction(thistype.m_pressLeftTrigger, function thistype.triggerActionKeyPressLeft)
			set triggerAction = null
			set thistype.m_releaseLeftTrigger = CreateTrigger()
			set triggerAction = TriggerAddAction(thistype.m_releaseLeftTrigger, function thistype.triggerActionKeyReleaseLeft)
			set triggerAction = null
			set thistype.m_pressRightTrigger = CreateTrigger()
			set triggerAction = TriggerAddAction(thistype.m_pressRightTrigger, function thistype.triggerActionKeyPressRight)
			set triggerAction = null
			set thistype.m_releaseRightTrigger = CreateTrigger()
			set triggerAction = TriggerAddAction(thistype.m_releaseRightTrigger, function thistype.triggerActionKeyReleaseRight)
			set triggerAction = null
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				set triggerEvent = TriggerRegisterPlayerEvent(thistype.m_pressUpTrigger, user, EVENT_PLAYER_ARROW_UP_DOWN)
				set triggerEvent = null
				set triggerEvent = TriggerRegisterPlayerEvent(thistype.m_releaseUpTrigger, user, EVENT_PLAYER_ARROW_UP_UP)
				set triggerEvent = null
				set triggerEvent = TriggerRegisterPlayerEvent(thistype.m_pressDownTrigger, user, EVENT_PLAYER_ARROW_DOWN_DOWN)
				set triggerEvent = null
				set triggerEvent = TriggerRegisterPlayerEvent(thistype.m_releaseDownTrigger, user, EVENT_PLAYER_ARROW_DOWN_UP)
				set triggerEvent = null
				set triggerEvent = TriggerRegisterPlayerEvent(thistype.m_pressLeftTrigger, user, EVENT_PLAYER_ARROW_LEFT_DOWN)
				set triggerEvent = null
				set triggerEvent = TriggerRegisterPlayerEvent(thistype.m_releaseLeftTrigger, user, EVENT_PLAYER_ARROW_LEFT_UP)
				set triggerEvent = null
				set triggerEvent = TriggerRegisterPlayerEvent(thistype.m_pressRightTrigger, user, EVENT_PLAYER_ARROW_RIGHT_DOWN)
				set triggerEvent = null
				set triggerEvent = TriggerRegisterPlayerEvent(thistype.m_releaseRightTrigger, user, EVENT_PLAYER_ARROW_RIGHT_UP)
				set triggerEvent = null
				set user = null
				set thistype.m_playerArrowKeys[i] = thistype.create(user)
				set i = i + 1
			endloop
		endmethod

		public static method cleanUp takes nothing returns nothing
			local integer i
			// static members
			call DestroyTrigger(thistype.m_pressUpTrigger)
			set thistype.m_pressUpTrigger = null
			call DestroyTrigger(thistype.m_releaseUpTrigger)
			set thistype.m_releaseUpTrigger = null
			call DestroyTrigger(thistype.m_pressDownTrigger)
			set thistype.m_pressDownTrigger = null
			call DestroyTrigger(thistype.m_releaseDownTrigger)
			set thistype.m_releaseDownTrigger = null
			call DestroyTrigger(thistype.m_pressLeftTrigger)
			set thistype.m_pressLeftTrigger = null
			call DestroyTrigger(thistype.m_releaseLeftTrigger)
			set thistype.m_releaseLeftTrigger = null
			call DestroyTrigger(thistype.m_pressRightTrigger)
			set thistype.m_pressRightTrigger = null
			call DestroyTrigger(thistype.m_releaseRightTrigger)
			set thistype.m_releaseRightTrigger = null
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (thistype.m_playerArrowKeys[i] != 0) then
					call thistype.m_playerArrowKeys[i].destroy()
					set thistype.m_playerArrowKeys[i] = 0
				endif
				set i = i + 1
			endloop
		endmethod

		// static dynamic members

		public static method setOnPressUpAction takes AArrowKeysOnPressAction onPressUpAction returns nothing
			set thistype.m_onPressUpAction = onPressUpAction
		endmethod

		public static method onPressUpAction takes nothing returns AArrowKeysOnPressAction
			return thistype.m_onPressUpAction
		endmethod

		public static method setOnReleaseUpAction takes AArrowKeysOnPressAction onReleaseUpAction returns nothing
			set thistype.m_onReleaseUpAction = onReleaseUpAction
		endmethod

		public static method onReleaseUpAction takes nothing returns AArrowKeysOnPressAction
			return thistype.m_onReleaseUpAction
		endmethod

		public static method setOnPressDownAction takes AArrowKeysOnPressAction onPressDownAction returns nothing
			set thistype.m_onPressDownAction = onPressDownAction
		endmethod

		public static method onPressDownAction takes nothing returns AArrowKeysOnPressAction
			return thistype.m_onPressDownAction
		endmethod

		public static method setOnReleaseDownAction takes AArrowKeysOnPressAction onReleaseDownAction returns nothing
			set thistype.m_onReleaseDownAction = onReleaseDownAction
		endmethod

		public static method onReleaseDownAction takes nothing returns AArrowKeysOnPressAction
			return thistype.m_onReleaseDownAction
		endmethod

		public static method setOnPressLeftAction takes AArrowKeysOnPressAction onPressLeftAction returns nothing
			set thistype.m_onPressLeftAction = onPressLeftAction
		endmethod

		public static method onPressLeftAction takes nothing returns AArrowKeysOnPressAction
			return thistype.m_onPressLeftAction
		endmethod

		public static method setOnReleaseLeftAction takes AArrowKeysOnPressAction onReleaseLeftAction returns nothing
			set thistype.m_onReleaseLeftAction = onReleaseLeftAction
		endmethod

		public static method onReleaseLeftAction takes nothing returns AArrowKeysOnPressAction
			return thistype.m_onReleaseLeftAction
		endmethod

		public static method setOnPressRightAction takes AArrowKeysOnPressAction onPressRightAction returns nothing
			set thistype.m_onPressRightAction = onPressRightAction
		endmethod

		public static method onPressRightAction takes nothing returns AArrowKeysOnPressAction
			return thistype.m_onPressRightAction
		endmethod

		public static method setOnReleaseRightAction takes AArrowKeysOnPressAction onReleaseRightAction returns nothing
			set thistype.m_onReleaseRightAction = onReleaseRightAction
		endmethod

		public static method onReleaseRightAction takes nothing returns AArrowKeysOnPressAction
			return thistype.m_onReleaseRightAction
		endmethod

		// static methods

		public static method playerArrowKeys takes player user returns thistype
			return thistype.m_playerArrowKeys[GetPlayerId(user)]
		endmethod
    endstruct

endlibrary