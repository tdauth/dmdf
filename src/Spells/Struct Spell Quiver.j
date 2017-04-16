/// Item
library StructSpellsSpellQuiver requires Asl, StructGameItemTypes

	struct SpellQuiver extends AUnitSpell
		public static constant integer abilityId = 'A160'

		private method condition takes nothing returns boolean
			local ACharacter character = ACharacter.getCharacterByUnit(GetTriggerUnit())
			local boolean result = true
			local integer itemTypeId
			if (character != 0) then
				if (character.inventory() != 0 and character.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0) then
					set itemTypeId = character.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId()
					set result = ItemTypes.itemTypeIdIsBow(itemTypeId)
				else
					set result = false
				endif

				if (not result) then
					call character.displayMessage(ACharacter.messageTypeError, tre("Trägt keinen Bogen.", "Does not carry a bow."))
				endif
			debug else
				debug call Print("Quiver: Is no character")
			endif

			return result
		endmethod

		public static method create takes nothing returns thistype
			return thistype.allocate(thistype.abilityId, 0, thistype.condition, 0, EVENT_PLAYER_UNIT_SPELL_CHANNEL, false, true, false)
		endmethod
	endstruct

endlibrary