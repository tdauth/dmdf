library StructMapMapTomb requires Asl, StructGameCharacter, StructMapMapDungeons, StructMapMapMapData, StructMapMapShrines, StructMapMapNpcs

	/**
	 * \brief The tomb is an area under the earth which is reigned by Deranor and only can be entered in the quest "Slaughter".
	 */
	struct Tomb
		private static trigger m_enterTrigger
		private static trigger m_leaveTrigger
		private static boolean array m_playerJoined[12] /// TODO MapSettings.maxPlayers()

		//! runtextmacro optional A_STRUCT_DEBUG("\"Tomb\"")

		public static method characterJoins takes Character character returns nothing
			// TODO Tomb needs different music
			call Dungeons.crypt().setCameraBoundsForPlayer(character.player())
			call character.setCamera()
			set thistype.m_playerJoined[GetPlayerId(character.player())] = true
		endmethod

		public static method characterLeaves takes Character character returns nothing
			call Dungeon.resetCameraBoundsForPlayer(character.player()) // set camera bounds before rect!
			call character.setCamera()
			set thistype.m_playerJoined[GetPlayerId(character.player())] = false
		endmethod

		public static method areaContainsCharacter takes Character character returns boolean
			return RectContainsUnit(gg_rct_area_tomb, character.unit()) or RectContainsUnit(gg_rct_area_tomb_1, character.unit())
		endmethod

		private static method triggerConditionEnter takes nothing returns boolean
			local ACharacter character = ACharacter.getCharacterByUnit(GetTriggerUnit())
			return character != 0 and not thistype.m_playerJoined[GetPlayerId(character.player())]
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
			call TriggerRegisterEnterRectSimple(thistype.m_enterTrigger, gg_rct_area_tomb_1)
			call TriggerAddCondition(thistype.m_enterTrigger, Condition(function thistype.triggerConditionEnter))
			call TriggerAddAction(thistype.m_enterTrigger, function thistype.triggerActionEnter)
		endmethod

		private static method triggerConditionLeave takes nothing returns boolean
			return ACharacter.isUnitCharacter(GetTriggerUnit()) and not RectContainsUnit(gg_rct_area_tomb, GetTriggerUnit()) and not RectContainsUnit(gg_rct_area_tomb_1, GetTriggerUnit())
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
			call TriggerRegisterLeaveRectSimple(thistype.m_leaveTrigger, gg_rct_area_tomb_1)
			call TriggerAddCondition(thistype.m_leaveTrigger, Condition(function thistype.triggerConditionLeave))
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