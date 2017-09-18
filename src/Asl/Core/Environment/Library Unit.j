/// Provides several functions for unit handling.
/// \author Tamino Dauth
library ALibraryCoreEnvironmentUnit requires ALibraryCoreMathsReal, AStructCoreGeneralHashTable

	/**
	 * Adds or removes the move ability to unit \p whichUnit.
	 * \author Tamino Dauth
	 * \param whichUnit Unit which the ability is added to.
	 * \param movable If this value is true the ability will be added to unit \p whichUnit, otherwise it will be removed.
	 * \sa MakeUnitAttackable()
	 */
	function MakeUnitMovable takes unit whichUnit, boolean movable returns nothing
		if (movable) then
			call UnitAddAbility(whichUnit, 'Amov')
		else
			call UnitRemoveAbility(whichUnit, 'Amov')
		endif
	endfunction

	/**
	 * Adds or removes the attack ability to unit \p whichUnit.
	 * \author Tamino Dauth
	 * \param whichUnit Unit which the ability is added to.
	 * \param attackable If this value is true the ability will be added to unit \p whichUnit, otherwise it will be removed.
	 * \sa MakeUnitMovable()
	 */
	function MakeUnitAttackable takes unit whichUnit, boolean attackable returns nothing
		if (attackable) then
			call UnitAddAbility(whichUnit, 'Aatk')
		else
			call UnitRemoveAbility(whichUnit, 'Aatk')
		endif
	endfunction

	/**
	 * \author DioD
	 * \return Returns true if unit \p whichUnit is invulnerable.
	 * <a href="http://www.wc3c.net/showthread.php?p=1056611">source</a>
	 * <a href="http://www.wc3c.net/showthread.php?t=103889">alternative version</a>
	 */
	function IsUnitInvulnerable takes unit whichUnit returns boolean
		//return (GetUnitAbilityLevel(whichUnit, 'Avul') > 0) OLD, works not for custom invulnerability spells (buffs)
		local real currentHealth = GetWidgetLife(whichUnit)
		local real currentMana   = GetUnitState(whichUnit,UNIT_STATE_MANA)
		local boolean checkHealth

		call SetWidgetLife(whichUnit, currentHealth + 0.001)
		if currentHealth != GetWidgetLife(whichUnit) then
			call UnitDamageTarget(whichUnit, whichUnit, 0.001, false, true, null, null, null)
			set checkHealth = (GetWidgetLife(whichUnit) == currentHealth + 0.001)
		else
			call UnitDamageTarget(whichUnit, whichUnit, 0.001, false, true, null, null, null)
			set checkHealth = (GetWidgetLife(whichUnit) == currentHealth)
			call SetWidgetLife(whichUnit,currentHealth)
		endif

		if (checkHealth) then // check mana absorbation
			return (not (GetUnitState(whichUnit,UNIT_STATE_MANA) != currentMana))
		endif

		return checkHealth
	endfunction

	/**
	 * \todo Function does not support all alliance states (only \ref bj_ALLIANCE_NEUTRAL, \ref bj_ALLIANCE_ALLIED and \ref bj_ALLIANCE_UNALLIED).
	 * \author Tamino Dauth
	 * \return Returns the alliance state of the two unit's owners.
	 */
	function GetUnitAllianceStateToUnit takes unit whichUnit, unit otherUnit returns integer
		local player usedUnitOwner = GetOwningPlayer(whichUnit)
		local player otherUnitOwner = GetOwningPlayer(otherUnit)
		local integer allianceState = -1
		if (IsPlayerAlly(usedUnitOwner, otherUnitOwner)) then
			if (GetPlayerAlliance(usedUnitOwner, otherUnitOwner, ALLIANCE_PASSIVE)) then
				set allianceState = bj_ALLIANCE_ALLIED
			else
				set allianceState = bj_ALLIANCE_NEUTRAL
			endif
		else
			set allianceState = bj_ALLIANCE_UNALLIED
		endif
		set usedUnitOwner = null
		set otherUnitOwner = null
		return allianceState
	endfunction

	/**
	 * In WC3, most debuff and stun spells have a decreased duration
	 * against heroes, creeps with a high enough level (\ref A_SPELL_RESISTANCE_CREEP_LEVEL) and units with
	 * resistant skin, while other spells such as Polymorph don't
	 * even work against such units. This function checks if a unit
	 * matches any of these criteria that would make it resistant to
	 * such spells, so you can make triggered spells work that way.
	 * \author Anitarf
	 * \sa A_SPELL_RESISTANCE_CREEP_LEVEL
	 * \sa IsUnitSpellImmune()
	 * <a href="http://www.wc3c.net/showthread.php?t=102721">source</a>
	 */
	function IsUnitSpellResistant takes unit u returns boolean
		local player owner = GetOwningPlayer(u)
		local boolean result = IsUnitType(u, UNIT_TYPE_HERO) or IsUnitType(u, UNIT_TYPE_RESISTANT) or (GetPlayerId(owner) >= PLAYER_NEUTRAL_AGGRESSIVE and GetUnitLevel(u) >= A_SPELL_RESISTANCE_CREEP_LEVEL) //the level at which creeps gain spell resistance
		set owner = null
		return result
	endfunction

	/**
	 * <a href="http://www.wc3c.net/showthread.php?t=102721">source</a>
	 * \author Anitarf
	 * \sa IsUnitSpellResistant()
	 */
	function IsUnitSpellImmune takes unit u returns boolean
		return IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE)
	endfunction

	/**
	 * \defgroup unitproperties Unit properties
	 * Other functions available for use are \ref GetFullDamage() and \ref GetReducedDamage().
	 * GetFullDamage, when passed the actual damage a unit takes (In most cases,
	 * GetEventDamage from \ref EVENT_UNIT_DAMAGED event callbacks) and a unit's armor,
	 * it will return how much damage was dealt before armor reduction. Similarly,
	 * GetReducedDamage, when given the base damage and armor, will return how much
	 * damage will be dealt after armor is considered. These functions DO NOT
	 * consider armor types in their calculations, so any further reductions or
	 * bonuses due to that will need to be considered BEFORE using these functions.
	 * I recommend using your damage detection system to modify and build your own
	 * armor types anyways.
	 *
	 * You can use the ObjectMerger call in \ref Creation_Unit_Properties.j in order to generate the ability for
	 * keeping units with maximum life lower than \ref DAMAGE_TEST from dying when
	 * using \ref GetUnitArmor() on them. If you do not plan on editing the 'AIlz' ability
	 * in your map, you can ignore the file's import and its ObjectMerger call and replace
	 * 'lif&' in the configuration constants with 'AIlz'. The 'AIlz' ability adds
	 * 50 max life, which is plenty for the script.
	 * \todo Support LIFE_BONUS_SPELL_ID configuration in ASL.
	 *
	 * Function Listing --
	 * function GetUnitArmor takes unit u returns real
	 * function GetReducedDamage takes real baseDamage, real armor returns real
	 * function GetFullDamage takes real damage, real armor returns real
	 */
	globals
		// Values that should be changed for your map
		/// \author Rising_Dusk
		/// \ingroup unitproperties
		private constant real ARMOR_REDUCTION_MULTIPLIER = 0.06
		/// \author Rising_Dusk
		/// \ingroup unitproperties
		private constant integer LIFE_BONUS_SPELL_ID = 'lif&'
		// Values that do not need to be changed
		/// \author Rising_Dusk
		/// \ingroup unitproperties
		private constant real ARMOR_INVULNERABLE = 917451.519
		/// \author Rising_Dusk
		/// \ingroup unitproperties
		private constant real DAMAGE_TEST = 16.
		/// \author Rising_Dusk
		/// \ingroup unitproperties
		private constant real DAMAGE_LIFE = 30.
		/// \author Rising_Dusk
		/// \ingroup unitproperties
		private constant real NATLOG_094 = -0.061875
	endglobals

	/// \author Rising_Dusk
	/// \ingroup unitproperties
	function GetUnitArmor takes unit u returns real
		local real life = GetWidgetLife(u)
		local real test = life
		local real redc = 0.
		local boolean enab = false
		local trigger trig = GetTriggeringTrigger()
		if (u != null and life >= 0.405) then
			if (GetUnitState(u, UNIT_STATE_MAX_LIFE) <= DAMAGE_TEST) then
				//Add max life to keep it alive
				call UnitAddAbility(u, LIFE_BONUS_SPELL_ID)
			endif
			if (life <= DAMAGE_LIFE) then
				//If under the threshold, heal it for the moment
				call SetWidgetLife(u, DAMAGE_LIFE)
				set test = DAMAGE_LIFE
			endif
			if (trig != null and IsTriggerEnabled(trig)) then
				//Disable the trigger to prevent it registering with damage detection systems
				call DisableTrigger(trig)
				set enab = true
			endif
			call UnitDamageTarget(u, u, DAMAGE_TEST, true, false, ATTACK_TYPE_CHAOS, DAMAGE_TYPE_NORMAL, null)
			set redc = (DAMAGE_TEST - test + GetWidgetLife(u)) / DAMAGE_TEST
			if (enab) then
				//Re-enable the trigger
				call EnableTrigger(trig)
			endif
			//Remove the max life ability
			call UnitRemoveAbility(u, LIFE_BONUS_SPELL_ID)
			call SetWidgetLife(u, life)
			set trig = null
			if (redc >= 1.0) then
				//Invulnerable
				return ARMOR_INVULNERABLE
			elseif (redc < 0.0) then
				//Negative Armor
				return -ALog(redc + 1.0, 20) / NATLOG_094
			else
				//Positive Armor
				return redc / (ARMOR_REDUCTION_MULTIPLIER * (1.0 - redc))
			endif
		endif
		set trig = null
		return 0.0
	endfunction

	/// \author Rising_Dusk
	/// \ingroup unitproperties
	function GetReducedDamage takes real baseDamage, real armor returns real
		if (armor >= 0.0) then
			return baseDamage * (1.0 - ((armor * ARMOR_REDUCTION_MULTIPLIER) / (1.0 + ARMOR_REDUCTION_MULTIPLIER * armor)))
		endif
		return baseDamage * (2.0 -Pow(0.94, -armor))
	endfunction

	/// \author Rising_Dusk
	/// \ingroup unitproperties
	function GetFullDamage takes real damage, real armor returns real
		if (armor >= 0.0) then
			return damage / (1.0 -((armor * ARMOR_REDUCTION_MULTIPLIER) / (1.0 + ARMOR_REDUCTION_MULTIPLIER * armor)))
		endif
		return damage / (2.0 -Pow(0.94, -armor))
	endfunction

	/**
	 * \return Returns the experience which a hero gets from killing a unit with level \p unitLevel.
	 * \author HaiZhung, Tamino Dauth
	 * \sa GetUnitXP()
	 * \sa GetUnitHeroXP()
	 * \sa GetHeroLevelMaxXP()
	 */
	function GetUnitLevelXP takes integer unitLevel returns integer
		local integer result = 25 // default XP
		local integer i = 2
		loop
			exitwhen (i > unitLevel)
			set result = result + 1 * ((i * 5) + 5)
			set i = i + 1
		endloop
		return result
	endfunction

	/**
	 * \return Returns the experience which a hero gets from killing unit \p whichUnit.
	 * \author HaiZhung, Tamino Dauth
	 * \sa GetUnitLevelXP()
	 * \sa GetUnitHeroXP()
	 * \sa GetHeroLevelMaxXP()
	 */
	function GetUnitXP takes unit whichUnit returns integer
		return GetUnitLevelXP(GetUnitLevel(whichUnit))
	endfunction

	/**
	 * \return Returns the experience which \p hero gets from killing unit \p whichUnit.
	 * \note Considers default creep experience reduction table.
	 * \author HaiZhung, Tamino Dauth
	 * \sa GetUnitLevelXP()
	 * \sa GetUnitXP()
	 * \sa GetHeroLevelMaxXP()
	 */
	function GetUnitHeroXP takes unit whichUnit, unit hero returns integer
		if (GetOwningPlayer(whichUnit) == Player(PLAYER_NEUTRAL_AGGRESSIVE)) then
			return R2I(I2R(GetUnitXP(whichUnit)) * (0.80 - I2R(GetHeroLevel(hero) - 1) * 0.10))
		endif
		return GetUnitXP(whichUnit)
	endfunction

	/**
	 * \return Returns the maximum required experience which is required to pass \p herolevel and level up.
	 * \note Considers default experience table.
	 * \author HaiZhung, Tamino Dauth
	 * \sa GetUnitLevelXP()
	 * \sa GetUnitXP()
	 * \sa GetHeroXP()
	 */
	function GetHeroLevelMaxXP takes integer heroLevel returns integer
		local integer result = 0 // level 1 XP
		local integer i = 2
		loop
			exitwhen (i > heroLevel + 1)
			set result = result + i * 100
			set i = i + 1
		endloop
		return result
	endfunction

	/// \sa FlushUnitTypeCollisionSize, GetUnitCollisionSizeEx, GetUnitCollisionSize
	function FlushUnitCollisionSizes takes nothing returns nothing
		call AGlobalHashTable.global().flushKey(A_HASHTABLE_GLOBAL_KEY_UNITCOLLISIONSIZES)
	endfunction

	/// \sa FlushUnitCollisionSizes, GetUnitCollisionSizeEx, GetUnitCollisionSize
	function FlushUnitTypeCollisionSize takes integer unitTypeId returns nothing
		call AGlobalHashTable.global().removeReal(A_HASHTABLE_GLOBAL_KEY_UNITCOLLISIONSIZES, unitTypeId)
	endfunction

	/**
	 * Caches collision sizes of unit types.
	 * Use \ref FlushUnitCollisionSizes or \ref FlushUnitTypeCollisionSize to flush cached data.
	 * Use \ref GetUnitCollisionSize to use predefined maximum collision size and iterations of map.
	 * \author Vexoiran, Tamino Dauth
	 * \sa FlushUnitCollisionSizes, FlushUnitTypeCollisionSize, GetUnitCollisionSize
	 * <a href="http://www.wc3c.net/showthread.php?t=101309">source</a>
	 */
	function GetUnitCollisionSizeEx takes unit u, real maxCollisionSize, integer iterations returns real
		local integer i = 0
		local real x = GetUnitX(u)
		local real y = GetUnitY(u)
		local real hi
		local real lo
		local real mid
		local integer unitType = GetUnitTypeId(u)
		if (AGlobalHashTable.global().hasReal(A_HASHTABLE_GLOBAL_KEY_UNITCOLLISIONSIZES, unitType)) then
			return AGlobalHashTable.global().real(A_HASHTABLE_GLOBAL_KEY_UNITCOLLISIONSIZES, unitType)
		endif
		set hi = maxCollisionSize
		set lo = 0.0
		loop
			set mid = (lo+hi) / 2.0
			exitwhen (i== iterations)
			if (IsUnitInRangeXY(u, x + mid,y,0)) then
				set lo=mid
			else
				set hi=mid
			endif
			set i=i+1
		endloop
		call AGlobalHashTable.global().setReal(A_HASHTABLE_GLOBAL_KEY_UNITCOLLISIONSIZES, unitType, mid)
		return mid
	endfunction

	/**
	 * Same as \ref GetUnitCollisionSizeEx but uses predefined constants.
	 * \sa FlushUnitCollisionSizes, FlushUnitTypeCollisionSize, GetUnitCollisionSizeEx
	 */
	function GetUnitCollisionSize takes unit u returns real
		return GetUnitCollisionSizeEx(u, A_MAX_COLLISION_SIZE, A_MAX_COLLISION_SIZE_ITERATIONS)
	endfunction

endlibrary