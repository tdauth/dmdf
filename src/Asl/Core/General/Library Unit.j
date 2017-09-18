library ALibraryCoreGeneralUnit requires AStructCoreGeneralHashTable, ALibraryCoreGeneralItem

	globals
		constant integer A_ORDER_ID_SMART = 851971
		constant integer A_ORDER_ID_SKILL_MENU = 852000
		constant integer A_ORDER_ID_BUILD_MENU = 851994
		constant integer A_ORDER_ID_MOVE_SLOT_0 = 852002
		constant integer A_ORDER_ID_MOVE_SLOT_1 = 852003
		constant integer A_ORDER_ID_MOVE_SLOT_2 = 852004
		constant integer A_ORDER_ID_MOVE_SLOT_3 = 852005
		constant integer A_ORDER_ID_MOVE_SLOT_4 = 852006
		constant integer A_ORDER_ID_MOVE_SLOT_5 = 852007
		constant integer A_ORDER_ID_USE_SLOT_0 = 852008
		constant integer A_ORDER_ID_USE_SLOT_1 = 852009
		constant integer A_ORDER_ID_USE_SLOT_2 = 852010
		constant integer A_ORDER_ID_USE_SLOT_3 = 852011
		constant integer A_ORDER_ID_USE_SLOT_4 = 852012
		constant integer A_ORDER_ID_USE_SLOT_5 = 852013
		constant integer A_ORDER_ID_CANCEL = 851976
		constant integer A_ORDER_ID_STUNNED = 851973
	endglobals

	/**
	* Sicheres Iterieren per FirstOfGroup
	*
	* Heyhey,
	*
	* dieser Bug (oder Feature, je nachdem wie mans nimmt) hat mich etwa 4 Stunden debuggen
	* gekostet.
	*
	* Hintergrund: Wie ihr wisst kann man ja über eine Unitgroup iterieren (und diese dabei leeren)
	* (Die Gruppe nenne ich einfach mal g):
	*
	* \code
	* local unit u
	* loop
	* 	set u = FirstOfGroup(g)
	* 	exitwhen u == null
	*
	* 	//HIER das mit der unit machen was man machen will
	*
	* 	call GroupRemoveUnit(g,u)
	* endloop
	* \endcode
	*
	* Tja, nur blöd dass das buggy ist, sobald einmal eine unit in der Gruppe aus dem Spiel
	* entfernt wurde ohne sie vorher ordnungsgemäß aus der Gruppe zu removen. Das wusste ich bisher
	* auch nicht.
	*
	* Beispiel:
	* Wir adden in eine Gruppe 4 units. Dann entfernen wir die erste geaddete unit per
	* RemoveUnit(...) aus dem Spiel. Nun ist die Gruppe kaputt (zumindest für das Iterieren per
	* FirstOfGroup()). Denn FirstOfGroup(g) wird nun null liefern, die schleife endet also sofort
	* obwohl drei units in der Group sind. Denn die "Lücke" die die unit hinterlassen hat bleibt in
	* der Group. Und das blödeste: Diese lücke können wir auch nicht mehr per call
	* GroupRemoveUnit(FirstOfGroup()) entfernen, da ja FoG nun null zurückliefert und
	* GroupRemoveUnit(null) nichts macht.
	*
	*
	* ALSO VORSICHT! Das FirstOfGroup(...) null zurückliefert heisst nicht unbedingt, dass die
	* Gruppe leer ist!
	*
	* Deshalb hab ich mir eine kleine Funktion geschrieben die äquivalent zu einem Aufruf von
	* FirstOfGroup ist, aber solche Lücken erkennt und die Gruppe automatisch repariert sobald sie
	* auf so eine Lücke trifft, hier ist sie:
	*
	* Die Idee:
	* Erstmal führt die Funktion ein normales FirstOfGroup auf die gewünschte Gruppe aus. Liefert
	* dieser aufruf NICHT null, klappt ja alles perfekt, dann gibt sie einfach die unit zurück.
	* Liefert der Aufruf aber null können zwei Fälle eingetreten sein:
	*
	* 1.) Die Group ist tatsächlich empty
	* 2.) Wir sind auf eine Lücke gestoßen die repariert werden muss.
	*
	* Das überprüfen wir einfach indem wir ein GroupIsEmpty-derivat aufrufen. Liefert es true
	* zurück war die gruppe wirklich leer und wir können null returnen. sonst reparieren wir sie,
	* das geht so:
	* Wir kopieren per ForGroup alle units in eine swap gruppe. Dabei werden lücken nicht
	* mitkopiert, da ForGroup so schlau ist und solche lücken beim iterieren nicht beachtet. Dann
	* leeren wir die gruppe und kopieren einfach die units aus der swapgruppe zurück und fertig ist
	* die reparierte Gruppe auf die wir nun ein erneutes FirstOfGroup aufrufen um die wirkliche
	* first unit zu ermitteln die wir zurück geben.
	*
	* Ich empfehle euch dringend diese Funktion zu benutzen wenn ihr über eine Group per
	* FirstOfGroup iterieren wollt, aber nicht sicher sein könnt, dass keine unit jemals aus dem
	* Spiel entfernt wurde (was auch nach dem normalen tod und dekay automatisch passiert) die in
	* der Gruppe war.
	*
	* Hoffe ich kann euch damit die Stunden des Bugfixen die ich hatte ersparen...
	* \author gexxo
	* \param g Used unit group.
	* \return Returns the first unit of group g. If the group is empty it will return null.
	*/
	function FirstOfGroupSave takes group g returns unit
		local unit u = FirstOfGroup(g) //Try a normal first of group
		local group swap

		// If the result is null there may be gaps in the group
		if u == null then
			//Check if the group is empty. If it is not, then there must be gaps -> repair
			set bj_isUnitGroupEmptyResult = true
			call ForGroup(g, function IsUnitGroupEmptyBJEnum)
			if not bj_isUnitGroupEmptyResult then
				//** Repair the group **
				set swap = CreateGroup()
				call GroupAddGroup(g,swap) //Add all units to a swapping group
				call GroupClear(g) //Clear the buggy group hence removing the gaps
				call GroupAddGroup(swap,g) //Put the units back in from the swapping group

				//Collect garbage
				call DestroyGroup(swap)
				set swap = null

				//Do another FirstOfGroup to gain the real first unit
				set u = FirstOfGroup(g)
			endif
		endif

		return u //Return the unit we wanted
	endfunction

	/// \author Tamino Dauth
	/// \todo Probably bugged, do not use.
	function MoveItemToSlot takes unit whichUnit, item usedItem, integer slot returns boolean
		return IssueTargetOrderById(whichUnit, A_ORDER_ID_MOVE_SLOT_0 + slot, usedItem)
	endfunction

	/// \author Tamino Dauth
	/// \todo Probably bugged, do not use.
	function UseItemOfSlot takes unit whichUnit, integer slot returns boolean
		return IssueImmediateOrderById(whichUnit, A_ORDER_ID_USE_SLOT_0 + slot)
	endfunction

	/// \author Tamino Dauth
	/// \todo Probably bugged, do not use.
	function UseItemOfSlotOnTarget takes unit whichUnit, integer slot, widget target returns boolean
		return IssueTargetOrderById(whichUnit, A_ORDER_ID_USE_SLOT_0 + slot, target)
	endfunction

	/// \author Tamino Dauth
	/// \todo Probably bugged, do not use.
	function UseItemOfSlotOnPoint takes unit whichUnit, integer slot, real x, real y returns boolean
		return IssuePointOrderById(whichUnit, A_ORDER_ID_USE_SLOT_0 + slot, x, y)
	endfunction

	/// \author Tamino Dauth
	function UnitDropSlot takes unit whichUnit, integer slot0, integer slot1 returns boolean
		local item slotItem = UnitItemInSlot(whichUnit, slot0)
		local boolean result = UnitDropItemSlot(whichUnit, slotItem, slot1)
		set slotItem = null
		return result
	endfunction

	/**
	 * \return Missing life of unit \p whichUnit.
	 * \author Tamino Dauth
	 */
	function GetUnitMissingLife takes unit whichUnit returns real
		return GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE) - GetUnitState(whichUnit, UNIT_STATE_LIFE)
	endfunction

	/**
	 * \return Missing life of unit \p whichUnit in percent.
	 * \author Tamino Dauth
	 */
	function GetUnitMissingLifePercent takes unit whichUnit returns real
		return 100.0 - GetUnitStatePercent(whichUnit, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE)
	endfunction

	/**
	 * \return Missing mana of unit \p whichUnit.
	 * \author Tamino Dauth
	 */
	function GetUnitMissingMana takes unit whichUnit returns real
		return GetUnitState(whichUnit, UNIT_STATE_MAX_MANA) - GetUnitState(whichUnit, UNIT_STATE_MANA)
	endfunction

	/**
	 * \return Missing mana of unit \p whichUnit in percent.
	 * \author Tamino Dauth
	 */
	function GetUnitMissingManaPercent takes unit whichUnit returns real
		return 100.0 - GetUnitStatePercent(whichUnit, UNIT_STATE_MANA, UNIT_STATE_MAX_MANA)
	endfunction

	/**
	 * Copies unit \p whichUnit by using state method \p stateMethod to copy unit's life and mana and creates the copy at position with \p x and \p y coordinates and facing angel \p facing (degrees).
	 * Data which cannot be copied by this function:
	 * <ul>
	 * <li>if unit is creep guard - \ref SetUnitCreepGuard()</li>
	 * <li>unit's custom player color - \ref SetUnitColor()</li>
	 * <li>unit's scale - \ref SetUnitScale()</li>
	 * <li>unit's time scale - \ref SetUnitTimeScale()</li>
	 * <li>unit's blend time - \ref SetUnitBlendTime()</li>
	 * <li>unit's vertex color - \ref SetUnitVertexColor()</li>
	 * <li>unit's animation queue and current animation - \ref QueueUnitAnimation(), \ref SetUnitAnimation(), \ref SetUnitAnimationByIndex()</li>
	 * <li>unit's animation rarity - \ref SetUnitAnimationWithRarity()</li>
	 * <li>unit's look target - \ref SetUnitLookAt(), \ref ResetUnitLookAt()</li>
	 * <li>if unit is rescuable - \ref SetUnitRescuable(), \ref SetUnitRescueRange()</li>
	 * <li>hero's proper name - \ref GetHeroProperName()</li>
	 * <li>unit's ability data - \ref GetUnitAbilityLevel(), \ref DecUnitAbilityLevel(), \ref IncUnitAbilityLevel(), \ref SetUnitAbilityLevel(), \ref UnitAddAbility(), \ref UnitRemoveAbility(), \ref UnitMakeAbilityPermanent()</li>
	 * <li>unit's buff data - \ref UnitRemoveBuffs(), \ref UnitRemoveBuffsEx(), \ref UnitHasBuffsEx(), \ref UnitCountBuffsEx()</li>
	 * <li>if unit should explode - \ref SetUnitExploded()</li>
	 * <li>if unit's pathing is enabled - \ref SetUnitPathing()</li>
	 * <li>if unit uses food - \ref SetUnitUseFood()</li>
	 * <li>if unit is an illusion (copy won't be one) - \ref IsUnitIllusion()</li>
	 * <li>if unit is transported (copy won't be) - \ref IsUnitInTransport()</li>
	 * <li>if unit is loaded (copy won't be) - \ref IsUnitLoaded()</li>
	 * <li>unit's customly shared visions - \ref UnitShareVision()</li>
	 * <li>if unit's decay is suspended - \ref UnitSuspendDecay()</li>
	 * <li>if unit sleeps permanently - \ref UnitAddSleepPerm()</li>
	 * <li>if unit has applied and paused timed life (copy won't have) - \ref UnitApplyTimedLife(), \ref UnitPauseTimedLife()</li>
	 * <li>unit's abilities cooldowns - \ref UnitResetCooldown()</li>
	 * <li>unit's construction progress - \ref UnitSetConstructionProgress()</li>
	 * <li>unit's upgrade progress - \ref UnitSetUpgradeProgress()</li>
	 * <li>if unit uses alternative icon - \ref UnitSetUsesAltIcon()</li>
	 * <li>unit's current order (since we don't know what kind of target - \ref GetUnitCurrentOrder()</li>
	 * <li>unit's custom stock items and their slots - \ref AddItemToStock(), \ref SetItemTypeSlots()</li>
	 * <li>unit's custom stock units - \ref AddUnitToStock(), \ref SetUnitTypeSlots()</li>
	 * </ul>
	 * \return Returns the copied version.
	 * \note Uses \ref CopyItemToItem() to copy unit inventory's items (which lacks of some copy functionality limited by JASS natives as well). Consider that \ref ReplaceUnitBJ() doesn't lack of this feature since it moves the original items into the replacing unit's inventory!
	 * \sa CopyItemToItem()
	 * \sa CopyItem()
	 * \sa ReplaceUnitBJ()
	 * \author Tamino Dauth
	 * \todo Complete!
	 */
	function CopyUnit takes unit whichUnit, real x, real y, real facing, integer stateMethod returns unit
		local player owner = GetOwningPlayer(whichUnit)
		local unit result
		local real oldRatio
		local player user
		local integer i
		local item oldSlotItem
		local integer inventorySize
		if (GetUnitTypeId(whichUnit) == 'ugol') then
			set result = CreateBlightedGoldmine(owner, x, y, facing)
		else
			set result = CreateUnit(owner, GetUnitTypeId(whichUnit), x, y, facing)
		endif

		// NOTE update inventory before pausing etc. since this seems to prevent items from being added!
		set inventorySize = IMinBJ(UnitInventorySize(whichUnit),  UnitInventorySize(result))

		if (inventorySize > 0) then
			set i = 0
			loop
				exitwhen (i == inventorySize)
				set oldSlotItem = UnitItemInSlot(whichUnit, i)
				if (oldSlotItem != null) then
					if (UnitAddItemToSlotById(result, GetItemTypeId(oldSlotItem), i)) then
						call CopyItemToItem(oldSlotItem, UnitItemInSlot(result, i))
					endif
					set oldSlotItem = null
				endif
				set i = i + 1
			endloop
		endif

		call ShowUnit(result, not IsUnitHidden(whichUnit))
		call PauseUnit(result, IsUnitPaused(whichUnit))
		call SetResourceAmount(result, GetResourceAmount(whichUnit))
		call SetUnitUserData(result, GetUnitUserData(whichUnit))

		// waygate data
		call WaygateSetDestination(result, WaygateGetDestinationX(whichUnit), WaygateGetDestinationY(whichUnit))
		call WaygateActivate(result, WaygateIsActive(whichUnit))

		call UnitAddSleep(result, UnitIsSleeping(whichUnit))
		call UnitIgnoreAlarm(result, UnitIgnoreAlarmToggled(whichUnit))

		/**
		TODO add these functions to the list since some values could be modified even without any item boni.
		Don't add item boni!
		call SetUnitMoveSpeed(result, GetUnitMoveSpeed(whichUnit))
		call SetUnitFlyHeight(result, GetUnitFlyHeight(whichUnit), 0.0
		call SetUnitTurnSpeed(result, GetUnitTurnSpeed(whichUnit))
		call SetUnitPropWindow(result, GetUnitPropWindow(whichUnit))
		call SetUnitAcquireRange(result, GetUnitAcquireRange(whichUnit))
		*/

		// all unit types
		if (IsUnitType(whichUnit, UNIT_TYPE_HERO)) then
			call UnitAddType(result, UNIT_TYPE_HERO)
		else
			call UnitRemoveType(result, UNIT_TYPE_HERO)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_DEAD)) then
			call UnitAddType(result, UNIT_TYPE_DEAD)
		else
			call UnitRemoveType(result, UNIT_TYPE_DEAD)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_STRUCTURE)) then
			call UnitAddType(result, UNIT_TYPE_STRUCTURE)
		else
			call UnitRemoveType(result, UNIT_TYPE_STRUCTURE)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_FLYING)) then
			call UnitAddType(result, UNIT_TYPE_FLYING)
		else
			call UnitRemoveType(result, UNIT_TYPE_FLYING)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_GROUND)) then
			call UnitAddType(result, UNIT_TYPE_GROUND)
		else
			call UnitRemoveType(result, UNIT_TYPE_GROUND)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_ATTACKS_FLYING)) then
			call UnitAddType(result, UNIT_TYPE_ATTACKS_FLYING)
		else
			call UnitRemoveType(result, UNIT_TYPE_ATTACKS_FLYING)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_ATTACKS_GROUND)) then
			call UnitAddType(result, UNIT_TYPE_ATTACKS_GROUND)
		else
			call UnitRemoveType(result, UNIT_TYPE_ATTACKS_GROUND)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_MELEE_ATTACKER)) then
			call UnitAddType(result, UNIT_TYPE_MELEE_ATTACKER)
		else
			call UnitRemoveType(result, UNIT_TYPE_MELEE_ATTACKER)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_RANGED_ATTACKER)) then
			call UnitAddType(result, UNIT_TYPE_RANGED_ATTACKER)
		else
			call UnitRemoveType(result, UNIT_TYPE_RANGED_ATTACKER)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_GIANT)) then
			call UnitAddType(result, UNIT_TYPE_GIANT)
		else
			call UnitRemoveType(result, UNIT_TYPE_GIANT)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_SUMMONED)) then
			call UnitAddType(result, UNIT_TYPE_SUMMONED)
		else
			call UnitRemoveType(result, UNIT_TYPE_SUMMONED)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_STUNNED)) then
			call UnitAddType(result, UNIT_TYPE_STUNNED)
		else
			call UnitRemoveType(result, UNIT_TYPE_STUNNED)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_PLAGUED)) then
			call UnitAddType(result, UNIT_TYPE_PLAGUED)
		else
			call UnitRemoveType(result, UNIT_TYPE_PLAGUED)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_SNARED)) then
			call UnitAddType(result, UNIT_TYPE_SNARED)
		else
			call UnitRemoveType(result, UNIT_TYPE_SNARED)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_UNDEAD)) then
			call UnitAddType(result, UNIT_TYPE_UNDEAD)
		else
			call UnitRemoveType(result, UNIT_TYPE_UNDEAD)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_MECHANICAL)) then
			call UnitAddType(result, UNIT_TYPE_MECHANICAL)
		else
			call UnitRemoveType(result, UNIT_TYPE_MECHANICAL)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_PEON)) then
			call UnitAddType(result, UNIT_TYPE_PEON)
		else
			call UnitRemoveType(result, UNIT_TYPE_PEON)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_SAPPER)) then
			call UnitAddType(result, UNIT_TYPE_SAPPER)
		else
			call UnitRemoveType(result, UNIT_TYPE_SAPPER)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_TOWNHALL)) then
			call UnitAddType(result, UNIT_TYPE_TOWNHALL)
		else
			call UnitRemoveType(result, UNIT_TYPE_TOWNHALL)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_ANCIENT)) then
			call UnitAddType(result, UNIT_TYPE_ANCIENT)
		else
			call UnitRemoveType(result, UNIT_TYPE_ANCIENT)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_TAUREN)) then
			call UnitAddType(result, UNIT_TYPE_TAUREN)
		else
			call UnitRemoveType(result, UNIT_TYPE_TAUREN)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_POISONED)) then
			call UnitAddType(result, UNIT_TYPE_POISONED)
		else
			call UnitRemoveType(result, UNIT_TYPE_POISONED)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_POLYMORPHED)) then
			call UnitAddType(result, UNIT_TYPE_POLYMORPHED)
		else
			call UnitRemoveType(result, UNIT_TYPE_POLYMORPHED)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_SLEEPING)) then
			call UnitAddType(result, UNIT_TYPE_SLEEPING)
		else
			call UnitRemoveType(result, UNIT_TYPE_SLEEPING)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_RESISTANT)) then
			call UnitAddType(result, UNIT_TYPE_RESISTANT)
		else
			call UnitRemoveType(result, UNIT_TYPE_RESISTANT)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_SLEEPING)) then
			call UnitAddType(result, UNIT_TYPE_SLEEPING)
		else
			call UnitRemoveType(result, UNIT_TYPE_SLEEPING)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_MAGIC_IMMUNE)) then
			call UnitAddType(result, UNIT_TYPE_MAGIC_IMMUNE)
		else
			call UnitRemoveType(result, UNIT_TYPE_MAGIC_IMMUNE)
		endif

		if (IsUnitType(whichUnit, UNIT_TYPE_MAGIC_IMMUNE)) then
			call UnitAddType(result, UNIT_TYPE_MAGIC_IMMUNE)
		else
			call UnitRemoveType(result, UNIT_TYPE_MAGIC_IMMUNE)
		endif

		// Set the unit's life and mana according to the requested method.
		if (stateMethod == bj_UNIT_STATE_METHOD_RELATIVE) then
			// Set the replacement's current/max life ratio to that of the old unit.
			// If both units have mana, do the same for mana.
			if (GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE) > 0) then
				set oldRatio = GetUnitState(whichUnit, UNIT_STATE_LIFE) / GetUnitState(whichUnit, UNIT_STATE_MAX_LIFE)
				call SetUnitState(result, UNIT_STATE_LIFE, oldRatio * GetUnitState(result, UNIT_STATE_MAX_LIFE))
			endif
			if (GetUnitState(whichUnit, UNIT_STATE_MAX_MANA) > 0) and (GetUnitState(result, UNIT_STATE_MAX_MANA) > 0) then
				set oldRatio = GetUnitState(whichUnit, UNIT_STATE_MANA) / GetUnitState(whichUnit, UNIT_STATE_MAX_MANA)
				call SetUnitState(result, UNIT_STATE_MANA, oldRatio * GetUnitState(result, UNIT_STATE_MAX_MANA))
			endif
		elseif (stateMethod == bj_UNIT_STATE_METHOD_ABSOLUTE) then
			// Set the replacement's current life to that of the old unit.
			// If the new unit has mana, do the same for mana.
			call SetUnitState(result, UNIT_STATE_LIFE, GetUnitState(whichUnit, UNIT_STATE_LIFE))
			if (GetUnitState(result, UNIT_STATE_MAX_MANA) > 0) then
				call SetUnitState(result, UNIT_STATE_MANA, GetUnitState(whichUnit, UNIT_STATE_MANA))
			endif
		elseif (stateMethod == bj_UNIT_STATE_METHOD_DEFAULTS) then
			// The newly created unit should already have default life and mana.
		elseif (stateMethod == bj_UNIT_STATE_METHOD_MAXIMUM) then
			// Use max life and mana.
			call SetUnitState(result, UNIT_STATE_LIFE, GetUnitState(result, UNIT_STATE_MAX_LIFE))
			call SetUnitState(result, UNIT_STATE_MANA, GetUnitState(result, UNIT_STATE_MAX_MANA))
		endif

		set i = 0
		loop
			exitwhen (i == bj_MAX_PLAYERS)
			set user = Player(i)
			if (IsUnitSelected(whichUnit, user)) then
				call SelectUnitAddForPlayer(result, user)
			endif
			set user = null
			set i = i + 1
		endloop

		if (IsUnitType(whichUnit, UNIT_TYPE_HERO) and IsUnitType(result, UNIT_TYPE_HERO)) then
			call SetHeroLevel(result, GetHeroLevel(whichUnit), false)
			call SetHeroXP(result, GetHeroXP(whichUnit), false)
			call SetHeroStr(result, GetHeroStr(whichUnit, false), true)
			call SetHeroAgi(result, GetHeroAgi(whichUnit, false), true)
			call SetHeroInt(result, GetHeroInt(whichUnit, false), true)
			call SuspendHeroXP(result, IsSuspendedXP(whichUnit))
			call UnitModifySkillPoints(result, GetHeroSkillPoints(whichUnit) - GetHeroSkillPoints(result))
		endif

		/// TODO Selection!
		//constant native IsUnitSelected      takes unit whichUnit, player whichPlayer returns boolean

		// rally point
		if (GetUnitRallyPoint(whichUnit) != null) then
			call SetUnitRallyPoint(result, GetUnitRallyPoint(whichUnit))
		endif

		if (GetUnitRallyUnit(whichUnit) != null) then
			call SetUnitRallyUnit(result, GetUnitRallyUnit(whichUnit))
		endif

		if (GetUnitRallyDestructable(whichUnit) != null) then
			call SetUnitRallyDestructable(result, GetUnitRallyDestructable(whichUnit))
		endif

		return result
	endfunction

	/**
	 * \sa CreateUnitsAtRect() CreateCorpsesAtPoint() CreateUnitAtRect() CreateCorpseAtRect()
	 * \author Tamino Dauth
	 */
	function CreateUnitsAtPoint takes integer count, integer unitTypeId, player whichPlayer, real x, real y, real face returns group
		local group unitGroup = CreateGroup()
		loop
			set count = count - 1
			exitwhen (count < 0)
			call GroupAddUnit(unitGroup,  CreateUnit(whichPlayer, unitTypeId, x, y, face))
		endloop
		return unitGroup
	endfunction

	/**
	 * \sa CreateUnitsAtPoint() CreateCorpsesAtPoint() CreateUnitAtRect() CreateCorpseAtRect()
	 * \author Tamino Dauth
	 */
	function CreateUnitsAtRect takes integer count, integer unitTypeId, player whichPlayer, rect whichRect, real face returns group
		local group unitGroup = CreateGroup()
		loop
			set count = count - 1
			exitwhen (count < 0)
			call GroupAddUnit(unitGroup,  CreateUnit(whichPlayer, unitTypeId, GetRectCenterX(whichRect), GetRectCenterY(whichRect), face))
		endloop
		return unitGroup
	endfunction

	/**
	 * \sa CreateUnitsAtPoint() CreateUnitsAtRect() CreateUnitAtRect() CreateCorpseAtRect()
	 * \author Tamino Dauth
	 */
	function CreateCorpsesAtPoint takes integer count, integer unitTypeId, player whichPlayer, real x, real y, real face returns group
		local group unitGroup = CreateGroup()
		loop
			set count = count - 1
			exitwhen (count < 0)
			call GroupAddUnit(unitGroup, CreateCorpse(whichPlayer, unitTypeId, x, y, face))
		endloop
		return unitGroup
	endfunction

	/**
	 * \sa CreateUnitsAtPoint() CreateUnitsAtRect() CreateCorpsesAtPoint() CreateCorpseAtRect()
	 * \author Tamino Dauth
	 */
	function CreateUnitAtRect takes player whichPlayer, integer unitTypeId, rect whichRect, real facing returns unit
		return CreateUnit(whichPlayer, unitTypeId, GetRectCenterX(whichRect), GetRectCenterY(whichRect), facing)
	endfunction

	/**
	 * \sa CreateUnitsAtPoint() CreateUnitsAtRect() CreateCorpsesAtPoint() CreateUnitAtRect()
	 * \author Tamino Dauth
	 */
	function CreateCorpseAtRect takes player whichPlayer, integer unitTypeId, rect whichRect, real facing returns unit
		return CreateCorpse(whichPlayer, unitTypeId, GetRectCenterX(whichRect), GetRectCenterY(whichRect), facing)
	endfunction

	/**
	 * Doesn't pause or unpause already paused units.
	 * Doesn't try to unpause newly created units.
	 * Doesn't use global variable.
	 * Saves a key on each unit to identify paused unit.
	 * Key is removed automatically when unit is removed from game.
	 * \sa PauseAllUnitsBJ()
	 * \author Tamino Dauth
	 */
	function PauseAllUnits takes boolean pause returns nothing
		local integer i
		local player whichPlayer
		local group whichGroup
		local AGroup unitGroup
		local unit whichUnit
		set whichGroup = CreateGroup()
		set unitGroup = AGroup.create.evaluate() // can't require struct AGroup, requirement cycle
		set i = 0
		loop
			set whichPlayer = Player(i)
			// If this is a computer slot, pause/resume the AI.
			if (GetPlayerController(whichPlayer) == MAP_CONTROL_COMPUTER) then
				call PauseCompAI(whichPlayer, pause)
			endif
			// Enumerate and unpause every unit owned by the player.
			call GroupEnumUnitsOfPlayer(whichGroup, whichPlayer, null)
			set whichPlayer = null
			call unitGroup.addGroup.evaluate(whichGroup, false, true) // clears group
			set i = i + 1
			exitwhen (i == bj_MAX_PLAYER_SLOTS)
		endloop
		call DestroyGroup(whichGroup)
		set whichGroup = null
		set i = 0
		loop
			exitwhen (i == unitGroup.units.evaluate().size.evaluate())
			set whichUnit = unitGroup.units.evaluate().at.evaluate(i)
			if (pause and not IsUnitPaused(whichUnit)) then
				call PauseUnit(whichUnit, true)
				call AHashTable.global().setHandleBoolean(whichUnit, A_HASHTABLE_KEY_UNITPAUSE, true)
			elseif (not pause and AHashTable.global().hasHandleBoolean(whichUnit, A_HASHTABLE_KEY_UNITPAUSE)) then
				call PauseUnit(whichUnit, false)
				call AHashTable.global().removeHandleBoolean(whichUnit, A_HASHTABLE_KEY_UNITPAUSE)
			endif
			set whichUnit = null
			set i = i + 1
		endloop
		call unitGroup.destroy.evaluate()
	endfunction

	private function hookFunctionRemoveUnit takes unit whichUnit returns nothing
		if (AHashTable.global().hasHandleBoolean(whichUnit, A_HASHTABLE_KEY_UNITPAUSE)) then
			call AHashTable.global().removeHandleBoolean(whichUnit, A_HASHTABLE_KEY_UNITPAUSE)
		endif
	endfunction

	hook RemoveUnit hookFunctionRemoveUnit

	/**
	 * \return Returns non-permanent strength of \p hero.
	 * \sa GetHeroAgiBonus() GetHeroIntBonus() GetHeroStr() GetHeroAgi() GetHeroInt()
	 * \author Tamino Dauth
	 */
	function GetHeroStrBonus takes unit hero returns integer
		return GetHeroStr(hero, true) - GetHeroStr(hero, false)
	endfunction

	/**
	 * \return Returns non-permanent agility of \p hero.
	 * \sa GetHeroStrBonus() GetHeroIntBonus() GetHeroStr() GetHeroAgi() GetHeroInt()
	 * \author Tamino Dauth
	 */
	function GetHeroAgiBonus takes unit hero returns integer
		return GetHeroAgi(hero, true) - GetHeroAgi(hero, false)
	endfunction

	/**
	 * \return Returns non-permanent intelligence of \p hero.
	 * \sa GetHeroStrBonus() GetHeroAgiBonus() GetHeroStr() GetHeroAgi() GetHeroInt()
	 * \author Tamino Dauth
	 */
	function GetHeroIntBonus takes unit hero returns integer
		return GetHeroInt(hero, true) - GetHeroInt(hero, false)
	endfunction

endlibrary