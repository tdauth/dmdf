library ALibraryCoreInterfaceSelection

	/**
	 * \return Returns true if \p whichPlayer has no unit selection.
	 */
	function IsPlayerSelectionEmpty takes player whichPlayer returns boolean
		local group selectedUnits = CreateGroup()
		local boolean result = true
		call GroupEnumUnitsSelected(selectedUnits, whichPlayer, null)
		if (selectedUnits != null) then
			set result = false
		endif
		call DestroyGroup(selectedUnits)
		set selectedUnits = null
		return result
	endfunction

	/**
	 * \return Returns the first unit in selection of \p whichPlayer. Returns null if player has no selection.
	 */
	function GetFirstSelectedUnitOfPlayer takes player whichPlayer returns unit
		local group selectedUnits = null
		local unit selectedUnit = null // initial value if group is empty
		set selectedUnits = GetUnitsSelectedAll(whichPlayer)
		set selectedUnit = FirstOfGroup(selectedUnits)
		call DestroyGroup(selectedUnits)
		set selectedUnits = null
		return selectedUnit
	endfunction

	/// Makes a unit select- or unselectable by removing or adding the gasshopper ability.
	function MakeUnitSelectable takes unit whichUnit, boolean selectable returns nothing
		if (selectable) then
			call UnitRemoveAbility(whichUnit, 'Aloc')
		else
			call UnitAddAbility(whichUnit, 'Aloc')
		endif
	endfunction

endlibrary