/*
 * TODO
 Wigberht: Folgt mir Männer. Wir müssen ihre Belagerungswaffen zerstören!

 Drachentöterin: Auf ihr Hochelfen, ihr Brüder und Schwestern! Für König Dararos!
 */
library StructMapQuestsQuestTheDefenseOfTalras requires Asl, StructMapQuestsQuestTheWayToHolzbruck, StructMapVideosVideoTheDefenseOfTalras, StructMapVideosVideoVictory, StructMapVideosVideoHolzbruck, StructMapQuestsQuestTheNorsemen, StructMapQuestsQuestWar

	struct QuestAreaQuestTheDefenseOfTalras extends QuestArea

		public stub method onCheck takes nothing returns boolean
			return QuestTheDefenseOfTalras.quest.evaluate().isNew()
		endmethod

		public stub method onStart takes nothing returns nothing
			call QuestTheNorsemen.quest().cleanFinalNorsemen()
			call QuestWar.quest().cleanUnits()

			call VideoTheDefenseOfTalras.video().play()
			call waitForVideo(Game.videoWaitInterval)

			call QuestTheDefenseOfTalras.quest.evaluate().enableTimer.evaluate()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	struct QuestAreaQuestTheDefenseOfTalrasGather extends QuestArea

		public stub method onStart takes nothing returns nothing
			call QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemGatherAtTheCamp).complete()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	struct QuestAreaQuestTheDefenseOfTalrasGatherAgain extends QuestArea

		public stub method onStart takes nothing returns nothing
			call QuestTheDefenseOfTalras.quest.evaluate().questItem(QuestTheDefenseOfTalras.questItemGatherAtTheCampAgain).complete()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	struct QuestAreaQuestTheDefenseOfTalrasReportHeimrich extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoHolzbruck.video().play()
			debug call Print("After finish")
			call waitForVideo(Game.videoWaitInterval)
			debug call Print("After wait")
			call QuestTheDefenseOfTalras.quest.evaluate().complete()
			call QuestTheWayToHolzbruck.quest().enable()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	/*
	 * TODO
	 * A battle with Wigberht, Ricman, Dragon Slayer and the arriving Dararos.
	 * You fight waves of Orcs and Dark Elves, destroy their artillery and finally their commander with the help of Dararos.
	 */
	struct QuestTheDefenseOfTalras extends SharedQuest
		public static constant integer questItemMoveToCamp = 0
		public static constant integer questItemPrepare = 1
		public static constant integer questItemDefendAgainstOrcs = 2
		public static constant integer questItemDestroyArtillery = 3
		public static constant integer questItemGatherAtTheCamp = 4
		public static constant integer questItemDefeatTheEnemy = 5
		public static constant integer questItemGatherAtTheCampAgain = 6
		public static constant integer questItemReportHeimrich = 7
		public static constant integer maxOrcWaves = 5
		private QuestAreaQuestTheDefenseOfTalras m_questArea

		private timer m_timer
		private timerdialog m_timerDialog

		private timer m_orcWavesTimer
		private timerdialog m_orcWavesTimerDialog

		private unit m_recruitBuilding
		private unit m_shop
		private AGroup m_recruits
		private AGroup m_warriors
		private AGroup m_siege

		private trigger m_spawnDogsTrigger

		// questItemDefendAgainstOrcs
		private AGroup m_orcs
		private integer m_orcWavesCounter

		// questItemDestroyArtillery
		private AGroup m_orcSiege
		private AGroup m_orcSiegeWarriors
		private AGroup m_orcWall

		// questItemGatherAtTheCamp
		private QuestAreaQuestTheDefenseOfTalrasGather m_questAreaGather

		// questItemDefeatTheEnemy
		private AGroup m_highElves
		private AGroup m_finalOrcs

		// questItemGatherAtTheCampAgain
		private QuestAreaQuestTheDefenseOfTalrasGatherAgain m_questAreaGatherAgain

		// questItemReportHeimrich
		private QuestAreaQuestTheDefenseOfTalrasReportHeimrich m_questAreaReportHeimrich

		private static method stateEventCompletedDefendAgainstOrcs takes AQuestItem whichQuestItem, trigger whichTrigger returns nothing
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DEATH)
		endmethod

		private static method stateConditionCompletedDefendAgainstOrcs takes AQuestItem whichQuestItem returns boolean
			local thistype this = thistype(whichQuestItem.quest())
			if (this.m_orcs.units().contains(GetTriggerUnit())) then
				call this.m_orcs.units().remove(GetTriggerUnit())

				if (this.m_orcs.units().empty() and this.m_orcWavesCounter == thistype.maxOrcWaves) then
					return true
				endif
			endif
			return false
		endmethod

		private static method stateActionCompletedDefendAgainstOrcs takes AQuestItem whichQuestItem returns nothing
			local thistype this = thistype(whichQuestItem.quest())
			call this.enableOrcArtillery.evaluate()
		endmethod

		private static method stateEventCompletedDestroyArtillery takes AQuestItem whichQuestItem, trigger whichTrigger returns nothing
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DEATH)
		endmethod

		private static method stateConditionCompletedDestroyArtillery takes AQuestItem whichQuestItem returns boolean
			local thistype this = thistype(whichQuestItem.quest())
			if (this.m_orcSiege.units().contains(GetTriggerUnit())) then
				call this.m_orcSiege.units().remove(GetTriggerUnit())
				call this.displayUpdateMessage(Format(trpe("%1% Belagerungswaffe verbleibt.", "%1% Belagerungswaffen verbleiben.", "%1% siege weapon remains.", "%1% siege weapons remain.", this.m_orcSiege.units().size())).i(this.m_orcSiege.units().size()).result())

				return this.m_orcSiege.units().empty()
			endif

			return false
		endmethod

		private static method stateActionCompletedDestroyArtillery takes AQuestItem whichQuestItem returns nothing
			local thistype this = thistype(whichQuestItem.quest())

			// remove annoying orc wall
			call this.m_orcWall.forGroup(thistype.forGroupKill)
			call this.m_orcWall.destroy()
			call this.m_orcSiege.destroy()
			call this.m_orcSiegeWarriors.destroy()

			set this.m_questAreaGather = QuestAreaQuestTheDefenseOfTalrasGather.create(gg_rct_quest_the_defense_of_talras)
			call this.questItem(thistype.questItemGatherAtTheCamp).setState(thistype.stateNew)
			call this.displayState()
		endmethod

		private static method stateActionCompletedGatherAtTheCamp takes AQuestItem whichQuestItem returns nothing
			local thistype this = thistype(whichQuestItem.quest())

			call Npcs.initDararos(CreateUnit(MapSettings.alliedPlayer(), 'H02F', GetRectCenterX(gg_rct_quest_the_defense_of_talras_dararos), GetRectCenterY(gg_rct_quest_the_defense_of_talras_dararos), 0.0))
			call SetHeroLevel(Npcs.dararos(), 30, false)
			call Fellows.initDararos(Npcs.dararos())

			call VideoDararos.video().play()
			call waitForVideo(Game.videoWaitInterval)

			call Fellows.dararos().shareWithAll()

			 set this.m_highElves = AGroup.create()

			 call this.m_highElves.addGroup(CreateUnitsAtRect(12, 'n05I', MapSettings.alliedPlayer(), gg_rct_quest_the_defense_of_talras_high_elf_archers, 0.0), true, false)
			 call this.m_highElves.addGroup(CreateUnitsAtRect(12, 'h02H', MapSettings.alliedPlayer(), gg_rct_quest_the_defense_of_talras_high_elf_warriors, 0.0), true, false)

			 /*
			  * TODO Create the final orcs from everywhere
			  */
			set this.m_finalOrcs = AGroup.create()

			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n058', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_0, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_0, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05L', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_0, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05H', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_0, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(2, 'n059', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_0, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05J', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_0, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05K', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_0, 90.0), true, false)

			// The ultimate Orc boss
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(1, 'o005', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_0, 90.0), true, false)

			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n058', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_1, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_1, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05L', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_1, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05H', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_1, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(2, 'n059', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_1, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05J', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_1, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05K', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_1, 90.0), true, false)

			// The ultimate Orc summoner
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(1, 'o006', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_1, 90.0), true, false)

			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n058', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_2, 180.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_2, 180.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05L', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_2, 180.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05H', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_2, 180.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(2, 'n059', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_2, 180.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05J', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_2, 180.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05K', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_2, 180.0), true, false)

			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n058', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_3, 180.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_3, 180.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05L', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_3, 180.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05H', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_3, 180.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(2, 'n059', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_3, 180.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05J', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_3, 180.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05K', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_3, 180.0), true, false)

			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n058', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_4, 270.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_4, 270.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05L', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_4, 270.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05H', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_4, 270.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(2, 'n059', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_4, 270.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05J', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_4, 270.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05K', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_4, 270.0), true, false)

			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n058', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_5, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_5, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05L', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_5, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05H', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_5, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(2, 'n059', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_5, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05J', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_5, 90.0), true, false)
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(4, 'n05K', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_5, 90.0), true, false)

			// The ultimate Dark Elves boss
			call this.m_finalOrcs.addGroup(CreateUnitsAtRect(1, 'n06F', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_final_orcs_5, 90.0), true, false)

			call this.m_finalOrcs.pointOrder("attack", GetRectCenterX(gg_rct_quest_the_defense_of_talras_orc_target), GetRectCenterY(gg_rct_quest_the_defense_of_talras_orc_target))

			call this.questItem(thistype.questItemDefeatTheEnemy).setState(thistype.stateNew)
			call this.displayState()

			call Character.displayUnitAcquiredToAll(tre("Dararos", "Dararos"), tre("Dararos ist der König der Hochelfen. Er ist ein mächtiger Zauberer.", "Dararos is the king of the High Elves. He is a powerful wizard."))
		endmethod

		public method finishDefeatTheEnemy takes nothing returns nothing
			if (this.m_finalOrcs == 0) then
				return
			endif
			call this.m_finalOrcs.forGroup(thistype.forGroupKill)
		endmethod

		private static method stateEventCompletedDefeatTheEnemy takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DEATH)
		endmethod

		private static method stateConditionCompletedDefeatTheEnemy takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			if (this.m_finalOrcs.units().contains(GetTriggerUnit())) then
				call this.m_finalOrcs.units().remove(GetTriggerUnit())
				debug call Print("Remaining final orcs: " + I2S(this.m_finalOrcs.units().size()))

				return this.m_finalOrcs.units().empty()
			endif

			return false
		endmethod

		private static method forGroupRemoveUnit takes unit whichUnit returns nothing
			call RemoveUnit(whichUnit)
		endmethod

		private static method stateActionCompletedDefeatTheEnemy takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.m_highElves.forGroup(thistype.forGroupRemoveUnit)
			call this.m_highElves.destroy()
			set this.m_highElves = 0
			call this.m_finalOrcs.destroy()
			set this.m_finalOrcs = 0

			set this.m_questAreaGatherAgain = QuestAreaQuestTheDefenseOfTalrasGatherAgain.create(gg_rct_quest_the_defense_of_talras)

			call this.questItem(thistype.questItemGatherAtTheCampAgain).setState(thistype.stateNew)
			call this.displayState()
		endmethod

		private static method stateActionCompletedGatherAtTheCampAgain takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			local unit guard

			call VideoVictory.video().play()
			call waitForVideo(Game.videoWaitInterval)

			call Fellows.ricman().reset()
			call Fellows.wigberht().reset()
			call Fellows.dragonSlayer().reset()

			call RemoveUnit(this.m_recruitBuilding)
			set this.m_recruitBuilding = null
			call RemoveUnit(this.m_shop)
			set this.m_shop = null

			call SetUnitX(Npcs.wigberht(), GetRectCenterX(gg_rct_waypoint_wigberht_training))
			call SetUnitY(Npcs.wigberht(), GetRectCenterY(gg_rct_waypoint_wigberht_training))

			call SetUnitX(Npcs.ricman(), GetRectCenterX(gg_rct_waypoint_ricman))
			call SetUnitY(Npcs.ricman(), GetRectCenterY(gg_rct_waypoint_ricman))


			/*
			 * Build up a camp with high elves and dararos.
			 */
			call Fellows.dararos().reset()

			call SetUnitPositionRectFacing(Npcs.dragonSlayer(), gg_rct_quest_the_defense_of_talras_camp_dragon_slayer, 270.0)
			call SetUnitPositionRectFacing(Npcs.dararos(), gg_rct_quest_the_defense_of_talras_camp_dararos, 270.0)

			call NpcRoutines.initDararosAndDragonSlayer()
			call AUnitRoutine.manualStart(Npcs.dararos())
			call AUnitRoutine.manualStart(Npcs.dragonSlayer())

			set guard = CreateUnitAtRect(MapSettings.neutralPassivePlayer(), 'h02H', gg_rct_quest_the_defense_of_talras_camp_guard_0, 0.0)
			call SetUnitInvulnerable(guard, true)
			set guard = CreateUnitAtRect(MapSettings.neutralPassivePlayer(), 'h02H', gg_rct_quest_the_defense_of_talras_camp_guard_1, 0.0)
			call SetUnitInvulnerable(guard, true)
			set guard = CreateUnitAtRect(MapSettings.neutralPassivePlayer(), 'h02H', gg_rct_quest_the_defense_of_talras_camp_guard_2, 270.0)
			call SetUnitInvulnerable(guard, true)
			set guard = CreateUnitAtRect(MapSettings.neutralPassivePlayer(), 'h02H', gg_rct_quest_the_defense_of_talras_camp_guard_3, 270.0)
			call SetUnitInvulnerable(guard, true)
			set guard = CreateUnitAtRect(MapSettings.neutralPassivePlayer(), 'h02H', gg_rct_quest_the_defense_of_talras_camp_guard_4, 0.0)
			call SetUnitInvulnerable(guard, true)
			set guard = CreateUnitAtRect(MapSettings.neutralPassivePlayer(), 'h02H', gg_rct_quest_the_defense_of_talras_camp_guard_5, 180.0)
			call SetUnitInvulnerable(guard, true)
			set guard = CreateUnitAtRect(MapSettings.neutralPassivePlayer(), 'h02H', gg_rct_quest_the_defense_of_talras_camp_guard_6, 90.0)
			call SetUnitInvulnerable(guard, true)
			set guard = CreateUnitAtRect(MapSettings.neutralPassivePlayer(), 'n05I', gg_rct_quest_the_defense_of_talras_camp_guard_7, 270.0)
			call SetUnitInvulnerable(guard, true)
			set guard = CreateUnitAtRect(MapSettings.neutralPassivePlayer(), 'h02H', gg_rct_quest_the_defense_of_talras_camp_guard_8, 270.0)
			call SetUnitInvulnerable(guard, true)
			set guard = CreateUnitAtRect(MapSettings.neutralPassivePlayer(), 'n05I', gg_rct_quest_the_defense_of_talras_camp_guard_9, 270.0)
			call SetUnitInvulnerable(guard, true)

			set this.m_questAreaReportHeimrich = QuestAreaQuestTheDefenseOfTalrasReportHeimrich.create(gg_rct_quest_the_defense_of_talras_heimrich)
			call this.questItem(thistype.questItemReportHeimrich).setState(thistype.stateNew)
			call this.displayState()
		endmethod

		private method enableOrcArtillery takes nothing returns nothing
			call this.createOrcArtillery.evaluate() // OpLimit

			call this.questItem(thistype.questItemDefendAgainstOrcs).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemDestroyArtillery).setState(thistype.stateNew)
			call this.displayState()
		endmethod

		private method createOrcArtillery takes nothing returns nothing
			set this.m_orcSiege = AGroup.create()
			call this.m_orcSiege.addGroup(CreateUnitsAtRect(1, 'o003', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_trebuchet_0, 180.0), true, false)
			call this.m_orcSiege.addGroup(CreateUnitsAtRect(1, 'o003', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_trebuchet_1, 180.0), true, false)
			call this.m_orcSiege.pointOrder("attackground", GetRectCenterX(gg_rct_quest_the_defense_of_talras), GetRectCenterY(gg_rct_quest_the_defense_of_talras))
			set this.m_orcSiegeWarriors = AGroup.create()
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n058', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_spawn_0, 180.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05J', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_spawn_0, 180.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05K', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_spawn_0, 180.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05H', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_spawn_0, 180.0), true, false)

			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n058', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_spawn_1, 180.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05J', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_spawn_1, 180.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05K', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_spawn_1, 180.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05H', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_spawn_1, 180.0), true, false)

			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n058', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_spawn_2, 180.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05J', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_spawn_2, 180.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05K', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_spawn_2, 180.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05H', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_spawn_2, 180.0), true, false)
			// FIXME Create orc siege stuff


			// orc crossbow men behind the wall
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_crossbow_men_0, 180.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_crossbow_men_1, 180.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_crossbow_men_2, 180.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_crossbow_men_3, 270.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_crossbow_men_4, 0.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_crossbow_men_5, 0.0), true, false)
			call this.m_orcSiegeWarriors.addGroup(CreateUnitsAtRect(4, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_crossbow_men_6, 0.0), true, false)

			// orc wall
			set this.m_orcWall = AGroup.create()
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_0, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_1, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_2, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_3, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_4, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_5, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_6, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_7, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_8, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_9, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_10, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_11, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_12, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_13, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_14, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_15, 180.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_16, 180.0), true, false)

			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_0_bottom, 270.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_1_bottom, 270.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_2_bottom, 270.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_3_bottom, 270.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_4_bottom, 270.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_5_bottom, 270.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_6_bottom, 270.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_7_bottom, 270.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_8_bottom, 270.0), true, false)


			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_0_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_1_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_2_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_3_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_4_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_5_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_6_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_7_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_8_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_9_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_10_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_11_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_12_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_13_right, 0.0), true, false)
			call this.m_orcWall.addGroup(CreateUnitsAtRect(1, 'h02G', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_siege_wall_14_right, 0.0), true, false)
		endmethod

		public method finishDestroyArtillery takes nothing returns nothing
			if (this.m_orcSiege == 0) then
				return
			endif

			call this.m_orcSiegeWarriors.forGroup(thistype.forGroupKill)
			call this.m_orcSiege.forGroup(thistype.forGroupKill)
			call this.m_orcWall.forGroup(thistype.forGroupKill)
		endmethod

		private static method forGroupIgnoreGuardsPosition takes unit whichUnit returns nothing
			call RemoveGuardPosition(whichUnit)
		endmethod

		private static method timerFunctionOrcWave takes nothing returns nothing
			local thistype this = thistype.quest.evaluate()
			local AGroup currentGroup = AGroup.create()
			set this.m_orcWavesCounter = this.m_orcWavesCounter + 1
			call currentGroup.addGroup(CreateUnitsAtRect(3, 'n058', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_0, 90.0), true, false)
			call currentGroup.addGroup(CreateUnitsAtRect(1, 'o004', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_0, 90.0), true, false)
			call currentGroup.addGroup(CreateUnitsAtRect(3, 'n058', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_1, 90.0), true, false)
			call currentGroup.addGroup(CreateUnitsAtRect(1, 'o004', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_1, 90.0), true, false)
			call currentGroup.addGroup(CreateUnitsAtRect(3, 'n058', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_2, 90.0), true, false)
			call currentGroup.addGroup(CreateUnitsAtRect(3, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_3, 90.0), true, false)
			call currentGroup.addGroup(CreateUnitsAtRect(3, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_4, 90.0), true, false)
			call currentGroup.addGroup(CreateUnitsAtRect(3, 'n05A', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_5, 90.0), true, false)
			call currentGroup.addGroup(CreateUnitsAtRect(2, 'n059', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_6, 90.0), true, false)
			call currentGroup.addGroup(CreateUnitsAtRect(1, 'o004', MapData.orcPlayer, gg_rct_quest_the_defense_of_talras_orc_spawn_6, 90.0), true, false)
			call currentGroup.forGroup(thistype.forGroupIgnoreGuardsPosition)
			call currentGroup.pointOrder("attack", GetRectCenterX(gg_rct_quest_the_defense_of_talras_orc_target), GetRectCenterY(gg_rct_quest_the_defense_of_talras_orc_target))

			call this.m_orcs.addOther(currentGroup)
			call currentGroup.destroy()
			set currentGroup = 0

			if (this.m_orcWavesCounter < thistype.maxOrcWaves) then
				call this.startOrcWavesTimer.evaluate()
			else
				call DestroyTimerDialog(this.m_orcWavesTimerDialog)
				set this.m_orcWavesTimerDialog = null
				call PauseTimer(this.m_orcWavesTimer)
				call DestroyTimer(this.m_orcWavesTimer)
				set this.m_orcWavesTimer = null
			endif
		endmethod

		private method startOrcWavesTimer takes nothing returns nothing
			if (this.m_orcWavesTimer == null) then
				set this.m_orcWavesTimer = CreateTimer()
			endif
			call TimerStart(this.m_orcWavesTimer, 40.0, false, function thistype.timerFunctionOrcWave)
			if (this.m_orcWavesTimerDialog == null) then
				set this.m_orcWavesTimerDialog = CreateTimerDialog(this.m_orcWavesTimer)
			endif
			call TimerDialogSetTitle(this.m_orcWavesTimerDialog, tre("Ork-Welle:", "Orc Wave:"))
			call TimerDialogDisplay(this.m_orcWavesTimerDialog, true)
		endmethod

		/*
		 * Enables the quest item to defend against the orcs and starts spawning orc waves.
		 */
		public method enableDefendAgainstOrcs takes nothing returns nothing
			set this.m_orcs = AGroup.create()
			call this.questItem(thistype.questItemDefendAgainstOrcs).enable()
			set this.m_orcWavesCounter = 0

			call StartSound(gg_snd_TheHornOfCenarius01)
			call thistype.timerFunctionOrcWave()
		endmethod

		private static method forGroupKill takes unit whichUnit returns nothing
			call KillUnit(whichUnit)
		endmethod

		public method finishDefendAgainstOrcs takes nothing returns nothing
			if (this.m_orcWavesTimer == null) then
				return
			endif
			set this.m_orcWavesCounter = thistype.maxOrcWaves - 1
			call PauseTimer(this.m_orcWavesTimer)
			call thistype.timerFunctionOrcWave()
			call this.m_orcs.forGroup(thistype.forGroupKill)
		endmethod

		private static method timerFunctionFinish takes nothing returns nothing
			local thistype this = thistype.quest.evaluate()

			call DestroyTimerDialog(this.m_timerDialog)
			set this.m_timerDialog = null
			call PauseTimer(this.m_timer)
			call DestroyTimer(this.m_timer)
			set this.m_timer = null

			call this.questItem(thistype.questItemPrepare).setState(thistype.stateCompleted)

			call this.enableDefendAgainstOrcs()
		endmethod

		/*
		 * Creates all allied units and starts the preparation timer.
		 */
		public method enableTimer takes nothing returns nothing
			local integer i

			call QuestWarTrapsFromBjoern.quest().placeTraps()

			/*
			 * This shrine is finally used here.
			 */
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call Shrines.orcCamp().enableForCharacter(ACharacter.playerCharacter(Player(i)), false)
				endif
				set i = i + 1
			endloop

			/*
			 * Setup the camp.
			 */
			set this.m_recruitBuilding = CreateUnitAtRect(MapSettings.alliedPlayer(), 'n04Q', gg_rct_quest_the_defense_of_talras_recruit_building, 196.87)
			set this.m_shop = CreateUnitAtRect(MapSettings.alliedPlayer(), 'n04Y', gg_rct_quest_the_defense_of_talras_shop, 196.87)
			set this.m_recruits = AGroup.create()
			call this.m_recruits.addGroup(CreateUnitsAtRect(5, 'n04P', MapSettings.alliedPlayer(), gg_rct_quest_the_defense_of_talras_recruits, 270.0), true, false)

			set this.m_warriors = AGroup.create()
			call this.m_warriors.addGroup(CreateUnitsAtRect(5, 'n015', MapSettings.alliedPlayer(), gg_rct_quest_the_defense_of_talras_warriors, 270.0), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(5, 'n005', MapSettings.alliedPlayer(), gg_rct_quest_the_defense_of_talras_warriors, 270.0), true, false)

			set this.m_siege = AGroup.create()
			call this.m_siege.addGroup(CreateUnitsAtRect(2, 'n007', MapSettings.alliedPlayer(), gg_rct_quest_the_defense_of_talras_siege, 270.0), true, false)

			call Fellows.dragonSlayer().shareWithAll()
			call SetUnitPositionRect(Fellows.dragonSlayer().unit(), gg_rct_quest_the_defense_of_talras_dragon_slayer)
			call SetUnitFacing(Fellows.dragonSlayer().unit(), 270.0)
			call SetHeroLevel(Fellows.dragonSlayer().unit(), 30, false)

			call Fellows.wigberht().shareWithAll()
			call SetUnitPositionRect(Fellows.wigberht().unit(), gg_rct_quest_the_defense_of_talras_wigberht)
			call SetUnitFacing(Fellows.wigberht().unit(), 270.0)
			call SetHeroLevel(Fellows.wigberht().unit(), 30, false)

			call Fellows.ricman().shareWithAll()
			call SetUnitPositionRect(Fellows.ricman().unit(), gg_rct_quest_the_defense_of_talras_ricman)
			call SetUnitFacing(Fellows.ricman().unit(), 270.0)
			call SetHeroLevel(Fellows.ricman().unit(), 30, false)

			/*
			 * The allied player needs a lot of gold to build something.
			 */
			call SetPlayerState( MapSettings.alliedPlayer(), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState( MapSettings.alliedPlayer(), PLAYER_STATE_RESOURCE_GOLD) + 3000)

			if (this.m_timer == null) then
				set this.m_timer = CreateTimer()
			endif
			call TimerStart(this.m_timer, 360.0, false, function thistype.timerFunctionFinish)
			if (this.m_timerDialog == null) then
				set this.m_timerDialog = CreateTimerDialog(this.m_timer)
			endif
			call TimerDialogSetTitle(this.m_timerDialog, tre("Vorbereitung:", "Preparation:"))
			call TimerDialogDisplay(this.m_timerDialog, true)

			call this.questItem(thistype.questItemMoveToCamp).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemPrepare).enable()

			call Character.displayUnitAcquiredToAll(tre("Knecht", "Servant"), tre("Ein Knecht kann verschiedene Verteidigungsanlagen errichten wie z. B. Tore, Barrikaden oder Ballistas.", "A servant can build various defenses like for example gates, barricades or ballistas."))

			call PingMinimap(GetRectCenterX(gg_rct_quest_the_defense_of_talras_recruits), GetRectCenterY(gg_rct_quest_the_defense_of_talras_recruits), bj_RESCUE_PING_TIME)
			call PanCameraTo(GetRectCenterX(gg_rct_quest_the_defense_of_talras_recruits), GetRectCenterY(gg_rct_quest_the_defense_of_talras_recruits))
		endmethod

		public method finishTimer takes nothing returns nothing
			if (this.m_timer == null or not (TimerGetRemaining(this.m_timer) > 0.0)) then
				return
			endif

			call PauseTimer(this.m_timer)
			call thistype.timerFunctionFinish()
		endmethod

		public stub method enable takes nothing returns boolean
			call Missions.addMissionToAll('A1CF', 'A1RF', this)
			set this.m_questArea = QuestAreaQuestTheDefenseOfTalras.create(gg_rct_quest_the_defense_of_talras)
			return super.enableUntil(thistype.questItemMoveToCamp)
		endmethod

		public stub method distributeRewards takes nothing returns nothing
			local integer i
			local integer j
			local item whichItem

			call super.distributeRewards()
			/*
			 * 10 Big Healing Potions
			 * 10 Big Mana Potions
			 * 10 Scrolls of Healing
			 * 10 Scrolls of Mana
			 * Amulet from Talras
			 */
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (Character.playerCharacter(Player(i)) != 0) then
					set j = 0
					loop
						exitwhen (j == 10)
						call Character(Character.playerCharacter(Player(i))).giveItem('I00B')
						call Character(Character.playerCharacter(Player(i))).giveItem('I00C')
						call Character(Character.playerCharacter(Player(i))).giveItem('I00F')
						call Character(Character.playerCharacter(Player(i))).giveItem('I00G')
						set j = j + 1
					endloop
					call Character(Character.playerCharacter(Player(i))).giveItem('I06P')
				endif
				set i = i + 1
			endloop

			call Character.displayItemAcquiredToAll(GetObjectName('I06P'), tre("Erhöht die Kraft, das Geschick und das Wissen des Trägers.", "Increases the strength, the skill and the lore of the carrying unit."))
		endmethod

		private static method triggerConditionSpawnDog takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))

			if (GetUnitTypeId(GetSummoningUnit()) == 'n05M') then
				call UnitApplyTimedLife(GetSummonedUnit(), 'B033', 30.0)
			endif

			return false
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Die Verteidigung von Talras", "The Defense of Talras"))
			local AQuestItem questItem
			set this.m_timer = null
			set this.m_timerDialog = null
			set this.m_spawnDogsTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_spawnDogsTrigger, EVENT_PLAYER_UNIT_SUMMON)
			call TriggerAddCondition(this.m_spawnDogsTrigger, Condition(function thistype.triggerConditionSpawnDog))
			call DmdfHashTable.global().setHandleInteger(this.m_spawnDogsTrigger, 0, this)
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNGuardTower.blp")
			call this.setDescription(tre("Ein Teil der Armee der Orks und Dunkelelfen ist in Talras eingetroffen. Verteidigt Talras um jeden Preis gegen die Horden der Orks und Dunkelelfen.", "A part of the army of Orcs and Dark Elves arrived in Talras. Defend Talras at all costs against the hordes of Orcs and Dark Elves."))
			call this.setReward(thistype.rewardExperience, 500)
			call this.setReward(thistype.rewardGold, 500)

			// item 0
			set questItem = AQuestItem.create(this, tre("Begebt euch zum Außenposten und beginnt mit der Verteidigung.", "Make your way to the outpost and begin with the defense."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_defense_of_talras)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 100)

			// item 1
			set questItem = AQuestItem.create(this, tre("Baut eine Verteidigung auf.", "Construct a defense."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_defense_of_talras)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 100)

			// item 2
			set questItem = AQuestItem.create(this, tre("Verteidigt euch gegen die Orks.", "Defend yourselves against the Orcs."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedDefendAgainstOrcs)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedDefendAgainstOrcs)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedDefendAgainstOrcs)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_defense_of_talras)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 1000)

			// item 3
			set questItem = AQuestItem.create(this, tre("Vernichtet die Belagerungswaffen der Orks.", "Destroy the siege weapons of the Orcs."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedDestroyArtillery)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedDestroyArtillery)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedDestroyArtillery)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_defense_of_talras_trebuchet_1)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 1000)

			// item 4
			set questItem = AQuestItem.create(this, tre("Sammelt euch am Außenposten, um euch auf die letzte Angriffswelle vorzubereiten.", "Gather at the outpost to prepare for the final attack wave."))
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedGatherAtTheCamp)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_defense_of_talras)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 5
			set questItem = AQuestItem.create(this, tre("Besiegt mit Hilfe der Hochelfen den Feind endgültig.", "Defeat the enemy finally with the help of the High Elves."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedDefeatTheEnemy)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedDefeatTheEnemy)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedDefeatTheEnemy)
			call questItem.setReward(thistype.rewardExperience, 1000)

			// item 6 questItemGatherAtTheCampAgain
			set questItem = AQuestItem.create(this, tre("Sammelt euch erneut am Außenposten.", "Gather again at the outpost."))
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedGatherAtTheCampAgain)

			// item 6
			set questItem = AQuestItem.create(this, tre("Berichtet dem Herzog von eurem Sieg.", "Report to the duke of your victory."))
			call questItem.setReward(thistype.rewardExperience, 200)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_defense_of_talras_heimrich)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement Quest
	endstruct

endlibrary
