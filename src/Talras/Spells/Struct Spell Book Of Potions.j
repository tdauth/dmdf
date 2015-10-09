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
			call Character(this.character()).craftItem('I00A')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct
	
	struct SpellBookOfPotionsManaPotion extends ASpell
		public static constant integer abilityId = 'A18S'

		private method condition takes nothing returns boolean
			if (this.character().inventory().hasItemType('I05L')) then
				debug call Print("Success")
				return true
			endif
			
			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tr("Benötigte Rohstoffe fehlen."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05L')
			call Character(this.character()).displayItemAcquired(GetObjectName('I00D'), tr("Hergestellt."))
			call Character(this.character()).giveItem('I00D')
			call Character(this.character()).craftItem('I00D')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct
	
	struct SpellBookOfPotionsPoison extends ASpell
		public static constant integer abilityId = 'A18V'

		private method condition takes nothing returns boolean
			if (this.character().inventory().totalItemTypeCharges('I041') >= 2) then
				debug call Print("Success")
				return true
			endif
			
			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tr("Benötigte Rohstoffe fehlen."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I041')
			call this.character().inventory().removeItemType('I041')
			call Character(this.character()).displayItemAcquired(GetObjectName('I05M'), tr("Hergestellt."))
			call Character(this.character()).giveItem('I05M')
			call Character(this.character()).craftItem('I05M')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct
	
	struct SpellBookOfPotionsBigHealPotion extends ASpell
		public static constant integer abilityId = 'A1CX'

		private method condition takes nothing returns boolean
			if (this.character().inventory().totalItemTypeCharges('I05K') >= 2) then
				debug call Print("Success")
				return true
			endif
			
			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tr("Benötigte Rohstoffe fehlen."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05K')
			call this.character().inventory().removeItemType('I05K')
			call Character(this.character()).displayItemAcquired(GetObjectName('I00B'), tr("Hergestellt."))
			call Character(this.character()).giveItem('I00B')
			call Character(this.character()).craftItem('I00B')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct
	
	struct SpellBookOfPotionsBigManaPotion extends ASpell
		public static constant integer abilityId = 'A1CY'

		private method condition takes nothing returns boolean
			if (this.character().inventory().totalItemTypeCharges('I05L') >= 2) then
				debug call Print("Success")
				return true
			endif
			
			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tr("Benötigte Rohstoffe fehlen."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05L')
			call this.character().inventory().removeItemType('I05L')
			call Character(this.character()).displayItemAcquired(GetObjectName('I00C'), tr("Hergestellt."))
			call Character(this.character()).giveItem('I00C')
			call Character(this.character()).craftItem('I00C')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

endlibrary