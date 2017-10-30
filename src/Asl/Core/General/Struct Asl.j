library AStructCoreGeneralAsl requires optional ALibraryCoreDebugMisc, ALibraryCoreStringConversion

	struct Asl
		public static constant string version = "1.3"
		public static constant string maintainer = "Tamino Dauth"

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
static if (DEBUG_MODE) then
			call thistype.showInformation.evaluate()
endif
		endmethod

		// static constant members

		public static constant method useDebugHandles takes nothing returns boolean
			return A_DEBUG_HANDLES
		endmethod

		// static methods

static if (DEBUG_MODE) then
		public static method showInformation takes nothing returns nothing
			call Print("Advanced Script Library")
			call Print(StringArg(tr("Version: %s"), thistype.version))
			call Print(StringArg(tr("Maintainer: %s"), thistype.maintainer))
			if (thistype.useDebugHandles()) then
				call Print(tr("* uses debug handles"))
			endif
		endmethod
endif
	endstruct

endlibrary