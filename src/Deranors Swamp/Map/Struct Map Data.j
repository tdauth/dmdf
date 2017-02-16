library StructMapMapMapData requires Asl, StructGameGame, StructMapMapShrines, StructMapMapFellows, MapQuests

	struct MapData
		private static Zone m_zoneGardonarsHell
		private static Zone m_zoneHolzbruck

		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// Required by \ref Game.
		public static method initSettings takes nothing returns nothing
			call MapSettings.setMapName("DS")
			call MapSettings.setMapMusic("Sound\\Music\\mp3Music\\War3XMainScreen.mp3")
			call MapSettings.setGoldmine(gg_unit_n06E_0011)
			call MapSettings.setNeutralPassivePlayer(Player(7))
		endmethod

		/// Required by \ref Game.
		public static method init takes nothing returns nothing
			call Shrines.init()
			call NewOpLimit(function SpawnPoints.init)
			call initMapVideos.evaluate()
			call NewOpLimit(function Fellows.init) // init after talks (new)

			set thistype.m_zoneGardonarsHell = Zone.create("GH", gg_rct_zone_gardonars_hell)
			set thistype.m_zoneHolzbruck = Zone.create("HB", gg_rct_zone_holzbruck)
			call thistype.m_zoneHolzbruck.disable()

			call Game.addDefaultDoodadsOcclusion()
		endmethod

		/**
		 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
		 */
		public static method createClassSelectionItems takes AClass class, unit whichUnit returns nothing
			if (class == Classes.ranger()) then
				// Hunting Bow
				call UnitAddItemToSlotById(whichUnit, 'I020', 2)
			elseif (class == Classes.cleric() or class == Classes.necromancer() or class == Classes.elementalMage() or class == Classes.wizard()) then
				// Haunted Staff
				call UnitAddItemToSlotById(whichUnit, 'I03V', 2)
			else
				call UnitAddItemToSlotById(whichUnit, ItemTypes.shortword().itemType(), 2)
				call UnitAddItemToSlotById(whichUnit, ItemTypes.lightWoodenShield().itemType(), 3)
			endif
			// scroll of death to teleport from the beginning, otherwise characters must walk long ways
			call UnitAddItemToSlotById(whichUnit, 'I01N', 0)
			call UnitAddItemToSlotById(whichUnit, 'I061', 1)

			call UnitAddItemToSlotById(whichUnit, 'I00A', 4)
			call UnitAddItemToSlotById(whichUnit, 'I00D', 5)
		endmethod

		/**
		 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
		 */
		public static method createClassItems takes Character character returns nothing
			if (character.class() == Classes.ranger()) then
				// Hunting Bow
				call character.giveItem('I020')
			elseif (character.class() == Classes.cleric() or character.class() == Classes.necromancer() or character.class() == Classes.elementalMage() or character.class() == Classes.wizard()) then
				// Haunted Staff
				call character.giveItem('I03V')
			else
				call character.giveItem(ItemTypes.shortword().itemType())
				call character.giveItem(ItemTypes.lightWoodenShield().itemType())
			endif

			// scroll of death to teleport from the beginning, otherwise characters must walk long ways
			call character.giveItem('I01N')
			call character.giveQuestItem('I061')

			call character.giveItem('I00A')
			call character.giveItem('I00A')
			call character.giveItem('I00A')
			call character.giveItem('I00A')
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call character.giveItem('I00D')
		endmethod

		/// Required by \ref Game.
		public static method initMapSpells takes ACharacter character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method onStart takes nothing returns nothing
			call SuspendTimeOfDay(true)
			call SetTimeOfDay(0.0)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onSelectClass takes Character character, AClass class, boolean last returns nothing
			call SetUnitX(character.unit(), GetRectCenterX(gg_rct_start))
			call SetUnitY(character.unit(), GetRectCenterY(gg_rct_start))
			call SetUnitFacing(character.unit(), 0.0)
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

			call initMapPrimaryQuests()
			call initMapSecundaryQuests()

			call SuspendTimeOfDay(false)

			call VideoIntro.video().play()
		endmethod

		public static method startAfterIntro takes nothing returns nothing
			debug call Print("Waited successfully for intro video.")

			call ACharacter.setAllMovable(true) // set movable since they weren't before after class selection (before video)
			call ACharacter.panCameraSmartToAll()
			call ACharacter.enableShrineForAll(Shrines.startShrine(), false)

			call Fellows.wigberht().shareWithAll()
			call Fellows.ricman().shareWithAll()
			call Fellows.dragonSlayer().shareWithAll()

			call QuestGate.quest().enable()

			//call NpcRoutines.manualStart() // necessary since at the beginning time of day events might not have be called

			call Game.applyHandicapToCreeps()
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacter takes string zone, Character character returns nothing
			if (zone == "HB") then
				call SetUnitX(character.unit(), GetRectCenterX(gg_rct_start_holzbruck))
				call SetUnitY(character.unit(), GetRectCenterY(gg_rct_start_holzbruck))
				call SetUnitFacing(character.unit(), 180.0)
			else
				call SetUnitX(character.unit(), GetRectCenterX(gg_rct_start))
				call SetUnitY(character.unit(), GetRectCenterY(gg_rct_start))
				call SetUnitFacing(character.unit(), 0.0)
			endif
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacters takes string zone returns nothing
		endmethod

		public static method initVideoSettings takes nothing returns nothing
		endmethod

		public static method resetVideoSettings takes nothing returns nothing
		endmethod

		public static method enableZoneHolzbruck takes nothing returns nothing
			call thistype.m_zoneHolzbruck.enable()
		endmethod
	endstruct

endlibrary