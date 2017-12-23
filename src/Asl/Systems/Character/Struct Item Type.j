library AStructSystemsCharacterItemType requires AStructSystemsInventoryItemType, AStructSystemsCharacterClass, AStructSystemsCharacterCharacter

	/**
	 * \brief Item type struct which allows adding the requirement of a character class.
	 */
	struct ACharacterItemType extends AItemType
		// static construction members
		private static string textClass
		// construction members
		private AClass m_requiredClass

		// construction members

		public method requiredClass takes nothing returns AClass
			return this.m_requiredClass
		endmethod

		// methods

		/**
		 * This method can be overwritten to check requirements manually.
		 * It is used by \ref AUnitInventory for instance.
		 */
		public stub method checkRequirement takes unit whichUnit returns boolean
			local boolean result = super.checkRequirement(whichUnit)
			local ACharacter character = 0
			if (not result) then
				return false
			elseif (this.m_requiredClass != 0) then
				set character = ACharacter.getCharacterByUnit(whichUnit)
				if (character != 0 and character.class() != this.m_requiredClass) then
					call character.displayMessage(ACharacter.messageTypeError, thistype.textClass)
					return false
				endif
			endif
			return true
		endmethod

		/**
		 * Each custom item type is associated with an item type id when it is created.
		 * Each item type id should only have one custom item type!
		 * \param equipmentType If this value is -1 (\ref AItemType.equipmentTypeNone) it will always be added to backpack.
		 * \param requiredClass If this value is 0 no specific class is required.
		 */
		public static method create takes integer itemType, integer equipmentType, integer requiredLevel, integer requiredStrength, integer requiredAgility, integer requiredIntelligence, AClass requiredClass returns thistype
			local thistype this = thistype.allocate(itemType, equipmentType, requiredLevel, requiredStrength, requiredAgility, requiredIntelligence)
			// construction members
			set this.m_requiredClass = requiredClass
			return this
		endmethod

		public static method initCharacterItemType takes string textClass returns nothing
			// static construction members
			set thistype.textClass = textClass
		endmethod
	endstruct

endlibrary