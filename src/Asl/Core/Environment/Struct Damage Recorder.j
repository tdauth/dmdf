library AStructCoreEnvironmentDamageRecorder requires optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable, AStructCoreGeneralVector

	/// \todo Should be a part of struct \ref ADamageRecorder, vJass bug.
	function interface ADamageRecorderOnDamageAction takes ADamageRecorder damageRecorder returns nothing

	/**
	 * \brief Provides damage recording functionality for a single unit target.
	 * The user is able to get all incurred damage of the unit target.
	 * Usually only the total incured damage is stored by using a simple real value.
	 * Consider that you can store the single damage sources and their given damage, too.
	 * To provide this functionality two vectors are used. Since their maximum could be reached very fast old sources at the beginning of the vectors are discarded when the maximum is reached. Total damage will still be correct!
	 * Use \ref thistype.setSaveData() to enable source and source values storing.
	 */
	struct ADamageRecorder
		// static constant members
		public static constant boolean defaultSaveData = true
		// static construction members
		private static boolean m_useGlobalDamageDetection
		private static ADamageRecorderOnDamageAction m_globalDamageDetectionOnDamageAction
		private static boolean m_saveDataByDefault
		// static members
		private static trigger m_globalDamageDetectionEnterTrigger
		private static trigger m_globalDamageDetectionLeaveTrigger
		private static trigger m_globalDamageDetectionDeathTrigger
		// dynamic members
		private ADamageRecorderOnDamageAction m_onDamageAction
		private boolean m_saveData = false
		// construction members
		private unit m_target
		// members
		private AUnitVector m_damageSources = 0
		private ARealVector m_damageAmounts = 0
		private real m_totalDamage
		private trigger m_damageTrigger

		//! runtextmacro optional A_STRUCT_DEBUG("\"ADamageRecorder\"")

		// dynamic members

		public method setOnDamageAction takes ADamageRecorderOnDamageAction onDamageAction returns nothing
			set this.m_onDamageAction = onDamageAction
		endmethod

		public method onDamageAction takes nothing returns ADamageRecorderOnDamageAction
			return this.m_onDamageAction
		endmethod

		/**
		 * \param saveData If this value is true damage sources and amounts will be saved.
		 * \sa saveData()
		 * \sa defaultSaveData
		 * \note If set to false the stored sources and amounts are discarded.
		 */
		public method setSaveData takes boolean saveData returns nothing
			if (this.m_saveData == saveData) then
				return
			endif
			set this.m_saveData = saveData
			if (saveData) then
				set this.m_damageSources = AUnitVector.create()
				set this.m_damageAmounts = ARealVector.create()
			else
				call this.m_damageSources.destroy()
				call this.m_damageAmounts.destroy()
			endif
		endmethod

		/**
		 * \return This value returns \ref defaultSaveData by default.
		 * \sa setSaveData()
		 */
		public method saveData takes nothing returns boolean
			return this.m_saveData
		endmethod

		// construction members

		public method target takes nothing returns unit
			return this.m_target
		endmethod

		// members

		public method damageSource takes integer index returns unit
			debug if (not this.checkIndex.evaluate(index)) then
				debug return null
			debug endif
			return this.m_damageSources[index]
		endmethod

		public method damageAmount takes integer index returns real
			debug if (not this.checkIndex.evaluate(index)) then
				debug return 0.0
			debug endif
			return this.m_damageAmounts[index]
		endmethod

		/**
		 * \return Returns the number of stored damage sources.
		 * \sa damageSource()
		 * \sa damageAmount()
		 */
		public method damageCount takes nothing returns integer
			return this.m_damageSources.size()
		endmethod

		/**
		 * \return Returns the total incurred damage of the unit target.
		 * \note Only valid if \ref saveData() returns true.
		 */
		public method totalDamage takes nothing returns real
			return this.m_totalDamage
		endmethod

		// methods

		/**
		 * Use \ref GetEventDamageSource() and \ref GetEventDamage() to get event properties.
		 * By default this method calls the user defined on damage action (\ref onDamageAction()) via .execute().
		 */
		public stub method onSufferDamage takes nothing returns nothing
			if (this.m_onDamageAction != 0) then
				call this.m_onDamageAction.execute(this)
			endif
		endmethod

		public method enable takes nothing returns nothing
			debug if (IsTriggerEnabled(this.m_damageTrigger)) then
				debug call this.print("Damage trigger has already been enabled before.")
				debug return
			debug endif
			call EnableTrigger(this.m_damageTrigger)
		endmethod

		public method disable takes nothing returns nothing
			debug if (not IsTriggerEnabled(this.m_damageTrigger)) then
				debug call this.print("Damage trigger has already been disabled before.")
				debug return
			debug endif
			call DisableTrigger(this.m_damageTrigger)
		endmethod

		public method isEnabled takes nothing returns boolean
			return IsTriggerEnabled(this.m_damageTrigger)
		endmethod

		public method setEnabled takes boolean enabled returns nothing
			if (enabled) then
				call this.enable()
			else
				call this.disable()
			endif
		endmethod

		debug private method checkIndex takes integer index returns boolean
			debug if (index < 0 or index >= this.m_damageSources.size()) then
				debug call this.print("Wrong index: " + I2S(index) + ".")
				debug return false
			debug endif
			debug return true
		debug endmethod

		private static method triggerActionDamaged takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			if (this.m_saveData) then
				if (this.m_damageSources.size() == AIntegerVector.maxSize()) then
					call this.m_damageSources.popFront()
					call this.m_damageAmounts.popFront()
				endif
				call this.m_damageSources.pushBack(GetEventDamageSource())
				call this.m_damageAmounts.pushBack(GetEventDamage())
				set this.m_totalDamage = this.m_totalDamage + GetEventDamage()
			endif
			call this.onSufferDamage()
		endmethod

		private method createDamageTrigger takes nothing returns nothing
			set this.m_damageTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_damageTrigger, this.m_target, EVENT_UNIT_DAMAGED)
			call TriggerAddAction(this.m_damageTrigger, function thistype.triggerActionDamaged)
			call AHashTable.global().setHandleInteger(this.m_damageTrigger, 0, this)
		endmethod

		public static method create takes unit target returns thistype
			local thistype this = thistype.allocate()
			debug if (target == null) then
				debug call this.print("Target is null.")
			debug endif
			// dynamic members
			set this.m_onDamageAction = 0
			call this.setSaveData(thistype.defaultSaveData)
			// construction members
			set this.m_target = target

			call this.createDamageTrigger()
			return this
		endmethod

		private method destroyDamageTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_damageTrigger)
			set this.m_damageTrigger = null
		endmethod

		public method onDestroy takes nothing returns nothing
			// construction members
			set this.m_target = null
			// members
			if (this.saveData()) then
				call this.m_damageSources.destroy()
				call this.m_damageAmounts.destroy()
			endif

			call this.destroyDamageTrigger()
		endmethod

		public static method isGlobalUnitRegistered takes unit whichUnit returns boolean
			debug if (not thistype.m_useGlobalDamageDetection) then
				debug call thistype.staticPrintMethodError("isGlobalUnitRegistered", "Global damage detection is not enabled.")
				debug return false
			debug endif
			return AHashTable.global().hasHandleInteger(whichUnit, A_HASHTABLE_KEY_GLOBALDAMAGERECORDER)
		endmethod

		public static method registerGlobalUnit takes unit whichUnit returns thistype
			local thistype this
			debug if (not thistype.m_useGlobalDamageDetection) then
				debug call thistype.staticPrintMethodError("registerGlobalUnit", "Global damage detection is not enabled.")
				debug return 0
			debug endif
			if (thistype.isGlobalUnitRegistered(whichUnit)) then
				return 0
			endif
			set this = thistype.create(whichUnit)
			call this.setOnDamageAction(thistype.m_globalDamageDetectionOnDamageAction)
			call this.setSaveData(thistype.m_saveDataByDefault) // TODO weak performance, just don't do it on construction
			call AHashTable.global().setHandleInteger(whichUnit, A_HASHTABLE_KEY_GLOBALDAMAGERECORDER, this)
			return this
		endmethod

		public static method unregisterGlobalUnit takes unit whichUnit returns boolean
			debug if (not thistype.m_useGlobalDamageDetection) then
				debug call thistype.staticPrintMethodError("unregisterGlobalUnit", "Global damage detection is not enabled.")
				debug return false
			debug endif
			if (not thistype.isGlobalUnitRegistered(whichUnit)) then
				return false
			endif
			call thistype(AHashTable.global().handleInteger(whichUnit, A_HASHTABLE_KEY_GLOBALDAMAGERECORDER)).destroy()
			call AHashTable.global().removeHandleInteger(whichUnit, A_HASHTABLE_KEY_GLOBALDAMAGERECORDER)
			return true
		endmethod

		public static method globalUnitDamageRecorder takes unit whichUnit returns thistype
			debug if (not thistype.m_useGlobalDamageDetection) then
				debug call thistype.staticPrintMethodError("globalUnitDamageRecorder", "Global damage detection is not enabled.")
				debug return 0
			debug endif
			return thistype(AHashTable.global().handleInteger(whichUnit, A_HASHTABLE_KEY_GLOBALDAMAGERECORDER))
		endmethod

		private static method groupFunctionRegister takes nothing returns nothing
			call thistype.registerGlobalUnit(GetEnumUnit())
		endmethod

		private static method unitIsNotDead takes nothing returns boolean
			return not IsUnitDeadBJ(GetFilterUnit())
		endmethod

		private static method registerAllUnitsInPlayableMap takes nothing returns nothing
			local group whichGroup = CreateGroup()
			call GroupEnumUnitsInRect(whichGroup, bj_mapInitialPlayableArea, Filter(function thistype.unitIsNotDead))
			call ForGroup(whichGroup, function thistype.groupFunctionRegister)
			call DestroyGroup(whichGroup)
			set whichGroup = null
		endmethod

		private static method triggerActionEnter takes nothing returns nothing
			call thistype.registerGlobalUnit(GetTriggerUnit())
		endmethod

		private static method triggerActionLeave takes nothing returns nothing
			call thistype.unregisterGlobalUnit(GetTriggerUnit())
		endmethod

		private static method triggerActionDeath takes nothing returns nothing
			if (not IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO)) then
				call thistype.unregisterGlobalUnit(GetTriggerUnit())
			endif
		endmethod

		/**
		 * \param useGlobalDamageDetection If this value is true there will be a global damage detection system which allows you acessing a damage recorder of every unit in map.
		 * \param globalDamageDetectionOnDamageAction Use this value to specify a default action which is set for every created global damage recorder.
		 * \param saveDataByDefault If this value is true data will be saved by default, otherwise it will be discared.
		 * \todo What's about dying units (should be removed from global damage detection? Heroes?!)
		 */
		public static method init takes boolean useGlobalDamageDetection, ADamageRecorderOnDamageAction globalDamageDetectionOnDamageAction, boolean saveDataByDefault returns nothing
			// static construction members
			set thistype.m_useGlobalDamageDetection = useGlobalDamageDetection
			set thistype.m_globalDamageDetectionOnDamageAction = globalDamageDetectionOnDamageAction
			set thistype.m_saveDataByDefault = saveDataByDefault

			if (thistype.m_useGlobalDamageDetection) then
				call thistype.registerAllUnitsInPlayableMap()

				set thistype.m_globalDamageDetectionEnterTrigger = CreateTrigger()
				call TriggerRegisterEnterRectSimple(thistype.m_globalDamageDetectionEnterTrigger, bj_mapInitialPlayableArea) /// \todo Leak
				call TriggerAddAction(thistype.m_globalDamageDetectionEnterTrigger, function thistype.triggerActionEnter)
				set thistype.m_globalDamageDetectionLeaveTrigger = CreateTrigger()
				call TriggerRegisterLeaveRectSimple(thistype.m_globalDamageDetectionLeaveTrigger, bj_mapInitialPlayableArea) /// \todo Leak

				set thistype.m_globalDamageDetectionDeathTrigger = CreateTrigger()
				call TriggerRegisterAnyUnitEventBJ(thistype.m_globalDamageDetectionDeathTrigger, EVENT_PLAYER_UNIT_DEATH)
				call TriggerAddAction(thistype.m_globalDamageDetectionDeathTrigger, function thistype.triggerActionDeath)
			endif
		endmethod
	endstruct

	hook RemoveUnit ADamageRecorder.unregisterGlobalUnit

endlibrary