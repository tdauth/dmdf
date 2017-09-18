library ALibraryCoreEnvironmentDestructable

	/**
	 * \author PitzerMike
	 * <a href="http://www.wc3c.net/showthread.php?t=103927">source</a>
	 */
	function IsDestructableDead takes destructable usedDestructable returns boolean
		return GetDestructableLife(usedDestructable) <= 0.405
	endfunction

	/**
	 * You could use globals instead of locals for dummy and player.
	 * \author PitzerMike
	 * <a href="http://www.wc3c.net/showthread.php?t=103927">source</a>
	 */
	function IsDestructableTree takes destructable usedDestructable returns boolean
		local player neutralPassivePlayer = Player(PLAYER_NEUTRAL_PASSIVE)
		local boolean isInvulnerable = IsDestructableInvulnerable(usedDestructable)
		local unit dummy = CreateUnit(neutralPassivePlayer, 'h000', GetWidgetX(usedDestructable), GetWidgetY(usedDestructable), 0.0)
		local boolean result = false
		call UnitAddAbility(dummy, 'Ahrl')
		if (isInvulnerable) then
			call SetDestructableInvulnerable(usedDestructable, false)
		endif
		set result = IssueTargetOrder(dummy, "harvest", usedDestructable)
		call RemoveUnit(dummy)
		set dummy = null
		if (isInvulnerable) then
			call SetDestructableInvulnerable(usedDestructable, true)
		endif
		set neutralPassivePlayer = null
		return result
	endfunction

	/**
	 * Creates a dummy unit which tries to harvest the filtered destructable.
	 * It should only used by filters.
	 * \return Returns true if the filtered destructable is a tree.
	 * \author PitzerMike
	 * <a href="http://www.wc3c.net/showthread.php?t=103927">source</a>
	 */
	function TreeFilter takes nothing returns boolean
		local destructable filterDestructable = GetFilterDestructable()
		local boolean result = IsDestructableTree(filterDestructable)
		set filterDestructable = null
		return result
	endfunction

endlibrary