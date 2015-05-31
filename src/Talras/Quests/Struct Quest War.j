library StructMapQuestsQuestWar requires Asl, StructGameQuestArea, StructMapVideosVideoIronFromTheDrumCave, StructMapVideosVideoWieland

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

	struct QuestWar extends AQuest
		public static constant integer questItemWeaponsFromWieland = 0
		public static constant integer questItemIronFromTheDrumCave = 1
		public static constant integer questItemSupplyFromManfred = 2
		public static constant integer questItemKillTheCornEaters = 3
		public static constant integer questItemLumberFromKuno = 4
		public static constant integer questItemKillTheWitches = 5
		public static constant integer questItemTrapsFromBjoern = 6
		public static constant integer questItemPlaceTraps = 7
		public static constant integer questItemRecruit = 8
		public static constant integer questItemGetRecruits = 9
		public static constant integer questItemReportHeimrich = 10
		public static constant integer maxImps = 4
		private QuestAreaWarWieland m_questAreaWieland
		private QuestAreaWarIronFromTheDrumCave m_questAreaIronFromTheDrumCave
		private timer m_impSpawnTimer
		private AGroup m_imps

		implement Quest

		public stub method enable takes nothing returns boolean
			local boolean result = super.enable()
			set this.m_questAreaWieland = QuestAreaWarWieland.create(gg_rct_quest_war_wieland)
			call this.questItem(thistype.questItemWeaponsFromWieland).setState(thistype.stateNew)
			call this.questItem(thistype.questItemSupplyFromManfred).setState(thistype.stateNew)
			call this.questItem(thistype.questItemLumberFromKuno).setState(thistype.stateNew)
			call this.questItem(thistype.questItemTrapsFromBjoern).setState(thistype.stateNew)
			call this.questItem(thistype.questItemRecruit).setState(thistype.stateNew)

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

			// quest item 0
			set questItem = AQuestItem.create(this, tr("Besorgt Waffen vom Schmied Wieland."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_wieland)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// quest item 1
			set questItem = AQuestItem.create(this, tr("Besorgt Eisen aus der Trommelhöhle."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedImps)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedImps)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedImps)
			
			// quest item 2
			set questItem = AQuestItem.create(this, tr("Besorgt Nahrung vom Bauern Manfred."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_manfred)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item 3
			set questItem = AQuestItem.create(this, tr("Vernichtet die Kornfresser."))
			
			// quest item 4
			set questItem = AQuestItem.create(this, tr("Besorgt Holz vom Holzfäller Kuno."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_kuno)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item 5
			set questItem = AQuestItem.create(this, tr("Vernichtet die Waldfurien."))
			
			// quest item 6
			set questItem = AQuestItem.create(this, tr("Besorgt Fallen vom Jäger Björn."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_bjoern)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item 7
			set questItem = AQuestItem.create(this, tr("Platziert die Fallen rund um den Außenposten."))
			
			// quest item 8
			set questItem = AQuestItem.create(this, tr("Rekrutiert kriegstaugliche Leute auf dem Bauernhof."))
			
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_farm)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// quest item 9
			set questItem = AQuestItem.create(this, tr("Sammelt die Rekruten am Außenposten."))
			
			// quest item 10
			set questItem = AQuestItem.create(this, tr("Berichtet Heimrich von Eurem Erfolg."))

			return this
		endmethod
	endstruct

endlibrary
