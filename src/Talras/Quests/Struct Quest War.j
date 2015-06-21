library StructMapQuestsQuestWar requires Asl, StructGameQuestArea, StructMapVideosVideoIronFromTheDrumCave, StructMapVideosVideoWieland, StructMapVideosVideoManfred

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
		public static constant integer questItemSupplyFromManfred = 2
		public static constant integer questItemKillTheCornEaters = 3
		public static constant integer questItemReportManfred = 4
		public static constant integer questItemLumberFromKuno = 5
		public static constant integer questItemKillTheWitches = 6
		public static constant integer questItemTrapsFromBjoern = 7
		public static constant integer questItemPlaceTraps = 8
		public static constant integer questItemRecruit = 9
		public static constant integer questItemGetRecruits = 10
		public static constant integer questItemReportHeimrich = 11
		public static constant integer maxImps = 4
		private QuestAreaWarWieland m_questAreaWieland
		private QuestAreaWarIronFromTheDrumCave m_questAreaIronFromTheDrumCave
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
			call this.displayUpdateMessage(tr("Neue Imps stehen zur Verfügung."))
		endmethod
		
		private static method stateEventCompletedImps takes AQuestItem questItem, trigger whichTrigger returns event
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_war_wieland)
			
			return null
		endmethod
		
		private static method stateConditionCompletedImps takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local integer i
			local integer counter = 0
			if (this.m_imps.units().contains(GetTriggerUnit())) then
				call SetUnitInvulnerable(GetTriggerUnit(), true)
				call PauseUnit(GetTriggerUnit(), true)
				set i = 0
				loop
					exitwhen (i == thistype.maxImps)
					if (GetTriggerUnit() != this.m_imps.units()[i] and RectContainsUnit(gg_rct_quest_war_wieland, this.m_imps.units()[i])) then
						set counter = counter + 1
					endif
					set i = i + 1
				endloop
				set counter = counter + 1 // entering unit
				
				call questItem.quest().displayUpdateMessage(Format(tr("%1%/%2% Imps.")).i(counter).i(thistype.maxImps).result())
				
				return counter == thistype.maxImps
			endif
			
			return false
		endmethod
		
		private static method groupFunctionRemove takes unit whichUnit returns nothing
			call RemoveUnit(whichUnit)
		endmethod

		private static method stateActionCompletedImps takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.m_imps.forGroup(thistype.groupFunctionRemove)
			call this.m_imps.destroy()
			set this.m_imps = 0
			call DmdfHashTable.global().destroyTimer(this.m_impSpawnTimer)
			set this.m_impSpawnTimer = null
			// TODO play video
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

		private static method stateConditionCompletedKillTheCornEaters takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local integer count0
			local integer count1
			if (GetUnitTypeId(GetTriggerUnit()) == UnitTypes.cornEater) then
				set count0 = SpawnPoints.cornEaters0().countUnitsOfType(UnitTypes.vampire)
				set count1 = SpawnPoints.cornEaters1().countUnitsOfType(UnitTypes.vampire)
				if (count0 == 0 and count1 == 0) then
					return true
				// get next one to ping
				else
					call questItem.quest().displayUpdateMessage(Format(tr("%1%/4 Kornfresser")).i(4 - count0 - count1).result())
					if (count0 > 0) then
						call this.setPingByUnitTypeId.execute(questItem, SpawnPoints.cornEaters0(), UnitTypes.cornEater)
					else
						call this.setPingByUnitTypeId.execute(questItem, SpawnPoints.cornEaters1(), UnitTypes.cornEater)
					endif
				endif
			endif
			return false
		endmethod
		
		private static method stateActionCompletedKillTheCornEaters takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			set this.m_questAreaReportManfred = QuestAreaWarReportManfred.create(gg_rct_quest_war_manfred)
		endmethod
		
		private static method stateActionCompletedReportManfred takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			local unit cart = CreateUnit(MapData.neutralPassivePlayer, 'h016', GetUnitX(Npcs.manfred()), GetUnitY(Npcs.manfred()), 0.0)
			call SetUnitInvulnerable(cart, true)
			call IssuePointOrder(cart, "move", GetRectCenterX(gg_rct_quest_war_cart_destination), GetRectCenterY(gg_rct_quest_war_cart_destination))
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
