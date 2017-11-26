library StructSpellsSpellReviveCreeps requires Asl, StructGameCharacter, StructGameSpawnPoint

	struct SpellReviveCreeps
		private static trigger m_castTrigger

		private static method triggerCondition takes nothing returns boolean
			if (GetSpellAbilityId() == 'A1S8') then
				call Character.displayWarningToAll(Format(tre("Die Unholde wurden von %1% erweckt!", "The creeps have been awakened by %1%!")).s(GetUnitName(GetTriggerUnit())).result())
				call SpawnPoint.spawnDeadOnlyAll()
			endif

			return false
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.m_castTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_castTrigger, EVENT_PLAYER_UNIT_SPELL_CAST)
			call TriggerAddCondition(thistype.m_castTrigger, Condition(function thistype.triggerCondition))
		endmethod
	endstruct

endlibrary