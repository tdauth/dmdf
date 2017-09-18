library AStructSystemsMeleeUnitSpawn requires AStructCoreGeneralHashTable, AStructSystemsMeleeIdSet

	/**
	 * \brief A simple unit spawn as normally placed in the terrain editor but can be modified via code dynamically.
	 * Can be used for buildings and usual units.
	 * Following properties do not affect buildings:
	 * <ul>
	 * <li>face</li>
	 * <li>is in camp (acquire range)</li>
	 * </ul>
	 * \todo Maybe add spawn on map start support.
	 */
	struct AUnitSpawn
		private player m_player
		private location m_location
		private real m_face
		private real m_lifePercentage
		private boolean m_isInCamp
		/// Since it creates exactly one single unit it needs only a set not a table
		private AIdSet m_set

		debug private timer m_timer
		debug private unit m_unit
		debug private effect m_effect

		public method setPlayer takes player whichPlayer returns nothing
			set this.m_player = whichPlayer
		endmethod

		public method player takes nothing returns player
			return this.m_player
		endmethod

		public method setLocation takes location whichLocation returns nothing
			set this.m_location = whichLocation
		endmethod

		public method location takes nothing returns location
			return this.m_location
		endmethod

		public method setFace takes real face returns nothing
			set this.m_face = face
		endmethod

		public method face takes nothing returns real
			return this.m_face
		endmethod

		public method setLifePercentage takes real percentage returns nothing
			set this.m_lifePercentage = percentage
		endmethod

		public method lifePercentage takes nothing returns real
			return this.m_lifePercentage
		endmethod

		public method setIsInCamp takes boolean isInCamp returns nothing
			set this.m_isInCamp = isInCamp
		endmethod

		public method isInCamp takes nothing returns boolean
			return this.m_isInCamp
		endmethod

		public method setSet takes AIdSet whichSet returns nothing
			set this.m_set = whichSet
		endmethod

		public method getSet takes nothing returns AIdSet
			return this.m_set
		endmethod

		private method createUnit takes nothing returns unit
			if (this.m_set == 0) then
				return null
			endif
			return CreateUnit(this.m_player, this.m_set.generate(), GetLocationX(this.location()), GetLocationY(this.location()), this.face())
		endmethod

		public stub method onSpawn takes nothing returns unit
			local unit result = this.createUnit()
			if (result == null) then
				return null
			endif
			call SetUnitLifePercentBJ(result, this.lifePercentage())
			if (this.isInCamp() and not IsUnitType(result, UNIT_TYPE_STRUCTURE)) then
				call SetUnitAcquireRange(result, 200.0)
			endif
			call this.onSpawnUnit.evaluate(result)
			return result
		endmethod

		public stub method onSpawnUnit takes unit whichUnit returns nothing
		endmethod

static if (DEBUG_MODE) then
		private method removeUnit takes nothing returns nothing
			if (this.m_unit != null) then
				call RemoveUnit(this.m_unit)
				set this.m_unit = null
				call DestroyEffect(this.m_effect)
				set this.m_effect = null
			endif
		endmethod

		private static method timerFunction takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetExpiredTimer(), 0)
			call this.removeUnit()
			set this.m_unit = this.createUnit()
			if (this.m_unit != null) then
				call PauseUnit(this.m_unit, true)
				call SetUnitInvulnerable(this.m_unit, true)
				set this.m_effect = AddSpecialEffectTarget("Objects\\RandomObjects\\RandomObject.mdl", this.m_unit, "overhead")
				if (this.isInCamp()) then
					call SetUnitVertexColor(this.m_unit, 0, 0, 255, 0)
				endif
			endif
		endmethod

		public method show takes nothing returns nothing
			if (this.m_timer == null) then
				set this.m_timer = CreateTimer()
				call TimerStart(this.m_timer, 2.0, true, function thistype.timerFunction)
				call AHashTable.global().setHandleInteger(this.m_timer, 0, this)
			endif
		endmethod

		public method hide takes nothing returns nothing
			if (this.m_timer != null) then
				call PauseTimer(this.m_timer)
				call AHashTable.global().destroyTimer(this.m_timer)
				set this.m_timer = null
				call this.removeUnit()
			endif
		endmethod
endif

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			set this.m_player = Player(PLAYER_NEUTRAL_AGGRESSIVE)
			set this.m_location = null
			set this.m_face = 0.0
			set this.m_lifePercentage = 100.0
			set this.m_isInCamp = false
			set this.m_set = 0

			debug set this.m_timer = null
			debug set this.m_unit = null
			debug set this.m_effect = null

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			debug if (this.m_timer != null) then
			debug call PauseTimer(this.m_timer)
			debug call AHashTable.global().destroyTimer(this.m_timer)
			debug set this.m_timer = null
			debug endif
			debug call this.removeUnit()
		endmethod

	endstruct

endlibrary