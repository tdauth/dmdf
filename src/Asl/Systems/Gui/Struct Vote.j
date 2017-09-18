library AStructSystemsGuiVote requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, AStructCoreGeneralList, AStructCoreGeneralVector, ALibraryCoreGeneralPlayer, AStructCoreStringFormat, AStructSystemsGuiGui

	private struct AVoteChoice
		private string m_message
		private integer m_votes

		public method message takes nothing returns string
			return this.m_message
		endmethod

		public method vote takes nothing returns nothing
			set this.m_votes = this.m_votes + 1
		endmethod

		public method removeVote takes nothing returns nothing
			set this.m_votes = this.m_votes - 1
		endmethod

		public method votes takes nothing returns integer
			return this.m_votes
		endmethod

		public static method create takes string message returns thistype
			local thistype this = thistype.allocate()
			set this.m_message = message
			set this.m_votes = 0
			return this
		endmethod
	endstruct

	private struct AVotePlayer
		private player m_player
		private integer m_choice

		public method player takes nothing returns player
			return this.m_player
		endmethod

		public method vote takes integer choice returns nothing
			set this.m_choice = choice
		endmethod

		public method choice takes nothing returns integer
			return this.m_choice
		endmethod

		public static method create takes player whichPlayer returns thistype
			local thistype this = thistype.allocate()
			set this.m_player = whichPlayer
			set this.m_choice = -1
			return this
		endmethod
	endstruct

	/// \todo Should be contained by struct \ref AVote, vJass bug.
	function interface AVoteResultAction takes AVote vote returns nothing

	/**
	* \brief Provides simple vote functionality for players by using Warcraft III dialogs.
	* Players can be added and removed dynamically.
	* Use \ref setRecognizePlayerLeavings() to prevent endless votes when a player leaves the game.
	* The vote's result action can either be specified by using \ref setResultAction() and a custom function or by extending your custom struct by AVote and overwriting \ref onResult().
	* Votes has to be started by using \ref start().
	* \note There should always be only one running vote per player. Use \ref playerVote() to get a player's running vote and \ref runs() to check if the vote is running.
	*/
	struct AVote
		// static construction members
		private static real m_messageDuration
		private static string m_voteMessage
		private static string m_resultMessage
		// dynamic members
		private string m_message
		private AVoteResultAction m_resultAction
		private boolean m_recognizePlayerLeavings
		// members
		private boolean m_runs
		private AIntegerList m_players
		private AIntegerVector m_choices
		private trigger m_leaveTrigger

		//! runtextmacro A_STRUCT_DEBUG("\"AVote\"")

		// dynamic members

		public method setMessage takes string message returns nothing
			set this.m_message = message
		endmethod

		public method message takes nothing returns string
			return this.m_message
		endmethod

		public method setResultAction takes AVoteResultAction resultAction returns nothing
			set this.m_resultAction = resultAction
		endmethod

		public method resultAction takes nothing returns AVoteResultAction
			return this.m_resultAction
		endmethod

		public method recognizePlayerLeavings takes nothing returns boolean
			return this.m_recognizePlayerLeavings
		endmethod

		// members

		public method runs takes nothing returns boolean
			return this.m_runs
		endmethod

		// method

		public stub method onResult takes nothing returns nothing
			if (this.m_resultAction != 0) then
				call this.m_resultAction.execute(this)
			endif
		endmethod

		public method result takes nothing returns integer
			local integer result = 0
			local integer i = 1
			loop
				exitwhen (i == this.m_choices.size())
				if (AVoteChoice(this.m_choices[i]).votes() > AVoteChoice(this.m_choices[result]).votes()) then
					set result = i
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		private method player takes player whichPlayer returns AVotePlayer
			local AIntegerListIterator iterator = this.m_players.begin()
			local AVotePlayer result = 0
			loop
				exitwhen (not iterator.isValid())
				if (AVotePlayer(iterator.data()).player() == whichPlayer) then
					set result = AVotePlayer(iterator.data())
					exitwhen (true)
				endif
				call iterator.next()
			endloop
			call iterator.destroy()

			return result
		endmethod

		/**
		 * \return Returns the vote's result. If there isn't any yet it returns -1.
		 */
		public method addVote takes player whichPlayer, integer choice returns integer
			local AVotePlayer data = this.player(whichPlayer)
			local AIntegerListIterator iterator
			local integer result = 0
			if (data == 0 or choice < 0 or choice >= this.m_choices.size()) then
				return -1
			endif
			call AVoteChoice(this.m_choices[choice]).vote()
			call data.vote(choice)
			// show message
			set iterator = this.m_players.begin()
			loop
				exitwhen (not iterator.isValid())
				if (AVotePlayer(iterator.data()).player() != whichPlayer) then
					call DisplayTimedTextToPlayer(whichPlayer, 0.0, 0.0, thistype.m_messageDuration, Format(thistype.m_voteMessage).s(GetPlayerName(whichPlayer)).s(AVoteChoice(this.m_choices[choice]).message()).i(AVoteChoice(this.m_choices[choice]).votes()).result())
				endif
				if (AVotePlayer(iterator.data()).choice() == -1) then
					set result = -1
				endif
				call iterator.next()
			endloop
			call iterator.destroy()
			if (result == -1) then
				return -1
			endif
			set result = this.result()
			set iterator = this.m_players.begin()
			loop
				exitwhen (not iterator.isValid())
				call AHashTable.global().removeHandleInteger(AVotePlayer(iterator.data()).player(), A_HASHTABLE_KEY_VOTE)
				call DisplayTimedTextToPlayer(AVotePlayer(iterator.data()).player(), 0.0, 0.0, thistype.m_messageDuration, Format(thistype.m_resultMessage).s(AVoteChoice(this.m_choices[result]).message()).i(AVoteChoice(this.m_choices[result]).votes()).result())
				call iterator.next()
			endloop
			call iterator.destroy()
			call this.onResult()
			set this.m_runs = false
			return result
		endmethod

		/// \return Returns player's \p whichPlayer running vote. If there is no running vote for player whichPlayer it returns 0.
		public static method playerVote takes player whichPlayer returns thistype
			return AHashTable.global().handleInteger(whichPlayer, A_HASHTABLE_KEY_VOTE)
		endmethod

		private static method dialogButtonActionVote takes ADialogButton dialogButton returns nothing
			local thistype vote = thistype.playerVote(dialogButton.dialog().player())
			if (vote != 0) then
				call vote.addVote(dialogButton.dialog().player(), dialogButton.index())
			endif
		endmethod

		public method start takes nothing returns nothing
			local AIntegerListIterator iterator = this.m_players.begin()
			local integer j
			set this.m_runs = true
			loop
				exitwhen (not iterator.isValid())
				debug if (thistype.playerVote(AVotePlayer(iterator.data()).player()) != 0) then
					debug call this.print("Player " + GetPlayerName(AVotePlayer(iterator.data()).player()) + " does already have a running vote.")
				debug endif
				call AHashTable.global().setHandleInteger(AVotePlayer(iterator.data()).player(), A_HASHTABLE_KEY_VOTE, this)
				call AGui.playerGui(AVotePlayer(iterator.data()).player()).dialog().clear()
				call AGui.playerGui(AVotePlayer(iterator.data()).player()).dialog().setMessage(this.m_message)
				set j = 0
				loop
					exitwhen (j == this.m_choices.size())
					call AGui.playerGui(AVotePlayer(iterator.data()).player()).dialog().addDialogButton(AVoteChoice(this.m_choices[j]).message(), 0, thistype.dialogButtonActionVote)
					set j = j + 1
				endloop
				call AGui.playerGui(AVotePlayer(iterator.data()).player()).dialog().show()
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		public method addPlayer takes player whichPlayer returns nothing
			if (this.m_leaveTrigger != null) then
				call TriggerRegisterPlayerEvent(this.m_leaveTrigger, whichPlayer, EVENT_PLAYER_LEAVE)
			endif
			call this.m_players.pushBack(AVotePlayer.create(whichPlayer))
		endmethod

		public method addForce takes force whichForce returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (IsPlayerInForce(Player(i), whichForce)) then
					call this.addPlayer(Player(i))
				endif
				set i = i + 1
			endloop
		endmethod

		/// \todo Remove event, impossible.
		public method removePlayer takes player whichPlayer returns boolean
			local AVotePlayer data = this.player(whichPlayer)
			if (data != 0) then
				// if player has already voted, remove his vote
				if (data.choice() != -1) then
					call AVoteChoice(this.m_choices[data.choice()]).removeVote()
				endif
				call this.m_players.remove(data)
				call data.destroy()
				return true
			endif
			return false
		endmethod

		private static method triggerActionPlayerLeaves takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.removePlayer(GetTriggerPlayer())
		endmethod

		public method setRecognizePlayerLeavings takes boolean flag returns nothing
			local AIntegerListIterator iterator
			set this.m_recognizePlayerLeavings = flag
			if (flag and this.m_leaveTrigger == null) then
				set this.m_leaveTrigger = CreateTrigger()
				set iterator = this.m_players.begin()
				loop
					exitwhen (not iterator.isValid())
					call TriggerRegisterPlayerEvent(this.m_leaveTrigger, AVotePlayer(iterator.data()).player(), EVENT_PLAYER_LEAVE)
					call iterator.next()
				endloop
				call iterator.destroy()
				call TriggerAddAction(this.m_leaveTrigger, function thistype.triggerActionPlayerLeaves)
				call AHashTable.global().setHandleInteger(this.m_leaveTrigger, 0, this)
			elseif (not flag and this.m_leaveTrigger != null) then
				call AHashTable.global().destroyTrigger(this.m_leaveTrigger)
				set this.m_leaveTrigger = null
			endif
		endmethod

		/// \return Returns the choice player whichPlayer voted for. If player whichPlayer is not a member of the vote or he hasn't already voted yet it returns -1.
		public method playerChoice takes player whichPlayer returns integer
			local AVotePlayer data = this.player(whichPlayer)
			if (data == 0) then
				return -1
			endif
			return data.choice()
		endmethod

		public method addChoice takes string message returns integer
			call this.m_choices.pushBack(AVoteChoice.create(message))
			return this.m_choices.backIndex()
		endmethod

		public method choiceMessage takes integer choice returns string
			if (choice < 0 or choice >= this.m_choices.size()) then
				return null
			endif
			return AVoteChoice(this.m_choices[choice]).message()
		endmethod

		public method choiceVotes takes integer choice returns integer
			if (choice < 0 or choice >= this.m_choices.size()) then
				return 0
			endif
			return AVoteChoice(this.m_choices[choice]).votes()
		endmethod

		public static method create takes string message returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_message = message
			set this.m_resultAction = 0
			set this.m_recognizePlayerLeavings = false
			// members
			set this.m_runs = false
			set this.m_players = AIntegerVector.create()
			set this.m_choices = AIntegerVector.create()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			local AIntegerListIterator iterator
			if (this.m_runs) then
				set iterator = this.m_players.begin()
				loop
					exitwhen (not iterator.isValid())
					call AHashTable.global().removeHandleInteger(AVotePlayer(iterator.data()).player(), A_HASHTABLE_KEY_VOTE)
					call iterator.next()
				endloop
				call iterator.destroy()
			endif
			// dynamic members
			if (this.m_leaveTrigger != null) then
				call AHashTable.global().destroyTrigger(this.m_leaveTrigger)
				set this.m_leaveTrigger = null
			endif
			// members
			//! runtextmacro A_DESTROY("this.m_players", "AVotePlayer")
			//! runtextmacro A_DESTROY("this.m_choices", "AVoteChoice")
		endmethod

		/**
		 * \param voteMessage Arguments are: player name (string), choice name (string) and choice votes (integer).
		 * \param resultMessage Arguments are:  choice name (string) and choice votes (integer).
		 */
		public static method init takes real messageDuration, string voteMessage, string resultMessage returns nothing
			// static construction members
			set thistype.m_messageDuration = messageDuration
			set thistype.m_voteMessage = voteMessage
			set thistype.m_resultMessage = resultMessage
		endmethod
	endstruct

endlibrary