library StructSpellsSpellFatherHeir requires Asl, StructGameCharacter

	struct SpellFatherHeir extends AUnitSpell
		public static constant integer abilityId = 'A1JO'
		/// The number of spawnable units is limited.
		public static constant integer maxUnits = 5
		private static integer array m_playerCounter
		private static trigger m_deathTrigger

		private method condition takes nothing returns boolean

			if (ACharacter.isUnitCharacter(GetSpellTargetUnit())) then
				if (thistype.m_playerCounter[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] >= thistype.maxUnits) then
					call SimError(GetOwningPlayer(GetTriggerUnit()), Format(tre("Ex können maximal %1% Erben gezeugt werden.", "There can be %1% heirs at maximum.")).i(thistype.maxUnits).result())

					return false
				endif

				return true
			endif

			call SimError(GetOwningPlayer(GetTriggerUnit()), tre("Ziel muss ein Charakter sein.", "Target must be a character."))

			return false
		endmethod

		private method action takes nothing returns nothing
			call CreateUnit(GetOwningPlayer(GetTriggerUnit()), 'n076', GetUnitX(GetSpellTargetUnit()), GetUnitY(GetSpellTargetUnit()), 0.0)
			set thistype.m_playerCounter[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] = thistype.m_playerCounter[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] + 1
		endmethod

		public static method create takes nothing returns thistype
			return thistype.allocate(thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_CHANNEL, false, true, true)
		endmethod

		private static method triggerConditionDeath takes nothing returns boolean
			if (GetUnitTypeId(GetTriggerUnit()) == 'n076') then
				set thistype.m_playerCounter[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] = thistype.m_playerCounter[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] - 1
			endif

			return false
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.m_deathTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_deathTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(thistype.m_deathTrigger, Condition(function thistype.triggerConditionDeath))
		endmethod
	endstruct

endlibrary