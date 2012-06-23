library StructMapMapLayers requires Asl

	struct Layers
		private static ALayer m_talrasBridge0

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			local region whichRegion
			set thistype.m_talrasBridge0 = ALayer.create()
			set whichRegion = CreateRegion()
			call RegionAddRect(whichRegion, gg_rct_layer_talras_bridge_0_entry_0)
			call thistype.m_talrasBridge0.addEntryRegion(whichRegion)
			set whichRegion = CreateRegion()
			call RegionAddRect(whichRegion, gg_rct_layer_talras_bridge_0_entry_1)
			call thistype.m_talrasBridge0.addEntryRegion(whichRegion)
			set whichRegion = CreateRegion()
			call RegionAddRect(whichRegion, gg_rct_layer_talras_bridge_0_exit_0)
			call thistype.m_talrasBridge0.addExitRegion(whichRegion)
			set whichRegion = CreateRegion()
			call RegionAddRect(whichRegion, gg_rct_layer_talras_bridge_0_exit_1)
			call thistype.m_talrasBridge0.addExitRegion(whichRegion)
			set whichRegion = CreateRegion()
			call RegionAddRect(whichRegion, gg_rct_layer_talras_bridge_0)
			call thistype.m_talrasBridge0.addRegion(whichRegion, 1000.0)
		endmethod

		public static method talrasBridge0 takes nothing returns ALayer
			return thistype.m_talrasBridge0
		endmethod
	endstruct

endlibrary