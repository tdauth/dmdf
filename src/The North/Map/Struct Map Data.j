library StructMapMapMapData requires Asl, StructGameGame

	struct MapData
		private static Zone m_zoneHolzbruck

		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// Required by \ref Game.
		public static method initSettings takes nothing returns nothing
			call MapSettings.setMapName("TN")
			call MapSettings.setMapMusic("Sound\\Music\\mp3Music\\Pippin the Hunchback.mp3;Sound\\Music\\mp3Music\\Minstrel Guild.mp3")
			call MapSettings.setGoldmine(gg_unit_n06E_0008)
		endmethod

		/// Required by \ref Game.
		public static method init takes nothing returns nothing
			set thistype.m_zoneHolzbruck = Zone.create("HB", gg_rct_zone_holzbruck)

			call Game.addDefaultDoodadsOcclusion()
		endmethod

		/**
		 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
		 * Required by \ref ClassSelection.
		 */
		public static method createClassSelectionItems takes AClass class, unit whichUnit returns nothing
		endmethod

		/**
		 * Creates the starting items for the inventory of \p whichUnit depending on \p class.
		 * Required by \ref ClassSelection.
		 */
		public static method createClassItems takes Character character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method initMapSpells takes ACharacter character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method onStart takes nothing returns nothing
			call SuspendTimeOfDay(false)
			call SetTimeOfDay(0.0)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onSelectClass takes Character character, AClass class, boolean last returns nothing
			call SetUnitX(character.unit(), GetRectCenterX(gg_rct_start))
			call SetUnitY(character.unit(), GetRectCenterY(gg_rct_start))
			call SetUnitFacing(character.unit(), 90.0)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onRepick takes Character character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method start takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call ACharacter.playerCharacter(Player(i)).setMovable(true)
					call SelectUnitForPlayerSingle(ACharacter.playerCharacter(Player(i)).unit(), Player(i))
				endif
				set i = i + 1
			endloop

			call SuspendTimeOfDay(false)
			call ACharacter.setAllMovable(true) // set movable since they weren't before after class selection (before video)
			call ACharacter.panCameraSmartToAll()
			//call ACharacter.enableShrineForAll(Shrines.startShrine(), false)

			call Game.applyHandicapToCreeps()
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacters takes string zone returns nothing
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacter takes string zone, Character character returns nothing
			call SetUnitX(character.unit(), GetRectCenterX(gg_rct_start_holzbruck))
			call SetUnitY(character.unit(), GetRectCenterY(gg_rct_start_holzbruck))
			call SetUnitFacing(character.unit(), 90.0)
		endmethod

		public static method initVideoSettings takes nothing returns nothing
		endmethod

		public static method resetVideoSettings takes nothing returns nothing
		endmethod
	endstruct

endlibrary