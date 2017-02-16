library StructMapQuestsQuestGate requires Asl, StructMapMapFellows

	struct QuestGate extends SharedQuest
		public static constant integer questItemGateActivator0 = 0
		public static constant integer questItemGateActivator1 = 1
		public static constant integer questItemGateActivator2 = 2
		public static constant integer questItemActivate = 3
		private static constant integer maxRects = 3
		private rect array m_enterRect[thistype.maxRects]
		private weathereffect array m_weatherEffect[thistype.maxRects]
		private trigger array m_enterTrigger[thistype.maxRects]
		private trigger array m_leaveTrigger[thistype.maxRects]
		private unit array m_unit[thistype.maxRects]
		private weathereffect m_finalWeatherEffect

		public method countActivatedRects takes nothing returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == thistype.maxRects)
				if (this.m_unit[i] != null) then
					set result = result + 1
				endif
				set i = i + 1
			endloop

			return result
		endmethod

		private method destroyEnterAndLeaveTrigger takes integer index returns nothing
			set this.m_enterRect[index] = null
			call RemoveWeatherEffect(this.m_weatherEffect[index])
			set this.m_weatherEffect[index] = null
			call DmdfHashTable.global().destroyTrigger(this.m_enterTrigger[index])
			set this.m_enterTrigger[index] = null
			call DmdfHashTable.global().destroyTrigger(this.m_leaveTrigger[index])
			set this.m_leaveTrigger[index] = null
			set this.m_unit[index] = null
		endmethod

		private static method triggerConditionEnter takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			local integer index = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 1)

			if (IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO)) then
				set this.m_unit[index] = GetTriggerUnit()
				call IssueImmediateOrder(GetTriggerUnit(), "halt")
				call EnableWeatherEffect(this.m_weatherEffect[index], false)
				call StartSound(gg_snd_StarfallCaster1)
				call this.displayUpdateMessage(Format(tre("%1%/%2% Kraftfelder deaktiviert", "Disabled %1%/%2% Force Fields")).i(this.countActivatedRects()).i(thistype.maxRects).result())

				return this.countActivatedRects() == thistype.maxRects
			endif

			return false
		endmethod

		private static method triggerActionEnter takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			local integer index = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 1)
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (Character.playerCharacter(Player(i)) != 0) then
					call PanCameraToForPlayer(Character.playerCharacter(Player(i)).player(), GetRectCenterX(gg_rct_quest_gate_weather), GetRectCenterY(gg_rct_quest_gate_weather))
				endif
				set i = i + 1
			endloop
			call RemoveWeatherEffect(this.m_finalWeatherEffect)
			set this.m_finalWeatherEffect = null
			set i = 0
			loop
				exitwhen (i == thistype.maxRects)
				call this.destroyEnterAndLeaveTrigger(i)
				set i = i + 1
			endloop
			call this.complete()
			call MapData.enableZoneHolzbruck.evaluate()
		endmethod

		private static method triggerConditionLeave takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			local integer index = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 1)

			if (GetTriggerUnit() == this.m_unit[index]) then
				set this.m_unit[index] = null
				call EnableWeatherEffect(this.m_weatherEffect[index], true)
			endif

			return false
		endmethod

		private method createEnterAndLeaveTrigger takes rect whichRect, integer index returns nothing
			set this.m_enterTrigger[index] = CreateTrigger()
			call TriggerRegisterEnterRectSimple(this.m_enterTrigger[index], whichRect)
			call TriggerAddCondition(this.m_enterTrigger[index], Condition(function thistype.triggerConditionEnter))
			call TriggerAddAction(this.m_enterTrigger[index], function thistype.triggerActionEnter)
			call DmdfHashTable.global().setHandleInteger(this.m_enterTrigger[index], 0, this)
			call DmdfHashTable.global().setHandleInteger(this.m_enterTrigger[index], 1, index)

			set this.m_leaveTrigger[index] = CreateTrigger()
			call TriggerRegisterLeaveRectSimple(this.m_leaveTrigger[index], whichRect)
			call TriggerAddCondition(this.m_leaveTrigger[index], Condition(function thistype.triggerConditionLeave))
			call DmdfHashTable.global().setHandleInteger(this.m_leaveTrigger[index], 0, this)
			call DmdfHashTable.global().setHandleInteger(this.m_leaveTrigger[index], 1, index)
		endmethod

		public stub method enable takes nothing returns boolean
			local integer i = 0
			set this.m_finalWeatherEffect = AddWeatherEffect(gg_rct_quest_gate_weather, 'MEds')
			call EnableWeatherEffect(this.m_finalWeatherEffect, true)
			set this.m_enterRect[0] = gg_rct_quest_gate_activator_0
			set this.m_weatherEffect[0] = AddWeatherEffect(gg_rct_quest_gate_activator_0_weather, 'MEds')
			call EnableWeatherEffect(this.m_weatherEffect[0], true)
			set this.m_enterRect[1] = gg_rct_quest_gate_activator_1
			set this.m_weatherEffect[1] = AddWeatherEffect(gg_rct_quest_gate_activator_1_weather, 'MEds')
			call EnableWeatherEffect(this.m_weatherEffect[1], true)
			set this.m_enterRect[2] = gg_rct_quest_gate_activator_2
			set this.m_weatherEffect[2] = AddWeatherEffect(gg_rct_quest_gate_activator_2_weather, 'MEds')
			call EnableWeatherEffect(this.m_weatherEffect[2], true)
			set i = 0
			loop
				exitwhen (i == thistype.maxRects)
				call this.createEnterAndLeaveTrigger(this.m_enterRect[i], i)
				set i = i + 1
			endloop
			return this.enableUntil(thistype.questItemActivate)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Das versiegelte Tor", "The Sealed Gate"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNMagicalSentry.blp")
			call this.setDescription(tr("Deranor der Schreckliche hat das Tor seiner Welt mit einem Zauber versiegelt. Die Kraftfelder müssen zunächst deaktiviert werden, bevor die Versiegelung aufgehoben werden kann."))

			// questItemGateActivator0
			set questItem = AQuestItem.create(this, tre("Deaktviert das erste Kraftfeld.", "Disable the first Force Field."))
			call questItem.setPing(true)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setPingCoordinatesFromRect(gg_rct_quest_gate_activator_0)
			call questItem.setReward(thistype.rewardExperience, 100)

			// questItemGateActivator1
			set questItem = AQuestItem.create(this, tre("Deaktviert das zweite Kraftfeld.", "Disable the second Force Field."))
			call questItem.setPing(true)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setPingCoordinatesFromRect(gg_rct_quest_gate_activator_1)
			call questItem.setReward(thistype.rewardExperience, 100)

			// questItemGateActivator2
			set questItem = AQuestItem.create(this, tre("Deaktviert das dritte Kraftfeld.", "Disable the third Force Field."))
			call questItem.setPing(true)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setPingCoordinatesFromRect(gg_rct_quest_gate_activator_2)
			call questItem.setReward(thistype.rewardExperience, 100)

			// questItemGateActivator2
			set questItem = AQuestItem.create(this, tre("Hebt die Versiegelung von Deranor auf.", "Clear the seal of Deranor."))
			call questItem.setPing(true)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setPingCoordinatesFromRect(gg_rct_quest_gate_weather)
			call questItem.setReward(thistype.rewardExperience, 800)

			return this
		endmethod

		implement Quest
	endstruct

endlibrary