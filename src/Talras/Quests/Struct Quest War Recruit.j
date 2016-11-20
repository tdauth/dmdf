library StructMapQuestsQuestWarRecruit requires Asl, StructGameQuestArea, StructMapQuestsQuestWarSubQuest, StructMapVideosVideoRecruit

	struct QuestAreaWarRecruit extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoRecruit.video().play()
		endmethod
	endstruct

	struct QuestWarRecruit extends QuestWarSubQuest
		public static constant integer questItemRecruit = 0
		public static constant integer questItemGetRecruits = 1
		private QuestAreaWarRecruit m_questAreaRecruit
		/*
		 * Recruits
		 */
		 public static constant integer maxRecruits = 5
		 private unit m_recruitBuilding
		 private trigger m_recruitTrigger
		 private AGroup m_recruits

		 public method cleanUnits takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.maxRecruits)
				call RemoveUnit(this.m_recruits.units()[i])
				set i = i + 1
			endloop
			call this.m_recruits.destroy()
			set this.m_recruits = 0
		endmethod

		public stub method enable takes nothing returns boolean
			local boolean result = this.setState(thistype.stateNew)
			call this.questItem(thistype.questItemRecruit).setState(thistype.stateNew)

			set this.m_questAreaRecruit = QuestAreaWarRecruit.create(gg_rct_quest_war_farm, true)

			return result
		endmethod

		/**
		 * Sold units are shared by all players.
		 * Then they can be moved to the camp.
		 */
		private static method triggerActionRecruit takes nothing returns nothing
			local thistype this = thistype.quest.evaluate()
			call SetUnitOwner(GetSoldUnit(), MapSettings.alliedPlayer(), true)
			call Game.setAlliedPlayerAlliedToAllCharacters()
			call this.displayUpdateMessage(tre("Knecht angeworben.", "Acquired servant."))
			call PingMinimapEx(GetUnitX(GetSoldUnit()), GetUnitY(GetSoldUnit()), 5.0, 255, 255, 255, true)
			call QuestWar.quest.evaluate().enableCartDestination.evaluate()
		endmethod

		/**
		 * The recruits can be bought by any player from a building at the farm.
		 * Whenever a recruit is bought its owner is changed to \ref MapSettings.alliedPlayer() and it has to be moved to the camp until \ref thistype.maxRecruits units are at the camp.
		 */
		public method enableGetRecruits takes nothing returns nothing
			call this.questItem(thistype.questItemGetRecruits).setState(thistype.stateNew)
			call this.displayUpdate()
			set this.m_recruitBuilding = CreateUnit(MapSettings.alliedPlayer(), 'n04F', GetRectCenterX(gg_rct_quest_war_recruit_building), GetRectCenterY(gg_rct_quest_war_recruit_building), 0.0)
			set this.m_recruits = AGroup.create()
			set this.m_recruitTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_recruitTrigger, this.m_recruitBuilding, EVENT_UNIT_SELL)
			call TriggerAddAction(this.m_recruitTrigger, function thistype.triggerActionRecruit)

			call SmartCameraPan(GetUnitX(this.m_recruitBuilding), GetUnitY(this.m_recruitBuilding), 4.0)
		endmethod

		private static method stateEventCompletedGetRecruits takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_war_cart_destination)
		endmethod

		private static method stateConditionCompletedGetRecruits takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			if (GetUnitTypeId(GetTriggerUnit()) == 'n02J' and GetOwningPlayer(GetTriggerUnit()) == MapSettings.alliedPlayer()) then
				call QuestWar.quest.evaluate().setupUnitAtDestination.evaluate(GetTriggerUnit())
				call this.m_recruits.units().pushBack(GetTriggerUnit())

				call this.displayUpdateMessage(Format(tre("%1%/%2% Rekruten", "%1%/%2% recruits")).i(this.m_recruits.units().size()).i(thistype.maxRecruits).result())

				return this.m_recruits.units().size() == thistype.maxRecruits
			endif

			return false
		endmethod

		private static method stateActionCompletedGetRecruits takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())

			call RemoveUnit(this.m_recruitBuilding)
			set this.m_recruitBuilding = null
			call DestroyTrigger(this.m_recruitTrigger)
			set this.m_recruitTrigger = null

			call this.questItem(thistype.questItemRecruit).setState(thistype.stateCompleted)
			call this.displayState()
			// TODO sell other recruits and distribute the costs to all players equally.
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Rekrutierung", "Recruit"), QuestWar.questItemRecruit)
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNMercenaryCamp.blp")
			call this.setDescription(tre("Um die bevorstehenden Angriffe der Orks und Dunkelelfen aufzuhalten, muss der eroberte Außenposten versorgt werden.  Außerdem müssen Fallen vor den Mauern aufgestellt werden, die es den Feinden erschweren, den Außenposten einzunehmen. Zusätzlich müssen auf dem Bauernhof kriegstaugliche Leute angeheuert werden.", "In order to stop the impeding attacks of Orcs and Dark Elves, the conquered outpost has to be supplied. In addition, traps has to be placed before the walls that make it harder for the enemies to conquer the outpost. Furthermore, war suitable people need to be hired at the farm."))
			call this.setReward(thistype.rewardExperience, 200)
			call this.setReward(thistype.rewardGold, 200)

			// quest item questItemRecruit
			set questItem = AQuestItem.create(this, tre("Rekrutiert kriegstaugliche Leute auf dem Bauernhof.", "Recruit war suitable people at the farm."))

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_farm)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// quest item questItemGetRecruits
			set questItem = AQuestItem.create(this, tre("Sammelt fünf Rekruten am Außenposten.", "Gather five recruits at the outpost."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedGetRecruits)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedGetRecruits)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedGetRecruits)

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_cart_destination)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement Quest
	endstruct

endlibrary