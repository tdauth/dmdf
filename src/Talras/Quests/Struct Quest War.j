library StructMapQuestsQuestWar requires Asl, StructGameQuestArea, StructMapVideosVideoIronFromTheDrumCave, StructMapVideosVideoWeaponsFromWieland, StructMapVideosVideoWieland, StructMapVideosVideoManfred

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

	struct QuestWar extends AQuest
		public static constant integer questItemWeaponsFromWieland = 0
		public static constant integer questItemIronFromTheDrumCave = 1
		public static constant integer questItemMoveImpsToWieland = 2
		public static constant integer questItemSupplyFromManfred = 3
		public static constant integer questItemKillTheCornEaters = 4
		public static constant integer questItemReportManfred = 5
		public static constant integer questItemLumberFromKuno = 6
		public static constant integer questItemKillTheWitches = 7
		public static constant integer questItemTrapsFromBjoern = 8
		public static constant integer questItemPlaceTraps = 9
		public static constant integer questItemRecruit = 10
		public static constant integer questItemGetRecruits = 11
		public static constant integer questItemReportHeimrich = 12
		public static constant integer maxImps = 4
		private QuestAreaWarWieland m_questAreaWieland
		private QuestAreaWarIronFromTheDrumCave m_questAreaIronFromTheDrumCave
		private QuestAreaWarImpTarget m_questAreaImpTarget
		private QuestAreaWarManfred m_questAreaManfred
		private QuestAreaWarReportManfred m_questAreaReportManfred
		private timer m_impSpawnTimer
		private AGroup m_imps

		implement Quest

		public stub method enable takes nothing returns boolean
			local boolean result = this.setState(thistype.stateNew)
			set this.m_questAreaWieland = QuestAreaWarWieland.create(gg_rct_quest_war_wieland)
			set this.m_questAreaManfred = QuestAreaWarManfred.create(gg_rct_quest_war_manfred)
			call this.questItem(thistype.questItemWeaponsFromWieland).setState(thistype.stateNew)
			call this.questItem(thistype.questItemSupplyFromManfred).setState(thistype.stateNew)
			call this.questItem(thistype.questItemLumberFromKuno).setState(thistype.stateNew)
			call this.questItem(thistype.questItemTrapsFromBjoern).setState(thistype.stateNew)
			call this.questItem(thistype.questItemRecruit).setState(thistype.stateNew)
			
			call this.displayState()

			return result
		endmethod
		
		public method enableIronFromTheDrumCave takes nothing returns nothing
			set this.m_questAreaIronFromTheDrumCave = QuestAreaWarIronFromTheDrumCave.create(gg_rct_quest_war_iron_from_the_drum_cave)
			call QuestWar.quest().questItem(QuestWar.questItemIronFromTheDrumCave).enable()
		endmethod
		
		private static method timerFunctionSpawnImps takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetExpiredTimer(), "this")
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
			call DmdfHashTable.global().setHandleInteger(this.m_impSpawnTimer, "this", this)
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
			call this.displayUpdate()
			call this.displayUpdateMessage(tr("Neue Imps stehen zur Verfügung."))
		endmethod
		
		private static method stateEventCompletedImps takes AQuestItem questItem, trigger whichTrigger returns event
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_war_wieland)
			
			return null
		endmethod
		
		/**
		 * Whenever an Imp reaches Wieland he will be paused and made invulnerable.
		 * If all Imps (\ref thistype.maxImps) have reached their target the quest item will be completed.
		 */
		private static method stateConditionCompletedImps takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local integer i
			local integer counter = 0
			if (this.m_imps.units().contains(GetTriggerUnit())) then
				debug call Print("Is imp!")
				call SetUnitInvulnerable(GetTriggerUnit(), true)
				call PauseUnit(GetTriggerUnit(), true)
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

		private static method stateActionCompletedImps takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			local unit cart
			/*
			 * Cleanup Imps.
			 * TODO Do something funny!
			 */
			call this.m_imps.forGroup(thistype.groupFunctionRemove)
			call this.m_imps.destroy()
			set this.m_imps = 0
			call DmdfHashTable.global().destroyTimer(this.m_impSpawnTimer)
			set this.m_impSpawnTimer = null
			call this.m_questAreaImpTarget.destroy()
			
			call VideoWeaponsFromWieland.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			
			/*
			 * TODO Would be much cooler when the Imps take weapons to the former Orc camp.
			 */
			call this.questItem(thistype.questItemWeaponsFromWieland).setState(thistype.stateCompleted)
			call this.displayUpdate()
			 
			set cart = CreateUnit(MapData.neutralPassivePlayer, 'h020', GetUnitX(Npcs.wieland()), GetUnitY(Npcs.wieland()), 0.0)
			call SetUnitInvulnerable(cart, true)
			call IssuePointOrder(cart, "move", GetRectCenterX(gg_rct_quest_war_cart_destination), GetRectCenterY(gg_rct_quest_war_cart_destination))
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
			set questItem = AQuestItem.create(this, tr("Sammelt die Rekruten am Außenposten."))
			
			// quest item questItemReportHeimrich
			set questItem = AQuestItem.create(this, tr("Berichtet Heimrich von Eurem Erfolg."))

			return this
		endmethod
	endstruct

endlibrary
