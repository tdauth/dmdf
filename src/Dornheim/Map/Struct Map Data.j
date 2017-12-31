library StructMapMapMapData requires Asl, Game, StructMapMapShrines, StructMapMapDungeons, StructMapMapFellows, StructMapMapNpcRoutines, MapQuests, StructMapTalksTalkGotlinde, StructMapTalksTalkMother, StructMapTalksTalkRalph

	struct MapData
		private static boolean m_traveled = false

		private static Zone m_zoneTalras

		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// Required by \ref Game.
		public static method initSettings takes nothing returns nothing
			call MapSettings.setMapName("DH")
			call MapSettings.setMapMusic("Sound\\Music\\mp3Music\\PippinTheHunchback.mp3")
			call MapSettings.setGoldmine(gg_unit_n06E_0009)
			call MapSettings.setIsSeparateChapter(true)
			call MapSettings.addZoneRestorePositionForAllPlayers("WM", GetRectCenterX(gg_rct_start_talras), GetRectCenterY(gg_rct_start_talras), 180.0)
			call MapSettings.addZoneRestorePositionForAllPlayers("TL", GetRectCenterX(gg_rct_start_talras), GetRectCenterY(gg_rct_start_talras), 180.0)
		endmethod

		/// Required by \ref Game.
		// TODO split up in multiple trigger executions to avoid OpLimit, .evaluate doesn't seem to work.
		public static method init takes nothing returns nothing
			call NewOpLimit(function Dungeons.init)

static if (DMDF_NPC_ROUTINES) then
			/*
			 * Use new OpLimit.
			 */
			call NewOpLimit(function NpcRoutines.init)
endif

			call Shrines.init()
			call NewOpLimit(function SpawnPoints.init)
			call initMapTalks.evaluate()
			call NewOpLimit(function Fellows.init) // init after talks (new)

			set thistype.m_zoneTalras = Zone.create("TL", gg_rct_zone_talras)
			call thistype.m_zoneTalras.disable()

			call Game.addDefaultDoodadsOcclusion()
		endmethod

		/// Required by \ref ClassSelection.
		public static method onCreateClassSelectionItems takes AClass class, unit whichUnit returns nothing
			call Classes.createDefaultClassSelectionItems(class, whichUnit)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onCreateClassItems takes Character character returns nothing
			// The class items will be given to the character by Gotlinde later in the game.
		endmethod

		/// Required by \ref Game.
		public static method onInitMapSpells takes ACharacter character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method onStart takes nothing returns nothing
			call SuspendTimeOfDay(false)
			call SetTimeOfDay(12.0)
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
				endif
				set i = i + 1
			endloop

			// clear unit selection for the tutorial
			call ClearSelection()

			call initMapPrimaryQuests()
			call initMapSecundaryQuests()

			call SuspendTimeOfDay(false)
			call thistype.startAfterIntro.execute()
		endmethod

		public static method startAfterIntro takes nothing returns nothing
			local Character character = 0
			local integer i = 0
			call ACharacter.setAllMovable(false)
			call ClearSelection()
			call SelectUnit(Npcs.ralph(), true)
			call ACharacter.panCameraSmartToAll()
			call ACharacter.enableShrineForAll(Shrines.startShrine(), false)

			call NewOpLimit(function AUnitRoutine.manualStartAll) // necessary since at the beginning time of day events might not have be called

			call Game.applyHandicapToCreeps()

			/*
			 * Wait a delay. Otherwise, the talk starts immediately and the player doesn't get the start of it.
			 */
			call TriggerSleepAction(6.0)
			/*
			 * Select Ralph, so the player can skip sentences.
			 */
			call ClearSelection()
			call SelectUnit(Npcs.ralph(), true)
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set character = Character(Character.playerCharacter(Player(i)))
				if (character != 0) then
					call TalkRalph.talk().openForCharacter(character)
				endif
				set i = i + 1
			endloop
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacter takes string zone, Character character returns nothing
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacters takes string zone returns nothing
			set thistype.m_traveled = true
			call TalkGotlinde.talk().setHasAlreadyAskedAfterTravelingForAllPlayers(false)
			call TalkMother.talk().setHasAlreadyAskedAfterTravelingForAllPlayers(false)
		endmethod

		public static method onInitVideoSettings takes nothing returns nothing
		endmethod

		public static method onResetVideoSettings takes nothing returns nothing
		endmethod

		public static method traveled takes nothing returns boolean
			return thistype.m_traveled
		endmethod

		public static method enableZoneTalras takes nothing returns nothing
			call thistype.m_zoneTalras.enable()
			call Character.displayHintToAll(tre("Sie können nun nach Talras reisen. Stellen Sie sich dazu mit Ihrem Charakter in das Gebiet, das auf der Minikarte durch den grün umrandeteten Kartenausgang markiert ist.", "You can travel to Talras now. For this, place your character in the area marked on the minimap by the green bordered map exit."))
		endmethod
	endstruct

endlibrary