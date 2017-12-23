library StructMapMapMapCheats requires Asl, Game, MapQuests, MapVideos, StructMapMapMapData

	struct MapCheats

		private static method onCheatActionMapCheats takes ACheat cheat returns nothing
			debug call Print(tre("Örtlichkeiten-Cheats:", "Location Cheats:"))
			debug call Print("bonus")
			debug call Print("start")
			debug call Print("castle")
			debug call Print("talras")
			debug call Print("farm")
			debug call Print("forest")
			debug call Print("aos")
			debug call Print("aosentry")
			debug call Print("tomb")
			debug call Print("orccamp")
			debug call Print(tre("Video-Cheats:", "Video Cheats:"))
			debug call Print("intro")
			debug call Print("rescuedago0")
			debug call Print("rescuedago1")
			debug call Print("thecastle")
			debug call Print("thedukeoftalras")
			debug call Print("thechief")
			debug call Print("thefirstcombat")
			debug call Print("wigberht")
			debug call Print("anewalliance")
			debug call Print("dragonhunt")
			debug call Print("deathvault")
			debug call Print("bloodthirstiness")
			debug call Print("deranor")
			debug call Print("deranorsdeath")
			debug call Print("recruitthehighelf")
			debug call Print("prepareforthedefense")
			debug call Print("thedefenseoftalras")
			debug call Print("dararos")
			debug call Print("victory")
			debug call Print("holzbruck")
			debug call Print("upstream")
			debug call Print(tre("Handlungs-Cheats:", "Plot Cheats:"))
			debug call Print("aftertalras")
			debug call Print("afterthenorsemen")
			debug call Print("afterslaughter")
			debug call Print("afterderanor")
			debug call Print("afterthebattle")
			debug call Print("afterwar")
			debug call Print("afterthedefenseoftalras")
			debug call Print(tre("Zonen-Cheats:", "Zone Cheats:"))
			debug call Print("zoneholzbruck")
			debug call Print("zonegardonar")
			debug call Print("loadtalras")
			debug call Print(tre("Erzeugungs-Cheats:", "Spawn Cheats:"))
			debug call Print("unitspawns")
			debug call Print("iron")
		endmethod

		private static method onCheatActionBonus takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_bonus)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call SetCameraBoundsToRectForPlayerBJ(whichPlayer, gg_rct_bonus)
			set whichPlayer = null
		endmethod

		private static method onCheatActionStart takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_start)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call Dungeon.resetCameraBoundsForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionCamp takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_camp)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call Dungeon.resetCameraBoundsForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionCastle takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_castle)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call Dungeon.resetCameraBoundsForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionTalras takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_talras)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call Dungeon.resetCameraBoundsForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionFarm takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_farm)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call Dungeon.resetCameraBoundsForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionForest takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_cheat_forest)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call Dungeon.resetCameraBoundsForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionAos takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_shrine_baldar_discover)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call Dungeon.resetCameraBoundsForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionAosEntry takes ACheat cheat returns nothing
			local player whichPlayer = GetTriggerPlayer()
			call ACharacter.playerCharacter(whichPlayer).setRect(gg_rct_aos_outside)
			call IssueImmediateOrder(ACharacter.playerCharacter(whichPlayer).unit(), "stop")
			call Dungeon.resetCameraBoundsForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		private static method onCheatActionTomb takes ACheat cheat returns nothing
			call ACharacter.playerCharacter(GetTriggerPlayer()).setRect(gg_rct_cheat_tomb)
			call IssueImmediateOrder(ACharacter.playerCharacter(GetTriggerPlayer()).unit(), "stop")
		endmethod

		private static method onCheatActionOrcCamp takes ACheat cheat returns nothing
			call ACharacter.playerCharacter(GetTriggerPlayer()).setRect(gg_rct_cheat_orc_camp)
			call IssueImmediateOrder(ACharacter.playerCharacter(GetTriggerPlayer()).unit(), "stop")
		endmethod

		private static method onCheatActionIntro takes ACheat cheat returns nothing
			call VideoIntro.video().play()
		endmethod

		private static method onCheatActionRescueDago0 takes ACheat cheat returns nothing
			call VideoRescueDago0.video().play()
		endmethod

		private static method onCheatActionRescueDago1 takes ACheat cheat returns nothing
			call VideoRescueDago1.video().play()
		endmethod

		private static method onCheatActionTheCastle takes ACheat cheat returns nothing
			call VideoTheCastle.video().play()
		endmethod

		private static method onCheatActionTheDukeOfTalras takes ACheat cheat returns nothing
			call VideoTheDukeOfTalras.video().play()
		endmethod

		private static method onCheatActionTheChief takes ACheat cheat returns nothing
			call VideoTheChief.video().play()
		endmethod

		private static method onCheatActionTheFirstCombat takes ACheat cheat returns nothing
			call VideoTheFirstCombat.video().play()
		endmethod

		private static method onCheatActionWigberht takes ACheat cheat returns nothing
			call VideoWigberht.video().play()
		endmethod

		private static method onCheatActionANewAlliance takes ACheat cheat returns nothing
			call VideoANewAlliance.video().play()
		endmethod

		private static method onCheatActionDragonHunt takes ACheat cheat returns nothing
			call VideoDragonHunt.video().play()
		endmethod

		private static method onCheatActionDeathVault takes ACheat cheat returns nothing
			call VideoDeathVault.video().play()
		endmethod

		private static method onCheatActionBloodthirstiness takes ACheat cheat returns nothing
			call VideoBloodthirstiness.video().play()
		endmethod

		private static method onCheatActionDeranor takes ACheat cheat returns nothing
			call VideoDeranor.video().play()
		endmethod

		private static method onCheatActionDeranorsDeath takes ACheat cheat returns nothing
			call VideoDeranorsDeath.video().play()
		endmethod

		private static method onCheatActionRecruitTheHighElf takes ACheat cheat returns nothing
			call VideoRecruitTheHighElf.video().play()
		endmethod

		private static method onCheatActionPrepareForTheDefense takes ACheat cheat returns nothing
			call VideoPrepareForTheDefense.video().play()
		endmethod

		private static method onCheatActionTheDefenseOfTalras takes ACheat cheat returns nothing
			call VideoTheDefenseOfTalras.video().play()
		endmethod

		private static method onCheatActionDararos takes ACheat cheat returns nothing
			call VideoDararos.video().play()
		endmethod

		private static method onCheatActionVictory takes ACheat cheat returns nothing
			call VideoVictory.video().play()
		endmethod

		private static method onCheatActionHolzbruck takes ACheat cheat returns nothing
			call VideoHolzbruck.video().play()
		endmethod

		private static method onCheatActionUpstream takes ACheat cheat returns nothing
			call VideoUpstream.video().play()
		endmethod

		private static method moveCharactersToRect takes rect whichRect returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					/*
					 * If the character is already standing in the rect move outside first to trigger the event afterwards.
					 */
					if (RectContainsUnit(whichRect, ACharacter.playerCharacter(Player(i)).unit())) then
						call SetUnitX(ACharacter.playerCharacter(Player(i)).unit(), GetRectMaxX(whichRect) + 100.0)
						call SetUnitY(ACharacter.playerCharacter(Player(i)).unit(), GetRectMaxY(whichRect) + 100.0)
					endif

					call SetUnitX(ACharacter.playerCharacter(Player(i)).unit(), GetRectCenterX(whichRect))
					call SetUnitY(ACharacter.playerCharacter(Player(i)).unit(), GetRectCenterY(whichRect))
				endif
				set i = i + 1
			endloop
		endmethod

		private static method makeCharactersInvulnerable takes boolean invulnerable returns nothing
			local integer i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call SetUnitInvulnerable(ACharacter.playerCharacter(Player(i)).unit(), invulnerable)
				endif
				set i = i + 1
			endloop
		endmethod

		private static method onCheatActionAfterTalras takes ACheat cheat returns nothing
			call thistype.makeCharactersInvulnerable(true)
			if (not QuestTalras.quest().isCompleted()) then
				if (not QuestTalras.quest().isNew()) then
					debug call Print("New quest Talras")
					if (not QuestTalras.quest().enable()) then
						debug call Print("Failed enabling quest Talras")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestTalras.quest().questItem(QuestTalras.questItemReachTheCastle).isCompleted()) then
					debug call Print("Complete quest item 0 Talras")
					/*
					 * Plays video "The Castle".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_talras_quest_item_0)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					if (not  QuestTalras.quest().questItem(QuestTalras.questItemReachTheCastle).isCompleted()) then
						debug call Print("Failed completing quest item meet at reach the castle.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestTalras.quest().questItem(QuestTalras.questItemMeetHeimrich).isCompleted()) then
					debug call Print("Complete quest item 1 Talras")
					/*
					 * Plays video "The Duke of Talras".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_talras_quest_item_1)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
				endif
			endif
			call thistype.makeCharactersInvulnerable(false)
		endmethod

		private static method onCheatActionAfterTheNorsemen takes ACheat cheat returns nothing
			call thistype.makeCharactersInvulnerable(true)
			if (not QuestTalras.quest().isCompleted()) then
				debug call Print("Quest Talras must be completed before.")
				call thistype.makeCharactersInvulnerable(false)
				return
			endif
			/*
			 * Quest The Norsemen must be at least new now.
			 */
			if (not QuestTheNorsemen.quest().isCompleted()) then
				if (not QuestTheNorsemen.quest().isNew()) then
					if (not QuestTheNorsemen.quest().enable()) then
						debug call Print("Failed enabling quest The Norsemen")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestTheNorsemen.quest().questItem(QuestTheNorsemen.questItemMeetTheNorsemen).isCompleted()) then
					/*
					 * Plays video "The Chief".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_the_norsemen_quest_item_0)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					if (not  QuestTheNorsemen.quest().questItem(QuestTheNorsemen.questItemMeetTheNorsemen).isCompleted()) then
						debug call Print("Failed completing quest item meet at the norsemen.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestTheNorsemen.quest().questItem(QuestTheNorsemen.questItemMeetAtTheBattlefield).isCompleted()) then
					/*
					 * Plays video "The First combat".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_the_norsemen_assembly_point)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					if (not  QuestTheNorsemen.quest().questItem(QuestTheNorsemen.questItemMeetAtTheBattlefield).isCompleted()) then
						debug call Print("Failed completing quest item meet at the battlefield.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestTheNorsemen.quest().questItem(QuestTheNorsemen.questItemFight).isCompleted()) then
					/*
					 * TODO cleanup does not work! Remove fighting troops, disable leaderboard etc.
					 * TODO Does not change the state!
					 */
					if (QuestTheNorsemen.quest().completeFight()) then

					else
						debug call Print("Failed completing quest item fight.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif


				if (not QuestTheNorsemen.quest().questItem(QuestTheNorsemen.questItemMeetAtTheOutpost).isCompleted()) then
					/*
					 * Plays video "Wigberht".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_the_defense_of_talras)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)

					if (not  QuestTheNorsemen.quest().questItem(QuestTheNorsemen.questItemMeetAtTheOutpost).isCompleted()) then
						debug call Print("Failed completing quest item meet at the outpost.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestTheNorsemen.quest().questItem(QuestTheNorsemen.questItemReportHeimrich).isCompleted()) then
					/*
					 * Plays video "A new alliance"
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_talras_quest_item_1)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
				endif
			endif
			call thistype.makeCharactersInvulnerable(false)
		endmethod

		private static method onCheatActionAfterSlaughter takes ACheat cheat returns nothing
			call thistype.makeCharactersInvulnerable(true)
			if (not QuestSlaughter.quest().isCompleted()) then
				if (not QuestSlaughter.quest().isNew()) then
					if (not QuestSlaughter.quest().enable()) then
						debug call Print("Enabling quest Slaughter failed.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				// TODO it would be safer to complete the single quest items
				call QuestSlaughter.quest().complete()
				call TriggerSleepAction(2.0 + 2.0)
				call waitForVideo(Game.videoWaitInterval)
				call TriggerSleepAction(2.0 + 2.0)
			endif
			call thistype.makeCharactersInvulnerable(false)
		endmethod

		private static method onCheatActionAfterDeranor takes ACheat cheat returns nothing
			call thistype.makeCharactersInvulnerable(true)

			if (not QuestSlaughter.quest().isCompleted()) then
				debug call Print("Quest Slaughter must be completed before.")
				call thistype.makeCharactersInvulnerable(false)
				return
			endif

			if (not QuestDeranor.quest().isCompleted()) then
				if (not QuestDeranor.quest().isNew()) then
					if (not QuestDeranor.quest().enable()) then
						debug call Print("Enabling quest Deranor failed.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestDeranor.quest().questItem(QuestDeranor.questItemEnterTheTomb).isCompleted()) then
					/*
					 * Plays video "Deranor".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_deranor_characters)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					if (not QuestDeranor.quest().questItem(QuestDeranor.questItemEnterTheTomb).isCompleted()) then
						debug call Print("Failed to complete enter the tomb.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestDeranor.quest().questItem(QuestDeranor.questItemKillDeranor).isCompleted()) then
					/*
					 * Plays video "Deranor's Death".
					 */
					call KillUnit(gg_unit_u00A_0353)

					if (not QuestDeranor.quest().questItem(QuestDeranor.questItemKillDeranor).isCompleted()) then
						debug call Print("Failed to complete kill deranor.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestDeranor.quest().questItem(QuestDeranor.questItemMeetAtTomb).isCompleted()) then
					/*
					 * Plays video "Deranor's Death".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_deranor_tomb)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)
					if (not QuestDeranor.quest().questItem(QuestDeranor.questItemMeetAtTomb).isCompleted()) then
						debug call Print("Failed to complete kill deranor.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif
			endif
			call thistype.makeCharactersInvulnerable(false)
		endmethod

		/**
		 * This cheat action tries to emulate that the battle with the norseman has been done and now the quest "A new alliance" is active.
		 * Therefore the following quests have been completed:
		 * Talras
		 * The Norsemen
		 * Slaughter
		 * Deranor
		 *
		 * All events which happened by these quests must be emulated.
		 */
		private static method onCheatActionAfterTheBattle takes ACheat cheat returns nothing
			call thistype.onCheatActionAfterTalras(cheat)
			call thistype.onCheatActionAfterTheNorsemen(cheat)
			call thistype.onCheatActionAfterSlaughter(cheat)
			call thistype.onCheatActionAfterDeranor(cheat)
		endmethod

		private static method onCheatActionAfterANewAlliance takes ACheat cheat returns nothing
			call thistype.onCheatActionAfterTheBattle(cheat)

			call thistype.makeCharactersInvulnerable(true)

			if (not QuestDeranor.quest().isCompleted()) then
				debug call Print("Quest Deranor must be completed before.")
				call thistype.makeCharactersInvulnerable(false)
				return
			endif


			if (not QuestANewAlliance.quest().isCompleted()) then
				/*
				 * Plays video "A New Alliance".
				 */
				call thistype.moveCharactersToRect(gg_rct_quest_a_new_alliance)

				call TriggerSleepAction(2.0 + 2.0)
				call waitForVideo(Game.videoWaitInterval)
				call TriggerSleepAction(2.0 + 2.0)
				if (not QuestANewAlliance.quest().isCompleted()) then
					debug call Print("Failed to complete quest Deranor.")
					call thistype.makeCharactersInvulnerable(false)
					return
				endif
			endif

			call thistype.makeCharactersInvulnerable(false)
		endmethod

		private static method onCheatActionAfterWar takes ACheat cheat returns nothing
			local integer i = 0
			call thistype.onCheatActionAfterANewAlliance(cheat)

			call thistype.makeCharactersInvulnerable(true)

			if (not QuestANewAlliance.quest().isCompleted()) then
				debug call Print("Quest A New Alliance must be completed before.")
				call thistype.makeCharactersInvulnerable(false)
				return
			endif

			if (not QuestWar.quest().isCompleted()) then

				if (not QuestWarWeaponsFromWieland.quest().questItem(QuestWarWeaponsFromWieland.questItemWeaponsFromWieland).isCompleted()) then
					/*
					 * Plays video "Wieland".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_war_wieland)

					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)

					if (not QuestWarWeaponsFromWieland.quest().questItem(QuestWarWeaponsFromWieland.questItemIronFromTheDrumCave).isCompleted()) then
						/*
						 * Plays video "Iron From The Drum Cave".
						 */
						call thistype.moveCharactersToRect(gg_rct_quest_war_iron_from_the_drum_cave)

						call TriggerSleepAction(2.0 + 2.0)
						call waitForVideo(Game.videoWaitInterval)
						call TriggerSleepAction(2.0 + 2.0)
					endif

					if (not QuestWarWeaponsFromWieland.quest().questItem(QuestWarWeaponsFromWieland.questItemMoveImpsToWieland).isCompleted()) then
						call QuestWarWeaponsFromWieland.quest().moveImpsToWieland()
						if (not QuestWarWeaponsFromWieland.quest().questItem(QuestWarWeaponsFromWieland.questItemMoveImpsToWieland).isCompleted()) then
							debug call Print("Failed to complete quest item move imps to wieland.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif

					endif

					if (not QuestWarWeaponsFromWieland.quest().questItem(QuestWarWeaponsFromWieland.questItemReportWieland).isCompleted()) then
						/*
						 * Plays video "Weapons From Wieland".
						 */
						call thistype.moveCharactersToRect(gg_rct_quest_war_wieland)
						call TriggerSleepAction(2.0 + 2.0)
						call waitForVideo(Game.videoWaitInterval)
						call TriggerSleepAction(2.0 + 2.0)
						if (not QuestWarWeaponsFromWieland.quest().questItem(QuestWarWeaponsFromWieland.questItemReportWieland).isCompleted()) then
							debug call Print("Failed to complete quest item report wieland.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
						if (not QuestWarWeaponsFromWieland.quest().questItem(QuestWarWeaponsFromWieland.questItemIronFromTheDrumCave).isCompleted()) then
							debug call Print("Failed to complete quest item iron from the drum cave.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif

					if (not QuestWarWeaponsFromWieland.quest().questItem(QuestWarWeaponsFromWieland.questItemWaitForWielandsWeapons).isCompleted()) then
						call TriggerSleepAction(QuestWar.constructionTime + 2.0)

						if (not QuestWarWeaponsFromWieland.quest().questItem(QuestWarWeaponsFromWieland.questItemWaitForWielandsWeapons).isCompleted()) then
							debug call Print("Failed to complete quest item wait for wielands weapons.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif

					if (not QuestWarWeaponsFromWieland.quest().questItem(QuestWarWeaponsFromWieland.questItemMoveWielandWeaponsToTheCamp).isCompleted()) then
						/*
						 * Completes questItemMoveWielandWeaponsToTheCamp and questItemWeaponsFromWieland.
						 */
						call QuestWarWeaponsFromWieland.quest().moveWeaponsCartToCamp()

						call TriggerSleepAction(1.0)

						if (not QuestWarWeaponsFromWieland.quest().questItem(QuestWarWeaponsFromWieland.questItemMoveWielandWeaponsToTheCamp).isCompleted()) then
							debug call Print("Failed to complete quest item move wieland weapons to the camp.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif

					if (not QuestWarWeaponsFromWieland.quest().questItem(QuestWarWeaponsFromWieland.questItemWeaponsFromWieland).isCompleted()) then
						debug call Print("Failed to complete quest item  weapons from wieland.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestWarSupplyFromManfred.quest().questItem(QuestWarSupplyFromManfred.questItemSupplyFromManfred).isCompleted()) then
					/*
					 * Plays video "Manfred".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_war_manfred)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)

					if (not QuestWarSupplyFromManfred.quest().questItem(QuestWarSupplyFromManfred.questItemSupplyFromManfred).isNew()) then
						debug call Print("Failed to enable quest item supply from manfred.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif

					if (not QuestWarSupplyFromManfred.quest().questItem(QuestWarSupplyFromManfred.questItemKillTheCornEaters).isCompleted()) then
						call SpawnPoints.cornEaters0().spawnDeadOnly()
						call SpawnPoints.cornEaters1().spawnDeadOnly()
						call SpawnPoints.cornEaters2().spawnDeadOnly()
						call SpawnPoints.cornEaters3().spawnDeadOnly()
						call SpawnPoints.cornEaters4().spawnDeadOnly()
						call SpawnPoints.cornEaters0().kill()
						call SpawnPoints.cornEaters1().kill()
						call SpawnPoints.cornEaters2().kill()
						call SpawnPoints.cornEaters3().kill()
						call SpawnPoints.cornEaters4().kill()

						if (not QuestWarSupplyFromManfred.quest().questItem(QuestWarSupplyFromManfred.questItemKillTheCornEaters).isCompleted()) then
							debug call Print("Failed to complete quest item kill the corn eaters.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif

					if (not QuestWarSupplyFromManfred.quest().questItem(QuestWarSupplyFromManfred.questItemReportManfred).isCompleted()) then
						/*
						* Plays video "Report Manfred".
						*/
						call thistype.moveCharactersToRect(gg_rct_quest_war_manfred)
						call TriggerSleepAction(2.0 + 2.0)
						call waitForVideo(Game.videoWaitInterval)
						call TriggerSleepAction(2.0 + 2.0)

						if (not QuestWarSupplyFromManfred.quest().questItem(QuestWarSupplyFromManfred.questItemReportManfred).isCompleted()) then
							debug call Print("Failed to complete quest item report manfred.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif

					if (not QuestWarSupplyFromManfred.quest().questItem(QuestWarSupplyFromManfred.questItemWaitForManfredsSupply).isCompleted()) then
						call TriggerSleepAction(QuestWar.constructionTime + 2.0)

						if (not QuestWarSupplyFromManfred.quest().questItem(QuestWarSupplyFromManfred.questItemWaitForManfredsSupply).isCompleted()) then
							debug call Print("Failed to complete quest item wait for manfreds supply.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif

					if (not QuestWarSupplyFromManfred.quest().questItem(QuestWarSupplyFromManfred.questItemMoveManfredsSupplyToTheCamp).isCompleted()) then
						call QuestWarSupplyFromManfred.quest().moveSupplyCartToCamp()

						call TriggerSleepAction(1.0)

						if (not QuestWarSupplyFromManfred.quest().questItem(QuestWarSupplyFromManfred.questItemMoveManfredsSupplyToTheCamp).isCompleted()) then
							debug call Print("Failed to complete quest item move manfreds supply to the camp.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif

					if (not QuestWarSupplyFromManfred.quest().questItem(QuestWarSupplyFromManfred.questItemSupplyFromManfred).isCompleted()) then
						debug call Print("Failed to complete quest item supply from manfred.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestWarLumberFromKuno.quest().questItem(QuestWarLumberFromKuno.questItemLumberFromKuno).isCompleted()) then
					/*
					 * Plays video "Kuno".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_war_kuno)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)

					if (not QuestWarLumberFromKuno.quest().questItem(QuestWarLumberFromKuno.questItemLumberFromKuno).isNew()) then
						debug call Print("Failed to enable quest item lumber from kuno.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif

					if (not QuestWarLumberFromKuno.quest().questItem(QuestWarLumberFromKuno.questItemKillTheWitches).isCompleted()) then
						call SpawnPoints.witch0().spawnDeadOnly()
						call SpawnPoints.witch1().spawnDeadOnly()
						call SpawnPoints.witch2().spawnDeadOnly()
						call SpawnPoints.witches().spawnDeadOnly()
						call SpawnPoints.witch0().kill()
						call SpawnPoints.witch1().kill()
						call SpawnPoints.witch2().kill()
						call SpawnPoints.witches().kill()

						if (not QuestWarLumberFromKuno.quest().questItem(QuestWarLumberFromKuno.questItemKillTheWitches).isCompleted()) then
							debug call Print("Failed to complete quest item kill the witches.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif

					if (not QuestWarLumberFromKuno.quest().questItem(QuestWarLumberFromKuno.questItemReportKuno).isCompleted()) then
						/*
						 * Plays video "Report Kuno".
						 */
						call thistype.moveCharactersToRect(gg_rct_quest_war_kuno)
						call TriggerSleepAction(2.0 + 2.0)
						call waitForVideo(Game.videoWaitInterval)
						call TriggerSleepAction(2.0 + 2.0)

						if (not QuestWarLumberFromKuno.quest().questItem(QuestWarLumberFromKuno.questItemReportKuno).isCompleted()) then
							debug call Print("Failed to complete quest item report kuno.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif

					if (not QuestWarLumberFromKuno.quest().questItem(QuestWarLumberFromKuno.questItemMoveKunosLumberToTheCamp).isCompleted()) then
						call QuestWarLumberFromKuno.quest().moveLumberCartToCamp()

						call TriggerSleepAction(1.0)

						if (not QuestWarLumberFromKuno.quest().questItem(QuestWarLumberFromKuno.questItemMoveKunosLumberToTheCamp).isCompleted()) then
							debug call Print("Failed to complete quest item report kuno.")
							call thistype.makeCharactersInvulnerable(false)
							return
						endif
					endif

					if (not QuestWarLumberFromKuno.quest().questItem(QuestWarLumberFromKuno.questItemLumberFromKuno).isCompleted()) then
						debug call Print("Failed to complete quest item lumber from kuno.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestWarTrapsFromBjoern.quest().questItem(QuestWarTrapsFromBjoern.questItemTrapsFromBjoern).isCompleted()) then
					/*
					 * Plays video "Bjoern".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_war_bjoern)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)

					if (not QuestWarTrapsFromBjoern.quest().questItem(QuestWarTrapsFromBjoern.questItemPlaceTraps).isNew()) then
						debug call Print("Failed to enable quest item place traps.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif

					/*
					 * Placing traps
					 */
					set i = 0
					loop
						exitwhen (i == QuestWarTrapsFromBjoern.maxPlacedTraps)
						call QuestWarTrapsFromBjoern.quest().addTrap(GetRectCenterX(gg_rct_quest_war_bjoern_place_traps), GetRectCenterY(gg_rct_quest_war_bjoern_place_traps))
						set i = i + 1
					endloop
					call QuestWarTrapsFromBjoern.quest().questItem(QuestWarTrapsFromBjoern.questItemPlaceTraps).complete()

					if (not QuestWarTrapsFromBjoern.quest().questItem(QuestWarTrapsFromBjoern.questItemPlaceTraps).isCompleted()) then
						debug call Print("Failed to complete quest item place traps.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestWarRecruit.quest().questItem(QuestWarRecruit.questItemRecruit).isCompleted()) then
					/*
					 * Plays video "Recruit".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_war_farm)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)

					if (not QuestWarRecruit.quest().questItem(QuestWarRecruit.questItemRecruit).isNew()) then
						debug call Print("Failed to enable quest item recruit.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif

					set i = 0
					loop
						exitwhen (i == QuestWarRecruit.maxRecruits)
						call CreateUnit(MapSettings.alliedPlayer(), 'n02J', GetRectCenterX(gg_rct_quest_war_cart_destination), GetRectCenterY(gg_rct_quest_war_cart_destination), 0.0)
						set i = i + 1
					endloop

					if (not QuestWarRecruit.quest().questItem(QuestWarRecruit.questItemGetRecruits).isCompleted() or not QuestWarRecruit.quest().questItem(QuestWarRecruit.questItemRecruit).isCompleted()) then
						debug call Print("Failed to complete quest item get recruits or quest item recruit.")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				/*
				 * Plays video "Prepare For The Defense".
				 */
				call thistype.moveCharactersToRect(gg_rct_quest_war_heimrich)
				call TriggerSleepAction(2.0 + 2.0)
				call waitForVideo(Game.videoWaitInterval)
				call TriggerSleepAction(2.0 + 2.0)

				if (not QuestWar.quest().isCompleted()) then
					debug call Print("Failed to complete quest war.")
					call thistype.makeCharactersInvulnerable(false)
					return
				endif
			endif

			call thistype.makeCharactersInvulnerable(false)
		endmethod

		private static method onCheatActionAfterTheDefenseOfTalras takes ACheat cheat returns nothing
			local integer i = 0
			call thistype.onCheatActionAfterWar(cheat)

			call thistype.makeCharactersInvulnerable(true)

			if (not QuestWar.quest().isCompleted()) then
				debug call Print("Quest War must be completed before.")
				call thistype.makeCharactersInvulnerable(false)
				return
			endif

			if (not QuestTheDefenseOfTalras.quest().isCompleted()) then

				if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemMoveToCamp).isCompleted()) then
					/*
					 * Plays video "The Defense Of Talras".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_the_defense_of_talras)

					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)

					if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemMoveToCamp).isCompleted()) then
						debug call Print("Error on completing quest item move to camp")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemPrepare).isCompleted()) then
					call QuestTheDefenseOfTalras.quest().finishTimer()

					if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemPrepare).isCompleted()) then
						debug call Print("Error on completing quest item prepare")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemDefendAgainstOrcs).isCompleted()) then
					call QuestTheDefenseOfTalras.quest().finishDefendAgainstOrcs()

					if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemDefendAgainstOrcs).isCompleted()) then
						debug call Print("Error on completing quest item defend against the orcs")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemDestroyArtillery).isCompleted()) then
					call QuestTheDefenseOfTalras.quest().finishDestroyArtillery()

					if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemDestroyArtillery).isCompleted()) then
						debug call Print("Error on completing quest item destroy artillery")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemGatherAtTheCamp).isCompleted()) then
					/*
					 * Plays video "Dararos".
					 */
					call thistype.moveCharactersToRect(gg_rct_quest_the_defense_of_talras)
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)

					if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemGatherAtTheCamp).isCompleted()) then
						debug call Print("Error on completing quest item gather at the camp")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemDefeatTheEnemy).isCompleted()) then
					call QuestTheDefenseOfTalras.quest().finishDefeatTheEnemy()

					// plays video "Victory"
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)

					if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemDefeatTheEnemy).isCompleted()) then
						debug call Print("Error on completing quest item defeat the enemy")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

				if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemReportHeimrich).isCompleted()) then
					call thistype.moveCharactersToRect(gg_rct_quest_the_defense_of_talras_heimrich)

					// plays video "Holzbruck"
					call TriggerSleepAction(2.0 + 2.0)
					call waitForVideo(Game.videoWaitInterval)
					call TriggerSleepAction(2.0 + 2.0)

					if (not QuestTheDefenseOfTalras.quest().questItem(QuestTheDefenseOfTalras.questItemReportHeimrich).isCompleted()) then
						debug call Print("Error on completing quest item report heimrich")
						call thistype.makeCharactersInvulnerable(false)
						return
					endif
				endif

			endif

			call thistype.makeCharactersInvulnerable(false)
		endmethod

		private static method onCheatActionZoneGardonar takes ACheat cheat returns nothing
			debug call Print("Change map to Gardonar")
			call MapChanger.changeMap(MapData.zoneGardonar().mapName())
		endmethod

		private static method onCheatActionZoneHolzbruck takes ACheat cheat returns nothing
			debug call Print("Change map to Holzbruck")
			call MapChanger.changeMap(MapData.zoneHolzbruck().mapName())
		endmethod

		private static method onCheatActionLoadTalras takes ACheat cheat returns nothing
			debug call Print("Loading Talras")
			call LoadGame("TPoF\\Campaign The Power of Fire shit\\Talras0.8.w3z", false)
		endmethod

		private static method onCheatActionIron takes ACheat cheat returns nothing
			local item whichItem = CreateItem('I05Z', GetRectCenterX(gg_rct_character_0_start), GetRectCenterY(gg_rct_character_0_start))
			call SetItemCharges(whichItem, 300)
			set whichItem = null
		endmethod

		private static method onCheatActionVectorRemoval takes ACheat cheat returns nothing
			local AIntegerVector vector = AIntegerVector.create()
			call vector.pushBack(1)
			call vector.remove(1)
			call vector.destroy()
		endmethod

static if (DEBUG_MODE) then
		private static method onInit takes nothing returns nothing
			local ACheat cheat = 0
			debug call Print(tre("|c00ffcc00TEST-MODUS|r", "|c00ffcc00TEST MODE|r"))
			debug call Print(tre("Sie befinden sich im Testmodus. Verwenden Sie den Cheat \"mapcheats\", um eine Liste sämtlicher Karten-Cheats zu erhalten.", "You are in test mode. Use the cheat \"mapcheats\" to get a list of all map cheats."))
			debug call Print("Before creating \"mapcheats\"")
			set cheat = ACheat.create("mapcheats", true, thistype.onCheatActionMapCheats)
			debug call Print("After creating \"mapcheats\": " + I2S(cheat))
			call ACheat.create("bonus", true, thistype.onCheatActionBonus)
			call ACheat.create("start", true, thistype.onCheatActionStart)
			call ACheat.create("camp", true, thistype.onCheatActionCamp)
			call ACheat.create("castle", true, thistype.onCheatActionCastle)
			call ACheat.create("talras", true, thistype.onCheatActionTalras)
			call ACheat.create("farm", true, thistype.onCheatActionFarm)
			call ACheat.create("forest", true, thistype.onCheatActionForest)
			call ACheat.create("aos", true, thistype.onCheatActionAos)
			call ACheat.create("aosentry", true, thistype.onCheatActionAosEntry)
			call ACheat.create("tomb", true, thistype.onCheatActionTomb)
			call ACheat.create("orccamp", true, thistype.onCheatActionOrcCamp)
			// videos
			call ACheat.create("intro", true, thistype.onCheatActionIntro)
			call ACheat.create("rescuedago0", true, thistype.onCheatActionRescueDago0)
			call ACheat.create("rescuedago1", true, thistype.onCheatActionRescueDago1)
			call ACheat.create("thecastle", true, thistype.onCheatActionTheCastle)
			call ACheat.create("thedukeoftalras", true, thistype.onCheatActionTheDukeOfTalras)
			call ACheat.create("thechief", true, thistype.onCheatActionTheChief)
			call ACheat.create("thefirstcombat", true, thistype.onCheatActionTheFirstCombat)
			call ACheat.create("wigberht", true, thistype.onCheatActionWigberht)
			call ACheat.create("anewalliance", true, thistype.onCheatActionANewAlliance)
			call ACheat.create("dragonhunt", true, thistype.onCheatActionDragonHunt)
			call ACheat.create("deathvault", true, thistype.onCheatActionDeathVault)
			call ACheat.create("bloodthirstiness", true, thistype.onCheatActionBloodthirstiness)
			call ACheat.create("deranor", true, thistype.onCheatActionDeranor)
			call ACheat.create("deranorsdeath", true, thistype.onCheatActionDeranorsDeath)
			call ACheat.create("recruitthehighelf", true, thistype.onCheatActionRecruitTheHighElf)
			call ACheat.create("prepareforthedefense", true, thistype.onCheatActionPrepareForTheDefense)
			call ACheat.create("thedefenseoftalras", true, thistype.onCheatActionTheDefenseOfTalras)
			call ACheat.create("dararos", true, thistype.onCheatActionDararos)
			call ACheat.create("victory", true, thistype.onCheatActionVictory)
			call ACheat.create("holzbruck", true, thistype.onCheatActionHolzbruck)
			call ACheat.create("upstream", true, thistype.onCheatActionUpstream)
			// plot cheats
			call ACheat.create("aftertalras", true, thistype.onCheatActionAfterTalras)
			call ACheat.create("afterthenorsemen", true, thistype.onCheatActionAfterTheNorsemen)
			call ACheat.create("afterslaughter", true, thistype.onCheatActionAfterSlaughter)
			call ACheat.create("afterderanor", true, thistype.onCheatActionAfterDeranor)
			call ACheat.create("afterthebattle", true, thistype.onCheatActionAfterTheBattle)
			call ACheat.create("afteranewalliance", true, thistype.onCheatActionAfterANewAlliance)
			call ACheat.create("afterwar", true, thistype.onCheatActionAfterWar)
			call ACheat.create("afterthedefenseoftalras", true, thistype.onCheatActionAfterTheDefenseOfTalras)
			// zones
			call ACheat.create("zonegardonar", true, thistype.onCheatActionZoneGardonar)
			call ACheat.create("zoneholzbruck", true, thistype.onCheatActionZoneHolzbruck)
			call ACheat.create("loadtalras", true, thistype.onCheatActionLoadTalras)
			// test cheats
			call ACheat.create("iron", true, thistype.onCheatActionIron)
			call ACheat.create("vectorremoval", true, thistype.onCheatActionVectorRemoval)
			debug call Print("Before creating all cheats")
		endmethod
endif

	endstruct

endlibrary