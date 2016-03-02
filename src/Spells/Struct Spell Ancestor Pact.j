/// Necromancer
library StructSpellsSpellAncestorPact requires Asl, StructGameClasses, StructGameSpell

	/**
	 * Der Nekromant regeneriert sein Leben und Mana mit Hilfe eines Kadavers. Wandelt X% des ursprünglichen Lebens des Ziels zu Leben und Y% zu Mana um.
	 */
	struct SpellAncestorPact extends Spell
		public static constant integer abilityId = 'A08N'
		public static constant integer favouriteAbilityId = 'A08I'
		public static constant integer classSelectionAbilityId = 'A0RK'
		public static constant integer classSelectionGrimoireAbilityId = 'A0RP'
		public static constant integer maxLevel = 5
		private static constant real targetRadius = 200.0
		private static constant real lifePercentage = 0.10
		private static constant real lifePercentageLevelValue = 10.0 // ab Stufe 1
		private static constant real manaPercentage = 0.0
		private static constant real manaPercentageLevelValue = 10.0 // ab Stufe 1

		private static method unitFilter takes nothing returns boolean
			return IsUnitDeadBJ(GetFilterUnit())
		endmethod
		
		private method targets takes nothing returns AGroup
			local AGroup targets = AGroup.create()
			call targets.addUnitsInRangeCounted(GetSpellTargetX(), GetSpellTargetY(), thistype.targetRadius, Filter(function thistype.unitFilter), 1)
			return targets
		endmethod
		
		private method target takes nothing returns unit
			local AGroup targets = this.targets()
			local unit result
			
			if (not targets.units().empty()) then
				set result = targets.units()[0]
			endif
			call targets.destroy()
			
			return result
		endmethod
		
		private method condition takes nothing returns boolean
			local unit target = this.target()
			
			if (target == null) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Kein totes Ziel gefunden.", "Missing dead target."))
				
				return false
			endif
			
			if (GetUnitState(this.character().unit(), UNIT_STATE_LIFE) < GetUnitState(this.character().unit(), UNIT_STATE_MAX_LIFE)) then
				return true
			elseif (GetUnitState(this.character().unit(), UNIT_STATE_MANA) < GetUnitState(this.character().unit(), UNIT_STATE_MAX_MANA)) then
				if (GetUnitState(target, UNIT_STATE_MAX_MANA) > 0.0) then
					return true
				else
					call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel hat kein Mana.", "Target has no mana."))
				endif
			else
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Charakter hat volle Werte.", "Character has full stats."))
			endif
			
			return false
		endmethod

		private method action takes nothing returns nothing
			local unit target = this.target() // not necessarily the same unit but that's just okay
			local real life
			local real mana
			set life =  GetUnitState(target, UNIT_STATE_MAX_LIFE) * (thistype.lifePercentage + (this.level() - 1) * thistype.lifePercentageLevelValue)
			set life = RMinBJ(life, GetUnitMissingLife(this.character().unit()))
			set mana = GetUnitState(target, UNIT_STATE_MAX_MANA) * (thistype.manaPercentage + (this.level() - 1) * thistype.manaPercentageLevelValue)
			set mana = RMinBJ(mana, GetUnitMissingMana(this.character().unit()))
			
			if (life > 0.0) then
				call SetUnitLifeBJ(this.character().unit(), GetUnitState(this.character().unit(), UNIT_STATE_MAX_LIFE) + life)
				call thistype.showLifeTextTag(this.character().unit(), life)
			endif
			
			if (mana > 0.0) then
				call SetUnitManaBJ(this.character().unit(), GetUnitState(this.character().unit(), UNIT_STATE_MAX_MANA) + mana)
				call thistype.showManaTextTag(this.character().unit(), mana)
			endif
			
			call RemoveUnit(target)
			set target = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.necromancer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			
			call this.addGrimoireEntry('A0RK', 'A0RP')
			call this.addGrimoireEntry('A0RL', 'A0RQ')
			call this.addGrimoireEntry('A0RM', 'A0RR')
			call this.addGrimoireEntry('A0RM', 'A0RS')
			call this.addGrimoireEntry('A0RO', 'A0RT')
			
			return this
		endmethod
	endstruct

endlibrary