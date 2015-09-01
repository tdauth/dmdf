library StructMapSpellsSpellBookOfPotions requires Asl, StructGameCharacter

	/**
	 * Allows the creation of potions with the corresponding resources.
	 */
	struct SpellBookOfPotionsHealPotion extends ASpell
		public static constant integer abilityId = 'A18R'

		private method condition takes nothing returns boolean
			if (this.character().inventory().hasItemType('I05K')) then
				debug call Print("Success")
				return true
			endif
			
			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tr("Benötigte Rohstoffe fehlen."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05K')
			call Character(this.character()).displayItemAcquired(GetObjectName('I00A'), tr("Hergestellt."))
			call Character(this.character()).giveItem('I00A')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

endlibrary