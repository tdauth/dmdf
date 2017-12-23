library AInterfaceCoreInterfaceBarInterface

	/**
	* Abstract interface for bar structs such as AMultiboardBar.
	*/
	interface ABarInterface
		// dynamic member methods
		public method setValue takes real value returns nothing
		public method value takes nothing returns real
		public method setMaxValue takes real maxValue returns nothing
		public method maxValue takes nothing returns real
		public method setValueIcon takes integer length, string valueIcon returns nothing
		public method valueIcon takes integer length returns string
		public method setEmptyIcon takes integer length, string emptyIcon returns nothing
		public method emptyIcon takes integer length returns string
		// construction member methods
		public method length takes nothing returns integer
		public method refreshRate takes nothing returns real
		public method horizontal takes nothing returns boolean
		// methods
		public method enable takes nothing returns nothing
		public method disable takes nothing returns nothing
		public method onRefresh takes nothing returns nothing
		public method refresh takes nothing returns nothing
		// convenience methods
		public method setIcons takes integer start, integer end, string icon, boolean valueIcon returns nothing
		public method setAllIcons takes string icon, boolean valueIcon returns nothing
	endinterface

endlibrary