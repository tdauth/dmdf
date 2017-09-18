library AStructSystemsCharacterInventory requires AStructSystemsInventoryUnitInventory, AStructSystemsCharacterAbstractCharacterSystem, AStructSystemsCharacterCharacter

	/**
	 * \brief This structure provides an interface to the character's inventory which is based on the default Warcraft III: The Frozen Throne inventory with 6 slots.
	 * Uses the adapter pattern to adapt the struct \ref AUnitInventory to \ref AAbstractCharacterSystem.
	 */
	struct ACharacterInventory extends AAbstractCharacterSystem
		private AUnitInventory m_unitInventory

		public method unitInventory takes nothing returns AUnitInventory
			return this.m_unitInventory
		endmethod

		public stub method enable takes nothing returns nothing
			call super.enable()
			call this.m_unitInventory.enable()
		endmethod

		public stub method disable takes nothing returns nothing
			call super.disable()
			call this.m_unitInventory.disable()
		endmethod

		public stub method store takes gamecache cache, string missionKey, string labelPrefix returns nothing
			call super.store(cache, missionKey, labelPrefix)
			call this.m_unitInventory.store(cache, missionKey, labelPrefix)
		endmethod

		public stub method restore takes gamecache cache, string missionKey, string labelPrefix returns nothing
			call super.restore(cache, missionKey, labelPrefix)
			call this.m_unitInventory.restore(cache, missionKey, labelPrefix)
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character)

			set this.m_unitInventory = AUnitInventory.create(character.unit())

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_unitInventory.destroy()
		endmethod
	endstruct

endlibrary