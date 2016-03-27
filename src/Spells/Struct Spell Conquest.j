/// Knight
library StructSpellsSpellConquest requires Asl, StructGameClasses, StructGameSpell

	struct SpellConquest extends Spell
		public static constant integer abilityId = 'A1H9'
		public static constant integer favouriteAbilityId = 'A1HA'
		public static constant integer classSelectionAbilityId = 'A1JK'
		public static constant integer classSelectionGrimoireAbilityId = 'A1JL'
		public static constant integer maxLevel = 5
		private static constant integer maxLevelStartValue = 1
		private static constant integer maxLevelLevelValue = 1
		
		private method condition takes nothing returns boolean
			local boolean isAlly = GetUnitAllianceStateToUnit(this.character().unit(), GetSpellTargetUnit()) == bj_ALLIANCE_ALLIED
			
			if (GetUnitLevel(GetSpellTargetUnit()) > this.level() * thistype.maxLevelLevelValue + thistype.maxLevelStartValue) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel ist zu mächtig.", "Target is too powerful."))
				return false
			endif
			
			return true
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, 0)
			call this.addGrimoireEntry('A1JK', 'A1JL')
			call this.addGrimoireEntry('A1GY', 'A1HF')
			call this.addGrimoireEntry('A1HB', 'A1HG')
			call this.addGrimoireEntry('A1HC', 'A1HH')
			call this.addGrimoireEntry('A1HD', 'A1HI')
			call this.addGrimoireEntry('A1HE', 'A1HJ')
			
			return this
		endmethod
	endstruct

endlibrary