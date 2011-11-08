library StructMapMapArena requires Asl, StructMapMapMapData, StructMapQuestsQuestArenaChampion

	struct Arena
		private static constant integer maxUnits = 2
		// static construction members
		private static real m_outsideX
		private static real m_outsideY
		private static real m_outsideFacing
		private static string m_textEnter
		private static string m_textLeave
		private static string m_textStartFight
		private static string m_textEndFight
		// static members
		private static ARealVector m_startX
		private static ARealVector m_startY
		private static ARealVector m_startFacing
		private static AUnitVector m_units
		private static integer array m_playerScore[6] /// @todo @member MapData.maxPlayers
		private static unit m_winner
		private static region m_region
		private static trigger m_killTrigger
		private static trigger m_leaveTrigger
		private static leaderboard m_leaderboard

		//! runtextmacro optional A_STRUCT_DEBUG("\"Arena\"")

		public static method removeUnitByIndex takes integer index returns nothing
			local unit usedUnit = thistype.m_units[index]
			local player owner = GetOwningPlayer(usedUnit)
			call thistype.m_units.erase(index)
			call LeaderboardRemoveItem(thistype.m_leaderboard, index)
			if (ACharacter.getCharacterByUnit(usedUnit) != 0) then
				if (IsUnitDeadBJ(usedUnit)) then
					call ReviveHero(usedUnit, thistype.m_outsideX, thistype.m_outsideY, true)
					call SetUnitFacing(usedUnit, thistype.m_outsideFacing)
					call SetUnitInvulnerable(usedUnit, false)
					call PauseUnit(usedUnit, false)
					call IssueImmediateOrder(usedUnit, "stop")
				else
					call SetUnitX(usedUnit, thistype.m_outsideX)
					call SetUnitY(usedUnit, thistype.m_outsideY)
					call SetUnitFacing(usedUnit, thistype.m_outsideFacing)
					call SetUnitInvulnerable(usedUnit, false)
					call PauseUnit(usedUnit, false)
					call IssueImmediateOrder(usedUnit, "stop")
				endif

				call Game.setAlliedPlayerAlliedToPlayer(owner)
				call PanCameraToForPlayer(owner, GetUnitX(usedUnit), GetUnitY(usedUnit))
				call ShowLeaderboardForPlayer(owner, thistype.m_leaderboard, false)
			// remove newly created NPC units
			else
				call RemoveUnit(usedUnit)
			endif
			set usedUnit = null
			set owner = null
		endmethod

		public static method removeUnit takes unit usedUnit returns nothing
			local integer index = thistype.m_units.find(usedUnit)
			if (index == -1) then
				return
			endif
			call thistype.removeUnitByIndex(index)
		endmethod

		public static method removeCharacter takes ACharacter character returns nothing
			call thistype.removeUnit(character.unit())
			call character.revival().enable()
			call character.revival().setEnableAgain(true)
			call character.displayMessage(ACharacter.messageTypeInfo, thistype.m_textLeave)
		endmethod

		private static method checkForEndFight takes nothing returns nothing
			local integer aliveCount = 0
			local integer i = 0
			loop
				exitwhen (i == thistype.m_units.size())
				if (not IsUnitDeadBJ(thistype.m_units[i])) then
					set aliveCount = aliveCount + 1
					if (aliveCount > 1) then
						set thistype.m_winner = null
						return
					else
						set thistype.m_winner = thistype.m_units[i]
					endif
				endif
				set i = i + 1
			endloop
			call thistype.endFight.execute()
		endmethod

		private static method triggerConditionIsFromArena takes nothing returns boolean
			local unit triggerUnit = GetTriggerUnit()
			local boolean result = thistype.m_units.contains(triggerUnit)
			set triggerUnit = null
			return result
		endmethod

		private static method triggerActionKill takes nothing returns nothing
			local unit killer = GetKillingUnit()
			local player killerOwner
			local integer i
			local integer aliveCount = 0
			if (thistype.m_units.contains(killer)) then
				set killerOwner = GetOwningPlayer(killer)
				set thistype.m_playerScore[GetPlayerId(killerOwner)] = thistype.m_playerScore[GetPlayerId(killerOwner)] + 1
				if (thistype.m_playerScore[GetPlayerId(killerOwner)] == 5 and ACharacter.playerCharacter(killerOwner) != 0) then
					call QuestArenaChampion.characterQuest(ACharacter.playerCharacter(killerOwner)).questItem(0).setState(AAbstractQuest.stateCompleted)
					call QuestArenaChampion.characterQuest(ACharacter.playerCharacter(killerOwner)).questItem(1).setState(AAbstractQuest.stateNew)
					call QuestArenaChampion.characterQuest(ACharacter.playerCharacter(killerOwner)).displayUpdate()
				endif
				call LeaderboardSetItemValue(thistype.m_leaderboard, LeaderboardGetPlayerIndex(thistype.m_leaderboard, killerOwner), thistype.m_playerScore[GetPlayerId(killerOwner)])
				call LeaderboardSortItemsByValue(thistype.m_leaderboard, true)
				set killerOwner = null
			endif
			set killer = null
			call thistype.checkForEndFight()
		endmethod

		private static method createKillTrigger takes nothing returns nothing
			local conditionfunc conditionFunction
			local triggercondition triggerCondition
			local triggeraction triggerAction
			set thistype.m_killTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_killTrigger, EVENT_PLAYER_UNIT_DEATH)
			set conditionFunction = Condition(function thistype.triggerConditionIsFromArena)
			set triggerCondition = TriggerAddCondition(thistype.m_killTrigger, conditionFunction)
			set triggerAction = TriggerAddAction(thistype.m_killTrigger, function thistype.triggerActionKill)
			call DestroyCondition(conditionFunction)
			set conditionFunction = null
			set triggerCondition = null
			set triggerAction = null
		endmethod

		private static method triggerActionLeave takes nothing returns nothing
			local unit triggerUnit = GetTriggerUnit()
			local ACharacter character = ACharacter.getCharacterByUnit(triggerUnit)
			if (character == 0) then
				call thistype.removeUnit(triggerUnit)
			else
				// increase score for computer player
				set thistype.m_playerScore[GetPlayerId(MapData.alliedPlayer())] = thistype.m_playerScore[GetPlayerId(MapData.alliedPlayer())] + 1
				call LeaderboardSetItemValue(thistype.m_leaderboard, LeaderboardGetPlayerIndex(thistype.m_leaderboard, MapData.alliedPlayer()), thistype.m_playerScore[GetPlayerId(MapData.alliedPlayer())])
				call LeaderboardSortItemsByValue(thistype.m_leaderboard, true)
				call thistype.removeCharacter(character)
			endif
			set triggerUnit = null
			call thistype.checkForEndFight()
		endmethod

		private static method createLeaveTrigger takes nothing returns nothing
			local event triggerEvent
			local conditionfunc conditionFunction
			local triggercondition triggerCondition
			local triggeraction triggerAction
			set thistype.m_leaveTrigger = CreateTrigger()
			set triggerEvent = TriggerRegisterLeaveRegion(thistype.m_leaveTrigger, thistype.m_region, null)
			set conditionFunction = Condition(function thistype.triggerConditionIsFromArena)
			set triggerCondition = TriggerAddCondition(thistype.m_leaveTrigger, conditionFunction)
			set triggerAction = TriggerAddAction(thistype.m_leaveTrigger, function thistype.triggerActionLeave)
			call DisableTrigger(thistype.m_leaveTrigger)
			call DestroyCondition(conditionFunction)
			set conditionFunction = null
			set triggerCondition = null
			set triggerAction = null
		endmethod

		private static method createLeaderboard takes nothing returns nothing
			set thistype.m_leaderboard = CreateLeaderboard()
			call LeaderboardSetLabel(thistype.m_leaderboard, tr("Arena:"))
			call LeaderboardSetStyle(thistype.m_leaderboard, true, true, true, true)
			call LeaderboardDisplay(thistype.m_leaderboard, false)
		endmethod

		public static method init takes real outsideX, real outsideY, real outsideFacing, string textEnter, string textLeave, string textStartFight, string textEndFight returns nothing
			local integer i
			// static construction members
			set thistype.m_outsideX = outsideX
			set thistype.m_outsideY = outsideY
			set thistype.m_outsideFacing = outsideFacing
			set thistype.m_textEnter = textEnter
			set thistype.m_textLeave = textLeave
			set thistype.m_textStartFight = textStartFight
			set thistype.m_textEndFight = textEndFight
			// static members
			set thistype.m_startX = ARealVector.create()
			set thistype.m_startY = ARealVector.create()
			set thistype.m_startFacing = ARealVector.create()
			set thistype.m_units = AUnitVector.create()
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set thistype.m_playerScore[i] = 0
				set i = i + 1
			endloop
			set thistype.m_winner = null
			set thistype.m_region = CreateRegion()

			call thistype.createKillTrigger()
			call thistype.createLeaveTrigger()
			call thistype.createLeaderboard()
		endmethod

		public static method cleanUp takes nothing returns nothing
			// static members
			call thistype.m_startX.destroy()
			call thistype.m_startY.destroy()
			call thistype.m_startFacing.destroy()
			call thistype.m_units.destroy()
			set thistype.m_winner = null
			call RemoveRegion(thistype.m_region)
			set thistype.m_region = null
			call DestroyTrigger(thistype.m_killTrigger)
			set thistype.m_killTrigger = null
			call DestroyTrigger(thistype.m_leaveTrigger)
			set thistype.m_leaveTrigger = null
			call DestroyLeaderboard(thistype.m_leaderboard)
			set thistype.m_leaderboard = null
		endmethod

		// static members

		public static method playerScore takes player user returns integer
			return thistype.m_playerScore[GetPlayerId(user)]
		endmethod

		public static method winner takes nothing returns unit
			return thistype.m_winner
		endmethod

		// static methods

		public static method addRect takes rect usedRect returns nothing
			call RegionAddRect(thistype.m_region, usedRect)
		endmethod

		public static method addStartPoint takes real x, real y, real facing returns nothing
			debug if (thistype.m_startX.size() == thistype.maxUnits) then
				debug call thistype.staticPrint("Reached unit maximum.")
				debug return
			debug endif
			call thistype.m_startX.pushBack(x)
			call thistype.m_startY.pushBack(y)
			call thistype.m_startFacing.pushBack(facing)
		endmethod

		private static method startFight takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.m_units.size())
				call SetUnitInvulnerable(thistype.m_units[i], false)
				call PauseUnit(thistype.m_units[i], false)
				set i = i + 1
			endloop
			call EnableTrigger(thistype.m_killTrigger)
			call EnableTrigger(thistype.m_leaveTrigger)
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, thistype.m_textStartFight)
		endmethod

		public static method addUnit takes unit usedUnit returns nothing
			local player owner = GetOwningPlayer(usedUnit)
			call thistype.m_units.pushBack(usedUnit)
			call SetUnitX(usedUnit, thistype.m_startX[thistype.m_units.backIndex()])
			call SetUnitY(usedUnit, thistype.m_startY[thistype.m_units.backIndex()])
			call SetUnitFacing(usedUnit, thistype.m_startFacing[thistype.m_units.backIndex()])
			call SetUnitInvulnerable(usedUnit, true)
			call PauseUnit(usedUnit, true)
			call LeaderboardAddItemBJ(owner, thistype.m_leaderboard, GetUnitName(usedUnit) + ":", thistype.playerScore(owner))
			if (Character.getCharacterByUnit(usedUnit) == 0 and owner != MapData.alliedPlayer()) then
				call SetUnitOwner(usedUnit, MapData.alliedPlayer(), true)
			elseif (Character.getCharacterByUnit(usedUnit) != 0) then
				call Game.setAlliedPlayerUnalliedToPlayer(owner)
				call PanCameraToForPlayer(owner, GetUnitX(usedUnit), GetUnitY(usedUnit))
				call ShowLeaderboardForPlayer(owner, thistype.m_leaderboard, true)
			endif
			if (thistype.m_units.size() == thistype.maxUnits) then
				call thistype.startFight()
			endif
			set owner = null
		endmethod

		public static method addCharacter takes ACharacter character returns nothing
			call thistype.addUnit(character.unit())
			call character.revival().disable()
			call character.revival().setEnableAgain(false)
			call character.displayMessage(ACharacter.messageTypeInfo, thistype.m_textEnter)
		endmethod

		public static method isFree takes nothing returns boolean
			debug call Print("Units size is " + I2S(thistype.m_units.size()))
			return thistype.m_units.size() < thistype.maxUnits
		endmethod

		/**
		* @todo Fix unit types.
		* h00D is level 6 enemy.
		*/
		public static method getRandomEnemy takes integer level returns unit
			local integer index = GetRandomInt(0, 2)
			if (index == 0) then
				return CreateUnit(MapData.alliedPlayer(), 'h00D', 0.0, 0.0, 0.0)
			elseif (index == 1) then
				return CreateUnit(MapData.alliedPlayer(), 'h00D', 0.0, 0.0, 0.0)
			elseif (index == 2) then
				return CreateUnit(MapData.alliedPlayer(), 'h00D', 0.0, 0.0, 0.0)
			endif
			return null
		endmethod

		private static method endFight takes nothing returns nothing
			// pause units
			call DisableTrigger(thistype.m_killTrigger)
			call DisableTrigger(thistype.m_leaveTrigger)
			call TriggerSleepAction(3.0)
			loop
				exitwhen (thistype.m_units.empty())
				call thistype.removeUnitByIndex(thistype.m_units.backIndex())
			endloop
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, StringArg(thistype.m_textEndFight, GetUnitName(thistype.m_winner)))
		endmethod
	endstruct

endlibrary