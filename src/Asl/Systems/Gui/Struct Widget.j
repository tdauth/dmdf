library AStructSystemsGuiWidget requires ALibraryCoreInterfaceTrackable, ALibraryCoreEnvironmentSound, AStructSystemsGuiGui, AStructSystemsGuiMainWindow

	/// \todo Should be a static method of \ref AWidget, vJass bug.
	function interface AWidgetOnHitAction takes AWidget usedWidget returns nothing

	/// \todo Should be a static method of \ref AWidget, vJass bug.
	function interface AWidgetOnTrackAction takes AWidget usedWidget returns nothing

	struct AWidget
		// static construction members
		private static string m_onHitSoundPath
		private static string m_onTrackSoundPath
		// dynamic members
		private boolean m_shown
		private integer m_shortcut // Wenn das Tastenkürzel gedr?ckt wird, wird auch die onHitFunction ausgeführt. Die Tastenkürzel werden über eine ausgewählte Einheit mit entsprechenden Fähigkeiten gesteuert.
		private string m_tooltip
		private real m_tooltipSize
		// construction members
		private AMainWindow m_mainWindow
		private real m_x
		private real m_y
		private real m_sizeX
		private real m_sizeY
		private string m_modelFilePath
		private AWidgetOnHitAction m_onHitAction
		private AWidgetOnTrackAction m_onTrackAction
		// members
		private integer m_index
		private trackable m_trackable
		private trigger m_onHitTrigger
		private trigger m_onTrackTrigger

		private method enableOnHitTrigger takes nothing returns nothing
			if (this.m_onHitAction != 0) then
				call EnableTrigger(this.m_onHitTrigger)
			endif
		endmethod

		private method enableOnTrackTrigger takes nothing returns nothing
			if (this.m_onTrackAction != 0) then
				call EnableTrigger(this.m_onTrackTrigger)
			endif
		endmethod

		public stub method show takes nothing returns nothing
			call this.enableOnHitTrigger()
			call this.enableOnTrackTrigger()
			set this.m_shown = true
		endmethod

		private method disableOnHitTrigger takes nothing returns nothing
			if (this.m_onHitAction != 0) then
				call DisableTrigger(this.m_onHitTrigger)
			endif
		endmethod

		private method disableOnTrackTrigger takes nothing returns nothing
			if (this.m_onTrackAction != 0) then
				call DisableTrigger(this.m_onTrackTrigger)
			endif
		endmethod

		public stub method hide takes nothing returns nothing
			call this.disableOnHitTrigger()
			call this.disableOnTrackTrigger()
			set this.m_shown = false
		endmethod

		//dynamic members

		public method setShown takes boolean shown returns nothing
			if (this.m_shown == shown) then
				return
			endif
			if (shown) then
				call this.show()
			else
				call this.hide()
			endif
		endmethod

		public method isShown takes nothing returns boolean
			return this.m_shown
		endmethod

		/// Important: Set all shortcuts when before showing the GUI.
		/// When hiding the GUI all shortcut actions will be reseted (because of the different main windows).
		public method setShortcut takes integer shortcut returns nothing
			//clear old action
			if (this.m_shortcut != 0) then
				call this.m_mainWindow.gui().setOnPressShortcutAction(shortcut, 0, 0)
			endif
			set this.m_shortcut = shortcut
			if (this.m_onHitAction != 0) then
				call this.m_mainWindow.gui().setOnPressShortcutAction(shortcut, this.m_onHitAction, this)
			endif
		endmethod

		public method shortcut takes nothing returns integer
			return this.m_shortcut
		endmethod

		public method setTooltip takes string tooltip returns nothing
			set this.m_tooltip = tooltip
		endmethod

		public method tooltip takes nothing returns string
			return this.m_tooltip
		endmethod

		public method setTooltipSize takes real tooltipSize returns nothing
			set this.m_tooltipSize = tooltipSize
		endmethod

		public method tooltipSize takes nothing returns real
			return this.m_tooltipSize
		endmethod

		// construction members

		public method mainWindow takes nothing returns AMainWindow
			return this.m_mainWindow
		endmethod

		/// Friend relation to \ref ALayout, do not use since widgets are static!
		public method setX takes real x returns nothing
			set this.m_x = x
		endmethod

		public method x takes nothing returns real
			return this.m_x
		endmethod

		/// Friend relation to \ref ALayout, do not use since widgets are static!
		public method setY takes real y returns nothing
			set this.m_y = y
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

		public method modelFilePath takes nothing returns string
			return this.m_modelFilePath
		endmethod

		// members

		public method index takes nothing returns integer
			return this.m_index
		endmethod

		// methods

		private method createTrackable takes nothing returns nothing
			if ((this.m_onHitAction != 0) or (this.m_onTrackAction != 0)) then
				set this.m_trackable = CreateTrackableForPlayer(this.m_mainWindow.gui().player(), this.m_modelFilePath, this.m_mainWindow.getX(this.m_x), this.m_mainWindow.getY(this.m_y), 0.0)
			endif
		endmethod

		private static method triggerActionOnHit takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, 0)
			call this.m_onHitAction.execute(this)
			if (thistype.m_onHitSoundPath != null) then
				call PlaySoundFileForPlayer(this.m_mainWindow.gui().player(), thistype.m_onHitSoundPath)
			endif
			set triggeringTrigger = null
		endmethod

		private method createOnHitTrigger takes nothing returns nothing
			local event triggerEvent
			local triggeraction triggerAction
			if (this.m_onHitAction != 0) then
				set this.m_onHitTrigger = CreateTrigger()
				set triggerEvent = TriggerRegisterTrackableHitEvent(this.m_onHitTrigger, this.m_trackable)
				set triggerAction = TriggerAddAction(this.m_onHitTrigger, function thistype.triggerActionOnHit)
				call AHashTable.global().setHandleInteger(this.m_onHitTrigger, 0, this)
				set triggerEvent = null
				set triggerAction = null
			endif
		endmethod

		private static method triggerActionOnTrack takes nothing returns nothing
			local trigger triggeringTrigger = GetTriggeringTrigger()
			local thistype this = AHashTable.global().handleInteger(triggeringTrigger, 0)
			call this.m_onTrackAction.execute(this)
			if (thistype.m_onTrackSoundPath != null) then
				call PlaySoundFileForPlayer(this.m_mainWindow.gui().player(), thistype.m_onTrackSoundPath)
			endif
			set triggeringTrigger = null
		endmethod

		private method createOnTrackTrigger takes nothing returns nothing
			local event triggerEvent
			local triggeraction triggerAction
			if (this.m_onTrackAction != 0) then
				set this.m_onTrackTrigger = CreateTrigger()
				set triggerEvent = TriggerRegisterTrackableTrackEvent(this.m_onTrackTrigger, this.m_trackable)
				set triggerAction = TriggerAddAction(this.m_onTrackTrigger, function thistype.triggerActionOnTrack)
				call AHashTable.global().setHandleInteger(this.m_onTrackTrigger, 0, this)
				set triggerEvent = null
				set triggerAction = null
			endif
		endmethod

		/**
		 * \param modelFilePath Model file path for the trackable model. If there aren't any onHitActions or onTrackActions this value could be null.
		 */
		public static method create takes AMainWindow mainWindow, real x, real y, real sizeX, real sizeY, string modelFilePath, AWidgetOnHitAction onHitAction, AWidgetOnTrackAction onTrackAction returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_shown = false
			// construction members
			set this.m_mainWindow = mainWindow
			set this.m_x = x
			set this.m_y = y
			set this.m_sizeX = sizeX
			set this.m_sizeY = sizeY
			set this.m_modelFilePath = modelFilePath
			set this.m_onHitAction = onHitAction
			set this.m_onTrackAction = onTrackAction
			// members
			set this.m_index = mainWindow.dockWidget(this)

			call this.createTrackable()
			call this.createOnHitTrigger()
			call this.createOnTrackTrigger()
			return this
		endmethod

		public static method createSimple takes AMainWindow mainWindow, real x, real y, real sizeX, real sizeY returns thistype
			return thistype.create(mainWindow, x, y, sizeX, sizeY, null, 0, 0)
		endmethod

		private method destroyTrackable takes nothing returns nothing
			if ((this.m_onHitAction != 0) or (this.m_onTrackAction != 0)) then
				//we can't destroy trackables :-[
				set this.m_trackable = null
			endif
		endmethod

		private method destroyOnHitTrigger takes nothing returns nothing
			if (this.m_onHitAction != 0) then
				call AHashTable.global().destroyTrigger(this.m_onHitTrigger)
				set this.m_onHitTrigger = null
			endif
		endmethod

		private method destroyOnTrackTrigger takes nothing returns nothing
			if (this.m_onTrackAction != 0) then
				call AHashTable.global().destroyTrigger(this.m_onTrackTrigger)
				set this.m_onTrackTrigger = null
			endif
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_mainWindow.undockWidgetByIndex(this.m_index)
			call this.destroyOnHitTrigger()
			call this.destroyOnTrackTrigger()
		endmethod

		public static method init takes string onHitSoundPath, string onTrackSoundPath returns nothing
			set thistype.m_onHitSoundPath = onHitSoundPath
			set thistype.m_onTrackSoundPath = onTrackSoundPath

			if (onHitSoundPath != null) then
				call PreloadSoundFile(onHitSoundPath)
			endif
			if (onTrackSoundPath != null) then
				call PreloadSoundFile(onTrackSoundPath)
			endif
		endmethod

		/**
		* Use this method as track action if you want to have the generic tooltip.
		* You can also use another track action and call this method in your custom action.
		*/
		public static method onTrackActionShowTooltip takes AWidget whichWidget returns nothing
			call whichWidget.m_mainWindow.showTooltip(whichWidget)
		endmethod
	endstruct

endlibrary