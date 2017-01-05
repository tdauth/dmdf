/// Wizard
library StructSpellsSpellTransfer requires Asl, StructGameClasses, StructGameSpell

	struct SpellTransfer extends Spell
		public static constant integer abilityId = 'A163'
		public static constant integer favouriteAbilityId = 'A164'
		public static constant integer classSelectionAbilityId = 'A1OD'
		public static constant integer classSelectionGrimoireAbilityId = 'A1OE'
		public static constant integer maxLevel = 5
		private static constant real startAllyPercentage = 0.0
		private static constant real levelAllyPercentage = 0.05
		private static constant real startEnemyPercentage = 0.0
		private static constant real levelEnemyPercentage = 0.05
		private static constant real time = 10.0

		private method condition takes nothing returns boolean
			local boolean isAlly = GetUnitAllianceStateToUnit(this.character().unit(), GetSpellTargetUnit()) == bj_ALLIANCE_ALLIED

			if (not (GetUnitState(GetSpellTargetUnit(), UNIT_STATE_MAX_MANA) > 0.0)) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel hat kein Mana.", "Target has no mana."))
				return false
			elseif (isAlly and not (GetUnitState(GetSpellTargetUnit(), UNIT_STATE_MANA) < GetUnitState(GetSpellTargetUnit(), UNIT_STATE_MAX_MANA))) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel hat bereits volles Mana.", "Target does already have full mana."))
				return false
			elseif (isAlly and not (GetUnitState(this.character().unit(), UNIT_STATE_MANA) > 0.0)) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Charakter hat kein Mana.", "Character has no mana."))
				return false
			elseif (not isAlly and not (GetUnitState(GetSpellTargetUnit(), UNIT_STATE_MANA) > 0.0)) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel hat kein Mana.", "Target has no mana."))
				return false
			elseif (not isAlly and not (GetUnitState(this.character().unit(), UNIT_STATE_MANA) < GetUnitState(GetSpellTargetUnit(), UNIT_STATE_MAX_MANA))) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Charakter hat bereits volles Mana.", "Character does already have full mana."))
				return false
			endif

			return true
		endmethod

		private method action takes nothing returns nothing
			local boolean isAlly = GetUnitAllianceStateToUnit(this.character().unit(), GetSpellTargetUnit()) == bj_ALLIANCE_ALLIED
			local real manaPercentage = 0.0
			local real mana = 0.0
			local unit to
			local unit from
			local real time = thistype.time
			local ADynamicLightning whichLightning = ADynamicLightning.create(null, "DRAM", this.character().unit(), GetSpellTargetUnit())
			call whichLightning.setDestroyOnDeath(false)
			if (isAlly) then
				set manaPercentage = thistype.startAllyPercentage + this.level() * thistype.levelAllyPercentage
				set to = GetSpellTargetUnit()
				set from = this.character().unit()
			else
				set manaPercentage = thistype.startEnemyPercentage + this.level() * thistype.levelEnemyPercentage
				set from = GetSpellTargetUnit()
				set to = this.character().unit()
			endif
			loop
				exitwhen(time <= 0.0 or IsUnitDeadBJ(from) or IsUnitDeadBJ(to))
				exitwhen (GetUnitState(from, UNIT_STATE_MANA) <= 0.0 or GetUnitState(to, UNIT_STATE_MANA) >= GetUnitState(to, UNIT_STATE_MAX_MANA))
				set mana = GetUnitState(from, UNIT_STATE_MAX_MANA) * manaPercentage
				call SetUnitState(from, UNIT_STATE_MANA, GetUnitState(from, UNIT_STATE_MANA) - mana)
				call SetUnitState(to, UNIT_STATE_MANA, GetUnitState(to, UNIT_STATE_MANA) + mana)
				call thistype.showManaTextTag(to, mana)
				call thistype.showManaCostTextTag(from, mana)
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			call whichLightning.destroy()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.wizard(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A1OD', 'A1OE')
			call this.addGrimoireEntry('A165', 'A16A')
			call this.addGrimoireEntry('A166', 'A16B')
			call this.addGrimoireEntry('A167', 'A16C')
			call this.addGrimoireEntry('A168', 'A16D')
			call this.addGrimoireEntry('A169', 'A16E')

			return this
		endmethod
	endstruct

endlibrary