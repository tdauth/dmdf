library StructMapMapAos requires Asl, StructGameCharacter, StructMapMapMapData, StructMapMapShrines

	struct Aos
		private static constant real spawnTime = 30.0
		private static player m_haldarsUser
		private static player m_baldarsUser
		private static integer m_haldarMembers
		private static integer m_baldarMembers
		private static boolean array m_playerHasJoinedHaldar[6] /// \todo \ref MapData.maxPlayers
		private static boolean array m_playerHasJoinedBaldar[6] /// \todo \ref MapData.maxPlayers
		private static integer array m_playerScore[6] /// \todo \ref MapData.maxPlayers
		private static leaderboard m_leaderboard
		private static trigger m_enterTrigger
		private static trigger m_leaveTrigger
		private static timer m_spawnTimer
		private static trigger m_scoreTrigger
		private static boolean m_characterHasEntered

		//! runtextmacro optional A_STRUCT_DEBUG("\"Aos\"")

		public static method continueSpawn takes nothing returns nothing
			call PauseTimerBJ(false, thistype.m_spawnTimer)
		endmethod

		public static method pauseSpawn takes nothing returns nothing
			call PauseTimerBJ(true, thistype.m_spawnTimer)
		endmethod

		public static method characterJoins takes Character character returns nothing
			local player user = character.player()
			call PlayMusic("Music\\TheDrumCave.mp3") /// @todo for user
			call MapData.setCameraBoundsToAosForPlayer.evaluate(user)
			call SetUnitToRandomPointOnRect(character.unit(), gg_rct_aos_no_team_start)
			call character.setFacing(180.0)
			call character.setCamera()
			call character.setMovable(true)
			call Shrines.aosShrineNeutral().enableForCharacter(character, false)
			if (not thistype.m_characterHasEntered) then
				set thistype.m_characterHasEntered = true
				/// @todo Play video The Vision.
				// black legion workers
				call IssueTargetOrder(gg_unit_u001_0190, "harvest", gg_dest_B00D_2651)
				call IssueTargetOrder(gg_unit_u001_0191, "harvest", gg_dest_B00D_8151)
				call IssueTargetOrder(gg_unit_u001_0192, "harvest", gg_dest_B00D_2623)
				call thistype.continueSpawn()
			endif
			set user = null
		endmethod

		public static method characterLeaves takes Character character returns nothing
			local player user = character.player()
			call StopMusic(false) /// @todo for user
			call MapData.setCameraBoundsToPlayableAreaForPlayer.evaluate(user) // set camera bounds before rect!
			call character.setRect(gg_rct_aos_outside)
			call character.setFacing(270.0)
			call character.setCamera()
			call character.setMovable(true)
			call Shrines.aosShrineOutside().enableForCharacter(character, false)
			set user = null
		endmethod

		public static method characterJoinsHaldar takes Character character returns nothing
			local player user
			call character.setRect(gg_rct_haldar_start)
			call character.setFacing(270.0)
			call character.panCameraSmart()
			call character.displayMessage(ACharacter.messageTypeInfo, tr("Sie sind Haldars Truppe beigetreten."))
			call character.displayMessageToAllOthers(ACharacter.messageTypeInfo, StringArg("%s ist Haldars Truppe beigetreten.", character.name()))
			set user = character.player()
			call Shrines.aosShrineHaldar().enableForCharacter(character, false)
			set thistype.m_playerHasJoinedHaldar[GetPlayerId(user)] = true
			set thistype.m_haldarMembers = thistype.m_haldarMembers + 1
			call SetPlayerAllianceStateBJ(thistype.m_haldarsUser, user, bj_ALLIANCE_ALLIED_VISION)
			call SetPlayerAllianceStateBJ(thistype.m_baldarsUser, user, bj_ALLIANCE_UNALLIED)
			call SetPlayerAllianceStateBJ(user, thistype.m_haldarsUser, bj_ALLIANCE_ALLIED)
			call SetPlayerAllianceStateBJ(user, thistype.m_baldarsUser, bj_ALLIANCE_UNALLIED)
			call LeaderboardAddItemBJ(user, thistype.m_leaderboard, character.name(), thistype.m_playerScore[GetPlayerId(user)])
			call ShowLeaderboardForPlayer(user, thistype.m_leaderboard, true)
			call character.setIsInPvp(true)
			set user = null
		endmethod

		public static method characterLeavesHaldar takes Character character returns nothing
			local player user = character.player()
			call character.displayMessageToAllOthers(ACharacter.messageTypeInfo, StringArg(tr("%s hat das Schlachtfeld und somit Haldars Truppe verlassen."), character.name()))
			set thistype.m_playerHasJoinedHaldar[GetPlayerId(user)] = false
			set thistype.m_haldarMembers = thistype.m_haldarMembers - 1
			call ShowLeaderboardForPlayer(user, thistype.m_leaderboard, false)
			call LeaderboardRemovePlayerItem(thistype.m_leaderboard, user)
			call SetPlayerAllianceStateBJ(thistype.m_haldarsUser, user, bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(thistype.m_baldarsUser, user, bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(user, thistype.m_haldarsUser, bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(user, thistype.m_baldarsUser, bj_ALLIANCE_NEUTRAL)
			call character.setIsInPvp(false)
			set user = null
		endmethod

		public static method characterJoinsBaldar takes Character character returns nothing
			local player user
			call character.setRect(gg_rct_baldar_start)
			call character.setFacing(90.0)
			call character.panCameraSmart()
			call character.displayMessage(ACharacter.messageTypeInfo, tr("Sie sind Baldars Truppe beigetreten."))
			call character.displayMessageToAllOthers(ACharacter.messageTypeInfo, StringArg(tr("%s ist Baldars Truppe beigetreten."), character.name()))
			set user = character.player()
			call Shrines.aosShrineBaldar().enableForCharacter(character, false)
			set thistype.m_playerHasJoinedBaldar[GetPlayerId(user)] = true
			set thistype.m_baldarMembers = thistype.m_baldarMembers + 1
			call SetPlayerAllianceStateBJ(thistype.m_haldarsUser, user, bj_ALLIANCE_UNALLIED)
			call SetPlayerAllianceStateBJ(thistype.m_baldarsUser, user, bj_ALLIANCE_ALLIED_VISION)
			call SetPlayerAllianceStateBJ(user, thistype.m_haldarsUser, bj_ALLIANCE_UNALLIED)
			call SetPlayerAllianceStateBJ(user, thistype.m_baldarsUser, bj_ALLIANCE_ALLIED)
			call LeaderboardAddItemBJ(user, thistype.m_leaderboard, character.name(), thistype.m_playerScore[GetPlayerId(user)])
			call ShowLeaderboardForPlayer(user, thistype.m_leaderboard, true)
			call character.setIsInPvp(true)
			set user = null
		endmethod

		public static method characterLeavesBaldar takes Character character returns nothing
			local player user = character.player()
			call character.displayMessageToAllOthers(ACharacter.messageTypeInfo, StringArg(tr("%s hat das Schlachtfeld und somit Baldars Truppe verlassen."), character.name()))
			set thistype.m_playerHasJoinedBaldar[GetPlayerId(user)] = false
			set thistype.m_baldarMembers = thistype.m_baldarMembers - 1
			call ShowLeaderboardForPlayer(user, thistype.m_leaderboard, false)
			call LeaderboardRemovePlayerItem(thistype.m_leaderboard, user)
			call SetPlayerAllianceStateBJ(thistype.m_haldarsUser, user, bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(thistype.m_baldarsUser, user, bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(user, thistype.m_haldarsUser, bj_ALLIANCE_NEUTRAL)
			call SetPlayerAllianceStateBJ(user, thistype.m_baldarsUser, bj_ALLIANCE_NEUTRAL)
			call character.setIsInPvp(false)
			set user = null
		endmethod

		public static method baldarContainsCharacter takes Character character returns boolean
			local player user = character.player()
			local boolean result = thistype.m_playerHasJoinedBaldar[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		public static method haldarContainsCharacter takes Character character returns boolean
			local player user = character.player()
			local boolean result = thistype.m_playerHasJoinedHaldar[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		public static method teamContainsCharacter takes Character character returns boolean
			local player user = character.player()
			local boolean result = thistype.m_playerHasJoinedHaldar[GetPlayerId(user)] or thistype.m_playerHasJoinedBaldar[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		public static method areaContainsCharacter takes Character character returns boolean
			return RectContainsUnit(gg_rct_area_aos, character.unit())
		endmethod

		private static method createLeaderboard takes nothing returns nothing
			//local integer i
			//local player user
			set thistype.m_leaderboard = CreateLeaderboard()
			call LeaderboardSetLabel(thistype.m_leaderboard, tr("Schlachtfeld-Rangliste:"))
			call LeaderboardSetStyle(thistype.m_leaderboard, true, true, true, true)
			//Usually not required because ShowLeaderboardForPlayer does the same work.
			//set i = 0
			//loop
				//exitwhen (i == MapData.maxPlayers)
				//set user = Player(i)
				//if (IsPlayerPlayingUser(user)) then
					//call PlayerSetLeaderboard(user, Aos.leaderBoard)
				//endif
				//set user = null
				//set i = i + 1
			//endloop
			call LeaderboardDisplay(thistype.m_leaderboard, false)
		endmethod

		private static method triggerConditionEnter takes nothing returns boolean
			local unit triggerUnit = GetTriggerUnit()
			local boolean result = ACharacter.isUnitCharacter(triggerUnit)
			set triggerUnit = null
			return result
		endmethod

		private static method dialogButtonActionEnterYes takes ADialogButton dialogButton returns nothing
			local player user = dialogButton.dialog().player()
			call thistype.characterJoins(ACharacter.playerCharacter(user))
			set user = null
		endmethod

		private static method dialogButtonActionEnterNo takes ADialogButton dialogButton returns nothing
			local player user = dialogButton.dialog().player()
			call ACharacter.playerCharacter(user).setMovable(true)
			set user = null
		endmethod

		private static method triggerActionEnter takes nothing returns nothing
			local unit triggerUnit = GetTriggerUnit()
			local Character character = ACharacter.getCharacterByUnit(triggerUnit)
			local player user = character.player()
			call character.setMovable(false)
			call AGui.playerGui(user).dialog().clear()
			call AGui.playerGui(user).dialog().setMessage(tr("Möchten Sie die Höhle betreten?"))
			call AGui.playerGui(user).dialog().addDialogButton(tr("Ja"), 'J', thistype.dialogButtonActionEnterYes)
			call AGui.playerGui(user).dialog().addDialogButton(tr("Nein"), 'N', thistype.dialogButtonActionEnterNo)
			call AGui.playerGui(user).dialog().show()
			set triggerUnit = null
			set user = null
		endmethod

		private static method createEnterTrigger takes nothing returns nothing
			local event triggerEvent
			local conditionfunc conditionFunction
			local triggercondition triggerCondition
			local triggeraction triggerAction
			set thistype.m_enterTrigger = CreateTrigger()
			set triggerEvent = TriggerRegisterEnterRectSimple(thistype.m_enterTrigger, gg_rct_aos_enter)
			set conditionFunction = Condition(function thistype.triggerConditionEnter)
			set triggerCondition = TriggerAddCondition(thistype.m_enterTrigger, conditionFunction)
			set triggerAction = TriggerAddAction(thistype.m_enterTrigger, function thistype.triggerActionEnter)
			set triggerEvent = null
			set conditionFunction = null
			set triggerCondition = null
			set triggerAction = null
		endmethod

		private static method dialogButtonActionLeaveYes takes ADialogButton dialogButton returns nothing
			local player user = dialogButton.dialog().player()
			call thistype.characterLeaves(ACharacter.playerCharacter(user))
			set user = null
		endmethod

		private static method dialogButtonActionLeaveNo takes ADialogButton dialogButton returns nothing
			local player user = dialogButton.dialog().player()
			call ACharacter.playerCharacter(user).setMovable(true)
			set user = null
		endmethod

		private static method triggerConditionLeave takes nothing returns boolean
			local unit triggerUnit = GetTriggerUnit()
			local Character character = ACharacter.getCharacterByUnit(triggerUnit)
			local boolean result = false
			if (character != 0) then
				set result = not thistype.teamContainsCharacter(character)
				if (not result) then
					call character.displayMessage(ACharacter.messageTypeError, tr("Sie müssen sich zurückverwandeln, bevor Sie die Höhle verlassen."))
				endif
			endif
			set triggerUnit = null
			return result
		endmethod

		private static method triggerActionLeave takes nothing returns nothing
			local unit triggerUnit = GetTriggerUnit()
			local Character character = ACharacter.getCharacterByUnit(triggerUnit)
			local player user = character.player()
			call character.setMovable(false)
			call AGui.playerGui(user).dialog().clear()
			call AGui.playerGui(user).dialog().setMessage(tr("Möchten Sie die Höhle verlassen?"))
			call AGui.playerGui(user).dialog().addDialogButton(tr("Ja"), 'J', thistype.dialogButtonActionLeaveYes)
			call AGui.playerGui(user).dialog().addDialogButton(tr("Nein"), 'N', thistype.dialogButtonActionLeaveNo)
			call AGui.playerGui(user).dialog().show()
			set triggerUnit = null
			set user = null
		endmethod

		private static method createLeaveTrigger takes nothing returns nothing
			local event triggerEvent
			local conditionfunc conditionFunction
			local triggercondition triggerCondition
			local triggeraction triggerAction
			set thistype.m_leaveTrigger = CreateTrigger()
			set triggerEvent = TriggerRegisterEnterRectSimple(thistype.m_leaveTrigger, gg_rct_aos_leave)
			set conditionFunction = Condition(function thistype.triggerConditionLeave)
			set triggerCondition = TriggerAddCondition(thistype.m_leaveTrigger, conditionFunction)
			set triggerAction = TriggerAddAction(thistype.m_leaveTrigger, function thistype.triggerActionLeave)
			set triggerEvent = null
			set conditionFunction = null
			set triggerCondition = null
			set triggerAction = null
		endmethod

		private static method timerFunctionSpawn takes nothing returns nothing
			local effect createdEffect
			local group haldarsGroup0 = CreateGroup()
			local group haldarsGroup1 = CreateGroup()
			local group baldarsGroup0 = CreateGroup()
			local group baldarsGroup1 = CreateGroup()
			local unit createdUnit
			// Haldar
			if (not IsUnitPaused(gg_unit_n00K_0040)) then
				call SetUnitAnimation(gg_unit_n00K_0040, "Spell Slam")
				call ResetUnitAnimation(gg_unit_n00K_0040)
				set createdEffect = AddSpecialEffect("Models\\Effects\\TeleportationZaubernder.mdx", GetUnitX(gg_unit_n00K_0040), GetUnitY(gg_unit_n00K_0040))
				call DestroyEffect(createdEffect)
				set createdEffect = null
			endif
			set createdEffect = AddSpecialEffect("Models\\Effects\\Teleportation.mdx", GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0))
			call DestroyEffect(createdEffect)
			set createdEffect = null
			set createdEffect = AddSpecialEffect("Models\\Effects\\Teleportation.mdx", GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1))
			call DestroyEffect(createdEffect)
			set createdEffect = null
			// the white legion - group 0
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n029', GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n028', GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n028', GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n027', GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n027', GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n026', GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0), 270.0)
			call GroupAddUnit(baldarsGroup0, createdUnit)
			set createdUnit = null
			// the white legion - group 1
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n029', GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n028', GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n028', GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n027', GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n027', GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_haldarsUser, 'n00M', GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1), 270.0)
			call GroupAddUnit(haldarsGroup0, createdUnit)
			set createdUnit = null
			// move
			call GroupPointOrder(haldarsGroup0, "patrol", GetRectCenterX(gg_rct_baldar_spawn_point_0), GetRectCenterY(gg_rct_baldar_spawn_point_0))
			call GroupPointOrder(haldarsGroup1, "patrol", GetRectCenterX(gg_rct_baldar_spawn_point_1), GetRectCenterY(gg_rct_baldar_spawn_point_1))
			// baldar
			if (not IsUnitPaused(gg_unit_n00L_0026)) then
				call SetUnitAnimation(gg_unit_n00L_0026, "Spell Slam")
				call ResetUnitAnimation(gg_unit_n00L_0026)
				set createdEffect = AddSpecialEffect("Models\\Effects\\TeleportationZaubernder.mdx", GetUnitX(gg_unit_n00L_0026), GetUnitY(gg_unit_n00L_0026))
				call DestroyEffect(createdEffect)
				set createdEffect = null
			endif
			set createdEffect = AddSpecialEffect("Models\\Effects\\Teleportation.mdx", GetRectCenterX(gg_rct_baldar_spawn_point_0), GetRectCenterY(gg_rct_baldar_spawn_point_0))
			call DestroyEffect(createdEffect)
			set createdEffect = null
			set createdEffect = AddSpecialEffect("Models\\Effects\\Teleportation.mdx", GetRectCenterX(gg_rct_baldar_spawn_point_1), GetRectCenterY(gg_rct_baldar_spawn_point_1))
			call DestroyEffect(createdEffect)
			set createdEffect = null
			// the black legion - group 0
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00G', GetRectCenterX(gg_rct_baldar_spawn_point_0), GetRectCenterY(gg_rct_baldar_spawn_point_0), 90.0)
			call GroupAddUnit(baldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00I', GetRectCenterX(gg_rct_baldar_spawn_point_0), GetRectCenterY(gg_rct_baldar_spawn_point_0), 90.0)
			call GroupAddUnit(baldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00I', GetRectCenterX(gg_rct_baldar_spawn_point_0), GetRectCenterY(gg_rct_baldar_spawn_point_0), 90.0)
			call GroupAddUnit(baldarsGroup0, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00I', GetRectCenterX(gg_rct_baldar_spawn_point_0), GetRectCenterY(gg_rct_baldar_spawn_point_0), 90.0)
			call GroupAddUnit(baldarsGroup0, createdUnit)
			set createdUnit = null
			// the black legion - group 1
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00J', GetRectCenterX(gg_rct_baldar_spawn_point_1), GetRectCenterY(gg_rct_baldar_spawn_point_1), 90.0)
			call GroupAddUnit(baldarsGroup1, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00I', GetRectCenterX(gg_rct_baldar_spawn_point_1), GetRectCenterY(gg_rct_baldar_spawn_point_1), 90.0)
			call GroupAddUnit(baldarsGroup1, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00I', GetRectCenterX(gg_rct_baldar_spawn_point_1), GetRectCenterY(gg_rct_baldar_spawn_point_1), 90.0)
			call GroupAddUnit(baldarsGroup1, createdUnit)
			set createdUnit = null
			set createdUnit = CreateUnit(thistype.m_baldarsUser, 'n00I', GetRectCenterX(gg_rct_baldar_spawn_point_1), GetRectCenterY(gg_rct_baldar_spawn_point_1), 90.0)
			call GroupAddUnit(baldarsGroup1, createdUnit)
			set createdUnit = null
			// move
			call GroupPointOrder(baldarsGroup0, "patrol", GetRectCenterX(gg_rct_haldar_spawn_point_0), GetRectCenterY(gg_rct_haldar_spawn_point_0))
			call GroupPointOrder(baldarsGroup1, "patrol", GetRectCenterX(gg_rct_haldar_spawn_point_1), GetRectCenterY(gg_rct_haldar_spawn_point_1))

			call DestroyGroup(haldarsGroup0)
			set haldarsGroup0 = null
			call DestroyGroup(haldarsGroup1)
			set haldarsGroup1 = null
			call DestroyGroup(baldarsGroup0)
			set baldarsGroup0 = null
			call DestroyGroup(baldarsGroup1)
			set baldarsGroup1 = null
		endmethod

		private static method createSpawnTimer takes nothing returns nothing
			set thistype.m_spawnTimer = CreateTimer()
			call TimerStart(thistype.m_spawnTimer, thistype.spawnTime, true, function thistype.timerFunctionSpawn)
			call thistype.pauseSpawn()
		endmethod

		/// All player units can score (for example summoned units).
		private static method triggerConditionScore takes nothing returns boolean
			local unit triggerUnit = GetTriggerUnit()
			local unit killingUnit = GetKillingUnit()
			local player triggerOwner = GetOwningPlayer(triggerUnit)
			local player killingOwner = GetOwningPlayer(killingUnit)
			local boolean result  = true
			if (not thistype.teamContainsCharacter(ACharacter.playerCharacter(killingOwner))) then
				set result = false
			elseif (thistype.m_playerHasJoinedHaldar[GetPlayerId(killingOwner)] and triggerOwner != thistype.m_baldarsUser) then
				set result = false
			elseif (thistype.m_playerHasJoinedBaldar[GetPlayerId(killingOwner)] and triggerOwner != thistype.m_haldarsUser) then
				set result = false
			endif
			set triggerUnit = null
			set killingUnit = null
			set triggerOwner = null
			set killingOwner = null
			return result
		endmethod

		private static method triggerActionScore takes nothing returns nothing
			local unit killingUnit = GetKillingUnit()
			local player killingOwner = GetOwningPlayer(killingUnit)
			set thistype.m_playerScore[GetPlayerId(killingOwner)] = thistype.m_playerScore[GetPlayerId(killingOwner)] + 1
			call LeaderboardSetPlayerItemValueBJ(killingOwner, thistype.m_leaderboard, thistype.m_playerScore[GetPlayerId(killingOwner)])
			call LeaderboardSortItemsByValue(thistype.m_leaderboard, false)
			set killingUnit = null
			set killingOwner = null
		endmethod

		private static method createScoreTrigger takes nothing returns nothing
			local conditionfunc conditionFunction
			local triggercondition triggerCondition
			local triggeraction triggerAction
			set thistype.m_scoreTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_scoreTrigger, EVENT_PLAYER_UNIT_DEATH)
			set conditionFunction = Condition(function thistype.triggerConditionScore)
			set triggerCondition = TriggerAddCondition(thistype.m_scoreTrigger, conditionFunction)
			set triggerAction = TriggerAddAction(thistype.m_scoreTrigger, function thistype.triggerActionScore)
			set conditionFunction = null
			set triggerCondition = null
			set triggerAction = null
		endmethod

		private static method initStartUnits takes nothing returns nothing
			//haldars camp
			//baldars camp
			//call SetUnitOwner(gg_unit_h00B_0200, thistype.m_baldarsUser, true)
			call SetUnitOwner(gg_unit_h00B_0005, thistype.m_baldarsUser, true)
			call SetUnitOwner(gg_unit_h00B_0023, thistype.m_baldarsUser, true)
			call SetUnitOwner(gg_unit_h00B_0024, thistype.m_baldarsUser, true)
			call SetUnitOwner(gg_unit_h00B_0025, thistype.m_baldarsUser, true)
			//call SetUnitOwner(gg_unit_u000_0010, thistype.m_baldarsUser, true) // Lager
			call SetUnitOwner(gg_unit_u001_0190, thistype.m_baldarsUser, true) // worker
			call SetUnitOwner(gg_unit_u001_0191, thistype.m_baldarsUser, true) // worker
			call SetUnitOwner(gg_unit_u001_0192, thistype.m_baldarsUser, true) // worker
			call SetUnitOwner(gg_unit_n00F_0018, thistype.m_baldarsUser, true) // Quelle
			call SetUnitInvulnerable(gg_unit_n00J_0021, true)
		endmethod

		public static method init takes nothing returns nothing
			local integer i
			local player user
			set thistype.m_haldarsUser = Player(bj_PLAYER_NEUTRAL_VICTIM)
			set thistype.m_baldarsUser = Player(bj_PLAYER_NEUTRAL_EXTRA)
			set thistype.m_haldarMembers = 0
			set thistype.m_baldarMembers = 0
			set thistype.m_characterHasEntered = false
			call SetPlayerFlagBJ(PLAYER_STATE_GIVES_BOUNTY, true, thistype.m_haldarsUser)
			call SetPlayerFlagBJ(PLAYER_STATE_GIVES_BOUNTY, true, thistype.m_baldarsUser)
			call SetPlayerAllianceStateBJ(thistype.m_haldarsUser, thistype.m_baldarsUser, bj_ALLIANCE_UNALLIED)
			call SetPlayerAllianceStateBJ(thistype.m_baldarsUser, thistype.m_haldarsUser, bj_ALLIANCE_UNALLIED)
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set user = Player(i)
				if (IsPlayerPlayingUser(user)) then
					call SetPlayerAllianceStateBJ(user, thistype.m_haldarsUser, bj_ALLIANCE_NEUTRAL)
					call SetPlayerAllianceStateBJ(user, thistype.m_baldarsUser, bj_ALLIANCE_NEUTRAL)
					call SetPlayerAllianceStateBJ(thistype.m_haldarsUser, user, bj_ALLIANCE_NEUTRAL)
					call SetPlayerAllianceStateBJ(thistype.m_baldarsUser, user, bj_ALLIANCE_NEUTRAL)
				endif
				set user = null
				set i = i + 1
			endloop

			call thistype.createLeaderboard()
			call thistype.createEnterTrigger()
			call thistype.createLeaveTrigger()
			call thistype.createSpawnTimer()
			call thistype.createScoreTrigger()
			call thistype.initStartUnits()
		endmethod

		private static method destroyLeaderboard takes nothing returns nothing
			call DestroyLeaderboard(thistype.m_leaderboard)
			set thistype.m_leaderboard = null
		endmethod

		private static method destroyEnterTrigger takes nothing returns nothing
			call DestroyTrigger(thistype.m_enterTrigger)
			set thistype.m_enterTrigger = null
		endmethod

		private static method destroyLeaveTrigger takes nothing returns nothing
			call DestroyTrigger(thistype.m_leaveTrigger)
			set thistype.m_leaveTrigger = null
		endmethod

		private static method destroySpawnTimer takes nothing returns nothing
			call DestroyTimer(thistype.m_spawnTimer)
			set thistype.m_spawnTimer = null
		endmethod

		private static method destroyScoreTrigger takes nothing returns nothing
			call DestroyTrigger(thistype.m_scoreTrigger)
			set thistype.m_scoreTrigger = null
		endmethod

		private static method cleanUpStartUnits takes nothing returns nothing
			//haldars camp
			//baldars camp
			call SetUnitInvulnerable(gg_unit_n00J_0021, false)
		endmethod

		public static method cleanUp takes nothing returns nothing
			set thistype.m_haldarsUser = null
			set thistype.m_baldarsUser = null
			call thistype.destroyLeaderboard()
			call thistype.destroyEnterTrigger()
			call thistype.destroyLeaveTrigger()
			call thistype.destroySpawnTimer()
			call thistype.destroyScoreTrigger()
			call thistype.cleanUpStartUnits()
		endmethod

		// static members

		public static method playerScore takes player user returns integer
			return thistype.m_playerScore[GetPlayerId(user)]
		endmethod
	endstruct

endlibrary