library StructSpellsSpellWitchSong requires Asl

	struct SpellWitchSong extends ASpell
		public static constant integer abilityId = 'A1W9'

		private method condition takes nothing returns boolean
			if (GetUnitTypeId(GetSpellTargetUnit()) == 'n02R') then
				debug call Print("Success")
				return true
			endif

			debug call Print("Fail")
			call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel muss ein Riese sein.", "Target has to be a giant."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call SetUnitOwner(GetSpellTargetUnit(), this.character().player(), true)
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL, false, true)
		endmethod
	endstruct

endlibrary