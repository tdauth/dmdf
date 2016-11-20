library StructMapMapArena requires Asl, StructGameClasses, StructGameGame, StructMapQuestsQuestArenaChampion

	/**
	 * \brief The arena allows two players to fight each other.
	 * One can either fight against a computer controlled enemy or against a human controlled enemy.
	 */
	struct Arena
		/**
		 * For every kill a player gets this reward of gold.
		 */
		public static constant integer rewardGoldPerLevel = 2
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
		private static integer array m_playerScore[12] /// \todo \ref MapSettings.maxPlayers()
		private static integer m_level = 0
		private static unit m_winner
		private static region m_region
		private static trigger m_killTrigger
		private static trigger m_leaveTrigger
		private static trigger m_pvpTrigger
		/**
		 * Use a damage detection trigger to punish units from outside helping one player.
		 */
		private static trigger m_damageTrigger
		private static leaderboard m_leaderboard
		private static trigger m_sellTrigger
		private static unit m_franziska
		private static unit m_valentin
		private static unit m_anne
		private static unit m_hartwig
		private static unit m_leonard

		//! runtextmacro optional A_STRUCT_DEBUG("\"Arena\"")

		public static method isFree takes nothing returns boolean
			debug call Print("Units size is " + I2S(thistype.m_units.size()))
			return thistype.m_units.size() < thistype.maxUnits
		endmethod

		public static method addUnit takes unit usedUnit returns nothing
			local player owner = GetOwningPlayer(usedUnit)
			local integer i
			local string title
			call thistype.m_units.pushBack(usedUnit)
			call SetUnitX(usedUnit, thistype.m_startX[thistype.m_units.backIndex()])
			call SetUnitY(usedUnit, thistype.m_startY[thistype.m_units.backIndex()])
			call SetUnitFacing(usedUnit, thistype.m_startFacing[thistype.m_units.backIndex()])
			call IssueImmediateOrder(usedUnit, "stop") // prevent the unit from walking out of the arena
			debug call Print("Stoping " + GetUnitName(usedUnit))
			call SetUnitInvulnerable(usedUnit, true)
			call PauseUnit(usedUnit, true)

			if (Character.getCharacterByUnit(usedUnit) != 0) then
				set title = GetPlayerName(owner)
			else
				set title = GetUnitName(usedUnit)
			endif

			if (not Character.isUnitCharacter(usedUnit) and GetOwningPlayer(usedUnit) == MapData.arenaPlayer) then
				set thistype.m_level = GetUnitLevel(usedUnit)
			endif

			call LeaderboardAddItemBJ(owner, thistype.m_leaderboard, title + ":", thistype.playerScore(owner))
			if (Character.getCharacterByUnit(usedUnit) == 0 and owner != MapData.arenaPlayer) then
				call SetUnitOwner(usedUnit, MapData.arenaPlayer, true)
			elseif (Character.getCharacterByUnit(usedUnit) != 0) then
				call PanCameraToForPlayer(owner, GetUnitX(usedUnit), GetUnitY(usedUnit))
				call ShowLeaderboardForPlayer(owner, thistype.m_leaderboard, true)
			endif
			if (thistype.m_units.size() == thistype.maxUnits) then
				call thistype.startFight()
			endif

			call SetPlayerAllianceStateBJ(owner, MapData.arenaPlayer, bj_ALLIANCE_UNALLIED)
			call SetPlayerAllianceStateBJ(MapData.arenaPlayer, owner, bj_ALLIANCE_UNALLIED)

			set i = 0
			loop
				exitwhen (i == thistype.m_units.size())
				if (Character.getCharacterByUnit(thistype.m_units[i]) != 0 and thistype.m_units[i] != usedUnit and GetOwningPlayer(thistype.m_units[i]) != owner) then
					call SetPlayerAllianceStateBJ(owner, GetOwningPlayer(thistype.m_units[i]), bj_ALLIANCE_UNALLIED)
					call SetPlayerAllianceStateBJ(GetOwningPlayer(thistype.m_units[i]), owner, bj_ALLIANCE_UNALLIED)
				endif
				set i = i + 1
			endloop

			set owner = null
		endmethod

		public static method addCharacter takes ACharacter character returns nothing
			call thistype.addUnit(character.unit())
			// auto select character, ready for the fight
			call SelectUnitForPlayerSingle(character.unit(), character.player())
			call character.displayMessage(ACharacter.messageTypeInfo, thistype.m_textEnter)
		endmethod

		/**
		 * Hides the revival timer of a character. This is required since the revival is triggered automatically when the character dies.
		 */
		private static method timerFunctionHideRevival takes nothing returns nothing
			local Character character = Character(DmdfHashTable.global().handleInteger(GetExpiredTimer(), 0))
			if (not IsUnitDeadBJ(character.unit())) then
				if (character.revival() != 0) then
					call character.revival().end()
				endif
			endif
			call PauseTimer(GetExpiredTimer())
			call DmdfHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod

		private static method showOpponentByUnitTypeId takes integer unitTypeId, boolean show returns nothing
			if (unitTypeId == GetUnitTypeId(thistype.m_franziska)) then
				call ShowUnit(thistype.m_franziska, show)
			elseif (unitTypeId == GetUnitTypeId(thistype.m_valentin)) then
				call ShowUnit(thistype.m_valentin, show)
			elseif (unitTypeId == GetUnitTypeId(thistype.m_anne)) then
				call ShowUnit(thistype.m_anne, show)
			elseif (unitTypeId == GetUnitTypeId(thistype.m_hartwig)) then
				call ShowUnit(thistype.m_hartwig, show)
			elseif (unitTypeId == GetUnitTypeId(thistype.m_leonard)) then
				call ShowUnit(thistype.m_leonard, show)
			endif
		endmethod

		/**
		 * Removes the unit from the arena with index \p index.
		 * Removing the unit from the arena removes the leaderboard item and revives the unit immediately if it is a character.
		 * It also stops the character. Otherwise he will continue fighting.
		 * It hides the leaderboard from the player if the unit is a character.
		 * Normal units are simply removed.
		 */
		public static method removeUnitByIndex takes integer index returns nothing
			local unit usedUnit = thistype.m_units[index]
			local player owner = GetOwningPlayer(usedUnit)
			local integer i = 0
			local timer whichTimer = null
			local Character character = Character(ACharacter.getCharacterByUnit(usedUnit))
			call thistype.m_units.erase(index)
			call LeaderboardRemoveItem(thistype.m_leaderboard, index)
			if (character != 0) then
				if (IsUnitDeadBJ(usedUnit)) then
					call ReviveHero(usedUnit, thistype.m_outsideX, thistype.m_outsideY, true)
				else
					call SetUnitX(usedUnit, thistype.m_outsideX)
					call SetUnitY(usedUnit, thistype.m_outsideY)
				endif

				call SetUnitFacing(usedUnit, thistype.m_outsideFacing)
				call SetUnitInvulnerable(usedUnit, false)
				call PauseUnit(usedUnit, false)
				call IssueImmediateOrder(usedUnit, "stop")
				// refresh everything
				call SetUnitState(usedUnit, UNIT_STATE_LIFE, GetUnitState(usedUnit, UNIT_STATE_MAX_LIFE))
				call SetUnitState(usedUnit, UNIT_STATE_MANA, GetUnitState(usedUnit, UNIT_STATE_MAX_MANA))

				call PanCameraToForPlayer(owner, GetUnitX(usedUnit), GetUnitY(usedUnit))
				call ShowLeaderboardForPlayer(owner, thistype.m_leaderboard, false)
				// remove player item to make sure the leaderboard is not restored after cinematics
				// remove item after hiding since hiding sets the leaderboard of the player
				call LeaderboardRemovePlayerItemBJ(owner, thistype.m_leaderboard)
				// fixes cinematic display of a leaderboard
				call PlayerSetLeaderboard(owner, null)

				/*
				 * Since only one character can be in the arena of a player the alliances can be reset safely.
				 */
				set i = 0
				loop
					exitwhen (i == MapSettings.maxPlayers())
					if (i != GetPlayerId(owner)) then
						if (GetPlayerController(owner) == MAP_CONTROL_COMPUTER or GetPlayerController(Player(i)) == MAP_CONTROL_COMPUTER) then
							call SetPlayerAllianceStateBJ(owner, Player(i), bj_ALLIANCE_ALLIED_ADVUNITS)
							call SetPlayerAllianceStateBJ(Player(i), owner, bj_ALLIANCE_ALLIED_ADVUNITS)
						else
							call SetPlayerAllianceStateBJ(owner, Player(i), bj_ALLIANCE_ALLIED_VISION)
							call SetPlayerAllianceStateBJ(Player(i), owner, bj_ALLIANCE_ALLIED_VISION)
						endif
					endif
					set i = i + 1
				endloop

				// removes the resources multiboard of shared vision with advanced units
				call character.showCharactersSchemeToPlayer()

				// triggered before revival starts, therefore a 0 timer has to be used
				set whichTimer = CreateTimer()
				call DmdfHashTable.global().setHandleInteger(whichTimer, 0, character)
				call TimerStart(whichTimer, 0.0, false, function thistype.timerFunctionHideRevival)
			// remove newly created NPC units
			else
				call thistype.showOpponentByUnitTypeId(GetUnitTypeId(usedUnit), true)

				// otherwise show the death animation
				if (not IsUnitDeadBJ(usedUnit)) then
					call RemoveUnit(usedUnit)
				endif
			endif


			call SetPlayerAllianceStateBJ(owner, MapData.arenaPlayer, bj_ALLIANCE_ALLIED)
			call SetPlayerAllianceStateBJ(MapData.arenaPlayer, owner, bj_ALLIANCE_ALLIED)

			set usedUnit = null
			set owner = null
		endmethod

		/**
		 * Removes unit \p usedUnit from the arena.
		 * Nothing happens if the unit is not in the arena.
		 */
		public static method removeUnit takes unit usedUnit returns nothing
			local integer index = thistype.m_units.find(usedUnit)
			if (index == -1) then
				return
			endif
			call thistype.removeUnitByIndex(index)
		endmethod

		public static method removeCharacter takes ACharacter character returns nothing
			call thistype.removeUnit(character.unit())
			call character.displayMessage(ACharacter.messageTypeInfo, thistype.m_textLeave)
		endmethod

		private static method destroyDamageTrigger takes nothing returns nothing
			if (thistype.m_damageTrigger != null) then
				call DestroyTrigger(thistype.m_damageTrigger)
				set thistype.m_damageTrigger = null
			endif
		endmethod

		/**
		 * When ending the fight all attacking units (summoned as well) should be stopped.
		 */
		private static method stopAttacks takes nothing returns nothing
			local integer i
			local integer j
			// store all units which are still attacking the unit
			local AGroup attackingUnits = AGroup.create()
			call attackingUnits.addUnitsInRange(GetRectCenterX(gg_rct_arena_outside), GetRectCenterY(gg_rct_arena_outside), 4000.0, null)
			set i = 0
			loop
				exitwhen (i == attackingUnits.units().size())
				set j = 0
				loop
					exitwhen (j == thistype.m_units.size())
					if (GetOwningPlayer(attackingUnits.units()[i]) == GetOwningPlayer(thistype.m_units[j])) then
						debug call Print("Stop arena unit " + GetUnitName(attackingUnits.units()[i]))
						call IssueImmediateOrder(attackingUnits.units()[i], "stop")
						exitwhen (true)
					endif
					set j = j + 1
				endloop
				set i = i + 1
			endloop
			call attackingUnits.destroy()
		endmethod

		/**
		 * Ends the fight by disabling the kill and leave triggers, removes all units and displays who won.
		 */
		private static method endFight takes nothing returns nothing
			local ACharacter character = ACharacter.getCharacterByUnit(thistype.m_winner)
			local integer rewardGold = thistype.rewardGoldPerLevel * thistype.m_level
			local string winnerName
			if (character != 0) then
				set winnerName = GetPlayerName(character.player())
			else
				set winnerName = GetUnitName(thistype.m_winner)
			endif
			// pause units
			call thistype.destroyDamageTrigger()
			call DisableTrigger(thistype.m_killTrigger)
			call DisableTrigger(thistype.m_leaveTrigger)
			call thistype.stopAttacks()
			debug call Print("Units size: " + I2S(thistype.m_units.size()))
			loop
				exitwhen (thistype.m_units.empty())
				call thistype.removeUnitByIndex(thistype.m_units.backIndex())
			endloop
			call AdjustPlayerStateSimpleBJ(GetOwningPlayer(thistype.m_winner), PLAYER_STATE_RESOURCE_GOLD, rewardGold)
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, Format(thistype.m_textEndFight).s(winnerName).i(rewardGold).result())
		endmethod

		/**
		 * Checks if more than one unit is still alive.
		 * If only one unit is alive it becomes the winner and the fight is ended.
		 */
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
			call thistype.endFight()
		endmethod

		private static method triggerConditionIsFromArena takes nothing returns boolean
			return thistype.m_units.contains(GetTriggerUnit())
		endmethod

		private static method triggerActionKill takes nothing returns nothing
			local unit killer = GetKillingUnit()
			local player killerOwner
			local boolean killerIsFromArenaPlayer = false
			local integer i = 0
			loop
				exitwhen (i == thistype.m_units.size() or killerIsFromArenaPlayer)
				if (GetOwningPlayer(killer) == GetOwningPlayer(thistype.m_units[i])) then
					set killerIsFromArenaPlayer = true
				endif
				set i = i + 1
			endloop
			if (killerIsFromArenaPlayer) then
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
			set thistype.m_killTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_killTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(thistype.m_killTrigger, Condition(function thistype.triggerConditionIsFromArena))
			call TriggerAddAction(thistype.m_killTrigger, function thistype.triggerActionKill)
		endmethod

		private static method triggerActionLeave takes nothing returns nothing
			local unit triggerUnit = GetTriggerUnit()
			local ACharacter character = ACharacter.getCharacterByUnit(triggerUnit)
			local integer i
			if (character == 0) then
				// increase score for all other unit's owner
				set i = 0
				loop
					exitwhen (i == thistype.m_units.size())
					if (GetOwningPlayer(thistype.m_units[i]) != GetOwningPlayer(triggerUnit)) then
						set thistype.m_playerScore[GetPlayerId(GetOwningPlayer(thistype.m_units[i]))] = thistype.m_playerScore[GetPlayerId(GetOwningPlayer(thistype.m_units[i]))] + 1
						call LeaderboardSetItemValue(thistype.m_leaderboard, LeaderboardGetPlayerIndex(thistype.m_leaderboard, GetOwningPlayer(thistype.m_units[i])), thistype.m_playerScore[GetPlayerId(GetOwningPlayer(thistype.m_units[i]))])
						call LeaderboardSortItemsByValue(thistype.m_leaderboard, true)
					endif
					set i = i + 1
				endloop

				// remove unit
				call thistype.removeUnit(triggerUnit)
			else
				// increase score for computer player
				set thistype.m_playerScore[GetPlayerId(MapData.arenaPlayer)] = thistype.m_playerScore[GetPlayerId(MapData.arenaPlayer)] + 1
				call LeaderboardSetItemValue(thistype.m_leaderboard, LeaderboardGetPlayerIndex(thistype.m_leaderboard, MapData.arenaPlayer), thistype.m_playerScore[GetPlayerId(MapData.arenaPlayer)])
				call LeaderboardSortItemsByValue(thistype.m_leaderboard, true)

				// remove character
				call thistype.removeCharacter(character)
			endif
			set triggerUnit = null
			call thistype.checkForEndFight()
		endmethod

		private static method createLeaveTrigger takes nothing returns nothing
			set thistype.m_leaveTrigger = CreateTrigger()
			call TriggerRegisterLeaveRegion(thistype.m_leaveTrigger, thistype.m_region, null)
			call TriggerAddCondition(thistype.m_leaveTrigger, Condition(function thistype.triggerConditionIsFromArena))
			call TriggerAddAction(thistype.m_leaveTrigger, function thistype.triggerActionLeave)
			call DisableTrigger(thistype.m_leaveTrigger)
		endmethod

		private static method filterPvp takes nothing returns boolean
			return ACharacter.isUnitCharacter(GetFilterUnit())
		endmethod

		private static method triggerConditionPvp takes nothing returns boolean
			local AGroup unitsInRect
			local integer i
			local integer missing
			if (ACharacter.isUnitCharacter(GetTriggerUnit())) then
				if (thistype.isFree()) then
					set unitsInRect = AGroup.create()
					call unitsInRect.addUnitsInRect(gg_rct_arena_pvp, Filter(function thistype.filterPvp))
					call unitsInRect.units().pushBack(GetTriggerUnit())
					if (unitsInRect.units().size() >= thistype.maxUnits) then
						set i = 0
						loop
							exitwhen (i == thistype.maxUnits)
							call thistype.addCharacter(ACharacter.getCharacterByUnit(unitsInRect.units()[i]))
							set i = i + 1
						endloop
					else
						set missing = thistype.maxUnits - unitsInRect.units().size()
						call Character.displayHintToAll(Format(trpe("Es fehlt noch ein Charakter für einen PvP-Arenakampf.", "Es fehlen noch %1% Charaktere für einen PvP-Arenakampf.", "One character is missing for a PvP arena fight.", "%1% characters are missing for a PvP arena fight.", missing)).i(missing).result())
					endif
					call unitsInRect.destroy()
				else
					call Character(Character.getCharacterByUnit(GetTriggerUnit())).displayHint(tre("Die Arena ist momentan belegt.", "The arena is occupied at the moment."))
				endif
			endif

			return false
		endmethod

		private static method createPvpTrigger takes nothing returns nothing
			set thistype.m_pvpTrigger = CreateTrigger()
			call TriggerRegisterEnterRectSimple(thistype.m_pvpTrigger, gg_rct_arena_pvp)
			call TriggerAddCondition(thistype.m_pvpTrigger, Condition(function thistype.triggerConditionPvp))
		endmethod

		private static method createLeaderboard takes nothing returns nothing
			set thistype.m_leaderboard = CreateLeaderboard()
			call LeaderboardSetLabelBJ(thistype.m_leaderboard, tre("Arena:", "Arena:"))
			call LeaderboardSetStyle(thistype.m_leaderboard, true, true, true, false)
			call LeaderboardDisplay(thistype.m_leaderboard, false)
		endmethod

		private static method triggerConditionSell takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))

			if (GetSellingUnit() == Npcs.agihard() and (GetUnitTypeId(GetSoldUnit()) == 'h017' or GetUnitTypeId(GetSoldUnit()) == 'h018' or GetUnitTypeId(GetSoldUnit()) == 'h019' or GetUnitTypeId(GetSoldUnit()) == 'h01A' or GetUnitTypeId(GetSoldUnit()) == 'h00D')) then
				return true
			endif

			return false
		endmethod

		private static method timerFunctionStartArenaFight takes nothing returns nothing
			local unit soldUnit = DmdfHashTable.global().handleUnit(GetExpiredTimer(), 0)
			local Character character = ACharacter.playerCharacter(GetOwningPlayer(soldUnit))
			local unit arenaEnemy

			if (GetPlayerController(GetOwningPlayer(soldUnit)) == MAP_CONTROL_USER and character != 0 and character.isMovable() and thistype.isFree()) then
				call thistype.showOpponentByUnitTypeId(GetUnitTypeId(soldUnit), false)
				set arenaEnemy = CreateUnit(MapData.arenaPlayer, GetUnitTypeId(soldUnit), 0.0, 0.0, 0.0)
				call Arena.addUnit(arenaEnemy)
				set arenaEnemy = null
				call Arena.addCharacter(character)
			debug else
				debug call Print("No character!")
			endif

			call RemoveUnit(soldUnit)
			call PauseTimer(GetExpiredTimer())
			call DmdfHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod

		private static method triggerActionSell takes nothing returns nothing
			local timer whichTimer = CreateTimer()
			call DmdfHashTable.global().setHandleUnit(whichTimer, 0, GetSoldUnit())

			debug call Print("Trigger unit: " + GetUnitName(GetTriggerUnit()))
			debug call Print("Selling unit: " + GetUnitName(GetSellingUnit()))
			debug call Print("Buying unit " + GetUnitName(GetBuyingUnit()))
			call SetUnitInvulnerable(GetSoldUnit(), true)
			call ShowUnit(GetSoldUnit(), false)
			call PauseUnit(GetSoldUnit(), true)

			// wait since the selling unit is being paused
			call TimerStart(whichTimer, 0.0, false, function thistype.timerFunctionStartArenaFight)
		endmethod

		private static method createSellTrigger takes nothing returns nothing
			set thistype.m_sellTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(thistype.m_sellTrigger, Npcs.agihard(), EVENT_UNIT_SELL)
			call TriggerAddCondition(thistype.m_sellTrigger, Condition(function thistype.triggerConditionSell))
			call TriggerAddAction(thistype.m_sellTrigger, function thistype.triggerActionSell)
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
				exitwhen (i == MapSettings.maxPlayers())
				set thistype.m_playerScore[i] = 0
				call SetPlayerAllianceStateBJ(Player(i), MapData.arenaPlayer, bj_ALLIANCE_ALLIED)
				call SetPlayerAllianceStateBJ(MapData.arenaPlayer, Player(i), bj_ALLIANCE_ALLIED)
				set i = i + 1
			endloop
			set thistype.m_winner = null
			set thistype.m_region = CreateRegion()

			set thistype.m_damageTrigger = null
			call thistype.createKillTrigger()
			call thistype.createLeaveTrigger()
			call thistype.createPvpTrigger()
			call thistype.createLeaderboard()
			call thistype.createSellTrigger()

			set thistype.m_franziska = gg_unit_h018_0640
			call SetUnitInvulnerable(thistype.m_franziska, true)
			set thistype.m_valentin = gg_unit_h019_0642
			call SetUnitInvulnerable(thistype.m_valentin, true)
			set thistype.m_anne = gg_unit_h01A_0644
			call SetUnitInvulnerable(thistype.m_anne, true)
			set thistype.m_hartwig = gg_unit_h00D_0643
			call SetUnitInvulnerable(thistype.m_hartwig, true)
			set thistype.m_leonard = gg_unit_h017_0641
			call SetUnitInvulnerable(thistype.m_leonard, true)
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
			call DestroyTrigger(thistype.m_pvpTrigger)
			set thistype.m_pvpTrigger = null
			call DestroyLeaderboard(thistype.m_leaderboard)
			set thistype.m_leaderboard = null
			call thistype.destroyDamageTrigger()
			call DestroyTrigger(thistype.m_sellTrigger)
			set thistype.m_sellTrigger = null
		endmethod

		// static members

		/**
		 * \return Returns the score of the player in the arena.
		 */
		public static method playerScore takes player user returns integer
			return thistype.m_playerScore[GetPlayerId(user)]
		endmethod

		/**
		 * \return Returns the current winner in the arena.
		 */
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

		/**
		 * As long as the damaging unit is owned by one of the owners of the arena's units everything is fine.
		 * Otherwise the damage is prevented and the interfering unit is punished by killing it.
		 */
		private static method triggerConditionDamage takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == thistype.m_units.size())
				if (GetEventDamageSource() == thistype.m_units[i] or (GetOwningPlayer(GetEventDamageSource()) == GetOwningPlayer(thistype.m_units[i]) and IsUnitType(GetEventDamageSource(), UNIT_TYPE_SUMMONED))) then
					debug call Print("Belongs to the arena or is summoned.")
					return false
				endif
				set i = i + 1
			endloop
			call Character.displayWarningToAll(Format(tre("Die Einheit %1% wurde hingerichtet weil sie sich in einen Arenakampf eingemischt hat.", "The unit %1% has been executed since it interfered in an arena fight.")).s(GetUnitName(GetEventDamageSource())).result())
			call KillUnit(GetEventDamageSource())
			call SetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE, GetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE) + GetEventDamage())

			// TODO if the unit belonged to one of the owners let him lose!

			return false
		endmethod

		private static method refreshDamageTrigger takes nothing returns nothing
			local integer i = 0
			call thistype.destroyDamageTrigger()
			set thistype.m_damageTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == thistype.m_units.size())
				call TriggerRegisterUnitEvent(thistype.m_damageTrigger, thistype.m_units[i], EVENT_UNIT_DAMAGED)
				set i = i + 1
			endloop
			call TriggerAddCondition(thistype.m_damageTrigger, Condition(function thistype.triggerConditionDamage))
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
			call thistype.refreshDamageTrigger()
			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, thistype.m_textStartFight)
		endmethod

		/**
		 * @todo Fix unit types.
		 * h00D is level 6 enemy.
		 */
		public static method getRandomEnemy takes ACharacter character returns unit
			if (Classes.isChaplain(character.class())) then
				return CreateUnit(MapData.arenaPlayer, 'h019', 0.0, 0.0, 0.0)
			elseif (Classes.isMage(character.class())) then
				if (character.level() < 6) then
					return CreateUnit(MapData.arenaPlayer, 'h018', 0.0, 0.0, 0.0)
				else
					return CreateUnit(MapData.arenaPlayer, 'h01A', 0.0, 0.0, 0.0)
				endif
			elseif (Classes.isWarrior(character.class())) then
				if (character.level() < 6) then
					return CreateUnit(MapData.arenaPlayer, 'h017', 0.0, 0.0, 0.0)
				else
					return CreateUnit(MapData.arenaPlayer, 'h00D', 0.0, 0.0, 0.0)
				endif
			endif
			return null
		endmethod
	endstruct

endlibrary