library StructMapQuestsQuestReinforcementForTalras requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestReinforcementForTalras extends AQuest
		private timer m_timer
		private integer m_arrowsCounter = 0
		private static constant integer maxArrows = 5
		private trigger array m_arrowTriggers[thistype.maxArrows]
		private destructable array arrowsMarker[thistype.maxArrows]
	
		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			call this.setState(AAbstractQuest.stateNew)
			call this.questItem(0).setState(AAbstractQuest.stateNew)
			call this.questItem(2).setState(AAbstractQuest.stateNew)
			call this.questItem(5).setState(AAbstractQuest.stateNew)
			
			call this.displayState()
			
			return true
		endmethod
		
		/**
		 * One day has 480 seconds
		 * That means two days are 960 seconds.
		 * That means one hour is 20 seconds.
		 */
		public method twoDaysPassed takes nothing returns boolean
			return this.m_timer != null and TimerGetRemaining(this.m_timer) <= 0.0
		endmethod
		
		public method lessThanOneHourPassed takes nothing returns boolean
			return this.m_timer != null and TimerGetElapsed(this.m_timer) < 20.0
		endmethod
		
		private static method timerFunction takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetExpiredTimer(), "this")
			call this.displayUpdateMessage(tr("Zwei Tage sind vergangen."))
		endmethod
			
		
		private static method stateActionCompletedStartTimer takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			local integer i
			set this.m_timer = CreateTimer()
			// wait two days
			// TODO 960.0
			call TimerStart(this.m_timer, 20.0, false, function thistype.timerFunction)
			call AHashTable.global().setHandleInteger(this.m_timer, "this", this)
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
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local boolean result = GetTriggerUnit() == this.character().unit() and this.character().inventory().hasItemType('I03U')
			local destructable box
			
			if (result) then
				call this.character().inventory().removeItemType('I03U')
				set box = CreateDestructable('B00K', GetUnitX(this.character().unit()), GetUnitY(this.character().unit()), 0.0, 1.0, 0)
				call SetDestructableInvulnerable(box, true)
				set this.m_arrowsCounter = this.m_arrowsCounter + 1
				
				call this.displayUpdateMessage(Format(tr("%1%/5 Pfeilbündel platziert")).i(this.m_arrowsCounter).result())
				
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
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
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
				call DmdfHashTable.global().setHandleInteger(this.m_arrowTriggers[i], "this", this)
				
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
			local thistype this = thistype.allocate(character, tr("Die Befestigung von Talras"))
			local AQuestItem questItem0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNStoneArchitecture.blp")
			call this.setDescription(tr("Markward, die rechte Hand des Herzogs, will die Burg Talras wegen einer möglichen Belagerung besser befestigen lassen. Dazu braucht er Holz von Kuno und ebenso Pfeile von Dago oder Björn den Jägern in Talras. Die Pfeile müssen auf den Mauern und Türmen platziert werden. Das Holz muss in die Burg gebracht werden."))
			call this.setReward(thistype.rewardExperience, 1000)
			call this.setReward(thistype.rewardGold, 600)
			
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Besorge Holz von Kuno."))
			call questItem0.setPing(true)
			call questItem0.setPingWidget(Npcs.kuno())
			call questItem0.setPingColour(100.0, 100.0, 100.0)

			// item 1
			set questItem0 = AQuestItem.create(this, tr("Bringe Kunos Holz zum Bauern Manfred."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.manfred())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			
			// item 2
			set questItem0 = AQuestItem.create(this, tr("Besorge Pfeile von Dago oder Björn."))
			call questItem0.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedStartTimer)
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.bjoern())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			
			// item 3
			set questItem0 = AQuestItem.create(this, tr("Warte zwei Tage auf Björns Pfeile."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.bjoern())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			
			// item 4
			set questItem0 = AQuestItem.create(this, tr("Platziere die Pfeile an den vorgesehenen Positionen."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.bjoern()) // TODO set rects
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			
			// item 5
			set questItem0 = AQuestItem.create(this, tr("Berichte Markward davon."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.markward())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			
			call this.createArrowTriggers()

			return this
		endmethod
	endstruct

endlibrary