library ALibraryCoreMathsLocation requires ALibraryCoreMathsPoint

	/**
	* Unlike \ref DistanceBetweenPoints this version considers z-values.
	* \return Returns distance between location \p location0 and \p location1.
	* \sa DistanceBetweenPoints, GetDistanceBetweenPoints
	*/
	function GetDistanceBetweenLocations takes location location0, location location1 returns real
		return GetDistanceBetweenPoints(GetLocationX(location0), GetLocationY(location0), GetLocationZ(location0), GetLocationX(location1), GetLocationY(location1), GetLocationZ(location1))
	endfunction

	/**
	* Z-value has to be ignored since we cannot create any location with user-defined z-value (all locations do have terrain z-value).
	* \return Returns centre location between location \p location0 and \p location1.
	*/
	function GetCentreBetweenLocations takes location location0, location location1 returns location
		return GetCentreBetweenPoints(GetLocationX(location0), GetLocationY(location0), GetLocationX(location1), GetLocationY(location1))
	endfunction

	/// \return Returns angle between location \p location0 and \p location1 from centre location \p centre.
	function GetAngleBetweenLocationsFromCentre takes location centre, location location0, location location1 returns real
		return GetAngleBetweenPointsFromCentre(GetLocationX(centre), GetLocationY(centre), GetLocationX(location0), GetLocationY(location0), GetLocationX(location1), GetLocationY(location1))
	endfunction

endlibrary