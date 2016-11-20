library StructSpellsSpellBookOfSmithCraft requires Asl, StructGameCharacter

	struct SpellBookOfSmithCraftIron extends ASpell
		public static constant integer abilityId = 'A1BD'

		private method condition takes nothing returns boolean
			if (this.character().inventory().hasItemType('I05Y')) then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05Y')
			call Character(this.character()).displayItemAcquired(GetObjectName('I05Z'), tre("Hergestellt.", "Crafted."))
			call Character(this.character()).giveItem('I05Z')
			call Character(this.character()).craftItem('I05Z')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

	struct SpellBookOfSmithCraftAxe extends ASpell
		public static constant integer abilityId = 'A1R2'
		public static constant integer itemTypeId = 'I00Q'

		private method condition takes nothing returns boolean
			if (this.character().inventory().totalItemTypeCharges('I05Z') >= 1 and this.character().inventory().totalItemTypeCharges('I02P') >= 1) then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05Z')
			call this.character().inventory().removeItemType('I02P')
			call Character(this.character()).displayItemAcquired(GetObjectName(thistype.itemTypeId), tre("Hergestellt.", "Crafted."))
			call Character(this.character()).giveItem(thistype.itemTypeId)
			call Character(this.character()).craftItem(thistype.itemTypeId)
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
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
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05Z')
			call this.character().inventory().removeItemType('I05Z')
			call Character(this.character()).displayItemAcquired(GetObjectName('I01Y'), tre("Hergestellt.", "Crafted."))
			call Character(this.character()).giveItem('I01Y')
			call Character(this.character()).craftItem('I01Y')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
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
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05Z')
			call this.character().inventory().removeItemType('I05Z')
			call this.character().inventory().removeItemType('I05Z')
			call this.character().inventory().removeItemType('I05Z')
			call Character(this.character()).displayItemAcquired(GetObjectName('I012'), tre("Hergestellt.", "Crafted."))
			call Character(this.character()).giveItem('I012')
			call Character(this.character()).craftItem('I012')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

	struct SpellBookOfSmithIronHelmet extends ASpell
		public static constant integer abilityId = 'A1R3'
		public static constant integer itemTypeId = 'I02E'

		private method condition takes nothing returns boolean
			if (this.character().inventory().totalItemTypeCharges('I05Z') >= 3) then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05Z')
			call this.character().inventory().removeItemType('I05Z')
			call this.character().inventory().removeItemType('I05Z')
			call Character(this.character()).displayItemAcquired(GetObjectName(thistype.itemTypeId), tre("Hergestellt.", "Crafted."))
			call Character(this.character()).giveItem(thistype.itemTypeId)
			call Character(this.character()).craftItem(thistype.itemTypeId)
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

	struct SpellBookOfSmithCraftEinarsSword extends ASpell
		public static constant integer abilityId = 'A1R1'

		private method condition takes nothing returns boolean
			if (this.character().inventory().totalItemTypeCharges('I05Z') >= 2) then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call this.character().inventory().removeItemType('I05Z')
			call this.character().inventory().removeItemType('I05Z')
			call Character(this.character()).displayItemAcquired(GetObjectName('I060'), tre("Hergestellt.", "Crafted."))
			call Character(this.character()).giveItem('I060')
			call Character(this.character()).craftItem('I060')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod

		private static method onInit takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				call SetPlayerAbilityAvailable(Player(i), thistype.abilityId, false)
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary