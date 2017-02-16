library StructMapMapMapData requires Asl, StructGameGame

	private struct ZoneData
		private static AIntegerVector m_zoneData
		private Zone m_zone
		private trackable m_trackable
		private trigger m_clickTrigger
		private trigger m_trackTrigger
		private image m_image
		private texttag m_textTag

		public static method zoneData takes nothing returns AIntegerVector
			return thistype.m_zoneData
		endmethod

		public method zone takes nothing returns Zone
			return this.m_zone
		endmethod

		public method enable takes nothing returns nothing
			call this.m_zone.enable()
			call EnableTrigger(this.m_clickTrigger)
			call EnableTrigger(this.m_trackTrigger)
			call ShowImage(this.m_image, true)
			call SetTextTagVisibility(this.m_textTag, true)
		endmethod

		public method disable takes nothing returns nothing
			call this.m_zone.disable()
			call DisableTrigger(this.m_clickTrigger)
			call DisableTrigger(this.m_trackTrigger)
			call ShowImage(this.m_image, false)
			call SetTextTagVisibility(this.m_textTag, false)
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
				exitwhen (i == MapSettings.maxPlayers())
				call DisplayTextToPlayer(Player(i), 0.0, 0.0, description)
				set i = i + 1
			endloop
		endmethod

		public static method create takes Zone zone, string imageFile, string name, string description returns thistype
			// TODO use a big invisible trackable with a big collision box
			// Box1000x1000.mdx
			local thistype this = thistype.allocate()
			set this.m_zone = zone
			set this.m_trackable = CreateTrackableZ("units\\nightelf\\Wisp\\Wisp.mdx", GetRectCenterX(zone.rect()), GetRectCenterY(zone.rect()), 100.0, 0.0)
			set this.m_clickTrigger = CreateTrigger()
			set this.m_trackTrigger = CreateTrigger()
			set this.m_image = CreateImageEx(imageFile, GetRectCenterX(zone.rect()), GetRectCenterY(zone.rect()), 150.0, 200.0, 200.0)
			set this.m_textTag = CreateTextTag()
			call SetTextTagPos(this.m_textTag, GetRectCenterX(zone.rect()), GetRectCenterY(zone.rect()), 100.0)
			call SetTextTagTextBJ(this.m_textTag, name, 18.0)
			call SetTextTagPermanent(this.m_textTag, true)
			call SetTextTagVisibility(this.m_textTag, true)
			call TriggerRegisterTrackableHitEvent(this.m_clickTrigger, this.m_trackable)
			call TriggerAddAction(this.m_clickTrigger, function thistype.triggerActionChangeZone)
			call DmdfHashTable.global().setHandleInteger(this.m_clickTrigger, 0, zone)
			call TriggerRegisterTrackableTrackEvent(this.m_trackTrigger, this.m_trackable)
			call TriggerAddAction(this.m_trackTrigger, function thistype.triggerActionTrack)
			call DmdfHashTable.global().setHandleInteger(this.m_trackTrigger, 0, zone)
			call DmdfHashTable.global().setHandleStr(this.m_trackTrigger, 1, description)
			call ShowImage(this.m_image, true)
			//call ShowUnit(zone.iconUnit(), false)

			call thistype.m_zoneData.pushBack(this)

			return this
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_zoneData = AIntegerVector.create()
		endmethod
	endstruct

	/**
	 * \brief The world map allows the player to travel to other maps in the singleplayer campaign.
	 */
	struct MapData
		private static constant real refreshInterval = 0.05

		private static Zone m_zoneDeranorsSwamp
		private static Zone m_zoneGardonarsHell
		private static Zone m_zoneGardonar
		private static Zone m_zoneHolzbruck
		private static Zone m_zoneHolzbrucksUnderworld
		private static Zone m_zoneTalras
		private static Zone m_zoneDornheim
		private static Zone m_zoneTheNorth

		private static timer m_cameraTimer

		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		/// Required by \ref Game.
		public static method initSettings takes nothing returns nothing
			call MapSettings.setMapName("WM")
			call MapSettings.setMapMusic("Sound\\Music\\mp3Music\\War3XMainScreen.mp3")
			call MapSettings.setGoldmine(null)
			call MapSettings.setNeutralPassivePlayer(Player(7))
			call MapSettings.setPlayerGivesXP(Player(PLAYER_NEUTRAL_AGGRESSIVE), false)
			call MapSettings.setAllowTravelingWithOtherUnits(true)

			// Make sure the container is created before using it.
			call ZoneData.init()
		endmethod

		/**
		 * Enable visited zones only.
		 */
		private static method updateZones takes nothing returns nothing
			local ZoneData zoneData = 0
			local Zone zone = 0
			local string zoneSaveGame = ""
			local integer i = 0
			loop
				exitwhen(i == ZoneData.zoneData().size())
				set zoneData = ZoneData(ZoneData.zoneData()[i])
				set zone = zoneData.zone()
				set zoneSaveGame = MapChanger.currentSaveGamePath(zone.mapName())
				if (SaveGameExists(zoneSaveGame)) then
					call zoneData.enable()
				else
					call zoneData.disable()
				endif
				set i = i + 1
			endloop
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
			call SetPlayerColor(MapSettings.neutralPassivePlayer(), ConvertPlayerColor(PLAYER_NEUTRAL_PASSIVE))
			call SetMapFlag(MAP_FOG_HIDE_TERRAIN, false)
			call SetMapFlag(MAP_FOG_MAP_EXPLORED, true)
			call SetMapFlag(MAP_FOG_ALWAYS_VISIBLE, true)

			set thistype.m_zoneDornheim = Zone.create("DH", gg_rct_zone_dornheim)
			call ZoneData.create(thistype.m_zoneDornheim, "", tre("Dornheim", "Dornheim"), tr("Dornheim ist ein kleines Dorf im Königreich der Menschen."))
			set thistype.m_zoneTalras = Zone.create("TL", gg_rct_zone_talras)
			call ZoneData.create(thistype.m_zoneTalras, "", tre("Talras", "Talras"), tr("Talras ist eine Burg im Grenzland des Königreichs der Menschen."))
			set thistype.m_zoneGardonar = Zone.create("GA", gg_rct_zone_gardonar)
			call ZoneData.create(thistype.m_zoneGardonar, "Gardonar.tga", tre("Gardonar", "Gardonar"), tr("Gardonar ist der Fürst der Dämonen."))
			set thistype.m_zoneGardonarsHell = Zone.create("GH", gg_rct_zone_gardonars_hell)
			call ZoneData.create(thistype.m_zoneGardonarsHell, "Gardonar.tga", tre("Gardonars Hölle", "Gardonar's Hell"), tre("Gardonars Hölle ist voll von Dämonen.", "Gardonar's hell is full of demons."))
			set thistype.m_zoneDeranorsSwamp = Zone.create("DS", gg_rct_zone_deranors_swamp)
			call ZoneData.create(thistype.m_zoneDeranorsSwamp, "", tre("Deranors Todessumpf", "Deranor's Death Swamp"), tr("Deranor der Schreckliche herrscht über die Untoten in seinem Sumpf."))
			set thistype.m_zoneHolzbruck = Zone.create("HB", gg_rct_zone_holzbruck)
			call ZoneData.create(thistype.m_zoneHolzbruck, "", tre("Holzbruck", "Holzbruck"), tr("Holzbruck ist eine reiche Handelsstadt im Königreich der Menschen."))
			set thistype.m_zoneHolzbrucksUnderworld = Zone.create("HU", gg_rct_zone_holzbrucks_underworld)
			call ZoneData.create(thistype.m_zoneHolzbrucksUnderworld, "Gardonar.tga", tre("Holzbrucks Unterwelt", "Holzbruck's Underworld"), tr("In der Unterwelt von Holzbruck sammeln sich mächtige Kreaturen."))
			set thistype.m_zoneTheNorth = Zone.create("TN", gg_rct_zone_the_north)
			call ZoneData.create(thistype.m_zoneTheNorth, "", tre("Der Norden", "The North"), tr("Im eisigen Norden leben die Nordmänner und Orks, die sich gegenseitig bekämpfen."))

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
				exitwhen (i == MapSettings.maxPlayers())
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
			call thistype.updateZones()
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacter takes string zone, Character character returns nothing
		endmethod


		/// Required by \ref MapChanger.
		public static method onRestoreCharacters takes string zone returns nothing
			call thistype.hideCharacters()
			call thistype.updateZones()
		endmethod

		public static method initVideoSettings takes nothing returns nothing
		endmethod

		public static method resetVideoSettings takes nothing returns nothing
		endmethod
	endstruct

endlibrary