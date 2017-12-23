library ALibraryCoreMathsHandle requires ALibraryCoreMathsPoint, ALibraryCoreMathsRect

	//! textmacro ALibraryCoreMathsHandleHandleMacro takes TYPE, TYPENAME
		function Get$TYPENAME$Z takes $TYPE$ $TYPENAME$ returns real
			return GetTerrainZ(Get$TYPENAME$X($TYPENAME$), Get$TYPENAME$Y($TYPENAME$))
		endfunction
		
		function GetDistanceBetween$TYPENAME$sWithoutZ takes $TYPE$ $TYPENAME$0, $TYPE$ $TYPENAME$1 returns real
			return GetDistanceBetweenPointsWithoutZ(Get$TYPENAME$X($TYPENAME$0), Get$TYPENAME$Y($TYPENAME$0), Get$TYPENAME$X($TYPENAME$1), Get$TYPENAME$Y($TYPENAME$1))
		endfunction

		/// Returns the distance between two $TYPENAME$s.
		/// Da es die Natives "Get$TYPENAME$X" und "Get$TYPENAME$Y" gibt, dürfte es schneller sein als erst Locations der $TYPENAME$s zu erzeugen und diese zu vergleichen.
		/// Achtung: Beim Ignorieren des Z-Wertes "z0" und "z1" den Wert 0 geben.
		function GetDistanceBetween$TYPENAME$s takes $TYPE$ $TYPENAME$0, $TYPE$ $TYPENAME$1, real z0, real z1 returns real
			return GetDistanceBetweenPoints(Get$TYPENAME$X($TYPENAME$0), Get$TYPENAME$Y($TYPENAME$0), z0, Get$TYPENAME$X($TYPENAME$1), Get$TYPENAME$Y($TYPENAME$1), z1)
		endfunction

		/// Returns the centre location between two $TYPENAME$s.
		/// Achtung: Z muss ignoriert werden, da sich kein Punkt mit einem Z-Wert erstellen lässt.
		function GetCentreBetween$TYPENAME$s takes $TYPE$ $TYPENAME$0, $TYPE$ $TYPENAME$1 returns location
			return GetCentreBetweenPoints(Get$TYPENAME$X($TYPENAME$0), Get$TYPENAME$Y($TYPENAME$0), Get$TYPENAME$X($TYPENAME$1), Get$TYPENAME$Y($TYPENAME$1))
		endfunction

		function Get$TYPENAME$PolarProjectionX takes $TYPE$ $TYPENAME$, real angle, real distance returns real
			return GetPolarProjectionX(Get$TYPENAME$X($TYPENAME$), angle, distance)
		endfunction

		function Get$TYPENAME$PolarProjectionY takes $TYPE$ $TYPENAME$, real angle, real distance returns real
			return GetPolarProjectionY(Get$TYPENAME$Y($TYPENAME$), angle, distance)
		endfunction

		/// Returns the angle between two $TYPENAME$s.
		/// Da es die Natives "Get$TYPENAME$X" und "Get$TYPENAME$Y" gibt, dürfte es schneller sein als erst Locations der $TYPENAME$s zu erzeugen und diese zu vergleichen.
		function GetAngleBetween$TYPENAME$s takes $TYPE$ $TYPENAME$0, $TYPE$ $TYPENAME$1 returns real
			return GetAngleBetweenPoints(Get$TYPENAME$X($TYPENAME$0), Get$TYPENAME$Y($TYPENAME$0), Get$TYPENAME$X($TYPENAME$1), Get$TYPENAME$Y($TYPENAME$1))
		endfunction

		function RectFrom$TYPENAME$Size takes $TYPE$ $TYPENAME$, real width, real height returns rect
			return RectFromPointSize(Get$TYPENAME$X($TYPENAME$), Get$TYPENAME$Y($TYPENAME$), width, height)
		endfunction
	//! endtextmacro

	//! runtextmacro ALibraryCoreMathsHandleHandleMacro("widget", "Widget")
	//! runtextmacro ALibraryCoreMathsHandleHandleMacro("unit", "Unit")
	//! runtextmacro ALibraryCoreMathsHandleHandleMacro("destructable", "Destructable")
	//! runtextmacro ALibraryCoreMathsHandleHandleMacro("item", "Item")

endlibrary