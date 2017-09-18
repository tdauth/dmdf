library AStructSystemsCharacterBuff requires AStructCoreGeneralHashTable, AStructCoreGeneralVector

	// TODO leaks on units, hook RemoveUnit and DeathEvent
	/**
	 * \brief Stores the number of buffs for one single unit.
	 */
	private struct BuffCounter
		private unit m_unit
		private AGlobalHashTable m_hashtable /// Stores for every allocated buff the count
		private integer m_guard /// If this value becomes 0 or less on decrement the buff counter is auto destroyed since the unit has no more buffs

		public method count takes ABuff whichBuff returns integer
			return this.m_hashtable.integer(whichBuff, 0)
		endmethod

		public method increment takes ABuff whichBuff returns integer
			local integer result =  this.m_hashtable.integer(whichBuff, 0) + 1
			call this.m_hashtable.setInteger(whichBuff, 0, result)
			set this.m_guard = this.m_guard + 1
			return result
		endmethod

		public method decrement takes ABuff whichBuff returns integer
			local integer result = this.m_hashtable.integer(whichBuff, 0) - 1
			call this.m_hashtable.setInteger(whichBuff, 0, result)
			set this.m_guard = this.m_guard - 1
			if (this.m_guard <= 0) then
				call this.destroy()
			endif
			return result
		endmethod

		public static method create takes unit whichUnit returns thistype
			local thistype this = thistype.allocate()
			set this.m_unit = whichUnit
			set this.m_hashtable = AHashTable.create()
			set this.m_guard = 0

			call AHashTable.global().setHandleInteger(whichUnit, A_HASHTABLE_KEY_BUFFCOUNTER, this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call AHashTable.global().removeHandleInteger(this.m_unit, A_HASHTABLE_KEY_BUFFCOUNTER)
			set this.m_unit = null
			call this.m_hashtable.destroy()
		endmethod

		public static method unitBuffCounter takes unit whichUnit returns thistype
			return BuffCounter(AHashTable.global().handleInteger(whichUnit, A_HASHTABLE_KEY_BUFFCOUNTER))
		endmethod
	endstruct

	/**
	 * Provides acces to buff type which can be added as buff instance several times to one single unit.
	 * Buff ID should be a custom ability ID of an aura which only affects the caster himself to create real buff effect in Warcraft III.
	 * A useful ability is 'Aasl' which allows you to create positive and negative buffs depending on its real value.
	 * \note If you remove a unit and \ref thistype.remove() is never called te stored buff counter leaks.
	 */
	struct ABuff
		// construction members
		private integer m_buffId
		// members
		private AUnitVector m_targets
		private integer m_index

		public stub method onAdd takes unit source, unit whichUnit, integer index returns nothing
		endmethod

		public stub method onRemove takes unit source, unit whichUnit, integer index returns nothing
		endmethod

		/**
		 * Use this method to check whether specific buff effects should be removed from unit.
		 */
		public method count takes unit whichUnit returns integer
			local BuffCounter buffCounter = BuffCounter.unitBuffCounter(whichUnit)
			if (buffCounter == 0) then
				return 0
			endif
			debug call Print("Before getting count")
			return buffCounter.count(this)
		endmethod

		private method getCounterOnRequest takes unit whichUnit returns BuffCounter
			local BuffCounter buffCounter = BuffCounter.unitBuffCounter(whichUnit)
			if (buffCounter == 0) then
				set buffCounter = BuffCounter.create(whichUnit)
			endif

			return buffCounter
		endmethod

		public method add takes unit source, unit whichUnit returns integer
			local BuffCounter buffCounter = this.getCounterOnRequest(whichUnit)
			local integer count = buffCounter.count(this)
			debug call Print("ABuff count of unit " + GetUnitName(whichUnit) + ": " + I2S(count))
			call this.m_targets.pushBack(whichUnit)
			if (count == 0) then
				debug call Print("ABuff Adding ability: " + GetObjectName(this.m_buffId))
				call UnitAddAbility(whichUnit, this.m_buffId)
				call UnitMakeAbilityPermanent(whichUnit, true, this.m_buffId) // bleibt auch bei Verwandlungen
			endif
			call buffCounter.increment(this)
			call this.onAdd.evaluate(source, whichUnit, count - 1)
			return this.m_targets.backIndex()
		endmethod

		public method remove takes unit source, unit whichUnit returns nothing
			local BuffCounter buffCounter = this.getCounterOnRequest(whichUnit)
			local integer count = buffCounter.count(this)
			call this.onRemove.evaluate(source, whichUnit, count)
			call this.m_targets.remove(whichUnit)
			if (buffCounter.decrement(this) == 0) then // auto destroys the buff counter if the guard is 0
				debug call Print("ABuff Removing ability: " + GetObjectName(this.m_buffId))
				call UnitRemoveAbility(whichUnit, this.m_buffId)
			endif
		endmethod

		public static method create takes integer buffId returns thistype
			local thistype this = thistype.allocate()
			set this.m_buffId = buffId
			set this.m_targets = AUnitVector.create()
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_targets.destroy()
			// TODO clean from all targets
		endmethod
	endstruct

endlibrary