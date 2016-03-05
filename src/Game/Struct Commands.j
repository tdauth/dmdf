library StructGameCommands requires Asl, StructGameCharacter

	/**
	 * \brief The first playing human player is the admin. He can use some special commands.
	 */
	struct Commands
		private static trigger m_leaveTrigger
		private static player m_adminPlayer
		private static trigger m_adminTrigger
		private static trigger m_unlockTrigger
		
		public static method adminPlayer takes nothing returns player
			return thistype.m_adminPlayer
		endmethod
		
		private static method reselectAdmin takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (GetPlayerSlotState(Player(i)) == PLAYER_SLOT_STATE_PLAYING and GetPlayerController(Player(i)) == MAP_CONTROL_USER) then
					set thistype.m_adminPlayer = Player(i)
					call Character.displayHintToAll(Format(tre("%1% ist nun Administrator.", "%1% is now admin.")).s(GetPlayerName(thistype.m_adminPlayer)).result())
					exitwhen (true)
				endif
				set i = i + 1
			endloop
		endmethod
		
		private static method triggerConditionLeave takes nothing returns boolean
			if (GetTriggerPlayer() == thistype.m_adminPlayer) then
				call thistype.reselectAdmin()
			endif
			
			return false
		endmethod
		
		private static method triggerConditionAdmin takes nothing returns boolean
			call DisplayTextToPlayer(GetTriggerPlayer(), 0.0, 0.0, Format(tre("%1% ist Administrator.", "%1% is admin.")).s(GetPlayerName(thistype.m_adminPlayer)).result())
			
			return false
		endmethod
		
		private static method filterIsCharacter takes nothing returns boolean
			return ACharacter.isUnitCharacter(GetFilterUnit())
		endmethod
		
		private static method triggerConditionUnlock takes nothing returns boolean
			local integer i
			local AGroup selected = AGroup.create()
			call selected.addUnitsSelected(GetTriggerPlayer(), Filter(function thistype.filterIsCharacter))
			if (selected.units().isEmpty()) then
				call SimError(GetTriggerPlayer(), tre("Kein Charakter ausgewählt.", "No character selected."))
			else
				set i = 0
				loop
					exitwhen (i == selected.units().size())
					call ACharacter.getCharacterByUnit(selected.units()[i]).setMovable(true)
					call ACharacter.getCharacterByUnit(selected.units()[i]).displayMessage(ACharacter.messageTypeInfo, tre("Vom Administrator wieder beweglich gemacht.", "Made movable again by the admin."))
					set i = i + 1
				endloop
			endif
			call selected.destroy()
			
			return false
		endmethod
	
		private static method onInit takes nothing returns nothing
			local integer i
			call thistype.reselectAdmin()
			
			set thistype.m_leaveTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call TriggerRegisterPlayerEvent(thistype.m_leaveTrigger, Player(i), EVENT_PLAYER_LEAVE)
				set i = i + 1
			endloop
			call TriggerAddCondition(thistype.m_leaveTrigger, Condition(function thistype.triggerConditionLeave))
			
			set thistype.m_adminTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call TriggerRegisterPlayerChatEvent(thistype.m_adminTrigger, Player(i), "-admin", true)
				set i = i + 1
			endloop
			call TriggerAddCondition(thistype.m_adminTrigger, Condition(function thistype.triggerConditionAdmin))
			
			set thistype.m_unlockTrigger = CreateTrigger()
			call TriggerRegisterPlayerChatEvent(thistype.m_unlockTrigger, Player(0), "-unlock", true)
			call TriggerAddCondition(thistype.m_unlockTrigger, Condition(function thistype.triggerConditionUnlock))
		endmethod
	endstruct
	
endlibrary