library AStructSystemsCharacterQuest requires optional ALibraryCoreDebugMisc, ALibraryCoreEnvironmentSound, AStructCoreGeneralVector, ALibraryCoreStringConversion, AStructSystemsCharacterAbstractQuest, AStructSystemsCharacterQuestItem

	/**
	 * \brief Some kind of more specific emulation of data type \ref quest.
	 * Allows you to create character-related quests and define it's state behaviour (extends AAbstractQuest).
	 * It's not necessarily required that AQuest instances create \ref quest objects. This must be defined in the initialization method.
	 * \internal Don't move quest items since they're stored via their corresponding index (besides we're using AIntegerVector which has huge performance costs for reodering elements)!
	 */
	struct AQuest extends AAbstractQuest
		// static construction members
		private static boolean m_useQuestLog
		private static boolean m_likeWarcraft
		private static string m_updateSoundPath
		private static string m_textQuestNew
		private static string m_textQuestCompleted
		private static string m_textQuestFailed
		private static string m_textQuestUpdate
		private static string m_textListItem
		// dynamic members
		private AIntegerVector m_questItems
		private string m_iconPath
		private string m_description
		private boolean m_isRequired
		// members
		private quest m_questLogQuest

		///! runtextmacro optional A_STRUCT_DEBUG("\"AQuest\"")

		// dynamic members

		public method questItem takes integer index returns AQuestItem
			return this.m_questItems[index]
		endmethod

		public method setIconPath takes string iconPath returns nothing
			debug if (not thistype.m_useQuestLog) then
				debug call this.print("setIconPath() was called (quest log is disabled).")
			debug endif
			set this.m_iconPath = iconPath
			call QuestSetIconPath(this.m_questLogQuest, iconPath)
		endmethod

		public method iconPath takes nothing returns string
			return this.m_iconPath
		endmethod

		/// No flash, just when you change the state!
		/// Description also is not used as start property because you do not always use the quest log.
		public method setDescription takes string description returns nothing
			debug if (not thistype.m_useQuestLog) then
				debug call this.print("setDescription() was called (quest log is disabled).")
			debug endif
			set this.m_description = description
			call QuestSetDescription(this.m_questLogQuest, description)
		endmethod

		public method description takes nothing returns string
			return this.m_description
		endmethod

		public method setIsRequired takes boolean isRequired returns nothing
			set this.m_isRequired = isRequired
			call QuestSetRequired(this.m_questLogQuest, isRequired)
		endmethod

		public method isRequired takes nothing returns boolean
			return this.m_isRequired
		endmethod

		// members

		/// Used by \ref AQuestItem, do not use.
		public method questLogQuest takes nothing returns quest
			return this.m_questLogQuest
		endmethod

		// methods

		/// \todo Should be protected
		public stub method distributeRewards takes nothing returns nothing
			call super.distributeRewards()
		endmethod

		public method hasLatestPing takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_questItems.size())
				if (AQuestItem(this.m_questItems[i]).state() == thistype.stateNew and AQuestItem(this.m_questItems[i]).ping()) then
					return true
				endif
				set i = i + 1
			endloop
			if (this.state() == thistype.stateNew and this.ping()) then
				return true
			endif
			return false
		endmethod

		public method latestPingX takes nothing returns real
			local integer i = 0
			loop
				exitwhen (i == this.m_questItems.size())
				if (AQuestItem(this.m_questItems[i]).state() == thistype.stateNew and AQuestItem(this.m_questItems[i]).ping()) then
					if (AQuestItem(this.m_questItems[i]).pingWidget() != null) then
						return GetWidgetX(AQuestItem(this.m_questItems[i]).pingWidget())
					else
						return AQuestItem(this.m_questItems[i]).pingX()
					endif
				endif
				set i = i + 1
			endloop
			if (this.state() == thistype.stateNew and this.ping()) then
				if (this.pingWidget() != null) then
					return GetWidgetX(this.pingWidget())
				else
					return this.pingX()
				endif
			endif
			return 0.0
		endmethod

		public method latestPingY takes nothing returns real
			local integer i = 0
			loop
				exitwhen (i == this.m_questItems.size())
				if (AQuestItem(this.m_questItems[i]).state() == thistype.stateNew and AQuestItem(this.m_questItems[i]).ping()) then
					if (AQuestItem(this.m_questItems[i]).pingWidget() != null) then
						return GetWidgetY(AQuestItem(this.m_questItems[i]).pingWidget())
					else
						return AQuestItem(this.m_questItems[i]).pingY()
					endif
				endif
				set i = i + 1
			endloop
			if (this.state() == thistype.stateNew and this.ping()) then
				if (this.pingWidget() != null) then
					return GetWidgetY(this.pingWidget())
				else
					return this.pingY()
				endif
			endif
			return 0.0
		endmethod

		private method displayStateMessage takes string soundPath returns nothing
			local integer i

			if (this.character() != 0) then

				call this.character().displayMessage(ACharacter.messageTypeInfo, this.title())
				if (not thistype.m_likeWarcraft or (not this.isCompleted() and not this.isFailed())) then
					set i = 0
					loop
						exitwhen (i == this.m_questItems.size())
						if (not AQuestItem(this.m_questItems[i]).isNotUsed()) then
							call this.character().displayMessage(ACharacter.messageTypeInfo, StringArg(thistype.m_textListItem, AQuestItem(this.m_questItems[i]).modifiedTitle()))
						endif
						set i = i + 1
					endloop
				endif
				if (soundPath != null) then
					call PlaySoundFileForPlayer(this.character().player(), soundPath)
				endif
			else
				call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, this.title())
				if (not thistype.m_likeWarcraft or (not this.isCompleted() and not this.isFailed())) then
					set i = 0
					loop
						exitwhen (i == this.m_questItems.size())
						if (not AQuestItem(this.m_questItems[i]).isNotUsed()) then
							call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, StringArg(thistype.m_textListItem, AQuestItem(this.m_questItems[i]).modifiedTitle()))
						endif
						set i = i + 1
					endloop
				endif
				if (soundPath != null) then
					call PlaySound(soundPath)
				endif
			endif

			if (thistype.m_useQuestLog) then
				if (this.character() == 0 or GetLocalPlayer() == this.character().player()) then
					call FlashQuestDialogButton()
					call ForceQuestDialogUpdate() //required?
				endif
			endif
		endmethod

		public method displayState takes nothing returns nothing
			local string title = null

			if (this.state() == AAbstractQuest.stateNew and thistype.m_textQuestNew != null) then
				set title = thistype.m_textQuestNew
			elseif (this.state() == AAbstractQuest.stateCompleted and thistype.m_textQuestCompleted != null) then
				set title = thistype.m_textQuestCompleted
			elseif (this.state() == AAbstractQuest.stateFailed and thistype.m_textQuestFailed != null) then
				set title = thistype.m_textQuestFailed
			endif


			if (this.character() != 0) then
				if (thistype.m_likeWarcraft) then
					call this.character().displayMessage(ACharacter.messageTypeInfo, " ") // Warcraft like line break
				endif
				if (title != null) then
					call this.character().displayMessage(ACharacter.messageTypeInfo, title)
				endif
			else
				if (thistype.m_likeWarcraft) then
					call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, " ") // Warcraft like line break
				endif
				if (title != null) then
					call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, title)
				endif
			endif

			call this.displayStateMessage(this.soundPath())
		endmethod

		/**
		 * Displays all quest item states as well as the quest state as an update message to the corresponding player
		 * or all players.
		 */
		public method displayUpdate takes nothing returns nothing
			if (this.character() != 0) then
				if (thistype.m_textQuestUpdate != null) then
					call this.character().displayMessage(ACharacter.messageTypeInfo, thistype.m_textQuestUpdate)
				endif
			else
				if (thistype.m_textQuestUpdate != null) then
					call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, thistype.m_textQuestUpdate)
				endif
			endif

			call this.displayStateMessage(thistype.m_updateSoundPath)
		endmethod

		/**
		 * Displays a user defined quest update message with the corresponding title of the quest .
		 * If this quest belongs to one character the message is shown the the character's owner only.
		 * Otherwise it is shown to all players.
		 * \param message The message which is displayed to all players of the quest.
		 */
		public method displayUpdateMessage takes string message returns nothing
			if (this.character() != 0) then
				if (thistype.m_textQuestUpdate != null) then
					call this.character().displayMessage(ACharacter.messageTypeInfo, thistype.m_textQuestUpdate)
				endif
				call this.character().displayMessage(ACharacter.messageTypeInfo, this.title())
				call this.character().displayMessage(ACharacter.messageTypeInfo, message)
				if (thistype.m_updateSoundPath != null) then
					call PlaySoundFileForPlayer(this.character().player(), thistype.m_updateSoundPath)
				endif
			else
				if (thistype.m_textQuestUpdate != null) then
					call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, thistype.m_textQuestUpdate)
				endif
				call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, this.title())
				call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, message)
				if (thistype.m_updateSoundPath != null) then
					call PlaySound(thistype.m_updateSoundPath)
				endif
			endif
		endmethod

		/// Single call!
		public stub method enableUntil takes integer questItemIndex returns boolean
			local integer i = 0
			if (this.setState(AAbstractQuest.stateNew)) then
				set i = 0
				loop
					exitwhen (i == IMinBJ(this.m_questItems.size(), questItemIndex + 1))
					call AQuestItem(this.m_questItems[i]).setState(AAbstractQuest.stateNew)
					set i = i + 1
				endloop
				call this.displayState()
				return true
			endif
			return false
		endmethod

		/// Single call!
		/// Enables all items (checking conditions).
		public stub method enable takes nothing returns boolean
			return this.enableUntil(this.m_questItems.size() - 1)
		endmethod

		/// Single call!
		/// Should disable all items since setting state to AAbstractQuest.stateNotUsed will set all items to this state, too.
		public stub method disable takes nothing returns boolean
			return this.setState(AAbstractQuest.stateNotUsed)
		endmethod

		/// Single call!
		public stub method complete takes nothing returns boolean
			if (this.setState(AAbstractQuest.stateCompleted)) then
				call this.displayState()
				return true
			endif
			return false
		endmethod

		/// Single call!
		public stub method fail takes nothing returns boolean
			if (this.setState(AAbstractQuest.stateFailed)) then
				call this.displayState()
				return true
			endif
			return false
		endmethod

		private method setQuestLogState takes integer state returns nothing
			if (state == AAbstractQuest.stateNotUsed) then
				if (this.character() == 0 or GetLocalPlayer() == this.character().player()) then
					//call QuestSetDiscovered(this.m_questLogQuest, false)
					call QuestSetEnabled(this.m_questLogQuest, false)
				endif
			elseif (state == AAbstractQuest.stateNew) then
				if (this.character() == 0 or GetLocalPlayer() == this.character().player()) then
					//call QuestSetDiscovered(this.m_questLogQuest, true)
					call QuestSetEnabled(this.m_questLogQuest, true)
				endif
			elseif (state == AAbstractQuest.stateCompleted) then
				if (this.character() == 0 or GetLocalPlayer() == this.character().player()) then
					call QuestSetCompleted(this.m_questLogQuest, true)
				endif
			elseif (state == AAbstractQuest.stateFailed) then
				if (this.character() == 0 or GetLocalPlayer() == this.character().player()) then
					call QuestSetFailed(this.m_questLogQuest, true)
				endif
			endif
		endmethod

		/// Note that if quest's state is changed quest items states will be changed automatically without checking conditions.
		public stub method setStateWithoutCondition takes integer state returns nothing
			local integer i
			if (this.state() == state) then
				call super.setStateWithoutCondition(state)
				return
			endif
			if (state == AAbstractQuest.stateCompleted or state == AAbstractQuest.stateFailed or state == AAbstractQuest.stateNotUsed) then
				set i = 0
				loop
					exitwhen (i == this.m_questItems.size())
					if (AQuestItem(this.m_questItems[i]).state() == AAbstractQuest.stateNew) then
						call AQuestItem(this.m_questItems[i]).setStateWithoutConditionAndCheck(state) // if you call it with check it will be completed twice
					endif
					set i = i + 1
				endloop
			endif
			if (thistype.m_useQuestLog) then
				call QuestSetTitle(this.m_questLogQuest, this.title())
				//call QuestSetDescription(this.questLogQuest, this.description)
				call this.setQuestLogState(state)
			endif

			call super.setStateWithoutCondition(state)
		endmethod

		/// If all quest items have an equal state quest does also get their state (without checking its state condition!)
		public method checkQuestItemsForState takes integer state returns boolean
			local integer i
			local boolean result = true
			// does not already have the same state
			if (this.state() != state) then
				set i = 0
				loop
					exitwhen(i == this.m_questItems.size())
					if (AQuestItem(this.m_questItems[i]).state() != state) then
						set result = false
					endif
					set i = i + 1
				endloop
				if (result) then
					call this.setStateWithoutCondition(state)
				endif
			endif
			return result
		endmethod

		/// Friend relationship to \ref AQuestItem, do not use.
		public method addQuestItem takes AQuestItem questItem returns integer
			call this.m_questItems.pushBack(questItem)
			return this.m_questItems.backIndex()
		endmethod

		/// Friend relationship to \ref AQuestItem, do not use.
		public method removeQuestItemByIndex takes integer index returns nothing
			call this.m_questItems.erase(index)
		endmethod

		private method createQuestLogQuest takes nothing returns nothing
			if (thistype.m_useQuestLog) then
				set this.m_questLogQuest = CreateQuest()
				call QuestSetEnabled(this.m_questLogQuest, false)
				//call this.setQuestLogState(this.state()) // hide quest before setting state
				call QuestSetRequired(this.m_questLogQuest, this.isRequired())
			endif
		endmethod

		/// Friend relationship to \ref AQuestItem, do not use.
		public method reorderQuestItems takes nothing returns nothing
			local integer i
			if (thistype.m_useQuestLog) then
				call DestroyQuest(this.m_questLogQuest)
				set this.m_questLogQuest = null
				call this.createQuestLogQuest()
				call this.setQuestLogState(this.state())
				call QuestSetTitle(this.m_questLogQuest, this.title())
				call this.setIconPath(this.iconPath())
				call this.setDescription(this.description())
				set i = 0
				loop
					exitwhen (i == this.m_questItems.size())
					if (AQuestItem(this.m_questItems[i]).state() != thistype.stateNotUsed) then
						call AQuestItem(this.m_questItems[i]).createQuestItem()
					endif
					set i = i + 1
				endloop
			endif
		endmethod

		/**
		 * Creates a new quest with state \ref AAbstractQuest.stateNotUsed.
		 * \param character If this value is 0 quest is being created for all character owners.
		 * \param title If quest will also be created as \ref quest object this title will be assigned to it. The quest title is not dynamic.
		 */
		public static method create takes ACharacter character, string title returns thistype
			local thistype this = thistype.allocate(character, title)
			// dynamic members
			set this.m_questItems = AIntegerVector.create()
			set this.m_isRequired = this.character() == 0

			call this.createQuestLogQuest()

			return this
		endmethod

		private method destroyQuestLogQuest takes nothing returns nothing
			if (thistype.m_useQuestLog) then
				call DestroyQuest(this.m_questLogQuest)
				set this.m_questLogQuest = null
			endif
		endmethod

		// all quest items will be destroyed, too
		private method destroyQuestItems takes nothing returns nothing
			loop
				exitwhen (this.m_questItems.empty())
				call AQuestItem(this.m_questItems.back()).destroy()
			endloop
			call this.m_questItems.destroy()
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.destroyQuestLogQuest()
			call this.destroyQuestItems()
		endmethod

		/**
		 * \param useQuestLog If this value is true \ref quest objects will be created and assigned automatically to each instance of \ref AQuest.
		 * \param likeWarcraft If this value is true quest fail messages won't list all quest items and there will be a line break before all quest state messages.
		 * \param textListItem Text which is displayed in quest item list. Gets the quest item's modified title as formatting argument (%s).
		 * \sa AAbstractQuest.init
		 */
		public static method init0 takes boolean useQuestLog, boolean likeWarcraft, string updateSoundPath, string textQuestNew, string textQuestCompleted, string textQuestFailed, string textQuestUpdate, string textListItem returns nothing
			// static construction members
			set thistype.m_useQuestLog = useQuestLog
			set thistype.m_likeWarcraft = likeWarcraft
			set thistype.m_updateSoundPath = updateSoundPath
			set thistype.m_textQuestNew = textQuestNew
			set thistype.m_textQuestCompleted = textQuestCompleted
			set thistype.m_textQuestFailed = textQuestFailed
			set thistype.m_textQuestUpdate = textQuestUpdate
			set thistype.m_textListItem = textListItem
		endmethod

		// static construction members

		// AQuestItem need access
		public static method isQuestLogUsed takes nothing returns boolean
			return thistype.m_useQuestLog
		endmethod
	endstruct

endlibrary