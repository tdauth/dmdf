library StructGameShrine requires Asl, StructGameCharacter, StructGameTutorial

	struct Shrine extends AShrine
		public static constant integer playerUnitId = 'n06J'
		private unit m_unit
		/**
		 * Player units are created on the corresponding shrine of the player's character.
		 * They should be classified as worker to enable the worker button.
		 */
		private static unit array m_playerUnits[6] // TODO MapData.maxPlayers
		private static AIntegerVector m_shrines = 0

		public method setUnit takes unit whichUnit returns nothing
			set this.m_unit = whichUnit
		endmethod

		public method unit takes nothing returns unit
			return this.m_unit
		endmethod
		
		public stub method onEnable takes Character character, Shrine oldShrine returns nothing
			local location revivalLoc
			local location playerUnitLoc
			
			// remove old player unit
			if (thistype.m_playerUnits[GetPlayerId(character.player())] != null) then
				call RemoveUnit(thistype.m_playerUnits[GetPlayerId(character.player())])
				set thistype.m_playerUnits[GetPlayerId(character.player())] = null
			endif
			
			set revivalLoc = GetUnitLoc(this.unit())
			set playerUnitLoc = PolarProjectionBJ(revivalLoc, 100.0, GetPlayerId(character.player()) * 360 / MapData.maxPlayers)
			set thistype.m_playerUnits[GetPlayerId(character.player())] = CreateUnitAtLoc(character.player(), thistype.playerUnitId, playerUnitLoc, 0.0)
			call RemoveLocation(revivalLoc)
			set revivalLoc = null
			call RemoveLocation(playerUnitLoc)
			set playerUnitLoc = null
			call SetUnitInvulnerable(thistype.m_playerUnits[GetPlayerId(character.player())], true)
			//call SetUnitAnimation(thistype.m_playerUnits[GetPlayerId(character.player())], "Stand Alternate")
			// change vertex color to player
			call SetUnitVertexColor(thistype.m_playerUnits[GetPlayerId(character.player())], GetPlayerColorRed(GetPlayerColor(character.player())), GetPlayerColorGreen(GetPlayerColor(character.player())),  GetPlayerColorBlue(GetPlayerColor(character.player())), 255)
		endmethod

		public stub method onEnter takes Character character returns nothing
			// call the super method to enable the shrine for the character
			call super.onEnter(character)
			/*
			 * The first time enabling a shrine shows a hint if the tutorial is enabled.
			 */
			if (character.tutorial().isEnabled() and not character.tutorial().hasEnteredShrine()) then
				call character.tutorial().showShrineInfo()
			endif
		endmethod

		public static method create takes unit whichUnit, destructable usedDestructable, rect discoverRect, rect revivalRect, real facing returns thistype
			local region discoverRegion = CreateRegion()
			local thistype this = thistype.allocate(usedDestructable, discoverRegion, revivalRect, facing)
			call RegionAddRect(discoverRegion, discoverRect)
			set this.m_unit = whichUnit
			if (thistype.m_shrines == 0) then
				set thistype.m_shrines = AIntegerVector.create()
			endif
			call thistype.m_shrines.pushBack(this)
			return this
		endmethod

		/**
		 * \return Returns a list of all Shrine instances. Useful for teleport spells for example.
		 */
		public static method shrines takes nothing returns AIntegerVector
			return thistype.m_shrines
		endmethod
		
		public static method playerUnit takes integer index returns unit
			return thistype.m_playerUnits[index]
		endmethod
	endstruct

endlibrary