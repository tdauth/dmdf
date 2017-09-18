library AStructCoreEnvironmentMissile requires optional ALibraryCoreDebugMisc, AStructCoreGeneralList, ALibraryCoreMathsHandle, ALibraryCoreMathsPoint, ALibraryCoreMathsReal, ALibraryCoreMathsUnit, ALibraryCoreInterfaceSelection

	/// OnDeathFunction functions can by set by method \ref AMissileType.setOnDeathFunction and will be called when missile hits target.
	function interface AMissileTypeOnDeathFunction takes AMissile missile returns nothing

	/**
	 * \brief Missile types can be used for one or several missiles. They determine the missile's behaviour.
	 */
	struct AMissileType
		private player m_owner
		private integer m_unitType
		private real m_speed
		private real m_maxHeight
		private boolean m_targetSeeking
		private real m_collisionRadius
		private boolean m_destroyOnDeath
		private string m_deathEffectPath
		private string m_startSoundPath
		private string m_deathSoundPath
		private AMissileTypeOnDeathFunction m_onDeathFunction

		public method setOwner takes player owner returns nothing
			set this.m_owner = owner
		endmethod

		public method owner takes nothing returns player
			return this.m_owner
		endmethod

		public method setUnitType takes integer unitType returns nothing
			set this.m_unitType = unitType
		endmethod

		public method unitType takes nothing returns integer
			return this.m_unitType
		endmethod

		/**
		 * \param speed Distance per second (without gravitational acceleration).
		 */
		public method setSpeed takes real speed returns nothing
			set this.m_speed = speed * AMissile.refreshTime.evaluate()
		endmethod

		public method speed takes nothing returns real
			return this.m_speed
		endmethod

		public method setMaxHeight takes real maxHeight returns nothing
			set this.m_maxHeight = maxHeight
		endmethod

		public method maxHeight takes nothing returns real
			return this.m_maxHeight
		endmethod

		public method setTargetSeeking takes boolean targetSeeking returns nothing
			set this.m_targetSeeking = targetSeeking
		endmethod

		public method targetSeeking takes nothing returns boolean
			return this.m_targetSeeking
		endmethod

		/**
		 * The collision radius is used at the target point or widget. When the missile reaches its target at this radius it will collide and therefore stop.
		 * @{
		 */
		public method setCollisionRadius takes real collisionRadius returns nothing
			set this.m_collisionRadius = collisionRadius
		endmethod

		public method collisionRadius takes nothing returns real
			return this.m_collisionRadius
		endmethod
		/**
		 * @}
		 */

		/**
		 * If this value is true, the missile will be destroyed when it reaches its target and "dies".
		 *
		 * @{
		 */
		public method setDestroyOnDeath takes boolean destroyOnDeath returns nothing
			set this.m_destroyOnDeath = destroyOnDeath
		endmethod

		public method destroyOnDeath takes nothing returns boolean
			return this.m_destroyOnDeath
		endmethod
		/**
		 * @}
		 */

		public method setDeathEffectPath takes string deathEffectPath returns nothing
			set this.m_deathEffectPath = deathEffectPath
		endmethod

		public method deathEffectPath takes nothing returns string
			return this.m_deathEffectPath
		endmethod

		public method setStartSoundPath takes string startSoundPath returns nothing
			set this.m_startSoundPath = startSoundPath
		endmethod

		public method startSoundPath takes nothing returns string
			return this.m_startSoundPath
		endmethod

		public method setDeathSoundPath takes string deathSoundPath returns nothing
			set this.m_deathSoundPath = deathSoundPath
		endmethod

		public method deathSoundPath takes nothing returns string
			return this.m_deathSoundPath
		endmethod

		/**
		 * @{
		 * The onDeathFunction is called whenever the missile is stopped. It is called with .evaluate().
		 */
		public method setOnDeathFunction takes AMissileTypeOnDeathFunction onDeathFunction returns nothing
			set this.m_onDeathFunction = onDeathFunction
		endmethod

		public method onDeathFunction takes nothing returns AMissileTypeOnDeathFunction
			return this.m_onDeathFunction
		endmethod
		/**
		 * @}
		 */

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_owner = null
			set this.m_unitType = 'hfoo'
			set this.m_speed = 100.0
			set this.m_maxHeight = 100.0
			set this.m_targetSeeking = false
			set this.m_collisionRadius = 30.0
			set this.m_destroyOnDeath = false
			set this.m_deathEffectPath = null
			set this.m_startSoundPath = null
			set this.m_deathSoundPath = null
			set this.m_onDeathFunction = 0
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// dynamic members
			set this.m_owner = null
		endmethod
	endstruct

	/**
	 * \brief Provides the functionality of a single physical missile which can have a specific missile type, a widget source and target or three coordinate values (x, y and z).
	 * All missiles are moved by a timer at a certain periodical interval.
	 * To provide a graphic for the missile you have to create a custom unit type with the graphic as model.
	 * For simiplification it does not use any gravity. It just uses a parabola function to deterimne the curve.
	 * \todo Collision between missiles?!
	 * \author Tamino Dauth
	 */
	struct AMissile
		// static construction members
		private static real m_refreshTime
		// static members
		private static AIntegerList m_missiles
		private static timer m_refreshTimer
		private static boolean m_refreshTimerStarted
		// dynamic members
		private AMissileType m_missileType
		private real m_targetX
		private real m_targetY
		private real m_targetZ
		private widget m_targetWidget
		private boolean m_isPaused
		// members
		private unit m_unit
		private real m_startX
		private real m_startY
		private real m_startDistance
		private AIntegerListIterator m_iterator

		//! runtextmacro optional A_STRUCT_DEBUG("\"AMissile\"")

		// dynamic members

		public method setMissileType takes AMissileType missileType returns nothing
			set this.m_missileType = missileType
		endmethod

		public method missileType takes nothing returns AMissileType
			return this.m_missileType
		endmethod

		public method setTargetX takes real targetX returns nothing
			set this.m_targetX = targetX
		endmethod

		public method targetX takes nothing returns real
			return this.m_targetX
		endmethod

		public method setTargetY takes real targetY returns nothing
			set this.m_targetY = targetY
		endmethod

		public method targetY takes nothing returns real
			return this.m_targetY
		endmethod

		public method setTargetZ takes real targetZ returns nothing
			set this.m_targetZ = targetZ
		endmethod

		public method targetZ takes nothing returns real
			return this.m_targetZ
		endmethod

		public method setTargetWidget takes widget targetWidget returns nothing
			set this.m_targetWidget = targetWidget
		endmethod

		public method targetWidget takes nothing returns widget
			return this.m_targetWidget
		endmethod

		public method setPaused takes boolean isPaused returns nothing
			set this.m_isPaused = isPaused
		endmethod

		public method isPaused takes nothing returns boolean
			return this.m_isPaused
		endmethod

		// members

		public method unit takes nothing returns unit
			return this.m_unit
		endmethod

		public method startX takes nothing returns real
			return this.m_startX
		endmethod

		public method startY takes nothing returns real
			return this.m_startY
		endmethod

		public method startDistance takes nothing returns real
			return this.m_startDistance
		endmethod

		// convenience methods

		public method startFromUnit takes unit whichUnit returns nothing
			call this.start.evaluate(GetUnitX(whichUnit), GetUnitY(whichUnit), 0.0)
		endmethod

		public method startFromUnitZ takes unit whichUnit returns nothing
			call this.start.evaluate(GetUnitX(whichUnit), GetUnitY(whichUnit), GetUnitZ(whichUnit))
		endmethod

		/// Makes the missile unpaused which means that it will be moved next time when the periodic trigger moves all unpaused missiles.
		public method continue takes nothing returns nothing
			set this.m_isPaused = true
		endmethod

		/// A paused missile won't be moved until it gets unpaused.
		public method pause takes nothing returns nothing
			set this.m_isPaused = false
		endmethod

		// public methods

		/**
		 * \return Returns the current X coordinate of the missile.
		 */
		public method x takes nothing returns real
			return GetUnitX(this.m_unit)
		endmethod

		/**
		 * \return Returns the current Y coordinate of the missile.
		 */
		public method y takes nothing returns real
			return GetUnitY(this.m_unit)
		endmethod

		/**
		 * \return Returns the current Z coordinate of the missile.
		 */
		public method z takes nothing returns real
			return GetUnitZ(this.m_unit)
		endmethod

		private method angleBetweenTarget takes real x, real y returns real
			if (this.m_targetWidget != null) then
				return GetAngleBetweenPoints(x, y, GetWidgetX(this.m_targetWidget), GetWidgetY(this.m_targetWidget))
			else
				return GetAngleBetweenPoints(x, y, this.m_targetX, this.m_targetY)
			endif
		endmethod

		private method distanceBetweenTarget takes real x, real y returns real
			if (this.m_targetWidget != null) then
				return GetDistanceBetweenPointsWithoutZ(x, y, GetWidgetX(this.m_targetWidget), GetWidgetY(this.m_targetWidget))
			else
				return GetDistanceBetweenPointsWithoutZ(x, y, this.m_targetX, this.m_targetY)
			endif
		endmethod

		/// Starts the missile from coordinates \p x, \p y, and \p z.
		public method start takes real x, real y, real z returns nothing
			local real angle = this.angleBetweenTarget(x, y)
			debug if (not this.isPaused()) then
				debug call this.print("Missile has already been started.")
				debug return
			debug endif
			debug if (this.m_missileType == 0) then
				debug call this.print("Can't start with missile type 0.")
			debug endif
			set this.m_unit = CreateUnit(this.m_missileType.owner(), this.m_missileType.unitType(), x, y, angle)
			call SetUnitInvulnerable(this.m_unit, true)
			call MakeUnitSelectable(this.m_unit, false)
			call MakeUnitFlyable(this.m_unit)
			call SetUnitZ(this.m_unit, z)
			set this.m_startX = x
			set this.m_startY = y
			set this.m_startDistance = this.distanceBetweenTarget(x, y)
			set this.m_isPaused = false
			if (this.m_missileType.startSoundPath() != null) then
				call PlaySoundFileAt(this.m_missileType.startSoundPath(), x, y, z)
			endif
		endmethod

		/**
		 * Stops the missile.
		 * This means that the missile will be destroyed, damage will be distributed, a death effect will be shown,
		 * a death sound will be played and the death function will be executed.
		 */
		public method stop takes nothing returns nothing
			local effect whichEffect
			if (this.m_missileType.deathEffectPath() != null) then
				set whichEffect = AddSpecialEffect(this.m_missileType.deathEffectPath(), GetUnitX(this.m_unit), GetUnitY(this.m_unit)) /// \todo Can't use Z value with special effects.
				call DestroyEffect(whichEffect)
				set whichEffect = null
			endif
			if (this.m_missileType.deathSoundPath() != null) then
				call PlaySoundFileAt(this.m_missileType.deathSoundPath(), GetUnitX(this.m_unit), GetUnitY(this.m_unit), GetUnitZ(this.m_unit))
			endif
			call KillUnit(this.m_unit)
			call RemoveUnit(this.m_unit)
			set this.m_unit = null
			set this.m_isPaused = true
			/*
			 * Call user-defined event handler function to run user-defined code.
			 */
			if (this.m_missileType.onDeathFunction() != 0) then
				call this.m_missileType.onDeathFunction().evaluate(this)
			endif
			if (this.m_missileType.destroyOnDeath()) then
				call this.destroy()
			endif
		endmethod

		// private methods

		private method move takes nothing returns nothing
			local rect mapRect = GetPlayableMapRect()
			local real currentX = GetUnitX(this.m_unit)
			local real currentY = GetUnitY(this.m_unit)
			local real angle = GetUnitFacing(this.m_unit)
			local real newX
			local real newY
			local real newZ
			local integer i

			// if it is not target seeking, it just moves into the direction where it started to
			if (this.m_missileType.targetSeeking()) then
				set angle = this.angleBetweenTarget(currentX, currentY)
				call SetUnitFacing(this.m_unit, angle)
			endif
			set newX = GetPolarProjectionX(currentX, angle, this.m_missileType.speed())
			set newY = GetPolarProjectionY(currentY, angle, this.m_missileType.speed())

			if (RectContainsCoords(mapRect, newX, newY) and not IsTerrainPathable(newX, newY, PATHING_TYPE_WALKABILITY)) then // not since the function returns the inverse result
				// if it is not target seeking it stops at the distance but in its initial direction
				if (not this.missileType().targetSeeking() and GetDistanceBetweenPointsWithoutZ(newX, newY, this.startX(), this.startY()) >= this.startDistance()) then
					call this.stop()
				// hits target widget
				elseif (this.m_targetWidget != null and GetDistanceBetweenPointsWithoutZ(newX, newY, GetWidgetX(this.m_targetWidget), GetWidgetY(this.m_targetWidget)) <= this.missileType().collisionRadius()) then
					call this.stop()
				// hits target point
				elseif (GetDistanceBetweenPointsWithoutZ(newX, newY, this.targetX(), this.targetY()) <= this.missileType().collisionRadius()) then
					call this.stop()
				// normal movement, no collision, no target
				else
					set newZ = ParabolaZ(this.m_missileType.maxHeight(), this.startDistance(), newX)
					call SetUnitX(this.m_unit, newX)
					call SetUnitY(this.m_unit, newY)
					call SetUnitZ(this.m_unit, newZ)
				endif
			// out of map rect
			else
				debug call this.print("Reached map bounds")
				call this.stop()
			endif
			set mapRect = null
		endmethod

		public static method create takes nothing returns AMissile
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_missileType = 0
			set this.m_isPaused = true
			// members
			set this.m_unit = null
			set this.m_startX = 0.0
			set this.m_startY = 0.0
			set this.m_startDistance = 0.0
			call thistype.m_missiles.pushBack(this)
			set this.m_iterator = thistype.m_missiles.end()
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// static members
			call thistype.m_missiles.erase(this.m_iterator)
			// members
			if (this.m_unit != null) then
				call RemoveUnit(this.m_unit)
			endif
			set this.m_unit = null
		endmethod

		private static method timerFunctionRefresh takes nothing returns nothing
			local AIntegerListIterator iterator = thistype.m_missiles.begin()
			loop
				exitwhen (not iterator.isValid())
				if (not thistype(iterator.data()).isPaused()) then
					call thistype(iterator.data()).move()
				endif
			endloop
			call iterator.destroy()
		endmethod

		public static method enable takes nothing returns nothing
			if (not thistype.m_refreshTimerStarted) then
				set thistype.m_refreshTimerStarted = true
				call TimerStart(thistype.m_refreshTimer, thistype.m_refreshTime, true, function thistype.timerFunctionRefresh)
			endif
		endmethod

		public static method disable takes nothing returns nothing
			if (thistype.m_refreshTimerStarted) then
				set thistype.m_refreshTimerStarted = false
				call PauseTimer(thistype.m_refreshTimer)
			endif
		endmethod

		public static method init takes real refreshTime returns nothing
			debug if (refreshTime <= 0.0) then
				debug call thistype.staticPrint("Wrong value refresh time value in AMissile struct initialization: " + R2S(refreshTime) + ".")
			debug endif
			// static construction members
			set thistype.m_refreshTime = refreshTime
			// static members
			set thistype.m_missiles = AIntegerList.create()
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
				exitwhen (thistype.m_missiles.empty())
				call thistype(thistype.m_missiles.back()).destroy()
			endloop
			call thistype.m_missiles.destroy()
		endmethod

		// static construction members

		public static method refreshTime takes nothing returns real
			return thistype.m_refreshTime
		endmethod
	endstruct

	/**
	 * \brief Example missile type which causes damage to the target point or target widget.
	 */
	struct ADamageMissileType extends AMissileType
		// dynamic members
		private real m_damage
		private real m_damageRange
		private unit m_damageSource
		private attacktype m_attackType
		private damagetype m_damageType
		private weapontype m_weaponType

		public method setDamage takes real damage returns nothing
			set this.m_damage = damage
		endmethod

		public method damage takes nothing returns real
			return this.m_damage
		endmethod

		public method setDamageRange takes real damageRange returns nothing
			set this.m_damageRange = damageRange
		endmethod

		public method damageRange takes nothing returns real
			return this.m_damageRange
		endmethod

		public method setDamageSource takes unit damageSource returns nothing
			set this.m_damageSource = damageSource
		endmethod

		public method damageSource takes nothing returns unit
			return this.m_damageSource
		endmethod

		public method setAttackType takes attacktype attackType returns nothing
			set this.m_attackType = attackType
		endmethod

		public method attackType takes nothing returns attacktype
			return this.m_attackType
		endmethod

		public method setDamageType takes damagetype damageType returns nothing
			set this.m_damageType = damageType
		endmethod

		public method damageType takes nothing returns damagetype
			return this.m_damageType
		endmethod

		public method setWeaponType takes weapontype weaponType returns nothing
			set this.m_weaponType = weaponType
		endmethod

		public method weaponType takes nothing returns weapontype
			return this.m_weaponType
		endmethod

		private static method onDeathFunctionDamage takes AMissile missile returns nothing
			local ADamageMissileType this = ADamageMissileType(missile.missileType())
			if (this.damage() <= 0.0) then
				return
			endif
			if (this.damageRange() > 0.0) then
				call UnitDamagePoint(this.damageSource(), 0.0, this.damageRange(), GetUnitX(missile.unit()), GetUnitY(missile.unit()), this.damage(), true, false, this.attackType(), this.damageType(), this.weaponType())
				//cause area damage to units who aren't allies of the source unit
			elseif (missile.targetWidget.evaluate() != null) then
				call UnitDamageTarget(this.damageSource(), missile.targetWidget(), this.damage(), true, false, this.attackType(), this.damageType(), this.weaponType())
				//cause single target damage if missile hits widget otherwise show floating text?
			endif
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_damage = 0.0
			set this.m_damageRange = 0.0
			set this.m_damageSource = null
			set this.m_attackType = ATTACK_TYPE_NORMAL
			set this.m_damageType = DAMAGE_TYPE_NORMAL
			set this.m_weaponType = WEAPON_TYPE_WHOKNOWS

			call this.setOnDeathFunction(thistype.onDeathFunctionDamage)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// dynamic members
			set this.m_damageSource = null
			set this.m_attackType = null
			set this.m_damageType = null
			set this.m_weaponType = null
		endmethod
	endstruct

endlibrary
