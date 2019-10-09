/**
* The Bonus Mod (originally created by \author weaaddar) is a famous system
* for modifying specific unit properties where JASS natives are missed and can not be used.
* It uses a special method by adding and removing property-modifying abilities to a unit.
* Therefore it allows the user to modify damage, armour, hit points, mana, sight range, hit point regeneration and mana regeneration of a unit.
* \note Note that you've to call \ref AInitBonusMod() before using this library.
* It won't be called by default (using it as initializer) since this would be decrease the performance for users who maybe won't use it at all.
* Besides many abilities have to be created in object editor.
* Therefore you should import file "Systems/BonusMod/Creation Bonus Mod.j" one-time into your
* map which will create all required object editor abilities automatically starting with ability id AZZ0.
* Here's a list of natives for changing unit properties:
* <ul>
* <li>\ref SetUnitState - For changing life, maximum life, mana and maximum mana.</li>
* <li>\ref SetUnitMoveSpeed - For assigning unit's movement speed.</li>
* <li>\ref SetUnitAcquireRange </li>
* <li>\ref SetUnitBlendTime </li>
* <li>\ref SetUnitFlyHeight </li>
* <li>\ref SetUnitFog </li>
* <li>\ref SetUnitScale </li>
* <li>...</li>
* </ul>
* \author weaaddar, Tamino Dauth
*/
library ALibrarySystemsBonusModBonusMod requires AStructCoreGeneralHashTable, optional ALibraryCoreDebugMisc

	globals
		constant integer A_BONUS_TYPE_DAMAGE = 0
		constant integer A_BONUS_TYPE_ARMOR = 1
		constant integer A_BONUS_TYPE_LIFE = 2
		constant integer A_BONUS_TYPE_MANA = 3
		constant integer A_BONUS_TYPE_SIGHT_RANGE = 4 // Sight Range Bonus
		constant integer A_BONUS_TYPE_MANA_REGENERATION = 5 // Mana Regeneration Bonus (A % value)
		constant integer A_BONUS_TYPE_LIFE_REGENERATION = 6 // Life Regeneration Bonus (An absolute value)
		constant integer A_BONUS_MAX_TYPES = 7
		/**
		* Bonus Mod's Number of abilities per bonus, if last power of 2 ability is -512,
		* this shall be 10, and the maximum bonus would be 511 while the minimum -512.
		*/
		private constant integer IxLimit = 10
		private constant integer LastIndex = IxLimit - 1
		/**
		* If it is 10, the  hp, mana abilities will be: 10, 20,40,80,160,...
		* If it is 1, they would be : 1,2,4,8,16,...
		* If it is 5, they would be: 5,10,20,40,80,..
		*/
		constant integer A_BONUS_BIG_VALUES_FACTOR = 10
		private integer array abilityId
		private AHashTable hashTable
	endglobals

	private function Ix takes integer x, integer y returns integer
		return Index2D(x, y, IxLimit)
	endfunction

	/// \todo Should be private, vJass bug.
	debug function CheckType takes integer bonusType returns boolean
		debug if (bonusType < 0 or bonusType >= A_BONUS_MAX_TYPES) then
			debug call Print("ABonusMod error: Wrong type, value " + I2S(bonusType) + ".")
			debug return true
		debug endif
		debug return false
	debug endfunction

	/**
	 * \return Returns true if bonus type \p bonusType uses big values/steps (10, 20,40,80,160,...).
	 * Usually, this is true for \ref A_BONUS_TYPE_LIFE, \ref A_BONUS_TYPE_MANA and \ref A_BONUS_TYPE_SIGHT_RANGE.
	 */
	function ABonusIsBigValue takes integer bonusType returns boolean
		debug if CheckType(bonusType) then
			debug return false
		debug endif
		return (bonusType == A_BONUS_TYPE_LIFE or bonusType == A_BONUS_TYPE_MANA or bonusType == A_BONUS_TYPE_SIGHT_RANGE)
	endfunction

	/**
	 * \return Returns the maximum, positive value which can be assigned using bonus type \p bonusType.
	 * This should be 511 for usual types and 5110 for big value types.
	 */
	function ABonusMax takes integer bonusType returns integer
		local integer max = 0
		debug if CheckType(bonusType) then
			debug return 0
		debug endif
		set max = (R2I(Pow(2, LastIndex)) - 1)
		if (ABonusIsBigValue(bonusType)) then
			return max * A_BONUS_BIG_VALUES_FACTOR
		endif
		return max
	endfunction

	/**
	 * \return Returns the minimum, negative value which can be assigned using bonus type \p bonusType.
	 * This should be -512 for usual types and -5120 for big value types.
	 */
	function ABonusMin takes integer bonusType returns integer
		local integer min = 0
		debug if CheckType(bonusType) then
			debug return 0
		debug endif
		set min = -(R2I(Pow(2, LastIndex)) - 1)
		if (ABonusIsBigValue(bonusType)) then
			return min * A_BONUS_BIG_VALUES_FACTOR
		endif
		return min
	endfunction

	/// \todo Should be private, vJass bug.
	debug function CheckAmount takes integer bonusType, integer amount returns boolean
		debug if (amount < ABonusMin(bonusType) or amount > ABonusMax(bonusType)) then
			debug call Print("ABonusMod error: Wrong amount, value " + I2S(amount) + ".")
			debug return true
		debug endif
		debug return false
	debug endfunction

	function ABonusModLabel takes integer bonusType returns integer
		return A_HASHTABLE_KEY_BONUSTYPE_DAMAGE + bonusType
	endfunction

	/**
	 * \param whichUnit Unit which is checked for bonus.
	 * \param bonusType Property type which is checked for.
	 * Possible values are:
	 * \ref A_BONUS_TYPE_DAMAGE
	 * \ref A_BONUS_TYPE_ARMOR
	 * \ref A_BONUS_TYPE_LIFE
	 * \ref A_BONUS_TYPE_MANA
	 * \ref A_BONUS_TYPE_SIGHT_RANGE
	 * \ref A_BONUS_TYPE_MANA_REGENERATION
	 * \ref A_BONUS_TYPE_LIFE_REGENERATION
	 * \return Returns units bonus of a specific property.
	 */
	function AUnitGetBonus takes unit whichUnit, integer bonusType returns integer
		debug call CheckType(bonusType)
		return hashTable.handleInteger(whichUnit, ABonusModLabel(bonusType))
	endfunction

	/**
	 * Sets units bonus of a specific property.
	 * \param whichUnit Unit which should get bonus.
	 * \param bonusType Property type which is used for setting bonus.
	 * Possible values are:
	 * \ref A_BONUS_TYPE_DAMAGE
	 * \ref A_BONUS_TYPE_ARMOR
	 * \ref A_BONUS_TYPE_LIFE
	 * \ref A_BONUS_TYPE_MANA
	 * \ref A_BONUS_TYPE_SIGHT_RANGE
	 * \ref A_BONUS_TYPE_MANA_REGENERATION
	 * \ref A_BONUS_TYPE_LIFE_REGENERATION
	 * \param amount Bonus amount which should be set.
	 * \return Returns if bonus was set successfully.
	 */
	function AUnitSetBonus takes unit whichUnit, integer bonusType, integer amount returns boolean
		local integer x
		local integer i
		/// \todo test for JassParser
		local integer bit = 0
		local boolean negative
		local boolean hadNoManaBefore
		debug if (whichUnit == null or CheckType(bonusType) or CheckAmount(bonusType, amount)) then
			debug return false
		debug endif
		// clear all stored data
		if (amount == 0) then
			call hashTable.removeHandleInteger(whichUnit, ABonusModLabel(bonusType))

			/*
			if (ABonusIsBigValue(bonusType) and hashTable.hasHandleInteger(whichUnit, ABonusModLeftLabel(bonusType))) then
				call hashTable.removeHandleInteger(whichUnit, ABonusModLeftLabel(bonusType))
			endif
			*/
		// get smaller amount, store amount
		elseif (ABonusIsBigValue(bonusType)) then
			set amount = amount / A_BONUS_BIG_VALUES_FACTOR
			call hashTable.setHandleInteger(whichUnit, ABonusModLabel(bonusType), amount * A_BONUS_BIG_VALUES_FACTOR)
		// store amount
		else
			call hashTable.setHandleInteger(whichUnit, ABonusModLabel(bonusType), amount)
		endif
		// assign before adding abilities!
		set hadNoManaBefore = (bonusType == A_BONUS_TYPE_MANA) and (GetUnitState(whichUnit, UNIT_STATE_MAX_MANA) <= 0)
		call UnitRemoveAbility(whichUnit, abilityId[Ix(bonusType, LastIndex)])
		if (amount < 0) then
			set negative = true
			set amount = bit + amount
		else
			set negative = false
		endif

		// skip negative ability and add all positive
		set i = LastIndex - 1
		set bit = R2I(Pow(2, i))
		loop
			exitwhen (i < 0)
			if (amount >= bit) then
				set x = abilityId[Ix(bonusType, i)]
				call UnitAddAbility(whichUnit, x)
				call UnitMakeAbilityPermanent(whichUnit, true, x)
				set amount = amount - bit
			else
				call UnitRemoveAbility(whichUnit, abilityId[Ix(bonusType, i)])
			endif
			set bit = bit / 2
			set i = i - 1
		endloop
		// last ability contains negative amount
		if (negative) then
			set x = abilityId[Ix(bonusType, LastIndex)]
			call UnitAddAbility(whichUnit, x)
			call UnitMakeAbilityPermanent(whichUnit, true, x)
		else
			call UnitRemoveAbility(whichUnit, abilityId[Ix(bonusType, LastIndex)])
		endif
		// has mana now
		if (hadNoManaBefore and (GetUnitState(whichUnit, UNIT_STATE_MAX_MANA) > 0)) then
			call SetUnitState(whichUnit, UNIT_STATE_MANA, 0)
		endif
		return amount == 0
	endfunction

	/**
	 * Sets units bonus of a specific property to 0. If bonus is set to 0 saved hash table data is cleared automatically.
	 * \param whichUnit Unit which should bonus cleared of.
	 * \param bonusType Property type which is used for adding bonus.
	 * Possible values are:
	 * \ref A_BONUS_TYPE_DAMAGE
	 * \ref A_BONUS_TYPE_ARMOR
	 * \ref A_BONUS_TYPE_LIFE
	 * \ref A_BONUS_TYPE_MANA
	 * \ref A_BONUS_TYPE_SIGHT_RANGE
	 * \ref A_BONUS_TYPE_MANA_REGENERATION
	 * \ref A_BONUS_TYPE_LIFE_REGENERATION
	 * \return Returns if bonus was cleared successfully.
	 */
	function AUnitClearBonus takes unit whichUnit, integer bonusType returns boolean
		return AUnitSetBonus(whichUnit, bonusType, 0)
	endfunction

	/**
	 * Adds bonus of a specific property to unit.
	 * \param whichUnit Unit which should get bonus.
	 * \param bonusType Property type which is used for adding bonus.
	 * Possible values are:
	 * \ref A_BONUS_TYPE_DAMAGE
	 * \ref A_BONUS_TYPE_ARMOR
	 * \ref A_BONUS_TYPE_LIFE
	 * \ref A_BONUS_TYPE_MANA
	 * \ref A_BONUS_TYPE_SIGHT_RANGE
	 * \ref A_BONUS_TYPE_MANA_REGENERATION
	 * \ref A_BONUS_TYPE_LIFE_REGENERATION
	 * \param amount Bonus amount which should be added.
	 * \return Returns if bonus was added successfully.
	 */
	function AUnitAddBonus takes unit whichUnit, integer bonusType, integer amount returns boolean
		/*
		local integer x
		local boolean b
		local real l
		local string s = null
		local real min
		local real mod
		debug call CheckType(bonusType)
		if (amount == 0) then
			return true
		endif
		if (ABonusIsBigValue(bonusType)) then
			if (bonusType == A_BONUS_TYPE_LIFE) then
				set l = GetWidgetLife(whichUnit)
				set mod = ModuloReal(l, A_BONUS_BIG_VALUES_FACTOR)
				set s = "ABonusModLeftLife"
				if mod >= 1 then
					set min = 0
				else
					set min = A_BONUS_BIG_VALUES_FACTOR
				endif
			elseif (bonusType == A_BONUS_TYPE_MANA) then
				set l = GetUnitState(whichUnit, UNIT_STATE_MAX_MANA)
				set mod = ModuloReal(l, A_BONUS_BIG_VALUES_FACTOR)
				set s = "ABonusModLeftMana"
				set min = 0
			endif
			//set amount = (amount / A_BONUS_BIG_VALUES_FACTOR) * BonusBigValuesManaFactor /// \todo Baradé, ?!!
			set amount = amount + hashTable.handleInteger(whichUnit, s)
			if (amount < 0) and (l + amount < 1) then
				set x = R2I(min + mod - l)
				set b = AUnitSetBonus(whichUnit, bonusType, AUnitGetBonus(whichUnit, bonusType) + x)
				call hashTable.setHandleInteger(whichUnit, s, amount - x)
			else
				call hashTable.setHandleInteger(whichUnit, s, 0)
				set b = AUnitSetBonus(whichUnit, bonusType, AUnitGetBonus(whichUnit, bonusType) + amount)
			endif
			return b
		endif
		*/
		return AUnitSetBonus(whichUnit, bonusType, AUnitGetBonus(whichUnit, bonusType) + amount)
	endfunction

	/**
	 * The same as \ref AUnitAddBonus() with a negative amount but a little bit more logic and readable in my opinion.
	 * Removes bonus of a specific property to unit.
	 * \author Tamino Dauth
	 * \param whichUnit Unit which should loose bonus.
	 * \param bonusType Property type which is used for removing bonus.
	 * Possible values are:
	 * \ref A_BONUS_TYPE_DAMAGE
	 * \ref A_BONUS_TYPE_ARMOR
	 * \ref A_BONUS_TYPE_LIFE
	 * \ref A_BONUS_TYPE_MANA
	 * \ref A_BONUS_TYPE_SIGHT_RANGE
	 * \ref A_BONUS_TYPE_MANA_REGENERATION
	 * \ref A_BONUS_TYPE_LIFE_REGENERATION
	 * \param amount Bonus amount which should be removed.
	 * \return Returns if bonus was removed successfully.
	 */
	function AUnitRemoveBonus takes unit whichUnit, integer bonusType, integer amount returns boolean
		return AUnitAddBonus(whichUnit, bonusType, -amount)
	endfunction

	/**
	 * So here you set each of the bonus abilities, 0 is damage, 1 armor, 2 health, and 3 mana
	 * The second numbers are the powers (2^1 is 1, 2^2=4, 2^3=8, ...
	 * Remember: Last power ability should be negative.
	 */
	function AInitBonusMod takes nothing returns nothing
		//Damage
		set abilityId[Ix(A_BONUS_TYPE_DAMAGE, 0)] = 'AZZ0' //+001
		set abilityId[Ix(A_BONUS_TYPE_DAMAGE, 1)] = 'AZZ1' //+002
		set abilityId[Ix(A_BONUS_TYPE_DAMAGE, 2)] = 'AZZ2' //+004
		set abilityId[Ix(A_BONUS_TYPE_DAMAGE, 3)] = 'AZZ3' //+008
		set abilityId[Ix(A_BONUS_TYPE_DAMAGE, 4)] = 'AZZ4' //+016
		set abilityId[Ix(A_BONUS_TYPE_DAMAGE, 5)] = 'AZZ5' //+032
		set abilityId[Ix(A_BONUS_TYPE_DAMAGE, 6)] = 'AZZ6' //+064
		set abilityId[Ix(A_BONUS_TYPE_DAMAGE, 7)] = 'AZZ7' //+128
		set abilityId[Ix(A_BONUS_TYPE_DAMAGE, 8)] = 'AZZ8' //+256
		set abilityId[Ix(A_BONUS_TYPE_DAMAGE, 9)] = 'AZZ9' //-512
		//Armor
		set abilityId[Ix(A_BONUS_TYPE_ARMOR, 0)] = 'AZY0' //+001
		set abilityId[Ix(A_BONUS_TYPE_ARMOR, 1)] = 'AZY1' //+002
		set abilityId[Ix(A_BONUS_TYPE_ARMOR, 2)] = 'AZY2' //+004
		set abilityId[Ix(A_BONUS_TYPE_ARMOR, 3)] = 'AZY3' //+008
		set abilityId[Ix(A_BONUS_TYPE_ARMOR, 4)] = 'AZY4' //+016
		set abilityId[Ix(A_BONUS_TYPE_ARMOR, 5)] = 'AZY5' //+032
		set abilityId[Ix(A_BONUS_TYPE_ARMOR, 6)] = 'AZY6' //+064
		set abilityId[Ix(A_BONUS_TYPE_ARMOR, 7)] = 'AZY7' //+128
		set abilityId[Ix(A_BONUS_TYPE_ARMOR, 8)] = 'AZY8' //+256
		set abilityId[Ix(A_BONUS_TYPE_ARMOR, 9)] = 'AZY9' //-512
		//Life
		set abilityId[Ix(A_BONUS_TYPE_LIFE, 0)] = 'AZX0' //+0010
		set abilityId[Ix(A_BONUS_TYPE_LIFE, 1)] = 'AZX1' //+0020
		set abilityId[Ix(A_BONUS_TYPE_LIFE, 2)] = 'AZX2' //+0040
		set abilityId[Ix(A_BONUS_TYPE_LIFE, 3)] = 'AZX3' //+0080
		set abilityId[Ix(A_BONUS_TYPE_LIFE, 4)] = 'AZX4' //+0160
		set abilityId[Ix(A_BONUS_TYPE_LIFE, 5)] = 'AZX5' //+0320
		set abilityId[Ix(A_BONUS_TYPE_LIFE, 6)] = 'AZX6' //+0640
		set abilityId[Ix(A_BONUS_TYPE_LIFE, 7)] = 'AZX7' //+1280
		set abilityId[Ix(A_BONUS_TYPE_LIFE, 8)] = 'AZX8' //+2560
		set abilityId[Ix(A_BONUS_TYPE_LIFE, 9)] = 'AZX9' //-5120
		//Mana
		set abilityId[Ix(A_BONUS_TYPE_MANA, 0)] = 'AZW0' //+0010
		set abilityId[Ix(A_BONUS_TYPE_MANA, 1)] = 'AZW1' //+0020
		set abilityId[Ix(A_BONUS_TYPE_MANA, 2)] = 'AZW2' //+0040
		set abilityId[Ix(A_BONUS_TYPE_MANA, 3)] = 'AZW3' //+0080
		set abilityId[Ix(A_BONUS_TYPE_MANA, 4)] = 'AZW4' //+0160
		set abilityId[Ix(A_BONUS_TYPE_MANA, 5)] = 'AZW5' //+0320
		set abilityId[Ix(A_BONUS_TYPE_MANA, 6)] = 'AZW6' //+0640
		set abilityId[Ix(A_BONUS_TYPE_MANA, 7)] = 'AZW7' //+1280
		set abilityId[Ix(A_BONUS_TYPE_MANA, 8)] = 'AZW8' //+2560
		set abilityId[Ix(A_BONUS_TYPE_MANA, 9)] = 'AZW9' //-5120
		//Sight Range
		set abilityId[Ix(A_BONUS_TYPE_SIGHT_RANGE, 0)] = 'AZV0' //+0010
		set abilityId[Ix(A_BONUS_TYPE_SIGHT_RANGE, 1)] = 'AZV1' //+0020
		set abilityId[Ix(A_BONUS_TYPE_SIGHT_RANGE, 2)] = 'AZV2' //+0040
		set abilityId[Ix(A_BONUS_TYPE_SIGHT_RANGE, 3)] = 'AZV3' //+0080
		set abilityId[Ix(A_BONUS_TYPE_SIGHT_RANGE, 4)] = 'AZV4' //+0160
		set abilityId[Ix(A_BONUS_TYPE_SIGHT_RANGE, 5)] = 'AZV5' //+0320
		set abilityId[Ix(A_BONUS_TYPE_SIGHT_RANGE, 6)] = 'AZV6' //+0640
		set abilityId[Ix(A_BONUS_TYPE_SIGHT_RANGE, 7)] = 'AZV7' //+1280
		set abilityId[Ix(A_BONUS_TYPE_SIGHT_RANGE, 8)] = 'AZV8' //+2560
		set abilityId[Ix(A_BONUS_TYPE_SIGHT_RANGE, 9)] = 'AZV9' //-5120
		//Life Regeneration
		set abilityId[Ix(A_BONUS_TYPE_LIFE_REGENERATION, 0)] = 'AZU0' //+001
		set abilityId[Ix(A_BONUS_TYPE_LIFE_REGENERATION, 1)] = 'AZU1' //+002
		set abilityId[Ix(A_BONUS_TYPE_LIFE_REGENERATION, 2)] = 'AZU2' //+004
		set abilityId[Ix(A_BONUS_TYPE_LIFE_REGENERATION, 3)] = 'AZU3' //+008
		set abilityId[Ix(A_BONUS_TYPE_LIFE_REGENERATION, 4)] = 'AZU4' //+016
		set abilityId[Ix(A_BONUS_TYPE_LIFE_REGENERATION, 5)] = 'AZU5' //+032
		set abilityId[Ix(A_BONUS_TYPE_LIFE_REGENERATION, 6)] = 'AZU6' //+064
		set abilityId[Ix(A_BONUS_TYPE_LIFE_REGENERATION, 7)] = 'AZU7' //+128
		set abilityId[Ix(A_BONUS_TYPE_LIFE_REGENERATION, 8)] = 'AZU8' //+256
		set abilityId[Ix(A_BONUS_TYPE_LIFE_REGENERATION, 9)] = 'AZU9' //-512
		//Mana Regneration
		set abilityId[Ix(A_BONUS_TYPE_MANA_REGENERATION, 0)] = 'AZT0' //+001
		set abilityId[Ix(A_BONUS_TYPE_MANA_REGENERATION, 1)] = 'AZT1' //+002
		set abilityId[Ix(A_BONUS_TYPE_MANA_REGENERATION, 2)] = 'AZT2' //+004
		set abilityId[Ix(A_BONUS_TYPE_MANA_REGENERATION, 3)] = 'AZT3' //+008
		set abilityId[Ix(A_BONUS_TYPE_MANA_REGENERATION, 4)] = 'AZT4' //+016
		set abilityId[Ix(A_BONUS_TYPE_MANA_REGENERATION, 5)] = 'AZT5' //+032
		set abilityId[Ix(A_BONUS_TYPE_MANA_REGENERATION, 6)] = 'AZT6' //+064
		set abilityId[Ix(A_BONUS_TYPE_MANA_REGENERATION, 7)] = 'AZT7' //+128
		set abilityId[Ix(A_BONUS_TYPE_MANA_REGENERATION, 8)] = 'AZT8' //+256
		set abilityId[Ix(A_BONUS_TYPE_MANA_REGENERATION, 9)] = 'AZT9' //-512
		set hashTable = AHashTable.create()
	endfunction

endlibrary
