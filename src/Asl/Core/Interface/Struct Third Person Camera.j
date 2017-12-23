library AStructCoreInterfaceThirdPersonCamera requires AStructCoreInterfaceArrowKeys

	/**
	 * \brief Adds a dynamic third person camera to the game.
	 * Its main purpose is to enable the user a highly configurable camera without the usual
	 * limitations of third person cameras. Using this camera you can basically use any kind
	 * of terrain on your map without caring about the cam falling below the terrain or
	 * clipping parts of the terrain.
	 * Note that you have to initialize \ref AArrowKeys before initializing this structure.
	 * Thanks to Wc3C.net user Opossum for this great system!
	 * \author Opossum
	 * \author Tamino Dauth (only the adaption for the ASL)
	 * <a href="http://www.wc3c.net/showthread.php?t=104786">Wc3C.net thread</a>
	 */
	struct AThirdPersonCamera
		private static constant real distanceAoaMin = -15.0
		private static constant real distanceDistanceMin = 300.0
		private static constant real distanceAoaMax = -65.0
		private static constant real distanceDistanceMax = 500.0
		private static constant real offsetAoaMin = -35.0
		private static constant real offsetOffsetMin = 0.0
		private static constant real offsetAoaMax = -70.0
		private static constant real offsetOffsetMax = 150.0
		private static constant real zOffset = 100.0
		private static constant real timeout = 0.1
		private static constant real terrainSampling = 32
		private static constant real panDuration = 0.5
		private static constant real angleAboveTerrain = 15.0
		private static constant real defaultAoa = -20.0
		private static constant real defaultRot = 0.0
		private static constant real fieldOfView = 120.0
		private static constant real farZ = 5000.0
		private static constant real cliffDistance = 500.0
		// key settings
		private static constant boolean inverted = false
		private static constant real minAoa = -65.0
		private static constant real maxAoa = 0.0
		private static constant real maxRot = 105.0
		private static constant real aoaInterval = 3.0
		private static constant real rotInterval = 7.5
		// static construction members
		private static boolean m_useArrowKeys
		// static members
		private static thistype array m_playerThirdPersonCamera[12] /// \todo bj_MAX_PLAYERS
		private static location m_location
		private static real m_distanceM
		private static real m_distanceT
		private static real m_offsetM
		private static real m_offsetT
		private static timer m_timer
		// dynamic members
		private real m_camAoa
		private real m_camRot
		// construction members
		private player m_player
		// members
		private unit m_unit
		private boolean m_isEnabled
		private timer m_firstPan

		// dynamic members

		public method setCamAoa takes real camAoa returns nothing
			set this.m_camAoa = camAoa
		endmethod

		public method camAoa takes nothing returns real
			return this.m_camAoa
		endmethod

		public method setCamRot takes real camRot returns nothing
			set this.m_camRot = camRot
		endmethod

		public method camRot takes nothing returns real
			return this.m_camRot
		endmethod

		// construction members

		public method player takes nothing returns player
			return this.m_player
		endmethod

		// members

		public method unit takes nothing returns unit
			return this.m_unit
		endmethod

		public method isEnabled takes nothing returns boolean
			return this.m_isEnabled
		endmethod

		//methods

		public method disable takes nothing returns nothing
			if (TimerGetRemaining(this.m_firstPan) > 0.0) then
				call PauseTimer(this.m_firstPan)
			endif
			set this.m_unit = null
			set this.m_isEnabled = false
		endmethod

		/// Functions for distance and offset. These are linear mathematical functions y = mx+t.
		private static method interpolateDistance takes real angleOfAttack returns real
			if (angleOfAttack <= thistype.distanceAoaMax * bj_DEGTORAD) then
				return thistype.distanceDistanceMax
			elseif (angleOfAttack >= thistype.distanceAoaMin * bj_DEGTORAD) then
				return thistype.distanceDistanceMin
			endif
			return thistype.m_distanceM * angleOfAttack + thistype.m_distanceT
		endmethod

		private static method interpolateOffset takes real angleOfAttack returns real
			if (angleOfAttack <= thistype.offsetAoaMax * bj_DEGTORAD) then
				return thistype.offsetOffsetMax
			elseif (angleOfAttack >= thistype.offsetAoaMin * bj_DEGTORAD) then
				return thistype.offsetOffsetMin
			endif
			return thistype.m_offsetM * angleOfAttack + thistype.m_offsetT
		endmethod

		private static method cappedReal takes real r, real lowBound, real highBound returns real
			if r < lowBound then
				return lowBound
			elseif r > highBound then
				return highBound
			endif
			return r
		endmethod

		private method applyCam takes real duration returns nothing
			local real aoa = GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK) - 2 * bj_PI
			local real offset = thistype.interpolateOffset(aoa)
			local real newaoa
			local real maxd
			local real tarz
			local real newx
			local real newy
			local real newm
			local real maxm = -1
			local real r = thistype.terrainSampling
			local real dx
			local real dy

			if (thistype.m_useArrowKeys) then
				if (thistype.inverted) then
					set this.m_camRot = thistype.cappedReal(this.m_camRot + (AArrowKeys.playerArrowKeys(this.m_player).horizontal() + AArrowKeys.playerArrowKeys(this.m_player).horizontalQuickPress()) * thistype.rotInterval, -thistype.maxRot, thistype.maxRot)
				else
					set this.m_camRot = thistype.cappedReal(this.m_camRot - (AArrowKeys.playerArrowKeys(this.m_player).horizontal() + AArrowKeys.playerArrowKeys(this.m_player).horizontalQuickPress()) * thistype.rotInterval, -thistype.maxRot, thistype.maxRot)
				endif
				call AArrowKeys.playerArrowKeys(this.m_player).setHorizontalQuickPress(0)
				set this.m_camAoa = thistype.cappedReal(this.m_camAoa - (AArrowKeys.playerArrowKeys(this.m_player).vertical() + AArrowKeys.playerArrowKeys(this.m_player).verticalQuickPress()) * thistype.aoaInterval, thistype.minAoa, thistype.maxAoa)
				call AArrowKeys.playerArrowKeys(this.m_player).setVerticalQuickPress(0)
			endif

			call SetCameraField(CAMERA_FIELD_ROTATION, GetUnitFacing(this.m_unit) + this.m_camRot, duration)
			call SetCameraField(CAMERA_FIELD_FIELD_OF_VIEW, thistype.fieldOfView, duration)
			call SetCameraField(CAMERA_FIELD_FARZ, thistype.farZ, duration)
			call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, thistype.interpolateDistance(aoa), duration)

			call PanCameraToTimed(GetUnitX(this.m_unit) + offset * Cos(bj_DEGTORAD*GetUnitFacing(this.m_unit)), GetUnitY(this.m_unit) + offset * Sin(bj_DEGTORAD*GetUnitFacing(this.m_unit)), duration)

			set newx = GetCameraTargetPositionX()
			set newy = GetCameraTargetPositionY()
			set maxd = thistype.cliffDistance + GetCameraField(CAMERA_FIELD_TARGET_DISTANCE)
			set dx = -Cos(GetCameraField(CAMERA_FIELD_ROTATION))*r
			set dy = -Sin(GetCameraField(CAMERA_FIELD_ROTATION))*r

			call MoveLocation(thistype.m_location, newx, newy)
			set tarz = GetCameraTargetPositionZ()
			call SetCameraField(CAMERA_FIELD_ZOFFSET, GetCameraField(CAMERA_FIELD_ZOFFSET) + GetLocationZ(thistype.m_location) + thistype.zOffset + GetUnitFlyHeight(this.m_unit) - tarz, duration)

			loop
				exitwhen (r > maxd)
				set newx = newx + dx
				set newy = newy + dy
				call MoveLocation(thistype.m_location, newx, newy)
				set newm = (GetLocationZ(thistype.m_location) - tarz) / r
				if (newm > maxm) then
					set maxm = newm
				endif
				set r = r + thistype.terrainSampling
			endloop
			set newaoa = - Atan(maxm) * bj_RADTODEG - thistype.angleAboveTerrain
			if (this.m_camAoa < newaoa) then
				set newaoa = this.m_camAoa
			endif
			call SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, newaoa, duration)
		endmethod

		public method enable takes unit whichUnit, real firstPan returns nothing
			if (this.isEnabled()) then
				call this.disable()
			endif
			set this.m_unit = whichUnit
			set this.m_isEnabled = true
			call TimerStart(this.m_firstPan, firstPan, false, null)
			if (GetLocalPlayer() == this.m_player) then
				call StopCamera()
				if (whichUnit != null) then
					call this.applyCam(firstPan)
				endif
			endif
		endmethod

		public method pause takes nothing returns nothing
			call PauseTimer(this.m_firstPan)
			set this.m_isEnabled = false
		endmethod

		public method resume takes nothing returns nothing
			call ResumeTimer(this.m_firstPan)
			set this.m_isEnabled = true
		endmethod

		public method resetCamAoa takes nothing returns nothing
			set this.m_camAoa = thistype.defaultAoa
		endmethod

		public method resetCamRot takes nothing returns nothing
			set this.m_camRot = thistype.defaultRot
		endmethod

		private static method create takes player usedPlayer returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_camAoa = thistype.defaultAoa
			set this.m_camRot = thistype.defaultRot
			// construction members
			set this.m_player = usedPlayer
			// members
			set this.m_unit = null
			set this.m_isEnabled = false
			set this.m_firstPan = CreateTimer()
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// construction members
			set this.m_player = null
			// members
			set this.m_unit = null
			call PauseTimer(this.m_firstPan)
			call DestroyTimer(this.m_firstPan)
			set this.m_firstPan = null
		endmethod

		private static method timerFunctionRefresh takes nothing returns nothing
			local player localPlayer = GetLocalPlayer()
			local integer playerId = GetPlayerId(localPlayer)
			if (thistype.m_playerThirdPersonCamera[playerId] != 0 and thistype.m_playerThirdPersonCamera[playerId].m_isEnabled) then
				if (TimerGetRemaining(thistype.m_playerThirdPersonCamera[playerId].m_firstPan) <= thistype.panDuration) then
					call thistype.m_playerThirdPersonCamera[playerId].applyCam(thistype.panDuration)
				else
					call thistype.m_playerThirdPersonCamera[playerId].applyCam(TimerGetRemaining(thistype.m_playerThirdPersonCamera[playerId].m_firstPan))
				endif
			endif
		endmethod

		public static method init takes boolean useArrowKeys returns nothing
			// static construction members
			set thistype.m_useArrowKeys = useArrowKeys
			// static members
			set thistype.m_location = Location(0,0)
			set thistype.m_distanceM = (thistype.distanceDistanceMax-thistype.distanceDistanceMin)/((thistype.distanceAoaMax - thistype.distanceAoaMin)*bj_DEGTORAD)
			set thistype.m_distanceT = thistype.distanceDistanceMin-thistype.distanceAoaMin*bj_DEGTORAD*thistype.m_distanceM
			set thistype.m_offsetM = (thistype.offsetOffsetMax-thistype.offsetOffsetMin)/((thistype.offsetAoaMax-thistype.offsetAoaMin)*bj_DEGTORAD)
			set thistype.m_offsetT = thistype.offsetOffsetMin-thistype.offsetAoaMin*bj_DEGTORAD* thistype.m_offsetM
			set thistype.m_timer = CreateTimer()
			call TimerStart(thistype.m_timer, thistype.timeout, true, function thistype.timerFunctionRefresh)
		endmethod

		public static method cleanUp takes nothing returns nothing
			call PauseTimer(thistype.m_timer)
			call RemoveLocation(thistype.m_location)
			set thistype.m_location = null
			call DestroyTimer(thistype.m_timer)
			set thistype.m_timer = null
		endmethod

		public static method playerThirdPersonCamera takes player user returns thistype
			if (thistype.m_playerThirdPersonCamera[GetPlayerId(user)] == 0) then
				set thistype.m_playerThirdPersonCamera[GetPlayerId(user)] = thistype.create(user)
			endif
			return thistype.m_playerThirdPersonCamera[GetPlayerId(user)]
		endmethod
	endstruct

endlibrary