/*
 * TODO
 Wigberht: Folgt mir Männer. Wir müssen ihre Belagerungswaffen zerstören!
 */
library StructMapQuestsQuestTheDefenseOfTalras requires Asl, StructMapQuestsQuestTheWayToHolzbruck, StructMapVideosVideoHolzbruck, StructMapQuestsQuestTheNorsemen, StructMapQuestsQuestWar

	struct QuestAreaQuestTheDefenseOfTalras extends QuestArea
	
		public stub method onCheck takes nothing returns boolean
			return QuestTheDefenseOfTalras.quest.evaluate().isNew()
		endmethod
	
		public stub method onStart takes nothing returns nothing
			//call VideoUpstream.video().play()
			// TEST
			call QuestTheDefenseOfTalras.quest.evaluate().enableTimer.evaluate()
		endmethod
	
		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct

	/*
	 * TODO
	 * A battle with Wigberht, Ricman, Dragon Slayer and some characters helping out, Tobias and Haldar and Baldar.
	 */
	struct QuestTheDefenseOfTalras extends AQuest
		public static constant integer questItemMoveToCamp = 0
		public static constant integer questItemPrepare = 1
		public static constant integer questItemDefendAgainstOrcs = 2
		public static constant integer maxOrcWaves = 5
		private QuestAreaQuestTheDefenseOfTalras m_questArea
		// TEST Finish the quest after 20 seconds, temporary solution.
		private timer m_timer
		private timerdialog m_timerDialog
		private unit m_recruitBuilding
		private unit m_shop
		private AGroup m_recruits
		private AGroup m_warriors
		private AGroup m_siege
		private AGroup m_orcs
		private integer m_orcWavesCounter
		
		implement Quest
		
		private static method timerFunctionOrcWave takes nothing returns nothing
			local thistype this = thistype.quest()
			set this.m_orcWavesCounter = this.m_orcWavesCounter + 1
			call this.m_warriors.addGroup(CreateUnitsAtRect(5, 'n019', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_0, 90.0), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(5, 'n019', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_1, 90.0), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(5, 'n019', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_2, 90.0), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(5, 'n019', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_3, 90.0), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(5, 'n019', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_4, 90.0), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(5, 'n019', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_5, 90.0), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(5, 'n019', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_6, 90.0), true, false)
			call this.m_warriors.pointOrder("attack", GetRectCenterX(gg_rct_quest_the_defense_of_talras_orc_target), GetRectCenterY(gg_rct_quest_the_defense_of_talras_orc_target))
			
			if (this.m_orcWavesCounter < thistype.maxOrcWaves) then
				call this.startTimer.evaluate()
			else
				// FIXME Create orc siege stuff
			endif
		endmethod
		
		private method startTimer takes nothing returns nothing
			if (this.m_timer == null) then
				set this.m_timer = CreateTimer()
			endif
			call TimerStart(this.m_timer, 20.0, false, function thistype.timerFunctionOrcWave)
			if (this.m_timerDialog == null) then
				set this.m_timerDialog = CreateTimerDialog(this.m_timer)
			endif
			call TimerDialogSetTitle(this.m_timerDialog, tr("Ork-Welle:"))
			call TimerDialogDisplay(this.m_timerDialog, true)
		endmethod
		
		public method enableDefendAgainstOrcs takes nothing returns nothing
			set this.m_orcs = AGroup.create()
			call this.questItem(thistype.questItemDefendAgainstOrcs).enable()
			set this.m_orcWavesCounter = 0
			
			call this.startTimer()
		endmethod
		
		private static method timerFunctionFinish takes nothing returns nothing
			local thistype this = thistype.quest()
			call this.questItem(thistype.questItemPrepare).setState(thistype.stateCompleted)
			call this.enableDefendAgainstOrcs()
		endmethod
		
		public method enableTimer takes nothing returns nothing
			call QuestTheNorsemen.quest().cleanFinalNorsemen()
			call QuestWar.quest().cleanUnits()
		
			/*
			 * Setup the camp.
			 */
			set this.m_recruitBuilding = CreateUnitAtRect(MapData.alliedPlayer, 'n04Q', gg_rct_quest_the_defense_of_talras_recruit_building, 196.87)
			set this.m_shop = CreateUnitAtRect(MapData.alliedPlayer, 'n04Y', gg_rct_quest_the_defense_of_talras_shop, 196.87)
			set this.m_recruits = AGroup.create()
			call this.m_recruits.addGroup(CreateUnitsAtRect(5, 'n04P', MapData.alliedPlayer, gg_rct_quest_the_defense_of_talras_recruits, 270.0), true, false)
			 
			set this.m_warriors = AGroup.create()
			call this.m_warriors.addGroup(CreateUnitsAtRect(5, 'n015', MapData.alliedPlayer, gg_rct_quest_the_defense_of_talras_warriors, 270.0), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(5, 'n005', MapData.alliedPlayer, gg_rct_quest_the_defense_of_talras_warriors, 270.0), true, false)
			 
			set this.m_siege = AGroup.create()
			call this.m_siege.addGroup(CreateUnitsAtRect(2, 'n007', MapData.alliedPlayer, gg_rct_quest_the_defense_of_talras_siege, 270.0), true, false)
			 
			call Fellows.dragonSlayer().shareWith(0)
			call SetUnitPositionRect(Fellows.dragonSlayer().unit(), gg_rct_quest_the_defense_of_talras_dragon_slayer)
			call SetUnitFacing(Fellows.dragonSlayer().unit(), 270.0)
			
			call Fellows.wigberht().shareWith(0)
			call SetUnitPositionRect(Fellows.wigberht().unit(), gg_rct_quest_the_defense_of_talras_wigberht)
			call SetUnitFacing(Fellows.wigberht().unit(), 270.0)
			
			call Fellows.ricman().shareWith(0)
			call SetUnitPositionRect(Fellows.ricman().unit(), gg_rct_quest_the_defense_of_talras_ricman)
			call SetUnitFacing(Fellows.ricman().unit(), 270.0)
			
			call AdjustPlayerStateBJ(20000, MapData.alliedPlayer, PLAYER_STATE_RESOURCE_GOLD)
		
			if (this.m_timer == null) then
				set this.m_timer = CreateTimer()
			endif
			call TimerStart(this.m_timer, 180.0, false, function thistype.timerFunctionFinish)
			if (this.m_timerDialog == null) then
				set this.m_timerDialog = CreateTimerDialog(this.m_timer)
			endif
			call TimerDialogSetTitle(this.m_timerDialog, tr("Vorbereitung:"))
			call TimerDialogDisplay(this.m_timerDialog, true)
			
			call this.questItem(thistype.questItemMoveToCamp).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemPrepare).enable()
		endmethod
		
		public stub method enable takes nothing returns boolean
			set this.m_questArea = QuestAreaQuestTheDefenseOfTalras.create(gg_rct_quest_the_defense_of_talras)
			return super.enableUntil(thistype.questItemMoveToCamp)
		endmethod
		
		private static method stateActionCompleted takes thistype this returns nothing
			debug call Print("Before finish")
			call VideoHolzbruck.video().play()
			debug call Print("After finish")
			call waitForVideo(MapData.videoWaitInterval)
			debug call Print("After wait")
			call QuestTheWayToHolzbruck.quest().enable()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(0, tr("Die Verteidigung von Talras"))
			local AQuestItem questItem
			set this.m_timer = null
			set this.m_timerDialog = null
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNGuardTower.blp")
			call this.setDescription(tr("Ein Teil der Armee der Orks und Dunkelelfen ist in Talras eingetroffen. Verteidigt Talras um jeden Preis gegen die Horden der Orks und Dunkelelfen."))
			call this.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted)
			// item 0
			set questItem = AQuestItem.create(this, tr("Begebt euch zum Außenposten und beginnt mit der Verteidigung."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_defense_of_talras)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 1000)
			
			// item 1
			set questItem = AQuestItem.create(this, tr("Baut eine Verteidigung auf."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_defense_of_talras)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 1000)
			
			// item 2
			set questItem = AQuestItem.create(this, tr("Verteidigt euch gegen die Orks."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_defense_of_talras)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 1000)
			
			return this
		endmethod
	endstruct

endlibrary
