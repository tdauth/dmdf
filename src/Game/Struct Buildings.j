library StructGameBuildings requires Asl, StructGameCharacter, StructGameClasses

	/**
	 * \brief Every player can acquire a plan for a building for his class and use it once. The building provides units and spells and allows collecting resources.
	 */
	struct Buildings
		/**
		 * Since the building allows collecting gold and many more things it should become available at a higher level.
		 */
		public static constant integer requiredLevel = 30
		private static timer m_refillTimer
		private static trigger m_bringGoldTrigger
		private static trigger m_usageTrigger
		private static trigger m_constructionStartTrigger
		private static trigger m_constructionFinishTrigger
		private static trigger m_deathTrigger
		private static trigger m_upgradeTrigger
		private static unit array m_buildings
		private static integer array m_collectedGold[12] // TODO MapSettings.maxPlayers()

		public static method playerBuilding takes integer playerIndex returns unit
			return thistype.m_buildings[playerIndex]
		endmethod

		private static method timerFunctionRefill takes nothing returns nothing
			local unit goldmine = MapSettings.goldmine()
			if (goldmine != null) then
				if (GetResourceAmount(goldmine) < 1000000) then
					call SetResourceAmount(goldmine, 1000000)
				endif
			endif
		endmethod

		private static method triggerConditionBringGold takes nothing returns boolean
			local integer actualGold = 10
			local integer gold = 10
			if (GetPlayerState(GetTriggerPlayer(), PLAYER_STATE_GOLD_GATHERED) > thistype.m_collectedGold[GetPlayerId(GetTriggerPlayer())]) then
				set gold = IMaxBJ(1, 10 * R2I(GetDistanceBetweenUnitsWithoutZ(thistype.m_buildings[GetPlayerId(GetTriggerPlayer())], MapSettings.goldmine()) / 1000.0))
				debug call Print("Gathered gold fixed value: " + I2S(gold))
				debug call Print("Current gold: " + I2S(GetPlayerState(GetTriggerPlayer(), PLAYER_STATE_RESOURCE_GOLD)))
				debug call Print("Gathered gold: " + I2S(GetPlayerState(GetTriggerPlayer(), PLAYER_STATE_GOLD_GATHERED)))
				if (gold < actualGold) then
					debug call Print("Removing gold: " + I2S(actualGold - gold))
					call SetPlayerState(GetTriggerPlayer(), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetTriggerPlayer(), PLAYER_STATE_RESOURCE_GOLD) - (actualGold - gold))
					call Bounty(GetTriggerPlayer(), GetUnitX(thistype.m_buildings[GetPlayerId(GetTriggerPlayer())]), GetUnitY(thistype.m_buildings[GetPlayerId(GetTriggerPlayer())]), gold)
				elseif (gold > actualGold) then
					debug call Print("Old gold: " + I2S(GetPlayerState(GetTriggerPlayer(), PLAYER_STATE_RESOURCE_GOLD)))
					debug call Print("Adding gold: " + I2S(gold - actualGold))
					debug call Print("New gold: " + I2S(GetPlayerState(GetTriggerPlayer(), PLAYER_STATE_RESOURCE_GOLD) + (gold - actualGold)))
					call SetPlayerState(GetTriggerPlayer(), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(GetTriggerPlayer(), PLAYER_STATE_RESOURCE_GOLD) + (gold - actualGold))
					call Bounty(GetTriggerPlayer(), GetUnitX(thistype.m_buildings[GetPlayerId(GetTriggerPlayer())]), GetUnitY(thistype.m_buildings[GetPlayerId(GetTriggerPlayer())]), gold)
				endif

				set thistype.m_collectedGold[GetPlayerId(GetTriggerPlayer())] = GetPlayerState(GetTriggerPlayer(), PLAYER_STATE_GOLD_GATHERED)
				// TODO the trigger gets more and more events every time
				call TriggerRegisterPlayerStateEvent(thistype.m_bringGoldTrigger, GetTriggerPlayer(), PLAYER_STATE_GOLD_GATHERED, GREATER_THAN, thistype.m_collectedGold[GetPlayerId(GetTriggerPlayer())])
			endif

			return false
		endmethod

		private static method triggerConditionUsage takes nothing returns boolean
			local ACharacter character = ACharacter.getCharacterByUnit(GetTriggerUnit())
			local AClass class = 0
			if (character != 0) then
				set class = character.class()
				if (GetSpellAbilityId() == 'A191' or GetSpellAbilityId() == 'A192' or GetSpellAbilityId() == 'A190' or GetSpellAbilityId() == 'A19E') then
					if (thistype.m_buildings[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] != null) then
						call IssueImmediateOrder(GetTriggerUnit(), "stop")
						call SimError(GetOwningPlayer(GetTriggerUnit()), tre("Sie haben bereits ein Gebäude errichtet.", "You have already constructed a building."))
					elseif (GetHeroLevel(character.unit()) < thistype.requiredLevel) then
						call IssueImmediateOrder(GetTriggerUnit(), "stop")
						call SimError(GetOwningPlayer(GetTriggerUnit()), Format(tre("Ihr Charakter muss mindestens Stufe %1% erreicht haben.", "Your character has to have reached at least level %1%.")).i(thistype.requiredLevel).result())
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
			local ACharacter character = ACharacter.playerCharacter(GetOwningPlayer(GetTriggerUnit()))
			if (GetUnitTypeId(GetConstructingStructure()) == 'h027' or GetUnitTypeId(GetConstructingStructure()) == 'h028' or GetUnitTypeId(GetConstructingStructure()) == 'h029' or GetUnitTypeId(GetConstructingStructure()) == 'h02C') then
				set thistype.m_buildings[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))] = GetConstructingStructure()
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

		private static method triggerConditionUpgrade takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (GetTriggerUnit() == thistype.m_buildings[i]) then
					// mage
					if (GetUnitTypeId(GetTriggerUnit()) == 'h027' or GetUnitTypeId(GetTriggerUnit()) == 'h02B') then
						call UnitRemoveAbility(thistype.m_buildings[i], 'A19O')
						call UnitAddAbility(thistype.m_buildings[i], 'A19O')
					// castle
					elseif (GetUnitTypeId(GetTriggerUnit()) == 'h028') then
						call UnitRemoveAbility(thistype.m_buildings[i], 'A19P')
						call UnitAddAbility(thistype.m_buildings[i], 'A19P')
					// church
					elseif (GetUnitTypeId(GetTriggerUnit()) == 'h029' or GetUnitTypeId(GetTriggerUnit()) == 'h02D') then
						call UnitRemoveAbility(thistype.m_buildings[i], 'A19Q')
						call UnitAddAbility(thistype.m_buildings[i], 'A19Q')
					// tree
					elseif (GetUnitTypeId(GetTriggerUnit()) == 'h02C' or GetUnitTypeId(GetTriggerUnit()) == 'h02U') then
						call UnitRemoveAbility(thistype.m_buildings[i], 'A19R')
						call UnitAddAbility(thistype.m_buildings[i], 'A19R')
					endif

					debug call Print("Readd spell book " + GetUnitName(GetTriggerUnit()))

					exitwhen (true)
				endif
				set i = i + 1
			endloop
			return false
		endmethod

		private static method onInit takes nothing returns nothing
			local integer i
			set thistype.m_refillTimer = CreateTimer()
			call TimerStart(thistype.m_refillTimer, 4.0, true, function thistype.timerFunctionRefill)

			set thistype.m_bringGoldTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set thistype.m_collectedGold[i] = 0
				call TriggerRegisterPlayerStateEvent(thistype.m_bringGoldTrigger, Player(i), PLAYER_STATE_GOLD_GATHERED, GREATER_THAN, thistype.m_collectedGold[i])
				set i = i + 1
			endloop
			call TriggerAddCondition(thistype.m_bringGoldTrigger, Condition(function thistype.triggerConditionBringGold))

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

			/*
			 * When the building is upgraded the spell book abilities are lost.
			 * Therefore they have to be readded manually.
			 */
			set thistype.m_upgradeTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_upgradeTrigger, EVENT_PLAYER_UNIT_UPGRADE_FINISH)
			call TriggerAddCondition(thistype.m_upgradeTrigger, Condition(function thistype.triggerConditionUpgrade))
		endmethod
	endstruct

endlibrary