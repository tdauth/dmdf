library StructMapMapTomb requires Asl, StructGameCharacter, StructMapMapMapData, StructMapMapShrines, StructMapMapNpcs

	struct Tomb
		private static trigger m_enterTrigger
		private static trigger m_leaveTrigger

		//! runtextmacro optional A_STRUCT_DEBUG("\"Tomb\"")

		public static method characterJoins takes Character character returns nothing
			call PlayMusic("Music\\TheDrumCave.mp3") /// @todo for user
			call MapData.setCameraBoundsToTombForPlayer.evaluate(character.player())
			call character.setCamera()
		endmethod

		public static method characterLeaves takes Character character returns nothing
			call StopMusic(false) /// @todo for user
			call MapData.setCameraBoundsToPlayableAreaForPlayer.evaluate(character.player()) // set camera bounds before rect!
			call character.setCamera()
		endmethod

		public static method areaContainsCharacter takes Character character returns boolean
			return RectContainsUnit(gg_rct_area_tomb, character.unit())
		endmethod

		private static method triggerConditionIsCharacter takes nothing returns boolean
			return ACharacter.isUnitCharacter(GetTriggerUnit())
		endmethod

		private static method triggerActionEnter takes nothing returns nothing
			local unit triggerUnit = GetTriggerUnit()
			local Character character = ACharacter.getCharacterByUnit(triggerUnit)
			local player user = character.player()
			call thistype.characterJoins(character)
			set triggerUnit = null
			set user = null
		endmethod

		private static method createEnterTrigger takes nothing returns nothing
			set thistype.m_enterTrigger = CreateTrigger()
			call TriggerRegisterEnterRectSimple(thistype.m_enterTrigger, gg_rct_area_tomb)
			call TriggerAddCondition(thistype.m_enterTrigger, Condition(function thistype.triggerConditionIsCharacter))
			call TriggerAddAction(thistype.m_enterTrigger, function thistype.triggerActionEnter)
		endmethod

		private static method triggerActionLeave takes nothing returns nothing
			local unit triggerUnit = GetTriggerUnit()
			local Character character = ACharacter.getCharacterByUnit(triggerUnit)
			local player user = character.player()
			call thistype.characterLeaves(character)
			set triggerUnit = null
			set user = null
		endmethod

		private static method createLeaveTrigger takes nothing returns nothing
			set thistype.m_leaveTrigger = CreateTrigger()
			call TriggerRegisterLeaveRectSimple(thistype.m_leaveTrigger, gg_rct_area_tomb)
			call TriggerAddCondition(thistype.m_leaveTrigger, Condition(function thistype.triggerConditionIsCharacter))
			call TriggerAddAction(thistype.m_leaveTrigger, function thistype.triggerActionLeave)
		endmethod

		public static method init takes nothing returns nothing
			call thistype.createEnterTrigger()
			call thistype.createLeaveTrigger()
		endmethod

		private static method destroyEnterTrigger takes nothing returns nothing
			call DestroyTrigger(thistype.m_enterTrigger)
			set thistype.m_enterTrigger = null
		endmethod

		private static method destroyLeaveTrigger takes nothing returns nothing
			call DestroyTrigger(thistype.m_leaveTrigger)
			set thistype.m_leaveTrigger = null
		endmethod

		public static method cleanUp takes nothing returns nothing
			call thistype.destroyEnterTrigger()
			call thistype.destroyLeaveTrigger()
		endmethod
	endstruct

endlibrary