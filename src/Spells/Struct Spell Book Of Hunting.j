library StructSpellsSpellBookOfHunting requires StructSpellsSpellBookCraftingSpell

	/**
	 * \return Returns the first unit from a group of a specific point with a specified radius of 250.0 using a custom filter. Returns null if no unit is in range matching the filter.
	 */
	private function GetCorpseInRange takes real x, real y, boolexpr filter returns unit
		local unit result = null
		local AGroup whichGroup = AGroup.create()
		call whichGroup.addUnitsInRange(x, y, 250.0, filter)

		if (not whichGroup.units().isEmpty()) then
			set result = whichGroup.units().front()
		endif

		call whichGroup.destroy()

		return result
	endfunction

	struct SpellBookOfHuntingPullFangs extends SpellBookCraftingSpell
		public static constant integer abilityId = 'A1TQ'

		private static method filter takes nothing returns boolean
			return IsUnitDeadBJ(GetFilterUnit()) and GetUnitTypeId(GetFilterUnit()) == 'n002'
		endmethod

		private method condition takes nothing returns boolean
			local unit target = GetCorpseInRange(GetSpellTargetX(), GetSpellTargetY(), Filter(function thistype.filter))

			if (target != null) then
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel muss ein toter Keiler sein.", "Target must be a dead boar."))

			return false
		endmethod

		private method action takes nothing returns nothing
			local unit target = GetCorpseInRange(GetSpellTargetX(), GetSpellTargetY(), Filter(function thistype.filter))

			if (target != null) then
				call Character(this.character()).displayItemAcquired(GetObjectName('I007'), tre("Gezogen.", "Pulled."))
				call Character(this.character()).giveItem('I007')
				call Character(this.character()).craftItem('I007')
				call RemoveUnit(target)
				set target = null
			endif
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

	struct SpellBookOfHuntingPullFurs extends SpellBookCraftingSpell
		public static constant integer abilityId = 'A1TR'


		private static method filter takes nothing returns boolean
			return IsUnitDeadBJ(GetFilterUnit()) and (GetUnitTypeId(GetFilterUnit()) == 'n02F' or GetUnitTypeId(GetFilterUnit()) == 'n00V' or GetUnitTypeId(GetFilterUnit()) == 'n04G' or GetUnitTypeId(GetFilterUnit()) == 'n008' or GetUnitTypeId(GetFilterUnit()) == 'n02G' or GetUnitTypeId(GetFilterUnit()) == 'n02R')
		endmethod

		private method condition takes nothing returns boolean
			local unit target = GetCorpseInRange(GetSpellTargetX(), GetSpellTargetY(), Filter(function thistype.filter))

			if (target != null) then
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel muss ein totes Tier mit Fell sein.", "Target must be a dead animal with fur."))

			return false
		endmethod

		private method action takes nothing returns nothing
			local unit target = GetCorpseInRange(GetSpellTargetX(), GetSpellTargetY(), Filter(function thistype.filter))

			if (target != null) then
				// wolf
				if (GetUnitTypeId(target) == 'n02F') then
					call Character(this.character()).displayItemAcquired(GetObjectName('I01H'), tre("Abgezogen.", "Pulled."))
					call Character(this.character()).giveItem('I01H')
					call Character(this.character()).craftItem('I01H')
				// deer
				elseif (GetUnitTypeId(target) == 'n00V') then
					call Character(this.character()).displayItemAcquired(GetObjectName('I00P'), tre("Abgezogen.", "Pulled."))
					call Character(this.character()).giveItem('I00P')
					call Character(this.character()).craftItem('I00P')
				// bear man
				elseif (GetUnitTypeId(target) == 'n04G') then
					call Character(this.character()).displayItemAcquired(GetObjectName('I058'), tre("Abgezogen.", "Pulled."))
					call Character(this.character()).giveItem('I058')
					call Character(this.character()).craftItem('I058')
				// bear
				elseif (GetUnitTypeId(target) == 'n008') then
					call Character(this.character()).displayItemAcquired(GetObjectName('I01J'), tre("Abgezogen.", "Pulled."))
					call Character(this.character()).giveItem('I01J')
					call Character(this.character()).craftItem('I01J')
				// pack leader
				elseif (GetUnitTypeId(target) == 'n02G') then
					call Character(this.character()).displayItemAcquired(GetObjectName('I01I'), tre("Abgezogen.", "Pulled."))
					call Character(this.character()).giveItem('I01I')
					call Character(this.character()).craftItem('I01I')
				// giant
				elseif (GetUnitTypeId(target) == 'n02R') then
					call Character(this.character()).displayItemAcquired(GetObjectName('I01Z'), tre("Abgezogen.", "Pulled."))
					call Character(this.character()).giveItem('I01Z')
					call Character(this.character()).craftItem('I01Z')
				endif

				call RemoveUnit(target)
				set target = null
			endif
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

	struct SpellBookOfHuntingPullBones extends SpellBookCraftingSpell
		public static constant integer abilityId = 'A1TS'


		private static method filter takes nothing returns boolean
			return IsUnitDeadBJ(GetFilterUnit()) and IsUnitType(GetFilterUnit(), UNIT_TYPE_UNDEAD)
		endmethod

		private method condition takes nothing returns boolean
			local unit target = GetCorpseInRange(GetSpellTargetX(), GetSpellTargetY(), Filter(function thistype.filter))

			if (target != null) then
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel muüssen die Reste eines Untoten sein.", "Target must be the remains of an Undead."))

			return false
		endmethod

		private method action takes nothing returns nothing
			local unit target = GetCorpseInRange(GetSpellTargetX(), GetSpellTargetY(), Filter(function thistype.filter))

			if (target != null) then
				call Character(this.character()).displayItemAcquired(GetObjectName('I05I'), tre("Entfernt.", "Removed."))
				call Character(this.character()).giveItem('I05I')
				call Character(this.character()).craftItem('I05I')

				call RemoveUnit(target)
				set target = null
			endif
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, thistype.condition, thistype.action)
		endmethod
	endstruct

endlibrary