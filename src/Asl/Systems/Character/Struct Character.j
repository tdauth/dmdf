library AStructSystemsCharacterCharacter requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, AStructCoreGeneralVector, ALibraryCoreGeneralPlayer, ALibraryCoreGeneralUnit, ALibraryCoreInterfaceCinematicFilter, ALibraryCoreInterfaceCamera, ALibraryCoreInterfaceMisc, ALibraryCoreMathsUnit, AStructSystemsCharacterAbstractCharacterSystem

	/**
	 * \brief This structure represents a single RPG character. Each player can own exactly one character.
	 * You can configure the character systems and enable or disable the several character system modules.
	 * Each module makes the system requiring more memory, so clearly think of which system modules are required and which aren't.
	 */
	struct ACharacter
		// static constant members
		public static constant integer messageTypeInfo = 0
		public static constant integer messageTypeError = 1
		// static construction members
		private static boolean m_doAlwaysAddExperience
		private static boolean m_removeUnitOnDestruction
		private static boolean m_destroyOnPlayerLeaves
		private static boolean m_shareOnPlayerLeaves
		private static boolean m_destroyOnDeath
		private static boolean m_useViewSystem
		private static boolean m_useRevivalSystem
		private static boolean m_useInventorySystem
		private static boolean m_useTalkLogSystem
		// static members
		private static thistype array m_playerCharacter[12] /// \todo [bj_MAX_PLAYERS] vjass bug
		// dynamic members
		private boolean m_isMovable
		private AClass m_class //No system
		private ATalk m_talk //No system
		private AShrine m_shrine //No system
		// construction members
		private player m_player
		private unit m_unit
		// members
		private trigger m_leaveTrigger
		private trigger m_deathTrigger
		//insert the character systems here
		private AView m_view
		private ARevival m_revival
		private ACharacterInventory m_inventory
		private ATalkLog m_talkLog
		private AIntegerVector m_spells

		//! runtextmacro optional A_STRUCT_DEBUG("\"ACharacter\"")

		// dynamic members

		/**
		 * If the character is set unmovable he will be stopped immediatly and can not move until he will be set movable.
		 * This method is used for dialogs or cinematic sequences.
		 * Besides it disables all character systems!
		 */
		public method setMovable takes boolean movable returns nothing
			//Don't make him movable if he is already!
			//If he talks with another NPC he is already unmovable.
			debug if (this.m_isMovable == movable) then
				debug call this.print("setMovable() error.")
				debug return
			debug endif
			set this.m_isMovable = movable
			call IssueImmediateOrder(this.m_unit, "stop") //new, required?!
			call PauseUnit(this.m_unit, not movable)
			call SetUnitInvulnerable(this.m_unit, not movable)
			if (movable) then
				call this.enableMovableSystems.evaluate()
			else
				call this.disableMovableSystems.evaluate()
			endif
		endmethod

		/**
		 * \return Returns if the character is movable. Unmovable characters are paused and invulnerable. Additionally all systems are disabled.
		 * \sa setMovable
		 */
		public method isMovable takes nothing returns boolean
			return this.m_isMovable
		endmethod

		/// Friend relation to \ref AClassSelection, don't use.
		public method setClass takes AClass class returns nothing
			set this.m_class = class
		endmethod

		/**
		 * \return Returns class of the character. Classes are used by class selection which allows user to choose between different classes/unit types which are during the game.
		 * \sa AClass, AClassSelection
		 */
		public method class takes nothing returns AClass
			return this.m_class
		endmethod

		/// Friend relation to \ref ATalk, don't use.
		public method setTalk takes ATalk talk returns nothing
			set this.m_talk = talk
		endmethod

		/// Friend relation to \ref ATalk, don't use.
		public method talk takes nothing returns ATalk
			return this.m_talk
		endmethod

		/// Friend relation to \ref AShrine, don't use.
		public method setShrine takes AShrine shrine returns nothing
			set this.m_shrine = shrine
		endmethod

		/// Friend relation to \ref AShrine, don't use.
		public method shrine takes nothing returns AShrine
			return this.m_shrine
		endmethod

		// construction members

		/**
		 * Each character has its own owner. Each playing player can own exact one character.
		 * \return Returns character's owning player
		 */
		public method player takes nothing returns player
			return this.m_player
		endmethod

		/**
		 * Characters are represented by units in game.
		 * \return Returns character's unit.
		 */
		public method unit takes nothing returns unit
			return this.m_unit
		endmethod

		// members

		public method view takes nothing returns AView
			return this.m_view
		endmethod

		/**
		 * Friend relation to \ref AShrine, don't use.
		 * Use it to setup the time.
		 */
		public method revival takes nothing returns ARevival
			return this.m_revival
		endmethod

		public method characterInventory takes nothing returns ACharacterInventory
			return this.m_inventory
		endmethod

		/**
		 * For keeping the compatibilty, this method returns the instance of \ref AUnitInventory.
		 * Use \ref characterInventory() for getting the actual character inventory instance.
		 */
		public method inventory takes nothing returns AUnitInventory
			return this.m_inventory.unitInventory.evaluate()
		endmethod

		public method talkLog takes nothing returns ATalkLog
			return this.m_talkLog
		endmethod

		/**
		 * \return Returns the size of the character's spells.
		 */
		public method spellCount takes nothing returns integer
			return this.m_spells.size()
		endmethod

		// convenience methods

		public method name takes nothing returns string
			return GetPlayerName(this.m_player)
		endmethod

		/**
		 * Displays a message to the owner of the character.
		 * \todo Change this method.
		 * \param messageType The message type.
		 * \param message The message text.
		 */
		public method displayMessage takes integer messageType, string message returns nothing
			if (messageType == thistype.messageTypeInfo) then
				call DisplayTimedTextToPlayer(this.m_player, 0.0, 0.0, 6.0, message)
			else
				call SimError(this.m_player, message)
			endif
		endmethod

		/// Displays a message to the owners of all other characters.
		public method displayMessageToAllOthers takes integer messageType, string message returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (user != this.m_player) then
					call thistype.playerCharacter.evaluate(user).displayMessage(messageType, message)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public method addLevels takes integer levels, boolean showEffect returns nothing
			call SetHeroLevel(this.m_unit, GetHeroLevel(this.m_unit) + levels, showEffect)
		endmethod

		public method addSkillPoints takes integer skillPoints returns boolean
			return UnitModifySkillPoints(this.m_unit, skillPoints)
		endmethod

		public method removeSkillPoints takes integer skillPoints returns boolean
			return UnitModifySkillPoints(this.m_unit, -skillPoints)
		endmethod

		public method addExperience takes integer experience, boolean showEffect returns nothing
			local boolean suspend = false
			if (thistype.m_doAlwaysAddExperience and IsSuspendedXP(this.m_unit)) then
				call SuspendHeroXP(this.m_unit, false)
				set suspend = true
			endif
			call AddHeroXP(this.m_unit, experience, showEffect)
			if (suspend) then
				call SuspendHeroXP(this.m_unit, true)
			endif
		endmethod

		public method addStrength takes integer strength returns nothing
			call SetHeroStr(this.m_unit, GetHeroStr(this.m_unit, false) + strength, true)
		endmethod

		public method addAgility takes integer agility returns nothing
			call SetHeroAgi(this.m_unit, GetHeroAgi(this.m_unit, false) + agility, true)
		endmethod

		public method addIntelligence takes integer intelligence returns nothing
			call SetHeroInt(this.m_unit, GetHeroInt(this.m_unit, false) + intelligence, true)
		endmethod

		public method addGold takes integer gold returns nothing
			call SetPlayerState(this.m_player, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(this.m_player, PLAYER_STATE_RESOURCE_GOLD) + gold)
		endmethod

		public method removeGold takes integer gold returns nothing
			call SetPlayerState(this.m_player, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(this.m_player, PLAYER_STATE_RESOURCE_GOLD) - gold)
		endmethod

		public method gold takes nothing returns integer
			return GetPlayerState(this.m_player, PLAYER_STATE_RESOURCE_GOLD)
		endmethod

		public method addLumber takes integer lumber returns nothing
			call SetPlayerState(this.m_player, PLAYER_STATE_RESOURCE_LUMBER, GetPlayerState(this.m_player, PLAYER_STATE_RESOURCE_LUMBER) + lumber)
		endmethod

		public method removeLumber takes integer lumber returns nothing
			call SetPlayerState(this.m_player, PLAYER_STATE_RESOURCE_LUMBER, GetPlayerState(this.m_player, PLAYER_STATE_RESOURCE_LUMBER) - lumber)
		endmethod

		public method lumber takes nothing returns integer
			return GetPlayerState(this.m_player, PLAYER_STATE_RESOURCE_LUMBER)
		endmethod

		public method showCinematicFilter takes real duration, blendmode blendMode, string texture, real red0, real green0, real blue0, real transparency0, real red1, real green1, real blue1, real transparency1 returns nothing
			call ShowGenericCinematicFilterForPlayer(this.m_player, duration, blendMode, texture, red0, green0, blue0, transparency0, red1, green1, blue1, transparency1)
		endmethod

		public method showBlackScreenCinematicFilter takes real duration returns nothing
			call ShowBlackScreenCinematicFilterForPlayer(this.m_player, duration)
		endmethod

		public method setX takes real x returns nothing
			call SetUnitX(this.m_unit, x)
		endmethod

		public method setY takes real y returns nothing
			call SetUnitY(this.m_unit, y)
		endmethod

		public method setPosition takes real x, real y returns nothing
			call SetUnitX(this.m_unit, x)
			call SetUnitY(this.m_unit, y)
		endmethod

		public method setLocation takes location usedLocation returns nothing
			call this.setX(GetLocationX(usedLocation))
			call this.setY(GetLocationY(usedLocation))
		endmethod

		public method setRect takes rect usedRect returns nothing
			call this.setX(GetRectCenterX(usedRect))
			call this.setY(GetRectCenterY(usedRect))
		endmethod

		public method setFacing takes real facing returns nothing
			call SetUnitFacing(this.m_unit, facing)
		endmethod

		public method show takes boolean show returns nothing
			call ShowUnit(this.m_unit, show)
		endmethod

		public method select takes boolean single returns nothing
			if (single) then
				call ClearSelectionForPlayer(this.m_player)
			endif
			call SelectUnitAddForPlayer(this.m_unit, this.m_player)
		endmethod

		public method panCamera takes nothing returns nothing
			call PanCameraToForPlayer(this.m_player, GetUnitX(this.m_unit), GetUnitY(this.m_unit))
		endmethod

		public method panCameraSmart takes nothing returns nothing
			call SmartCameraPanWithZForPlayer(this.m_player, GetUnitX(this.m_unit), GetUnitY(this.m_unit), 0.0, 0.0)
		endmethod

		public method setCamera takes nothing returns nothing
			call SetCameraPositionForPlayer(this.m_player, GetUnitX(this.m_unit), GetUnitY(this.m_unit))
		endmethod

		public method setCameraBoundsToRect takes rect usedRect returns nothing
			call SetCameraBoundsToRectForPlayerBJ(this.m_player, usedRect)
		endmethod

		public method resetCameraBoundsToMapRect takes nothing returns nothing
			call ResetCameraBoundsToMapRectForPlayer(this.m_player)
		endmethod

		public method userId takes nothing returns integer
			return GetPlayerId(this.m_player)
		endmethod

		public method level takes nothing returns integer
			return GetHeroLevel(this.m_unit)
		endmethod

		public method skillPoints takes nothing returns integer
			return GetHeroSkillPoints(this.m_unit)
		endmethod

		/**
		 * Copies character's unit by using function \ref CopyUnit with state method \p stateMethod.
		 * \return Returns copied unit.
		 */
		public method copy takes integer stateMethod returns unit
			return CopyUnit(this.m_unit, GetUnitX(this.m_unit), GetUnitY(this.m_unit), GetUnitFacing(this.m_unit), stateMethod)
		endmethod

		/// \return Returns if player has shared advanced control (\ref ALLIANCE_SHARED_CONTROL and \ref ALLIANCE_SHARED_ADVANCED_CONTROL) to all other players.
		public method isControlShared takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (i != GetPlayerId(this.m_player) and (not GetPlayerAlliance(this.m_player, Player(i), ALLIANCE_SHARED_CONTROL) or not GetPlayerAlliance(this.m_player, Player(i), ALLIANCE_SHARED_ADVANCED_CONTROL))) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/// Shares advanced player control (\ref ALLIANCE_SHARED_CONTROL and \ref ALLIANCE_SHARED_ADVANCED_CONTROL) to players.
		public method shareControl takes boolean share returns nothing
			local player whichPlayer
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (i != GetPlayerId(this.m_player)) then
					set whichPlayer = Player(i)
					call SetPlayerAlliance(this.m_player, whichPlayer, ALLIANCE_SHARED_CONTROL, share)
					call SetPlayerAlliance(this.m_player, whichPlayer, ALLIANCE_SHARED_ADVANCED_CONTROL, share)
					set whichPlayer = null
				endif
				set i = i + 1
			endloop
		endmethod

		public method suspendExperience takes boolean suspend returns nothing
			call SuspendHeroXP(this.m_unit, suspend)
		endmethod

		// methods

		/**
		 * Refresh events (without death events, there won't be any revival).
		 * Only use this method when replacing the character's unit for some time.
		 */
		public method replaceUnit takes unit newUnit returns nothing
			local unit oldUnit = this.m_unit
			call AHashTable.global().removeHandleInteger(oldUnit, A_HASHTABLE_KEY_CHARACTER)
			set this.m_unit = newUnit
			call AHashTable.global().setHandleInteger(newUnit, A_HASHTABLE_KEY_CHARACTER, this)
			call this.onReplaceUnit.evaluate(oldUnit, newUnit)
		endmethod

		/**
		 * Is called by .evaluate() when the unit is replaced by \ref replaceUnit(). At the time of the call the reference in this struct is already replaced.
		 * Any references can be updated in this method.
		 */
		public stub method onReplaceUnit takes unit oldUnit, unit newUnit returns nothing
		endmethod

		/**
		 * Call this method to store the whole character data into game cache \p cache on key \p missionKey.
		 */
		public method store takes gamecache cache, string missionKey returns nothing
			call StoreInteger(cache, missionKey, "Class", integer(this.m_class))
			// don't store is movable, talk, shrine and player
			call StoreUnit(cache, missionKey, "Unit", this.m_unit)
			if (thistype.m_useViewSystem) then
				call this.m_view.store(cache, missionKey, "View")
			endif
			if (thistype.m_useRevivalSystem) then
				call this.m_revival.store(cache, missionKey, "Revival")
			endif
			if (thistype.m_useInventorySystem) then
				call this.m_inventory.store.evaluate(cache, missionKey, "Inventory")
			endif
			if (thistype.m_useTalkLogSystem) then
				call this.m_talkLog.store(cache, missionKey, "TalkLog")
			endif
		endmethod

		/**
		 * Restores a character unit from a gamecache.
		 */
		public static method restoreUnitFromCache takes gamecache cache, string missionKey, player whichPlayer, real x, real y, real facing returns unit
			return RestoreUnit(cache, missionKey, "Unit", whichPlayer, x, y, facing)
		endmethod

		public method restoreDataFromCache takes gamecache cache, string missionKey returns nothing
			set this.m_class = AClass(GetStoredInteger(cache, missionKey, "Class"))
			/// \todo call refresh unit actions
			if (thistype.m_useViewSystem) then
				call this.m_view.restore(cache, missionKey, "View")
			endif
			if (thistype.m_useRevivalSystem) then
				call this.m_revival.restore(cache, missionKey, "Revival")
			endif
			if (thistype.m_useInventorySystem) then
				call this.m_inventory.restore.evaluate(cache, missionKey, "Inventory")
			endif
			if (thistype.m_useTalkLogSystem) then
				call this.m_talkLog.restore(cache, missionKey, "TalkLog")
			endif
		endmethod

		/**
		 * Call this method to restore the whole character data into game cache \p cache on key \p missionKey.
		 */
		public method restore takes gamecache cache, string missionKey, real x, real y, real facing returns nothing
			// don't restore is movable, talk, shrine and player
			if (this.m_unit != null) then
				call RemoveUnit(this.m_unit)
				set this.m_unit = null
			endif
			set this.m_unit = thistype.restoreUnitFromCache(cache, missionKey, this.m_player, x, y, facing)
			call this.restoreDataFromCache(cache, missionKey)
		endmethod

		/**
		 * This method is called with .evaluate() by \ref ARevival.
		 */
		public stub method onRevival takes nothing returns nothing
		endmethod

		/// Friend relation to \ref ASpell, don't use.
		public method addSpell takes ASpell spell returns nothing
			call this.m_spells.pushBack(spell)
		endmethod

		/// Friend relation to \ref ASpell, don't use.
		public method removeSpell takes ASpell spell returns nothing
			call this.m_spells.remove(spell)
		endmethod

		/**
		 * \return Returns the character spell with index \p index.
		 */
		public method spell takes integer index returns ASpell
			return this.m_spells[index]
		endmethod

		/**
		 * Gets a spell of the character by an ability ID if it exists.
		 * \param abilityId The ability ID for which a spell is searched.
		 * \return Returns 0 if no spell has the ability ID.
		 * \note This method has linear complexity O(n) and should only be used if necessary.
		 */
		public method spellByAbilityId takes integer abilityId returns ASpell
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				if (ASpell(this.m_spells[i]).unitSpell.evaluate().ability() == abilityId) then
					return ASpell(this.m_spells[i])
				endif
				set i = i + 1
			endloop
			return 0
		endmethod

		/// \note Use this method with care. Make sure the spells are already destroyed.
		public method clearSpells takes nothing returns nothing
			call this.m_spells.clear()
		endmethod

		private method enableMovableSystems takes nothing returns nothing
			if (thistype.m_useViewSystem and this.m_view.enableAgain()) then
				call this.m_view.enable.evaluate()
			endif
			if (thistype.m_useRevivalSystem and this.m_revival.enableAgain()) then
				call this.m_revival.enable.evaluate()
			endif
			/*
			inventory and talk log systems aren't movable systems!
			if (thistype.m_useInventorySystem and this.m_inventory.enableAgain()) then
				call this.m_inventory.enable()
			endif
			if (thistype.m_useTalkLogSystem and this.m_talkLog.enableAgain()) then
				call this.m_talkLog.enable()
			endif
			*/
		endmethod

		private method disableMovableSystems takes nothing returns nothing
			if (thistype.m_useViewSystem and this.m_view.isEnabled()) then
				call this.m_view.disable.evaluate()
			endif
			if (thistype.m_useRevivalSystem and this.m_revival.isEnabled()) then
				call this.m_revival.disable.evaluate()
			endif
			/*
			inventory and talk log systems aren't movable systems!
			if (thistype.m_useInventorySystem and this.m_inventory.isEnabled()) then
				call this.m_inventory.disable()
			endif
			if (thistype.m_useTalkLogSystem and this.m_talkLog.isEnabled()) then
				call this.m_talkLog.disable()
			endif
			*/
		endmethod

		private static method triggerConditionIsCharacter takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return this.unit() == GetTriggerUnit()
		endmethod

		private static method triggerActionDestroyCharacter takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call thistype.destroy(this)
		endmethod

		private static method triggerActionShareControl takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.shareControl(true)
		endmethod

		private method createLeaveTrigger takes nothing returns nothing
			set this.m_leaveTrigger = CreateTrigger()
			call TriggerRegisterPlayerEvent(this.m_leaveTrigger, this.m_player, EVENT_PLAYER_LEAVE)
			if (thistype.m_destroyOnPlayerLeaves) then
				call TriggerAddAction(this.m_leaveTrigger, function thistype.triggerActionDestroyCharacter)
			elseif (thistype.m_shareOnPlayerLeaves) then
				call TriggerAddAction(this.m_leaveTrigger, function thistype.triggerActionShareControl)
			endif
			call AHashTable.global().setHandleInteger(this.m_leaveTrigger, 0, this)
		endmethod

		/// DON'T MAKE HIM UNMOVABLE, disables all systems!
		private method createDeathTrigger takes nothing returns nothing
			set this.m_deathTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_deathTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(this.m_deathTrigger, Condition(function thistype.triggerConditionIsCharacter))
			call TriggerAddAction(this.m_deathTrigger, function thistype.triggerActionDestroyCharacter)
			call AHashTable.global().setHandleInteger(this.m_deathTrigger, 0, this)
		endmethod

		private method createSystems takes nothing returns nothing
			if (thistype.m_useViewSystem) then
				set this.m_view = AView.create.evaluate(this)
			endif
			if (thistype.m_useRevivalSystem) then
				set this.m_revival = ARevival.create.evaluate(this)
			endif
			if (thistype.m_useInventorySystem) then
				set this.m_inventory = ACharacterInventory.create.evaluate(this)
			endif
			if (thistype.m_useTalkLogSystem) then
				set this.m_talkLog = ATalkLog.create.evaluate(this)
			endif
		endmethod

		public static method create takes player whichPlayer, unit whichUnit returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_player = whichPlayer
			set this.m_unit = whichUnit
			if (whichUnit != null) then
				call AHashTable.global().setHandleInteger(whichUnit, A_HASHTABLE_KEY_CHARACTER, this)
			endif
			// dynamic members
			set this.m_isMovable = true
			// members
			set this.m_inventory = 0
			set this.m_talkLog = 0
			set this.m_spells = AIntegerVector.create()

			if (thistype.m_destroyOnPlayerLeaves or thistype.m_shareOnPlayerLeaves) then
				call this.createLeaveTrigger()
			endif
			if (thistype.m_destroyOnDeath) then
				call this.createDeathTrigger()
			endif
			call this.createSystems()
			return this
		endmethod

		public static method createRestored takes player whichPlayer, gamecache cache, string missionKey, real x, real y, real facing returns thistype
			local thistype this = thistype.create(whichPlayer, thistype.restoreUnitFromCache(cache, missionKey, whichPlayer, x, y, facing))

			call this.restoreDataFromCache(cache, missionKey)

			return this
		endmethod


		private method removeUnit takes nothing returns nothing
			if (thistype.m_removeUnitOnDestruction) then
				call RemoveUnit(this.m_unit)
			endif
			call AHashTable.global().flushHandle(this.m_unit)
			set this.m_unit = null
		endmethod

		private method destroyLeaveTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_leaveTrigger)
			set this.m_leaveTrigger = null
		endmethod

		private method destroyDeathTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_deathTrigger)
			set this.m_deathTrigger = null
		endmethod

		private method destroySystems takes nothing returns nothing
			//ifs are important
			if (thistype.m_useViewSystem) then
				call this.m_view.destroy()
			endif
			if (thistype.m_useRevivalSystem) then
				call this.m_revival.destroy()
			endif
			if (thistype.m_useInventorySystem) then
				call this.m_inventory.destroy()
			endif
			if (thistype.m_useTalkLogSystem) then
				call this.m_talkLog.destroy()
			endif
		endmethod

		// Automatic destruction when player leaves
		private method onDestroy takes nothing returns nothing
			// construction members
			set this.m_player = null
			// members
			// make sure the spell instances are destroyed as well, otherwise on repick they will stay available
			call this.destroySpells.evaluate() // new OpLimit

			call this.removeUnit()
			if (thistype.m_destroyOnPlayerLeaves or thistype.m_shareOnPlayerLeaves) then
				call this.destroyLeaveTrigger()
			endif
			if (thistype.m_destroyOnDeath) then
				call this.destroyDeathTrigger()
			endif
			call this.destroySystems()
		endmethod

		private method destroySpells takes nothing returns nothing
			loop
				exitwhen (this.m_spells.empty())
				// new OpLimit
				call this.destroySpell.evaluate(ASpell(this.m_spells.back()))
			endloop
			call this.m_spells.destroy()
		endmethod

		private method destroySpell takes ASpell spell returns nothing
			call spell.destroy()
		endmethod

		/**
		 * Call this method before you use this class!
		 * \param destroyOnPlayerLeaves If this value is true the character will be destroyed when his owner leaves game.
		 * \param shareOnPlayerLeaves If this value is true control over character will be shared with other character owners.
		 * \param destroyOnDeath If this value is false the character will be set unmovable when he dies otherwise he will be destroyed.
		 * \param useViewSystem Shows if the view system is used.
		 * \param useRevivalSystem Shows if the revival system is used.
		 * \param useInventorySystem Shows if the inventory system is used.
		 * \param useTalkLogSystem Shows if the talk log system is used.
		 * \sa AView
		 * \sa ARevival
		 * \sa ACharacterInventory
		 * \sa ATalkLog
		 */
		public static method init takes boolean doAlwaysAddExperience, boolean removeUnitOnDestruction, boolean destroyOnPlayerLeaves, boolean shareOnPlayerLeaves, boolean destroyOnDeath, boolean useViewSystem, boolean useRevivalSystem, boolean useInventorySystem, boolean useTalkLogSystem returns nothing
			// static initialization members
			set thistype.m_doAlwaysAddExperience = doAlwaysAddExperience
			set thistype.m_removeUnitOnDestruction = removeUnitOnDestruction
			set thistype.m_destroyOnPlayerLeaves = destroyOnPlayerLeaves
			set thistype.m_shareOnPlayerLeaves = shareOnPlayerLeaves
			set thistype.m_destroyOnDeath = destroyOnDeath
			set thistype.m_useViewSystem = useViewSystem
			set thistype.m_useRevivalSystem = useRevivalSystem
			set thistype.m_useInventorySystem = useInventorySystem
			set thistype.m_useTalkLogSystem = useTalkLogSystem

			debug if (destroyOnPlayerLeaves and shareOnPlayerLeaves) then
				debug call thistype.staticPrint("destroyOnPlayerLeaves and shareOnPlayerLeaves can not be set true at the same time.")
			debug endif
			debug if (destroyOnDeath and useRevivalSystem) then
				debug call thistype.staticPrint("You're using destroy on death and use revival system options at the same time.")
			debug endif
		endmethod

		public static method doAlwaysAddExperience takes nothing returns boolean
			return thistype.m_doAlwaysAddExperience
		endmethod

		public static method removeUnitOnDestruction takes nothing returns boolean
			return thistype.m_removeUnitOnDestruction
		endmethod

		public static method destroyOnPlayerLeaves takes nothing returns boolean
			return thistype.m_destroyOnPlayerLeaves
		endmethod

		public static method shareOnPlayerLeaves takes nothing returns boolean
			return thistype.m_shareOnPlayerLeaves
		endmethod

		public static method destroyOnDeath takes nothing returns boolean
			return thistype.m_destroyOnDeath
		endmethod

		public static method useViewSystem takes nothing returns boolean
			return thistype.m_useViewSystem
		endmethod

		public static method useRevivalSystem takes nothing returns boolean
			return thistype.m_useRevivalSystem
		endmethod

		public static method useInventorySystem takes nothing returns boolean
			return thistype.m_useInventorySystem
		endmethod

		public static method useTalkLogSystem takes nothing returns boolean
			return thistype.m_useTalkLogSystem
		endmethod

		/**
		 * Each human playing player can own exact one character.
		 * Use this method to set the unit of a player character.
		 * \param user The owner of the character.
		 * \param usedUnit The unit of the character.
		 * \return Returns player character.
		 * \sa playerCharacter()
		 */
		public static method setPlayerCharacter takes player user, unit usedUnit returns thistype
			local thistype character = thistype.create(user, usedUnit)
			set thistype.m_playerCharacter[GetPlayerId(user)] = character
			return character
		endmethod

		/**
		 * Should not be used.
		 * Used by \ref ClassSelection only.
		 */
		public static method setPlayerCharacterByCharacter takes ACharacter character returns nothing
			set thistype.m_playerCharacter[GetPlayerId(character.player())] = character
		endmethod

		/// \param user The owner of the character.
		/// \return The character instance.
		public static method playerCharacter takes player user returns thistype
			return thistype.m_playerCharacter[GetPlayerId(user)]
		endmethod

		/// If character will be destroyed automaticly you don't have to call this method.
		/// \param user The owner of the character.
		public static method destroyPlayerCharacter takes player user returns nothing
			call thistype.destroy(thistype.m_playerCharacter[GetPlayerId(user)])
		endmethod

		// static convenience methods

		/// \todo You could also check it by only comparing with the units owner character unit.
		public static method getCharacterByUnit takes unit usedUnit returns thistype
			return AHashTable.global().handleInteger(usedUnit, A_HASHTABLE_KEY_CHARACTER)
		endmethod

		public static method isUnitCharacter takes unit usedUnit returns boolean
			return thistype.getCharacterByUnit(usedUnit) != 0
		endmethod

		/**
		 * \return Returns the first existing character starting with the lowest player ID. If no character exists it returns 0.
		 */
		public static method getFirstCharacter takes nothing returns thistype
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					set user = null
					return thistype.playerCharacter(user)
				endif
				set user = null
				set i = i + 1
			endloop
			return 0
		endmethod

		public static method displayMessageByUser takes player user, integer messageType, string message returns nothing
			call thistype.playerCharacter(user).displayMessage(messageType, message)
		endmethod

		// the following methods are for convience to call methods for all characters

		public static method setAllMovable takes boolean movable returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).setMovable(movable)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		/// Displays a message to each owner of every character.
		public static method displayMessageToAll takes integer messageType, string message returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).displayMessage(messageType, message)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		/**
		 * Counts all characters.
		 * \return Returns the number of all characters.
		 */
		public static method countAll takes nothing returns integer
			local integer i
			local player user
			local integer result = 0
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					set result = result + 1
				endif
				set user = null
				set i = i + 1
			endloop
			return result
		endmethod

		public static method countAllPlaying takes nothing returns integer
			local integer i
			local player user
			local integer result = 0
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (IsPlayerPlayingUser(user) and thistype.playerCharacter(user) != 0) then
					set result = result + 1
				endif
				set user = null
				set i = i + 1
			endloop
			return result
		endmethod

		public static method addLevelsToAll takes integer levels, boolean showEffect returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).addLevels(levels, showEffect)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method addSkillPointsToAll takes integer skillPoints returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).addSkillPoints(skillPoints)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method addExperienceToAll takes integer experience, boolean showEffect returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).addExperience(experience, showEffect)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method addStrengthToAll takes integer strength returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).addStrength(strength)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method addAgilityToAll takes integer agility returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).addAgility(agility)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method addIntelligenceToAll takes integer intelligence returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).addIntelligence(intelligence)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method addGoldToAll takes integer gold returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).addGold(gold)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method addLumberToAll takes integer lumber returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).addLumber(lumber)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method allUnitsAreInRect takes rect usedRect returns boolean
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					if ((thistype.playerCharacter(user).unit() == null) or (not RectContainsUnit(usedRect, thistype.playerCharacter(user).unit()))) then //RectContainsUnit shouldn't be that slow
						return false
					endif
				endif
				set user = null
				set i = i + 1
			endloop
			return true
		endmethod

		public static method panCameraToAll takes nothing returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).panCamera()
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method panCameraSmartToAll takes nothing returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).panCameraSmart()
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method showAll takes boolean show returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).show(show)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method enableShrineForAll takes AShrine shrine, boolean showMessage returns nothing
			local integer i
			local player user
			debug if (not thistype.m_useRevivalSystem) then
				debug call thistype.staticPrint("Revival system is not enabled.")
				debug return
			debug endif
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call shrine.enableForCharacter.evaluate(thistype.playerCharacter(user), showMessage)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method setToRandomPointOnRectForAll takes rect whichRect returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call SetUnitToRandomPointOnRect(thistype.playerCharacter(user).unit(), whichRect)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod

		public static method suspendExperienceForAll takes boolean suspend returns nothing
			local integer i
			local player user
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set user = Player(i)
				if (thistype.playerCharacter(user) != 0) then
					call thistype.playerCharacter(user).suspendExperience(suspend)
				endif
				set user = null
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary