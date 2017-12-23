library ALibraryCoreMathsUnit requires ALibraryCoreGeneralUnit, ALibraryCoreMathsHandle, ALibraryCoreMathsPoint

	/**
	 * Calculates the distance between two units including their z coordinates.
	 * \note Do only use if z distance is really required. Otherwise use \ref GetDistanceBetweenUnits().
	 * \return Returns the distance between units \p unit0 and \p unit1.
	 */
	function GetDistanceBetweenUnitsWithZ takes unit unit0, unit unit1 returns real
		return GetDistanceBetweenUnits(unit0, unit1, GetUnitZ(unit0), GetUnitZ(unit1)) // ALibraryMathsHandle
	endfunction

	/// \note Does not create any locations.
	function SetUnitPolarProjectionPosition takes unit whichUnit, real angle, real distance returns nothing
		local real x = GetUnitPolarProjectionX(whichUnit, angle, distance)
		local real y = GetUnitPolarProjectionY(whichUnit, angle, distance)
		call SetUnitPosition(whichUnit, x, y)
		call SetUnitFacing(whichUnit, angle)
	endfunction

	/**
	 * Makes a unit flyable by adding and removing the ability "Crow Form".
	 * Thus you can change its high.
	 * \sa SetUnitFlyHeight()
	 * \sa SetUnitZ()
	 */
	function MakeUnitFlyable takes unit whichUnit returns nothing
		if (GetUnitAbilityLevel(whichUnit, 'Amrf') == 0) then
			call UnitAddAbility(whichUnit, 'Amrf')
			call UnitRemoveAbility(whichUnit, 'Amrf')
		endif
	endfunction

	/**
	 * Changes height of unit \p whichUnit to \p z.
	 * \param z Has to be greater than or equal to the ground height at which unit \p whichUnit is standing.
	 * \author WaterKnight
	 * <a href="https://warcraft.ingame.de/forum/showthread.php?p=3564125&postcount=13#post3564125">source</a>
	 * \sa GetUnitZ()
	 * \sa MakeUnitFlyable()
	 */
	function SetUnitZ takes unit whichUnit, real z returns nothing
		call MakeUnitFlyable(whichUnit)
		call SetUnitFlyHeight(whichUnit, z - GetUnitZ(whichUnit), 0.0) // ALibraryMathsHandle
	endfunction

	/**
	 * Beschreibung: Die Funktionen setzen eine Einheit auf angegebene Koordinaten, falls die Einheit
	 * auf diesen stehen könnte. Dabei wird die Betrachtung für jede Koordinate separat ausgeführt.
	 * Das heißt, die Einheit könnte in eine Achsenrichtung bewegt werden, auch wenn sie es in die
	 * Zweite nicht kann. Dadurch slidet sie an Grenzen, wenn die Bewegung in eine Richtung möglich
	 * ist. Die Funktionen returnen, ob die Einheit erfolgreich an die gegebenen Koordinaten bewegt
	 * wurde.
	 * Hinweise: Um zu entscheiden, ob die Einheit geblockt wird, wird ein kleiner Toleranzbereich
	 * genommen. Auf Bewegung bezogene Ereignisse werden ausgeführt, auch wenn die Einheit im
	 * Endeffekt zurückgesetzt wurde. Sowohl das Prüfen als auch das Zurücksetzen der Position
	 * erfolgt über Bewegungsaktionen, die auf die Einheit angewandt werden. Da die Funktionen wohl
	 * im Zusammenhang mit rekursiven Fortbewegungssystemen einer Einheit gebraucht werden (die
	 * vorigen Koordinaten einer Einheit werden ausgelesen, um sie zum Beispiel für die Ermittlung
	 * der Nächsten zu verarbeiten), muss man bei allen drei Funktionen die alten
	 * Positionsinformationen der Einheit mitliefern. Das ist besser für die
	 * Schnelligkeitsperformance, als wenn man es mehrfach ausliest.
	 * \author WaterKnight
	 * <a href="https://warcraft.ingame.de/forum/showthread.php?p=4102915&postcount=21#post4102915">source</a>
	 * \sa SetUnitYIfNotBlocked()
	 * \sa SetUnitXYIfNotBlocked()
	 */
	function SetUnitXIfNotBlocked takes unit whichUnit, real oldX, real oldY, real x returns boolean
		call SetUnitPosition(whichUnit, x, oldY)
		if ((RAbsBJ(GetUnitX(whichUnit) - x) > 1) or (RAbsBJ(GetUnitY(whichUnit) - oldY) > 1)) then
			call SetUnitX(whichUnit, oldX)
			call SetUnitY(whichUnit, oldY)
			return false
		endif
		return true
	endfunction

	/**
	 * \author WaterKnight
	 * <a href="https://warcraft.ingame.de/forum/showthread.php?p=4102915&postcount=21#post4102915">source</a>
	 * \sa SetUnitXIfNotBlocked()
	 * \sa SetUnitXYIfNotBlocked()
	 */
	function SetUnitYIfNotBlocked takes unit whichUnit, real oldX, real oldY, real y returns boolean
		call SetUnitPosition(whichUnit, oldX, y)
		if ((RAbsBJ(GetUnitX(whichUnit) - oldX) > 1) or (RAbsBJ(GetUnitY(whichUnit) - y) > 1)) then
			call SetUnitX(whichUnit, oldX)
			call SetUnitY(whichUnit, oldY)
			return false
		endif
		return true
	endfunction

	/**
	 * \author WaterKnight
	 * <a href="https://warcraft.ingame.de/forum/showthread.php?p=4102915&postcount=21#post4102915">source</a>
	 * \sa SetUnitXIfNotBlocked()
	 * \sa SetUnitYIfNotBlocked()
	 */
	function SetUnitXYIfNotBlocked takes unit whichUnit, real oldX, real oldY, real x, real y returns boolean
		if (SetUnitXIfNotBlocked(whichUnit, oldX, oldY, x)) then
			if (SetUnitYIfNotBlocked(whichUnit, x, oldY, y )) then
				return true
			endif
		else
			call SetUnitYIfNotBlocked(whichUnit, oldX, oldY, y)
		endif
		return false
	endfunction

	/**
	 * \author Grater
	 * <a href="http://www.wc3jass.com/viewtopic.php?t=100">source</a>
	 * \sa FindClosestUnitByLocation()
	 * \sa FindClosestUnitByRect()
	 */
	function FindClosestUnit takes group g, real x, real y returns unit
		local real dx
		local real dy
		local group tempGroup
		local real maxDist = 999999.0
		local real dist
		local unit u = null
		local unit closest = null
		if (bj_wantDestroyGroup == true) then
			set tempGroup = g
		else
			set tempGroup = CreateGroup()
			call GroupAddGroup(g, tempGroup)
		endif
		set bj_wantDestroyGroup = false

		loop
			set u = FirstOfGroupSave(tempGroup)
			call GroupRemoveUnit(tempGroup, u)
			exitwhen (u == null)
			set dx = GetUnitX(u) - x
			set dy = GetUnitY(u) - y
			set dist = SquareRoot(dx*dx+dy*dy)
			if (dist < maxDist) then
				set closest = u
				set maxDist = dist
			endif
			set u = null
		endloop
		call DestroyGroup(tempGroup)
		set tempGroup = null
		return closest
	endfunction

	/**
	 * \author Grater
	 * <a href="http://www.wc3jass.com/viewtopic.php?t=100">source</a>
	 * \sa FindClosestUnit()
	 * \sa FindClosestUnitByRect()
	 */
	function FindClosestUnitByLocation takes group g, location loc returns unit
		return FindClosestUnit(g, GetLocationX(loc), GetLocationY(loc))
	endfunction

	/**
	 * \author Tamino Dauth
	 * \sa FindClosestUnit()
	 * \sa FindClosestUnitByLocation()
	 */
	function FindClosestUnitByRect takes group whichGroup, rect usedRect returns unit
		return FindClosestUnit(whichGroup, GetRectCenterX(usedRect), GetRectCenterY(usedRect))
	endfunction

	/**
	 * IsUnitOnRect returns true if the unit's collision circle
	 * ------------ interesects with a rect.
	 *
	 * Useful for example, in a "enter rect" event
	 * it will return true, unlike blizz' \ref RectContainsUnit()
	 *
	 * probably slower than \ref RectContainsUnit()
	 * \author Vexorian
	 */
	function IsUnitOnRect takes unit u, rect r returns boolean
		local real x = GetUnitX(u)
		local real y = GetUnitY(u)
		local real mx = GetRectMaxX(r)
		local real nx = GetRectMinX(r)
		local real my = GetRectMaxY(r)
		local real ny = GetRectMinY(r)
		if (nx <= x) and (x <= mx) and (ny <= y) and (y <= my) then
			return true
		endif
		if(x>mx) then
			set x=mx
		elseif(x<nx) then
			set x=nx
		endif
		if(y>my) then
			set y=my
		elseif(y<ny) then
			set y=ny
		endif
		return IsUnitInRangeXY(u,x,y,0.0)
	endfunction

	/**
	 * \author Tamino Dauth
	 * \sa SetUnitFacingTimed()
	 */
	function SetUnitFacingToFaceRectTimed takes unit whichUnit, rect whichRect, real duration returns nothing
		call SetUnitFacingTimed(whichUnit, GetAngleBetweenPoints(GetUnitX(whichUnit), GetUnitY(whichUnit), GetRectCenterX(whichRect), GetRectCenterY(whichRect)), duration)
	endfunction

	/**
	 * \author Tamino Dauth
	 * \sa SetUnitFacingToFaceUnitTimed()
	 */
	function SetUnitFacingToFaceUnit takes unit whichUnit, unit target returns nothing
		call SetUnitFacing(whichUnit, GetAngleBetweenUnits(whichUnit, target))
	endfunction

	/**
	 * \author Tamino Dauth
	 * \sa SetUnitPositionLoc()
	 */
	function SetUnitPositionRect takes unit whichUnit, rect whichRect returns nothing
		call SetUnitPosition(whichUnit, GetRectCenterX(whichRect), GetRectCenterY(whichRect))
	endfunction

	/**
	 * \author Tamino Dauth
	 * \sa SetUnitPositionLocFacingBJ
	 */
	function SetUnitPositionRectFacing takes unit whichUnit, rect whichRect, real facing returns nothing
		call SetUnitPositionRect(whichUnit, whichRect)
		call SetUnitFacing(whichUnit, facing)
	endfunction

	/// \author Tamino Dauth
	function SetUnitToRandomPointOnRect takes unit whichUnit, rect whichRect returns nothing
		local real minX = RMinBJ(GetRectMinX(whichRect), GetRectMaxX(whichRect))
		local real maxX = RMaxBJ(GetRectMinX(whichRect), GetRectMaxX(whichRect))
		local real minY = RMinBJ(GetRectMinY(whichRect), GetRectMaxY(whichRect))
		local real maxY = RMaxBJ(GetRectMinY(whichRect), GetRectMaxY(whichRect))
		call SetUnitPosition(whichUnit, GetRandomReal(minX, maxX), GetRandomReal(minY, maxY))
	endfunction

	/**
	 * Issues unit \p whichUnit order \p order at center of rect \p whichRect.
	 * \return Returns true if order was issued successfully.
	 * \author Tamino Dauth
	 * \sa IssuePointOrder()
	 * \sa IssueRectOrderById()
	 */
	function IssueRectOrder takes unit whichUnit, string order, rect whichRect returns boolean
		return IssuePointOrder(whichUnit, order, GetRectCenterX(whichRect), GetRectCenterY(whichRect))
	endfunction

	/**
	 * \copydoc IssueRectOrder
	 * \author Tamino Dauth
	 * \sa IssuePointOrderById()
	 * \sa IssueRectOrder()
	 */
	function IssueRectOrderById takes unit whichUnit, integer order, rect whichRect returns boolean
		return IssuePointOrderById(whichUnit, order, GetRectCenterX(whichRect), GetRectCenterY(whichRect))
	endfunction

endlibrary