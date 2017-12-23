library AStructSystemsWorldItemSpawnPoint requires ALibraryCoreEnvironmentSound, AInterfaceSystemsWorldSpawnPointInterface,  optional ALibraryCoreDebugMisc, AStructCoreGeneralHashTable

	/**
	 * \brief Item spawn points allow to place items from an item pool in a given period of time whenever they are picked up or destroyed.
	 *
	 * Use \ref addItemType() to add any item type with a specific weight to the pool.
	 * The constructor \ref createFromItemWithType() can be used to create a spawn point using an existing item and adding its type.
	 *
	 * \sa ASpawnPoint
	 */
	struct AItemSpawnPoint extends ASpawnPointInterface
		// dynamic members
		private real m_time
		private real m_x
		private real m_y
		private string m_effectFilePath
		private string m_soundFilePath
		// members
		private itempool m_itemPool
		private item m_item
		private timer m_timer
		private boolean m_isEnabled
		private boolean m_runs // required because of restarting before finishing!
		private trigger m_pickUpTrigger
		private trigger m_deathTrigger

		//! runtextmacro A_STRUCT_DEBUG("\"AItemSpawnPoint\"")
		
		// dynamic members
		
		/**
		 * \param time This is the value of the time (in seconds) which has to expired until the item is respawned.
		 */
		public method setTime takes real time returns nothing
			set this.m_time = time
		endmethod
		
		public method time takes nothing returns real
			return this.m_time
		endmethod
		
		public method setX takes real x returns nothing
			set this.m_x = x
		endmethod
		
		public method x takes nothing returns real
			return this.m_x
		endmethod
		
		public method setY takes real y returns nothing
			set this.m_y = y
		endmethod

		public method y takes nothing returns real
			return this.m_y
		endmethod
		
		/**
		 * \param effectFilePath File fath of the effect which is shown when the units respawn. If this value is null there won't be shown any effect.
		 */
		public method setEffectFilePath takes string effectFilePath returns nothing
			set this.m_effectFilePath = effectFilePath
		endmethod
		
		public method effectFilePath takes nothing returns string
			return this.m_effectFilePath
		endmethod
		
		/**
		 * \param soundFilePath File path of the sound which is played when the units respawn. If this value is null there won't be played any sound.
		 */
		public method setSoundFilePath takes string soundFilePath returns nothing
			set this.m_soundFilePath = soundFilePath
		endmethod
	
		public method soundFilePath takes nothing returns string
			return this.m_soundFilePath
		endmethod
		
		// members

		public method item takes nothing returns item
			return this.m_item
		endmethod

		public method isEnabled takes nothing returns boolean
			return this.m_isEnabled
		endmethod

		public method addItemType takes integer itemTypeId, real weight returns nothing
			call ItemPoolAddItemType(this.m_itemPool, itemTypeId, weight)
		endmethod

		public method removeItemType takes integer itemTypeId returns nothing
			call ItemPoolRemoveItemType(this.m_itemPool, itemTypeId)
		endmethod

		public method remainingTime takes nothing returns real
			if (this.m_timer == null) then
				return 0.0
			endif
			return TimerGetRemaining(this.m_timer)
		endmethod

		/**
		 * \return Returns true if the timer for the respawn is running.
		 */
		public method runs takes nothing returns boolean
			return this.m_runs
		endmethod

		/**
		 * Pauses the respawn if it does already run.
		 * \return Returns true if the timer has been paused. Otherwise if the timer does not run it returns false.
		 * \sa runs()
		 */
		public method pause takes nothing returns boolean
			if (not this.runs()) then
				return false
			endif
			call PauseTimer(this.m_timer)
			return true
		endmethod

		public method resume takes nothing returns boolean
			if (not this.runs()) then
				return false
			endif
			call ResumeTimer(this.m_timer)
			return true
		endmethod

		public method enable takes nothing returns nothing
			set this.m_isEnabled = true
			call this.resume()
		endmethod

		public method disable takes nothing returns nothing
			set this.m_isEnabled = false
			call this.pause()
		endmethod
		
		private static method triggerConditionDeath takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
	
			return GetTriggerWidget() == this.m_item
		endmethod
		
		private static method triggerActionDeath takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			
			call this.respawn.evaluate()
		endmethod
		
		private method createDeathTrigger takes nothing returns nothing
			set this.m_deathTrigger = CreateTrigger()
			call TriggerRegisterDeathEvent(this.m_deathTrigger, this.m_item)
			call TriggerAddCondition(this.m_deathTrigger, Condition(function thistype.triggerConditionDeath))
			call TriggerAddAction(this.m_deathTrigger, function thistype.triggerActionDeath)
			call AHashTable.global().setHandleInteger(this.m_deathTrigger, 0, this)
		endmethod
		
		private method destroyDeathTrigger takes nothing returns nothing
			if (this.m_deathTrigger != null) then
				call AHashTable.global().destroyTrigger(this.m_deathTrigger)
				set this.m_deathTrigger = null
			endif
		endmethod

		public method spawn takes nothing returns boolean
			local effect whichEffect = null
			if (this.m_item != null) then
				return false
			endif
			set this.m_item = PlaceRandomItem(this.m_itemPool, this.m_x, this.m_y)
			
			debug if (this.m_item == null) then
				debug call this.print("Could not spawn item.")
			debug endif
			
			if (this.m_item != null) then
				call EnableTrigger(this.m_pickUpTrigger)
				call this.createDeathTrigger()
				
				if (this.effectFilePath() != null) then
					set whichEffect = AddSpecialEffect(this.effectFilePath(), GetItemX(this.m_item), GetItemX(this.m_item))
					call DestroyEffect(whichEffect)
					set whichEffect = null
				endif
				if (this.soundFilePath() != null) then
					call PlaySoundFileAt(this.soundFilePath(), GetItemX(this.m_item), GetItemY(this.m_item), GetItemZ(this.m_item))
				endif
				
				return true
			endif
			
			return false
		endmethod
		
		private static method timerFunctionRespawn takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetExpiredTimer(), 0)
			call this.spawn()
			set this.m_runs = false
		endmethod

		private method respawn takes nothing returns nothing
			debug call this.print("Starting respawn with item: " + GetItemName(this.m_item) + " with time " + R2S(this.time()))
			call DisableTrigger(this.m_pickUpTrigger)
			call this.destroyDeathTrigger()
			set this.m_item = null
			if (this.m_timer == null) then
				set this.m_timer = CreateTimer()
				call AHashTable.global().setHandleInteger(this.m_timer, 0, this)
			endif
			call TimerStart(this.m_timer, this.time(), false, function thistype.timerFunctionRespawn)
			set this.m_runs = true
		endmethod
		
		private static method triggerConditionPickUp takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
	
			return GetManipulatedItem() == this.m_item
		endmethod
		
		private static method triggerActionPickUp takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			
			call this.respawn()
		endmethod

		/**
		 * Creates a new item spawn point using \p x and \p y as coordinates and \p whichItem as initially spawned item.
		 * \param whichItem If this value is null the respawn has to be started manually at any time.
		 */
		public static method create takes real x, real y, item whichItem returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_time = 60.0
			set this.m_x = x
			set this.m_y = y
			set this.m_effectFilePath = null
			set this.m_soundFilePath = null
			// members
			set this.m_itemPool = CreateItemPool()
			set this.m_item = whichItem
			set this.m_timer = null
			set this.m_isEnabled = true
			set this.m_runs = false
			
			set this.m_pickUpTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_pickUpTrigger, EVENT_PLAYER_UNIT_PICKUP_ITEM)
			call TriggerAddCondition(this.m_pickUpTrigger, Condition(function thistype.triggerConditionPickUp))
			call TriggerAddAction(this.m_pickUpTrigger, function thistype.triggerActionPickUp)
			call AHashTable.global().setHandleInteger(this.m_pickUpTrigger, 0, this)
			
			if (whichItem != null) then
				call this.createDeathTrigger()
			endif

			return this
		endmethod

		/**
		 * Respawn will be started immediately after creation.
		 */
		public static method createWithoutItem takes real x, real y, integer itemTypeId, real weight returns thistype
			local thistype this = thistype.create(x, y, null)
			call this.addItemType(itemTypeId, weight)
			
			return this
		endmethod
		
		public static method createFromItemWithType takes item whichItem, real weight returns thistype
			local thistype this = thistype.create(GetItemX(whichItem), GetItemY(whichItem), whichItem)
			call this.addItemType(GetItemTypeId(whichItem), weight)
			
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			set this.m_effectFilePath = null
			set this.m_soundFilePath = null
			call DestroyItemPool(this.m_itemPool)
			set this.m_itemPool = null
			set this.m_item = null
			if (this.m_timer != null) then
				call PauseTimer(this.m_timer)
				call AHashTable.global().destroyTimer(this.m_timer)
				set this.m_timer = null
			endif
			call AHashTable.global().destroyTrigger(this.m_pickUpTrigger)
			set this.m_pickUpTrigger = null
			call this.destroyDeathTrigger()
		endmethod
	endstruct

endlibrary