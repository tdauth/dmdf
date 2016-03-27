library StructSpellsSpellFatherHeir requires Asl, StructGameCharacter

	struct SpellFatherHeir extends AUnitSpell
		public static constant integer abilityId = 'A1JO'

		private method condition takes nothing returns boolean
		
			if (ACharacter.isUnitCharacter(GetSpellTargetUnit())) then
				return true
			endif

			call SimError(GetOwningPlayer(GetTriggerUnit()), tre("Ziel muss ein Charakter sein.", "Target must be a character."))
			
			return false
		endmethod
		
		private method action takes nothing returns nothing
			call CreateUnit(GetOwningPlayer(GetTriggerUnit()), 'n076', GetUnitX(GetSpellTargetUnit()), GetUnitY(GetSpellTargetUnit()), 0.0)
		endmethod

		public static method create takes nothing returns thistype
			return thistype.allocate(thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct
	
endlibrary