/// \author Tamino Dauth
library AStructCoreDebugCheat requires ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, ALibraryCoreGeneralPlayer, ALibraryCoreStringMisc, ALibraryCoreStringPool

	/// \todo Should be a part of \ref ACheat, vJass bug.
	function interface ACheatOnCheatAction takes ACheat cheat returns nothing

	/**
	 * ACheat provides simple cheat functionality. Cheats are strings which has to be entered by one player into the chat and which are connected to a user-defined function called "action" using interface \ref ACheatOnCheatAction which is called via .execute() immediately after the cheat was sent to the screen.
	 *
	 * Cheats may have arguments. For example, you could create a cheat  called "setlevel" which
	 * expects a level value after the cheat expression.
	 * Since you can create cheats without requiring exact match on entered chat string, arguments can be passed, as well.
	 * Use \ref thistype#arguments() to get them in your custom function.
	 *
	 * \note Note that you can use \ref GetEventPlayerChatString() in the corresponding function to read the whole entered chat string.
	 *
	 * \note Unlike exact match in \ref TriggerRegisterPlayerChatEvent() this just works if there are only white space characters prior the cheat expression if \ref exactMatch() returns false. For example "    setlevel 3".
	 */
	struct ACheat
		// construction members
		private string m_cheat
		private boolean m_exactMatch
		private ACheatOnCheatAction m_action
		// members
		private trigger m_cheatTrigger

		//! runtextmacro optional A_STRUCT_DEBUG("\"ACheat\"")

		// construction members

		public method cheat takes nothing returns string
			return this.m_cheat
		endmethod

		/**
		 * \note Unlike exact match in \ref TriggerRegisterPlayerChatEvent() this just works if there are only white space characters prior the cheat expression if \ref exactMatch() returns false. For example "    setlevel 3".
		 */
		public method exactMatch takes nothing returns boolean
			return this.m_exactMatch
		endmethod

		// methods

		private method findCheat takes string chatString returns integer
			local integer index = FindString(chatString, this.cheat())
			if (index == -1) then
				return -1
			endif
			if ((index > 0) and (not IsStringWhiteSpace(SubString(chatString, 0, index)))) then
				return -1
			endif
			return index
		endmethod

		/**
		 * \return Returns the whole entered cheat without the cheat expression itself refered as cheat arguments.
		 * For example, if player has entered "setlevel 3 all" and "setlevel" is the actual cheat this would return "3 all".
		 * \note This doesn only works if \ref exactMatch() is false.
		 * \note Unlike exact match in \ref TriggerRegisterPlayerChatEvent() this just works if there are only white space characters prior the cheat expression if \ref exactMatch() returns false. For example "    setlevel 3".
		 * \note Argument is returned with spaces which come after the cheat expression, so \ref StringTrim() might be useful.
		 */
		public method argument takes nothing returns string
			local integer index = this.findCheat(GetEventPlayerChatString())
			if (index == -1) then
				return ""
			endif
			return SubString(GetEventPlayerChatString(), index + StringLength(this.cheat()), StringLength(GetEventPlayerChatString()))
		endmethod

		private static method triggerConditionCheat takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			debug call this.print("Checking cheat with string: " + GetEventPlayerChatString())
			return (this.findCheat(GetEventPlayerChatString()) != -1)
		endmethod

		private static method triggerActionCheat takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			if (this.m_action != 0) then
				call this.m_action.execute(this)
			debug else
				debug call this.print("Missing cheat action.")
			endif
		endmethod

		private method createCheatTrigger takes nothing returns nothing
			local integer i
			set this.m_cheatTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (IsPlayerPlayingUser(Player(i))) then
					call TriggerRegisterPlayerChatEvent(this.m_cheatTrigger, Player(i), this.m_cheat, this.m_exactMatch)
				endif
				set i = i + 1
			endloop
			call TriggerAddCondition(this.m_cheatTrigger, Condition(function thistype.triggerConditionCheat))
			call TriggerAddAction(this.m_cheatTrigger, function thistype.triggerActionCheat)
			call AHashTable.global().setHandleInteger(this.m_cheatTrigger, 0, this)
		endmethod

		/**
		 * \param cheat String value a player has to enter into the chat.
		 * \param exactMatch If this value is false user does not have to enter the exact string of \p cheat to run the cheat. For example if the cheat string is "setlevel" "setlevel 1000" would work, as well.
		 * \param action The function which will be called when any player enters cheat string. Consider that it is called via .execute() not .evaluate()!
		 */
		public static method create takes string cheat, boolean exactMatch, ACheatOnCheatAction action returns thistype
			local thistype this = thistype.allocate()
			debug if (cheat == null) then
				debug call this.print("cheat is empty.")
			debug endif
			debug if (action == 0) then
				debug call this.print("action is 0.")
			debug endif
			// construction members
			set this.m_cheat = cheat
			set this.m_exactMatch = exactMatch
			set this.m_action = action

			call this.createCheatTrigger()
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_cheatTrigger)
			set this.m_cheatTrigger = null
			debug call this.print("Destroying cheat " + this.m_cheat)
		endmethod
	endstruct

endlibrary