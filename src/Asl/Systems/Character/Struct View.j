/// Do not use this library, it is unfinished!
library AStructSystemsCharacterView requires AStructCoreGeneralHashTable, AStructCoreInterfaceThirdPersonCamera, ALibraryCoreMathsUnit, AStructSystemsCharacterAbstractCharacterSystem, AStructSystemsCharacterCharacter

	/**
	 * \brief Uses \ref AThirdPersonCamera to allow a third person view for the character.
	 */
	struct AView extends AAbstractCharacterSystem

		public method enable takes nothing returns nothing
			call super.enable()
			if (AThirdPersonCamera.playerThirdPersonCamera(this.character().player()).unit() != this.character().unit()) then
				call AThirdPersonCamera.playerThirdPersonCamera(this.character().player()).enable(this.character().unit(), 0.0)
			else
				call AThirdPersonCamera.playerThirdPersonCamera(this.character().player()).resume()
			endif
		endmethod

		public method disable takes nothing returns nothing
			call super.disable()
			call AThirdPersonCamera.playerThirdPersonCamera(this.character().player()).pause()
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character)
			// don't enable since it might be during the map initialization
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call AThirdPersonCamera.playerThirdPersonCamera(this.character().player()).disable()
		endmethod
	endstruct

endlibrary