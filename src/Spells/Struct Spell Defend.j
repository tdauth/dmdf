/// Knight
library StructSpellsSpellDefend requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	// TODO disable when character drops buckler
	struct SpellDefend extends Spell
		public static constant integer abilityId = 'A1HK'
		public static constant integer favouriteAbilityId = 'A1HL'
		public static constant integer classSelectionAbilityId = 'A1HM'
		public static constant integer classSelectionGrimoireAbilityId = 'A1HR'
		public static constant integer maxLevel = 1
		
		private method condition takes nothing returns boolean
			if (this.character().inventory().equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) == 0 or not ItemTypes.itemTypeIdIsBuckler(this.character().inventory().equipmentItemData(AItemType.equipmentTypeSecondaryWeapon).itemTypeId())) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Ritter muss einen Schild tragen."))
				return false
			endif
			
			return true
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), thistype.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, 0)
			call this.addGrimoireEntry('A1HM', 'A1HR')
			
			return this
		endmethod
	endstruct

endlibrary