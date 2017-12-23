library StructSpellsSpellBookOfDemonology requires StructSpellsSpellBookCraftingSpell

	struct SpellBookOfDemonologySacrificeChild extends SpellBookCraftingSpell
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
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

	struct SpellBookOfDemonologySacrificeAnimal extends SpellBookCraftingSpell
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
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

	struct SpellBookOfDemonologyConjuration extends SpellBookCraftingSpell
		public static constant integer abilityId = 'A1VB'
		private static constant real time = 60.0

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
			call UnitApplyTimedLife(summoned, 'B010', thistype.time)
			set summoned = CreateUnit(this.character().player(), 'n087', GetUnitX(this.character().unit()), GetUnitY(this.character().unit()), 0.0)
			call UnitApplyTimedLife(summoned, 'B010', thistype.time)
			set summoned = CreateUnit(this.character().player(), 'n088', GetUnitX(this.character().unit()), GetUnitY(this.character().unit()), 0.0)
			call UnitApplyTimedLife(summoned, 'B010', thistype.time)

			call this.character().inventory().removeItemType('I07C')
			call this.character().inventory().removeItemType('I07D')
			call this.character().inventory().removeItemType('I07D')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

	private struct SpellBookOfDemonologyBloodRitualBuffData
		private Character m_character
		private AGroup m_targets
		private AIntegerVector m_dynamicLightnings
		private effect m_effect
		private timer m_updateTimer
		private real m_elapsedTime

		private static method timerFunctionUpdate takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), 0))
			local real life = 0.0
			local real totalLife = 0.0
			local unit target = null
			local integer i = 0
			set this.m_elapsedTime = this.m_elapsedTime +  TimerGetElapsed(GetExpiredTimer())

			if (this.m_elapsedTime >= 12.0) then
				call this.destroy()
			else
				set i = 0
				loop
					exitwhen (i == this.m_targets.units().size())
					set target = this.m_targets.units()[i]
					if (not IsUnitDeadBJ(target)) then
						set life = GetUnitState(target, UNIT_STATE_MAX_LIFE) * 0.05
						call SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE) - life)
						call Spell.showLifeCostTextTag(target, life)
						set totalLife = totalLife + life
						set i = i + 1
					else
						call this.m_targets.units().erase(i)
					endif
					set target = null
				endloop

				call SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE) + totalLife)
				call Spell.showLifeCostTextTag(this.m_character.unit(), totalLife)
			endif
		endmethod


		public static method create takes Character character, AGroup targets returns thistype
			local thistype this = thistype.allocate()
			local integer i = 0

			set this.m_character = character
			set this.m_targets = targets
			set this.m_effect = AddSpellEffectTargetById(SpellBookOfDemonologyBloodRitual.abilityId, EFFECT_TYPE_TARGET, character.unit(), "origin")
			set this.m_dynamicLightnings = AIntegerVector.create()
			set i = 0
			loop
				exitwhen (i == targets.units().size())
				call this.m_dynamicLightnings.pushBack(ADynamicLightning.create(null, "AFOD", character.unit(), targets.units()[i]))
				set i = i + 1
			endloop
			set this.m_updateTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_updateTimer, 0, this)
			call TimerStart(this.m_updateTimer, 0.01, true, function thistype.timerFunctionUpdate)
			set this.m_elapsedTime = 0.0

			return this
		endmethod

		private method onDestroy takes nothing returns nothing
			local integer i = 0
			call PauseTimer(this.m_updateTimer)
			call DmdfHashTable.global().destroyTimer(this.m_updateTimer)
			call DestroyEffect(this.m_effect)
			set this.m_effect = null
			set i = 0
			loop
				exitwhen (i == this.m_dynamicLightnings.size())
				call ADynamicLightning(this.m_dynamicLightnings[i]).destroy()
				set i = i + 1
			endloop
			call this.m_dynamicLightnings.destroy()
			call this.m_targets.destroy()
		endmethod
	endstruct

	struct SpellBookOfDemonologyBloodRitual extends SpellBookCraftingSpell
		public static constant integer abilityId = 'A1VE'
		public static constant real area = 300.0

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
			if (targets != 0) then
				call SpellBookOfDemonologyBloodRitualBuffData.create(this.character(), targets)
			endif
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

	struct SpellBookOfDemonologyLordOfDarkness extends SpellBookCraftingSpell
		public static constant integer abilityId = 'A1VD'
		private static constant real time = 60.0

		private method condition takes nothing returns boolean
			if (this.character().inventory().totalItemTypeCharges('I07C') >= 2 and this.character().inventory().totalItemTypeCharges('I07D') >= 3) then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Benötigte Rohstoffe fehlen.", "Required resources are missing."))

			return false
		endmethod

		private method action takes nothing returns nothing
			local unit summoned = CreateUnit(this.character().player(), 'n08V', GetUnitX(this.character().unit()), GetUnitY(this.character().unit()), 0.0)
			call UnitApplyTimedLife(summoned, 'B010', thistype.time)

			call this.character().inventory().removeItemType('I07C')
			call this.character().inventory().removeItemType('I07C')
			call this.character().inventory().removeItemType('I07D')
			call this.character().inventory().removeItemType('I07D')
			call this.character().inventory().removeItemType('I07D')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

endlibrary