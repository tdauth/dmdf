library StructMapQuestsQuestWarTrapsFromBjoern requires Asl, StructGameQuestArea, StructMapQuestsQuestWarSubQuest, StructMapVideosVideoBjoern

	struct QuestAreaWarBjoern extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoBjoern.video().play()
		endmethod
	endstruct

	/**
	 * Dummy quest area for the placement of traps.
	 */
	struct QuestAreaWarBjoernPlaceTraps extends QuestArea

		public stub method onCheck takes nothing returns boolean
			call Character.displayHintToAll(tre("In diesem Gebiet müssen Björns Fallen platziert werden.", "Bjorn's traps have to be placed in this area."))
			return false
		endmethod

		public stub method onStart takes nothing returns nothing
		endmethod
	endstruct

	struct QuestWarTrapsFromBjoern extends QuestWarSubQuest
		public static constant integer questItemTrapsFromBjoern = 0
		public static constant integer questItemPlaceTraps = 1

		private QuestAreaWarBjoern m_questAreaBjoern
		private QuestAreaWarBjoernPlaceTraps m_questAreaBjoernPlaceTraps

		/*
		 * Björn
		 */
		 public static constant integer maxSpawnedTraps = 10
		 public static constant integer maxPlacedTraps = 10
		 public static constant integer trapItemTypeId = 'I057'
		 private timer m_bjoernsTrapsSpawnTimer
		 private item array m_spawnedTraps[thistype.maxSpawnedTraps]
		 private ALocationVector m_traps
		 private AEffectVector m_trapEffects

		public stub method enable takes nothing returns boolean
			local boolean result = this.setState(thistype.stateNew)
			call this.questItem(thistype.questItemTrapsFromBjoern).setState(thistype.stateNew)

			set this.m_questAreaBjoern = QuestAreaWarBjoern.create(gg_rct_quest_war_bjoern, true)

			return result
		endmethod

		private static method timerFunctionSpawnBjoernsTraps takes nothing returns nothing
			local thistype this = thistype.quest.evaluate()
			local boolean spawned = false
			local integer i = 0
			loop
				exitwhen (i == thistype.maxSpawnedTraps)
				if (this.m_spawnedTraps[i] == null or GetItemLifeBJ(this.m_spawnedTraps[i]) <= 0.0 or IsItemOwned(this.m_spawnedTraps[i])) then
					set this.m_spawnedTraps[i] = CreateItem(thistype.trapItemTypeId, GetRectCenterX(gg_rct_quest_war_bjoern_traps), GetRectCenterY(gg_rct_quest_war_bjoern_traps))
					set spawned = true
				endif
				set i = i + 1
			endloop

			if (spawned) then
				call this.displayUpdateMessage(tre("Neue Fallen verfügbar.", "New traps are available."))
				call PingMinimapEx(GetRectCenterX(gg_rct_quest_war_bjoern_traps), GetRectCenterY(gg_rct_quest_war_bjoern_traps), 5.0, 255, 255, 255, true)
			endif
		endmethod

		/**
		 * Items are spawned at Kuno's place for all players.
		 * If one player decides to not use them but picks them up there will be always a constant number of traps in the rect until the quest item is finished.
		 * It takes some time to respawn the traps.
		 *
		 * The items are spawned with an initial delay since Björn has to produce them.
		 */
		public method enablePlaceTraps takes nothing returns nothing
			call this.questItem(thistype.questItemPlaceTraps).setState(thistype.stateNew)
			call this.displayUpdate()

			set this.m_traps = ALocationVector.create()
			set this.m_trapEffects = AEffectVector.create()
			set this.m_bjoernsTrapsSpawnTimer = CreateTimer()
			call TimerStart(this.m_bjoernsTrapsSpawnTimer, QuestWar.respawnTime, true, function thistype.timerFunctionSpawnBjoernsTraps)

			set this.m_questAreaBjoernPlaceTraps = QuestAreaWarBjoernPlaceTraps.create(gg_rct_quest_war_bjoern_place_traps, true)
		endmethod

		private static method stateEventCompletedPlaceTraps takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod

		public method addTrap takes real x, real y returns nothing
			call this.m_traps.pushBack(Location(x, y))
			call this.m_trapEffects.pushBack(AddSpecialEffect("Objects\\InventoryItems\\Spiketrap\\Spiketrap.mdx", x, y))
			call this.displayUpdateMessage(Format(tre("%1%/%2% Fallen platziert.", "Placed %1%/%2% traps.")).i(this.m_traps.size()).i(thistype.maxPlacedTraps).result())
		endmethod

		/**
		 * Places all traps as trap units at the locations which have been specified.
		 * This destroys and clears the stored locations afterwards to avoid memory leaks.
		 */
		public method placeTraps takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_traps.size())
				call CreateUnit(MapSettings.alliedPlayer(), 'n02W', GetLocationX(this.m_traps[i]), GetLocationY(this.m_traps[i]), 0.0)
				call RemoveLocation(this.m_traps[i])
				set this.m_traps[i] = null
				set i = i + 1
			endloop
			call this.m_traps.destroy()
			set this.m_traps = 0
		endmethod

		private static method stateConditionCompletedPlaceTraps takes AQuestItem questItem returns boolean
			local thistype this = thistype.quest.evaluate()
			if (GetSpellAbilityId() == 'A0QZ' and RectContainsCoords(gg_rct_quest_war_bjoern_place_traps, GetSpellTargetX(), GetSpellTargetY())) then
				call this.addTrap(GetSpellTargetX(), GetSpellTargetY())

				return this.m_traps.size() >= thistype.maxPlacedTraps
			endif

			return false
		endmethod

		private static method stateActionCompletedPlaceTraps takes AQuestItem questItem returns nothing
			local thistype this = thistype.quest.evaluate()
			local integer i = 0
			loop
				exitwhen (i == thistype.maxSpawnedTraps)
				if (RectContainsItem(this.m_spawnedTraps[i], gg_rct_quest_war_bjoern_traps)) then
					call RemoveItem(this.m_spawnedTraps[i])
				endif
				set this.m_spawnedTraps[i] = null
				set i = i + 1
			endloop
			set i = 0
			loop
				exitwhen (i == this.m_trapEffects.size())
				call DestroyEffect(this.m_trapEffects[i])
				set this.m_trapEffects[i] = null
				set i = i + 1
			endloop
			call this.m_trapEffects.destroy()
			set this.m_trapEffects = 0

			call PauseTimer(this.m_bjoernsTrapsSpawnTimer)
			call DestroyTimer(this.m_bjoernsTrapsSpawnTimer)
			set this.m_bjoernsTrapsSpawnTimer = null

			call this.m_questAreaBjoernPlaceTraps.destroy()
			set this.m_questAreaBjoernPlaceTraps = 0

			call this.questItem(thistype.questItemTrapsFromBjoern).setState(thistype.stateCompleted)
			call this.displayState()
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Fallen von Björn", "Traps from Bjoern"), QuestWar.questItemTrapsFromBjoern)
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNPitfall.blp")
			call this.setDescription(tre("Um die bevorstehenden Angriffe der Orks und Dunkelelfen aufzuhalten, muss der eroberte Außenposten versorgt werden.  Außerdem müssen Fallen vor den Mauern aufgestellt werden, die es den Feinden erschweren, den Außenposten einzunehmen. Zusätzlich müssen auf dem Bauernhof kriegstaugliche Leute angeheuert werden.", "In order to stop the impeding attacks of Orcs and Dark Elves, the conquered outpost has to be supplied. In addition, traps has to be placed before the walls that make it harder for the enemies to conquer the outpost. Furthermore, war suitable people need to be hired at the farm."))
			call this.setReward(thistype.rewardExperience, 200)
			call this.setReward(thistype.rewardGold, 200)

			// quest item questItemTrapsFromBjoern
			set questItem = AQuestItem.create(this, tre("Besorgt Fallen vom Jäger Björn.", "Get traps from the hunter Björn."))

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_bjoern)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// quest item questItemPlaceTraps
			set questItem = AQuestItem.create(this, tre("Platziert zehn Fallen vor dem Tor des Außenpostens.", "Place ten traps in front of the outpost's gate."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedPlaceTraps)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedPlaceTraps)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedPlaceTraps)

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_bjoern_place_traps)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement Quest
	endstruct

endlibrary