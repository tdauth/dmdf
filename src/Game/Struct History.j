library StructGameHistory requires Asl

	/**
	 * \brief The history allows each player to view logged game messages which can be useful in multiplayer games where only the chat history is available by default.
	 */
	struct History
		public static constant integer maxStorage = 200
		private static History array m_playerHistory[12]
		private AStringList m_messages
		private boolean m_log
		private trigger m_commandTrigger
		
		public method log takes nothing returns boolean
			return this.m_log
		endmethod
		
		public method addMessage takes string message returns nothing
			if (this.m_messages.size() == thistype.maxStorage) then
				call this.m_messages.popFront()
			endif
			call this.m_messages.pushBack(message)
		endmethod
		
		public method print takes player whichPlayer, integer maxMessages returns nothing
			local integer start = IMaxBJ(this.m_messages.size() - maxMessages, 0)
			local integer i = 0
			local AStringListIterator iterator = this.m_messages.begin()
			set this.m_log = false
			debug call Print("Print history entries: " + I2S(this.m_messages.size() - start))
			loop
				exitwhen (i == this.m_messages.size() or not iterator.isValid())
				if (i >= start) then
					call DisplayTextToPlayer(whichPlayer, 0, 0, iterator.data())
				endif
				call iterator.next()
				set i = i + 1
			endloop
			call iterator.destroy()
			set this.m_log = true
		endmethod
		
		private static method triggerConditionShow takes nothing returns boolean
			local integer index = FindString(GetEventPlayerChatString(), "-history")
			return index == 0
		endmethod
		
		private static method triggerActionShow takes nothing returns nothing
			local integer index = FindString(GetEventPlayerChatString(), "-history")
			local string arg = SubString(GetEventPlayerChatString(), index + StringLength("-history"), StringLength(GetEventPlayerChatString()))
			local integer maxMessages = 5
			if (StringLength(arg) > 0) then
				set maxMessages = S2I(arg)
			endif
			
			call thistype.playerHistory.evaluate(GetTriggerPlayer()).print(GetTriggerPlayer(), maxMessages)
		endmethod
		
		private static method create takes player whichPlayer returns thistype
			local thistype this = thistype.allocate()
			set this.m_messages = AStringList.create()
			set this.m_log = true
			set this.m_commandTrigger = CreateTrigger()
			call TriggerRegisterPlayerChatEvent(this.m_commandTrigger,whichPlayer, "-history", false)
			call TriggerAddCondition(this.m_commandTrigger, Condition(function thistype.triggerConditionShow))
			call TriggerAddAction(this.m_commandTrigger, function thistype.triggerActionShow)
			
			return this
		endmethod
		
		private method onDestroy takes nothing returns nothing
			call this.m_messages.destroy()
			set this.m_messages = 0
			call DestroyTrigger(this.m_commandTrigger)
			set this.m_commandTrigger = null
		endmethod
		
		public static method playerHistory takes player whichPlayer returns thistype
			return thistype.m_playerHistory[GetPlayerId(whichPlayer)]
		endmethod
		
		private static method onInit takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (IsPlayerPlayingUser(Player(i))) then
					set thistype.m_playerHistory[i] = thistype.create(Player(i))
				endif
				set i = i + 1
			endloop
		endmethod
		
	endstruct

	private function DisplayTextToPlayerHook takes player toPlayer, real x, real y, string message returns nothing
		if (History.playerHistory(toPlayer).log()) then
			call History.playerHistory(toPlayer).addMessage(message)
		endif
	endfunction
	
	private function DisplayTimedTextToPlayerHook takes player toPlayer, real x, real y, real duration, string message returns nothing
		if (History.playerHistory(toPlayer).log()) then
			call History.playerHistory(toPlayer).addMessage(message)
		endif
	endfunction

	private function DisplayTimedTextFromPlayerHook takes player toPlayer, real x, real y, real duration, string message returns nothing
		if (History.playerHistory(toPlayer).log()) then
			call History.playerHistory(toPlayer).addMessage(message)
		endif
	endfunction
	
	// TODO only log transmission for players
	/*
	private function SetCinematicSceneHook takes integer portraitUnitId, playercolor color, string speakerTitle, string text, real sceneDuration, real voiceoverDuration returns nothing
		local integer i = 0
		loop
			exitwhen (i == bj_MAX_PLAYERS) then
			if (History.playerHistory(Player(i)).log()) then
				call History.playerHistory(Player(i)).addMessage(text)
			endif
			set i = i + 1
		endloop
	endfunction
	*/

	// FIXME GetLocalPlayer() - local code
	//hook DisplayTextToPlayer DisplayTextToPlayerHook
	//hook DisplayTimedTextToPlayer DisplayTimedTextToPlayerHook
	//hook DisplayTimedTextFromPlayer DisplayTimedTextFromPlayerHook
	//hook SetCinematicScene SetCinematicSceneHook
	
endlibrary