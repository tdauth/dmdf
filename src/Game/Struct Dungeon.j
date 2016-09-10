library StructGameDungeon requires Asl, StructGameCharacter, StructGameDmdfHashTable, StructGameGame, StructGameTreeTransparency

	/**
	 * \brief Dungeons allow the use of separate rects with custom camera bounds.
	 * TODO add generic enter and leave triggers and detect in which rect the character is.
	 */
	struct Dungeon
		// static members
		private static AIntegerVector m_dungeons
		// dynamic members
		private string m_name
		private rect m_cameraBounds
		/// The camera is moved to this rect if the bounds are applied and the character is not in the dungeon.
		private rect m_viewRect

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

		// methods

		public method setCameraBoundsForPlayer takes player whichPlayer returns nothing
			call SetCameraBoundsToRectForPlayerBJ(whichPlayer, this.cameraBounds())
			if (not IsUnitDeadBJ(Character.playerCharacter(whichPlayer).unit()) and RectContainsUnit(this.cameraBounds(), Character.playerCharacter(whichPlayer).unit())) then
				call Character.playerCharacter(whichPlayer).panCamera()
				debug call Print("Pan to character")
			elseif (Character.playerCharacter(whichPlayer).shrine() != 0 and RectContainsCoords(this.cameraBounds(), GetRectCenterX(Character.playerCharacter(whichPlayer).shrine().revivalRect()), GetRectCenterY(Character.playerCharacter(whichPlayer).shrine().revivalRect()))) then
				call SetCameraPositionForPlayer(whichPlayer, GetRectCenterX(Character.playerCharacter(whichPlayer).shrine().revivalRect()), GetRectCenterY(Character.playerCharacter(whichPlayer).shrine().revivalRect()))
				debug call Print("Pan to shrine rect")
			elseif (this.viewRect() != null) then
				// TODO panning camera after setting bounds does not work.
				call SetCameraPositionForPlayer(whichPlayer, GetRectCenterX(this.viewRect()), GetRectCenterY(this.viewRect()))
				debug call Print("Pan to view rect")
			endif
		endmethod

		public static method create takes string name, rect cameraBounds, rect viewRect returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_name = name
			set this.m_cameraBounds = cameraBounds
			set this.m_viewRect = viewRect

			call thistype.m_dungeons.pushBack(this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			set this.m_cameraBounds = null
			set this.m_viewRect = null
			call thistype.m_dungeons.remove(this)
		endmethod

		public static method init takes nothing returns nothing
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

	private struct DungeonEntry extends AMultipageSpellbookAction
		private Dungeon m_dungeon

		public method dungeonSpellbook takes nothing returns DungeonSpellbook
			return DungeonSpellbook(this.multipageSpellbook())
		endmethod

		public method dungeon takes nothing returns Dungeon
			return this.m_dungeon
		endmethod

		public stub method onTrigger takes nothing returns nothing
			call this.dungeon().setCameraBoundsForPlayer(this.dungeonSpellbook().character.evaluate().player())
		endmethod

		public static method create takes DungeonSpellbook dungeonSpellbook, integer abilityId, integer spellBookAbilityId, Dungeon dungeon returns thistype
			local thistype this = thistype.allocate(dungeonSpellbook, abilityId, spellBookAbilityId)
			set this.m_dungeon = dungeon

			return this
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
			return this.addEntry(DungeonEntry.create(this, abilityId, spellBookAbilityId, dungeon))
		endmethod

		public static method create takes Character character, unit whichUnit returns thistype
			local thistype this = thistype.allocate(whichUnit, 'A1TW', 'A1TY', 'A1TX', 'A1TZ')
			set this.m_character = character
			call this.setShortcut(tr("D"))
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod

		public static method addDungeonToAll takes integer abilityId, integer spellBookAbilityId, Dungeon dungeon returns nothing
			local Character character = 0
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set character = Character.playerCharacter(Player(i))
				if (character != 0) then
					call character.options().dungeons().addDungeon(abilityId, spellBookAbilityId, dungeon)
				endif
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary