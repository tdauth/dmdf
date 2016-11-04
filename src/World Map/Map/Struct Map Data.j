library StructMapMapMapData requires Asl, StructGameGame

	/**
	 * \brief The world map allows the player to travel to other maps in the singleplayer campaign.
	 */
	struct MapData extends MapDataInterface
		public static constant string mapName = "WM"
		public static constant string mapMusic = "Sound\\Music\\mp3Music\\War3XMainScreen.mp3"
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
		public static constant integer startLevel = 50
		public static constant integer startSkillPoints = 5 /// Includes the skill point for the default spell.
		public static constant integer levelSpellPoints = 2
		public static constant integer maxLevel = 10000
		public static constant integer workerUnitTypeId = 'h00E'
		public static constant boolean isSeparateChapter = false
		public static sound cowSound = null

		private static constant real refreshInterval = 0.05

		private static Zone m_zoneDeranorsSwamp
		private static Zone m_zoneGardonarsHell
		private static Zone m_zoneGardonar
		private static Zone m_zoneHolzbruck
		private static Zone m_zoneHolzbrucksUnderworld
		private static Zone m_zoneTalras
		private static Zone m_zoneDornheim

		private static timer m_cameraTimer

		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method triggerActionChangeZone takes nothing returns nothing
			local Zone zone = Zone(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			call zone.onStart.execute()
		endmethod

		private static method triggerActionTrack takes nothing returns nothing
			local Zone zone = Zone(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			local string description = DmdfHashTable.global().handleStr(GetTriggeringTrigger(), 1)
			local integer i = 0
			debug call Print("Zone: " + zone.mapName())
			loop
				exitwhen (i == MapData.maxPlayers)
				call DisplayTextToPlayer(Player(i), 0.0, 0.0, description)
				set i = i + 1
			endloop
		endmethod

		private static method createZoneChanger takes Zone zone, string imageFile, string name, string description returns nothing
			// TODO use a big invisible trackable with a big collision box
			// Box1000x1000.mdx
			local trackable whichTrackable = CreateTrackableZ("units\\nightelf\\Wisp\\Wisp.mdx", GetRectCenterX(zone.rect()), GetRectCenterY(zone.rect()), 100.0, 0.0)
			local trigger clickTrigger = CreateTrigger()
			local trigger trackTrigger = CreateTrigger()
			local image whichImage = CreateImageEx(imageFile, GetRectCenterX(zone.rect()), GetRectCenterY(zone.rect()), 150.0, 200.0, 200.0)
			local texttag textTag = CreateTextTag()
			call SetTextTagPos(textTag, GetRectCenterX(zone.rect()), GetRectCenterY(zone.rect()), 100.0)
			call SetTextTagTextBJ(textTag, name, 18.0)
			call SetTextTagPermanent(textTag, true)
			call SetTextTagVisibility(textTag, true)
			call TriggerRegisterTrackableHitEvent(clickTrigger, whichTrackable)
			call TriggerAddAction(clickTrigger, function thistype.triggerActionChangeZone)
			call DmdfHashTable.global().setHandleInteger(clickTrigger, 0, zone)
			call TriggerRegisterTrackableTrackEvent(trackTrigger, whichTrackable)
			call TriggerAddAction(trackTrigger, function thistype.triggerActionTrack)
			call DmdfHashTable.global().setHandleInteger(trackTrigger, 0, zone)
			call DmdfHashTable.global().setHandleStr(trackTrigger, 1, description)
			call ShowImage(whichImage, true)
			//call ShowUnit(zone.iconUnit(), false)
		endmethod

		private static method timerRefreshCamera takes nothing returns nothing
			// TODO check if player GUI or class selection is enabled
			call SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, 300.0, thistype.refreshInterval)
			call SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, 3000.0, thistype.refreshInterval)
		endmethod

		/// Required by \ref Game.
		// TODO split up in multiple trigger executions to avoid OpLimit, .evaluate doesn't seem to work.
		public static method init takes nothing returns nothing
			// player should look like neutral passive
			call SetPlayerColor(MapData.neutralPassivePlayer, ConvertPlayerColor(PLAYER_NEUTRAL_PASSIVE))
			call SetMapFlag(MAP_FOG_HIDE_TERRAIN, false)
			call SetMapFlag(MAP_FOG_MAP_EXPLORED, true)
			call SetMapFlag(MAP_FOG_ALWAYS_VISIBLE, true)

			set thistype.m_zoneDornheim = Zone.create("DH", gg_rct_zone_dornheim)
			call thistype.createZoneChanger(thistype.m_zoneDornheim, "", tr("Dornheim"), tr("Dornheim ist ein kleines Dorf im Königreich der Menschen."))
			set thistype.m_zoneTalras = Zone.create("TL", gg_rct_zone_talras)
			call thistype.createZoneChanger(thistype.m_zoneTalras, "", tr("Talras"), tr("Talras ist eine Burg im Grenzland des Königreichs der Menschen."))
			set thistype.m_zoneGardonar = Zone.create("GA", gg_rct_zone_gardonars_hell)
			call thistype.createZoneChanger(thistype.m_zoneGardonar, "Gardonar.tga", tr("Gardonar"), tr("Gardonar ist der Fürst der Dämonen."))
			set thistype.m_zoneGardonarsHell = Zone.create("GH", gg_rct_zone_gardonars_hell)
			call thistype.createZoneChanger(thistype.m_zoneGardonarsHell, "Gardonar.tga", tr("Gardonars Hölle"), tr("Gardonars Hölle ist voll von Dämonen."))
			set thistype.m_zoneDeranorsSwamp = Zone.create("DS", gg_rct_zone_deranors_swamp)
			call thistype.createZoneChanger(thistype.m_zoneDeranorsSwamp, "", tr("Deranors Todessumpf"), tr("Deranor der Schreckliche herrscht über die Untoten in seinem Sumpf."))
			set thistype.m_zoneHolzbruck = Zone.create("HB", gg_rct_zone_holzbruck)
			call thistype.createZoneChanger(thistype.m_zoneHolzbruck, "", tr("Holzbruck"), tr("Holzbruck ist eine reiche Handelsstadt im Königreich der Menschen."))
			set thistype.m_zoneHolzbrucksUnderworld = Zone.create("HU", gg_rct_zone_holzbrucks_underworld)
			call thistype.createZoneChanger(thistype.m_zoneHolzbrucksUnderworld, "Gardonar.tga", tr("Holzbrucks Unterwelt"), tr("In der Unterwelt von Holzbruck sammeln sich mächtige Kreaturen."))

			set thistype.m_cameraTimer = CreateTimer()
			call TimerStart(thistype.m_cameraTimer, thistype.refreshInterval, true, function thistype.timerRefreshCamera)

			//call Game.addDefaultDoodadsOcclusion()
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
			call SuspendTimeOfDay(true)
			call SetTimeOfDay(12.0)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onSelectClass takes Character character, AClass class, boolean last returns nothing
		endmethod

		/// Required by \ref ClassSelection.
		public static method onRepick takes Character character returns nothing
		endmethod

		private static method hideCharacters takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.maxPlayers)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call ACharacter.playerCharacter(Player(i)).setMovable(false)
					call Character(Character.playerCharacter(Player(i))).setCameraTimer(false)
					call ShowUnit(ACharacter.playerCharacter(Player(i)).unit(), false)
				endif
				set i = i + 1
			endloop
		endmethod

		/// Required by \ref Game.
		public static method start takes nothing returns nothing
			call FogMaskEnable(false)
			call FogEnable(false) // show the whole world map
			call CameraHeight.pause()
			call thistype.hideCharacters()
		endmethod

		/// Required by \ref Classes.
		public static method startX takes integer index returns real
			return 0.0
		endmethod

		/// Required by \ref Classes.
		public static method startY takes integer index returns real
			return 0.0
		endmethod

		/// Required by \ref Classes.
		public static method startFacing takes integer index returns real
			return 0.0
		endmethod

		/// Required by \ref MapChanger.
		public static method restoreStartX takes integer index, string zone returns real
			return 0.0
		endmethod

		/// Required by \ref MapChanger.
		public static method restoreStartY takes integer index, string zone returns real
			return 0.0
		endmethod

		/// Required by \ref MapChanger.
		public static method restoreStartFacing takes integer index, string zone returns real
			return 0.0
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacters takes string zone returns nothing
			call thistype.hideCharacters()
		endmethod

		/**
		 * \return Returns true if characters gain experience from killing units of player \p whichPlayer. Otherwise it returns false.
		 */
		public static method playerGivesXP takes player whichPlayer returns boolean
			return false
		endmethod

		public static method initVideoSettings takes nothing returns nothing
		endmethod

		public static method resetVideoSettings takes nothing returns nothing
		endmethod

		/// Required by \ref Buildings.
		public static method goldmine takes nothing returns unit
			return null
		endmethod

		/// Required by teleport spells.
		public static method excludeUnitTypeFromTeleport takes integer unitTypeId returns boolean
			return false
		endmethod
	endstruct

endlibrary