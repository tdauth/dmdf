library AStructSystemsCharacterVideo requires optional ALibraryCoreDebugMisc, AStructCoreGeneralVector, ALibraryCoreGeneralPlayer, ALibraryCoreGeneralUnit, ALibraryCoreInterfaceCinematic, AStructCoreInterfacePlayerSelection, ALibraryCoreInterfaceMisc, ALibraryCoreStringConversion, AStructSystemsCharacterCharacter, AStructSystemsCharacterTalk

	/**
	 * \brief Interface for all unit based actor data.
	 *
	 * Allows restoring from the video sequence as well as access to the stored actor.
	 */
	private interface AActorInterface
		/**
		 * Restores the original unit and destroys or hides the actor unit.
		 */
		public method restore takes nothing returns nothing
		public method restoreOnActorsLocation takes nothing returns nothing
		/**
		 * Refreshes the actor unit which means copying as much data as possible from the original unit.
		 */
		public method refresh takes nothing returns nothing
		/**
		 * \return Returns the actor unit.
		 */
		public method actor takes nothing returns unit
	endinterface

	/**
	 * \brief This struct stores a copy of an existing unit which is used as actor in a video.
	 *
	 * \sa AUnitTypeActorData
	 */
	private struct AActorData extends AActorInterface
		// construction members
		private AVideo m_video
		private unit m_unit
		// members
		private unit m_actor

		// construction members

		public method unit takes nothing returns unit
			return this.m_unit
		endmethod

		// members

		public method actor takes nothing returns unit
			return this.m_actor
		endmethod

		// methods

		public method restore takes nothing returns nothing
			call AHashTable.global().destroyUnit(this.m_actor)
			set this.m_actor = null
			call ShowUnit(this.m_unit, true)
		endmethod

		public method restoreOnActorsLocation takes nothing returns nothing
			call SetUnitX(this.m_unit, GetUnitX(this.m_actor))
			call SetUnitY(this.m_unit, GetUnitY(this.m_actor))
			call SetUnitFacing(this.m_unit, GetUnitFacing(this.m_actor))
			call this.restore()
		endmethod

		public method refresh takes nothing returns nothing
			local ACharacter character = ACharacter.getCharacterByUnit(this.unit())
			local integer i
			local item whichItem
			if (this.m_actor != null) then
				call AHashTable.global().destroyUnit(this.m_actor)
				set this.m_actor = null
			endif
			set this.m_actor = CopyUnit(this.unit(), GetUnitX(this.unit()), GetUnitY(this.unit()), GetUnitFacing(this.unit()), bj_UNIT_STATE_METHOD_MAXIMUM)
			call AHashTable.global().setHandleInteger(this.m_actor, A_HASHTABLE_KEY_ACTOR, this)
			call PauseUnit(this.m_actor, false) // unpause before adding items!
			// remove copied items of backpack and add equipment
			// TODO would be better performance when not copying items in CopyUnit in case backpack is displayed
			// only show equipment if equipment is enabled, not if only backpack is enabled and not if inventory has been disabled completely
			if (character != 0 and character.characterInventory() != 0 and character.inventory() != 0 and character.inventory().backpackIsEnabled() and not character.inventory().onlyBackpackIsEnabled() and ((character.isMovable() and character.characterInventory().isEnabled()) or (not character.isMovable() and character.characterInventory().enableAgain()))) then
				set i = 0
				loop
					exitwhen (i == AUnitInventory.maxEquipmentTypes)
					set whichItem = UnitItemInSlot(this.m_actor, i)
					if (whichItem != null) then
						call RemoveItem(whichItem)
						set whichItem = null
					endif
					if (character.inventory().equipmentItemData(i) != 0) then
						if (UnitAddItemToSlotById(this.m_actor, character.inventory().equipmentItemData(i).itemTypeId(), i)) then
							set whichItem = UnitItemInSlot(this.m_actor, i)
							call character.inventory().equipmentItemData(i).assignToItem(whichItem)
						debug else
							debug call Print("Error when copying equipment item of character " + I2S(character) + " of equipment type " + I2S(i) + ".")
						endif
					endif
					set i = i + 1
				endloop
			endif
			if (this.m_video.actorOwner.evaluate() != null) then
				call SetUnitOwner(this.m_actor, this.m_video.actorOwner.evaluate(), false) // set passive owner so unit won't attack or be attacked but still use the color
			endif
			call ShowUnit(this.m_actor, true)

			call SelectUnit(this.m_actor, false)
			call SetUnitInvulnerable(this.m_actor, true)
			call IssueImmediateOrder(this.m_actor, "stop") // cancel orders.
			call IssueImmediateOrder(this.m_actor, "halt") // make sure it runs not away
		endmethod

		public static method create takes AVideo video, unit oldUnit returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_video = video
			call ShowUnit(oldUnit, false)
			set this.m_unit = oldUnit
			// members
			call this.refresh()
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// construction members
			set this.m_unit = null
			// members
			if (this.m_actor != null) then
				call AHashTable.global().destroyUnit(this.m_actor)
				set this.m_actor = null
			endif
		endmethod
	endstruct

	/**
	 * \brief This struct stores a unit which is only used during a video sequence and removed afterwards.
	 * Use this struct whenever units should newly be created for videos and not made by copies.
	 * \sa AActorData
	 */
	private struct AUnitTypeActorData extends AActorInterface
		// construction members
		private player m_owner
		private integer m_unitTypeId
		private real m_x
		private real m_y
		private real m_face
		// members
		private unit m_actor

		// construction members

		public method owner takes nothing returns player
			return this.m_owner
		endmethod

		public method unitTypeId takes nothing returns integer
			return this.m_unitTypeId
		endmethod

		public method x takes nothing returns real
			return this.m_x
		endmethod

		public method y takes nothing returns real
			return this.m_y
		endmethod

		public method face takes nothing returns real
			return this.m_face
		endmethod

		// members

		public method actor takes nothing returns unit
			return this.m_actor
		endmethod

		// methods

		public method restore takes nothing returns nothing
			call AHashTable.global().destroyUnit(this.m_actor)
			set this.m_actor = null
		endmethod

		public method restoreOnActorsLocation takes nothing returns nothing
			call this.restore()
		endmethod

		public method refresh takes nothing returns nothing
			if (this.m_actor != null) then
				call AHashTable.global().destroyUnit(this.m_actor)
				set this.m_actor = null
			endif
			set this.m_actor = CreateUnit(this.owner(), this.unitTypeId(), this.x(), this.y(), this.face())
			call AHashTable.global().setHandleInteger(this.m_actor, A_HASHTABLE_KEY_ACTOR, this)
			call SetUnitInvulnerable(this.m_actor, true)
			call IssueImmediateOrder(this.m_actor, "stop") // cancel orders.
			call IssueImmediateOrder(this.m_actor, "halt") // make sure it runs not away
		endmethod

		public static method create takes player owner, integer unitTypeId, real x, real y, real face returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_owner = owner
			set this.m_unitTypeId = unitTypeId
			set this.m_x = x
			set this.m_y = y
			set this.m_face = face
			// members
			call this.refresh()
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// construction members
			set this.m_owner = null
			// members
			if (this.m_actor != null) then
				call AHashTable.global().destroyUnit(this.m_actor)
				set this.m_actor = null
			endif
		endmethod
	endstruct

	/**
	 * \brief Stores all visible player data which has to be hidden during a video.
	 */
	private struct AVideoPlayerData
		private player m_player
		private APlayerSelection m_selection
		private leaderboard m_leaderboard
		private boolean m_hadDialog

		public method store takes nothing returns nothing
			if (this.m_selection != 0) then
				call this.m_selection.destroy()
			endif
			set this.m_selection = APlayerSelection.create(this.m_player)
			call this.m_selection.store()
			set this.m_leaderboard = PlayerGetLeaderboard(this.m_player)
			if (this.m_leaderboard != null) then
				call ShowLeaderboardForPlayer(this.m_player, this.m_leaderboard, false)
			endif
			if (AGui.playerGui(this.m_player).dialog().isDisplayed()) then
				set this.m_hadDialog = true
				call AGui.playerGui(this.m_player).dialog().hide()
			else
				set this.m_hadDialog = false
			endif
		endmethod

		public method restore takes nothing returns nothing
			if (this.m_selection != 0) then
				call this.m_selection.restore()
			endif
			/*
			FIXME The player's leaderboard is never null even when it has been hidden and destroyed!
			if (this.m_leaderboard != null) then
				call ShowLeaderboardForPlayer(this.m_player, this.m_leaderboard, true)
			endif
			*/
			if (this.m_hadDialog) then
				call AGui.playerGui(this.m_player).dialog().show()
			endif
		endmethod

		public static method create takes player whichPlayer returns thistype
			local thistype this = thistype.allocate()
			set this.m_player = whichPlayer
			set this.m_selection = 0
			set this.m_hadDialog = false

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			if (this.m_selection != 0) then
				call this.m_selection.destroy()
			endif
		endmethod
	endstruct

	/**
	* Stores all necessary character data which has to be restored after video.
	*/
	private struct AVideoCharacterData
		// construction members
		private ACharacter m_character
		// members
		private boolean m_isMovable

		public method store takes nothing returns nothing
			set this.m_isMovable = this.m_character.isMovable()
		endmethod

		public method restore takes nothing returns nothing
			if (this.m_character.isMovable() != this.m_isMovable) then
				call this.m_character.setMovable(this.m_isMovable)
			endif
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate()
			set this.m_character = character

			return this
		endmethod
	endstruct

	/// \todo Should be a part of \ref AVideo, vJass bug.
	function interface AVideoAction takes AVideo video returns nothing

	/**
	 * Provides access to a global video. Global means that the video is played/shown for all character owners.
	 * The ASL character system doesn't support local videos which means videos for each single character owner.
	 * Videos can have initialization, play and stop actions which has to be defined as function interface functions.
	 * Additionally there is a method called \ref thistype.actor() which gives user access to an almost exact copy of the "first character".
	 * The first character is always the character of first player in list which still is online. List is starting with player 1 (id 0).
	 * Since you don't use character units (beside the copied one) they will be hidden in video initialization.
	 * Besides all units will be paused so you have to unpause a unit if you want to give orders (like move) to it.
	 * Videos can be skipped by pressing a user-defined key. If at least half of players want to skip a video (have pressed that key) it will be skipped.
	 * \sa wait(), waitForVideo(), waitForCondition(), AVideoAction, AVideoCondition
	 */
	struct AVideo
		// static construction members
		private static string m_textPlayerSkips
		private static string m_textSkip
		// static members
		private static thistype m_runningVideo /// Do not access.
		private static sound m_playedSound
		private static boolean m_skipped
		private static integer m_skippingPlayers
		private static boolean array m_playerHasSkipped[12] /// \todo \ref bj_MAX_PLAYERS
		private static trigger m_skipTrigger
		/**
		 * Whenever a player leaves the game the number of skipping players has to be recalculated.
		 */
		private static trigger m_leaveTrigger
		private static AVideoPlayerData array m_playerData[12] /// \todo \ref bj_MAX_PLAYERS
		private static AVideoCharacterData array m_playerCharacterData[12] /// \todo \ref bj_MAX_PLAYERS
		private static real m_timeOfDay
		// dynamic members
		private player m_actorOwner
		private boolean m_hasCharacterActor
		private AVideoAction m_initAction
		private AVideoAction m_playAction
		private AVideoAction m_stopAction
		private AVideoAction m_skipAction
		private boolean m_fadeIn
		private real m_playFilterTime
		private real m_stopFilterTime
		private real m_skipFilterTime
		// members
		/// A copy of the first player character.
		private AActorData m_actor
		/// Vector of \ref AActorInterface instances.
		private AIntegerVector m_actors

		//! runtextmacro optional A_STRUCT_DEBUG("\"AVideo\"")

		// dynamic members

		/**
		 * Sets the owner of all unit actors which are copies of actual owners.
		 * This helps preventing fights between hostile units in videos.
		 * \param owner If this value is null the owner won't be changed at all.
		 */
		public method setActorOwner takes player owner returns nothing
			set this.m_actorOwner = owner
		endmethod

		public method actorOwner takes nothing returns player
			return this.m_actorOwner
		endmethod

		public method setHasCharacterActor takes boolean hasCharacterActor returns nothing
			set this.m_hasCharacterActor = hasCharacterActor
		endmethod

		public method hasCharacterActor takes nothing returns boolean
			return this.m_hasCharacterActor
		endmethod

		/**
		 * The init action is called using .evaluate() in \ref onInitAction() by default
		 * to initialize the video which is about the being played.
		 * The init action is evaluated when the black screen faded in.
		 * @{
		 */
		public method setInitAction takes AVideoAction initAction returns nothing
			set this.m_initAction = initAction
		endmethod

		public method initAction takes nothing returns AVideoAction
			return this.m_initAction
		endmethod
		/**
		 @}
		 */

		/**
		 * The play action is called using .execute() in \ref onPlayAction() by default.
		 * It is called after the black screen faded out and the video starts.
		 * @{
		 */
		public method setPlayAction takes AVideoAction playAction returns nothing
			set this.m_playAction = playAction
		endmethod

		public method playAction takes nothing returns AVideoAction
			return this.m_playAction
		endmethod
		/**
		 * @}
		 */

		public method setStopAction takes AVideoAction stopAction returns nothing
			set this.m_stopAction = stopAction
		endmethod

		public method stopAction takes nothing returns AVideoAction
			return this.m_stopAction
		endmethod

		public method setSkipAction takes AVideoAction skipAction returns nothing
			set this.m_skipAction = skipAction
		endmethod

		public method skipAction takes nothing returns AVideoAction
			return this.m_skipAction
		endmethod

		/**
		 * \param fadeIn If this value is true, black masked will be removed automatically when video is started. Otherwise, it will remain for manual removal.
		 * \note Default value is true.
		 */
		public method setFadeIn takes boolean fadeIn returns nothing
			set this.m_fadeIn = fadeIn
		endmethod

		public method fadeIn takes nothing returns boolean
			return this.m_fadeIn
		endmethod

		public method checkFilterTime takes real time, string name returns nothing
			/*
			TODO Causes a bug, the function call is stopped here.
			debug if (time < bj_CINEMODE_INTERFACEFADE) then
				debug call this.staticPrint(name + " filter time should be equal to or bigger than bj_CINEMODE_INTERFACEFADE (" + R2S(bj_CINEMODE_INTERFACEFADE) + " but it has value " + R2S(time) + ".")
			debug endif
			*/
		endmethod

		public method setPlayFilterTime takes real time returns nothing
			set this.m_playFilterTime = time
			debug call this.checkFilterTime(time, "play")
		endmethod

		public method playFilterTime takes nothing returns real
			return this.m_playFilterTime
		endmethod

		public method setStopFilterTime takes real time returns nothing
			set this.m_stopFilterTime = time
			debug call this.checkFilterTime(time, "stop")
		endmethod

		public method stopFilterTime takes nothing returns real
			return this.m_stopFilterTime
		endmethod

		public method setSkipFilterTime takes real time returns nothing
			set this.m_skipFilterTime = time
			debug call this.checkFilterTime(time, "skip")
		endmethod

		public method skipFilterTime takes nothing returns real
			return this.m_skipFilterTime
		endmethod

		// methods

		private static method savePlayerData takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (IsPlayerPlayingUser(Player(i))) then
					if (thistype.m_playerData[i] == 0) then
						set thistype.m_playerData[i] = AVideoPlayerData.create(Player(i))
					endif
					call thistype.m_playerData[i].store()
				endif
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					if (thistype.m_playerCharacterData[i] == 0) then
						set thistype.m_playerCharacterData[i] = AVideoCharacterData.create(ACharacter.playerCharacter(Player(i)))
					endif
					call thistype.m_playerCharacterData[i].store()
				endif
				set i = i + 1
			endloop
		endmethod

		private static method restorePlayerData takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (thistype.m_playerData[i] != 0) then
					call thistype.m_playerData[i].restore()
				endif
				if (thistype.m_playerCharacterData[i] != 0) then
					if (ACharacter.playerCharacter(Player(i)) != 0) then
						call thistype.m_playerCharacterData[i].restore()
					endif
				endif
				set i = i + 1
			endloop
		endmethod

		/**
		 * Overwrite this method to implement code which is run when the video is started during the black fade.
		 * Called by .evaluate().
		 */
		public stub method onInitAction takes nothing returns nothing
			if (this.m_initAction != 0) then
				call this.m_initAction.evaluate(this) // evaluate since it is called between fading
			endif
		endmethod

		/**
		 * Called by .execute().
		 */
		public stub method onPlayAction takes nothing returns nothing
			if (this.m_playAction != 0) then
				call this.m_playAction.execute(this) // execute since we need to be able to use TriggerSleepAction calls (stop has to be called in this function)
			endif
		endmethod

		/**
		 * Called by .evaluate() when the video is being stopped (skipped or ended normally).
		 * It is called AFTER the units have been unpaused and all player and character data has been restored successfully.
		 * After this method the cinematic fade is done and the running video is finally set to 0.
		 */
		public stub method onStopAction takes nothing returns nothing
			if (this.m_stopAction != 0) then
				call this.m_stopAction.evaluate(this) // evaluate since it is called between fading
			endif
		endmethod

		/**
		 * Called by .evaluate() when the video is being skipped.
		 * .evaluates() the skip action by default.
		 * This is called immediately before \ref stop() is called.
		 */
		public stub method onSkipAction takes nothing returns nothing
			if (this.m_skipAction != 0) then
				call this.m_skipAction.evaluate(this) // evaluate since it is called before stop action
			endif
		endmethod

		/**
		 * \return Returns the first character's actor.
		 * \note \ref hasCharacterActor() must return true for the current video if you use this method.
		 */
		public method actor takes nothing returns unit
			debug if (thistype.m_runningVideo == 0) then
				debug call thistype.staticPrint("Running video is 0.")
			debug endif

			return this.m_actor.actor()
		endmethod

		/**
		 * Stores an actor for unit \p actor and returns the corresponding internal index.
		 *
		 * \return Returns the internal index which can be used for further treatment.
		 * \note If you want to create a newly actor based on a unit type use \ref createUnitActor().
		 * \note Use \ref unitActor() to get the corresponding created unit.
		 */
		public method saveUnitActor takes unit actor returns integer
			local AActorData data = AActorData.create(this, actor)
			call this.m_actors.pushBack(data)
			return this.m_actors.backIndex()
		endmethod

		/**
		 * Creates a newly actor unit based on a unit type rather than an existing unit.
		 * \return Returns the corresponding internal index of the created unit actor.
		 * \note Use \ref unitActor() to get the corresponding created unit.
		 */
		public method createUnitActor takes player owner, integer unitTypeId, real x, real y, real face returns integer
			local AUnitTypeActorData data = AUnitTypeActorData.create(owner, unitTypeId, x, y, face)
			call this.m_actors.pushBack(data)
			return this.m_actors.backIndex()
		endmethod

		public method createUnitActorAtLocation takes player owner, integer unitTypeId, location whichLocation, real face returns integer
			return this.createUnitActor(owner, unitTypeId, GetLocationX(whichLocation), GetLocationY(whichLocation), face)
		endmethod

		public method createUnitActorAtRect takes player owner, integer unitTypeId, rect whichRect, real face returns integer
			return this.createUnitActor(owner, unitTypeId, GetRectCenterX(whichRect), GetRectCenterY(whichRect), face)
		endmethod

		/**
		 * Returns the created actor unit for the video based on the internal index.
		 * \param index The internal index of the unit actor.
		 */
		public method unitActor takes integer index returns unit
			// TEST
			debug if (AActorInterface(this.m_actors[index]).actor() == null) then
			debug call Print("Unit actor " + I2S(index) + " is null")
			debug endif
			return AActorInterface(this.m_actors[index]).actor()
		endmethod

		public method restoreUnitActor takes integer index returns nothing
			call AActorInterface(this.m_actors[index]).restore()
			call AActorInterface(this.m_actors[index]).destroy()
			call this.m_actors.erase(index)
		endmethod

		public method restoreUnitActorOnActorLocation takes integer index returns nothing
			call AActorInterface(this.m_actors[index]).restoreOnActorsLocation()
			call AActorInterface(this.m_actors[index]).destroy()
			call this.m_actors.erase(index)
		endmethod

		/**
		 * Restores all stored unit actors.
		 * This method is called automatically when the video is being stopped.
		 */
		public method restoreUnitActors takes nothing returns nothing
			debug call Print("Restoring " + I2S(this.m_actors.size()) + " unit actors.")
			loop
				exitwhen (this.m_actors.empty())
				call this.restoreUnitActor(this.m_actors.backIndex())
			endloop
		endmethod

		public method restoreUnitActorsOnActorsLocations takes nothing returns nothing
			loop
				exitwhen (this.m_actors.empty())
				call this.restoreUnitActorOnActorLocation(this.m_actors.backIndex())
			endloop
		endmethod

		public method setActorsMoveSpeed takes real moveSpeed returns nothing
			local integer i = 0
			call SetUnitMoveSpeed(this.actor(), moveSpeed)
			loop
				exitwhen (i == this.m_actors.size())
				call SetUnitMoveSpeed(AActorInterface(this.m_actors[i]).actor(), moveSpeed)
				set i = i + 1
			endloop
		endmethod

		public method setActorsOwner takes player owner returns nothing
			local integer i = 0
			call SetUnitOwner(this.actor(), owner, true)
			loop
				exitwhen (i == this.m_actors.size())
				call SetUnitOwner(AActorInterface(this.m_actors[i]).actor(), owner, true)
				set i = i + 1
			endloop
		endmethod

		public static method resetSkippingPlayers takes nothing returns nothing
			local integer i
			set thistype.m_skippingPlayers = 0
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set thistype.m_playerHasSkipped[i] = false
				set i = i + 1
			endloop
		endmethod

		/**
		 * In addition to the usual game properties which are stored and restored by function CinematicModeExBJ the following things will be stored by this method and restored by AVideo.stop:
		 * <ul>
		 * <li>if any dialog was shown to a player</li>
		 * <li>player selection</li>
		 * <li>character movability</li>
		 * <li>time of day</li>
		 * </ul>
		 * \sa CinematicModeExBJ()
		 */
		public method play takes nothing returns nothing
			debug if (thistype.m_runningVideo != 0) then
				debug call this.print("Another Video is already being run.")
				debug return
			debug endif
			set thistype.m_playedSound = null
			set thistype.m_skipped = false
			call thistype.resetSkippingPlayers()
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, this.playFilterTime(), "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call TriggerSleepAction(this.playFilterTime())
			/// \todo disable experience gain of all characters?
			call thistype.savePlayerData()
			set thistype.m_timeOfDay = GetTimeOfDay()
			call ATalk.hideAllEffects()
			call ClearSelection()
			call ACharacter.setAllMovable(false)
			call ACharacter.showAll(false)
			call PauseAllUnits(true)
			/*
			 * Refresh the character's actor if the video requires one.
			 */
			if (this.hasCharacterActor()) then
				debug call this.print("Has character actor")
				if (this.m_actor == 0) then
					debug call this.print("is 0 so create one")
					if (ACharacter.getFirstCharacter() != 0) then
						set this.m_actor = AActorData.create(this, ACharacter.getFirstCharacter().unit())
					debug else
						debug call this.print("There is no character for the video.")
					endif
				endif

				call this.m_actor.refresh()
			endif
			call SetCameraBoundsToRect(bj_mapInitialPlayableArea) // for all players
			call CinematicModeBJ(true, GetPlayersAll())
			set thistype.m_runningVideo = this
			call this.onInitAction.evaluate()
			if (this.fadeIn()) then
				call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, this.playFilterTime(), "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			endif
			call TriggerSleepAction(this.playFilterTime())
			call EnableTrigger(thistype.m_skipTrigger)
			call this.onPlayAction.execute() // execute since we need to be able to use TriggerSleepAction calls (stop method has to be called in this method)
		endmethod

		/**
		 * Stops the video and does the following things:
		 * <ul>
		 * <li>fades out and disables cinematic mode</li>
		 * <li>resets game camera</li>
		 * <li>enables all \ref ATalk effects again</li>
		 * <li>restores all actors automatically</li>
		 * <li>unpauses all units which have not been paused before</li>
		 * <li>restores time of day</li>
		 * <li>restores player data (selection, leaderboard and dialog visibility)</li>
		 * <li>calls \ref onStopAction() with .evaluate()</li>
		 * </ul>
		 * \param fadeOut If this value is true this method is called without any fade out before.
		 * \note You have to call this method at the end of your video play action.
		 * \note Since there is an execution of the action, TriggerSleepAction functions will be ignored, so this method could not be called by the play method.
		 */
		private method doStop takes real filterTime, boolean fadeOut returns nothing
			debug if (thistype.m_runningVideo != this) then
				debug call this.print("Video is not being run.")
				debug return
			debug endif
			call DisableTrigger(thistype.m_skipTrigger)
			call DisableTrigger(thistype.m_leaveTrigger)

			if (fadeOut) then
				call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, filterTime, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			endif

			call TriggerSleepAction(filterTime)

			/*
			 * Cleanup.
			 */
			 // start with new OpLimit
			call ForForce(bj_FORCE_PLAYER[0], function ATalk.showAllEffects)
			call ResetToGameCamera(0.0)
			if (this.hasCharacterActor()) then
				if (this.m_actor != 0) then
					debug call Print("Restoring actor")
					call this.m_actor.restore()
					call this.m_actor.destroy()
					set this.m_actor = 0
				debug else
					debug call this.print("Missing character actor.")
				endif
			endif
			// make sure all actors are restored before unpausing and restoring player selection
			call this.restoreUnitActors()
			call ACharacter.showAll(true)
			call PauseAllUnits(false)
			// make sure data is already restored when calling the on stop action
			// otherwise characters are being set unmovable etc. after onStopAction() is called
			call thistype.restorePlayerData()
			call SetTimeOfDay(thistype.m_timeOfDay)
			call this.onStopAction.evaluate()
			call CinematicModeBJ(false, GetPlayersAll())
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, filterTime, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call TriggerSleepAction(filterTime)
			set thistype.m_runningVideo = 0
			// No camera pan! Call it manually, please.
		endmethod

		/**
		 * Stops the video.
		 * This method has to be called at the end of every \ref onPlayAction() call.
		 */
		public method stop takes nothing returns nothing
			call this.doStop(this.stopFilterTime(), true)
		endmethod

		/**
		 * Skips the video immediately which means the cinematic scene is ended and the sound is stopped if \ref transmissionFromUnitType() had been used.
		 * This means that \ref onSkipAction() is called by .evaluate() and afterwards \ref stop() is called.
		 * Besides it displays a message that the video has been skipped (useful in multiplayer games).
		 */
		public method skip takes nothing returns nothing
			local boolean firstStop = not thistype.m_skipped
			if (thistype.m_runningVideo != this) then
				debug call this.print("Video is not being run.")
				return
			endif
			debug if (firstStop) then
				debug call this.print("Warning: Video is skipped manually and not by players.")
			debug endif
			if (thistype.m_playedSound != null) then
				call StopSound(thistype.m_playedSound, false, false)
				set thistype.m_playedSound = null
			endif
			// cancel sound
			debug call Print("Cancel sound " + I2S(GetHandleId(bj_cineSceneLastSound)))
			call CancelCineSceneBJ()
			/*
			 * Reset the number of skipping players.
			 */
			set thistype.m_skipped = true
			call thistype.resetSkippingPlayers()
			if (firstStop) then
				call DisableTrigger(thistype.m_skipTrigger) // do not allow skipping at twice!
				call DisableTrigger(thistype.m_leaveTrigger)
			endif
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, thistype.m_textSkip)
			call this.onSkipAction.evaluate()

			call this.doStop(this.skipFilterTime(), firstStop)
		endmethod

		/**
		 * This method is called every time a player attempts to skip the video. It is called with .evaluate().
		 * It returns whether the video is actually being skipped or not.
		 * You can overwrite this method in your custom derived structure to avoid this default behaviour.
		 * Usually there must be at least playing players / divident of playing players who want to skip the video so that it will be skipped.
		 * \param skipablePlayers The number of players controlled by humans.
		 * \return Returns true if the video actually will be skipped.
		 * \todo If a player leaves the game who should have skipped the video or all players leave the game who did not skip what happens? Store the number of skips!
		 */
		public stub method onSkipCondition takes integer skipablePlayers returns boolean
			return thistype.m_skippingPlayers >= skipablePlayers / 2 + ModuloInteger(skipablePlayers, 2)
		endmethod

		/**
		 * Creates a new video sequence which can be played to all players at the same time.
		 * \param hasCharacterActor If this value is true, \ref actor() will be available during the video sequence. Otherwise the character will simply be hidden.
		 */
		public static method create takes boolean hasCharacterActor returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_actorOwner = Player(PLAYER_NEUTRAL_PASSIVE) // with this player they won't attack anyone BUT will return to their location (creep bug)
			set this.m_hasCharacterActor = hasCharacterActor
			set this.m_initAction = 0
			set this.m_playAction = 0
			set this.m_stopAction = 0
			set this.m_skipAction = 0
			set this.m_fadeIn = true
			set this.m_playFilterTime = 1.0
			set this.m_stopFilterTime = 1.0
			set this.m_skipFilterTime = 0.50
			// members
			set this.m_actor = 0
			set this.m_actors = AIntegerVector.create()

			debug call this.checkFilterTime(this.m_playFilterTime, "play")
			debug call this.checkFilterTime(this.m_stopFilterTime, "stop")
			debug call this.checkFilterTime(this.m_skipFilterTime, "skip")

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			if (this.m_actor != 0) then
				call this.m_actor.destroy()
			endif

			loop
				exitwhen (this.m_actors.empty())
				call AActorInterface(this.m_actors.back()).destroy()
				call this.m_actors.popBack()
			endloop
			call this.m_actors.destroy()
		endmethod

		/**
		 * Checks the number of skipable players (all playing human players) and runs \ref onSkipCondition() with that number.
		 * If it returns true it prepares the skip of the video setting \ref thistype.m_skipped to true and fading to black.
		 * The actual skip is done in the corresponding wait method of the video.
		 */
		private method checkForSkip takes nothing returns boolean
			local integer skipablePlayers = 0
			// recalculate every time since players could have left the game by now
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (IsPlayerPlayingUser(Player(i))) then
					set skipablePlayers = skipablePlayers + 1
				endif
				set i = i + 1
			endloop

			if (this.onSkipCondition.evaluate(skipablePlayers)) then
				debug call Print("Skipping video: " + I2S(this))
				/*
				 * skip() must be called in any wait action or in the action of the video itself.
				 * If you skip the video immediately here it might run further since it did not recognize itself that it has been skipped.
				 */
				call thistype.resetSkippingPlayers()
				set thistype.m_skipped = true

				/*
				 * These things must be done immediately.
				 */
				call CancelCineSceneBJ()
				call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, this.skipFilterTime(), "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)

				return true
			endif

			return false
		endmethod

		/**
		 * Increases the number of skips and calls \ref onSkipCondition() with the number of skipable players (all playing humans).
		 * If the method returns true the video is being skipped.
		 * \return Returns true if the video is skipped. Otherwise it returns false.
		 * \note This method can only be called once during a video for each player. Called a second time it won't have any effect and simply return false.
		 */
		public static method playerSkips takes player whichPlayer returns boolean
			local thistype this = thistype.m_runningVideo

			if (thistype.m_runningVideo == 0 or thistype.m_skipped) then
				return false
			endif

			if (thistype.m_playerHasSkipped[GetPlayerId(whichPlayer)]) then
				return false
			endif

			set thistype.m_playerHasSkipped[GetPlayerId(whichPlayer)] = true
			set thistype.m_skippingPlayers = thistype.m_skippingPlayers + 1
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, StringArg(thistype.m_textPlayerSkips, GetPlayerName(whichPlayer)))

			return this.checkForSkip()
		endmethod

		public static method transmissionFromUnitType takes integer unitType, player owner, string name, string text, sound playedSound returns nothing
			set thistype.m_playedSound = playedSound
			call TransmissionFromUnitType(unitType, owner, name, text, playedSound)
		endmethod

		public static method transmissionFromUnit takes unit whichUnit, string text, sound playedSound returns nothing
			set thistype.m_playedSound = playedSound
			call TransmissionFromUnit(whichUnit, text, playedSound)
		endmethod

		public static method transmissionFromUnitWithName takes unit whichUnit, string name, string text, sound playedSound returns nothing
			set thistype.m_playedSound = playedSound
			call TransmissionFromUnitWithName(whichUnit, name, text, playedSound)
		endmethod

		private static method triggerConditionVideoIsRunning takes nothing returns boolean
			return thistype.m_runningVideo != 0
		endmethod

		private static method triggerActionSkip takes nothing returns nothing
			call thistype.playerSkips(GetTriggerPlayer())
		endmethod

		private static method createSkipTrigger takes nothing returns nothing
			local integer i
			set thistype.m_skipTrigger = CreateTrigger()
			call DisableTrigger(thistype.m_skipTrigger) //will be enabled by first running video
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (IsPlayerPlayingUser(Player(i))) then
					call TriggerRegisterKeyEventForPlayer(Player(i), thistype.m_skipTrigger, AKeyEscape, true) //important: If it is the escape key it is the same key as in the character selection.
				endif
				set i = i + 1
			endloop
			call TriggerAddCondition(thistype.m_skipTrigger, Condition(function thistype.triggerConditionVideoIsRunning))
			call TriggerAddAction(thistype.m_skipTrigger, function thistype.triggerActionSkip)
		endmethod

		private static method triggerActionLeave takes nothing returns nothing
			local thistype this = thistype.m_runningVideo
			// recalculate skipping players and skip if there is a majority.
			if (thistype.m_playerHasSkipped[GetPlayerId(GetTriggerPlayer())]) then
				set thistype.m_skippingPlayers = thistype.m_skippingPlayers - 1
			endif

			call this.checkForSkip()
		endmethod

		private static method createLeaveTrigger takes nothing returns nothing
			local integer i
			set thistype.m_leaveTrigger = CreateTrigger()
			call DisableTrigger(thistype.m_leaveTrigger)
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (IsPlayerPlayingUser(Player(i))) then
					call TriggerRegisterPlayerEvent(thistype.m_leaveTrigger, Player(i), EVENT_PLAYER_LEAVE)
				endif
				set i = i + 1
			endloop
			call TriggerAddCondition(thistype.m_leaveTrigger, Condition(function thistype.triggerConditionVideoIsRunning))
			call TriggerAddAction(thistype.m_leaveTrigger, function thistype.triggerActionLeave)
		endmethod

		public static method init takes string textPlayerSkips, string textSkip returns nothing
			local integer i
			// static construction members
			set thistype.m_textPlayerSkips = textPlayerSkips
			set thistype.m_textSkip = textSkip
			// static members
			set thistype.m_playedSound = null
			set thistype.m_runningVideo = 0
			set thistype.m_skipped = false
			set thistype.m_skippingPlayers = 0
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set thistype.m_playerData[i] = 0
				set thistype.m_playerCharacterData[i] = 0
				set thistype.m_playerHasSkipped[i] = false

				set i = i + 1
			endloop
			set thistype.m_timeOfDay = 0.0

			call thistype.createSkipTrigger()
			call thistype.createLeaveTrigger()
		endmethod

		private static method destroySkipTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(thistype.m_skipTrigger)
			set thistype.m_skipTrigger = null
		endmethod

		private static method destroyLeaveTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(thistype.m_leaveTrigger)
			set thistype.m_leaveTrigger = null
		endmethod

		public static method cleanUp takes nothing returns nothing
			local integer i
			// static members
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (thistype.m_playerData[i] != 0) then
					call thistype.m_playerData[i].destroy()
				endif
				if (thistype.m_playerCharacterData[i] != 0) then
					call thistype.m_playerCharacterData[i].destroy()
				endif
				set i = i + 1
			endloop

			call thistype.destroySkipTrigger()
			call thistype.destroyLeaveTrigger()
		endmethod

		// static members

		/**
		 * Since there can only be one video at a moment this method returns the running one.
		 */
		public static method runningVideo takes nothing returns thistype
			return thistype.m_runningVideo
		endmethod

		/**
		 * \return Returns true if the running video has been skipped. Otherwise it returns false.
		 */
		public static method skipped takes nothing returns boolean
			return thistype.m_skipped
		endmethod

		// static methods

		/**
		 * \return Returns true if a video is running at the moment at all.
		 */
		public static method isRunning takes nothing returns boolean
			return thistype.m_runningVideo != 0
		endmethod

		// static methods

		/**
		 * \param whichUnit The specified unit which could be an actor.
		 * \return Returns true if the specified unit is an actor unit. Otherwise it returns false.
		 */
		public static method unitIsActor takes unit whichUnit returns boolean
			return AHashTable.global().hasHandleInteger(whichUnit, A_HASHTABLE_KEY_ACTOR)
		endmethod

		/**
		 * \param whichUnit The specified unit which could be an actor.
		 * \return Returns the corresponding \ref AActorInterface instance of the specified unit. Returns 0 if the unit is no actor unit.
		 */
		public static method actorByUnit takes unit whichUnit returns AActorInterface
			return AActorInterface(AHashTable.global().handleInteger(whichUnit, A_HASHTABLE_KEY_ACTOR))
		endmethod
	 endstruct

	/**
	 * Waits (synchronized) until no video is running anymore.
	 * \param interval Check interval.
	 */
	function waitForVideo takes real interval returns nothing
		loop
			exitwhen (AVideo.runningVideo() == 0)
			call PolledWait(interval) // synchron waiting, important for multiplayer games
		endloop
	endfunction

	private function WaitCondition takes nothing returns boolean
		return AVideo.skipped()
	endfunction

	/**
	* Waits \p seconds game-time seconds. Cancels if video is skipped during this time and calls \ref AVideo.skip().
	* Note that this function is like \ref PolledWait since it has to be synchronos.
	* \return Returns true if video was skipped during the wait phase. Otherwise it returns false (if wait time has expired normally).
	* \see PolledWait
	*/
	function wait takes real seconds returns boolean
		if (WaitCheckingCondition(seconds, function WaitCondition, 0)) then
			call AVideo.runningVideo().skip()

			return true
		endif
		return false
	endfunction

	/**
	* Condition function interface for video conditions which can be checked during wait phase.
	* \sa waitForCondition
	*/
	function interface AVideoCondition takes AVideo video returns boolean

	/**
	* Advanced conditional video wait function.
	* Checks every \p interval seconds for condition \p condition. If video is being skipped during this time it returns true amd calls \ref AVideo.skip().
	* Otherwise it returns false when condition is true.
	* \param interval Interval in seconds in which the condition will be checked.
	* \param condition Condition which will be checked. Use \ref AVideoCondition to create and pass a correct function.
	* \return Returns true if the video had been skipped before condition became true. Otherwise it returns false when condition becomes true.
	* \sa AVideoCondition
	*/
	function waitForCondition takes real interval, AVideoCondition condition returns boolean
		loop
			exitwhen (condition.evaluate(AVideo.runningVideo()))
			if (WaitCondition()) then
				call AVideo.runningVideo().skip()

				return true
			endif
			call PolledWait(interval)
		endloop
		return false
	endfunction
endlibrary