library StructMapSpellsSpellBookOfSmithCraft requires Asl, StructGameCharacter

	struct SpellBookOfSmithCraftIron extends ASpell
		public static constant integer abilityId = 'A1BD'

		private method condition takes nothing returns boolean
			if (this.character().inventory().hasItemType('I05Y')) then
				debug call Print("Success")
				return true
			endif
			
			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tr("Benötigte Rohstoffe fehlen."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05Y')
			call Character(this.character()).displayItemAcquired(GetObjectName('I05Z'), tr("Hergestellt."))
			call Character(this.character()).giveItem('I05Z')
			call Character(this.character()).craftItem('I05Z')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct
	
	struct SpellBookOfSmithCraftShortSword extends ASpell
		public static constant integer abilityId = 'A1BC'

		private method condition takes nothing returns boolean
			if (this.character().inventory().totalItemTypeCharges('I05Z') >= 2) then
				debug call Print("Success")
				return true
			endif
			
			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tr("Benötigte Rohstoffe fehlen."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05Z')
			call this.character().inventory().removeItemType('I05Z')
			call Character(this.character()).displayItemAcquired(GetObjectName('I01Y'), tr("Hergestellt."))
			call Character(this.character()).giveItem('I01Y')
			call Character(this.character()).craftItem('I01Y')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct
	
	struct SpellBookOfSmithCraftLongSword extends ASpell
		public static constant integer abilityId = 'A1C2'

		private method condition takes nothing returns boolean
			if (this.character().inventory().totalItemTypeCharges('I05Z') >= 4) then
				debug call Print("Success")
				return true
			endif
			
			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tr("Benötigte Rohstoffe fehlen."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05Z')
			call this.character().inventory().removeItemType('I05Z')
			call this.character().inventory().removeItemType('I05Z')
			call this.character().inventory().removeItemType('I05Z')
			call Character(this.character()).displayItemAcquired(GetObjectName('I012'), tr("Hergestellt."))
			call Character(this.character()).giveItem('I012')
			call Character(this.character()).craftItem('I012')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

endlibrary