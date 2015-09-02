library StructMapMapBuildings requires StructGameCharacter

	struct Buildings
		private static trigger m_usageTrigger
		private static trigger m_deathTrigger
		private static unit array m_buildings
		
		private static method triggerConditionUsage takes nothing returns boolean
			local ACharacter character = ACharacter.getCharacterByUnit(GetTriggerUnit())
			local AClass class = 0
			if (character != 0) then
				set class = character.class()
				if (GetSpellAbilityId() == 'A191' or GetSpellAbilityId() == 'A192' or GetSpellAbilityId() == 'A190') then
					if (thistype.m_buildings[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] != null) then
						call IssueImmediateOrder(GetTriggerUnit(), "stop")
						call SimError(GetOwningPlayer(GetTriggerUnit()), tr("Sie haben bereits ein Gebäude errichtet."))
					elseif (GetSpellAbilityId() == 'A191' and class != Classes.knight() and class != Classes.dragonSlayer()) then
						call IssueImmediateOrder(GetTriggerUnit(), "stop")
						call SimError(GetOwningPlayer(GetTriggerUnit()), tr("Sie sind weder Ritter noch Drachentöter."))
					elseif (GetSpellAbilityId() == 'A192' and class != Classes.cleric() and class != Classes.necromancer()) then
						call IssueImmediateOrder(GetTriggerUnit(), "stop")
						call SimError(GetOwningPlayer(GetTriggerUnit()), tr("Sie sind weder Kleriker noch Nekromant."))
					elseif (GetSpellAbilityId() == 'A190' and class != Classes.elementalMage() and class != Classes.wizard()) then
						call IssueImmediateOrder(GetTriggerUnit(), "stop")
						call SimError(GetOwningPlayer(GetTriggerUnit()), tr("Sie sind weder Elementarmagier noch Zauberer."))
					else
						set thistype.m_buildings[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] = GetSummonedUnit()
						call Character.displayHintToAll(Format(tr("%1% hat das Gebäude %2% errichtet. Kommt und besucht es!")).s(GetPlayerName(character.player())).s(GetUnitName(GetSummonedUnit())).result())
						call PingMinimapEx(GetUnitX(GetSummonedUnit()), GetUnitY(GetSummonedUnit()), 5.0, PercentTo255(100), PercentTo255(100), PercentTo255(100), false)
						debug call Print("Summoned unit: " + GetUnitName(GetSummonedUnit()))
					endif
				endif
			endif
			return false
		endmethod
		
		private static method triggerConditionDeath takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (GetTriggerUnit() == thistype.m_buildings[i]) then
					set thistype.m_buildings[i] = null
					call Character.displayHintToAll(Format(tr("%1% hat das Gebäude %2% verloren!")).s(GetPlayerName(GetOwningPlayer(GetTriggerUnit()))).s(GetUnitName(GetTriggerUnit())).result())
					exitwhen (true)
				endif
				set i = i + 1
			endloop
			return false
		endmethod
		
		private static method onInit takes nothing returns nothing
			set thistype.m_usageTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_usageTrigger, EVENT_PLAYER_UNIT_SUMMON)
			call TriggerAddCondition(thistype.m_usageTrigger, Condition(function thistype.triggerConditionUsage))
			
			set thistype.m_deathTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_deathTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(thistype.m_deathTrigger, Condition(function thistype.triggerConditionDeath))
		endmethod
	endstruct

endlibrary