library StructMapMapTavern requires Asl

	struct Tavern
		private static trigger m_enterTrigger
		private static trigger m_leaveTrigger

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method triggerConditionIsCharacter takes nothing returns boolean
			local unit triggerUnit = GetTriggerUnit()
			local boolean result = ACharacter.isUnitCharacter(triggerUnit)
			set triggerUnit = null
			return result
		endmethod

		private static method triggerActionEnter takes nothing returns nothing
			local unit triggerUnit = GetTriggerUnit()
			local ACharacter character = ACharacter.getCharacterByUnit(triggerUnit)
			local player user = character.player()
			call character.setRect(gg_rct_tavern_enter)
			call character.setFacing(225.0)
			call MapData.setCameraBoundsToTavernForPlayer.evaluate(user)
			call character.panCameraSmart()
			if (not character.view().isEnabled()) then
				call CameraSetupApplyForPlayer(true, gg_cam_tavern, user, 0.0)
			endif
			call character.displayMessage(ACharacter.messageTypeInfo, tr("Sie haben das Wirtshaus betreten."))
			set triggerUnit = null
			set user = null
		endmethod

		private static method createEnterTrigger takes nothing returns nothing
			local event triggerEvent
			local conditionfunc conditionFunction
			local triggercondition triggerCondition
			local triggeraction triggerAction
			set thistype.m_enterTrigger = CreateTrigger()
			set triggerEvent = TriggerRegisterEnterRectSimple(thistype.m_enterTrigger, gg_rct_area_tavern)
			set conditionFunction = Condition(function thistype.triggerConditionIsCharacter)
			set triggerCondition = TriggerAddCondition(thistype.m_enterTrigger, conditionFunction)
			set triggerAction = TriggerAddAction(thistype.m_enterTrigger, function thistype.triggerActionEnter)
			set triggerEvent = null
			set conditionFunction = null
			set triggerCondition = null
			set triggerAction = null
		endmethod

		private static method triggerActionLeave takes nothing returns nothing
			local unit triggerUnit = GetTriggerUnit()
			local ACharacter character = ACharacter.getCharacterByUnit(triggerUnit)
			local player user = character.player()
			call character.setRect(gg_rct_tavern_leave)
			call character.setFacing(45.0)
			call MapData.setCameraBoundsToPlayableAreaForPlayer.evaluate(user)
			call character.panCameraSmart()
			call character.displayMessage(ACharacter.messageTypeInfo, tr("Sie haben das Wirtshaus verlassen."))
			set triggerUnit = null
		endmethod

		private static method createLeaveTrigger takes nothing returns nothing
			local event triggerEvent
			local conditionfunc conditionFunction
			local triggercondition triggerCondition
			local triggeraction triggerAction
			set thistype.m_leaveTrigger = CreateTrigger()
			set triggerEvent = TriggerRegisterLeaveRectSimple(thistype.m_leaveTrigger, gg_rct_area_tavern)
			set conditionFunction = Condition(function thistype.triggerConditionIsCharacter)
			set triggerCondition = TriggerAddCondition(thistype.m_leaveTrigger, conditionFunction)
			set triggerAction = TriggerAddAction(thistype.m_leaveTrigger, function thistype.triggerActionLeave)
			set triggerEvent = null
			set conditionFunction = null
			set triggerCondition = null
			set triggerAction = null
		endmethod

		public static method init takes nothing returns nothing
			call thistype.createEnterTrigger()
			call thistype.createLeaveTrigger()
		endmethod

		public static method areaContainsCharacter takes ACharacter character returns boolean
			return RectContainsUnit(gg_rct_area_tavern, character.unit())
		endmethod
	endstruct

endlibrary
