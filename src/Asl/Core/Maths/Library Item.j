library ALibraryCoreMathsItem requires ALibraryCoreMathsHandle

	/// Doesn't create locations.
	function SetItemPolarProjectionPosition takes item usedItem, real angle, real distance returns nothing
		local real x = GetItemPolarProjectionX(usedItem, angle, distance)
		local real y = GetItemPolarProjectionY(usedItem, angle, distance)
		call SetItemPosition(usedItem, x, y)
	endfunction

endlibrary