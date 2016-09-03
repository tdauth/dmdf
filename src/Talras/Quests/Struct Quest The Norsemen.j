library StructMapQuestsQuestTheNorsemen requires Asl, StructMapMapFellows, StructMapMapNpcs, StructMapVideosVideoANewAlliance, StructMapVideosVideoTheChief, StructMapVideosVideoTheFirstCombat, StructMapVideosVideoWigberht

	private struct WavesDisplay
		private leaderboard m_leaderboard
		// remaining waves
		private integer m_hostileWaves
		private integer m_alliedWaves

		public method decreaseHostiles takes nothing returns nothing
			set this.m_hostileWaves = this.m_hostileWaves - 1
			call LeaderboardSetItemValue(this.m_leaderboard, 0, this.m_hostileWaves)
		endmethod

		public method decreaseAllies takes nothing returns nothing
			set this.m_alliedWaves = this.m_alliedWaves - 1
			call LeaderboardSetItemValue(this.m_leaderboard, 1, this.m_alliedWaves)
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			local integer i
			set this.m_leaderboard = CreateLeaderboard()
			set this.m_hostileWaves = QuestTheNorsemen.maxWaves - 1
			set this.m_alliedWaves = QuestTheNorsemen.maxAlliedWaves
			call LeaderboardSetLabel(this.m_leaderboard, tre("Verbleibende Wellen", "Remaining Waves"))
			call LeaderboardSetStyle(this.m_leaderboard, true, true, true, true)
			call LeaderboardAddItemBJ(Player(PLAYER_NEUTRAL_AGGRESSIVE), this.m_leaderboard, tre("Feindliche:", "Hostile:"), this.m_hostileWaves)
			// don't make it black
			call LeaderboardSetPlayerItemLabelColorBJ(Player(PLAYER_NEUTRAL_AGGRESSIVE), this.m_leaderboard, 100, 80, 20, 0)
			call LeaderboardSetPlayerItemValueColorBJ(Player(PLAYER_NEUTRAL_AGGRESSIVE), this.m_leaderboard, 100, 80, 20, 0)
			call LeaderboardAddItemBJ(MapData.alliedPlayer, this.m_leaderboard, tre("Verbündete:", "Allied:"), this.m_alliedWaves)
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call PlayerSetLeaderboard(Player(i), this.m_leaderboard)
				set i = i + 1
			endloop

			call LeaderboardDisplay(this.m_leaderboard, true)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call DestroyLeaderboard(this.m_leaderboard)
			set this.m_leaderboard = null
		endmethod
	endstruct

	struct QuestAreaTheNorsemenTheChief extends QuestArea

		public stub method onStart takes nothing returns nothing
			call QuestTheNorsemen.quest.evaluate().enableTheBattle.execute()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct

	struct QuestAreaTheNorsemenBattle extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoTheFirstCombat.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			call QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemMeetAtTheBattlefield).setState(AAbstractQuest.stateCompleted)
			call QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemFight).setState(AAbstractQuest.stateNew)
			call QuestTheNorsemen.quest.evaluate().displayState()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct

	struct QuestAreaTheNorsemenAfterTheBattle extends QuestArea

		public stub method onStart takes nothing returns nothing
			call QuestTheNorsemen.quest.evaluate().completeMeetAtTheOutpost.execute()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct

	struct QuestAreaTheNorsemenHeimrich extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoANewAlliance.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			call QuestTheNorsemen.quest.evaluate().questItem(QuestTheNorsemen.questItemReportHeimrich).setState(AAbstractQuest.stateCompleted)
			call QuestTheNorsemen.quest.evaluate().displayState()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct

	struct QuestTheNorsemen extends SharedQuest
		/**
		 * The number of enemy waves of Orcs and Dark Elves which the Norsemen and characters have to fight.
		 */
		public static constant integer maxWaves = 5
		/**
		 * The number of allied waves which support the Norsemen and the characters.
		 */
		public static constant integer maxAlliedWaves = 2
		public static constant integer questItemMeetTheNorsemen = 0
		public static constant integer questItemMeetAtTheBattlefield = 1
		public static constant integer questItemFight = 2
		public static constant integer questItemMeetAtTheOutpost = 3
		public static constant integer questItemReportHeimrich = 4
		private boolean m_hasStarted
		private AGroup m_allyStartGroup
		private AGroup m_allyRangerGroup
		private unit m_allyRangerLeader
		private AGroup m_allyFarmerGroup
		private unit m_allyFarmerLeader
		private AGroup m_currentGroup
		private integer m_currentGroupIndex
		private trigger m_spawnTrigger
		private WavesDisplay m_wavesDisplay
		private QuestAreaTheNorsemenTheChief m_questAreaTheChief
		private QuestAreaTheNorsemenBattle m_questAreaBattle
		private QuestAreaTheNorsemenAfterTheBattle m_questAreAfterTheBattle
		private QuestAreaTheNorsemenHeimrich m_questAreaHeimrich
		private AGroup m_finalNorsemen

		implement Quest

		// members

		public method hasStarted takes nothing returns boolean
			return this.m_hasStarted
		endmethod

		// methods

		public stub method enable takes nothing returns boolean
			call Missions.addMissionToAll('A1C0', 'A1RA', this)
			set this.m_questAreaTheChief = QuestAreaTheNorsemenTheChief.create(gg_rct_quest_the_norsemen_quest_item_0)
			return super.enableUntil(thistype.questItemMeetTheNorsemen)
		endmethod

		/**
		 * Everytime a unit dies which belongs to the enemy group it will be checked if it was the last of the group to create a new spawn wave or to complete the quest.
		 * Allied groups will be spawned in between while some of the enemy group's units are still alive.
		 */
		private static method triggerConditionSpawn takes nothing returns boolean
			local thistype this = thistype.quest()
			local unit triggerUnit = GetTriggerUnit()
			local boolean result = false
			if (this.m_currentGroup.units().contains(triggerUnit)) then
				call this.m_currentGroup.units().remove(triggerUnit)
				set result = this.m_currentGroup.units().empty()

				if (not result and this.m_currentGroup.units().size() == 5) then // Gruppen müssen immer größer als 5 sein
					// rangers (ally spawn)
					if (this.m_currentGroupIndex == 1) then
						call this.m_wavesDisplay.decreaseAllies()
						set this.m_allyRangerGroup = AGroup.create()
						call this.m_allyRangerGroup.addGroup(CreateUnitsAtPoint(5, UnitTypes.ranger, MapData.alliedPlayer, GetUnitX(Npcs.wigberht()), GetUnitY(Npcs.wigberht()), 90.0), true, false)
						set this.m_allyRangerLeader = CreateUnit(MapData.alliedPlayer, 'n03G',  GetUnitX(Npcs.wigberht()), GetUnitY(Npcs.wigberht()), 90.0)
						call this.m_allyRangerGroup.units().pushBack(this.m_allyRangerLeader)

						call PingMinimap(GetUnitX(Npcs.wigberht()), GetUnitY(Npcs.wigberht()), bj_RESCUE_PING_TIME)

						call TransmissionFromUnit(this.m_allyRangerLeader, tre("He ihr da! Wir sind gekommen, um euch zu unterstützen. Vertreiben wir diese Brut aus unserem Land!", "Hey you there! We have come to assist you. Let us drive this pack out of our country!"), null)
						call Character.displayUnitAcquiredToAll(tre("Waldläufer", "Ranger"), tre("Waldläufer sind geschickte Fernkämpfer, die ihre Gegner mit vergifteten Pfeilen beschießen können.", "Rangers are skilled range fighters who can bombard their opponents with poisoned arrows."))
					// farmers (ally spawn)
					elseif (this.m_currentGroupIndex == 3) then
						call this.m_wavesDisplay.decreaseAllies()
						set this.m_allyFarmerGroup = AGroup.create()
						call this.m_allyFarmerGroup.addGroup(CreateUnitsAtPoint(5, UnitTypes.armedVillager, MapData.alliedPlayer, GetUnitX(Npcs.wigberht()), GetUnitY(Npcs.wigberht()), 90.0), true, false)
						set this.m_allyFarmerLeader = CreateUnit(MapData.alliedPlayer, 'n03I',  GetUnitX(Npcs.wigberht()), GetUnitY(Npcs.wigberht()), 90.0)
						call this.m_allyFarmerGroup.units().pushBack(this.m_allyFarmerLeader)

						call PingMinimap(GetUnitX(Npcs.wigberht()), GetUnitY(Npcs.wigberht()), bj_RESCUE_PING_TIME)

						call TransmissionFromUnit(this.m_allyFarmerLeader, tre("Kommt Leute, helfen wir ihnen! Tötet alle Feinde!", "Come on guys, we can help them! Kill all the enemies!"), null)
						call Character.displayUnitAcquiredToAll(tre("Bewaffnete Dorfbewohner", "Armed Villagers"), tre("Bewaffnete Dorfbewohner sind mutige Fernkämpfer, die ihre Gegner mit Brandpfeilen beschießen können.", "Armed villagers are courageous range fighters who can bombard their opponents with fire arrows."))
					endif
				endif
			endif

			set triggerUnit = null
			return result
		endmethod

		private method cleanUpBattleField takes nothing returns nothing
			set this.m_hasStarted = false
			call this.m_allyStartGroup.units().remove(Npcs.wigberht())
			call this.m_allyStartGroup.units().remove(Npcs.ricman())
			call this.m_allyStartGroup.forGroup(thistype.groupFunctionRemoveUnit)
			call this.m_allyStartGroup.destroy()
			call this.m_allyRangerGroup.forGroup(thistype.groupFunctionRemoveUnit)
			call this.m_allyRangerGroup.destroy()
			set this.m_allyRangerLeader = null
			call this.m_allyFarmerGroup.forGroup(thistype.groupFunctionRemoveUnit)
			call this.m_allyFarmerGroup.destroy()
			set this.m_allyFarmerLeader = null
			call this.m_currentGroup.forGroup(thistype.groupFunctionRemoveUnit)
			call this.m_currentGroup.destroy()
			call DestroyTrigger(this.m_spawnTrigger)
			set this.m_spawnTrigger = null

			call this.m_wavesDisplay.destroy()
		endmethod

		public method completeFight takes nothing returns boolean
			call this.cleanUpBattleField()
			return QuestTheNorsemen.quest().questItem(thistype.questItemFight).setState(AAbstractQuest.stateCompleted) // video Wigberht is played in quest completion action
		endmethod

		private static method forGroupNoGuard takes unit whichUnit returns nothing
			call SetUnitCreepGuard(whichUnit, false)
			call RemoveGuardPosition(whichUnit)
		endmethod

		private static method triggerActionSpawn takes nothing returns nothing
			local thistype this = thistype.quest()
			local player owner = MapData.orcPlayer
			local unit orcLeader
			call this.m_currentGroup.units().clear()

			// killed last wave -> quest item 1 completed
			if (this.m_currentGroupIndex + 1 == thistype.maxWaves) then
				call this.completeFight() // video Wigberht is played in quest completion action
				return
			endif
			set this.m_currentGroupIndex = this.m_currentGroupIndex + 1
			call this.m_wavesDisplay.decreaseHostiles()

			if (this.m_currentGroupIndex == 1) then
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(3, UnitTypes.orcWarrior, owner, gg_rct_quest_the_norsemen_enemy_spawn_0, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, UnitTypes.orcCrossbow, owner, gg_rct_quest_the_norsemen_enemy_spawn_0, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, UnitTypes.orcPython, owner, gg_rct_quest_the_norsemen_enemy_spawn_0, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, 'n044', owner, gg_rct_quest_the_norsemen_enemy_spawn_0, 270.0), true, false)

				call this.m_currentGroup.addGroup(CreateUnitsAtRect(3, UnitTypes.orcWarrior, owner, gg_rct_quest_the_norsemen_enemy_spawn_1, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, UnitTypes.orcWarlock, owner, gg_rct_quest_the_norsemen_enemy_spawn_1, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, UnitTypes.darkElfSatyr, owner, gg_rct_quest_the_norsemen_enemy_spawn_1, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, 'n044', owner, gg_rct_quest_the_norsemen_enemy_spawn_1, 270.0), true, false)

				call this.m_currentGroup.addGroup(CreateUnitsAtRect(3, UnitTypes.orcWarrior, owner, gg_rct_quest_the_norsemen_enemy_spawn_2, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, UnitTypes.orcCrossbow, owner, gg_rct_quest_the_norsemen_enemy_spawn_2, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, UnitTypes.orcPython, owner, gg_rct_quest_the_norsemen_enemy_spawn_2, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, 'n044', owner, gg_rct_quest_the_norsemen_enemy_spawn_2, 270.0), true, false)

				call TransmissionFromUnitWithName(Npcs.ricman(), tre("Ricman", "Ricman"), tre("Diese verdammten Hunde haben Verstärkung gerufen. Macht euch bereit Männer!", "Those damned bastards have called reinforcements. Get ready men!"), gg_snd_RicmanTheNorsemenRicman1)

				call PingMinimap(GetRectCenterX(gg_rct_quest_the_norsemen_enemy_spawn_1), GetRectCenterY(gg_rct_quest_the_norsemen_enemy_spawn_1), bj_RESCUE_PING_TIME)
			elseif (this.m_currentGroupIndex == 2) then
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(3, UnitTypes.orcWarrior, owner, gg_rct_quest_the_norsemen_enemy_spawn_0, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, 'n044', owner, gg_rct_quest_the_norsemen_enemy_spawn_0, 270.0), true, false)

				call this.m_currentGroup.addGroup(CreateUnitsAtRect(3, UnitTypes.orcWarrior, owner, gg_rct_quest_the_norsemen_enemy_spawn_1, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, 'n044', owner, gg_rct_quest_the_norsemen_enemy_spawn_1, 270.0), true, false)

				call this.m_currentGroup.addGroup(CreateUnitsAtRect(3, UnitTypes.orcWarrior, owner, gg_rct_quest_the_norsemen_enemy_spawn_2, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, 'n044', owner, gg_rct_quest_the_norsemen_enemy_spawn_2, 270.0), true, false)

				call TransmissionFromUnitWithName(Npcs.ricman(), tre("Ricman", "Ricman"), tre("Schon wieder ein neuer Trupp.", "Again a new squad."), gg_snd_RicmanTheNorsemenRicman2) // TODO wrong sound
			elseif (this.m_currentGroupIndex == 3) then
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(3, UnitTypes.orcWarrior, owner, gg_rct_quest_the_norsemen_enemy_spawn_0, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, 'n044', owner, gg_rct_quest_the_norsemen_enemy_spawn_0, 270.0), true, false)

				call this.m_currentGroup.addGroup(CreateUnitsAtRect(3, UnitTypes.orcWarrior, owner, gg_rct_quest_the_norsemen_enemy_spawn_1, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, 'n044', owner, gg_rct_quest_the_norsemen_enemy_spawn_1, 270.0), true, false)

				call this.m_currentGroup.addGroup(CreateUnitsAtRect(3, UnitTypes.orcWarrior, owner, gg_rct_quest_the_norsemen_enemy_spawn_2, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, 'n044', owner, gg_rct_quest_the_norsemen_enemy_spawn_2, 270.0), true, false)

				call TransmissionFromUnitWithName(Npcs.ricman(), tre("Ricman", "Ricman"), tre("Schlachtet sie!", "Slaughter them!"), gg_snd_RicmanTheNorsemenRicman3)
			elseif (this.m_currentGroupIndex == 4) then
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(4, UnitTypes.orcWarrior, owner, gg_rct_quest_the_norsemen_enemy_spawn_0, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, 'n044', owner, gg_rct_quest_the_norsemen_enemy_spawn_0, 270.0), true, false)

				call this.m_currentGroup.addGroup(CreateUnitsAtRect(4, UnitTypes.orcWarrior, owner, gg_rct_quest_the_norsemen_enemy_spawn_1, 270.0), true, false)
				set orcLeader = CreateUnit(owner, UnitTypes.orcLeader, GetRectCenterX(gg_rct_quest_the_norsemen_enemy_spawn_1), GetRectCenterY(gg_rct_quest_the_norsemen_enemy_spawn_1), 270.0)
				call this.m_currentGroup.units().pushBack(orcLeader)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, 'n044', owner, gg_rct_quest_the_norsemen_enemy_spawn_1, 270.0), true, false)


				call this.m_currentGroup.addGroup(CreateUnitsAtRect(4, UnitTypes.orcWarrior, owner, gg_rct_quest_the_norsemen_enemy_spawn_2, 270.0), true, false)
				call this.m_currentGroup.addGroup(CreateUnitsAtRect(1, 'n044', owner, gg_rct_quest_the_norsemen_enemy_spawn_2, 270.0), true, false)

				call TransmissionFromUnit(orcLeader, tre("Ihr elenden Menschen, euer Ende ist nah!", "You wretched men, your end is near!"), null)
			endif

			call this.m_currentGroup.forGroup(thistype.forGroupNoGuard) // prevents them from walking back to the spawn point
			// TODO they do not walk back BUT some units dont move, maybe it is because of the unit type that they cant attack a point
			call this.m_currentGroup.pointOrder("attack", GetRectCenterX(gg_rct_quest_the_norsemen_enemy_target), GetRectCenterY(gg_rct_quest_the_norsemen_enemy_target))
			set owner = null
		endmethod

		private static method groupFunctionMoveToRandomPointOnBattleField takes unit enumUnit returns nothing
			call SetUnitToRandomPointOnRect(enumUnit, gg_rct_video_the_first_combat_battle_field)
			call SetUnitFacing(enumUnit, GetRandomReal(0.0, 360.0))
		endmethod

		private static method groupFunctionChangeOwnerToAlly takes unit enumUnit returns nothing
			local player allyPlayer = MapData.alliedPlayer
			call SetUnitOwner(enumUnit, allyPlayer, true)
			set allyPlayer = null
		endmethod

		private static method groupFunctionChangeOwnerToEnemy takes unit enumUnit returns nothing
			local player enemyPlayer = MapData.orcPlayer
			call SetUnitOwner(enumUnit, enemyPlayer, true)
			set enemyPlayer = null
		endmethod

		/**
		 * Starts the battle and enables spawning the new waves.
		 * The old spawn points at the camp are disabled and Wigberht and Ricman are shared as fellows as well as the Norsemen.
		 */
		public method startSpawns takes AGroup allyStartGroup, AGroup enemyStartGroup returns nothing
			local integer i
			// hide orc spawn point
			call SpawnPoints.orcs0().disable()
			set i = 0
			loop
				exitwhen (i == SpawnPoints.orcs0().countUnits())
				debug call Print("Pausing and hiding orc spawn point unit: " + GetUnitName(SpawnPoints.orcs0().unit(i)))
				call PauseUnit(SpawnPoints.orcs0().unit(i), true)
				call ShowUnit(SpawnPoints.orcs0().unit(i), false)
				set i = i + 1
			endloop


			set this.m_allyStartGroup = allyStartGroup
			set this.m_spawnTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_spawnTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(this.m_spawnTrigger, Condition(function thistype.triggerConditionSpawn))
			call TriggerAddAction(this.m_spawnTrigger, function thistype.triggerActionSpawn)

			set this.m_wavesDisplay = WavesDisplay.create()

			set this.m_hasStarted = true
			set this.m_currentGroup = enemyStartGroup
			set this.m_currentGroupIndex = 0

			call this.m_allyStartGroup.forGroup(thistype.groupFunctionMoveToRandomPointOnBattleField)
			call this.m_allyStartGroup.forGroup(thistype.groupFunctionChangeOwnerToAlly)
			call enemyStartGroup.forGroup(thistype.groupFunctionMoveToRandomPointOnBattleField)
			call enemyStartGroup.forGroup(thistype.groupFunctionChangeOwnerToEnemy)

			// alliance with player 6, player 6 is used for ending norsemen battle
			call Game.setAlliedPlayerAlliedToAllCharacters()

			call ACharacter.enableShrineForAll(Shrines.hillShrine(), false)
			call ACharacter.setToRandomPointOnRectForAll(gg_rct_video_the_first_combat_battle_field)
			call Character.displayHintToAll(tre("Unterstützen Sie Wigberht und seine Männer und besiegen sie die Orks und Dunkelelfen.", "Support Wigberht and his men and defeat the Orcs and Dark Elves."))
			/// @todo set map bounds that characters aren't able to move out of the camera bounds area
			call Game.resetCameraBounds() // camera will be set to fight area automatically when spawn has started
			call ACharacter.panCameraSmartToAll()

			call Fellows.wigberht().shareWithAll()
			call Fellows.ricman().shareWithAll()
		endmethod

		public method enableTheBattle takes nothing returns nothing
			call this.questItem(thistype.questItemMeetTheNorsemen).complete()
			call VideoTheChief.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			call this.questItem(thistype.questItemMeetAtTheBattlefield).enable()
			set this.m_questAreaBattle = QuestAreaTheNorsemenBattle.create(gg_rct_quest_the_norsemen_assembly_point)
		endmethod

		private static method groupFunctionRemoveUnit takes unit enumUnit returns nothing
			call RemoveUnit(enumUnit)
		endmethod

		private static method stateActionCompleted2 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			debug call Print("Quest The Norsemen target 1 completed -> starting with video Wigberht")

			call this.questItem(thistype.questItemMeetAtTheOutpost).setState(thistype.stateNew)
			call this.displayUpdate()

			call Fellows.wigberht().reset()
			call Fellows.ricman().reset()

			call SetUnitX(Npcs.wigberht(), GetRectCenterX(gg_rct_waypoint_wigberht_training))
			call SetUnitY(Npcs.wigberht(), GetRectCenterY(gg_rct_waypoint_wigberht_training))

			call SetUnitX(Npcs.ricman(), GetRectCenterX(gg_rct_waypoint_ricman))
			call SetUnitY(Npcs.ricman(), GetRectCenterY(gg_rct_waypoint_ricman))

			// the orc spawn point will be disabled forever. The camp is now in hands of norsemen, villagers and rangers
			// new NPCs?
			call SpawnPoints.destroyOrcs0()

			set this.m_questAreAfterTheBattle = QuestAreaTheNorsemenAfterTheBattle.create(gg_rct_quest_the_defense_of_talras)
		endmethod

		public method completeMeetAtTheOutpost takes nothing returns nothing
			local unit whichUnit
			call VideoWigberht.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			call this.questItem(thistype.questItemMeetAtTheOutpost).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemReportHeimrich).setState(thistype.stateNew)
			call this.displayUpdate()

			/*
			 * Create Norsemen
			 */
			set this.m_finalNorsemen = AGroup.create()
			set whichUnit = CreateUnitAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.norseman, gg_rct_waypoint_orc_camp_norseman_0, 196.87)
			call SetUnitInvulnerable(whichUnit, true)
			call this.m_finalNorsemen.units().pushBack(whichUnit)
			set whichUnit =  CreateUnitAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.norseman, gg_rct_waypoint_orc_camp_norseman_1, 353.13)
			call SetUnitInvulnerable(whichUnit, true)
			call this.m_finalNorsemen.units().pushBack(whichUnit)
			set whichUnit =  CreateUnitAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.norseman, gg_rct_waypoint_orc_camp_norseman_2, 243.49)
			call SetUnitInvulnerable(whichUnit, true)
			call this.m_finalNorsemen.units().pushBack(whichUnit)
			set whichUnit =  CreateUnitAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.armedVillager, gg_rct_waypoint_orc_camp_villager_0, 7.50)
			call SetUnitInvulnerable(whichUnit, true)
			call this.m_finalNorsemen.units().pushBack(whichUnit)
			set whichUnit =  CreateUnitAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.armedVillager, gg_rct_waypoint_orc_camp_villager_1, 230.15)
			call SetUnitInvulnerable(whichUnit, true)
			call this.m_finalNorsemen.units().pushBack(whichUnit)
			set whichUnit =  CreateUnitAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.ranger, gg_rct_waypoint_orc_camp_ranger_0, 296.12)
			call SetUnitInvulnerable(whichUnit, true)
			call this.m_finalNorsemen.units().pushBack(whichUnit)

			/*
			 * This shrine is finally used here.
			 */
			call Shrines.initOrcCamp()

			set this.m_questAreaHeimrich = QuestAreaTheNorsemenHeimrich.create(gg_rct_quest_talras_quest_item_1)
		endmethod

		private static method forEachFunctionRemoveUnit takes unit whichUnit returns nothing
			call RemoveUnit(whichUnit)
		endmethod

		public method cleanFinalNorsemen takes nothing returns nothing
			call this.m_finalNorsemen.units().forEach(thistype.forEachFunctionRemoveUnit)
			call this.m_finalNorsemen.destroy()
			set this.m_finalNorsemen = 0
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Die Nordmänner", "The Norsemen"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNHeroDeathKnight.blp")
			call this.setDescription(tre("Der Herzog will, dass ihr die Nordmänner vor der Burg auf seine Seite zieht, damit er neue Verbündete für den bevorstehenden Krieg gewinnt.", "The duke wants you to win the Norsemen in front of the castle for him for winning new allies for the upcoming war."))
			// item 0
			set questItem = AQuestItem.create(this, tre("Begebt euch zum Lager der Nordmänner östlich von der Burg.", "Move to the camp of the Norsemen east of the castle."))

			call questItem.setPing(true)
			call questItem.setPingCoordinatesFromRect(gg_rct_quest_the_norsemen_quest_item_0)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 150)
			// item 1
			set questItem = AQuestItem.create(this, tre("Sammelt euch nahe des nordwestlichen Orklagers mit den Nordmännern.", "Gather yourselves with the Norsemen near to the north west Orc camp."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_norsemen_assembly_point)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 150)
			// item 2
			set questItem = AQuestItem.create(this, tre("Beweist eure Kampfstärke, indem ihr die Nordmänner im Kampf unterstützt.", "Prove your combat strength by supporting the Northmen in the fight."))
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted2)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_norsemen_assembly_point)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 2000)
			// item 3
			set questItem = AQuestItem.create(this, tre("Trefft euch am Außenposten.", "Meet at the outpost."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_defense_of_talras)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// item 4
			set questItem = AQuestItem.create(this, tre("Berichtet dem Herzog von eurem Erfolg.", "Report to the Duke of your success."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_talras_quest_item_1)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 150)
			// members
			set this.m_hasStarted = false
			set this.m_allyStartGroup = 0
			set this.m_allyRangerGroup = 0
			set this.m_allyFarmerGroup = 0
			set this.m_currentGroup = 0
			set this.m_currentGroupIndex = 0
			set this.m_spawnTrigger = null

			return this
		endmethod
	endstruct

endlibrary
