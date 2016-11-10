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

	struct SpellBookOfDemonologyBloodRitual extends ASpell
		public static constant integer abilityId = 'A1VE'
		public static constant real area = 300.0

		// AFOD

		private static method filter takes nothing returns boolean
			return not IsUnitDeadBJ(GetFilterUnit())
		endmethod

		private method targets takes unit caster, real x, real y returns AGroup
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets = AGroup.create()
			call GroupEnumUnitsInRange(targetGroup, x, y, thistype.area, filter)
			call targets.addGroup(targetGroup, true, false)
			set targetGroup = null
			call targets.removeAlliesOfUnit(caster)
			call DestroyFilter(filter)
			set filter = null
			return targets
		endmethod

		private method condition takes nothing returns boolean
			local AGroup targets = this.targets(this.character().unit(), GetSpellTargetX(), GetSpellTargetY())
			local boolean result = not targets.units().empty()
			if (not result) then
				debug call Print("Success")

				call this.character().displayMessage(ACharacter.messageTypeError, tre("Keine gültigen Ziele.", "No valid targets."))
				call targets.destroy()
			else
				call DmdfHashTable.global().setHandleInteger(GetTriggeringTrigger(), 0, targets)
			endif

			return result
		endmethod

		private method action takes nothing returns nothing
			local AGroup targets = AGroup(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			local integer i = 0
			local AIntegerVector dynamicLightnings = 0
			local effect whichEffect = null

			if (targets != 0) then
				set whichEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, this.character().unit(), "origin")
				set dynamicLightnings = AIntegerVector.create()
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					call dynamicLightnings.pushBack(ADynamicLightning.create(null, "AFOD", 0.01, this.character().unit(), targets.units()[i]))
					set i = i + 1
				endloop
				call TriggerSleepAction(12.0)
				set i = 0
				loop
					exitwhen (i == dynamicLightnings.size())
					call ADynamicLightning(dynamicLightnings[i]).destroy()
					set i = i + 1
				endloop
				call dynamicLightnings.destroy()
				call targets.destroy()
			endif
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

endlibrary