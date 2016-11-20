library StructGameCommands requires Asl, StructGameCharacter

	/**
	 * \brief The first playing human player is the admin. He can use some special commands.
	 * When the admin leaves, the next human player in the list becomes admin automatically to prevent that there is no admin.
	 */
	struct Commands
		private static trigger m_leaveTrigger
		private static player m_adminPlayer
		private static trigger m_adminTrigger
		private static trigger m_unlockTrigger
		private static trigger m_kickTrigger

		/**
		 * One player is the administrator and has higher privileges than the other players.
		 * He can use the admin commands.
		 * \return Returns the current admin player.
		 */
		public static method adminPlayer takes nothing returns player
			return thistype.m_adminPlayer
		endmethod

		private static method reselectAdmin takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
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
			local Character character = 0
			local AGroup selected = 0
			if (GetTriggerPlayer() == thistype.m_adminPlayer) then
				set selected = AGroup.create()
				call selected.addUnitsSelected(GetTriggerPlayer(), Filter(function thistype.filterIsCharacter))
				if (selected.units().isEmpty()) then
					call SimError(GetTriggerPlayer(), tre("Kein Charakter ausgewählt.", "No character selected."))
				else
					set i = 0
					loop
						exitwhen (i == selected.units().size())
						set character = Character(ACharacter.getCharacterByUnit(selected.units()[i]))
						call character.setMovable(true)
						call AGui.playerGui(character.player()).dialog().clear()
						call ResetUnitLookAt(character.unit())
						call character.setTalk(0)

						call ACharacter.getCharacterByUnit(selected.units()[i]).displayMessage(ACharacter.messageTypeInfo, tre("Vom Administrator wieder beweglich gemacht.", "Made movable again by the admin."))
						set i = i + 1
					endloop
				endif
				call selected.destroy()
			endif

			return false
		endmethod

		private static method triggerConditionKick takes nothing returns boolean
			local string kickedPlayersName
			local integer i
			local player kickedPlayer = null
			if (GetTriggerPlayer() == thistype.m_adminPlayer) then
				set kickedPlayersName = StringTrim(SubString(GetEventPlayerChatString(), StringLength("-kick"), StringLength(GetEventPlayerChatString())))
				debug call Print("Kicking player " + kickedPlayersName)
				if (StringLength(kickedPlayersName) == 0) then
					call SimError(GetTriggerPlayer(), tre("Spielername oder -nummer fehlt.", "Player name or number is missing."))

					return false
				endif
				set i = 0
				loop
					exitwhen (i == MapSettings.maxPlayers())
					// number or name matches
					if ((GetPlayerName(Player(i)) == kickedPlayersName) or ((i + 1) == S2I(kickedPlayersName))) then
						set kickedPlayer = Player(i)
						exitwhen (true)
					endif
					set i = i + 1
				endloop
				if (kickedPlayer == GetTriggerPlayer()) then
					call SimError(GetTriggerPlayer(), tre("Sie können sich nicht selbst kicken.", "You cannot kick yourself."))
				elseif (kickedPlayer == null) then
					call SimError(GetTriggerPlayer(), tre("Ungültiger Spieler.", "Invalid player."))
				else
					call CustomDefeatBJ(kickedPlayer, tre("Sie wurden aus dem Spiel gekickt.", "You have been kicked from the game."))
				endif
				set kickedPlayer = null
			endif

			return false
		endmethod

		private static method onInit takes nothing returns nothing
			local integer i
			call thistype.reselectAdmin()

			set thistype.m_leaveTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				call TriggerRegisterPlayerEvent(thistype.m_leaveTrigger, Player(i), EVENT_PLAYER_LEAVE)
				set i = i + 1
			endloop
			call TriggerAddCondition(thistype.m_leaveTrigger, Condition(function thistype.triggerConditionLeave))

			set thistype.m_adminTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				call TriggerRegisterPlayerChatEvent(thistype.m_adminTrigger, Player(i), "-admin", true)
				set i = i + 1
			endloop
			call TriggerAddCondition(thistype.m_adminTrigger, Condition(function thistype.triggerConditionAdmin))

			set thistype.m_unlockTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				call TriggerRegisterPlayerChatEvent(thistype.m_unlockTrigger, Player(i), "-unlock", true)
				set i = i + 1
			endloop
			call TriggerAddCondition(thistype.m_unlockTrigger, Condition(function thistype.triggerConditionUnlock))

			set thistype.m_kickTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				call TriggerRegisterPlayerChatEvent(thistype.m_kickTrigger, Player(i), "-kick", false)
				set i = i + 1
			endloop
			call TriggerAddCondition(thistype.m_kickTrigger, Condition(function thistype.triggerConditionKick))
		endmethod
	endstruct

endlibrary