library StructSpellsSpellBookOfDemonology requires Asl, StructGameCharacter

	struct SpellBookOfDemonologySacrificeChild extends ASpell
		public static constant integer abilityId = 'A1V9'

		private method condition takes nothing returns boolean
			if (GetUnitTypeId(GetSpellTargetUnit()) == 'nvlk' or GetUnitTypeId(GetSpellTargetUnit()) == 'nvk2' or GetUnitTypeId(GetSpellTargetUnit()) == 'n084' or GetUnitTypeId(GetSpellTargetUnit()) == 'n085') then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel muss ein Kind sein.", "Target has to be a child."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call KillUnit(GetSpellTargetUnit())
			// TODO Demonic effect

			call Character(this.character()).displayItemAcquired(GetObjectName('I07C'), tre("Gefangen.", "Captured."))
			call Character(this.character()).giveItem('I07C')
			call Character(this.character()).craftItem('I07C')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

	struct SpellBookOfDemonologySacrificeAnimal extends ASpell
		public static constant integer abilityId = 'A1VA'

		private method condition takes nothing returns boolean
			if (GetUnitTypeId(GetSpellTargetUnit()) == 'n02Y' or GetUnitTypeId(GetSpellTargetUnit()) == 'n02X' or GetUnitTypeId(GetSpellTargetUnit()) == 'n02N' or GetUnitTypeId(GetSpellTargetUnit()) == 'n06R' or GetUnitTypeId(GetSpellTargetUnit()) == 'n01K' or GetUnitTypeId(GetSpellTargetUnit()) == 'n083' or GetUnitTypeId(GetSpellTargetUnit()) == 'n00B' or GetUnitTypeId(GetSpellTargetUnit()) == 'h02K') then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel muss ein Tier sein.", "Target has to be an animal."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call KillUnit(GetSpellTargetUnit())
			// TODO Demonic effect

			call Character(this.character()).displayItemAcquired(GetObjectName('I07D'), tre("Gefangen.", "Captured."))
			call Character(this.character()).giveItem('I07D')
			call Character(this.character()).craftItem('I07D')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

	struct SpellBookOfDemonologyConjuration extends ASpell
		public static constant integer abilityId = 'A1VB'

		private method condition takes nothing returns boolean
			if (this.character().inventory().totalItemTypeCharges('I07C') >= 1 and this.character().inventory().totalItemTypeCharges('I07D') >= 2) then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			local unit summoned = CreateUnit(this.character().player(), 'n086', GetUnitX(this.character().unit()), GetUnitY(this.character().unit()), 0.0)
			call UnitApplyTimedLife(summoned, 'B010', 60.0)
			set summoned = CreateUnit(this.character().player(), 'n087', GetUnitX(this.character().unit()), GetUnitY(this.character().unit()), 0.0)
			call UnitApplyTimedLife(summoned, 'B010', 60.0)
			set summoned = CreateUnit(this.character().player(), 'n088', GetUnitX(this.character().unit()), GetUnitY(this.character().unit()), 0.0)
			call UnitApplyTimedLife(summoned, 'B010', 60.0)

			call this.character().inventory().removeItemType('I07C')
			call this.character().inventory().removeItemType('I07D')
			call this.character().inventory().removeItemType('I07D')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

endlibrary