library AStructSystemsCharacterClassSelection requires optional ALibraryCoreDebugMisc, ALibraryCoreEnvironmentUnit, AStructCoreGeneralHashTable, ALibraryCoreGeneralPlayer, ALibraryCoreInterfaceCinematic, ALibraryCoreInterfaceMisc, ALibraryCoreInterfaceMultiboard, AStructSystemsCharacterCharacter, AStructSystemsCharacterClass

	/// \todo Should be part of \ref AClassSelection, vJass bug.
	function interface AClassSelectionSelectClassAction takes ACharacter character, AClass class, boolean last returns nothing

	/// \todo Should be part of \ref AClassSelection, vJass bug.
	function interface AClassSelectionCharacterCreationAction takes AClassSelection classSelection, unit whichUnit returns ACharacter

	/**
	 * \brief Simple class selection for the player's character which offers keyboard selection and a multiboard with information about the corresponding class as well as automatic camera view and unit rotation updates.
	 *
	 * The class selection creates the corresponding unit of the class and updates the camera of the player to a fixed view.
	 * It displays a multiboard with the name and a description of the class.
	 * The arrow keys can be used to change the currently displayed class. This behaviour must be enabled.
	 * The escape key can be used to select the currently displayed class. This behaviour must be enabled.
	 * It may rotate the shown class unit automatically.
	 *
	 * There is various stub methods which can be overwritten in a sub struct to change the class selection's behaviour.
	 * Besides functions can be passed using \ref AClassSelectionSelectClassAction and \ref AClassSelectionCharacterCreationAction function interfaces to set the behaviour
	 * without extending AClassSelection in a custom struct.
	 *
	 * \sa AClass
	 * \todo Some of the construction members could be dynamic.
	 */
	struct AClassSelection
		// static members
		private static thistype array m_playerClassSelection[12] /// \todo \ref bj_MAX_PLAYERS, JassHelper bug
		/**
		 * Required for the start game action.
		 * When it becomes one and the final character class is chosen, the game starts.
		 */
		private static integer m_stack
		// static dynamic members
		private static timer m_selectionTimer
		private static timerdialog m_selectionTimerDialog
		// dynamic members
		private real m_infoSheetWidth
		private real m_startX
		private real m_startY
		private real m_startFacing
		private boolean m_showAttributes
		private AClassSelectionSelectClassAction m_selectClassAction
		private AClassSelectionCharacterCreationAction m_characterCreationAction
		// construction members
		private player m_user
		private camerasetup m_cameraSetup
		private boolean m_hideUserInterface
		private real m_x
		private real m_y
		private real m_facing
		private real m_refreshRate
		private real m_rotationAngle
		private string m_strengthIconPath
		private string m_agilityIconPath
		private string m_intelligenceIconPath
		private string m_textTitle
		private string m_textStrength
		private string m_textAgility
		private string m_textIntelligence
		// members
		private unit m_classUnit
		private trigger m_leaveTrigger
		private trigger m_refreshTrigger
		private trigger m_changePreviousTrigger
		private trigger m_changeNextTrigger
		private trigger m_selectTrigger
		private multiboard m_infoSheet
		private AIntegerVector m_classes
		/**
		 * This trigger prevents move or smart orders which would corrupt the automatic rotation.
		 */
		private trigger m_moveTrigger
		private integer m_classIndex

		//! runtextmacro optional A_STRUCT_DEBUG("\"AClassSelection\"")

		/**
		 * \return Returns the class selection of player \p whichPlayer.
		 */
		public static method playerClassSelection takes player whichPlayer returns thistype
			return thistype.m_playerClassSelection[GetPlayerId(whichPlayer)]
		endmethod

		// dynamic members

		public method setInfoSheetWidth takes real width returns nothing
			set this.m_infoSheetWidth = width
			if (this.m_infoSheet != null) then
				call MultiboardSetItemsWidth(this.m_infoSheet, this.m_infoSheetWidth)
			endif
		endmethod

		public method infoSheetWidth takes nothing returns real
			return this.m_infoSheetWidth
		endmethod

		/**
		 * Sets the X coordinate of the start position for the created character.
		 * \param startX The X coordinate of the start position for the created character.
		 */
		public method setStartX takes real startX returns nothing
			set this.m_startX = startX
		endmethod

		public method startX takes nothing returns real
			return this.m_startX
		endmethod

		/**
		 * Sets the Y coordinate of the start position for the created character.
		 * \param startY The Y coordinate of the start position for the created character.
		 */
		public method setStartY takes real startY returns nothing
			set this.m_startY = startY
		endmethod

		public method startY takes nothing returns real
			return this.m_startY
		endmethod

		/**
		 * Sets the start facing angle for the created character.
		 * \param startFacing The start facing angle for the created character.
		 */
		public method setStartFacing takes real startFacing returns nothing
			set this.m_startFacing = startFacing
		endmethod

		public method startFacing takes nothing returns real
			return this.m_startFacing
		endmethod

		/**
		 * If this attribute is set to true it shows the classes' attributes per level in the multiboard.
		 * The attributes per level can be set in \ref AClass.
		 */
		public method setShowAttributes takes boolean showAttributes returns nothing
			set this.m_showAttributes = showAttributes
		endmethod

		public method showAttributes takes nothing returns boolean
			return this.m_showAttributes
		endmethod

		public method selectClassAction takes nothing returns AClassSelectionSelectClassAction
			return this.m_selectClassAction
		endmethod

		public method characterCreationAction takes nothing returns AClassSelectionCharacterCreationAction
			return this.m_characterCreationAction
		endmethod

		// construction members

		public method player takes nothing returns player
			return this.m_user
		endmethod

		// members

		/**
		 * \return Returns the currently displayed unit of the selected class in the class selection.
		 * \note The unit changes every time another class is selected.
		 */
		public method classUnit takes nothing returns unit
			return this.m_classUnit
		endmethod

		/**
		 * \return Returns the index of the currently selected class.
		 */
		public method classIndex takes nothing returns integer
			return this.m_classIndex
		endmethod

		// methods

		/**
		 * \return Returns the available class at index \p index.
		 */
		public method class takes integer index returns AClass
			return AClass(this.m_classes[index])
		endmethod

		/**
		 * \return Returns the total number of classes available in the class slection.
		 */
		public method classCount takes nothing returns integer
			return this.m_classes.size()
		endmethod

		/**
		 * \return Returns the currentl selected class.
		 */
		public method currentClass takes nothing returns AClass
			return this.class(this.classIndex())
		endmethod

		/**
		 * Adds a new class to the current class selection.
		 * \param class The class which is added to the class selection.
		 */
		public method addClass takes AClass class returns nothing
			call this.m_classes.pushBack(class)
		endmethod

		/**
		 * Is called via .evaluate() whenever a class is being selected.
		 * By default it evaluates \ref selectClassAction() if it is not 0.
		 * \param character The created character from the class selection.
		 * \param class The selected class for the character.
		 * \param last Is true if this is the last class to be selected by a player.
		 */
		public stub method onSelectClass takes ACharacter character, AClass class, boolean last returns nothing
			if (this.selectClassAction() != 0) then
				call this.selectClassAction().evaluate(character, class, last)
			endif
		endmethod

		/**
		 * Is called via .evaluate() to create a character whenever one is selected by a class and unit.
		 * By default it calls \ref characterCreationAction() via .evaluate().
		 * If \ref characterCreationAction() is 0 it creates a \ref ACharacter instance from the corresponding player and unit.
		 */
		public stub method onCharacterCreation takes AClassSelection classSelection, unit whichUnit returns ACharacter
			if (this.characterCreationAction() != 0) then
				return this.characterCreationAction().evaluate(classSelection, whichUnit)
			endif

			return ACharacter.create(classSelection.player(), whichUnit)
		endmethod

		/**
		 * Is called by .evaluate() whenever a class unit is created for a class.
		 * \param whichUnit The created unit of the corresponding class.
		 */
		public stub method onCreate takes unit whichUnit returns nothing
		endmethod

		/**
		 * Is called by .evaluate() whenever a player leaves the game who has an active class selection.
		 * It is called before the class selection had been destroyed or the class had been selected automatically and after the control had been shared.
		 */
		public stub method onPlayerLeaves takes player whichPlayer, boolean last returns nothing
		endmethod

		/**
		 * Selects the currently displayed class for the corresponding player and creates a character based on it.
		 * Calls \ref selectClassAction() with .execute().
		 */
		public method selectClass takes nothing returns nothing
			local integer i = 0
			local ACharacter character = 0
			local unit whichUnit = this.currentClass().generateUnit(this.m_user, this.startX(), this.startY(), this.startFacing())

			set character = this.onCharacterCreation.evaluate(this, whichUnit)
			call ACharacter.setPlayerCharacterByCharacter(character)

			if (GetPlayerController(this.m_user) == MAP_CONTROL_COMPUTER or (GetPlayerSlotState(this.m_user) == PLAYER_SLOT_STATE_LEFT and ACharacter.shareOnPlayerLeaves())) then
				call character.shareControl(true)
				// show info sheet since multiboard with team resources is displayed!
				set i = 0
				loop
					exitwhen (i == bj_MAX_PLAYERS)
					if (IsPlayerPlayingUser(Player(i)) and ACharacter.playerCharacter(Player(i)) == 0) then
						call ShowMultiboardForPlayer(Player(i), thistype.playerClassSelection(Player(i)).m_infoSheet, true)
					endif
					set i = i + 1
				endloop
			endif
			if (this.m_hideUserInterface) then
				call SetUserInterfaceForPlayer(this.m_user, true, true)
			endif
			call ResetToGameCameraForPlayer(this.m_user, 0.0)
			call character.setClass(this.currentClass())
			call this.onSelectClass.evaluate(character, this.currentClass(), thistype.m_stack == 1)
			debug call Print("Destroy it!")
			call this.destroy()
			debug call Print("After destruction!")
		endmethod

		/**
		 * Enables or disables changing the shown class using the left and the right arrow key.
		 */
		public method enableArrowKeySelection takes boolean enable returns nothing
			if (enable) then
				call EnableTrigger(this.m_changePreviousTrigger)
				call EnableTrigger(this.m_changeNextTrigger)
			else
				call DisableTrigger(this.m_changePreviousTrigger)
				call DisableTrigger(this.m_changeNextTrigger)
			endif
		endmethod

		/**
		 * Enables or disables selecting the class using the escape key.
		 */
		public method enableEscapeKeySelection takes boolean enable returns nothing
			if (enable) then
				call EnableTrigger(this.m_selectTrigger)
			else
				call DisableTrigger(this.m_selectTrigger)
			endif
		endmethod

		private method selectRandomClass takes nothing returns nothing
			set this.m_classIndex = GetRandomInt(0, this.classCount() - 1)
			call this.selectClass()
		endmethod

		private method createUnit takes nothing returns nothing
			if (this.m_classUnit != null) then
				call RemoveUnit(this.m_classUnit)
				set this.m_classUnit = null
			endif
			set this.m_classUnit = CreateUnit(this.m_user, this.currentClass().unitType(), this.m_x, this.m_y, this.m_facing)
			call SetUnitInvulnerable(this.m_classUnit, true)
			// make sure that the unit does not move or do anything else
			call SetUnitMoveSpeed(this.m_classUnit, 0.0) // should not be moved but be rotatable, the map Azeroth Grandprix uses a movement speed of 0.0 but a rotation rate of 0.10 for the selectable cars
			// do not block units from other players by the unit's pathing
			call SetUnitPathing(this.m_classUnit, false)

			/*
			 * Make the character invisible for all other players since all class selections share the same rect.
			 */
			if (GetLocalPlayer() != this.player()) then
				call SetUnitVertexColor(this.m_classUnit, 255, 255, 255, 0)
			endif

			/// \todo Has to be set although unit is being paused?!
			if (IsUnitType(this.m_classUnit, UNIT_TYPE_HERO)) then
				call SuspendHeroXP(this.m_classUnit, true)
			endif
			// refresh position
			call SetUnitPosition(this.m_classUnit, this.m_x, this.m_y)
			call SetUnitAnimation(this.m_classUnit, this.currentClass().animation())
			call PlaySoundFileForPlayer(this.m_user, this.currentClass().soundPath())
			if (not this.m_hideUserInterface) then
				call SelectUnitForPlayerSingle(this.m_classUnit, this.m_user)
			endif

			// refresh OpLimit
			call this.refreshInfoSheet.evaluate()

			call this.onCreate.evaluate(this.m_classUnit)
		endmethod

		/**
		 * Refreshes the info sheet (multiboard). If it does not exist it creates one and updates it with information fo the currently displayed character class.
		 */
		private method refreshInfoSheet takes nothing returns nothing
			local integer count = 0
			local integer i
			local multiboarditem multiboardItem
			local string strengthText
			local string agilityText
			local string intelligenceText
			local integer index = 0

			if (this.showAttributes()) then
				set count = 3
				set strengthText = RWArg(this.m_textStrength, this.currentClass().strPerLevel(), 0, 1)
				set agilityText = RWArg(this.m_textAgility, this.currentClass().agiPerLevel(), 0, 1)
				set intelligenceText = RWArg(this.m_textIntelligence, this.currentClass().intPerLevel(), 0, 1)
			endif

			if (this.m_infoSheet != null) then
				call ShowMultiboardForPlayer(this.m_user, this.m_infoSheet, false)
				call DestroyMultiboard(this.m_infoSheet)
				set this.m_infoSheet = null
			endif
			set this.m_infoSheet = CreateMultiboard()
			call MultiboardSetItemsWidth(this.m_infoSheet, this.m_infoSheetWidth)
			call MultiboardSetColumnCount(this.m_infoSheet, 1)

			if (this.currentClass().descriptionLines() > 0) then
				set count = count + this.currentClass().descriptionLines()
			endif

			call MultiboardSetRowCount(this.m_infoSheet, count)
			call MultiboardSetTitleText(this.m_infoSheet, IntegerArg(IntegerArg(StringArg(this.m_textTitle, GetUnitName(this.m_classUnit)), this.currentClass()), this.classCount()))
			if (this.showAttributes()) then
				// strength
				set multiboardItem = MultiboardGetItem(this.m_infoSheet, 0, 0)
				call MultiboardSetItemStyle(multiboardItem, true, true)
				call MultiboardSetItemIcon(multiboardItem, this.m_strengthIconPath)
				call MultiboardSetItemValue(multiboardItem, strengthText)
				call MultiboardReleaseItem(multiboardItem)
				set multiboardItem = null
				// agility
				set multiboardItem = MultiboardGetItem(this.m_infoSheet, 1, 0)
				call MultiboardSetItemStyle(multiboardItem, true, true)
				call MultiboardSetItemIcon(multiboardItem, this.m_agilityIconPath)
				call MultiboardSetItemValue(multiboardItem, agilityText)
				call MultiboardReleaseItem(multiboardItem)
				set multiboardItem = null
				// intelligence
				set multiboardItem = MultiboardGetItem(this.m_infoSheet, 2, 0)
				call MultiboardSetItemStyle(multiboardItem, true, true)
				call MultiboardSetItemIcon(multiboardItem, this.m_intelligenceIconPath)
				call MultiboardSetItemValue(multiboardItem, intelligenceText)
				call MultiboardReleaseItem(multiboardItem)
				set multiboardItem = null
				set index = 3
			endif

			if (this.currentClass().descriptionLines() > 0) then
				set i = 0
				loop
					exitwhen(i == this.currentClass().descriptionLines())
					set multiboardItem = MultiboardGetItem(this.m_infoSheet, index, 0)
					call MultiboardSetItemStyle(multiboardItem, true, false)
					call MultiboardSetItemValue(multiboardItem, this.currentClass().descriptionLine(i))
					call MultiboardReleaseItem(multiboardItem)
					set multiboardItem = null
					set i = i + 1
					set index = index + 1
				endloop
			endif
			call ShowMultiboardForPlayer(this.m_user, this.m_infoSheet, true)
		endmethod

		public method show takes nothing returns nothing
			if (GetPlayerController(this.m_user) == MAP_CONTROL_COMPUTER or GetPlayerSlotState(this.m_user) == PLAYER_SLOT_STATE_LEFT) then
				call this.selectRandomClass()
			else
				call ClearScreenMessagesForPlayer(this.m_user)
				if (this.m_hideUserInterface) then
					call SetUserInterfaceForPlayer(this.m_user, false, true)
				endif
				call this.createUnit()
			endif
		endmethod

		/**
		 * Minimizes or maximizes the multiboard with information about the currently displayed class.
		 * \param minimize If this value is true the multiboard is minimized. If this value is false the multiboard is maximized.
		 */
		public method minimize takes boolean minimize returns nothing
			 call MultiboardMinimize(this.m_infoSheet, minimize)
		endmethod

		private static method triggerActionPlayerLeaves takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local player whichPlayer
			local integer i
			if (ACharacter.shareOnPlayerLeaves()) then
				set i = 0
				loop
					exitwhen (i == bj_MAX_PLAYERS)
					if (i != GetPlayerId(this.m_user)) then
						set whichPlayer = Player(i)
						call SetPlayerAlliance(this.m_user, whichPlayer, ALLIANCE_SHARED_CONTROL, true)
						set whichPlayer = null
					endif
					set i = i + 1
				endloop
			endif
			call this.onPlayerLeaves.evaluate(GetTriggerPlayer(), thistype.m_stack == 1)
			if (ACharacter.destroyOnPlayerLeaves()) then
				call this.destroy()
			/*
			 * If the character is not destroyed when the player leaves a class is selected automatically.
			 */
			else
				call this.selectClass()
			endif
		endmethod

		private method createLeaveTrigger takes nothing returns nothing
			set this.m_leaveTrigger = CreateTrigger()
			call TriggerRegisterPlayerEvent(this.m_leaveTrigger, this.m_user, EVENT_PLAYER_LEAVE)
			call TriggerAddAction(this.m_leaveTrigger, function thistype.triggerActionPlayerLeaves)
			call AHashTable.global().setHandleInteger(this.m_leaveTrigger, 0, this)
		endmethod

		private static method triggerActionRefresh takes nothing returns nothing
			local thistype this = thistype(AHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			debug if (this.m_cameraSetup != null) then
				call CameraSetupApplyForPlayer(true, this.m_cameraSetup, this.m_user, 0.0)
				call CameraSetupApplyForPlayer(true, this.m_cameraSetup, this.m_user, this.m_refreshRate)
			debug else
				debug call this.print("No camera object.")
			debug endif
			call SetUnitFacingTimed(this.m_classUnit, GetUnitFacing(this.m_classUnit) + this.m_rotationAngle, this.m_refreshRate)
		endmethod

		private method createRefreshTrigger takes nothing returns nothing
			if (this.m_refreshRate > 0.0) then
				set this.m_refreshTrigger = CreateTrigger()
				call TriggerRegisterTimerEvent(this.m_refreshTrigger, this.m_refreshRate, true)
				call TriggerAddAction(this.m_refreshTrigger, function thistype.triggerActionRefresh)
				call AHashTable.global().setHandleInteger(this.m_refreshTrigger, 0, this)
			endif
		endmethod

		/**
		 * Changes to the previous class in selection.
		 */
		public method changeToPrevious takes nothing returns nothing
			if (this.classIndex() == 0) then
				set this.m_classIndex = this.classCount() - 1
			else
				set this.m_classIndex = this.m_classIndex - 1
			endif
			call this.createUnit()
		endmethod

		/**
		 * Changes to the next class in selection.
		 */
		public method changeToNext takes nothing returns nothing
			if (this.classIndex() == this.classCount() - 1) then
				set this.m_classIndex = 0
			else
				set this.m_classIndex = this.m_classIndex + 1
			endif
			call this.createUnit()
		endmethod

		private static method triggerActionChangeToPrevious takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.changeToPrevious()
		endmethod

		private method createChangePreviousTrigger takes nothing returns nothing
			set this.m_changePreviousTrigger = CreateTrigger()
			call TriggerRegisterKeyEventForPlayer(this.m_user, this.m_changePreviousTrigger, AKeyLeft, true)
			call TriggerAddAction(this.m_changePreviousTrigger, function thistype.triggerActionChangeToPrevious)
			call AHashTable.global().setHandleInteger(this.m_changePreviousTrigger, 0, this)
			call DisableTrigger(this.m_changePreviousTrigger)
		endmethod

		private static method triggerActionChangeToNext takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.changeToNext()
		endmethod

		private method createChangeNextTrigger takes nothing returns nothing
			set this.m_changeNextTrigger = CreateTrigger()
			call TriggerRegisterKeyEventForPlayer(this.m_user, this.m_changeNextTrigger, AKeyRight, true)
			call TriggerAddAction(this.m_changeNextTrigger, function thistype.triggerActionChangeToNext)
			call AHashTable.global().setHandleInteger(this.m_changeNextTrigger, 0, this)
			call DisableTrigger(this.m_changeNextTrigger)
		endmethod

		private static method triggerActionSelectClass takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call this.selectClass()
		endmethod

		private method createSelectTrigger takes nothing returns nothing
			set this.m_selectTrigger = CreateTrigger()
			call TriggerRegisterKeyEventForPlayer(this.m_user, this.m_selectTrigger, AKeyEscape, true)
			call TriggerAddAction(this.m_selectTrigger, function thistype.triggerActionSelectClass)
			call AHashTable.global().setHandleInteger(this.m_selectTrigger, 0, this)
			call DisableTrigger(this.m_selectTrigger)
		endmethod

		private method createInfoSheet takes nothing returns nothing
			set this.m_infoSheet = CreateMultiboard()
		endmethod

		private static method triggerConditionMove takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return GetTriggerUnit() == this.m_classUnit and (GetIssuedOrderId() == OrderId("move") or GetIssuedOrderId() == OrderId("smart") or GetIssuedOrderId() == OrderId("attack") or GetIssuedOrderId() == OrderId("patrol"))
		endmethod

		private static method timerFunctionStop takes nothing returns nothing
			local unit triggerUnit = AHashTable.global().handleUnit(GetExpiredTimer(), 0)
			call IssueImmediateOrder(triggerUnit, "stop")
			call PauseTimer(GetExpiredTimer())
			call AHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod

		private static method triggerActionMove takes nothing returns nothing
			local timer whichTimer = CreateTimer()
			call AHashTable.global().setHandleUnit(whichTimer, 0, GetTriggerUnit())
			call TimerStart(whichTimer, 0.0, false, function thistype.timerFunctionStop)
			debug call Print("Stop!")
		endmethod

		private method createMoveTrigger takes nothing returns nothing
			set this.m_moveTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_moveTrigger, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
			call TriggerRegisterAnyUnitEventBJ(this.m_moveTrigger, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
			call TriggerAddCondition(this.m_moveTrigger, Condition(function thistype.triggerConditionMove))
			call TriggerAddAction(this.m_moveTrigger, function thistype.triggerActionMove)
			call AHashTable.global().setHandleInteger(this.m_moveTrigger, 0, this)
		endmethod

		/**
		 * Creates a new class selection for player \p user.
		 * \param user The player for who the class selection is for.
		 * \param cameraSetup This camera setup is applied periodically for the player \p user to change his view to the class selection.
		 * \param hideUserInterface If this value is true the user interface is hidden from the player. Otherwise it is still available.
		 * \param x The start coordinate X for the selected class.
		 * \param y The start coordinate Y for the selected class.
		 * \param facing The start facing of the selected class.
		 * \note Set the classes before showing the class selection with \ref addClass().
		 */
		public static method create takes player user, camerasetup cameraSetup, boolean hideUserInterface, real x, real y, real facing, real refreshRate, real rotationAngle, string strengthIconPath, string agilityIconPath, string intelligenceIconPath, string textTitle, string textStrength, string textAgility, string textIntelligence returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_infoSheetWidth = 0.35
			set this.m_startFacing = 0.0
			set this.m_startX = 0.0
			set this.m_startY = 0.0
			set this.m_showAttributes = false
			set this.m_selectClassAction = 0
			set this.m_characterCreationAction = 0
			// construction members
			set this.m_user = user
			set this.m_cameraSetup = cameraSetup
			set this.m_hideUserInterface = hideUserInterface
			set this.m_x = x
			set this.m_y = y
			set this.m_facing = facing
			set this.m_refreshRate = refreshRate
			set this.m_rotationAngle = rotationAngle
			set this.m_strengthIconPath = strengthIconPath
			set this.m_agilityIconPath = agilityIconPath
			set this.m_intelligenceIconPath = intelligenceIconPath
			set this.m_textTitle = textTitle
			set this.m_textStrength = textStrength
			set this.m_textAgility = textAgility
			set this.m_textIntelligence = textIntelligence
			// members
			set this.m_classUnit = null
			set this.m_infoSheet = null
			set this.m_classIndex = 0
			set this.m_classes = AIntegerVector.create()
			// static members
			set thistype.m_playerClassSelection[GetPlayerId(user)] = this
			set thistype.m_stack = thistype.m_stack + 1

			call this.createLeaveTrigger()
			call this.createRefreshTrigger()
			call this.createChangePreviousTrigger()
			call this.createChangeNextTrigger()
			call this.createSelectTrigger()
			call this.createInfoSheet()
			call this.createMoveTrigger()
			return this
		endmethod

		private method destroyLeaveTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_leaveTrigger)
			set this.m_leaveTrigger = null
		endmethod

		private method destroyRefreshTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_refreshTrigger)
			set this.m_refreshTrigger = null
		endmethod

		private method destroyChangePreviousTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_changePreviousTrigger)
			set this.m_changePreviousTrigger = null
		endmethod

		private method destroyChangeNextTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_changeNextTrigger)
			set this.m_changeNextTrigger = null
		endmethod

		private method destroySelectTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_selectTrigger)
			set this.m_selectTrigger = null
		endmethod

		private method destroyInfoSheet takes nothing returns nothing
			call DestroyMultiboard(this.m_infoSheet)
			set this.m_infoSheet = null
		endmethod

		private method destroyMoveTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_moveTrigger)
			set this.m_moveTrigger = null
		endmethod

		private method removeClassUnit takes nothing returns nothing
			call RemoveUnit(this.m_classUnit)
			set this.m_classUnit = null
		endmethod

		private method onDestroy takes nothing returns nothing
			local player user = this.m_user
			// construction members
			set this.m_user = null
			// members
			call this.m_classes.destroy()
			set this.m_classes = 0
			// static members
			set thistype.m_playerClassSelection[GetPlayerId(user)] = 0
			set user = null
			set thistype.m_stack = thistype.m_stack - 1

			call this.destroyLeaveTrigger()
			call this.destroyRefreshTrigger()
			call this.destroyChangePreviousTrigger()
			call this.destroyChangeNextTrigger()
			call this.destroySelectTrigger()
			call this.destroyInfoSheet()
			call this.destroyMoveTrigger()
			call this.removeClassUnit()
		endmethod

		private static method timerFunctionAutoSelectClasses takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (thistype.m_playerClassSelection[i] != 0) then
					call thistype.m_playerClassSelection[i].selectClass()
				endif
				set i = i + 1
			endloop
			call DestroyTimerDialog(thistype.m_selectionTimerDialog)
			set thistype.m_selectionTimerDialog = null
			call PauseTimer(GetExpiredTimer())
			call DestroyTimer(GetExpiredTimer())
			set thistype.m_selectionTimer = null
		endmethod

		/**
		 * Starts a timer which auto selects classes for all players who have not already selected a class.
		 * This helps to start games with players who are afk. Otherwise the players would have to be kicked out of the game.
		 * \param text The text which will be displayed in the timer dialog.
		 * \param maxTime The time after which the classes will be selected automatically.
		 */
		public static method startTimer takes string text, real maxTime returns nothing
			if (thistype.m_selectionTimer == null) then
				set thistype.m_selectionTimer = CreateTimer()
			endif
			call TimerStart(thistype.m_selectionTimer, maxTime, false, function thistype.timerFunctionAutoSelectClasses)
			if (thistype.m_selectionTimerDialog == null) then
				set thistype.m_selectionTimerDialog = CreateTimerDialog(thistype.m_selectionTimer)
			endif
			call TimerDialogSetTitle(thistype.m_selectionTimerDialog, text)
			call TimerDialogDisplay(thistype.m_selectionTimerDialog, true)
		endmethod

		/**
		 * Ends the limitation timer.
		 */
		public static method endTimer takes nothing returns nothing
			if (thistype.m_selectionTimerDialog != null) then
				call DestroyTimerDialog(thistype.m_selectionTimerDialog)
				set thistype.m_selectionTimerDialog = null
			endif
			if (thistype.m_selectionTimer != null) then
				call PauseTimer(thistype.m_selectionTimer)
				call DestroyTimer(thistype.m_selectionTimer)
				set thistype.m_selectionTimer = null
			endif
		endmethod

		private static method onInit takes nothing returns nothing
			local integer i
			// static members
			set thistype.m_selectionTimer = null
			set thistype.m_selectionTimerDialog = null
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set thistype.m_playerClassSelection[i] = 0
				set i = i + 1
			endloop
			set thistype.m_stack = 0
		endmethod
	endstruct

endlibrary