library StructSpellsSpellBookOfMagic requires StructSpellsSpellBookCraftingSpell

	/**
	 * Allows the creation of scrolls with the corresponding resources.
	 */
	struct SpellBookOfMagicScrollOfHex extends SpellBookCraftingSpell
		public static constant integer abilityId = 'A18M'

		private method condition takes nothing returns boolean
			if (this.character().inventory().hasItemType('I05H') and this.character().inventory().hasItemType('I007')) then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05H')
			call this.character().inventory().removeItemType('I007')
			call Character(this.character()).displayItemAcquired(GetObjectName('I03E'), tre("Hergestellt.", "Crafted."))
			call Character(this.character()).giveItem('I03E')
			call Character(this.character()).craftItem('I03E')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

	/**
	 * Allows the creation of scrolls with the corresponding resources.
	 */
	struct SpellBookOfMagicScrollOfNecromancy extends SpellBookCraftingSpell
		public static constant integer abilityId = 'A18N'

		private method condition takes nothing returns boolean
			if (this.character().inventory().totalItemTypeCharges('I05I') >= 2) then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05I')
			call this.character().inventory().removeItemType('I05I')
			call Character(this.character()).displayItemAcquired(GetObjectName('I02I'), tre("Hergestellt.", "Crafted."))
			call Character(this.character()).giveItem('I02I')
			call Character(this.character()).craftItem('I02I')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

	struct SpellBookOfMagicScrollOfHealing extends SpellBookCraftingSpell
		public static constant integer abilityId = 'A18O'

		private method condition takes nothing returns boolean
			if (this.character().inventory().hasItemType('I00B')) then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I00B')
			call Character(this.character()).displayItemAcquired(GetObjectName('I00F'), tre("Hergestellt.", "Crafted."))
			call Character(this.character()).giveItem('I00F')
			call Character(this.character()).craftItem('I00F')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

	struct SpellBookOfMagicScrollOfMana extends SpellBookCraftingSpell
		public static constant integer abilityId = 'A18P'

		private method condition takes nothing returns boolean
			if (this.character().inventory().hasItemType('I00C')) then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I00C')
			call Character(this.character()).displayItemAcquired(GetObjectName('I00G'), tre("Hergestellt.", "Crafted."))
			call Character(this.character()).giveItem('I00G')
			call Character(this.character()).craftItem('I00G')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

	struct SpellBookOfMagicScrollOfAncestors extends SpellBookCraftingSpell
		public static constant integer abilityId = 'A19Y'

		private method condition takes nothing returns boolean
			if (this.character().inventory().totalItemTypeCharges('I05I') >= 3) then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05I')
			call this.character().inventory().removeItemType('I05I')
			call this.character().inventory().removeItemType('I05I')
			call Character(this.character()).displayItemAcquired(GetObjectName('I05T'), tre("Hergestellt.", "Crafted."))
			call Character(this.character()).giveItem('I05T')
			call Character(this.character()).craftItem('I05T')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

	struct SpellBookOfMagicScrollOfCollector extends SpellBookCraftingSpell
		public static constant integer abilityId = 'A1AC'

		private method condition takes nothing returns boolean
			if (this.character().inventory().hasItemType('I03Y') and this.character().inventory().hasItemType('I05K')) then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I03Y')
			call this.character().inventory().removeItemType('I05K')
			call Character(this.character()).displayItemAcquired(GetObjectName('I04N'), tre("Hergestellt.", "Crafted."))
			call Character(this.character()).giveItem('I04N')
			call Character(this.character()).craftItem('I04N')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

	struct SpellBookOfMagicScrollOfWay extends SpellBookCraftingSpell
		public static constant integer abilityId = 'A1A7'

		private method condition takes nothing returns boolean
			if (this.character().inventory().hasItemType('I047')) then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I047')

			call Character(this.character()).displayItemAcquired(GetObjectName('I037'), tre("Hergestellt.", "Crafted."))
			call Character(this.character()).giveItem('I037')
			call Character(this.character()).craftItem('I037')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

endlibrary