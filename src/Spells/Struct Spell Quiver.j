/// Item
library StructSpellsSpellQuiver requires Asl

	struct SpellQuiver extends AUnitSpell
		public static constant integer abilityId = 'A160'

		private method condition takes nothing returns boolean
			local ACharacter character = ACharacter.getCharacterByUnit(GetTriggerUnit())
			local integer itemTypeId
			if (character != 0) then
				// TODO all bows
				if (character.inventory() != 0 and character.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0) then
					set itemTypeId = character.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId()
					return itemTypeId == 'I020' or itemTypeId == 'I021' or itemTypeId == 'I013'
				endif
				
				call character.displayMessage(ACharacter.messageTypeError, tr("Trägt keinen Bogen."))
			endif
			
			return false
		endmethod

		public static method create takes nothing returns thistype
			return thistype.allocate(thistype.abilityId, 0, thistype.condition, 0, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod	
	endstruct

endlibrary