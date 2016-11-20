library StructMapQuestsQuestWarWeaponsFromWieland requires Asl, StructGameQuestArea, StructMapQuestsQuestWarSubQuest, StructMapVideosVideoIronFromTheDrumCave, StructMapVideosVideoWeaponsFromWieland, StructMapVideosVideoWieland

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
			call Character.displayHintToAll(tre("In dieses Gebiet müssen die Imps gebracht werden.", "The imps have to be brought to this area."))
			return false
		endmethod
	endstruct

	struct QuestAreaWarReportWieland extends QuestArea

		public stub method onStart takes nothing returns nothing
			call QuestWarWeaponsFromWieland.quest.evaluate().questItem(QuestWarWeaponsFromWieland.questItemReportWieland).complete()
		endmethod
	endstruct

	struct QuestWarWeaponsFromWieland extends QuestWarSubQuest
		public static constant integer questItemWeaponsFromWieland = 0
		public static constant integer questItemIronFromTheDrumCave = 1
		public static constant integer questItemMoveImpsToWieland = 2
		public static constant integer questItemReportWieland = 3
		public static constant integer questItemWaitForWielandsWeapons = 4
		public static constant integer questItemMoveWielandWeaponsToTheCamp = 5

		public static constant integer maxImps = 4

		private QuestAreaWarWieland m_questAreaWieland
		private QuestAreaWarIronFromTheDrumCave m_questAreaIronFromTheDrumCave
		private QuestAreaWarImpTarget m_questAreaImpTarget

		/*
		 * Wieland
		 */
		private timer m_impSpawnTimer
		private timer m_wielandsWeaponsTimer
		private timer m_weaponCartSpawnTimer
		private unit m_weaponCart
		private AGroup m_imps
		private QuestAreaWarReportWieland m_questAreaReportWieland

		public method cleanUnits takes nothing returns nothing
			// Wieland
			call RemoveUnit(this.m_weaponCart)
			set this.m_weaponCart = null
		endmethod

		public stub method enable takes nothing returns boolean
			local boolean result = this.setState(thistype.stateNew)
			call this.questItem(thistype.questItemWeaponsFromWieland).setState(thistype.stateNew)

			set this.m_questAreaWieland = QuestAreaWarWieland.create(gg_rct_quest_war_wieland, true)

			return result
		endmethod

		/*
		 * The characters have to move to the Drum Cave and talk to Baldar who has an iron mine.
		 */
		public method enableIronFromTheDrumCave takes nothing returns nothing
			set this.m_questAreaIronFromTheDrumCave = QuestAreaWarIronFromTheDrumCave.create(gg_rct_quest_war_iron_from_the_drum_cave, true)
			call this.questItem(thistype.questItemIronFromTheDrumCave).enable()
		endmethod

		/*
		 * Whenever Imps have been died they will be respawned periodically.
		 */
		private static method timerFunctionSpawnImps takes nothing returns nothing
			local thistype this = thistype.quest.evaluate()
			local boolean spawned = false
			local integer i = 0
			loop
				exitwhen (i == thistype.maxImps)
				if (this.m_imps.units().size() < i + 1) then
					call this.m_imps.units().pushBack(CreateUnit(MapSettings.alliedPlayer(), 'u00C', GetRectCenterX(gg_rct_quest_war_imp_spawn),  GetRectCenterY(gg_rct_quest_war_imp_spawn), 180.0))
					set spawned = true
				elseif (IsUnitDeadBJ(this.m_imps.units()[i])) then
					set this.m_imps.units()[i] = CreateUnit(MapSettings.alliedPlayer(), 'u00C', GetRectCenterX(gg_rct_quest_war_imp_spawn),  GetRectCenterY(gg_rct_quest_war_imp_spawn), 180.0)
					set spawned = true
				endif
				set i = i + 1
			endloop

			call Game.setAlliedPlayerAlliedToAllCharacters()

			if (spawned) then
				call this.displayUpdateMessage(tre("Neue Imps stehen zur Verfügung.", "New imps are available."))
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
			call TimerStart(this.m_impSpawnTimer, QuestWar.respawnTime, true, function thistype.timerFunctionSpawnImps)
			set i = 0
			loop
				exitwhen (i == thistype.maxImps)
				call this.m_imps.units().pushBack(CreateUnit(MapSettings.alliedPlayer(), 'u00C', GetRectCenterX(gg_rct_quest_war_imp_spawn),  GetRectCenterY(gg_rct_quest_war_imp_spawn), 180.0))
				set i = i + 1
			endloop
			call Game.setAlliedPlayerAlliedToAllCharacters()
			call SmartCameraPanRect(gg_rct_quest_war_imp_spawn, 0.0)
			set this.m_questAreaImpTarget = QuestAreaWarImpTarget.create(gg_rct_quest_war_wieland, true)
			call this.questItem(thistype.questItemMoveImpsToWieland).setState(thistype.stateNew)
			debug call Print("state condition: " + I2S(this.questItem(thistype.questItemMoveImpsToWieland).stateCondition(thistype.stateCompleted)))
			call this.displayUpdate()
			call this.displayUpdateMessage(tre("Neue Imps stehen zur Verfügung.", "New imps are available."))
		endmethod

		/**
		 * Debugging function.
		 *
		 * Moves all Imps to Wieland to finish the quest item.
		 */
		public method moveImpsToWieland takes nothing returns nothing
			local integer i
			call thistype.timerFunctionSpawnImps()
			set i = 0
			loop
				exitwhen (i == this.m_imps.units().size())
				call SetUnitX(this.m_imps.units()[i], GetRectCenterX(gg_rct_quest_war_wieland))
				call SetUnitY(this.m_imps.units()[i], GetRectCenterY(gg_rct_quest_war_wieland))
				set i = i + 1
			endloop
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
				call QuestWar.quest.evaluate().setupUnitAtDestination.evaluate(GetTriggerUnit())
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

				call questItem.quest().displayUpdateMessage(Format(tre("%1%/%2% Imps.", "%1%/%2% Imps.")).i(counter).i(thistype.maxImps).result())

				if (counter == thistype.maxImps) then
					return true
				endif
			debug else
				debug call Print("Is no Imp!")
			endif

			return false
		endmethod

		private static method stateActionCompletedImps takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.m_questAreaImpTarget.destroy()
			set this.m_questAreaReportWieland = QuestAreaWarReportWieland.create(gg_rct_quest_war_wieland, true)
			call this.questItem(thistype.questItemReportWieland).setState(thistype.stateNew)
			call this.displayUpdate()
		endmethod

		private static method groupFunctionHide takes unit whichUnit returns nothing
			call ShowUnit(whichUnit, false)
		endmethod

		private static method groupFunctionShowAndMakeMovableAndChangeOwner takes unit whichUnit returns nothing
			call ShowUnit(whichUnit, true)
			call PauseUnit(whichUnit, false)
			call SetUnitPathing(whichUnit, true)
			call IssueImmediateOrder(whichUnit, "halt")
			call SetUnitOwner(whichUnit, MapSettings.neutralPassivePlayer(), true)
			call SetUnitInvulnerable(whichUnit, true)
		endmethod

		private static method timerFunctionSpawnWeaponCart takes nothing returns nothing
			local thistype this = thistype.quest.evaluate()
			if (IsUnitDeadBJ(this.m_weaponCart)) then
				set this.m_weaponCart = CreateUnit(MapSettings.alliedPlayer(), 'h020', GetRectCenterX(gg_rct_quest_war_wieland), GetRectCenterY(gg_rct_quest_war_wieland), 0.0)
				call this.displayUpdateMessage(tre("Eine neue Waffenlieferung steht zur Verfügung.", "A new supply of weapons is available."))
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
			local thistype this = thistype.quest.evaluate()
			call this.questItem(thistype.questItemWaitForWielandsWeapons).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemMoveWielandWeaponsToTheCamp).setState(thistype.stateNew)
			call this.displayUpdateMessage(tre("Wieland's Waffen sind fertig.", "Wieland's weapons are finished."))
			call this.displayUpdate()

			set this.m_weaponCart = CreateUnit(MapSettings.alliedPlayer(), 'h020', GetRectCenterX(gg_rct_quest_war_wieland), GetRectCenterY(gg_rct_quest_war_wieland), 0.0)
			set this.m_weaponCartSpawnTimer = CreateTimer()
			call TimerStart(this.m_weaponCartSpawnTimer, QuestWar.respawnTime, true, function thistype.timerFunctionSpawnWeaponCart)
			call Game.setAlliedPlayerAlliedToAllCharacters()

			// TODO destroy the elapsed timer

			call QuestWar.quest.evaluate().enableCartDestination.evaluate()
		endmethod

		private static method stateActionCompletedReportWieland takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			/*
			 * The Imps need a new home now! It is shown in the video.
			 */
			call this.m_imps.forGroup(thistype.groupFunctionHide)

			call PauseTimer(this.m_impSpawnTimer)
			call DestroyTimer(this.m_impSpawnTimer)
			set this.m_impSpawnTimer = null
			call this.m_questAreaReportWieland.destroy()

			call VideoWeaponsFromWieland.video().play()
			call waitForVideo(Game.videoWaitInterval)

			debug call Print("Place the imps.")

			/*
			 * Give the imps a new home.
			 */
			call this.m_imps.forGroup(thistype.groupFunctionShowAndMakeMovableAndChangeOwner)
			call SetUnitX(this.m_imps.units()[0], GetRectCenterX(gg_rct_waypoint_imp_0))
			call SetUnitY(this.m_imps.units()[0], GetRectCenterY(gg_rct_waypoint_imp_0))
			call SetUnitFacing(this.m_imps.units()[0], 90.91)
			call SetUnitAnimation(this.m_imps.units()[0], "Attack")
			call SetUnitX(this.m_imps.units()[1], GetRectCenterX(gg_rct_waypoint_imp_1))
			call SetUnitY(this.m_imps.units()[1], GetRectCenterY(gg_rct_waypoint_imp_1))
			call SetUnitFacing(this.m_imps.units()[1], 47.63)
			call SetUnitAnimation(this.m_imps.units()[1], "Attack")
			call SetUnitX(this.m_imps.units()[2], GetRectCenterX(gg_rct_waypoint_imp_2))
			call SetUnitY(this.m_imps.units()[2], GetRectCenterY(gg_rct_waypoint_imp_2))
			call SetUnitFacing(this.m_imps.units()[2], 91.56)
			call SetUnitAnimation(this.m_imps.units()[2], "Attack")
			call SetUnitX(this.m_imps.units()[3], GetRectCenterX(gg_rct_waypoint_imp_3))
			call SetUnitY(this.m_imps.units()[3], GetRectCenterY(gg_rct_waypoint_imp_3))
			call SetUnitFacing(this.m_imps.units()[3], 163.31)

			/*
			 * TODO Would be much cooler when the Imps take weapons to the former Orc camp.
			 */
			call this.questItem(thistype.questItemIronFromTheDrumCave).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemWaitForWielandsWeapons).setState(thistype.stateNew)
			call this.displayUpdate()

			set this.m_wielandsWeaponsTimer = CreateTimer()
			call TimerStart(this.m_wielandsWeaponsTimer, QuestWar.constructionTime, false, function thistype.timerFunctionWielandsWeapons)
		endmethod

		/**
		 * Debugging method to finish the quest.
		 */
		public method moveWeaponsCartToCamp takes nothing returns nothing
			call thistype.timerFunctionSpawnWeaponCart() // respawn
			call SetUnitX(this.m_weaponCart, GetRectCenterX(gg_rct_quest_war_cart_destination))
			call SetUnitY(this.m_weaponCart, GetRectCenterY(gg_rct_quest_war_cart_destination))
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

			call QuestWar.quest.evaluate().setupUnitAtDestination.evaluate(GetTriggerUnit())

			call PauseTimer(this.m_weaponCartSpawnTimer)
			call DestroyTimer(this.m_weaponCartSpawnTimer)
			set this.m_weaponCartSpawnTimer = null

			call this.questItem(thistype.questItemWeaponsFromWieland).setState(thistype.stateCompleted)
			call this.displayState()
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Waffen von Wieland", "Weapons from Wieland"), QuestWar.questItemWeaponsFromWieland)
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNHalberd.blp")
			call this.setDescription(tre("Um die bevorstehenden Angriffe der Orks und Dunkelelfen aufzuhalten, muss der eroberte Außenposten versorgt werden.  Außerdem müssen Fallen vor den Mauern aufgestellt werden, die es den Feinden erschweren, den Außenposten einzunehmen. Zusätzlich müssen auf dem Bauernhof kriegstaugliche Leute angeheuert werden.", "In order to stop the impeding attacks of Orcs and Dark Elves, the conquered outpost has to be supplied. In addition, traps has to be placed before the walls that make it harder for the enemies to conquer the outpost. Furthermore, war suitable people need to be hired at the farm."))
			call this.setReward(thistype.rewardExperience, 200)
			call this.setReward(thistype.rewardGold, 200)

			// quest item questItemWeaponsFromWieland
			set questItem = AQuestItem.create(this, tre("Besorgt Waffen vom Schmied Wieland.", "Get weapons from the smith Wieland."))

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_wieland)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// quest item questItemIronFromTheDrumCave
			set questItem = AQuestItem.create(this, tre("Besorgt Eisen aus der Trommelhöhle.", "Get iron from the Drum Cave."))

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_iron_from_the_drum_cave)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// quest item questItemMoveImpsToWieland
			set questItem = AQuestItem.create(this, tre("Bringt die Imps aus der Trommelhöhle zu Wieland.", "Bring the Imps from the Drum Cave to Wieland."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedImps)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedImps)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedImps)

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_wieland)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// questItemReportWieland
			set questItem = AQuestItem.create(this, tre("Berichtet Wieland davon.", "Report Wieland about it."))
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedReportWieland)

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_wieland)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// questItemWaitForWielandsWeapons
			set questItem = AQuestItem.create(this, tre("Wartet bis Wieland die Waffen hergestellt hat.", "Wait until Wieland has constructed the weapons."))


			// questItemMoveWielandWeaponsToTheCamp
			set questItem = AQuestItem.create(this, tre("Bringt Wielands Waffen sicher zum Außenposten.", "Move Wieland's weapons safely to the outpost."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedMoveWielandsWeaponsToTheCamp)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedMoveWielandsWeaponsToTheCamp)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedMoveWielandsWeaponsToTheCamp)

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_cart_destination)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement Quest
	endstruct

endlibrary