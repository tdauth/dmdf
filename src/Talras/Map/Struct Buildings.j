library StructMapMapBuildings requires StructGameCharacter

	struct Buildings
		private static trigger m_usageTrigger
		private static trigger m_constructionStartTrigger
		private static trigger m_constructionFinishTrigger
		private static trigger m_deathTrigger
		private static unit array m_buildings
		
		private static method triggerConditionUsage takes nothing returns boolean
			local ACharacter character = ACharacter.getCharacterByUnit(GetTriggerUnit())
			local AClass class = 0
			if (character != 0) then
				set class = character.class()
				if (GetSpellAbilityId() == 'A191' or GetSpellAbilityId() == 'A192' or GetSpellAbilityId() == 'A190' or GetSpellAbilityId() == 'A19E') then
					if (thistype.m_buildings[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] != null) then
						call IssueImmediateOrder(GetTriggerUnit(), "stop")
						call SimError(GetOwningPlayer(GetTriggerUnit()), tre("Sie haben bereits ein Gebäude errichtet.", "You have already constructed a building."))
					elseif (GetSpellAbilityId() == 'A191' and class != Classes.knight() and class != Classes.dragonSlayer()) then
						call IssueImmediateOrder(GetTriggerUnit(), "stop")
						call SimError(GetOwningPlayer(GetTriggerUnit()), tre("Sie sind weder Ritter noch Drachentöter.", "You are neither knight nor dragon slayer."))
					elseif (GetSpellAbilityId() == 'A192' and class != Classes.cleric() and class != Classes.necromancer()) then
						call IssueImmediateOrder(GetTriggerUnit(), "stop")
						call SimError(GetOwningPlayer(GetTriggerUnit()), tre("Sie sind weder Kleriker noch Nekromant.", "You are neither cleric nor necromancer."))
					elseif (GetSpellAbilityId() == 'A190' and class != Classes.elementalMage() and class != Classes.wizard()) then
						call IssueImmediateOrder(GetTriggerUnit(), "stop")
						call SimError(GetOwningPlayer(GetTriggerUnit()), tre("Sie sind weder Elementarmagier noch Zauberer.", "You are neither elemental mage nor wizard."))
					elseif (GetSpellAbilityId() == 'A19E' and class != Classes.druid() and class != Classes.ranger()) then
						call IssueImmediateOrder(GetTriggerUnit(), "stop")
						call SimError(GetOwningPlayer(GetTriggerUnit()), tre("Sie sind weder Druide noch Waldläufer.", "You are neither druid nor ranger."))
					endif
				endif
			endif
			return false
		endmethod
		
		private static method triggerConditionConstructionStart takes nothing returns boolean
			if (GetUnitTypeId(GetConstructingStructure()) == 'h027' or GetUnitTypeId(GetConstructingStructure()) == 'h028' or GetUnitTypeId(GetConstructingStructure()) == 'h029' or GetUnitTypeId(GetConstructingStructure()) == 'h02C') then
				if (thistype.m_buildings[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] != null) then
					call IssueImmediateOrder(GetTriggerUnit(), "stop")
					call SimError(GetOwningPlayer(GetTriggerUnit()), tre("Sie haben bereits ein Gebäude errichtet.", "You have already constructed a building."))
				else
					set thistype.m_buildings[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] = GetConstructingStructure()
				endif
			endif
			return false
		endmethod
		
		private static method triggerConditionConstructionFinish takes nothing returns boolean
			if (GetUnitTypeId(GetConstructedStructure()) == 'h027' or GetUnitTypeId(GetConstructedStructure()) == 'h028' or GetUnitTypeId(GetConstructedStructure()) == 'h029' or GetUnitTypeId(GetConstructedStructure()) == 'h02C') then
				call Character.displayHintToAll(Format(tre("%1% hat das Gebäude %2% errichtet. Kommt und besucht es!", "%1% has constructed the building %2%. Come and visit it!")).s(GetPlayerName(GetOwningPlayer(GetConstructedStructure()))).s(GetUnitName(GetConstructedStructure())).result())
				call PingMinimapEx(GetUnitX(GetConstructedStructure()), GetUnitY(GetConstructedStructure()), 5.0, PercentTo255(100), PercentTo255(100), PercentTo255(100), false)
				debug call Print("Summoned unit: " + GetUnitName(GetConstructedStructure()))
			endif
			return false
		endmethod
		
		private static method triggerConditionDeath takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (GetTriggerUnit() == thistype.m_buildings[i]) then
					set thistype.m_buildings[i] = null
					call Character.displayHintToAll(Format(tre("%1% hat das Gebäude %2% verloren!", "%1% has lost the building %2%!")).s(GetPlayerName(GetOwningPlayer(GetTriggerUnit()))).s(GetUnitName(GetTriggerUnit())).result())
					exitwhen (true)
				endif
				set i = i + 1
			endloop
			return false
		endmethod
		
		private static method onInit takes nothing returns nothing
			set thistype.m_usageTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_usageTrigger, EVENT_PLAYER_UNIT_SPELL_CAST)
			call TriggerAddCondition(thistype.m_usageTrigger, Condition(function thistype.triggerConditionUsage))
			
			set thistype.m_constructionStartTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_constructionStartTrigger, EVENT_PLAYER_UNIT_CONSTRUCT_START)
			call TriggerAddCondition(thistype.m_constructionStartTrigger, Condition(function thistype.triggerConditionConstructionStart))
			
			set thistype.m_constructionFinishTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_constructionFinishTrigger, EVENT_PLAYER_UNIT_CONSTRUCT_FINISH)
			call TriggerAddCondition(thistype.m_constructionFinishTrigger, Condition(function thistype.triggerConditionConstructionFinish))
			
			set thistype.m_deathTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_deathTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(thistype.m_deathTrigger, Condition(function thistype.triggerConditionDeath))
		endmethod
	endstruct

endlibrary