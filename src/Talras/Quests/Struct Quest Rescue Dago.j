library StructMapQuestsQuestRescueDago requires Asl, StructMapMapFellows, StructMapMapNpcs, StructMapTalksTalkDago

	struct QuestAreaRescueDago extends QuestArea
	
		public stub method onStart takes nothing returns nothing
			local integer i
			call VideoRescueDago0.video.evaluate().play()
			call waitForVideo(MapData.videoWaitInterval)
			call QuestRescueDago.quest.evaluate().enable.evaluate()
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call SmartCameraPanWithZForPlayer(Player(i), GetUnitX(Npcs.dago()), GetUnitY(Npcs.dago()), 0.0, 0.0)
				set i = i + 1
			endloop
		endmethod
	
		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct

	struct QuestRescueDago extends AQuest
		private static constant real rectRange = 500.0
		private timer m_timer
		private QuestAreaRescueDago m_questArea

		implement Quest
		
		public stub method enable takes nothing returns boolean
			return super.enableUntil(1)
		endmethod

		private method stateEventFailed takes trigger whichTrigger returns nothing
			call TriggerRegisterUnitEvent(whichTrigger, Npcs.dago(), EVENT_UNIT_DEATH)
		endmethod

		private method stateActionFailed takes nothing returns nothing
			call Fellows.dago().reset() // prevent the hero icon from being permanently shown
			call Fellows.dago().destroy()
			call ACharacter.displayMessageToAll(ACharacter.messageTypeError, tre("Dago wurde getötet!", "Dago has been killed!"))
			call this.displayState()
		endmethod

		private method stateActionCompleted takes nothing returns nothing
			call this.displayState()
		endmethod

		private static method stateEventCompleted0 takes AQuestItem questItem, trigger usedTrigger returns nothing
			call TriggerRegisterUnitEvent(usedTrigger, gg_unit_n008_0083, EVENT_UNIT_DEATH)
			call TriggerRegisterUnitEvent(usedTrigger, gg_unit_n008_0027, EVENT_UNIT_DEATH)
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			return IsUnitDeadBJ(gg_unit_n008_0027) and IsUnitDeadBJ(gg_unit_n008_0083)
		endmethod
		
		private static method timerFunctionMove takes nothing returns nothing
			if (GetUnitCurrentOrder(Npcs.dago()) != OrderId("move")) then
				if (IsUnitInRangeXY(Npcs.dago(), GetRectCenterX(gg_rct_waypoint_dago_0), GetRectCenterY(gg_rct_waypoint_dago_0), thistype.rectRange)) then
					call IssuePointOrder(Npcs.dago(), "move", GetRectCenterX(gg_rct_waypoint_dago_1), GetRectCenterY(gg_rct_waypoint_dago_1))
				elseif (IsUnitInRangeXY(Npcs.dago(), GetRectCenterX(gg_rct_waypoint_dago_1), GetRectCenterY(gg_rct_waypoint_dago_1), thistype.rectRange)) then
					call IssuePointOrder(Npcs.dago(), "move", GetRectCenterX(gg_rct_waypoint_dago_2), GetRectCenterY(gg_rct_waypoint_dago_2))
				elseif (IsUnitInRangeXY(Npcs.dago(), GetRectCenterX(gg_rct_waypoint_dago_2), GetRectCenterY(gg_rct_waypoint_dago_2), thistype.rectRange)) then
					call IssuePointOrder(Npcs.dago(), "move", GetRectCenterX(gg_rct_waypoint_dago_3), GetRectCenterY(gg_rct_waypoint_dago_3))
				elseif (IsUnitInRangeXY(Npcs.dago(), GetRectCenterX(gg_rct_waypoint_dago_3), GetRectCenterY(gg_rct_waypoint_dago_3), thistype.rectRange)) then
					call IssuePointOrder(Npcs.dago(), "move", GetRectCenterX(gg_rct_waypoint_dago_4), GetRectCenterY(gg_rct_waypoint_dago_4))
				else
					call IssuePointOrder(Npcs.dago(), "move", GetRectCenterX(gg_rct_waypoint_dago_0), GetRectCenterY(gg_rct_waypoint_dago_0))
				endif
			endif
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call VideoRescueDago1.video.evaluate().play()
			call waitForVideo(MapData.videoWaitInterval)
			call IssuePointOrder(Npcs.dago(), "move", GetRectCenterX(gg_rct_waypoint_dago_0), GetRectCenterY(gg_rct_waypoint_dago_0))
			/*
			 * This timer makes sure that Dago keeps on moving even if he is blocked by units. Otherwise the quest will never be completed.
			 */
			call TimerStart(this.m_timer, 10.0, true, function thistype.timerFunctionMove)
			call questItem.quest().questItem(1).enable()
		endmethod

		private static method stateEventCompleted1 takes AQuestItem questItem, trigger usedTrigger returns nothing
			local event triggerEvent = TriggerRegisterEnterRectSimple(usedTrigger, gg_rct_waypoint_dago_0)
			set triggerEvent = null
			set triggerEvent = TriggerRegisterEnterRectSimple(usedTrigger, gg_rct_waypoint_dago_1)
			set triggerEvent = null
			set triggerEvent = TriggerRegisterEnterRectSimple(usedTrigger, gg_rct_waypoint_dago_2)
			set triggerEvent = null
			set triggerEvent = TriggerRegisterEnterRectSimple(usedTrigger, gg_rct_waypoint_dago_3)
			set triggerEvent = null
			set triggerEvent = TriggerRegisterEnterRectSimple(usedTrigger, gg_rct_waypoint_dago_4)
			set triggerEvent = null
		endmethod

		private static method stateConditionCompleted1 takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local unit enteringUnit = GetEnteringUnit()
			debug call Print("Checking Rescue Dago state condition!")
			if (enteringUnit == Npcs.dago()) then
				if (IsUnitInRangeXY(Npcs.dago(), GetRectCenterX(gg_rct_waypoint_dago_0), GetRectCenterY(gg_rct_waypoint_dago_0), thistype.rectRange)) then
					call IssuePointOrder(Npcs.dago(), "move", GetRectCenterX(gg_rct_waypoint_dago_1), GetRectCenterY(gg_rct_waypoint_dago_1))
				elseif (IsUnitInRangeXY(Npcs.dago(), GetRectCenterX(gg_rct_waypoint_dago_1), GetRectCenterY(gg_rct_waypoint_dago_1), thistype.rectRange)) then
					call IssuePointOrder(Npcs.dago(), "move", GetRectCenterX(gg_rct_waypoint_dago_2), GetRectCenterY(gg_rct_waypoint_dago_2))
				elseif (IsUnitInRangeXY(Npcs.dago(), GetRectCenterX(gg_rct_waypoint_dago_2), GetRectCenterY(gg_rct_waypoint_dago_2), thistype.rectRange)) then
					call IssuePointOrder(Npcs.dago(), "move", GetRectCenterX(gg_rct_waypoint_dago_3), GetRectCenterY(gg_rct_waypoint_dago_3))
				elseif (IsUnitInRangeXY(Npcs.dago(), GetRectCenterX(gg_rct_waypoint_dago_3), GetRectCenterY(gg_rct_waypoint_dago_3), thistype.rectRange)) then
					call IssuePointOrder(Npcs.dago(), "move", GetRectCenterX(gg_rct_waypoint_dago_4), GetRectCenterY(gg_rct_waypoint_dago_4))
					call TransmissionFromUnitWithName(Npcs.dago(), tre("Dago", "Dago"), tre("Wir sind fast da.", "We are almost there."), gg_snd_DagoRescueDago6)
				elseif (IsUnitInRangeXY(Npcs.dago(), GetRectCenterX(gg_rct_waypoint_dago_4), GetRectCenterY(gg_rct_waypoint_dago_4), thistype.rectRange)) then
					call SetUnitFacing(Npcs.dago(), 265.0)
					call TransmissionFromUnitWithName(Npcs.dago(), tre("Dago", "Dago"), tre("So, wenn ihr dem Weg folgt, kommt ihr zum Burgtor. Ich komme später nach, aber jetzt muss ich noch ein paar Pilze in der Umgebung sammeln. Für den Herzog versteht sich.", "Fine, if you follow the way you reach the castle's gate. I will join you later but now I have to collect some mushrooms in the area. For the duke of course."), gg_snd_DagoRescueDago7)
					call TalkDago.initTalk()
					call PauseTimer(this.m_timer)
					call DestroyTimer(this.m_timer)
					set this.m_timer = null
					
					return true
				endif
			endif
			return false
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(0, tre("Rettet Dago!", "Rescue Dago!"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			set this.m_timer = CreateTimer()
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNAttentaeter.tga")
			call this.setDescription(tre("Dago wird vor einer Höhle von zwei Bären angegriffen. Ihr müsst ihm zu Hilfe eilen.", "Dago is being attacked by two bears in front of a cage. You must help him."))
			
			call this.setStateEvent(thistype.stateFailed, thistype.stateEventFailed)
			call this.setStateAction(thistype.stateFailed, thistype.stateActionFailed)
			call this.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted)
			// item 0
			set questItem0 = AQuestItem.create(this, tre("Helft Dago die Bären zu töten.", "Help Dago to kill the bears."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.dago())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem0.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem0.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			// item 1
			set questItem1 = AQuestItem.create(this, tre("Folgt Dago zum Burgeingang.", "Follow Dago to the castle's gate."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(Npcs.dago())
			call questItem1.setPingColour(100.0, 100.0, 100.0)
			call questItem1.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted1)
			call questItem1.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted1)
			
			set this.m_questArea = QuestAreaRescueDago.create(gg_rct_quest_rescue_dago_enable)

			return this
		endmethod
	endstruct

endlibrary