library AStructSystemsGuiGui requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, AStructCoreGeneralVector, ALibraryCoreGeneralPlayer, AStructCoreInterfacePlayerSelection, ALibraryCoreInterfaceCamera, ALibraryCoreInterfaceMisc, ALibraryCoreStringConversion

	/// \todo Should be a static member of \ref AGui, vJass bug.
	/// This is the generic shortcut function interface.
	/// \param id Id of the object which belongs to the function call.
	function interface AGuiOnPressShortcutAction takes integer id returns nothing

	/// \todo Should be a static member of \ref AGui, vJass bug.
	/// If you want to use an explicit gui action use this.
	function interface AGuiOnPressGuiShortcutAction takes AGui gui returns nothing

	/**
	 * \brief Represents the graphical user interface which can be used by all playing players. Each player can have exactly one GUI.
	 * A GUI contains main windows which are user-defined areas on the map. That's necessary because
	 * trackables, textes and images are map-placed objects and trackables aren't removable.
	 * When you destroy an instance all docked main windows will be destroy automatically.
	 * Besides user can access a single \ref ADialog instance by using method \ref dialog().
	 * There also is a simple implemention of shortcuts by creating an unit with shortcut abilities.
	 * Unfortunately a unit can only have 12 different abilities so you can't use all ASCII keys.
	 * Maybe shortcut abilities will be added dynamically (by checking which shortcuts are really necessary) in future.
	 */
	struct AGui
		// static constant members
		public static constant integer shortcutArrowUpDown = 0 //these are the special shortcuts
		public static constant integer shortcutArrowDownDown = 1
		public static constant integer shortcutArrowLeftDown = 2
		public static constant integer shortcutArrowRightDown = 3
		public static constant integer shortcutArrowUpUp = 4
		public static constant integer shortcutArrowDownUp = 5
		public static constant integer shortcutArrowLeftUp = 6
		public static constant integer shortcutArrowRightUp = 7
		public static constant integer shortcutEscape = 8 //last value has to be lesser than 'a'
		private static constant integer m_maxSpecialShortcuts = 9
		private static constant integer m_maxMainWindows = 4 //public see above in the text macro
		private static constant integer m_maxShortcuts = 91 //'Z' + 1
		// static construction members
		private static integer m_shortcutHandlerUnitType
		private static real m_shortcutHandlerX
		private static real m_shortcutHandlerY
		private static string m_textOk
		private static integer m_shortcutOk
		// static dynamic members
		private static integer array m_shortcutAbility[thistype.m_maxShortcuts]
		// static members
		private static thistype array m_playerGui[12] /// \ref bj_MAX_PLAYERS, \todo vJass bug
		// dynamic members
		private AGuiOnPressShortcutAction array m_onPressShortcutAction[thistype.m_maxShortcuts]
		private integer array m_onPressShortcutActionId[thistype.m_maxShortcuts]
		// construction members
		private player m_player
		// members
		private AIntegerVector m_mainWindows
		private AMainWindow m_shownMainWindow
		private trigger m_leaveTrigger
		private unit m_shortcutHandler
		private trigger m_shortcutHandleTrigger
		private trigger array m_specialShortcutHandleTrigger[thistype.m_maxSpecialShortcuts]
		private APlayerSelection m_playerSelection
		private ADialog m_dialog

		//! runtextmacro optional A_STRUCT_DEBUG("\"AGui\"")

		// dynamic members

		/**
		 * Each shortcut (including special shortcuts) can have its own action.
		 * Additionally you can add shortcuts to widgets that they'll get the widgets action automatically.
		 */
		public method setOnPressShortcutAction takes integer shortcut, AGuiOnPressShortcutAction onPressShortcutAction, integer id returns nothing
			if ((shortcut >= 0) and (shortcut < thistype.m_maxSpecialShortcuts)) then
				call this.createSpecialShortcutTrigger.evaluate(shortcut)
			endif
			set this.m_onPressShortcutAction[shortcut] = onPressShortcutAction
			set this.m_onPressShortcutActionId[shortcut] = id
		endmethod

		/**
		 * Convenience method.
		 * Assigns a function to a shortcut. The function gets the AGui instance as argument.
		 */
		public method setOnPressGuiShortcutAction takes integer shortcut, AGuiOnPressGuiShortcutAction onPressGuiShortcutAction returns nothing
			call this.setOnPressShortcutAction(shortcut, onPressGuiShortcutAction, this)
		endmethod

		// construction members

		public method player takes nothing returns player
			return this.m_player
		endmethod

		// members

		public method shownMainWindow takes nothing returns AMainWindow
			return this.m_shownMainWindow
		endmethod

		public method dialog takes nothing returns ADialog
			return this.m_dialog
		endmethod

		// convenience methods

		/// \return Returns if a dialog or main window is shown to the user.
		public method isShown takes nothing returns boolean
			return this.m_shownMainWindow != 0 or this.m_dialog.isDisplayed()
		endmethod

		// methods

		/// Saves GUI users camera data and selection in game.
		public method savePlayerData takes nothing returns nothing
			call this.m_playerSelection.store()
		endmethod

		/// Loads GUI users camera data and selection from time before he has enabled the GUI.
		public method loadPlayerData takes nothing returns nothing
			call this.m_playerSelection.restore()
		endmethod

		public method showMainWindowByIndex takes integer index returns nothing
			call AMainWindow(this.m_mainWindows[index]).show.evaluate()
		endmethod

		public method enableSpecialShortcuts takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.m_maxSpecialShortcuts)
					if (this.m_specialShortcutHandleTrigger[i] != null) then
						call EnableTrigger(this.m_specialShortcutHandleTrigger[i])
					endif
				set i = i + 1
			endloop
		endmethod

		public method disableSpecialShortcuts takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.m_maxSpecialShortcuts)
					if (this.m_specialShortcutHandleTrigger[i] != null) then
						call DisableTrigger(this.m_specialShortcutHandleTrigger[i])
					endif
				set i = i + 1
			endloop
		endmethod

		public method enableShortcuts takes nothing returns nothing
			call this.enableShortcutHandler.evaluate()
			call this.enableSpecialShortcuts()
		endmethod

		/// Resets all shortcut actions!
		public method disableShortcuts takes nothing returns nothing
			call this.disableShortcutHandler.evaluate()
			call this.disableSpecialShortcuts()
		endmethod

		/// Convenience method.
		/// Shows a simple dialog with an OK button.
		/// \param message Displayed message.
		public method showInfoDialog takes string message returns nothing
			call this.m_dialog.clear()
			call this.m_dialog.setMessage(message)
			call this.m_dialog.addDialogButton(thistype.m_textOk, thistype.m_shortcutOk, 0)
			call this.m_dialog.show()
		endmethod

		/**
		 * If you dock a main window it will be destroyed when the GUI will be destroyed.
		 * \return Container index.
		 * \todo Friend relation to \ref AMainWindow. In general you do not need to use this method.
		 */
		public method dockMainWindow takes AMainWindow mainWindow returns integer
			call this.m_mainWindows.pushBack(mainWindow)
			return this.m_mainWindows.backIndex()
		endmethod

		/**
		 * Undocks a main window from GUI. If a main window is undocked there won't be any relationships between it and the GUI anymore.
		 * \todo Friend relation to \ref AMainWindow. In general you do not need to use this method.
		 */
		public method undockMainWindowByIndex takes integer index returns nothing
			call this.m_mainWindows.erase(index)
		endmethod

		/// \todo Friend relation to \ref AMainWindow, do not use!
		public method hideShownMainWindowAndSetNew takes AMainWindow mainWindow returns nothing
			if (this.m_shownMainWindow != 0) then
				call this.m_shownMainWindow.hide.evaluate()
			endif
			set this.m_shownMainWindow = mainWindow
		endmethod

		/// \todo Friend relation to \ref AMainWindow, do not use!
		public method resetShownMainWindow takes nothing returns nothing
			set this.m_shownMainWindow = 0
		endmethod

		private method enableShortcutHandler takes nothing returns nothing
			local integer i
			call PauseUnit(this.m_shortcutHandler, false)
			call ShowUnit(this.m_shortcutHandler, true)
			call SelectUnitForPlayerSingle(this.m_shortcutHandler, this.m_player)
			call EnableTrigger(this.m_shortcutHandleTrigger)
			set i = 0
			loop
				exitwhen (i == thistype.m_maxShortcuts)
				if (this.m_onPressShortcutActionId[i] != 0) then
					call UnitAddAbility(this.m_shortcutHandler, thistype.m_shortcutAbility[i])
				endif
				set i = i + 1
			endloop
		endmethod

		/// Resets all shortcut actions!
		private method disableShortcutHandler takes nothing returns nothing
			local integer i
			call PauseUnit(this.m_shortcutHandler, true)
			call ShowUnit(this.m_shortcutHandler, false)
			call SelectUnitRemoveForPlayer(this.m_shortcutHandler, this.m_player)
			call DisableTrigger(this.m_shortcutHandleTrigger)
			set i = 0
			loop
				exitwhen (i == thistype.m_maxShortcuts)
				if (this.m_onPressShortcutActionId[i] != 0) then
					call UnitRemoveAbility(this.m_shortcutHandler, thistype.m_shortcutAbility[i])
				endif
				set this.m_onPressShortcutActionId[i] = 0
				set i = i + 1
			endloop
		endmethod

		private static method triggerActionPlayerLeaves takes nothing returns nothing
			local player triggerPlayer = GetTriggerPlayer()
			call thistype.m_playerGui[GetPlayerId(triggerPlayer)].destroy()
			set triggerPlayer = null
		endmethod

		private method createLeaveTrigger takes nothing returns nothing
			local event triggerEvent
			local triggeraction triggerAction
			set this.m_leaveTrigger = CreateTrigger()
			set triggerEvent = TriggerRegisterPlayerEvent(this.m_leaveTrigger, this.m_player, EVENT_PLAYER_LEAVE)
			set triggerAction = TriggerAddAction(this.m_leaveTrigger, function thistype.triggerActionPlayerLeaves)
			set triggerEvent = null
			set triggerAction = null
		endmethod

		private method createShortcutHandler takes nothing returns nothing
			set this.m_shortcutHandler = CreateUnit(this.m_player, thistype.m_shortcutHandlerUnitType, thistype.m_shortcutHandlerX, thistype.m_shortcutHandlerY, 0.0)
			call SetUnitInvulnerable(this.m_shortcutHandler, true)
			call ShowUnit(this.m_shortcutHandler, false)
		endmethod

		private static method triggerActionOnPressShortcut takes nothing returns nothing
			local integer i
			local integer abilityId  = GetSpellAbilityId()
			local trigger triggeringTrigger
			local thistype this
			set i = 'a'
			loop
				exitwhen (i == thistype.m_maxShortcuts)
				if (abilityId == thistype.m_shortcutAbility[i]) then
					set triggeringTrigger = GetTriggeringTrigger()
					set this = AHashTable.global().handleInteger(triggeringTrigger, 0)
					debug if (this.m_onPressShortcutAction[i] != 0) then
						debug call Print("Action exists")
					debug endif
					call this.m_onPressShortcutAction[i].execute(this.m_onPressShortcutActionId[i])
					set triggeringTrigger = null
					exitwhen (true)
				endif
				set i  = i + 1
			endloop
		endmethod

		private method createShortcutHandleTrigger takes nothing returns nothing
			local event triggerEvent
			local triggeraction triggerAction
			set this.m_shortcutHandleTrigger = CreateTrigger()
			set triggerEvent = TriggerRegisterUnitEvent(this.m_shortcutHandleTrigger, this.m_shortcutHandler, EVENT_UNIT_SPELL_CAST)
			set triggerAction = TriggerAddAction(this.m_shortcutHandleTrigger, function thistype.triggerActionOnPressShortcut)
			call AHashTable.global().setHandleInteger(this.m_shortcutHandleTrigger, 0, this)
			set triggerEvent = null
			set triggerAction = null
		endmethod

		private static method triggerActionOnPressSpecialShortcut takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, 0)
			local integer shortcut = AHashTable.global().handleInteger(triggeringTrigger, 1)
			call this.m_onPressShortcutAction[shortcut].execute(this)
			set triggeringTrigger = null
		endmethod

		/// This method won't be called in the constructor.
		/// It is a dynamic creation.
		private method createSpecialShortcutTrigger takes integer shortcut returns nothing
			local event triggerEvent
			local triggeraction triggerAction
			//don't check if the action is 0, it can be changed dynamicly!
			//the trigger can't be changed dynamicly
			if (this.m_specialShortcutHandleTrigger[shortcut] == null) then
				set this.m_specialShortcutHandleTrigger[shortcut] = CreateTrigger()
				if (shortcut == thistype.shortcutArrowUpDown) then
					set triggerEvent = TriggerRegisterPlayerEvent(this.m_specialShortcutHandleTrigger[shortcut], this.m_player, EVENT_PLAYER_ARROW_UP_DOWN)
				elseif (shortcut == thistype.shortcutArrowDownDown) then
					set triggerEvent = TriggerRegisterPlayerEvent(this.m_specialShortcutHandleTrigger[shortcut], this.m_player, EVENT_PLAYER_ARROW_DOWN_DOWN)
				elseif (shortcut == thistype.shortcutArrowLeftDown) then
					set triggerEvent = TriggerRegisterPlayerEvent(this.m_specialShortcutHandleTrigger[shortcut], this.m_player, EVENT_PLAYER_ARROW_LEFT_DOWN)
				elseif (shortcut == thistype.shortcutArrowRightDown) then
					set triggerEvent = TriggerRegisterPlayerEvent(this.m_specialShortcutHandleTrigger[shortcut], this.m_player, EVENT_PLAYER_ARROW_RIGHT_DOWN)
				elseif (shortcut == thistype.shortcutArrowUpUp) then
					set triggerEvent = TriggerRegisterPlayerEvent(this.m_specialShortcutHandleTrigger[shortcut], this.m_player, EVENT_PLAYER_ARROW_UP_UP)
				elseif (shortcut == thistype.shortcutArrowDownUp) then
					set triggerEvent = TriggerRegisterPlayerEvent(this.m_specialShortcutHandleTrigger[shortcut], this.m_player, EVENT_PLAYER_ARROW_DOWN_UP)
				elseif (shortcut == thistype.shortcutArrowLeftUp) then
					set triggerEvent = TriggerRegisterPlayerEvent(this.m_specialShortcutHandleTrigger[shortcut], this.m_player, EVENT_PLAYER_ARROW_LEFT_UP)
				elseif (shortcut == thistype.shortcutArrowRightUp) then
					set triggerEvent = TriggerRegisterPlayerEvent(this.m_specialShortcutHandleTrigger[shortcut], this.m_player, EVENT_PLAYER_ARROW_RIGHT_UP)
				elseif (shortcut == thistype.shortcutEscape) then
					set triggerEvent = TriggerRegisterPlayerEvent(this.m_specialShortcutHandleTrigger[shortcut], this.m_player, EVENT_PLAYER_END_CINEMATIC)
				endif
				set triggerAction = TriggerAddAction(this.m_specialShortcutHandleTrigger[shortcut], function thistype.triggerActionOnPressSpecialShortcut)
				call AHashTable.global().setHandleInteger(this.m_specialShortcutHandleTrigger[shortcut], 0, this)
				call AHashTable.global().setHandleInteger(this.m_specialShortcutHandleTrigger[shortcut], 1, shortcut)
				set triggerEvent = null
				set triggerAction = null
			endif
		endmethod

		/// Don't use the constructor.
		/// Use \ref playerGui().
		/// Shortcuts will be disabled first.
		private static method create takes player whichPlayer returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_player = whichPlayer
			// members
			set this.m_mainWindows = AIntegerVector.create()
			set this.m_shownMainWindow = 0
			set this.m_playerSelection = APlayerSelection.create(whichPlayer)
			set this.m_dialog = ADialog.create(whichPlayer)

			call this.createLeaveTrigger()
			call this.createShortcutHandler()
			call this.createShortcutHandleTrigger()
			call this.disableShortcuts()
			return this
		endmethod

		private method destroyLeaveTrigger takes nothing returns nothing
			call DestroyTrigger(this.m_leaveTrigger)
			set this.m_leaveTrigger = null
		endmethod

		private method removeShortcutHandler takes nothing returns nothing
			call RemoveUnit(this.m_shortcutHandler)
			set this.m_shortcutHandler = null
		endmethod

		private method destroyShortcutHandleTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_shortcutHandleTrigger)
			set this.m_shortcutHandleTrigger = null
		endmethod

		private method destroySpecialShortcutTriggers takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.m_maxSpecialShortcuts)
					if (this.m_specialShortcutHandleTrigger[i] != null) then
						call AHashTable.global().destroyTrigger(this.m_specialShortcutHandleTrigger[i])
						set this.m_specialShortcutHandleTrigger[i] = null
					endif
				set i = i + 1
			endloop
		endmethod

		/// Will be destroyed when player leaves the game.
		private method onDestroy takes nothing returns nothing
			// members
			loop
				exitwhen (this.m_mainWindows.empty())
				call AMainWindow(this.m_mainWindows.back()).destroy()
				// don't pop back
			endloop
			call this.m_mainWindows.destroy()
			call this.m_playerSelection.destroy()
			call this.m_dialog.destroy()

			call this.destroyLeaveTrigger()
			call this.removeShortcutHandler()
			call this.destroyShortcutHandleTrigger()
			call this.destroySpecialShortcutTriggers()
		endmethod

		/**
		 * \param shortcutHandlerUnitType The unit type of the unit which is selected during the display time of the GUI. It should have all shortcut abilities.
		 * \param shortcutHandlerX The x coordinate of the shortcut handlers position.
		 * \param shortcutHandlerY The y coordinate of the shortcut handlers position.
		 * \param textOk The text which is displayed as Ok text.
		 * \param shortcutOk The shortcut which is used for the Ok text.
		 */
		public static method init takes integer shortcutHandlerUnitType, real shortcutHandlerX, real shortcutHandlerY, string textOk, integer shortcutOk returns nothing
			local integer i
			// static construction members
			set thistype.m_shortcutHandlerUnitType = shortcutHandlerUnitType
			set thistype.m_shortcutHandlerX = shortcutHandlerX
			set thistype.m_shortcutHandlerY = shortcutHandlerY
			set thistype.m_textOk = textOk
			set thistype.m_shortcutOk = shortcutOk
			// static members
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set thistype.m_playerGui[i] = thistype.create(Player(i))
				set i = i + 1
			endloop
		endmethod

		// static dynamic members

		public static method setShortcutAbility takes integer shortcutAbility, integer abilityId returns nothing
			set thistype.m_shortcutAbility[shortcutAbility] = abilityId
		endmethod

		public static method shortcutAbility takes integer shortcutAbility returns integer
			return thistype.m_shortcutAbility[shortcutAbility]
		endmethod

		// static methods

		public static method playerGui takes player whichPlayer returns thistype
			return thistype.m_playerGui[GetPlayerId(whichPlayer)]
		endmethod

		// static convenience methods

		public static method setOnPressGuiShortcutActionForAll takes integer shortcut, AGuiOnPressGuiShortcutAction onPressGuiShortcutAction returns nothing
			local integer i
			local player whichPlayer
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set whichPlayer = Player(i)
				if (IsPlayerPlayingUser(whichPlayer)) then
					call thistype.playerGui(whichPlayer).setOnPressGuiShortcutAction(shortcut, onPressGuiShortcutAction)
				endif
				set whichPlayer = null
				set i = i + 1
			endloop
		endmethod

		public static method showInfoDialogToAll takes string text returns nothing
			local integer i
			local player whichPlayer
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set whichPlayer = Player(i)
				if (IsPlayerPlayingUser(whichPlayer)) then
					call thistype.playerGui(whichPlayer).showInfoDialog(text)
				endif
				set whichPlayer = null
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary