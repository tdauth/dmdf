library StructMapQuestsQuestReinforcementForTalras requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestReinforcementForTalras extends AQuest
		private timer m_timer
		private integer m_arrowsCounter = 0
		private static constant integer maxArrows = 5
		private trigger array m_arrowTriggers[thistype.maxArrows]
		private destructable array arrowsMarker[thistype.maxArrows]

		public stub method enable takes nothing returns boolean
			call this.setState(AAbstractQuest.stateNew)
			call this.questItem(0).setState(AAbstractQuest.stateNew)
			call this.questItem(2).setState(AAbstractQuest.stateNew)
			call this.questItem(5).setState(AAbstractQuest.stateNew)

			call this.displayState()

			return true
		endmethod

		private static method stateActionCompletedSendLumber takes AQuestItem questItem returns nothing
			local unit cart = CreateUnit(MapSettings.neutralPassivePlayer(), 'h01Z', GetUnitX(Npcs.manfred()), GetUnitY(Npcs.manfred()), 0.0)
			call SetUnitInvulnerable(cart, true)
			call IssuePointOrder(cart, "move", GetRectCenterX(gg_rct_quest_reinforcements_of_talras_cart_destination), GetRectCenterY(gg_rct_quest_reinforcements_of_talras_cart_destination))
			set cart = null
		endmethod

		public method oneMinutePassed takes nothing returns boolean
			return this.m_timer != null and TimerGetRemaining(this.m_timer) <= 0.0
		endmethod

		public method lessThanFiveSecondsPassed takes nothing returns boolean
			return this.m_timer != null and TimerGetElapsed(this.m_timer) < 5.0
		endmethod

		private static method timerFunction takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetExpiredTimer(), 0)
			call this.displayUpdateMessage(tre("Die Pfeile sind fertig.", "The arrows have been completed."))
		endmethod


		private static method stateActionCompletedStartTimer takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			local integer i
			set this.m_timer = CreateTimer()
			// wait two days
			call TimerStart(this.m_timer, 60.0, false, function thistype.timerFunction)
			call AHashTable.global().setHandleInteger(this.m_timer, 0, this)
			set this.arrowsMarker[0] =  CreateDestructable('B00L', GetRectCenterX(gg_rct_quest_reinforcement_for_talras_arrows_0), GetRectCenterY(gg_rct_quest_reinforcement_for_talras_arrows_0), 0.0, 1.0, 0)
			call SetDestructableInvulnerable(this.arrowsMarker[0], true)
			set this.arrowsMarker[1] =  CreateDestructable('B00L', GetRectCenterX(gg_rct_quest_reinforcement_for_talras_arrows_1), GetRectCenterY(gg_rct_quest_reinforcement_for_talras_arrows_1), 0.0, 1.0, 0)
			call SetDestructableInvulnerable(this.arrowsMarker[1], true)
			set this.arrowsMarker[2] =  CreateDestructable('B00L', GetRectCenterX(gg_rct_quest_reinforcement_for_talras_arrows_2), GetRectCenterY(gg_rct_quest_reinforcement_for_talras_arrows_2), 0.0, 1.0, 0)
			call SetDestructableInvulnerable(this.arrowsMarker[2], true)
			set this.arrowsMarker[3] =  CreateDestructable('B00L', GetRectCenterX(gg_rct_quest_reinforcement_for_talras_arrows_3), GetRectCenterY(gg_rct_quest_reinforcement_for_talras_arrows_3), 0.0, 1.0, 0)
			call SetDestructableInvulnerable(this.arrowsMarker[3], true)
			set this.arrowsMarker[4] =  CreateDestructable('B00L', GetRectCenterX(gg_rct_quest_reinforcement_for_talras_arrows_4), GetRectCenterY(gg_rct_quest_reinforcement_for_talras_arrows_4), 0.0, 1.0, 0)
			call SetDestructableInvulnerable(this.arrowsMarker[4], true)

			set i = 0
			loop
				exitwhen (i == thistype.maxArrows)
				call EnableTrigger(this.m_arrowTriggers[i])
				set i = i + 1
			endloop
		endmethod

		private static method stateConditionCompletedPlaceArrows takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local boolean result = GetTriggerUnit() == this.character().unit() and this.character().inventory().hasItemType('I03U')
			local destructable box

			if (result) then
				call this.character().inventory().removeItemType('I03U')
				set box = CreateDestructable('B00K', GetUnitX(this.character().unit()), GetUnitY(this.character().unit()), 0.0, 1.0, 0)
				call SetDestructableInvulnerable(box, true)
				set this.m_arrowsCounter = this.m_arrowsCounter + 1

				call this.displayUpdateMessage(Format(tre("%1%/5 Pfeilbündel platziert", "Placed %1%/5 arrow bundles")).i(this.m_arrowsCounter).result())

				/*
				 * Prevent multiple placements at the same place.
				 */
				if (this.m_arrowsCounter != 5) then
					call DisableTrigger(GetTriggeringTrigger())
					return false
				else
					return true
				endif
			endif

			return false
		endmethod

		private static method stateActionCompletedPlaceArrows takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local integer i = 0
			loop
				exitwhen (i == thistype.maxArrows)
				call RemoveDestructable(this.arrowsMarker[i])
				set this.arrowsMarker[i] = null
				set i = i + 1
			endloop
			call DisableTrigger(GetTriggeringTrigger()) // make sure arrows cannot be placed twice
			call this.questItem(4).setState(thistype.stateCompleted)
			call this.displayUpdate()
		endmethod

		private method createArrowTriggers takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.maxArrows)
				set this.m_arrowTriggers[i] = CreateTrigger()

				call TriggerAddCondition(this.m_arrowTriggers[i], Condition(function thistype.stateConditionCompletedPlaceArrows))
				call TriggerAddAction(this.m_arrowTriggers[i], function thistype.stateActionCompletedPlaceArrows)
				call DmdfHashTable.global().setHandleInteger(this.m_arrowTriggers[i], 0, this)

				call DisableTrigger(this.m_arrowTriggers[i])

				set i = i + 1
			endloop

			call TriggerRegisterEnterRectSimple(this.m_arrowTriggers[0], gg_rct_quest_reinforcement_for_talras_arrows_0)
			call TriggerRegisterEnterRectSimple(this.m_arrowTriggers[1], gg_rct_quest_reinforcement_for_talras_arrows_1)
			call TriggerRegisterEnterRectSimple(this.m_arrowTriggers[2], gg_rct_quest_reinforcement_for_talras_arrows_2)
			call TriggerRegisterEnterRectSimple(this.m_arrowTriggers[3], gg_rct_quest_reinforcement_for_talras_arrows_3)
			call TriggerRegisterEnterRectSimple(this.m_arrowTriggers[4], gg_rct_quest_reinforcement_for_talras_arrows_4)
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Die Befestigung von Talras", "The Reinforcement of Talras"))
			local AQuestItem questItem = 0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNStoneArchitecture.blp")
			call this.setDescription(tre("Markward, die rechte Hand des Herzogs, will die Burg Talras wegen einer möglichen Belagerung besser befestigen lassen. Dazu braucht er Holz von Kuno und ebenso Pfeile von Dago oder Björn den Jägern in Talras. Die Pfeile müssen auf den Mauern und Türmen platziert werden. Das Holz muss in die Burg gebracht werden.", "Markward the right hand of the duke wants to let the castle reinforce better because of a possible siege. For this he needs wood from Kuno and as well arrows from Dago or Björn the hunters in Talras. The arrows must be placed on the walls and towers. The wood has to be brought into the castle."))
			call this.setReward(thistype.rewardExperience, 1000)
			call this.setReward(thistype.rewardGold, 600)

			// item 0
			set questItem = AQuestItem.create(this, tre("Besorge Holz von Kuno.", "Get wood from Kuno."))
			call questItem.setPing(true)
			call questItem.setPingWidget(Npcs.kuno())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 1
			set questItem = AQuestItem.create(this, tre("Bringe Kunos Holz zum Bauern Manfred.", "Bring Kuno's wood to the farmer Manfred."))
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedSendLumber)
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.manfred())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 2
			set questItem = AQuestItem.create(this, tre("Besorge Pfeile von Dago oder Björn.", "Get arrows from Dago or Björn."))
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedStartTimer)
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.bjoern())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 3
			set questItem = AQuestItem.create(this, tre("Warte bis Björn die Pfeile hergestellt hat.", "Wait until Björn has produced arrows."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.bjoern())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 4
			set questItem = AQuestItem.create(this, tre("Platziere die Pfeile an den vorgesehenen Positionen.", "Place the arrows at the intended positions."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.bjoern()) // TODO set rects
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 5
			set questItem = AQuestItem.create(this, tre("Berichte Markward davon.", "Report Markward about it."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.markward())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			call this.createArrowTriggers()

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary