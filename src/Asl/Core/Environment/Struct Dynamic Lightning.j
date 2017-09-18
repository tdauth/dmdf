library AStructCoreEnvironmentDynamicLightning requires optional ALibraryCoreDebugMisc, ALibraryCoreEnvironmentLightning, ALibraryCoreMathsHandle

	/**
	 * \brief Dynamic lightnings are lightnings which are being moved automatically between positions of to specific units.
	 * Besides they can be shown to a certain player only.
	 * The positions are updated by a static timer.
	 */
	struct ADynamicLightning
		// static construction members
		private static real m_refreshTime
		// static members
		private static AIntegerList m_dynamicLightnings
		private static timer m_refreshTimer
		private static boolean m_refreshTimerStarted
		// construction members
		private player m_player
		private string m_code
		// dynamic members
		private unit m_firstUnit
		private unit m_secondUnit
		private boolean m_destroyOnDeath
		private boolean m_isPaused
		// members
		private lightning m_lightning
		private AIntegerListIterator m_iterator

		//! runtextmacro optional A_STRUCT_DEBUG("\"ADynamicLightning\"")

		// construction members

		public method player takes nothing returns player
			return this.m_player
		endmethod

		public method code takes nothing returns string
			return this.m_code
		endmethod

		// dynamic members

		public method setFirstUnit takes unit firstUnit returns nothing
			set this.m_firstUnit = firstUnit
		endmethod

		public method firstUnit takes nothing returns unit
			return this.m_firstUnit
		endmethod

		public method setSecondUnit takes unit secondUnit returns nothing
			set this.m_secondUnit = secondUnit
		endmethod

		public method secondUnit takes nothing returns unit
			return this.m_secondUnit
		endmethod

		public method setDestroyOnDeath takes boolean destroyOnDeath returns nothing
			set this.m_destroyOnDeath = destroyOnDeath
		endmethod

		public method destroyOnDeath takes nothing returns boolean
			return this.m_destroyOnDeath
		endmethod

		public method setPaused takes boolean isPaused returns nothing
			set this.m_isPaused = isPaused
		endmethod

		public method isPaused takes nothing returns boolean
			return this.m_isPaused
		endmethod

		// methods

		/// Makes the dynamic lightning unpaused which means that it will be moved next time when the periodic trigger moves all unpaused dynamic lightnings.
		public method continue takes nothing returns nothing
			set this.m_isPaused = true
		endmethod

		/// A paused dynamic lightning won't be moved until it gets unpaused.
		public method pause takes nothing returns nothing
			set this.m_isPaused = false
		endmethod

		public method setLightningColor takes real red, real green, real blue, real alpha returns boolean
			return SetLightningColor(this.m_lightning, red, green, blue, alpha)
		endmethod

		public method lightningColorRed takes nothing returns real
			return GetLightningColorR(this.m_lightning)
		endmethod

		public method lightningColorGreen takes nothing returns real
			return GetLightningColorG(this.m_lightning)
		endmethod

		public method lightningColorBlue takes nothing returns real
			return GetLightningColorB(this.m_lightning)
		endmethod

		public method lightningColorAlpha takes nothing returns real
			return GetLightningColorA(this.m_lightning)
		endmethod

		private method move takes nothing returns nothing
			if (this.destroyOnDeath() and (IsUnitDeadBJ(this.firstUnit()) or IsUnitDeadBJ(this.secondUnit()))) then
				call this.destroy()
			else
				call MoveLightningEx(this.m_lightning, false, GetUnitX(this.firstUnit()), GetUnitY(this.firstUnit()), GetUnitZ(this.firstUnit()), GetUnitX(this.secondUnit()), GetUnitY(this.secondUnit()), GetUnitZ(this.secondUnit()))
			endif
		endmethod

		/**
		 * Creates a new dynamic lightning between two units.
		 * \param whichPlayer If whichPlayer is null, dynamic lightning will be visible for all players.
		 * \param usedCode Must be a valid lightning code like "CLPB". Look into the corresponding SLK file.
		 */
		public static method create takes player whichPlayer, string usedCode, unit firstUnit, unit secondUnit returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_player = whichPlayer
			set this.m_code = usedCode
			// dynamic members
			set this.m_firstUnit = firstUnit
			set this.m_secondUnit = secondUnit
			set this.m_destroyOnDeath = true
			set this.m_isPaused = false
			// members
			if (this.m_player == null) then
				set this.m_lightning = AddLightningEx(this.m_code, false, GetUnitX(this.m_firstUnit), GetUnitY(this.m_firstUnit), GetUnitZ(this.m_firstUnit), GetUnitX(this.m_secondUnit), GetUnitY(this.m_secondUnit), GetUnitZ(this.m_secondUnit))
			else
				set this.m_lightning = CreateLightningForPlayer(this.m_player, this.m_code, GetUnitX(this.m_firstUnit), GetUnitY(this.m_firstUnit), GetUnitZ(this.m_firstUnit), GetUnitX(this.m_secondUnit), GetUnitY(this.m_secondUnit), GetUnitZ(this.m_secondUnit))
			endif
			call thistype.m_dynamicLightnings.pushBack(this)
			set this.m_iterator = thistype.m_dynamicLightnings.end()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// static members
			call thistype.m_dynamicLightnings.erase(this.m_iterator)

			// construction members
			set this.m_player = null
			// dynamic members
			set this.m_firstUnit = null
			set this.m_secondUnit = null
			// members
			call DestroyLightning(this.m_lightning)
			set this.m_lightning = null
		endmethod

		private static method timerFunctionRefresh takes nothing returns nothing
			local thistype dynamicLighting = 0
			local AIntegerListIterator iterator = thistype.m_dynamicLightnings.begin()
			loop
				exitwhen (not iterator.isValid())
				set dynamicLighting = thistype(iterator.data())
				if (not dynamicLighting.isPaused()) then
					call dynamicLighting.move()
				endif
			endloop
			call iterator.destroy()
		endmethod

		/**
		 * Enables the refresh timer which updates the positions of all dynamic lightnings.
		 */
		public static method enable takes nothing returns nothing
			if (not thistype.m_refreshTimerStarted) then
				set thistype.m_refreshTimerStarted = true
				call TimerStart(thistype.m_refreshTimer, thistype.m_refreshTime, true, function thistype.timerFunctionRefresh)
			endif
		endmethod

		/**
		 * Disables the refresh timer which updates the positions of all dynamic lightnings.
		 */
		public static method disable takes nothing returns nothing
			if (thistype.m_refreshTimerStarted) then
				set thistype.m_refreshTimerStarted = false
				call PauseTimer(thistype.m_refreshTimer)
			endif
		endmethod

		/**
		 * Initializes the dynamic lightning system. This is required before creating any dynamic lightning since it creates and starts the refresh timer.
		 * \param refreshTime The time in seconds which is the interval in which all dynamic lightnings positions are updated.
		 */
		public static method init takes real refreshTime returns nothing
			debug if (refreshTime <= 0.0) then
				debug call thistype.staticPrint("Wrong value refresh time value in ADynamicLightning struct initialization: " + R2S(refreshTime) + ".")
			debug endif
			// static construction members
			set thistype.m_refreshTime = refreshTime
			// static members
			set thistype.m_dynamicLightnings = AIntegerList.create()
			set thistype.m_refreshTimer = CreateTimer()
			set thistype.m_refreshTimerStarted = false
			call thistype.enable()
		endmethod

		public static method cleanUp takes nothing returns nothing
			call PauseTimer(thistype.m_refreshTimer)
			call DestroyTimer(thistype.m_refreshTimer)
			set thistype.m_refreshTimer = null
			//remove all missiles
			loop
				exitwhen (thistype.m_dynamicLightnings.empty())
				call thistype(thistype.m_dynamicLightnings.back()).destroy()
			endloop
			call thistype.m_dynamicLightnings.destroy()
		endmethod

		// static construction members

		public static method refreshTime takes nothing returns real
			return thistype.m_refreshTime
		endmethod
	endstruct

endlibrary