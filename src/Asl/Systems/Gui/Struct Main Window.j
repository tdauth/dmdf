library AStructSystemsGuiMainWindow requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, AStructCoreGeneralVector, ALibraryCoreInterfaceCamera, ALibraryCoreInterfaceCinematic, ALibraryCoreInterfaceTextTag, ALibraryCoreInterfaceMisc, ALibraryCoreEnvironmentSound, ALibraryCoreMathsRect, AStructSystemsGuiGui

	/// \todo Should be a static function interface of \ref AMainWindow, vJass bug.
	function interface AMainWindowOnShowCondition takes AMainWindow mainWindow returns boolean

	/// \todo Should be a static function interface of \ref AMainWindow, vJass bug.
	function interface AMainWindowOnShowAction takes AMainWindow mainWindow returns nothing

	/// \todo Should be a static function interface of \ref AMainWindow, vJass bug.
	function interface AMainWindowOnHideCondition takes AMainWindow mainWindow returns boolean

	/// \todo Should be a static function interface of \ref AMainWindow, vJass bug.
	function interface AMainWindowOnHideAction takes AMainWindow mainWindow returns nothing

	struct AMainWindow
		// dynamic members
		private camerasetup m_cameraSetup
		private AMainWindowOnShowCondition m_onShowCondition
		private AMainWindowOnShowAction m_onShowAction
		private AMainWindowOnHideCondition m_onHideCondition
		private AMainWindowOnHideAction m_onHideAction
		private real m_tooltipX
		private real m_tooltipY
		private string m_tooltipBackgroundImageFilePath
		private string m_tooltipSoundPath
		private boolean m_useShortcuts
		private boolean m_useSpecialShortcuts
		private integer m_shortcut
		// construction members
		private AGui m_gui
		private real m_x
		private real m_y
		private real m_sizeX
		private real m_sizeY
		// members
		private integer m_index
		private boolean m_isShown
		private AIntegerVector m_widgets
		private texttag m_tooltip
		private image m_tooltipBackground
		private trigger m_shortcutTrigger
		private rect m_fogModifierRect
		private fogmodifier m_visibilityModifier
		private fogmodifier m_blackMaskModifier

		//! runtextmacro optional A_STRUCT_DEBUG("\"AMainWindow\"")

		// dynamic members

		public method cameraSetup takes nothing returns camerasetup
			return this.m_cameraSetup
		endmethod

		/**
		 * \param cameraSetup The camera setup which is used as the players view on the main window.
		 */
		public method setCameraSetup takes camerasetup cameraSetup returns nothing
			set this.m_cameraSetup = cameraSetup
			if (this.isShown.evaluate()) then
				call CameraSetupApplyForPlayer(false, this.cameraSetup(), this.gui.evaluate().player(), 0.0)
			endif
		endmethod

		/// The \p onShowCondition will be checked before the main window should be displayed.
		/// If it returns false the main window won't be displayed.
		public method setOnShowCondition takes AMainWindowOnShowAction onShowCondition returns nothing
			set this.m_onShowCondition = onShowCondition
		endmethod

		public method onShowCondition takes nothing returns AMainWindowOnShowCondition
			return this.m_onShowCondition
		endmethod

		public method setOnShowAction takes AMainWindowOnShowAction onShowAction returns nothing
			set this.m_onShowAction = onShowAction
		endmethod

		public method onShowAction takes nothing returns AMainWindowOnShowAction
			return this.m_onShowAction
		endmethod

		public method setOnHideCondition takes AMainWindowOnHideCondition onHideCondition returns nothing
			set this.m_onHideCondition = onHideCondition
		endmethod

		public method onHideCondition takes nothing returns AMainWindowOnHideCondition
			return this.m_onHideCondition
		endmethod

		public method setOnHideAction takes AMainWindowOnHideAction onHideAction returns nothing
			set this.m_onHideAction = onHideAction
		endmethod

		public method onHideAction takes nothing returns AMainWindowOnHideAction
			return this.m_onHideAction
		endmethod

		/**
		 * \param tooltipX If this value is less than 0.0 tooltip x will be set to corresponding widget's x.
		 */
		public method setTooltipX takes real tooltipX returns nothing
			set this.m_tooltipX = tooltipX
		endmethod

		public method tooltipX takes nothing returns real
			return this.m_tooltipX
		endmethod

		/**
		 * \param tooltipY If this value is less than 0.0 tooltip y will be set to corresponding widget's y.
		 */
		public method setTooltipY takes real tooltipY returns nothing
			set this.m_tooltipY = tooltipY
		endmethod

		public method tooltipY takes nothing returns real
			return this.m_tooltipY
		endmethod

		public method setTooltipBackgroundImageFilePath takes string tooltipBackgroundImageFilePath returns nothing
			set this.m_tooltipBackgroundImageFilePath = tooltipBackgroundImageFilePath
		endmethod

		public method tooltipBackgroundImageFilePath takes nothing returns string
			return this.m_tooltipBackgroundImageFilePath
		endmethod

		/**
		 * \param tooltipSoundPath Path of the sound which is played when player drags the cursor over the related object (which has its own tooltip). If this value is null there won't be played any sound.
		 */
		public method setTooltipSoundPath takes string tooltipSoundPath returns nothing
			set this.m_tooltipSoundPath = tooltipSoundPath
			if (tooltipSoundPath != null) then
				call PreloadSoundFile(tooltipSoundPath) //ALibraryEnvironmentSound
			endif
		endmethod

		public method tooltipSoundPath takes nothing returns string
			return this.m_tooltipSoundPath
		endmethod

		public method useShortcuts takes nothing returns boolean
			return this.m_useShortcuts
		endmethod

		public method useSpecialShortcuts takes nothing returns boolean
			return this.m_useSpecialShortcuts
		endmethod

		/**
		 * \param useShortcuts If true shortcuts and shortcut handler are enabled when windows is shown.
		 */
		public method setUseShortcuts takes boolean useShortcuts returns nothing
			if (this.useShortcuts() == useShortcuts) then
				return
			endif
			set this.m_useShortcuts = useShortcuts
			if (this.isShown.evaluate()) then
				if (useShortcuts) then
					call this.m_gui.enableShortcuts()
				else
					call this.m_gui.disableShortcuts()
					// enable them again
					if (this.useSpecialShortcuts()) then
						call this.m_gui.enableSpecialShortcuts()
					endif
				endif
			endif
		endmethod

		/**
		 * \param useSpecialShortcuts If this value is true and \p useShortcuts is not, special shortcuts will be still enabled. Otherwise, if \p useShortcuts is true, this value will be ignored.
		 */
		public method setUseSpecialShortcuts takes boolean useSpecialShortcuts returns nothing
			if (this.useSpecialShortcuts() == useSpecialShortcuts) then
				return
			endif
			set this.m_useSpecialShortcuts = useSpecialShortcuts
			if (this.isShown.evaluate()) then
				if (useSpecialShortcuts) then
					call this.m_gui.enableSpecialShortcuts()
				else
					call this.m_gui.disableSpecialShortcuts()
				endif
			endif
		endmethod

		public method shortcut takes nothing returns integer
			return this.m_shortcut
		endmethod

		private static method triggerActionPressShortcut takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger( GetTriggeringTrigger(), 0)
			if (not this.isShown.evaluate()) then
				call this.show.evaluate()
			else
				call this.hide.evaluate()
			endif
		endmethod

		private method createShortcutTrigger takes nothing returns nothing
			set this.m_shortcutTrigger = CreateTrigger()
			call TriggerRegisterKeyEventForPlayer(this.gui.evaluate().player(), this.m_shortcutTrigger, this.shortcut(), true)
			call TriggerAddAction(this.m_shortcutTrigger, function thistype.triggerActionPressShortcut)
			call AHashTable.global().setHandleInteger(this.m_shortcutTrigger, 0, this)
		endmethod

		private method destroyShortcutTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_shortcutTrigger)
			set this.m_shortcutTrigger = null
		endmethod

		/**
		 * \param shortcut If this shortcut is pressed by the corresponding player, main window opens for him. If this value is -1 main window won't have any shortcut.
		 */
		public method setShortcut takes integer shortcut returns nothing
			if (shortcut == this.shortcut()) then
				return
			endif
static if (DEBUG_MODE) then
				if (not KeyIsValid(shortcut)) then
					call this.print("Shortcut has no valid key value.")
				endif
endif
			set this.m_shortcut = shortcut
			if (this.m_shortcutTrigger != null) then
				call this.destroyShortcutTrigger()
			endif
			call this.createShortcutTrigger()
		endmethod

		// construction members

		public method gui takes nothing returns AGui
			return this.m_gui
		endmethod

		public method x takes nothing returns real
			return this.m_x
		endmethod

		public method y takes nothing returns real
			return this.m_y
		endmethod

		public method sizeX takes nothing returns real
			return this.m_sizeX
		endmethod

		public method sizeY takes nothing returns real
			return this.m_sizeY
		endmethod

		//members

		public method index takes nothing returns integer
			return this.m_index
		endmethod

		public method isShown takes nothing returns boolean
			return this.m_isShown
		endmethod

		//methods

		public method getX takes real x returns real
			return this.m_x + x
		endmethod

		public method getY takes real y returns real
			return this.m_y - y
		endmethod

		public method enableShortcut takes nothing returns nothing
			debug if (this.m_shortcut == -1) then
				debug call this.print("Main window does not use a shortcut.")
				debug return
			debug endif
			call EnableTrigger(this.m_shortcutTrigger)
		endmethod

		public method disableShortcut takes nothing returns nothing
			debug if (this.m_shortcut == -1) then
				debug call this.print("Main window does not use a shortcut.")
				debug return
			debug endif
			call DisableTrigger(this.m_shortcutTrigger)
		endmethod

		public method showTooltip takes AWidget whichWidget returns nothing
			local real x
			local real y
			if (this.m_tooltip == null) then
				set this.m_tooltip = CreateTextTag()
				call SetTextTagVisibility(this.m_tooltip, false)
			endif
			call SetTextTagTextBJ(this.m_tooltip, whichWidget.tooltip.evaluate(), whichWidget.tooltipSize.evaluate())

			if (this.m_tooltipX < 0.0) then
				set x = this.getX(whichWidget.x.evaluate())
			else
				set x = this.getX(this.m_tooltipX)
			endif

			if (this.m_tooltipY < 0.0) then
				set y = this.getY(whichWidget.y.evaluate())
			else
				set y = this.getY(this.m_tooltipY)
			endif

			call SetTextTagPos(this.m_tooltip, x, y, 0.0)
			call ShowTextTagForPlayer(this.gui().player(), this.m_tooltip, true)

			if (this.m_tooltipBackgroundImageFilePath != null) then // each time create a new image, since path could be changed
				if (this.m_tooltipBackground != null) then
					call DestroyImage(this.m_tooltipBackground)
					set this.m_tooltipBackground = null
				endif
				set this.m_tooltipBackground = CreateImageForPlayer(this.gui().player(), this.m_tooltipBackgroundImageFilePath, x, y, 0.0, 50.0, 50.0, true) /// \todo Setup correct size to tooltip text, should be higher than normal images

			endif
			if (this.tooltipSoundPath() != null) then
				call PlaySoundFileForPlayer(this.gui().player(), this.tooltipSoundPath())
			endif
		endmethod

		public method hideTooltip takes nothing returns nothing
			if (this.m_tooltip != null) then
				call ShowTextTagForPlayer(this.gui().player(), this.m_tooltip, false)
			endif
			if (this.m_tooltipBackground != null) then
				call DestroyImage(this.m_tooltipBackground)
				set this.m_tooltipBackground = null
			endif
		endmethod

		public stub method onShowCheck takes nothing returns boolean
			if (this.m_onShowCondition != 0) then
				return this.m_onShowCondition.evaluate(this)
			endif
			return true
		endmethod

		public stub method onShow takes nothing returns nothing
			if (this.m_onShowAction != 0) then
				call this.m_onShowAction.execute(this)
			endif
		endmethod

		public method show takes nothing returns nothing
			local real centerX = 0.0
			local real centerY = 0.0
			local integer i = 0
			if (not this.onShowCheck.evaluate()) then
				debug call this.print("Failed on show check")
				return
			endif
			set centerX = this.m_x + (this.m_sizeX / 2.0)
			set centerY = this.m_y - (this.m_sizeY / 2.0)
			call this.m_gui.savePlayerData()
			call FogModifierStop(this.m_blackMaskModifier)
			call FogModifierStart(this.m_visibilityModifier)
			call ClearScreenMessagesForPlayer(this.gui().player())
			call SetCameraPositionForPlayer(this.gui().player(), centerX, centerY)
			if (this.cameraSetup() != null) then
				debug call this.print("Has camera setup")
				call CameraSetupApplyForPlayer(false, this.cameraSetup(), this.gui().player(), 0.0)
			endif
			call SetCameraBoundsToAreaForPlayer(this.gui().player(), this.x(), this.y(), this.sizeX(), this.sizeY())
			// widgets
			set i = 0
			loop
				exitwhen (i == this.m_widgets.size())
				call AWidget(this.m_widgets[i]).show.evaluate()
				set i = i + 1
			endloop

			if (this.useShortcuts()) then
				call this.m_gui.enableShortcuts()
			elseif (this.useSpecialShortcuts()) then
				call this.m_gui.enableSpecialShortcuts()
			endif
			set this.m_isShown = true
			call this.m_gui.hideShownMainWindowAndSetNew(this)
			call this.onShow.execute()
		endmethod

		public stub method onHideCheck takes nothing returns boolean
			if (this.m_onHideCondition != 0) then
				return this.m_onHideCondition.evaluate(this)
			endif
			return true
		endmethod

		public stub method onHide takes nothing returns nothing
			if (this.m_onHideAction != 0) then
				call this.m_onHideAction.execute(this)
			endif
		endmethod

		public method hide takes nothing returns nothing
			local integer i
			if (not this.onHideCheck.evaluate()) then
				debug call this.print("Failed on hide check")
				return
			endif

			call ResetCameraBoundsToMapRectForPlayer(this.gui().player())
			call ResetToGameCameraForPlayer(this.gui().player(), 0.0)
			call FogModifierStop(this.m_visibilityModifier)
			call FogModifierStart(this.m_blackMaskModifier)
			call this.m_gui.loadPlayerData()
			call this.hideTooltip()
			//widgets
			set i = 0
			loop
				exitwhen (i == this.m_widgets.size())
				call AWidget(this.m_widgets[i]).hide.evaluate()
				set i = i + 1
			endloop

			if (this.useShortcuts()) then
				call this.m_gui.disableShortcuts()
			elseif (this.useSpecialShortcuts()) then
				call this.m_gui.disableSpecialShortcuts()
			endif
			set this.m_isShown = false
			call this.m_gui.resetShownMainWindow()
			call this.onHide.execute()
		endmethod

		/// Friend relationship to \ref AWidget, do not use.
		public method dockWidget takes AWidget usedWidget returns integer
			call this.m_widgets.pushBack(usedWidget)
			return this.m_widgets.backIndex()
		endmethod

		/// Friend relationship to \ref AWidget, do not use.
		public method undockWidgetByIndex takes integer index returns nothing
			call this.m_widgets.erase(index)
		endmethod

		/**
		 * \param x Top left edge x.
		 * \param y Top left edge y.
		 */
		public static method create takes AGui gui, real x, real y, real sizeX, real sizeY returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_cameraSetup = null
			set this.m_onShowCondition  = 0
			set this.m_onShowAction = 0
			set this.m_onHideCondition = 0
			set this.m_onHideAction = 0
			set this.m_tooltipX = -1.0
			set this.m_tooltipY = -1.0
			set this.m_tooltipBackgroundImageFilePath = null
			set this.m_tooltipSoundPath = null
			set this.m_useShortcuts = false
			set this.m_useSpecialShortcuts = true
			set this.m_shortcut = -1
			// construction members
			set this.m_gui = gui
static if (DEBUG_MODE) then
			if (not RectContainsCoords(GetPlayableMapRect(), x, y)) then
				call this.print("X and y aren't contained by playable map rect.")
			endif
endif
			set this.m_x = x //insert a debug if the coordinates are out of map range
			set this.m_y = y
static if (DEBUG_MODE) then
			if (not RectContainsCoords(GetPlayableMapRect(), x + sizeX, y - sizeY)) then
				call this.print("X size and y size aren't contained by playable map rect.")
			endif
endif
			set this.m_sizeX = sizeX
			set this.m_sizeY = sizeY
			// members
			set this.m_index = gui.dockMainWindow(this)
			set this.m_widgets = AIntegerVector.create()
			set this.m_tooltip = null
			set this.m_tooltipBackground = null
			set this.m_isShown = false
			set this.m_fogModifierRect = RectFromPointSize(this.m_x, this.m_y, this.m_sizeX, this.m_sizeY)
			set this.m_visibilityModifier = CreateFogModifierRect(this.gui().player(), FOG_OF_WAR_VISIBLE, this.m_fogModifierRect, false, false)
			set this.m_blackMaskModifier = CreateFogModifierRect(this.gui().player(), FOG_OF_WAR_MASKED, this.m_fogModifierRect, false, false)
			call FogModifierStart(this.m_blackMaskModifier)
			set this.m_shortcutTrigger = null

			return this
		endmethod

		public static method createByRectSize takes AGui gui, real x, real y, rect whichRect returns thistype
			return thistype.create(gui, x, y, GetRectWidthBJ(whichRect), GetRectHeightBJ(whichRect))
		endmethod

		public static method createByRect takes AGui gui, rect whichRect returns thistype
			return thistype.createByRectSize(gui, GetRectMinX(whichRect), GetRectMaxY(whichRect), whichRect)
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_gui.undockMainWindowByIndex(this.m_index)
			// members
			if (this.m_tooltip != null) then
				call DestroyTextTag(this.m_tooltip)
				set this.m_tooltip = null
			endif
			if (this.m_tooltipBackground != null) then
				call DestroyImage(this.m_tooltipBackground)
				set this.m_tooltipBackground = null
			endif
			call RemoveRect(this.m_fogModifierRect)
			set this.m_fogModifierRect = null
			call DestroyFogModifier(this.m_visibilityModifier)
			set this.m_visibilityModifier = null
			call DestroyFogModifier(this.m_blackMaskModifier)
			set this.m_blackMaskModifier = null

			if (this.m_shortcutTrigger != null) then
				call this.destroyShortcutTrigger()
			endif

			loop
				exitwhen (this.m_widgets.empty())
				call AWidget(this.m_widgets.back()).destroy.evaluate()
				/// \todo don't pop back, is in destructor, check for errors
			endloop
			call this.m_widgets.destroy()
		endmethod
	endstruct

endlibrary
