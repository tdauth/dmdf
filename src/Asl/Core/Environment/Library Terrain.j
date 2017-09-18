library ALibraryCoreEnvironmentTerrain initializer init requires AStructCoreGeneralVector, ALibraryCoreMathsRect

	/**
	 * Original description:
	 * The function \ref SetTerrainPathable() sets a single 32x32 space on the pathing grid. However, \ref SetTerrainType() sets a
	 * 128x128 space on the terrain grid, and does not change the pathing for that space. If you want to change the
	 * pathing, you'd have to change the pathing for 16 individual points per terrain space. This function rectifies
	 * the situation by allowing you to change the pathing for a single space on the terrain grid, instead of a single
	 * space on the pathing grid.
	 * \note Note: In my tests, the alignment was correct. However, there might be cases where this isn't true, so if there
	 * is a problem I will change the numbers as needed.
	 * \author Shvegait
	 * <a href="http://www.wc3jass.com/">source</a>
	 */
	function SetTerrainSpacePathable takes real x, real y, pathingtype pathingType, boolean flag returns nothing
		local real newX = x + 64.0
		local real newY = y + 64.0
		local integer i
		local integer j
		set newX = (newX - ModuloReal(newX, 128.0) - 64.0)
		set newY = (newY - ModuloReal(newY, 128.0) + 32.0)
		set i = 0
		loop
			exitwhen (i > 3)
			set j = 0
			loop
				exitwhen (j > 3)
				call SetTerrainPathable((newX + i * 32.0) , (newY - j * 32.0), pathingType, flag)
				set j = j + 1
			endloop
			set i = i + 1
		endloop
	endfunction

	/**
	By Anitarf from <a href="http://www.wc3c.net/showpost.php?p=1114433&postcount=52">Wc3C.net<a>
	I might as well just post our findings here, since they mostly pertain to this specific resource.

	The IsTerrainPathable() native, which is one of the two foundations of this resource, has some peculiar quirks. The first and most obvious of those is the fact that it's return value is the opposite of what you would expect it to be: The native returns true if the terrain is not pathable and false if it is. So, rather than answering the question "Is the terrain pathable here?", it answers the question "Is pathing blocked here?".

	The second important property of the native is that it ignores dynamic objects when doing the pathing check, it only considers the map's static pathing map, which is affected by cliffs, water and doodads. Destructables and buildings, being dynamic objects, do not affect this, so if a point of flat terrain is blocked by a tree, the pathing natives will still say that point is pathable for ground units and buildable.

	This brings us to the second foundation of this resource, the item pathing check. If you try moving an item to an unpathable point, it will be moved to the nearest pathable point instead. With this discrepancy, we can detect all unpathable points, even those caused by destructables and structures. Note however that items can be moved into deep water which is otherwise unpathable for ground units, so besides the item position check we still need an additional pathing check in the IsTerrainWalkable function.

	Getting back to the IsTerrainPathable(), or more precisely, the static pathing map it reads from. Normally, dynamic objects like destructables can only block passable areas on the static pathing map, but they can not unblock blocked areas. Using a trigger to create a bridge over a cliff in-game will not allow ground units to cross that cliff. How do the bridges work then? Simple:

	Any destructable with it's "Pathing - Is Walkable" property set to true that you pre-place in the editor will affect how the editor writes the map's static pathing map. Areas where such destructables are placed are made fully pathable (air, ground, naval) and buildable. It is then entirely up to the destructable to do the pathing blocking. Killing a bridge causes it to switch to it's dead pathing texture which is unpassable for ground units, however completely removing a bridge will leave the cliffs where it once stood perfectly pathable and buildable.

	The other thing that the "Pathing - Is Walkable" field does is it makes the destructable affect the terrain z, causing units to walk on it instead of through it as well as affecting the return value of GetLocationZ(). If you do this with animated destructables, this can cause a server split (since animations are not synced) unless you only use location z values for only graphical stuff like changing unit flying height and not gameplay stuff like calculating projectile bounce angles.
	*/

	//******************************************************************************
	//* BY: Rising_Dusk
	//*
	//* This script can be used to detect the type of pathing at a specific point.
	//* It is valuable to do it this way because the IsTerrainPathable is very
	//* counterintuitive and returns in odd ways and aren't always as you would
	//* expect. This library, however, facilitates detecting those things reliably
	//* and easily.
	//*
	//******************************************************************************
	//*
	//*    > function IsTerrainDeepWater    takes real x, real y returns boolean
	//*    > function IsTerrainShallowWater takes real x, real y returns boolean
	//*    > function IsTerrainLand         takes real x, real y returns boolean
	//*    > function IsTerrainPlatform     takes real x, real y returns boolean
	//*    > function IsTerrainWalkable     takes real x, real y returns boolean
	//*
	//* These functions return true if the given point is of the type specified
	//* in the function's name and false if it is not. For the IsTerrainWalkable
	//* function, the MAX_RANGE constant below is the maximum deviation range from
	//* the supplied coordinates that will still return true.
	//*
	//* The IsTerrainPlatform works for any preplaced walkable destructable. It will
	//* return true over bridges, destructable ramps, elevators, and invisible
	//* platforms. Walkable destructables created at runtime do not create the same
	//* pathing hole as preplaced ones do, so this will return false for them. All
	//* other functions except IsTerrainWalkable return false for platforms, because
	//* the platform itself erases their pathing when the map is saved.
	//*
	//* After calling IsTerrainWalkable(x, y), the following two global variables
	//* gain meaning. They return the X and Y coordinates of the nearest walkable
	//* point to the specified coordinates. These will only deviate from the
	//* IsTerrainWalkable function arguments if the function returned false.
	//*
	//* Variables that can be used from the library:
	//*     [real]    TerrainPathability_X
	//*     [real]    TerrainPathability_Y
	//*

	/**
	 * \author Rising_Dusk
	 * \sa IsTerrainShallowWater()
	 * \sa IsTerrainLand()
	 * \sa IsTerrainPlatform()
	 * \sa IsTerrainWalkable()
	 * \sa IsTerrainPathable()
	 */
	function IsTerrainDeepWater takes real x, real y returns boolean
		return not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
	endfunction

	/**
	 * \author Rising_Dusk
	 * \sa IsTerrainDeepWater()
	 * \sa IsTerrainLand()
	 * \sa IsTerrainPlatform()
	 * \sa IsTerrainWalkable()
	 * \sa IsTerrainPathable()
	 */
	function IsTerrainShallowWater takes real x, real y returns boolean
		return not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) and IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
	endfunction

	/**
	 * \author Rising_Dusk
	 * \sa IsTerrainDeepWater()
	 * \sa IsTerrainShallowWater()
	 * \sa IsTerrainPlatform()
	 * \sa IsTerrainWalkable()
	 * \sa IsTerrainPathable()
	 */
	function IsTerrainLand takes real x, real y returns boolean
		return IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
	endfunction

	/**
	 * The IsTerrainPlatform works for any preplaced walkable destructable. It will
	 * return true over bridges, destructable ramps, elevators, and invisible
	 * platforms. Walkable destructables created at runtime do not create the same
	 * pathing hole as preplaced ones do, so this will return false for them. All
	 * other functions except \ref IsTerrainWalkable() return false for platforms, because
	 * the platform itself erases their pathing when the map is saved.
	 * \author Rising_Dusk
	 * \sa IsTerrainDeepWater()
	 * \sa IsTerrainShallowWater()
	 * \sa IsTerrainLand()
	 * \sa IsTerrainWalkable()
	 * \sa IsTerrainPathable()
	 */
	function IsTerrainPlatform takes real x, real y returns boolean
		return not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) and not IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
	endfunction

	globals
		private AItemVector items
	endglobals

	private function HideItem takes nothing returns nothing
		if IsItemVisible(GetEnumItem()) then
			call items.pushBack(GetEnumItem())
			call SetItemVisible(items.back(), false)
		endif
	endfunction

	/**
	 * \param maxRange Maximum range deviation which the function will still return true for.
	 * \author Vexorian, Rising_Dusk, Tamino Dauth
	 */
	function IsTerrainWalkable takes real x, real y, real maxRange returns boolean
		local rect Find = RectFromPointSize(x, y, 128.0, 128.0)
		local item Item = CreateItem('wolg', x, y)
		local real X
		local real Y
		//Hide any items in the area to avoid conflicts with our item
		set items = AItemVector.create()
		call EnumItemsInRect(Find ,null, function HideItem)
		//Try to move the test item and get its coords
		set X = GetItemX(Item)
		set Y = GetItemY(Item)
		//Unhide any items hidden at the start
		loop
			exitwhen (items.empty())
			call SetItemVisible(items.back(), true)
			call items.popBack()
		endloop
		call RemoveRect(Find)
		set Find = null
		call RemoveItem(Item)
		set Item = null
		call items.destroy()
		set items = 0
		//Return walkability
		return (X-x)*(X-x)+(Y-y)*(Y-y) <= maxRange*maxRange and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
	endfunction

	private function init takes nothing returns nothing
		set items = 0
	endfunction

endlibrary