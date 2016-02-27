library StructMapMapTavern requires Asl, StructGameCharacter, StructMapMapDungeons

	/**
	 * \brief The tavern ia a specific building at the castle which can be entered via a portal and requires a custom camera view.
	 * Whenever a character enters the tavern the camera view is changed.
	 */
	struct Tavern
		private static region m_region
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
			local Character character = Character.getCharacterByUnit(triggerUnit)
			local player user = character.player()
			call Dungeons.tavern().setCameraBoundsForPlayer(user)
			call character.panCameraSmart()
			if (not character.view().isEnabled()) then
				call character.setCameraTimer(false)
				call CameraSetupApplyForPlayer(true, gg_cam_tavern, user, 0.0)
			endif
			call character.displayMessage(ACharacter.messageTypeInfo, tre("Sie haben das Wirtshaus betreten.", "You have entered the tavern."))
			set triggerUnit = null
			set user = null
		endmethod

		private static method createEnterTrigger takes nothing returns nothing
			set thistype.m_enterTrigger = CreateTrigger()
			call TriggerRegisterEnterRegion(thistype.m_enterTrigger, thistype.m_region, null)
			call TriggerAddCondition(thistype.m_enterTrigger, Condition(function thistype.triggerConditionIsCharacter))
			call TriggerAddAction(thistype.m_enterTrigger, function thistype.triggerActionEnter)
		endmethod

		private static method triggerActionLeave takes nothing returns nothing
			local Character character = Character.getCharacterByUnit(GetTriggerUnit())
			call Dungeon.resetCameraBoundsForPlayer(character.player())
			call character.setCameraTimer(true)
			call character.displayMessage(ACharacter.messageTypeInfo, tre("Sie haben das Wirtshaus verlassen.", "You have left the tavern."))
		endmethod

		private static method createLeaveTrigger takes nothing returns nothing
			set thistype.m_leaveTrigger = CreateTrigger()
			call TriggerRegisterLeaveRegion(thistype.m_leaveTrigger, thistype.m_region, null)
			call TriggerAddCondition(thistype.m_leaveTrigger, Condition(function thistype.triggerConditionIsCharacter))
			call TriggerAddAction(thistype.m_leaveTrigger, function thistype.triggerActionLeave)
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_region = CreateRegion()
			 call RegionAddRect(thistype.m_region, gg_rct_area_tavern_0)
			 call RegionAddRect(thistype.m_region, gg_rct_area_tavern_1)
			 call RegionAddRect(thistype.m_region, gg_rct_area_tavern_2)
			 call RegionAddRect(thistype.m_region, gg_rct_area_tavern_3)
			 call RegionAddRect(thistype.m_region, gg_rct_area_tavern_4)
			 call RegionAddRect(thistype.m_region, gg_rct_area_tavern_5)
			 call RegionAddRect(thistype.m_region, gg_rct_area_tavern_6)
			 call RegionAddRect(thistype.m_region, gg_rct_area_tavern_7)
			 call RegionAddRect(thistype.m_region, gg_rct_area_tavern_8)
			call thistype.createEnterTrigger()
			call thistype.createLeaveTrigger()
		endmethod
	endstruct

endlibrary
