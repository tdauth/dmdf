library ALibraryCoreGeneralItem requires AStructCoreGeneralHashTable

	/**
	 * Data which cannot be copied by this function:
	 * <ul>
	 * <li>if item is dropped on death - \ref SetItemDropOnDeath()</li>
	 * <li>if item is droppable - \ref SetItemDroppable()</li>
	 * <li>item drop id - \ref SetItemDropID()</li>
	 * </ul>
	 * \author Tamino Dauth
	 * \sa CopyItem()
	 * \sa CopyUnit()
	 */
	function CopyItemToItem takes item whichItem, item result returns nothing
		local player owner
		call SetItemCharges(result, GetItemCharges(whichItem))
		call SetItemInvulnerable(result, IsItemInvulnerable(whichItem))
		call SetWidgetLife(result, GetWidgetLife(whichItem))
		call SetItemPawnable(result, IsItemPawnable(whichItem))
		if (IsItemOwned(whichItem)) then
			set owner = GetItemPlayer(whichItem)
			call SetItemPlayer(result, owner, true)
			set owner = null
		endif
		call SetItemVisible(result, IsItemVisible(whichItem))
		call SetItemUserData(result, GetItemUserData(whichItem))
	endfunction

	/**
	 * Creates a copy of item \p whichItem at position with coordinates \p x and \p y.
	 * \author Tamino Dauth
	 * \sa CopyItemToItem()
	 */
	function CopyItem takes item whichItem, real x, real y returns item
		local item result = CreateItem(GetItemTypeId(whichItem), x, y)
		call CopyItemToItem(whichItem, result)
		return result
	endfunction

	/**
	* \return Returns name of item type \p itemTypeId.
	* \author Tamino Dauth
	*/
	function GetItemTypeIdName takes integer itemTypeId returns string
		local item whichItem = CreateItem(itemTypeId, 0.0, 0.0)
		local string result = GetItemName(whichItem)
		call RemoveItem(whichItem)
		set whichItem = null
		return result
	endfunction

	/**
	 * The sell system is made by the Hiveworkshop user MeKC:
	 * http://www.hiveworkshop.com/threads/detecting-item-price.120355/
	 * For better performance this system caches the item prices once they have been calculated.
	 */
	function GetUnitShop takes nothing returns integer
		return 'ngme'                                                               // This is the raw code for the goblin shop
	endfunction

	function GetUnitSell takes nothing returns integer
		return 'Hpal'                                                               // This is the raw code for the paladin
	endfunction

	/**
	 * Calculates the gold which a player gets for selling an item of type \p i.
	 * \param i Item type ID for which the gold is calculated.
	 * \return Returns the gold a player gets for selling an item of the specified type.
	 * \note This function has a quite poor performance. Use \ref GetItemValue() for better performance which relies on a cached value.
	 */
	function GetItemValueEx takes integer i returns integer
		local real x   = 0                                                          // This is the x position where we create the dummy units. Dont place it in the water.
		local real y   = 0                                                          // This is the y position where we create the dummy units. Dont place it in the water.
		local unit u1  = CreateUnit(Player(12),GetUnitShop(),x,y,0)
		local unit u2  = CreateUnit(Player(12),GetUnitSell(),x,y-100,90)
		local item a   = UnitAddItemByIdSwapped(i,u2)
		local integer g1 = GetPlayerState(Player(12),PLAYER_STATE_RESOURCE_GOLD)
		local integer g2 = 0
		call UnitDropItemTarget(u2,a,u1)
		set g2 = GetPlayerState(Player(12),PLAYER_STATE_RESOURCE_GOLD) - g1
		call SetPlayerState(Player(12),PLAYER_STATE_RESOURCE_GOLD,GetPlayerState(Player(12),PLAYER_STATE_RESOURCE_GOLD)-g2)
		call RemoveUnit(u1)
		call RemoveUnit(u2)
		set u1 = null
		set u2 = null
		set a  = null
		return g2
	endfunction

	function GetItemValue takes integer i returns integer
		if (AGlobalHashTable.global().hasInteger(A_HASHTABLE_GLOBAL_KEY_ITEMCOSTS, i)) then
			return AGlobalHashTable.global().integer(A_HASHTABLE_GLOBAL_KEY_ITEMCOSTS, i)
		endif

		return GetItemValueEx(i)
	endfunction

	/**
	 * Clears the cache of all item values which have been cached to this point of time.
	 */
	function ClearAllItemValues takes nothing returns nothing
		call AGlobalHashTable.global().flushKey(A_HASHTABLE_GLOBAL_KEY_ITEMCOSTS)
	endfunction

endlibrary