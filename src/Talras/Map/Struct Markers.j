library StructMapMapMarkers requires Asl, StructGameMarker

	struct Markers
		private static Marker m_talras0

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_talras0 = Marker.create("Doodads\\LordaeronSummer\\Props\\SignPost\\SignPost.mdl", GetRectCenterX(gg_rct_marker_talras_0), GetRectCenterY(gg_rct_marker_talras_0), 227.29, tr("Nach Talras"))
		endmethod

		public static method talras0 takes nothing returns Marker
			return thistype.m_talras0
		endmethod
	endstruct

endlibrary