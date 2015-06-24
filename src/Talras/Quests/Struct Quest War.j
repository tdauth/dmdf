library StructMapQuestsQuestWar requires Asl, StructGameQuestArea, StructMapVideosVideoIronFromTheDrumCave, StructMapVideosVideoKuno, StructMapVideosVideoWeaponsFromWieland, StructMapVideosVideoWieland, StructMapVideosVideoManfred

	struct QuestAreaWarWieland extends QuestArea
	
		public stub method onStart takes nothing returns nothing
			call VideoWieland.video().play()
		endmethod
	endstruct
	
	struct QuestAreaWarIronFromTheDrumCave extends QuestArea
		public stub method onStart takes nothing returns nothing
			call VideoIronFromTheDrumCave.video().play()
		endmethod
	endstruct
	
	/**
	 * Dummy quest area for the imps.
	 */
	struct QuestAreaWarImpTarget extends QuestArea
		public stub method onCheck takes nothing returns boolean
			return false
		endmethod
	
		public stub method onStart takes nothing returns nothing
		endmethod
	endstruct
	
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
	
	struct QuestAreaWarKuno extends QuestArea
	
		public stub method onStart takes nothing returns nothing
			call VideoKuno.video().play()
		endmethod
	endstruct
	
	struct QuestAreaWarReportKuno extends QuestArea
	
		public stub method onStart takes nothing returns nothing
			call VideoReportKuno.video().play()
		endmethod
	endstruct
	
	struct QuestAreaWarBjoern extends QuestArea
	
		public stub method onStart takes nothing returns nothing
			call VideoBjoern.video().play()
		endmethod
	endstruct
	
	struct QuestAreaWarRecruit extends QuestArea
	
		public stub method onStart takes nothing returns nothing
			call VideoRecruit.video().play()
		endmethod
	endstruct
	
	struct QuestAreaWarCartDestination extends QuestArea
		public stub method onCheck takes nothing returns boolean
			return false
		endmethod
	
		public stub method onStart takes nothing returns nothing
		endmethod
	endstruct

	// TODO add quest items to bring weapons, lumber and supply manually to the orc camp
	// TODO add some time until the weapons are finished, timer
	// TODO remove leaks, destroy quest areas etc.
	struct QuestWar extends AQuest
		public static constant integer questItemWeaponsFromWieland = 0
		public static constant integer questItemIronFromTheDrumCave = 1
		public static constant integer questItemMoveImpsToWieland = 2
		public static constant integer questItemWaitForWielandsWeapons = 3
		public static constant integer questItemMoveWielandWeaponsToTheCamp = 4
		public static constant integer questItemSupplyFromManfred = 5
		public static constant integer questItemKillTheCornEaters = 6
		public static constant integer questItemReportManfred = 7
		public static constant integer questItemLumberFromKuno = 8
		public static constant integer questItemKillTheWitches = 9
		public static constant integer questItemReportKuno = 10
		public static constant integer questItemMoveKunosLumberToTheCamp = 11
		public static constant integer questItemTrapsFromBjoern = 12
		public static constant integer questItemPlaceTraps = 13
		public static constant integer questItemRecruit = 14
		public static constant integer questItemGetRecruits = 15
		public static constant integer questItemReportHeimrich = 16
		public static constant integer maxImps = 4
		private QuestAreaWarWieland m_questAreaWieland
		private QuestAreaWarIronFromTheDrumCave m_questAreaIronFromTheDrumCave
		private QuestAreaWarImpTarget m_questAreaImpTarget
		private QuestAreaWarManfred m_questAreaManfred
		private QuestAreaWarReportManfred m_questAreaReportManfred
		private QuestAreaWarKuno m_questAreaKuno
		private QuestAreaWarReportKuno m_questAreaReportKuno
		private QuestAreaWarBjoern m_questAreaBjoern
		private QuestAreaWarRecruit m_questAreaRecruit
		/**
		 * Quest area without effect to mark the destination of all carts.
		 */
		private QuestAreaWarCartDestination m_questAreaCartDestination
		/*
		 * Wieland
		 */
		private timer m_impSpawnTimer
		private timer m_wielandsWeaponsTimer
		private timer m_weaponCartSpawnTimer
		private unit m_weaponCart
		private AGroup m_imps
		/*
		 * Kuno
		 */
		public static constant integer witchSpawnPoints = 4
		private boolean array m_killedWitches[thistype.witchSpawnPoints]
		private timer m_kunosCartSpawnTimer
		private unit m_kunosCart
		
		/*
		 * Recruits
		 */
		 public static constant integer maxRecruits = 5
		 private unit m_recruitBuilding
		 private trigger m_recruitTrigger
		 private integer m_recruitCounter

		implement Quest

		public stub method enable takes nothing returns boolean
			local boolean result = this.setState(thistype.stateNew)
			set this.m_questAreaWieland = QuestAreaWarWieland.create(gg_rct_quest_war_wieland)
			set this.m_questAreaManfred = QuestAreaWarManfred.create(gg_rct_quest_war_manfred)
			set this.m_questAreaKuno = QuestAreaWarKuno.create(gg_rct_quest_war_kuno)
			set this.m_questAreaBjoern = QuestAreaWarBjoern.create(gg_rct_quest_war_bjoern)
			set this.m_questAreaRecruit = QuestAreaWarRecruit.create(gg_rct_quest_war_farm)
			set this.m_questAreaCartDestination = 0
			call this.questItem(thistype.questItemWeaponsFromWieland).setState(thistype.stateNew)
			call this.questItem(thistype.questItemSupplyFromManfred).setState(thistype.stateNew)
			call this.questItem(thistype.questItemLumberFromKuno).setState(thistype.stateNew)
			call this.questItem(thistype.questItemTrapsFromBjoern).setState(thistype.stateNew)
			call this.questItem(thistype.questItemRecruit).setState(thistype.stateNew)
			
			set this.m_recruitCounter = 0
			
			call this.displayState()

			return result
		endmethod
		
		/**
		 * Enables an empty quest area to mark the carts destinations.
		 */
		private method enableCartDestination takes nothing returns nothing
			if (this.m_questAreaCartDestination == 0) then
				set this.m_questAreaCartDestination = QuestAreaWarCartDestination.create(gg_rct_quest_war_cart_destination)
			endif
		endmethod
		
		/**
		 * Makes \p whichUnit invulnerable and changes its owner.
		 */
		private method setupUnitAtDestination takes unit whichUnit returns nothing
			call SetUnitInvulnerable(whichUnit, true)
			call SetUnitOwner(whichUnit, MapData.neutralPassivePlayer, true)
			call SetUnitPathing(whichUnit, false)
			call IssueImmediateOrder(whichUnit, "stop")
		endmethod
		
		/*
		 * The characters have to move to the Drum Cave and talk to Baldar who has an iron mine.
		 */
		public method enableIronFromTheDrumCave takes nothing returns nothing
			set this.m_questAreaIronFromTheDrumCave = QuestAreaWarIronFromTheDrumCave.create(gg_rct_quest_war_iron_from_the_drum_cave)
			call QuestWar.quest().questItem(QuestWar.questItemIronFromTheDrumCave).enable()
		endmethod
		
		/*
		 * Whenever Imps have been died they will be respawned periodically.
		 */
		private static method timerFunctionSpawnImps takes nothing returns nothing
			local thistype this = thistype.quest()
			local boolean spawned = false
			local integer i = 0
			loop
				exitwhen (i == thistype.maxImps)
				if (this.m_imps.units().size() < i + 1) then
					call this.m_imps.units().pushBack(CreateUnit(MapData.alliedPlayer, 'u00C', GetRectCenterX(gg_rct_quest_war_imp_spawn),  GetRectCenterY(gg_rct_quest_war_imp_spawn), 180.0))
					set spawned = true
				elseif (IsUnitDeadBJ(this.m_imps.units()[i])) then
					set this.m_imps.units()[i] = CreateUnit(MapData.alliedPlayer, 'u00C', GetRectCenterX(gg_rct_quest_war_imp_spawn),  GetRectCenterY(gg_rct_quest_war_imp_spawn), 180.0)
					set spawned = true
				endif
				set i = i + 1
			endloop
			
			call Game.setAlliedPlayerAlliedToAllCharacters()
			
			if (spawned) then
				call this.displayUpdateMessage(tr("Neue Imps stehen zur Verfügung."))
				call PingMinimapEx(GetRectCenterX(gg_rct_quest_war_imp_spawn), GetRectCenterY(gg_rct_quest_war_imp_spawn), 5.0, 255, 255, 255, true)
			endif
		endmethod
		
		/**
		 * There will be spawd \ref thistype.maxImps which the players can move to Wieland.
		 * If they do not survive new Imps will be spawned.
		 * This is a bit like the Goblin quest in the Bonus Campaign except that the imps should survive their journey.
		 */
		public method enableImpSpawn takes nothing returns nothing
			local integer i
			set this.m_imps = AGroup.create()
			set this.m_impSpawnTimer = CreateTimer()
			call TimerStart(this.m_impSpawnTimer, 20.0, true, function thistype.timerFunctionSpawnImps)
			set i = 0
			loop
				exitwhen (i == thistype.maxImps)
				call this.m_imps.units().pushBack(CreateUnit(MapData.alliedPlayer, 'u00C', GetRectCenterX(gg_rct_quest_war_imp_spawn),  GetRectCenterY(gg_rct_quest_war_imp_spawn), 180.0))
				set i = i + 1
			endloop
			call Game.setAlliedPlayerAlliedToAllCharacters()
			call SmartCameraPanRect(gg_rct_quest_war_imp_spawn, 0.0)
			set this.m_questAreaImpTarget = QuestAreaWarImpTarget.create(gg_rct_quest_war_wieland)
			call this.questItem(thistype.questItemMoveImpsToWieland).setState(thistype.stateNew)
			debug call Print("state condition: " + I2S(this.questItem(thistype.questItemMoveImpsToWieland).stateCondition(thistype.stateCompleted)))
			call this.displayUpdate()
			call this.displayUpdateMessage(tr("Neue Imps stehen zur Verfügung."))
		endmethod
		
		private static method stateEventCompletedImps takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_war_wieland)
		endmethod
		
		/**
		 * Whenever an Imp reaches Wieland he will be paused and made invulnerable.
		 * If all Imps (\ref thistype.maxImps) have reached their target the quest item will be completed.
		 */
		private static method stateConditionCompletedImps takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local integer i
			local integer counter = 0
			debug call Print("Condition for imps!")
			if (this.m_imps.units().contains(GetTriggerUnit())) then
				debug call Print("Is imp!")
				call this.setupUnitAtDestination(GetTriggerUnit())
				debug call Print("After setting Imp up")
				set i = 0
				loop
					exitwhen (i == thistype.maxImps)
					if (GetTriggerUnit() != this.m_imps.units()[i] and RectContainsUnit(gg_rct_quest_war_wieland, this.m_imps.units()[i])) then
						set counter = counter + 1
					endif
					set i = i + 1
				endloop
				set counter = counter + 1 // entering unit
				debug call Print("After counting " + I2S(counter))
				
				call questItem.quest().displayUpdateMessage(Format(tr("%1%/%2% Imps.")).i(counter).i(thistype.maxImps).result())
				
				return counter == thistype.maxImps
			debug else
				debug call Print("Is no Imp!")
			endif
			
			return false
		endmethod
		
		private static method groupFunctionRemove takes unit whichUnit returns nothing
			call RemoveUnit(whichUnit)
		endmethod
		
		private static method timerFunctionSpawnWeaponCart takes nothing returns nothing
			local thistype this = thistype.quest()
			if (IsUnitDeadBJ(this.m_weaponCart)) then
				set this.m_weaponCart = CreateUnit(MapData.alliedPlayer, 'h020', GetRectCenterX(gg_rct_quest_war_wieland), GetRectCenterY(gg_rct_quest_war_wieland), 0.0)
				call this.displayUpdateMessage(tr("Eine neue Waffenlieferung steht zur Verfügung."))
				call PingMinimapEx(GetRectCenterX(gg_rct_quest_war_wieland), GetRectCenterY(gg_rct_quest_war_wieland), 5.0, 255, 255, 255, true)
				
				call Game.setAlliedPlayerAlliedToAllCharacters()
			endif
		endmethod
		
		/**
		 * After the given time Wieland finished with his weapons and a cart is spawned.
		 * This cart can be controlled by all players and must be moved to the camp.
		 * It will be respawned by another timer if it dies.
		 */
		private static method timerFunctionWielandsWeapons takes nothing returns nothing
			local thistype this = thistype.quest()
			call this.questItem(thistype.questItemWaitForWielandsWeapons).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemMoveWielandWeaponsToTheCamp).setState(thistype.stateNew)
			call this.displayUpdateMessage(tr("Wieland's Waffen sind fertig."))
			call this.displayUpdate()
			
			set this.m_weaponCart = CreateUnit(MapData.alliedPlayer, 'h020', GetRectCenterX(gg_rct_quest_war_wieland), GetRectCenterY(gg_rct_quest_war_wieland), 0.0)
			set this.m_weaponCartSpawnTimer = CreateTimer()
			call TimerStart(this.m_weaponCartSpawnTimer, 20.0, true, function thistype.timerFunctionSpawnWeaponCart)
			call Game.setAlliedPlayerAlliedToAllCharacters()
			
			// TODO destroy the elapsed timer
			
			call this.enableCartDestination()
		endmethod

		private static method stateActionCompletedImps takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			/*
			 * Cleanup Imps.
			 * TODO Do something funny!
			 */
			call this.m_imps.forGroup(thistype.groupFunctionRemove)
			call this.m_imps.destroy()
			set this.m_imps = 0
			call PauseTimer(this.m_impSpawnTimer)
			call DestroyTimer(this.m_impSpawnTimer)
			set this.m_impSpawnTimer = null
			call this.m_questAreaImpTarget.destroy()
			
			call VideoWeaponsFromWieland.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			
			/*
			 * TODO Would be much cooler when the Imps take weapons to the former Orc camp.
			 */
			call this.questItem(thistype.questItemIronFromTheDrumCave).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemWaitForWielandsWeapons).setState(thistype.stateNew)
			call this.displayUpdate()
			
			set this.m_wielandsWeaponsTimer = CreateTimer()
			call TimerStart(this.m_wielandsWeaponsTimer, 30.0, false, function thistype.timerFunctionWielandsWeapons)
		endmethod
		
		private static method stateEventCompletedMoveWielandsWeaponsToTheCamp takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_war_cart_destination)
		endmethod
		
		private static method stateConditionCompletedMoveWielandsWeaponsToTheCamp takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			return GetTriggerUnit() == this.m_weaponCart
		endmethod
		
		private static method stateActionCompletedMoveWielandsWeaponsToTheCamp takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			
			call this.setupUnitAtDestination(GetTriggerUnit())
			
			call this.questItem(thistype.questItemWeaponsFromWieland).setState(thistype.stateCompleted)
			call this.displayState()
		endmethod
		
		/// Considers death units (spawn points) and continues searching for the first one with unit type id \p unitTypeId of spawn point \p spawnPoint with an 1 second interval.
		private method setPingByUnitTypeId takes AQuestItem questItem, ASpawnPoint spawnPoint, integer unitTypeId returns nothing
			local unit whichUnit = spawnPoint.firstUnitOfType(unitTypeId)
			if (whichUnit == null) then
				call questItem.setPing(false)
				call TriggerSleepAction(1.0)
				call this.setPingByUnitTypeId.execute(questItem, spawnPoint, unitTypeId) // continue searching
			else
				call questItem.setPing(true)
				call questItem.setPingUnit(whichUnit)
				call questItem.setPingColour(100.0, 100.0, 100.0)
			endif
		endmethod
		
		public method enableKillTheCornEaters takes nothing returns nothing
			call this.questItem(QuestWar.questItemKillTheCornEaters).enable()
			// TODO find out which spawn point still has creeps
			call this.setPingByUnitTypeId.execute(this.questItem(QuestWar.questItemKillTheCornEaters), SpawnPoints.cornEaters0(), UnitTypes.cornEater)
		endmethod
		
		private static method stateEventCompletedKillTheCornEaters takes AQuestItem questItem, trigger whichTrigger returns nothing
			// the units owner might be different due to abilities
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DEATH)
		endmethod

		/**
		 * There is two spawn points for Corn Eaters at the moment.
		 * Both have to be checked for all units being dead.
		 * If so the quest item will be completed.
		 * The ping is always moved to the next living Corn Eater.
		 */
		private static method stateConditionCompletedKillTheCornEaters takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local integer count0
			local integer count1
			if (GetUnitTypeId(GetTriggerUnit()) == UnitTypes.cornEater) then
				set count0 = SpawnPoints.cornEaters0().countUnitsOfType(UnitTypes.cornEater)
				set count1 = SpawnPoints.cornEaters1().countUnitsOfType(UnitTypes.cornEater)
				if (count0 == 0 and count1 == 0) then
					return true
				// get next one to ping
				else
					call this.displayUpdateMessage(Format(tr("%1%/4 Kornfresser")).i(4 - count0 - count1).result())
					if (count0 > 0) then
						call this.setPingByUnitTypeId.execute(questItem, SpawnPoints.cornEaters0(), UnitTypes.cornEater)
					else
						call this.setPingByUnitTypeId.execute(questItem, SpawnPoints.cornEaters1(), UnitTypes.cornEater)
					endif
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
			set this.m_questAreaReportManfred = QuestAreaWarReportManfred.create(gg_rct_quest_war_manfred)
		endmethod
		
		/**
		 * When the characters reported to Manfred he sends a cart to the former Orc camp to provide some supply.
		 */
		private static method stateActionCompletedReportManfred takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			local unit cart = CreateUnit(MapData.neutralPassivePlayer, 'h016', GetUnitX(Npcs.manfred()), GetUnitY(Npcs.manfred()), 0.0)
			call SetUnitInvulnerable(cart, true)
			call IssuePointOrder(cart, "move", GetRectCenterX(gg_rct_quest_war_cart_destination), GetRectCenterY(gg_rct_quest_war_cart_destination))
			call this.questItem(thistype.questItemSupplyFromManfred).setState(thistype.stateCompleted)
			call this.displayUpdate()
			set cart = null
		endmethod
		
		public method enableKillTheWitches takes nothing returns nothing
			call this.questItem(thistype.questItemKillTheWitches).setState(thistype.stateNew)
			call this.displayUpdate()
		endmethod
		
		private static method stateEventCompletedKillTheWitches takes AQuestItem questItem, trigger whichTrigger returns nothing
			// the units owner might be different due to abilities
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DEATH)
		endmethod

		/**
		 * There is four spawn points for Witches at the moment.
		 * Both have to be checked for all units being dead.
		 * If so the quest item will be completed.
		 * The ping is always moved to the next living Witch.
		 *
		 * Once a spawn point has been cleared it needn't to be cleaned again. Otherwise characters would be running around trying to kill all Witches at the same time.
		 */
		private static method stateConditionCompletedKillTheWitches takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local integer count0 = 0
			local integer count1 = 0
			local integer count2 = 0
			local integer count3 = 0
			if (GetUnitTypeId(GetTriggerUnit()) == UnitTypes.witch) then
				if (not this.m_killedWitches[0]) then
					set count0 = SpawnPoints.witch0().countUnitsOfType(UnitTypes.witch)
					set this.m_killedWitches[0] = count0 == 0
				endif
				if (not this.m_killedWitches[1]) then
					set count1 = SpawnPoints.witch1().countUnitsOfType(UnitTypes.witch)
					set this.m_killedWitches[1] = count1 == 0
				endif
				if (not this.m_killedWitches[2]) then
					set count2 = SpawnPoints.witch2().countUnitsOfType(UnitTypes.witch)
					set this.m_killedWitches[2] = count2 == 0
				endif
				if (not this.m_killedWitches[3]) then
					set count3 = SpawnPoints.witches().countUnitsOfType(UnitTypes.witch)
					set this.m_killedWitches[3] = count3 == 0
				endif
				if (this.m_killedWitches[0] and this.m_killedWitches[1] and this.m_killedWitches[2] and this.m_killedWitches[3]) then
					return true
				// get next one to ping
				else
					call this.displayUpdateMessage(Format(tr("%1%/6 Waldfurien")).i(6 - count0 - count1 - count2 - count3).result())
					if (count0 > 0) then
						call this.setPingByUnitTypeId.execute(questItem, SpawnPoints.witch0(), UnitTypes.witch)
					elseif (count1 > 0) then
						call this.setPingByUnitTypeId.execute(questItem, SpawnPoints.witch1(), UnitTypes.witch)
					elseif (count2 > 0) then
						call this.setPingByUnitTypeId.execute(questItem, SpawnPoints.witch2(), UnitTypes.witch)
					else
						call this.setPingByUnitTypeId.execute(questItem, SpawnPoints.witches(), UnitTypes.witch)
					endif
				endif
			endif
			return false
		endmethod
		
		/**
		 * After the Witches have been killed the characters must report Kuno.
		 * The same rect is used as for talking to him in the first place.
		 */
		private static method stateActionCompletedKillTheWitches takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.questItem(thistype.questItemReportKuno).setState(thistype.stateNew)
			call this.displayUpdate()
			set this.m_questAreaReportKuno = QuestAreaWarReportKuno.create(gg_rct_quest_war_kuno)
		endmethod
		
		private static method timerFunctionSpawnKunosCart takes nothing returns nothing
			local thistype this = thistype.quest()
			if (IsUnitDeadBJ(this.m_kunosCart)) then
				set this.m_kunosCart = CreateUnit(MapData.alliedPlayer, 'h021', GetRectCenterX(gg_rct_quest_war_kuno), GetRectCenterY(gg_rct_quest_war_kuno), 0.0)
				call this.displayUpdateMessage(tr("Eine neue Holzlieferung steht zur Verfügung."))
				call PingMinimapEx(GetRectCenterX(gg_rct_quest_war_kuno), GetRectCenterY(gg_rct_quest_war_kuno), 5.0, 255, 255, 255, true)
				
				call Game.setAlliedPlayerAlliedToAllCharacters()
			endif
		endmethod
		
		/**
		 * Kuno gives the characters a cart with lumber.
		 * It is owned by \ref MapData.alliedPlayer and has to be moved to the camp.
		 * Whenever it is killed a new one spawns at Kuno's house.
		 * It is checked periodically if it is killed.
		 */
		public method enableMoveKunosLumberToTheCamp takes nothing returns nothing
			call this.questItem(thistype.questItemReportKuno).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemMoveKunosLumberToTheCamp).setState(thistype.stateNew)
			call this.displayUpdate()
			
			// TODO enable respawn timer
			set this.m_kunosCart = CreateUnit(MapData.alliedPlayer, 'h021', GetRectCenterX(gg_rct_quest_war_kuno), GetRectCenterY(gg_rct_quest_war_kuno), 0.0)
			set this.m_kunosCartSpawnTimer = CreateTimer()
			call TimerStart(this.m_kunosCartSpawnTimer, 20.0, true, function thistype.timerFunctionSpawnKunosCart)
			call Game.setAlliedPlayerAlliedToAllCharacters()
			call this.enableCartDestination()
		endmethod
		
		private static method stateEventCompletedMoveKunosLumberToTheCamp takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_war_cart_destination)
		endmethod
		
		private static method stateConditionCompletedMoveKunosLumberToTheCamp takes AQuestItem questItem returns boolean
			local thistype this = thistype.quest()
			return GetTriggerUnit() == this.m_kunosCart
		endmethod
		
		private static method stateActionCompletedMoveKunosLumberToTheCamp takes AQuestItem questItem returns nothing
			local thistype this = thistype.quest()
			call this.setupUnitAtDestination(this.m_kunosCart)
			call PauseTimer(this.m_kunosCartSpawnTimer)
			call DestroyTimer(this.m_kunosCartSpawnTimer)
			set this.m_kunosCartSpawnTimer = null
			set this.m_kunosCart = null
			call this.questItem(thistype.questItemLumberFromKuno).setState(thistype.stateCompleted)
			call this.displayUpdate()
		endmethod
		
		public method enablePlaceTraps takes nothing returns nothing
			call this.questItem(thistype.questItemPlaceTraps).setState(thistype.stateNew)
			call this.displayUpdate()
		endmethod
		
		/**
		 * Sold units are shared by all players.
		 * Then they can be moved to the camp.
		 */
		private static method triggerActionRecruit takes nothing returns nothing
			local thistype this = thistype.quest()
			call SetUnitOwner(GetSoldUnit(), MapData.alliedPlayer, true)
			call Game.setAlliedPlayerAlliedToAllCharacters()
			call this.displayUpdateMessage(tr("Knecht angeworben."))
			call PingMinimapEx(GetUnitX(GetSoldUnit()), GetUnitY(GetSoldUnit()), 5.0, 255, 255, 255, true)
			call this.enableCartDestination()
		endmethod
		
		/**
		 * The recruits can be bought by any player from a building at the farm.
		 * Whenever a recruit is bought its owner is changed to \ref MapData.alliedPlayer and it has to be moved to the camp until \ref thistype.maxRecruits units are at the camp.
		 */
		public method enableGetRecruits takes nothing returns nothing
			call this.questItem(thistype.questItemGetRecruits).setState(thistype.stateNew)
			call this.displayUpdate()
			set this.m_recruitBuilding = CreateUnit(MapData.alliedPlayer, 'n04F', GetRectCenterX(gg_rct_quest_war_recruit_building), GetRectCenterY(gg_rct_quest_war_recruit_building), 0.0)
			set this.m_recruitTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_recruitTrigger, this.m_recruitBuilding, EVENT_UNIT_SELL)
			call TriggerAddAction(this.m_recruitTrigger, function thistype.triggerActionRecruit)
		endmethod
		
		private static method stateEventCompletedGetRecruits takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_war_cart_destination)
		endmethod
		
		private static method stateConditionCompletedGetRecruits takes AQuestItem questItem returns boolean
			local thistype this = thistype.quest()
			if (GetUnitTypeId(GetTriggerUnit()) == 'n02J' and GetOwningPlayer(GetTriggerUnit()) == MapData.alliedPlayer) then
				call this.setupUnitAtDestination(GetTriggerUnit())
				set this.m_recruitCounter = this.m_recruitCounter + 1
				
				call this.displayUpdateMessage(Format(tr("%1%/%2% Rekruten")).i(this.m_recruitCounter).i(thistype.maxRecruits).result())
				
				return this.m_recruitCounter == thistype.maxRecruits
			endif
			
			return false
		endmethod
		
		private static method stateActionCompletedGetRecruits takes AQuestItem questItem returns nothing
			local thistype this = thistype.quest()
			call this.questItem(thistype.questItemRecruit).setState(thistype.stateCompleted)
			call this.displayState()
		endmethod
		
		public stub method distributeRewards takes nothing returns nothing
			// TODO besonderer Gegenstand für die Klasse
			//call AAbstractQuest.distributeRewards()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(0, tr("Krieg"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNCallToArms.blp")
			call this.setDescription(tr("Um die bevorstehenden Angriffe der Orks und Dunkelelfen aufzuhalten, muss der eroberte Außenposten versorgt werden.  Außerdem müssen Fallen vor den Mauern aufgestellt werden, die es den Feinden erschweren, den Außenposten einzunehmen. Zusätzlich müssen auf dem Bauernhof kriegstaugliche Leute angeheuert werden."))
			call this.setReward(AAbstractQuest.rewardExperience, 1000)
			call this.setReward(AAbstractQuest.rewardGold, 500)

			// quest item questItemWeaponsFromWieland
			set questItem = AQuestItem.create(this, tr("Besorgt Waffen vom Schmied Wieland."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_wieland)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item questItemIronFromTheDrumCave
			set questItem = AQuestItem.create(this, tr("Besorgt Eisen aus der Trommelhöhle."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_iron_from_the_drum_cave)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item questItemMoveImpsToWieland
			set questItem = AQuestItem.create(this, tr("Bringt die Imps aus der Trommelhöhle zu Wieland."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedImps)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedImps)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedImps)
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_wieland)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// questItemWaitForWielandsWeapons = 3
			set questItem = AQuestItem.create(this, tr("Wartet bis Wieland die Waffen hergestellt hat."))
			
			
			// questItemMoveWielandWeaponsToTheCamp = 4
			set questItem = AQuestItem.create(this, tr("Bringt Wielands Waffen sicher zum Außenposten."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_cart_destination)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item questItemSupplyFromManfred
			set questItem = AQuestItem.create(this, tr("Besorgt Nahrung vom Bauern Manfred."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_manfred)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item questItemKillTheCornEaters
			set questItem = AQuestItem.create(this, tr("Vernichtet die Kornfresser."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedKillTheCornEaters)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedKillTheCornEaters)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedKillTheCornEaters)
			
			// quest item questItemReportManfred
			set questItem = AQuestItem.create(this, tr("Berichtet Manfred davon."))
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedReportManfred)
			
			// quest item questItemLumberFromKuno
			set questItem = AQuestItem.create(this, tr("Besorgt Holz vom Holzfäller Kuno."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_kuno)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// quest item questItemKillTheWitches
			set questItem = AQuestItem.create(this, tr("Vernichtet die Waldfurien."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedKillTheWitches)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedKillTheWitches)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedKillTheWitches)
			
			// quest item questItemReportKuno
			set questItem = AQuestItem.create(this, tr("Berichte Kuno davon."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_kuno)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item questItemMoveKunosLumberToTheCamp
			set questItem = AQuestItem.create(this, tr("Bringt Kunos Holz sicher zum Außenposten."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedMoveKunosLumberToTheCamp)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedMoveKunosLumberToTheCamp)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedMoveKunosLumberToTheCamp)
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_cart_destination)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item questItemTrapsFromBjoern
			set questItem = AQuestItem.create(this, tr("Besorgt Fallen vom Jäger Björn."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_bjoern)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item questItemPlaceTraps
			set questItem = AQuestItem.create(this, tr("Platziert die Fallen rund um den Außenposten."))
			
			// quest item questItemRecruit
			set questItem = AQuestItem.create(this, tr("Rekrutiert kriegstaugliche Leute auf dem Bauernhof."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_farm)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item questItemGetRecruits
			set questItem = AQuestItem.create(this, tr("Sammelt fünf Rekruten am Außenposten."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedGetRecruits)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedGetRecruits)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedGetRecruits)
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_cart_destination)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item questItemReportHeimrich
			set questItem = AQuestItem.create(this, tr("Berichtet Heimrich von Eurem Erfolg."))

			return this
		endmethod
	endstruct

endlibrary
