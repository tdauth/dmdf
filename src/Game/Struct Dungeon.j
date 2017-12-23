library StructGameDungeon requires Asl, StructGameDmdfHashTable, StructGameMapSettings

	/**
	 * \brief Dungeons allow the use of separate rects with custom camera bounds.
	 * TODO add generic enter and leave triggers and detect in which rect the character is.
	 */
	struct Dungeon
		// static members
		private static AIntegerVector m_dungeons
		private static Dungeon array m_playerDungeon[12]
		// dynamic members
		private string m_name
		private rect m_cameraBounds
		/// The camera is moved to this rect if the bounds are applied and the character is not in the dungeon.
		private rect m_viewRect
		private trigger m_enterTrigger
		private camerasetup m_cameraSetup
		private timer m_cameraTimer
		private APlayerVector m_players

		//! runtextmacro A_STRUCT_DEBUG("\"Dungeon\"")

		// dynamic members

		public method setName takes string name returns nothing
			set this.m_name = name
		endmethod

		public method name takes nothing returns string
			return this.m_name
		endmethod

		public method setCameraBounds takes rect whichRect returns nothing
			set this.m_cameraBounds = whichRect
		endmethod

		public method cameraBounds takes nothing returns rect
			return this.m_cameraBounds
		endmethod

		public method setViewRect takes rect whichRect returns nothing
			set this.m_viewRect = whichRect
		endmethod

		public method viewRect takes nothing returns rect
			return this.m_viewRect
		endmethod

		public method cameraSetup takes nothing returns camerasetup
			return this.m_cameraSetup
		endmethod

		// methods

		private method destroyCameraTimer takes nothing returns nothing
			if (this.m_cameraTimer != null) then
				call PauseTimer(this.m_cameraTimer)
				call DmdfHashTable.global().destroyTimer(this.m_cameraTimer)
				set this.m_cameraTimer = null
			endif
		endmethod

		private static method timerFunctionCamera takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), 0))
			local integer i = 0
			loop
				exitwhen (i == this.m_players.size())
				call CameraSetupApplyForPlayer(true, this.m_cameraSetup, this.m_players[i], 0.0)
				set i = i + 1
			endloop
		endmethod

		private method refreshCameraTimer takes nothing returns nothing
			call this.destroyCameraTimer()
			set this.m_cameraTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_cameraTimer, 0, this)
			call TimerStart(this.m_cameraTimer, 0.01, true, function thistype.timerFunctionCamera)
		endmethod

		public static method playerDungeon takes player whichPlayer returns thistype
			return thistype.m_playerDungeon[GetPlayerId(whichPlayer)]
		endmethod

		public method setCameraBoundsForPlayer takes player whichPlayer returns nothing
			local thistype old = thistype.m_playerDungeon[GetPlayerId(whichPlayer)]
			local Character character = Character(Character.playerCharacter(whichPlayer))

			if (old != 0) then
				call old.m_players.remove(whichPlayer)

				if (old.m_players.isEmpty()) then
					call old.destroyCameraTimer()
				endif
			endif

			call SetCameraBoundsToRectForPlayerBJ(whichPlayer, this.cameraBounds())
			if (character != 0 and not IsUnitDeadBJ(character.unit()) and RectContainsUnit(this.cameraBounds(), character.unit())) then
				call SetCameraPositionForPlayer(whichPlayer, GetUnitX(character.unit()), GetUnitY(character.unit())) // pan immediately, otherwise the pan is annoying
				debug call Print("Pan to character")
			elseif (character != 0 and character.shrine() != 0 and RectContainsCoords(this.cameraBounds(), GetRectCenterX(character.shrine().revivalRect()), GetRectCenterY(character.shrine().revivalRect()))) then
				call SetCameraPositionForPlayer(whichPlayer, GetRectCenterX(character.shrine().revivalRect()), GetRectCenterY(character.shrine().revivalRect()))
				debug call Print("Pan to shrine rect")
			elseif (this.viewRect() != null) then
				// TODO panning camera after setting bounds does not work.
				call SetCameraPositionForPlayer(whichPlayer, GetRectCenterX(this.viewRect()), GetRectCenterY(this.viewRect()))
				debug call Print("Pan to view rect")
			endif

			set thistype.m_playerDungeon[GetPlayerId(whichPlayer)] = this
			call this.m_players.pushBack(whichPlayer)

			if (this.m_cameraSetup != null) then
				call this.refreshCameraTimer()
			endif
		endmethod

		public method setEnterTrigger takes boolean enabled returns nothing
			if (enabled) then
				call EnableTrigger(this.m_enterTrigger)
			else
				call DisableTrigger(this.m_enterTrigger)
			endif
		endmethod

		public method setCameraSetup takes camerasetup cameraSetup returns nothing
			set this.m_cameraSetup = cameraSetup
		endmethod


		private static method triggerConditionEnter takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			local Character character = Character.getCharacterByUnit(GetTriggerUnit())

			if (character != 0) then
				call this.setCameraBoundsForPlayer(character.player())
			endif
			return false
		endmethod

		public static method create takes string name, rect cameraBounds, rect viewRect returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_name = name
			set this.m_cameraBounds = cameraBounds
			set this.m_viewRect = viewRect
			// members
			set this.m_enterTrigger = CreateTrigger()
			call TriggerRegisterEnterRectSimple(this.m_enterTrigger, cameraBounds)
			call TriggerAddCondition(this.m_enterTrigger, Condition(function thistype.triggerConditionEnter))
			call DmdfHashTable.global().setHandleInteger(this.m_enterTrigger, 0, this)
			call DisableTrigger(this.m_enterTrigger)
			set this.m_cameraSetup = null
			set this.m_cameraTimer = null
			set this.m_players = AIntegerVector.create()

			call thistype.m_dungeons.pushBack(this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			set this.m_cameraBounds = null
			set this.m_viewRect = null
			call DmdfHashTable.global().destroyTrigger(this.m_enterTrigger)
			set this.m_enterTrigger = null
			call this.destroyCameraTimer()
			call this.m_players.destroy()
			call thistype.m_dungeons.remove(this)
		endmethod

		public static method init takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				set thistype.m_playerDungeon[i] = 0
				set i = i + 1
			endloop
			set thistype.m_dungeons = AIntegerVector.create()
		endmethod

		public static method dungeons takes nothing returns AIntegerVector
			return thistype.m_dungeons
		endmethod

		/// Required by \ref Game.
		public static method resetCameraBoundsForPlayer takes player whichPlayer returns nothing
			local thistype dungeon = 0
			local integer i = 0
			debug call Print("Dungeons size: " + I2S(thistype.dungeons().size()))
			loop
				exitwhen (i == thistype.dungeons().size())
				set dungeon = thistype(thistype.dungeons()[i])
				if (RectContainsUnit(dungeon.cameraBounds(), Character.playerCharacter(whichPlayer).unit())) then
					call dungeon.setCameraBoundsForPlayer(whichPlayer)
					exitwhen (true)
				endif
				set i = i + 1
			endloop
		endmethod
	endstruct

	/**
	 * \brief Every character gets an item with a spellbook ability which contains icons for all active missions. Clicking on an icon pans the camera to the mission's target location.
	 */
	struct DungeonSpellbook extends AMultipageSpellbook
		private Character m_character

		public method character takes nothing returns Character
			return this.m_character
		endmethod

		public method addDungeon takes integer abilityId, integer spellBookAbilityId, Dungeon dungeon returns integer
			return this.addEntry(DungeonEntry.create.evaluate(this, abilityId, spellBookAbilityId, dungeon))
		endmethod

		public static method create takes Character character, unit whichUnit returns thistype
			local thistype this = thistype.allocate(whichUnit, 'A1TW', 'A1TY', 'A1TX', 'A1TZ')
			set this.m_character = character
			call this.setShortcut(tre("D", "D"))
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod

		public static method addDungeonToAll takes integer abilityId, integer spellBookAbilityId, Dungeon dungeon returns nothing
			local Character character = 0
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set character = Character.playerCharacter(Player(i))
				if (character != 0) then
					// Use .evaluate() here since it is only called once but Character needs the struct Dungeon in timerFunctionCamera() periodically.
					call character.options.evaluate().dungeons.evaluate().addDungeon.evaluate(abilityId, spellBookAbilityId, dungeon)
				endif
				set i = i + 1
			endloop
		endmethod
	endstruct

	struct DungeonEntry extends AMultipageSpellbookAction
		private Dungeon m_dungeon

		public method dungeonSpellbook takes nothing returns DungeonSpellbook
			return DungeonSpellbook(this.multipageSpellbook())
		endmethod

		public method dungeon takes nothing returns Dungeon
			return this.m_dungeon
		endmethod

		public stub method onTrigger takes nothing returns nothing
			call this.dungeon().setCameraBoundsForPlayer(this.dungeonSpellbook().character().player())
		endmethod

		public static method create takes DungeonSpellbook dungeonSpellbook, integer abilityId, integer spellBookAbilityId, Dungeon dungeon returns thistype
			local thistype this = thistype.allocate(dungeonSpellbook, abilityId, spellBookAbilityId)
			set this.m_dungeon = dungeon

			return this
		endmethod
	endstruct

endlibrary