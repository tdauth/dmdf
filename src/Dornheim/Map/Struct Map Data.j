library StructMapMapMapData requires Asl, StructGameGame, StructMapMapShrines, StructMapMapDungeons, StructMapMapFellows, StructMapMapNpcRoutines, MapQuests

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
			call MapSettings.setMapMusic("Sound\\Music\\mp3Music\\Pippin the Hunchback.mp3;Sound\\Music\\mp3Music\\Minstrel Guild.mp3")
			call MapSettings.setGoldmine(gg_unit_n06E_0009)
			call MapSettings.setIsSeparateChapter(true)
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

		/**
		 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
		 */
		public static method createClassSelectionItems takes AClass class, unit whichUnit returns nothing
		endmethod

		/**
		 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
		 */
		public static method createClassItems takes Character character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method initMapSpells takes ACharacter character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method onStart takes nothing returns nothing
			call SuspendTimeOfDay(false)
			call SetTimeOfDay(12.0)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onSelectClass takes Character character, AClass class, boolean last returns nothing
			call SetUnitX(character.unit(), GetRectCenterX(gg_rct_start))
			call SetUnitX(character.unit(), GetRectCenterY(gg_rct_start))
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

			call initMapPrimaryQuests()
			call initMapSecundaryQuests()

			call SuspendTimeOfDay(false)
			call thistype.startAfterIntro.evaluate()
		endmethod

		public static method startAfterIntro takes nothing returns nothing
			call ACharacter.setAllMovable(true) // set movable since they weren't before after class selection (before video)
			call ACharacter.panCameraSmartToAll()
			call ACharacter.enableShrineForAll(Shrines.startShrine(), false)

			call Game.applyHandicapToCreeps()

			/*
			 * Starts the tutorial:
			 * - Select your character.
			 * - Move to Ralph.
			 * - Talk to Ralph and get a quest.
			 * - Walk to your mother and talk to her.
			 * - Collect herbals and sell them to get an item from the merchant.
			 * - Get an item from the merchant.
			 * - Give it to your mother.
			 * - Talk to Gotlinde and level up.
			 * - Skill some spell.
			 * - Use the spell somewhere to kill a creep.
			 * - The creep drops an equipment item, equip it.
			 */
			 call Character.displayHintToAll(tr("Willkommen bei Die Macht des Feuers. Klicken Sie zunächst Ihren Charakter an und schicken Sie ihn zu Ralph."))
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacter takes string zone, Character character returns nothing
			call SetUnitX(character.unit(), GetRectCenterX(gg_rct_start_talras))
			call SetUnitY(character.unit(), GetRectCenterY(gg_rct_start_talras))
			call SetUnitFacing(character.unit(), 180.0)
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacters takes string zone returns nothing
			set thistype.m_traveled = true
		endmethod

		public static method initVideoSettings takes nothing returns nothing
		endmethod

		public static method resetVideoSettings takes nothing returns nothing
		endmethod

		public static method traveled takes nothing returns boolean
			return thistype.m_traveled
		endmethod

		public static method enableZoneTalras takes nothing returns nothing
			call thistype.m_zoneTalras.enable()
			call Character.displayHintToAll(tr("Sie können nun nach Talras reisen. Stellen Sie sich dazu mit Ihrem Charakter in das Gebiet, das auf der Minikarte durch den grün umrandeteten Kartenausgang markiert ist."))
		endmethod
	endstruct

endlibrary