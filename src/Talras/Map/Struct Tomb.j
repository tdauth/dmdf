library StructMapMapTomb requires Asl, StructGameCharacter, StructMapMapDungeons, StructMapMapMapData, StructMapMapShrines, StructMapMapNpcs

	/**
	 * \brief The tomb is an area under the earth which is reigned by Deranor and only can be entered in the quest "Slaughter".
	 */
	struct Tomb
		private static trigger m_enterTrigger
		private static trigger m_leaveTrigger
		private static boolean array m_playerJoined[12] /// TODO MapData.maxPlayers

		//! runtextmacro optional A_STRUCT_DEBUG("\"Tomb\"")

		public static method characterJoins takes Character character returns nothing
			// TODO Tomb needs different music
			call PlayMusic("Music\\TheDrumCave.mp3") /// @todo for user
			call Dungeons.crypt().setCameraBoundsForPlayer(character.player())
			call character.setCamera()
			set thistype.m_playerJoined[GetPlayerId(character.player())] = true
		endmethod

		public static method characterLeaves takes Character character returns nothing
			call StopMusic(false) /// @todo for user
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
		
		private static method triggerConditionShake takes nothing returns boolean
			return GetTriggerUnit() == gg_unit_u00A_0353 and GetSpellAbilityId() == 'A0BR'
		endmethod
		
		private static method triggerActionShake takes nothing returns nothing
			local force whichForce = CreateForce()
			local integer i = 0
			debug call Print("Shake!")
			/*
			 * Shake the camera for all players  which see the tomb.
			 */
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.areaContainsCharacter(ACharacter.playerCharacter(Player(i)))) then
					call CameraSetTargetNoiseForPlayer(Player(i), 5.0, 5.0)
					call ForceAddPlayer(whichForce, Player(i))
				endif
				set i = i + 1
			endloop
			call TriggerSleepAction(4.0)
			loop
				exitwhen (i == MapData.maxPlayers)
				if (IsPlayerInForce(Player(i), whichForce)) then
					debug call Print("Disable noise for player " + GetPlayerName(Player(i)))
					call CameraClearNoiseForPlayer(Player(i))
					// TODO not during video
					call ResetToGameCameraForPlayer(Player(i), 0.0)
				endif
				set i = i + 1
			endloop
			call ForceClear(whichForce)
			call DestroyForce(whichForce)
			set whichForce = null
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