library StructMapQuestsQuestWarSupplyFromManfred requires Asl, StructGameQuestArea, StructMapQuestsQuestWarSubQuest, StructMapVideosVideoManfred

	struct QuestAreaWarManfred extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoManfred.video().play()
		endmethod
	endstruct

	struct QuestAreaWarReportManfred extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoReportManfred.video().play()
		endmethod
	endstruct

	struct QuestWarSupplyFromManfred extends QuestWarSubQuest
		public static constant integer questItemSupplyFromManfred = 0
		public static constant integer questItemKillTheCornEaters = 1
		public static constant integer questItemReportManfred = 2
		public static constant integer questItemWaitForManfredsSupply = 3
		public static constant integer questItemMoveManfredsSupplyToTheCamp = 4

		private QuestAreaWarManfred m_questAreaManfred
		private QuestAreaWarReportManfred m_questAreaReportManfred

		public static constant integer maxSpawnPoints = 5
		private boolean array m_killedSpawnPoint[thistype.maxSpawnPoints]
		private SpawnPoint array m_spawnPoint[thistype.maxSpawnPoints]

		/*
		 * Manfred
		 */
		private unit m_supplyCart
		private timer m_supplyCartSpawnTimer
		private timer m_manfredsSupplyTimer

		public method cleanUnits takes nothing returns nothing
			// Manfred
			call RemoveUnit(this.m_supplyCart)
			set this.m_supplyCart = null
		endmethod

		public stub method enable takes nothing returns boolean
			local integer i = 0
			local boolean result = this.setState(thistype.stateNew)
			call this.questItem(thistype.questItemSupplyFromManfred).setState(thistype.stateNew)

			set this.m_questAreaManfred = QuestAreaWarManfred.create(gg_rct_quest_war_manfred, true)

			set i = 0
			loop
				exitwhen (i == thistype.maxSpawnPoints)
				set this.m_killedSpawnPoint[i] = false
				set i = i + 1
			endloop

			set this.m_spawnPoint[0] = SpawnPoints.cornEaters0()
			set this.m_spawnPoint[1] = SpawnPoints.cornEaters1()
			set this.m_spawnPoint[2] = SpawnPoints.cornEaters2()
			set this.m_spawnPoint[3] = SpawnPoints.cornEaters3()
			set this.m_spawnPoint[4] = SpawnPoints.cornEaters4()

			return result
		endmethod

		public method enableKillTheCornEaters takes nothing returns nothing
			call this.questItem(thistype.questItemKillTheCornEaters).enable()
			// TODO find out which spawn point still has creeps
			call setQuestItemPingByUnitTypeId.execute(this.questItem(thistype.questItemKillTheCornEaters), SpawnPoints.cornEaters0(), UnitTypes.cornEater)
		endmethod

		private static method stateEventCompletedKillTheCornEaters takes AQuestItem questItem, trigger whichTrigger returns nothing
			// the units owner might be different due to abilities
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DEATH)
		endmethod

		private static method unitLives takes unit whichUnit returns boolean
			debug call Print("Checking " + GetUnitName(whichUnit) + " with life: " + R2S(GetUnitState(whichUnit, UNIT_STATE_LIFE)))
			return not IsUnitDeadBJ(whichUnit)
		endmethod

		/**
		 * There is two spawn points for Corn Eaters at the moment.
		 * Both have to be checked for all units being dead.
		 * If so the quest item will be completed.
		 * The ping is always moved to the next living Corn Eater.
		 */
		private static method stateConditionCompletedKillTheCornEaters takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local integer tmpCount = 0
			local integer count = 0
			local integer total = 0
			local integer i = 0
			if (GetUnitTypeId(GetTriggerUnit()) == UnitTypes.cornEater) then
				set i = 0
				loop
					exitwhen (i == thistype.maxSpawnPoints)
					// if a spawn point is completely killed ONCE it is marked as completed, otherwise corn eaters would have to be killed again when they respawn
					if (not this.m_killedSpawnPoint[i]) then
						set tmpCount = this.m_spawnPoint[i].countUnitsIf(thistype.unitLives)
						set this.m_killedSpawnPoint[i] = tmpCount == 0
						set count = count + tmpCount
						debug call Print("Check spawn point " + I2S(i) + " with id " + I2S(this.m_spawnPoint[i]) + ": " + I2S(tmpCount) + " and total count of this spawn point units: " + I2S(this.m_spawnPoint[i].countUnits()))
					endif
					set i = i + 1
				endloop
				if (count == 0) then
					debug call Print("All counts are 0")
					return true
				// get next one to ping
				else
					set i = 0
					loop
						exitwhen (i == thistype.maxSpawnPoints)
						set total = total + this.m_spawnPoint[i].countMembers()
						set i = i + 1
					endloop
					call this.displayUpdateMessage(Format(tre("%1%/%2% Kornfresser", "%1%/%2% Corn Eaters")).i(total - count).i(total).result())
				endif
			endif
			return false
		endmethod

		/**
		 * After the Corn Eaters have been killed the characters must report Manfred.
		 * The same rect is used as for talking to him in the first place.
		 */
		private static method stateActionCompletedKillTheCornEaters takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.questItem(thistype.questItemReportManfred).setState(thistype.stateNew)
			call this.displayUpdate()
			set this.m_questAreaReportManfred = QuestAreaWarReportManfred.create(gg_rct_quest_war_manfred, true)
		endmethod

		private static method timerFunctionSpawnSupplyCart takes nothing returns nothing
			local thistype this = thistype.quest.evaluate()
			if (IsUnitDeadBJ(this.m_supplyCart)) then
				set this.m_supplyCart = CreateUnit(MapSettings.alliedPlayer(), 'h022', GetRectCenterX(gg_rct_quest_war_manfred), GetRectCenterY(gg_rct_quest_war_manfred), 0.0)
				call this.displayUpdateMessage(tre("Eine neue Nahrungslieferung steht zur Verfügung.", "A new supply of food is available."))
				call PingMinimapEx(GetRectCenterX(gg_rct_quest_war_manfred), GetRectCenterY(gg_rct_quest_war_manfred), 5.0, 255, 255, 255, true)

				call Game.setAlliedPlayerAlliedToAllCharacters()
			endif
		endmethod

		private static method timerFunctionManfredsSupply takes nothing returns nothing
			local thistype this = thistype.quest.evaluate()
			call this.questItem(thistype.questItemWaitForManfredsSupply).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemMoveManfredsSupplyToTheCamp).setState(thistype.stateNew)
			call this.displayUpdate()

			set this.m_supplyCart = CreateUnit(MapSettings.alliedPlayer(), 'h022', GetRectCenterX(gg_rct_quest_war_manfred), GetRectCenterY(gg_rct_quest_war_manfred), 0.0)
			set this.m_supplyCartSpawnTimer = CreateTimer()
			call TimerStart(this.m_supplyCartSpawnTimer, QuestWar.respawnTime, true, function thistype.timerFunctionSpawnSupplyCart)
			call Game.setAlliedPlayerAlliedToAllCharacters()
			call PingMinimapEx(GetRectCenterX(gg_rct_quest_war_manfred), GetRectCenterY(gg_rct_quest_war_manfred), 5.0, 255, 255, 255, true)

			// TODO destroy the elapsed timer

			call QuestWar.quest.evaluate().enableCartDestination.evaluate()
		endmethod

		/**
		 * When the characters reported to Manfred he sends a cart to the former Orc camp to provide some supply.
		 */
		private static method stateActionCompletedReportManfred takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())

			set this.m_manfredsSupplyTimer = CreateTimer()
			call TimerStart(this.m_manfredsSupplyTimer, QuestWar.constructionTime, false, function thistype.timerFunctionManfredsSupply)

			call this.questItem(thistype.questItemWaitForManfredsSupply).setState(thistype.stateNew)
			call this.displayUpdate()
		endmethod

		/**
		 * Test method.
		 */
		public method moveSupplyCartToCamp takes nothing returns nothing
			call thistype.timerFunctionSpawnSupplyCart()
			call SetUnitX(this.m_supplyCart, GetRectCenterX(gg_rct_quest_war_cart_destination))
			call SetUnitY(this.m_supplyCart, GetRectCenterY(gg_rct_quest_war_cart_destination))
		endmethod

		private static method stateEventCompletedMoveManfredsSupplyToTheCamp takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_war_cart_destination)
		endmethod

		private static method stateConditionCompletedMoveManfredsSupplyToTheCamp takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			return GetTriggerUnit() == this.m_supplyCart
		endmethod

		private static method stateActionCompletedMoveManfredsSupplyToTheCamp takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())

			call QuestWar.quest.evaluate().setupUnitAtDestination.evaluate(GetTriggerUnit())

			call PauseTimer(this.m_supplyCartSpawnTimer)
			call DestroyTimer(this.m_supplyCartSpawnTimer)
			set this.m_supplyCartSpawnTimer = null

			call this.questItem(thistype.questItemSupplyFromManfred).setState(thistype.stateCompleted)
			call this.displayState()
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Nahrung von Manfred", "Supply from Manfred"), QuestWar.questItemSupplyFromManfred)
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNMonsterLure.blp")
			call this.setDescription(tre("Um die bevorstehenden Angriffe der Orks und Dunkelelfen aufzuhalten, muss der eroberte Außenposten versorgt werden.  Außerdem müssen Fallen vor den Mauern aufgestellt werden, die es den Feinden erschweren, den Außenposten einzunehmen. Zusätzlich müssen auf dem Bauernhof kriegstaugliche Leute angeheuert werden.", "In order to stop the impeding attacks of Orcs and Dark Elves, the conquered outpost has to be supplied. In addition, traps has to be placed before the walls that make it harder for the enemies to conquer the outpost. Furthermore, war suitable people need to be hired at the farm."))
			call this.setReward(thistype.rewardExperience, 200)
			call this.setReward(thistype.rewardGold, 200)

			// quest item questItemSupplyFromManfred
			set questItem = AQuestItem.create(this, tre("Besorgt Nahrung vom Bauern Manfred.", "Get food from the farmer Manfred."))

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_manfred)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// quest item questItemKillTheCornEaters
			set questItem = AQuestItem.create(this, tre("Vernichtet die Kornfresser.", "Destroy the Corn Eaters."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedKillTheCornEaters)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedKillTheCornEaters)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedKillTheCornEaters)

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_corn_eaters)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// quest item questItemReportManfred
			set questItem = AQuestItem.create(this, tre("Berichtet Manfred davon.", "Report Manfred about it."))
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedReportManfred)

			// questItemWaitForManfredsSupply
			set questItem = AQuestItem.create(this, tre("Wartet bis Manfred die Nahrung aufgeladen hat.", "Wait until Manfred has loaded the food."))

			// questItemMoveManfredsSupplyToTheCamp
			set questItem = AQuestItem.create(this, tre("Bringt Manfreds Nahrung sicher zum Außenposten.", "Move Manfred's food safely to the outpost."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedMoveManfredsSupplyToTheCamp)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedMoveManfredsSupplyToTheCamp)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedMoveManfredsSupplyToTheCamp)

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_cart_destination)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement Quest
	endstruct

endlibrary