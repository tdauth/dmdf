library StructMapMapMapData requires Asl, StructGameGame, StructMapMapShrines, StructMapMapDungeons, StructMapMapFellows, StructMapMapNpcRoutines, MapQuests

	struct MapData extends MapDataInterface
		public static constant string mapName = "DH"
		public static constant string mapMusic = "Sound\\Music\\mp3Music\\Pippin the Hunchback.mp3;Sound\\Music\\mp3Music\\Minstrel Guild.mp3"
		public static constant integer maxPlayers = 6
		public static constant player alliedPlayer = Player(6)
		public static constant player neutralPassivePlayer = Player(7)
		public static constant real morning = 5.0
		public static constant real midday = 12.0
		public static constant real afternoon = 16.0
		public static constant real evening = 18.0
		public static constant real revivalTime = 35.0
		public static constant real revivalLifePercentage = 100.0
		public static constant real revivalManaPercentage = 100.0
		public static constant integer startLevel = 1
		public static constant integer startSkillPoints = 1 /// Includes the skill point for the default spell.
		public static constant integer levelSpellPoints = 2
		public static constant integer maxLevel = 10000
		public static constant integer workerUnitTypeId = 'h00E'
		public static constant boolean isSeparateChapter = true
		public static sound cowSound = null

		private static Zone m_zoneTalras

		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// Required by \ref Game.
		// TODO split up in multiple trigger executions to avoid OpLimit, .evaluate doesn't seem to work.
		public static method init takes nothing returns nothing
			// player should look like neutral passive
			call SetPlayerColor(MapData.neutralPassivePlayer, ConvertPlayerColor(PLAYER_NEUTRAL_PASSIVE))

			call ForForce(bj_FORCE_PLAYER[0], function Dungeons.init)

static if (DMDF_NPC_ROUTINES) then
			/*
			 * Use new OpLimit.
			 */
			call ForForce(bj_FORCE_PLAYER[0], function NpcRoutines.init)
endif

			call Shrines.init()
			call ForForce(bj_FORCE_PLAYER[0], function SpawnPoints.init)
			call initMapTalks.evaluate()
			call ForForce(bj_FORCE_PLAYER[0], function Fellows.init) // init after talks (new)

			set thistype.m_zoneTalras = Zone.create("TL", gg_rct_zone_talras)

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
		endmethod

		/// Required by \ref ClassSelection.
		public static method onRepick takes Character character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method start takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.maxPlayers)
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

		/// Required by \ref Classes.
		public static method startX takes integer index returns real
			return GetRectCenterX(gg_rct_start)
		endmethod

		/// Required by \ref Classes.
		public static method startY takes integer index returns real
			return GetRectCenterY(gg_rct_start)
		endmethod

		/// Required by \ref Classes.
		public static method startFacing takes integer index returns real
			return 90.0
		endmethod

		/// Required by \ref MapChanger.
		public static method restoreStartX takes integer index, string zone returns real
			return GetRectCenterX(gg_rct_start_talras)
		endmethod

		/// Required by \ref MapChanger.
		public static method restoreStartY takes integer index, string zone returns real
			return GetRectCenterY(gg_rct_start_talras)
		endmethod

		/// Required by \ref MapChanger.
		public static method restoreStartFacing takes integer index, string zone returns real
			return 180.0
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacters takes string zone returns nothing
		endmethod

		/**
		 * \return Returns true if characters gain experience from killing units of player \p whichPlayer. Otherwise it returns false.
		 */
		public static method playerGivesXP takes player whichPlayer returns boolean
			return whichPlayer == Player(PLAYER_NEUTRAL_AGGRESSIVE)
		endmethod

		public static method initVideoSettings takes nothing returns nothing
		endmethod

		public static method resetVideoSettings takes nothing returns nothing
		endmethod

		/// Required by \ref Buildings.
		public static method goldmine takes nothing returns unit
			return gg_unit_n06E_0009
		endmethod

		/// Required by teleport spells.
		public static method excludeUnitTypeFromTeleport takes integer unitTypeId returns boolean
			return false
		endmethod
	endstruct

endlibrary