library ALibraryCoreMathsRect

	/**
	* Similar to \ref GetRectCenterX.
	* Allows easier implementation of generic text macros for rect data type.
	* \author Tamino Dauth
	* \sa GetRectCenterX, GetRectY, GetRectCenterY, GetRectCenter
	*/
	function GetRectX takes rect whichRect returns real
		return GetRectCenterX(whichRect)
	endfunction

	/**
	* Similar to \ref GetRectCenterY.
	* Allows easier implementation of generic text macros for rect data type.
	* \author Tamino Dauth
	* \sa GetRectCenterY, GetRectY, GetRectCenterY, GetRectCenter
	*/
	function GetRectY takes rect whichRect returns real
		return GetRectCenterY(whichRect)
	endfunction

	/**
	* \return Returns the rect where rect \p rect0 and \p rect1 cross each other. If both rects do not cross anywhere function will return null.
	*/
	function GetRectsBorderRect takes rect rect0, rect rect1 returns rect
		local real x0 = RMaxBJ(GetRectMinX(rect0), GetRectMinX(rect1))
		local real x1 = RMinBJ(GetRectMaxX(rect0), GetRectMaxX(rect1))
		local real y0 = RMaxBJ(GetRectMinY(rect0), GetRectMinY(rect1))
		local real y1 = RMinBJ(GetRectMaxY(rect0), GetRectMaxY(rect1))
		if ((x0 > x1) or (y0 > y1)) then
			return null
		endif
		return Rect(x0, y0, x1, y1)
	endfunction

	/**
	* \return Returns a rect at point with coordinates \p x and \p y and with width \p width and height \p height.
	* \sa RectFromCenterSizeBJ
	*/
	function RectFromPointSize takes real x, real y, real width, real height returns rect
		return Rect((x - width * 0.5), (y - height * 0.5), (x + width * 0.5), (y + height * 0.5))
	endfunction

	function SetRectByCoordinates takes rect whichRect, real x1, real y1, real x2, real y2, real x3, real y3, real x4, real y4 returns nothing
		local real minX = 0.0
		local real maxX = 0.0
		local real minY = 0.0
		local real maxY = 0.0

		if (x1 >= x2 and x1 >= x3 and x1 >= x4) then
			set maxX = x1
		elseif (x2 >= x1 and x2 >= x3 and x2 >= x4) then
			set maxX = x2
		elseif (x3 >= x1 and x3 >= x2 and x3 >= x4) then
			set maxX = x3
		else
			set maxX = x4
		endif

		if (x1 <= x2 and x1 <= x3 and x1 <= x4) then
			set minX = x1
		elseif (x2 <= x1 and x2 <= x3 and x2 <= x4) then
			set minX = x2
		elseif (x3 <= x1 and x3 <= x2 and x3 <= x4) then
			set minX = x3
		else
			set minX = x4
		endif

		if (y1 >= y2 and y1 >= y3 and y1 >= y4) then
			set maxY = y1
		elseif (y2 >= y1 and y2 >= y3 and y2 >= y4) then
			set maxY = y2
		elseif (y3 >= y1 and y3 >= y2 and y3 >= y4) then
			set maxY = y3
		else
			set maxY = y4
		endif

		if (y1 <= y2 and y1 <= y3 and y1 <= y4) then
			set minY = y1
		elseif (y2 <= y1 and y2 <= y3 and y2 <= y4) then
			set minY = y2
		elseif (y3 <= y1 and y3 <= y2 and y3 <= y4) then
			set minY = y3
		else
			set minY = y4
		endif

		call SetRect(whichRect, minX, minY, maxX, maxY)
	endfunction

	function GetGroupInRectByCoordinates takes real x1, real y1, real x2, real y2, real x3, real y3, real x4, real y4 returns group
		local rect usedRect = Rect(0.0, 0.0, 0.0, 0.0)
		local group usedGroup = CreateGroup()
		local unit  firstUnit = null
		local real firstUnitX = 0.0
		local real firstUnitY = 0.0
		call SetRectByCoordinates(usedRect, x1, y1, x2, y2, x3, y3, x4, y4)
		call GroupEnumUnitsInRect(usedGroup, usedRect, null)
		loop
			set firstUnit = FirstOfGroup(usedGroup)
			exitwhen (firstUnit == null)

			set firstUnitX = GetUnitX(firstUnit)
			set firstUnitY = GetUnitY(firstUnit)

			if ((firstUnitY - y1) * (x2 - x1) - (firstUnitX - x1) * (y2 - y1) > 0.0) then
				call GroupRemoveUnit(usedGroup, firstUnit)
			elseif ((firstUnitY - y2) * (x3 - x2) - (firstUnitX - x2) * (y3 - y2) > 0.0) then
				call GroupRemoveUnit(usedGroup, firstUnit)
			elseif ((firstUnitY - y3) * (x4 - x3) - (firstUnitX - x3) * (y4 - y3) > 0.0) then
				call GroupRemoveUnit(usedGroup, firstUnit)
			elseif ((firstUnitY - y4) * (x1 - x4) - (firstUnitX - x4) * (y1 - y4) > 0.0) then
				call GroupRemoveUnit(usedGroup, firstUnit)
			endif
			set firstUnit = null
		endloop
		call RemoveRect(usedRect)
		set usedRect = null
		return usedGroup
	endfunction

endlibrary