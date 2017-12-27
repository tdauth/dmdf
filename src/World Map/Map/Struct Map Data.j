library StructMapMapMapData requires Asl, Game

	private struct ZoneData
		/**
		 * A vector of instances of \ref thistype.
		 */
		private static AIntegerVector m_zoneData
		private static Zone m_currentZone = 0
		private Zone m_zone
		private rect m_fogOfWarRect
		private fogmodifier array m_fogModifierVisible[12] // TODO bj_MAX_PLAYERS
		private fogmodifier array m_fogModifierInvisible[12] // TODO bj_MAX_PLAYERS
		private trackable m_trackable
		private trigger m_clickTrigger
		private trigger m_trackTrigger
		private texttag m_textTag
		private boolean m_isEnabled

		public static method zoneData takes nothing returns AIntegerVector
			return thistype.m_zoneData
		endmethod

		public method zone takes nothing returns Zone
			return this.m_zone
		endmethod

		public method isEnabled takes nothing returns boolean
			return this.m_isEnabled
		endmethod

		public method enable takes nothing returns nothing
			local integer i = 0
			if (this.isEnabled()) then
				return
			endif
			call this.m_zone.enable()
			call EnableTrigger(this.m_clickTrigger)
			call EnableTrigger(this.m_trackTrigger)
			call SetTextTagVisibility(this.m_textTag, true)
			set this.m_isEnabled = true
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				call FogModifierStop(this.m_fogModifierInvisible[i])
				call FogModifierStart(this.m_fogModifierVisible[i])
				set i = i + 1
			endloop
		endmethod

		public method disable takes nothing returns nothing
			local integer i = 0
			if (not this.isEnabled()) then
				return
			endif
			call this.m_zone.disable()
			call DisableTrigger(this.m_clickTrigger)
			call DisableTrigger(this.m_trackTrigger)
			call SetTextTagVisibility(this.m_textTag, false)
			set this.m_isEnabled = false
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				call FogModifierStop(this.m_fogModifierVisible[i])
				call FogModifierStart(this.m_fogModifierInvisible[i])
				set i = i + 1
			endloop
		endmethod

		private static method dialogButtonActionTravelToCurrentZone takes ADialogButton dialogButton returns nothing
			if (thistype.m_currentZone != 0) then
				call thistype.m_currentZone.onStart.execute()
			debug else
				debug call Print("Invalid zone data: 0")
			endif
		endmethod

		private static method triggerActionChangeZone takes nothing returns nothing
			local Zone zone = Zone(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			set thistype.m_currentZone = zone

			/*
			 * Ask for the player's confirmation. Traveling means a complete map change, so make sure the player wants to travel there.
			 *
			 * The World map works for one player only, so use this one player.
			 * Otherwise, a trackable per player would have to be created.
			 */
			call AGui.playerGui(Commands.adminPlayer()).dialog().clear()
			call AGui.playerGui(Commands.adminPlayer()).dialog().setMessage(tre("Wirklich verreisen?", "Travel really?"))
			call AGui.playerGui(Commands.adminPlayer()).dialog().addDialogButtonIndex(tre("Ja", "Yes"), thistype.dialogButtonActionTravelToCurrentZone)
			call AGui.playerGui(Commands.adminPlayer()).dialog().addSimpleDialogButtonIndex(tre("Nein", "No"))
			call AGui.playerGui(Commands.adminPlayer()).dialog().show()
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

		public static method create takes Zone zone, rect fogOfWarRect, string name, string description returns thistype
			// TODO use a big invisible trackable with a big collision box
			// Box1000x1000.mdx
			local thistype this = thistype.allocate()
			local integer i = 0
			set this.m_zone = zone
			set this.m_fogOfWarRect = fogOfWarRect
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set this.m_fogModifierVisible[i] = CreateFogModifierRect(Player(i), FOG_OF_WAR_VISIBLE, this.m_fogOfWarRect, true, true)
				set this.m_fogModifierInvisible[i] = CreateFogModifierRect(Player(i), FOG_OF_WAR_MASKED, this.m_fogOfWarRect, true, true)
				call FogModifierStart(this.m_fogModifierInvisible[i])
				set i = i + 1
			endloop
			set this.m_trackable = CreateTrackableZ("units\\nightelf\\Wisp\\Wisp.mdx", GetRectCenterX(zone.rect()), GetRectCenterY(zone.rect()), 100.0, 0.0)
			set this.m_clickTrigger = CreateTrigger()
			set this.m_trackTrigger = CreateTrigger()
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
			set this.m_isEnabled = true

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

			// Make sure the container is created before using it.
			call ZoneData.init()
		endmethod

		/**
		 * Enable visited zones only.
		 * Has to be called AFTER the data is restored from the gamecache!
		 */
		private static method updateZones takes nothing returns nothing
			local ZoneData zoneData = 0
			local Zone zone = 0
			local integer i = 0
			loop
				exitwhen(i == ZoneData.zoneData().size())
				set zoneData = ZoneData(ZoneData.zoneData()[i])
				set zone = zoneData.zone()
				if (MapChanger.zoneHasSaveGame(zone.mapName())) then
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

			set thistype.m_zoneDornheim = Zone.create("DH", gg_rct_zone_dornheim)
			set thistype.m_zoneTalras = Zone.create("TL", gg_rct_zone_talras)
			set thistype.m_zoneGardonar = Zone.create("GA", gg_rct_zone_gardonar)
			set thistype.m_zoneGardonarsHell = Zone.create("GH", gg_rct_zone_gardonars_hell)
			set thistype.m_zoneDeranorsSwamp = Zone.create("DS", gg_rct_zone_deranors_swamp)
			set thistype.m_zoneHolzbruck = Zone.create("HB", gg_rct_zone_holzbruck)
			set thistype.m_zoneHolzbrucksUnderworld = Zone.create("HU", gg_rct_zone_holzbrucks_underworld)
			set thistype.m_zoneTheNorth = Zone.create("TN", gg_rct_zone_the_north)

			set thistype.m_cameraTimer = CreateTimer()
			call TimerStart(thistype.m_cameraTimer, thistype.refreshInterval, true, function thistype.timerRefreshCamera)
		endmethod

		/// Required by \ref ClassSelection.
		public static method onCreateClassSelectionItems takes AClass class, unit whichUnit returns nothing
		endmethod

		/// Required by \ref ClassSelection.
		public static method onCreateClassItems takes Character character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method onInitMapSpells takes ACharacter character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method onStart takes nothing returns nothing
			call SuspendTimeOfDay(true)
			call SetTimeOfDay(12.0)

			/*
			 * Create after start and not in map initialization because it shows fog modifiers etc.
			 */
			call ZoneData.create(thistype.m_zoneDornheim, gg_rct_zone_dornheim_fog_area, tre("Dornheim", "Dornheim"), tre("Dornheim ist ein kleines Dorf im Königreich der Menschen.", "Dornheim is a small village in the kingdom of the humans."))
			call ZoneData.create(thistype.m_zoneTalras, gg_rct_zone_talras_fog_area, tre("Talras", "Talras"), tre("Talras ist eine Burg im Grenzland des Königreichs der Menschen.", "Talras is a castle in the borderland of the kingdom of the humans."))
			call ZoneData.create(thistype.m_zoneGardonar, gg_rct_zone_gardonar_fog_area, tre("Gardonar", "Gardonar"), tre("Gardonar ist der Fürst der Dämonen.", "Gardonar is the prince of demons."))
			call ZoneData.create(thistype.m_zoneGardonarsHell, gg_rct_zone_gardonars_hell_fog_area, tre("Gardonars Hölle", "Gardonar's Hell"), tre("Gardonars Hölle ist voll von Dämonen.", "Gardonar's hell is full of demons."))
			call ZoneData.create(thistype.m_zoneDeranorsSwamp, gg_rct_zone_deranors_swamp_fog_area, tre("Deranors Todessumpf", "Deranor's Death Swamp"), tre("Deranor der Schreckliche herrscht über die Untoten in seinem Sumpf.", "Deranor the Terrible reigns over the undead in his swamp."))
			call ZoneData.create(thistype.m_zoneHolzbruck, gg_rct_zone_holzbruck_fog_area, tre("Holzbruck", "Holzbruck"), tre("Holzbruck ist eine reiche Handelsstadt im Königreich der Menschen.", "Holzbruck is a rich trading city in the kingdom of humans."))
			call ZoneData.create(thistype.m_zoneHolzbrucksUnderworld, gg_rct_zone_holzbrucks_underworld_fog_area, tre("Holzbrucks Unterwelt", "Holzbruck's Underworld"), tre("In der Unterwelt von Holzbruck sammeln sich mächtige Kreaturen.", "In the underworld of Holzbruck, powerful creatures gather."))
			call ZoneData.create(thistype.m_zoneTheNorth, gg_rct_zone_the_north_fog_area, tre("Der Norden", "The North"), tre("Im eisigen Norden leben die Nordmänner und Orks, die sich gegenseitig bekämpfen.", "In the icy north live the Northmen and Orcs fighting each other."))
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
			call CameraHeight.pause()
			call thistype.hideCharacters()
			call thistype.updateZones()
		endmethod

		/// Required by \ref MapChanger.
		public static method onRestoreCharacter takes string zone, Character character returns nothing
		endmethod


		/// Required by \ref MapChanger.
		public static method onRestoreCharacters takes string zone returns nothing
			local integer index = Zone.zoneNameIndex(zone)
			local Zone zoneFrom = 0
			call thistype.hideCharacters()
			call thistype.updateZones()

			// Pan the camera to the zone from which the characters came.
			if (index != -1) then
				set zoneFrom = Zone(Zone.zones()[index])
				call SetCameraPosition(GetRectCenterX(zoneFrom.rect()), GetRectCenterY(zoneFrom.rect()))
			debug
				debug call Print("Error: Missing zone " + zone)
			endif
		endmethod

		public static method onInitVideoSettings takes nothing returns nothing
		endmethod

		public static method onResetVideoSettings takes nothing returns nothing
		endmethod
	endstruct

endlibrary