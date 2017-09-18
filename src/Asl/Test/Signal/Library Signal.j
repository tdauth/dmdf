library ALibraryTestSignalSignal requires ALibraryCoreDebugMisc, AStructCoreGeneralSignal

	//! runtextmacro A_SIGNAL("private", "MouseMovementSignal", "real x, real y", "x, y")

	private struct Window
		private MouseMovementSignal m_signal

		//! runtextmacro A_STRUCT_DEBUG("\"Window\"")

		public method signal takes nothing returns MouseMovementSignal
			return this.m_signal
		endmethod

		public method moveMouse takes real x, real y returns nothing
			call this.m_signal.emit(x, y)
		endmethod

		private static method privateSlot0 takes real x, real y returns nothing
			debug call thistype.staticPrint("Private slot 0 with x " + R2S(x) + " and y " + R2S(y) + ".")
		endmethod

		private static method privateSlot1 takes real x, real y returns nothing
			debug call thistype.staticPrint("Private slot 1 with x " + R2S(x) + " and y " + R2S(y) + ".")
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			set this.m_signal = MouseMovementSignal.create()
			call this.m_signal.connect(thistype.privateSlot0)
			call this.m_signal.connect(thistype.privateSlot1)
			return this
		endmethod
	endstruct

	private function publicSlot takes real x, real y returns nothing
		debug call Print("Public slot with x " + R2S(x) + " and y " + R2S(y) + ".")
	endfunction

	function ASignalDebug takes nothing returns nothing
		local Window window = Window.create()
		call window.signal().connect(publicSlot)
		debug call Print("Created window. Moving mouse to (10.0 | 15.0).")
		call window.moveMouse(10.0, 15.0)
		debug call Print("Finished movement.")
		call window.destroy()
	endfunction

endlibrary