library StructMapMapMapData requires Asl, StructGameGame

	struct MapData extends MapDataInterface
		public static constant string mapMusic = "Music\\Ingame.mp3;Music\\Talras.mp3"
		public static constant integer maxPlayers = 12
		public static constant player alliedPlayer = null
		public static constant player neutralPassivePlayer = Player(PLAYER_NEUTRAL_PASSIVE)
		public static constant real morning = 5.0
		public static constant real midday = 12.0
		public static constant real afternoon = 16.0
		public static constant real evening = 18.0
		public static constant real videoWaitInterval = 1.0
		public static constant real revivalTime = 5.0
		public static constant real revivalLifePercentage = 100.0
		public static constant real revivalManaPercentage = 100.0
		public static constant integer startSkillPoints = 4
		public static constant integer levelSpellPoints = 2
		public static constant integer maxLevel = 30
		public static constant integer workerUnitTypeId = 'h00E'
		public static sound cowSound = null
		public static constant integer maxScore = 50
		private static trigger m_safeEnterTrigger
		private static trigger m_safeLeaveTrigger
		private static Shrine m_shrine
		private static leaderboard m_leaderboard
		private static trigger m_deathTrigger
		private static integer array m_score[12]
		
		//! runtextmacro optional A_STRUCT_DEBUG("\"MapData\"")

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod
		
		/// Required by \ref Game.
		// TODO split up in multiple trigger executions to avoid OpLimit, .evaluate doesn't seem to work.
		public static method init takes nothing returns nothing
			local quest whichQuest
			local questitem questItem
			local NpcTalksRoutine talkRoutine

			// info
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Regeln", "Rules"))
			call QuestSetDescription(whichQuest, tre("Zu seiner Belustigung hat Heimrich, der Herzog von Talras, euch gemeinsam in eine Arena werfen lassen aus welcher der Sieg die einzige Möglichkeit zu entkommen ist.", "For his amusement Heimrich, the duke of Talras, has thrown you into an arena from which the victory is the only possibility to escape."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNCorpseExplode.blp")
			call QuestSetEnabled(whichQuest, true)
			call QuestSetRequired(whichQuest, true)
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, Format(tre("Tötet einander bis einer der Spieler %1% Punkte erreicht hat.", "Kill each other until one player has reached %1% kills.")).i(thistype.maxScore).result())
			
			// player should look like neutral passive
			call SetPlayerColor(MapData.neutralPassivePlayer, ConvertPlayerColor(PLAYER_NEUTRAL_PASSIVE))
			
			set talkRoutine = NpcTalksRoutine.create(Routines.talk(), gg_unit_n013_0012, 0.0, 24.00, gg_rct_waypoint_heimrich_0)
			call talkRoutine.setPartner(gg_unit_n014_0038)
			call talkRoutine.addSound(tr("Was erlaubt sich das einfache Volk?"), gg_snd_Heimrich12)
			call talkRoutine.addSound(tr("Wir müssen uns auf den Krieg vorbereiten."), gg_snd_Heimrich13)
			call talkRoutine.addSound(tr("Hat Er sich um alles Nötige gekümmert?"), gg_snd_Heimrich14)
			call talkRoutine.addSound(tr("Bald werden sie hier einfallen und dann?"), gg_snd_Heimrich15)
			
			set talkRoutine = NpcTalksRoutine.create(Routines.talk(), gg_unit_n014_0038, 0.0, 24.00, gg_rct_waypoint_markward_0)
			call talkRoutine.setPartner(gg_unit_n013_0012)
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
			elseif (class == Classes.dragonSlayer()) then
				// sword and morning star
				call UnitAddItemToSlotById(whichUnit, ItemTypes.shortword().itemType(), 2)
				call UnitAddItemToSlotById(whichUnit, 'I06I', 3)
			elseif (class == Classes.druid()) then
				// simple druid staff
				call UnitAddItemToSlotById(whichUnit, 'I06J', 2)
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
			elseif (character.class() == Classes.dragonSlayer()) then
				// sword and morning star
				call character.giveItem(ItemTypes.shortword().itemType())
				call character.giveItem('I06I')
			elseif (character.class() == Classes.druid()) then
				// simple druid staff
				call character.giveItem('I06J')
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
		
		public static method setCameraBoundsToMapForPlayer takes player user returns nothing
			call ResetCameraBoundsToMapRectForPlayer(user)
		endmethod

		/// Required by \ref Classes.
		public static method setCameraBoundsToPlayableAreaForPlayer takes player user returns nothing
			call SetCameraBoundsToRectForPlayerBJ(user, gg_rct_area_playable)
		endmethod

		/// Required by \ref Game.
		public static method resetCameraBoundsForPlayer takes player user returns nothing
		endmethod
		
		private static method filterSummoned takes nothing returns boolean
			return IsUnitType(GetFilterUnit(), UNIT_TYPE_SUMMONED)
		endmethod
		
		private static method triggerConditionEnterSafe takes nothing returns boolean
			local integer i = 0
			local AGroup summonedUnits = 0
			if (ACharacter.isUnitCharacter(GetTriggerUnit())) then
				set i = 0
				loop
					exitwhen (i == thistype.maxPlayers)
					if (GetPlayerId(GetOwningPlayer(GetTriggerUnit())) != i) then
						call SetPlayerAllianceStateBJ(Player(i), GetOwningPlayer(GetTriggerUnit()), bj_ALLIANCE_NEUTRAL)
						call SetPlayerAllianceStateBJ(GetOwningPlayer(GetTriggerUnit()), Player(i), bj_ALLIANCE_NEUTRAL)
					endif
					set i = i + 1
				endloop
				call SetUnitInvulnerable(GetTriggerUnit(), true)
				
				set summonedUnits = AGroup.create()
				call summonedUnits.addUnitsInRect(gg_rct_area_playable, Filter(function thistype.filterSummoned))
				set i = 0
				loop
					exitwhen (i == summonedUnits.units().size())
					if (GetOwningPlayer(summonedUnits.units()[i]) == GetOwningPlayer(GetTriggerUnit())) then
						call KillUnit(summonedUnits.units()[i])
					endif
					set i = i + 1
				endloop
				call summonedUnits.destroy()
				set summonedUnits = 0
			endif
		
			
			return false
		endmethod
		
		private static method triggerConditionLeaveSafe takes nothing returns boolean
			local integer i = 0
			if (ACharacter.isUnitCharacter(GetTriggerUnit())) then
				set i = 0
				loop
					exitwhen (i == thistype.maxPlayers)
					if (GetPlayerId(GetOwningPlayer(GetTriggerUnit())) != i and not RectContainsUnit(gg_rct_area_safe, ACharacter.playerCharacter(Player(i)).unit())) then
						call SetPlayerAllianceStateBJ(Player(i), GetOwningPlayer(GetTriggerUnit()), bj_ALLIANCE_UNALLIED)
						call SetPlayerAllianceStateBJ(GetOwningPlayer(GetTriggerUnit()), Player(i), bj_ALLIANCE_UNALLIED)
					endif
					set i = i + 1
				endloop
				call SetUnitInvulnerable(GetTriggerUnit(), false)
			endif
			
			return false
		endmethod
		
		private static method randomWord takes nothing returns string
			local integer random = GetRandomInt(0, 3)
			if (random == 0) then
				return tre("zermalmt", "crushed")
			elseif (random == 1) then
				return tre("geplättet", "nuked")
			elseif (random == 2) then
				return tre("abgeschlachtet", "slaughtered")
			endif
			
			return tr("gezeigt wo der Hammer hängt")
		endmethod
		
		private static method victory takes player whichPlayer returns nothing
			local integer i = 0
			loop
				exitwhen (i == thistype.maxPlayers)
				if (i != GetPlayerId(whichPlayer)) then
					call MeleeDefeatDialogBJ(Player(i), false)
				endif
				set i = i + 1
			endloop
			call MeleeVictoryDialogBJ(whichPlayer, false)
		endmethod
		
		private static method triggerConditionDeath takes nothing returns boolean
			local integer killerPlayerId
			if (GetKillingUnit() != null and ACharacter.isUnitCharacter(GetTriggerUnit()) and GetOwningPlayer(GetKillingUnit()) != GetOwningPlayer(GetTriggerUnit())) then
				call DisplayTextToForce(bj_FORCE_ALL_PLAYERS, Format(tre("%1% hat %2% %3%.", "%1% has %2% %3%.")).s(GetPlayerName(GetOwningPlayer(GetKillingUnit()))).s(GetPlayerName(GetOwningPlayer(GetTriggerUnit()))).s(thistype.randomWord()).result())
			
				set killerPlayerId = GetPlayerId(GetOwningPlayer(GetKillingUnit()))
				set thistype.m_score[killerPlayerId] = thistype.m_score[killerPlayerId] + 1
				call LeaderboardSetPlayerItemValueBJ(GetOwningPlayer(GetKillingUnit()), thistype.m_leaderboard, thistype.m_score[killerPlayerId])
				call LeaderboardSortItemsByValue(thistype.m_leaderboard, false)
				
				if (thistype.m_score[killerPlayerId] == thistype.maxScore) then
					call thistype.victory(GetOwningPlayer(GetKillingUnit()))
				endif
			endif
			
			return false
		endmethod
		
		/// Required by \ref Game.
		public static method initMapSpells takes ACharacter character returns nothing
		endmethod

		/// Required by \ref Game.
		public static method start takes nothing returns nothing
			local integer i
			
			call SetMapFlag(MAP_FOG_HIDE_TERRAIN, false)
			call SetMapFlag(MAP_FOG_ALWAYS_VISIBLE, true)
			call SetMapFlag(MAP_FOG_MAP_EXPLORED, true)
			call FogMaskEnableOff()
			call FogEnableOff()

			set thistype.m_safeEnterTrigger = CreateTrigger()
			call TriggerRegisterEnterRectSimple(thistype.m_safeEnterTrigger, gg_rct_area_safe)
			call TriggerAddCondition(thistype.m_safeEnterTrigger, Condition(function thistype.triggerConditionEnterSafe))
			
			set thistype.m_safeLeaveTrigger = CreateTrigger()
			call TriggerRegisterLeaveRectSimple(thistype.m_safeLeaveTrigger, gg_rct_area_safe)
			call TriggerAddCondition(thistype.m_safeLeaveTrigger, Condition(function thistype.triggerConditionLeaveSafe))
			
			set thistype.m_shrine = Shrine.create(gg_unit_n02D_0000, gg_dest_B008_0000, gg_rct_shrine_discover, gg_rct_shrine_revival, 312.69)
			
			set thistype.m_leaderboard = CreateLeaderboardBJ(bj_FORCE_ALL_PLAYERS, tre("Punkte:", "Kills:"))
			
			set thistype.m_deathTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_deathTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(thistype.m_deathTrigger, Condition(function thistype.triggerConditionDeath))
			
			set i = 0
			loop
				exitwhen (i == thistype.maxPlayers)
				call thistype.setupCharacter.evaluate(Player(i))
				set i = i + 1
			endloop
			
			call Character.showCharactersSchemeToAll()
			
			
			call DisplayTextToForce(bj_FORCE_ALL_PLAYERS, Format(tre("Schlachtet euch gegenseitig für Ruhm und Ehre in der Arena ab. Gewonnen hat derjenige, der zuerst %1% Gegner niedergestreckt hat.", "Slaughter each other in the arena for glory and honour. The one who slaughtered %1% enemies first has won.")).i(thistype.maxScore).result())
		endmethod
		
		private static method setupCharacter takes player whichPlayer returns nothing
			local integer j
			if (ACharacter.playerCharacter(whichPlayer) != 0) then
				set j = 0
				loop
					exitwhen (j == thistype.maxPlayers)
					if (GetPlayerId(whichPlayer) != j) then
						call SetPlayerAllianceStateBJ(whichPlayer, Player(j), bj_ALLIANCE_UNALLIED)
						call SetPlayerAllianceStateBJ(Player(j), whichPlayer, bj_ALLIANCE_UNALLIED)
					endif
					set j = j + 1
				endloop
				call SelectUnitForPlayerSingle(ACharacter.playerCharacter(whichPlayer).unit(), whichPlayer)
				call SetHeroLevel(ACharacter.playerCharacter(whichPlayer).unit(), MapData.maxLevel, false)
				call thistype.m_shrine.enableForCharacter(ACharacter.playerCharacter(whichPlayer), false)
				call ACharacter.playerCharacter(whichPlayer).setMovable(true)
				call ACharacter.playerCharacter(whichPlayer).panCamera()
				call Character.setTutorialForAll(false) // no need in a PvP map
				
				call LeaderboardAddItemBJ(whichPlayer, thistype.m_leaderboard, GetPlayerName(whichPlayer), 0)
				
				call SetUnitInvulnerable(ACharacter.playerCharacter(whichPlayer).unit(), true)
				// evaluate because of OpLimit
				call thistype.autoSkill.evaluate(whichPlayer)
			endif
		endmethod
		
		private static method autoSkill takes player whichPlayer returns nothing
			local Grimoire grimoire = Character(ACharacter.playerCharacter(whichPlayer)).grimoire()
			local integer i = 0
			local boolean result = true
			// try for every spell and do not exit before since it returns false on having the maximum level already
			loop
				exitwhen (i == grimoire.spells())
				// evaluate because of OpLimit
				if (not thistype.autoSkillGrimoireSpell.evaluate(grimoire, i)) then
					set result = false
					debug call Print("Failed at " + GetObjectName(grimoire.spell(i).ability()))
				endif
				set i = i + 1
			endloop
			call grimoire.updateUi.evaluate()
		endmethod
		
		private static method autoSkillGrimoireSpell takes Grimoire grimoire, integer index returns boolean
			return grimoire.setSpellMaxLevelByIndex.evaluate(index, false)
		endmethod

		/// Required by \ref Classes.
		public static method startX takes integer index returns real
			return GetRectCenterX(gg_rct_area_safe)
		endmethod

		/// Required by \ref Classes.
		public static method startY takes integer index returns real
			return GetRectCenterY(gg_rct_area_safe)
		endmethod
		
		/**
		 * \return Returns true if characters gain experience from killing units of player \p whichPlayer. Otherwise it returns false.
		 */
		public static method playerGivesXP takes player whichPlayer returns boolean
			return false //whichPlayer == Player(PLAYER_NEUTRAL_AGGRESSIVE) or whichPlayer == thistype.orcPlayer
		endmethod
		
		public static method initVideoSettings takes nothing returns nothing
		endmethod
		
		public static method resetVideoSettings takes nothing returns nothing
		endmethod
	endstruct

endlibrary