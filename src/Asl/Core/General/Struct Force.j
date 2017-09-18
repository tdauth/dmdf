library AStructCoreGeneralForce requires AStructCoreGeneralVector

	/**
	 * Some kind of wrapper structure for native JASS type \ref force.
	 * Simplifies member access by providing an instance of \ref APlayerVector which holds all force members.
	 * Additionally it provides various methods which provide same functionality as native and BJ functions.
	 * \sa AGroup
	 * \sa wrappers
	 */
	struct AForce
		// members
		private APlayerVector m_players

		// members

		public method players takes nothing returns APlayerVector
			return this.m_players
		endmethod

		// methods

		/**
		 * Fills force \p whichForce with all belonging players.
		 */
		public method fillForce takes force whichForce returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				call ForceAddPlayer(whichForce, this.m_players[i])
				set i = i + 1
			endloop
		endmethod

		/**
		 * Creates a new Warcraft-3-like force from the force.
		 * \return Returns a newly created force.
		 */
		public method force takes nothing returns force
			local force whichForce = CreateForce()
			call this.fillForce(whichForce)
			return whichForce
		endmethod

		/**
		 * Simple forEach wrapper (equal to players.forEach).
		 * \sa ForForce()
		 */
		public method forForce takes APlayerVectorUnaryFunction forFunction returns nothing
			call this.m_players.forEach(forFunction)
		endmethod

		/**
		 * Adds all units of force \p whichForce to the force.
		 * \param destroy If this value is true force \p whichForce will be destroyed after it has been added.
		 * \param clear If this value is true force \p whichForce will be cleared after it has been added. This value has no effect if \p destroy is already true. If both parameters are false force \p whichForce won't change. Unfortunately the method has to check all players (limited Warcraft 3 natives).
		 */
		public method addForce takes force whichForce, boolean destroy, boolean clear returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYER_SLOTS)
				if (IsPlayerInForce(Player(i), whichForce)) then
					call this.m_players.pushBack(Player(i))
				endif
				set i = i + 1
			endloop

			if (destroy) then
				call DestroyForce(whichForce)
				set whichForce = null
			elseif (clear) then
				call ForceClear(whichForce)
			endif
		endmethod

		/**
		 * \sa ForceEnumPlayers()
		 */
		public method addPlayers takes boolexpr filter returns nothing
			local force whichForce = CreateForce()
			call ForceEnumPlayers(whichForce, filter)
			call this.addForce(whichForce, true, false)
			set whichForce = null
		endmethod

		/**
		 * \sa ForceEnumPlayersCounted()
		 */
		public method addPlayersCounted takes boolexpr filter, integer countLimit returns nothing
			local force whichForce = CreateForce()
			call ForceEnumPlayersCounted(whichForce, filter, countLimit)
			call this.addForce(whichForce, true, false)
			set whichForce = null
		endmethod

		/**
		 * \sa ForceEnumAllies()
		 */
		public method addAllies takes player whichPlayer, boolexpr filter returns nothing
			local force whichForce = CreateForce()
			call ForceEnumAllies(whichForce, whichPlayer, filter)
			call this.addForce(whichForce, true, false)
			set whichForce = null
		endmethod

		/**
		 * \sa ForceEnumEnemies()
		 */
		public method addEnemies takes player whichPlayer, boolexpr filter returns nothing
			local force whichForce = CreateForce()
			call ForceEnumEnemies(whichForce, whichPlayer, filter)
			call this.addForce(whichForce, true, false)
			set whichForce = null
		endmethod

		/**
		 * \sa GetPlayersByMapControl()
		 */
		public method addPlayersByMapControl takes mapcontrol whichControl returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYER_SLOTS)
				if (GetPlayerController(Player(i)) == whichControl) then
					call this.m_players.pushBack(Player(i))
				endif
				set i = i + 1
			endloop
		endmethod

		/**
		 * \sa SetForceAllianceStateBJ()
		 */
		public method setAllianceState takes AForce targetForce, integer allianceState returns nothing
			local integer targetIndex
			local integer sourceIndex = 0
			loop
				exitwhen (sourceIndex == this.m_players.size())
				set targetIndex = 0
				loop
					exitwhen (targetIndex == targetForce.m_players.size())
					call SetPlayerAllianceStateBJ(this.m_players[sourceIndex], targetForce.m_players[targetIndex], allianceState)
					set targetIndex = targetIndex + 1
				endloop
				set sourceIndex = sourceIndex + 1
			endloop
		endmethod

		/**
		 * \sa GetPlayerTeam()
		 */
		public method hasTeam takes integer team returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (GetPlayerTeam(this.m_players[i]) != team) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa GetPlayerStartLocation()
		 */
		public method hasStartLocation takes integer startLocation returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (GetPlayerStartLocation(this.m_players[i]) != startLocation) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa GetPlayerColor()
		 */
		public method hasColor takes playercolor color returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (GetPlayerColor(this.m_players[i]) != color) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa GetPlayerSelectable
		 */
		public method isSelectable takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not GetPlayerSelectable(this.m_players[i])) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa GetPlayerController
		 */
		public method hasController takes mapcontrol controller returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (GetPlayerController(this.m_players[i]) != controller) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa GetPlayerSlotState
		 */
		public method hasSlotState takes playerslotstate playerSlotState returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (GetPlayerSlotState(this.m_players[i]) != playerSlotState) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa GetPlayerTaxRate
		 */
		public method hasTaxRate takes player otherPlayer, playerstate whichResource, integer taxRate returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (GetPlayerTaxRate(this.m_players[i], otherPlayer, whichResource) != taxRate) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa SetPlayerRacePreference
		 * \sa thistype#hasRacePreferenceSet
		 */
		public method setRacePreference takes racepreference preference returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				call SetPlayerRacePreference(this.m_players[i], preference)
				set i = i + 1
			endloop
		endmethod

		/**
		 * \return Returns true if all belonging players have race preference \p preference.
		 * \sa IsPlayerRacePrefSet
		 * \sa thistype#setRacePreference
		 * \sa isSetHuman
		 * \sa isSetOrc
		 * \sa isSetNightelf
		 * \sa isSetUndead
		 * \sa isSetDemon
		 * \sa isSetRandom
		 * \sa isSetUserSelectable
		 */
		public method hasRacePreferenceSet takes racepreference preference returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not IsPlayerRacePrefSet(this.m_players[i], preference)) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		public method isSetHuman takes nothing returns boolean
			return this.hasRacePreferenceSet(RACE_PREF_HUMAN)
		endmethod

		public method isSetOrc takes nothing returns boolean
			return this.hasRacePreferenceSet(RACE_PREF_ORC)
		endmethod

		public method isSetNightelf takes nothing returns boolean
			return this.hasRacePreferenceSet(RACE_PREF_NIGHTELF)
		endmethod

		public method isSetUndead takes nothing returns boolean
			return this.hasRacePreferenceSet(RACE_PREF_UNDEAD)
		endmethod

		public method isSetDemon takes nothing returns boolean
			return this.hasRacePreferenceSet(RACE_PREF_DEMON)
		endmethod

		public method isSetRandom takes nothing returns boolean
			return this.hasRacePreferenceSet(RACE_PREF_RANDOM)
		endmethod

		public method isSetUserSelectable takes nothing returns boolean
			return this.hasRacePreferenceSet(RACE_PREF_USER_SELECTABLE)
		endmethod

		/**
		 * Sets the name of every player in the force to \p name.
		 * \sa SetPlayerName
		 */
		public method setName takes string name returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				call SetPlayerName(this.m_players[i], name)
				set i = i + 1
			endloop
		endmethod

		/**
		 * \return Returns true if all players in the force have the name \p name. Otherwise it returns false.
		 * \sa GetPlayerName
		 */
		public method hasName takes string name returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (GetPlayerName(this.m_players[i]) != name) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \return Returns true if the whole force is allied to player \p whichPlayer. Otherwise it returns false.
		 * \sa IsPlayerAlly
		 */
		public method isAlliedToPlayer takes player whichPlayer returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not IsPlayerAlly(this.m_players[i], whichPlayer)) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \return Returns true if the whole force is hostile to player \p whichPlayer. Otherwise it returns false.
		 * \sa IsPlayerEnemy
		 */
		public method isHostileToPlayer takes player whichPlayer returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not IsPlayerEnemy(this.m_players[i], whichPlayer)) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa IsPlayerInForce
		 */
		public method isInForce takes force whichForce returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not IsPlayerInForce(this.m_players[i], whichForce)) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa IsPlayerObserver
		 */
		public method isObserver takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not IsPlayerObserver(this.m_players[i])) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa IsVisibleToPlayer
		 */
		public method isVisibleTo takes real x, real y returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not IsVisibleToPlayer(x, y, this.m_players[i])) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa IsLocationVisibleToPlayer
		 */
		public method isLocationVisibleTo takes location whichLocation returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not IsLocationVisibleToPlayer(whichLocation, this.m_players[i])) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa IsFoggedToPlayer
		 */
		public method isFoggedTo takes real x, real y returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not IsFoggedToPlayer(x, y, this.m_players[i])) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa IsLocationFoggedToPlayer
		 */
		public method isLocationFoggedTo takes location whichLocation returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not IsLocationFoggedToPlayer(whichLocation, this.m_players[i])) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa IsMaskedToPlayer
		 */
		public method isMaskedTo takes real x, real y returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not IsMaskedToPlayer(x, y, this.m_players[i])) then
					return false
				endif
				set i = i + 1
			endloop
			return false
		endmethod

		/**
		 * \sa IsLocationMaskedToPlayer
		 */
		public method isLocationMaskedTo takes location whichLocation returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not IsLocationMaskedToPlayer(whichLocation, this.m_players[i])) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \return Returns true all players in the force have the race \p whichRace. Otherwise it returns false.
		 * \sa GetPlayerRace
		 */
		public method hasRace takes race whichRace returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (GetPlayerRace(this.m_players[i]) != whichRace) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		public method isHuman takes nothing returns boolean
			return this.hasRace(RACE_HUMAN)
		endmethod

		public method isOrc takes nothing returns boolean
			return this.hasRace(RACE_ORC)
		endmethod

		public method isUndead takes nothing returns boolean
			return this.hasRace(RACE_UNDEAD)
		endmethod

		public method isNightelf takes nothing returns boolean
			return this.hasRace(RACE_NIGHTELF)
		endmethod

		public method isDemon takes nothing returns boolean
			return this.hasRace(RACE_DEMON)
		endmethod

		public method isOther takes nothing returns boolean
			return this.hasRace(RACE_OTHER)
		endmethod

		/**
		 * \return Returns true if all players in the force have the ID \p id. Otherwise it returns false.
		 * \sa GetPlayerId
		 */
		public method hasId takes integer id returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (GetPlayerId(this.m_players[i]) != id) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \return Returns the sum of all players unit counts.
		 * \sa GetPlayerUnitCount
		 * \sa thistype#unitTypedCount()
		 * \sa thistype#structureCount()
		 */
		public method unitCount takes boolean includeIncomplete returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				set result = result + GetPlayerUnitCount(this.m_players[i], includeIncomplete)
				set i = i + 1
			endloop
			return result
		endmethod

		/**
		 * \return Returns the sum of all players typed unit counts.
		 * \sa GetPlayerTypedUnitCount
		 * \sa thistype#unitCount()
		 * \sa thistype#structureCount()
		 */
		public method unitTypedCount takes string unitName, boolean includeIncomplete, boolean includeUpgrades returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				set result = result + GetPlayerTypedUnitCount(this.m_players[i], unitName, includeIncomplete, includeUpgrades)
				set i = i + 1
			endloop
			return result
		endmethod

		/**
		 * \return Returns the sum of all players structure counts.
		 * \sa GetPlayerStructureCount
		 * \sa thistype#unitCount()
		 * \sa thistype#unitTypedCount()
		 */
		public method structureCount takes boolean includeIncomplete returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				set result = result + GetPlayerStructureCount(this.m_players[i], includeIncomplete)
				set i = i + 1
			endloop
			return result
		endmethod

		/**
		 * Sets state \p whichPlayerState for all belonging players to \p value.
		 * \sa SetPlayerState
		 * \sa thistype#state()
		 */
		public method setState takes playerstate whichPlayerState, integer value returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				call SetPlayerState(this.m_players[i], whichPlayerState, value)
				set i = i + 1
			endloop
		endmethod

		/**
		 * \return Returns the sum of all player state values of state \p whichPlayerState.
		 * \sa GetPlayerState
		 * \sa thistype#setState()
		 */
		public method state takes playerstate whichPlayerState returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				set result = result + GetPlayerState(this.m_players[i], whichPlayerState)
				set i = i + 1
			endloop
			return result
		endmethod

		/**
		 * \return Returns the sum of all players score of type \p whichPlayerScore.
		 * \sa GetPlayerScore
		 */
		public method score takes playerscore whichPlayerScore returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				set result = result + GetPlayerScore(this.m_players[i], whichPlayerScore)
				set i = i + 1
			endloop
			return result
		endmethod

		/**
		 * \return Only returns true if alliance type \p whichAllianceSetting is true for all belonging players to player \p otherPlayer. Otherwise it returns false.
		 * \sa GetPlayerAlliance
		 */
		public method alliance takes player otherPlayer, alliancetype whichAllianceSetting returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not GetPlayerAlliance(this.m_players[i], otherPlayer, whichAllianceSetting)) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa SetPlayerHandicap
		 */
		public method setHandicap takes real handicap returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				call SetPlayerHandicap(this.m_players[i], handicap)
				set i = i + 1
			endloop
		endmethod

		/**
		 * \sa GetPlayerHandicap
		 */
		public method handicap takes nothing returns real
			local real result = 0.0
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				set result = result + GetPlayerHandicap(this.m_players[i])
				set i = i + 1
			endloop
			return result
		endmethod

		/**
		 * \sa SetPlayerHandicapXP
		 */
		public method setHandicapXP takes real handicap returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				call SetPlayerHandicapXP(this.m_players[i], handicap)
				set i = i + 1
			endloop
		endmethod

		/**
		 * \sa GetPlayerHandicapXP
		 */
		public method handicapXP takes nothing returns real
			local real result = 0.0
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				set result = result + GetPlayerHandicapXP(this.m_players[i])
				set i = i + 1
			endloop
			return result
		endmethod

		/**
		 * \sa SetPlayerTechMaxAllowed
		 */
		public method setTechMaxAllowed takes integer techid, integer maximum returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				call SetPlayerTechMaxAllowed(this.m_players[i], techid, maximum)
				set i = i + 1
			endloop
		endmethod

		/**
		 * \sa GetPlayerTechMaxAllowed
		 */
		public method techMaxAllowed takes integer techid returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				set result = result + GetPlayerTechMaxAllowed(this.m_players[i], techid)
				set i = i + 1
			endloop
			return result
		endmethod

		/**
		 * \sa AddPlayerTechResearched
		 */
		public method addTechResearched takes integer techid, integer levels returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				call AddPlayerTechResearched(this.m_players[i], techid, levels)
				set i = i + 1
			endloop
		endmethod

		/**
		 * \sa SetPlayerTechResearched
		 */
		public method setTechResearched takes integer techid, integer setToLevel returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				call SetPlayerTechResearched(this.m_players[i], techid, setToLevel)
				set i = i + 1
			endloop
		endmethod

		/**
		 * \sa GetPlayerTechResearched
		 */
		public method techResearched takes integer techid, boolean specificonly returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not GetPlayerTechResearched(this.m_players[i], techid, specificonly)) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		/**
		 * \sa GetPlayerTechCount
		 */
		public method techCount takes integer techid, boolean specificonly returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				set result = result + GetPlayerTechCount(this.m_players[i], techid, specificonly)
				set i = i + 1
			endloop
			return result
		endmethod

		/**
		 * \sa SetPlayerUnitsOwner
		 */
		public method setUnitsOwner takes integer newOwner returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				call SetPlayerUnitsOwner(this.m_players[i], newOwner)
				set i = i + 1
			endloop
		endmethod

		/**
		 * \sa CripplePlayer
		 */
		public method cripple takes force toWhichPlayers, boolean flag returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				call CripplePlayer(this.m_players[i], toWhichPlayers, flag)
				set i = i + 1
			endloop
		endmethod

		/**
		 * \sa SetPlayerAbilityAvailable
		 */
		public method setAbilityAvailable takes integer abilityId, boolean available returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				call SetPlayerAbilityAvailable(this.m_players[i], abilityId, available)
				set i = i + 1
			endloop
		endmethod

		public method hasUnitsOfPlayer takes player whichPlayer returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (this.m_players[i] == whichPlayer) then
					return true
				endif
				set i = i + 1
			endloop
			return false
		endmethod

		public method removeUnitsOfPlayer takes player whichPlayer returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (this.m_players[i] == whichPlayer) then
					call this.m_players.erase(i)
				else
					set i = i + 1
				endif
			endloop
		endmethod

		public method hasAlliesOfPlayer takes player whichPlayer returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (IsPlayerAlly(this.m_players[i], whichPlayer)) then
					return true
				endif
				set i = i + 1
			endloop
			return false
		endmethod

		public method hasAlliesOfUnit takes unit whichUnit returns boolean
			local player owner = GetOwningPlayer(whichUnit)
			local boolean result = this.hasAlliesOfPlayer(owner)
			set owner = null
			return result
		endmethod

		public method removeAlliesOfPlayer takes player whichPlayer returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (IsPlayerAlly(this.m_players[i], whichPlayer)) then
					call this.m_players.erase(i)
				else
					set i = i + 1
				endif
			endloop
		endmethod

		public method removeAlliesOfUnit takes unit whichUnit returns nothing
			local player owner = GetOwningPlayer(whichUnit)
			call this.removeAlliesOfPlayer(owner)
			set owner = null
		endmethod

		public method hasEnemiesOfPlayer takes player whichPlayer returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not IsPlayerAlly(this.m_players[i], whichPlayer)) then
					return true
				endif
				set i = i + 1
			endloop
			return false
		endmethod

		public method hasEnemiesOfUnit takes unit whichUnit returns boolean
			local player owner = GetOwningPlayer(whichUnit)
			local boolean result = this.hasEnemiesOfPlayer(owner)
			set owner = null
			return result
		endmethod

		public method removeEnemiesOfPlayer takes player whichPlayer returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				if (not IsPlayerAlly(this.m_players[i], whichPlayer)) then
					call this.m_players.erase(i)
				else
					set i = i + 1
				endif
			endloop
		endmethod

		public method removeEnemiesOfUnit takes unit whichUnit returns nothing
			local player owner = GetOwningPlayer(whichUnit)
			call this.removeEnemiesOfPlayer(owner)
			set owner = null
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			// members
			set this.m_players = APlayerVector.create()
			return this
		endmethod

		public static method createWithForce takes force whichForce, boolean destroy, boolean clear returns thistype
			local thistype this = thistype.create()
			call this.addForce(whichForce, destroy, clear)
			return this
		endmethod

		public static method createWithAll takes nothing returns thistype
			local thistype this = thistype.allocate()
			local integer i = 0
			// members
			set this.m_players = APlayerVector.createWithSize(bj_MAX_PLAYERS, null)
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set this.m_players[i] = Player(i)
				set i = i + 1
			endloop
			return this
		endmethod

		public static method createWithPlayer takes player whichPlayer returns thistype
			local thistype this = thistype.allocate()
			// members
			set this.m_players = APlayerVector.createWithSize(1, whichPlayer)
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// members
			call this.m_players.destroy()
		endmethod
	endstruct

endlibrary