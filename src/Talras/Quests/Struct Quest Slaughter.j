library StructMapQuestsQuestSlaughter requires Asl, StructGameCharacter, StructMapMapFellows, StructMapMapNpcs, StructMapMapSpawnPoints, StructMapVideosVideoBloodthirstiness, StructMapVideosVideoDeathVault, StructMapVideosVideoDragonHunt

	struct QuestAreaSlaughter extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoDragonHunt.video().play()
			call waitForVideo(Game.videoWaitInterval)
			call QuestSlaughter.quest.evaluate().enable.evaluate()
			call Fellows.dragonSlayer().shareWith(0)
			call Character.displayUnitAcquiredToAll(GetUnitName(Npcs.dragonSlayer()), tre("Die Drachentöterin kann zwischen Nah- und Fernkampf wechseln.", "The Dragon Slayer can switch between close and range combat."))
			//call TransmissionFromUnit(Npcs.dragonSlayer(), tre("In der Nähe befindet sich ein mächtiger Vampir, der über eine Hand voll Diener gebietet. Es wird Zeit, ihn abzuschlachten und dieses Land von einem weiteren Parasiten zu befreien!", "Nearby there is a powerful vampire who rules over a handful of servants. It is time to slaughter him and to free this land from another parasite!"), gg_snd_DragonSlayerSlaughter1)
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	struct QuestAreaSlaughterEnter extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoDeathVault.video().play()
			call waitForVideo(Game.videoWaitInterval)
			call QuestSlaughter.quest.evaluate().questItem(QuestSlaughter.questItemEnterTheDeathVault).setState(AAbstractQuest.stateCompleted)
			call QuestSlaughter.quest.evaluate().questItem(QuestSlaughter.questItemKillTheMedusa).setState(AAbstractQuest.stateNew)
			call QuestSlaughter.quest.evaluate().questItem(QuestSlaughter.questItemKillTheDiacon).setState(AAbstractQuest.stateNew)
			call QuestSlaughter.quest.evaluate().displayUpdate()
			call setQuestItemPingByUnitTypeId.execute(QuestSlaughter.quest.evaluate(), SpawnPoints.deathVault(), UnitTypes.medusa)
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	struct QuestAreaSlaughterFinish extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoBloodthirstiness.video().play()
			call waitForVideo(Game.videoWaitInterval)
			call QuestSlaughter.quest.evaluate().complete()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	struct QuestSlaughter extends SharedQuest
		public static constant integer questItemKillTheBroodMother = 0
		public static constant integer questItemKillTheVampireLord = 1
		public static constant integer questItemKillTheVampires = 2
		public static constant integer questItemKillTheDeathAngel = 3
		public static constant integer questItemKillTheBoneDragons = 4
		public static constant integer questItemEnterTheDeathVault = 5
		public static constant integer questItemKillTheMedusa = 6
		public static constant integer questItemKillTheDiacon = 7
		public static constant integer questItemMeetAtTheDeathVault = 8
		private QuestAreaSlaughter m_questArea
		private QuestAreaSlaughterEnter m_questAreaEnter
		private QuestAreaSlaughterFinish m_questAreaFinish

		public stub method enable takes nothing returns boolean
			call Missions.addMissionToAll('A1C1', 'A1RD', this)
			return super.enableUntil(thistype.questItemKillTheBoneDragons)
		endmethod

		public stub method distributeRewards takes nothing returns nothing
			local integer i
			local item whichItem
			/// \todo JassHelper bug
			//call AQuest.distributeRewards()
			/*
			Blutamulett
			Drachenschuppe
			2 Götzenbilder
			2 große Heiltränke
			2 große Manatränke
			*/
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (Character.playerCharacter(Player(i)) != 0) then
					call Character(Character.playerCharacter(Player(i))).giveItem('I02L')
					call Character(Character.playerCharacter(Player(i))).giveItem('I02M')
					call Character(Character.playerCharacter(Player(i))).giveItem('I00B')
					call Character(Character.playerCharacter(Player(i))).giveItem('I00B')
					call Character(Character.playerCharacter(Player(i))).giveItem('I00C')
					call Character(Character.playerCharacter(Player(i))).giveItem('I00C')
					call Character(Character.playerCharacter(Player(i))).giveItem('I05O')
					call Character(Character.playerCharacter(Player(i))).giveItem('I05O')
				endif
				set i = i + 1
			endloop

			call Character.displayItemAcquiredToAll(GetObjectName('I02L'), tre("Ein Teil des am Träger verursachten Schadens wird auf den Verursacher zurückgeworfen.", "Part of the damage caused to the holder will be thrown back to the causing unit."))
			call Character.displayItemAcquiredToAll(GetObjectName('I02M'), tre("Macht den Verzehrenden eine Zeit lang unverwundbar.", "Makes the consumer invulnerable for some time."))
		endmethod

		private static method stateEventCompleted takes AQuestItem questItem, trigger whichTrigger returns nothing
			// the units owner might be different due to abilities
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DEATH)
		endmethod

		private method checkForDeathVault takes nothing returns nothing
			if (this.questItem(thistype.questItemKillTheVampireLord).isCompleted() and this.questItem(thistype.questItemKillTheVampires).isCompleted() and this.questItem(thistype.questItemKillTheDeathAngel).isCompleted() and this.questItem(thistype.questItemKillTheBoneDragons).isCompleted()) then
				set this.m_questAreaEnter = QuestAreaSlaughterEnter.create(gg_rct_quest_slaughter_death_vault)
				call this.questItem(thistype.questItemEnterTheDeathVault).setState(thistype.stateNew)
			else
				if (this.questItem(thistype.questItemKillTheVampireLord).isNew()) then
					call setQuestItemPingByUnitTypeId.execute(this.questItem(thistype.questItemKillTheVampireLord), SpawnPoints.vampireLord0(), UnitTypes.vampireLord)
				endif

				if (this.questItem(thistype.questItemKillTheVampires).isNew()) then
					call setQuestItemPingByUnitTypeId.execute(this.questItem(thistype.questItemKillTheVampires), SpawnPoints.vampires0(), UnitTypes.vampire)
				endif

				if (this.questItem(thistype.questItemKillTheDeathAngel).isNew()) then
					call setQuestItemPingByUnitTypeId.execute(this.questItem(thistype.questItemKillTheDeathAngel), SpawnPoints.deathAngel(), UnitTypes.deathAngel)
				endif

				if (this.questItem(thistype.questItemKillTheBoneDragons).isNew()) then
					call setQuestItemPingByUnitTypeId.execute(this.questItem(thistype.questItemKillTheBoneDragons), SpawnPoints.boneDragons(), UnitTypes.boneDragon)
				endif
			endif

			call this.displayUpdate()
		endmethod

		private static method isUnitBroodMotherAndNotDead takes unit whichUnit returns boolean
			return GetUnitTypeId(whichUnit) == UnitTypes.broodMother and not IsUnitDeadBJ(whichUnit)
		endmethod

		private static method stateConditionCompletedBroodMother takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.broodMother and SpawnPoints.spiderQueen().countUnitsIf(thistype.isUnitBroodMotherAndNotDead) == 0
		endmethod

		private static method stateActionCompletedBroodMother takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.checkForDeathVault()
		endmethod

		private static method isUnitVampireLordAndNotDead takes unit whichUnit returns boolean
			return GetUnitTypeId(whichUnit) == UnitTypes.vampireLord and not IsUnitDeadBJ(whichUnit)
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.vampireLord and SpawnPoints.vampireLord0().countUnitsIf(thistype.isUnitVampireLordAndNotDead) == 0
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			//call TransmissionFromUnit(Npcs.dragonSlayer(), tre("Gute Arbeit! Das war aber nicht der einzige Vampir in dieser Gegend. Weiter westlich befinden sich noch mehr seiner Art.", "Good work! But that was not the only vampire in this area. Further west there are more of his kind."), gg_snd_DragonSlayerSlaughter2)
			call this.checkForDeathVault()
		endmethod

		private static method isUnitVampireAndNotDead takes unit whichUnit returns boolean
			return GetUnitTypeId(whichUnit) == UnitTypes.vampire and not IsUnitDeadBJ(whichUnit)
		endmethod

		private static method stateConditionCompleted1 takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local integer count
			if (GetUnitTypeId(GetTriggerUnit()) == UnitTypes.vampire) then
				set count = SpawnPoints.vampires0().countUnitsIf(thistype.isUnitVampireAndNotDead)
				if (count == 0) then
					return true
				// get next one to ping
				else
					call this.displayUpdateMessage(Format(tre("%1%/3 Vampire", "%1%/3 Vampires")).i(3 - count).result())
					call setQuestItemPingByUnitTypeId.execute(questItem, SpawnPoints.vampires0(), UnitTypes.vampire)
				endif
			endif
			return false
		endmethod

		private static method stateActionCompleted1 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			//call TransmissionFromUnit(Npcs.dragonSlayer(), tre("Erst gestern beobachtete ich einen dunklen Engel des Todes, weiter östlich. Lasst uns ihn vernichten!", "Just yesterday I watched a dark angel of death, further east. Let us destroy her!"), gg_snd_DragonSlayerSlaughter3)
			call this.checkForDeathVault()
		endmethod

		private static method isUnitDeathAngelAndNotDead takes unit whichUnit returns boolean
			return GetUnitTypeId(whichUnit) == UnitTypes.deathAngel and not IsUnitDeadBJ(whichUnit)
		endmethod

		private static method stateConditionCompleted2 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.deathAngel and SpawnPoints.deathAngel().countUnitsIf(thistype.isUnitDeathAngelAndNotDead) == 0
		endmethod

		private static method stateActionCompleted2 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			//call TransmissionFromUnit(Npcs.dragonSlayer(), tre("Einige untote Drachen haben sich weiter nördlich versammelt. Auf zum Kampf!", "Some undead dragons gathered further north. To the battle!"), gg_snd_DragonSlayerSlaughter4)
			call this.checkForDeathVault()
		endmethod

		private static method isUnitBoneDragonAndNotDead takes unit whichUnit returns boolean
			return GetUnitTypeId(whichUnit) == UnitTypes.boneDragon and not IsUnitDeadBJ(whichUnit)
		endmethod

		private static method stateConditionCompleted3 takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local integer count = 0
			if (GetUnitTypeId(GetTriggerUnit()) == UnitTypes.boneDragon) then
				set count = SpawnPoints.boneDragons().countUnitsIf(thistype.isUnitBoneDragonAndNotDead)
				if (count == 0) then
					return true
				// get next one to ping
				else
					call this.displayUpdateMessage(Format(tre("%1%/3 Knochendrachen", "%1%/3 Bone Dragons")).i(3 - count).result())
					call setQuestItemPingByUnitTypeId.execute(questItem, SpawnPoints.boneDragons(), UnitTypes.boneDragon)
				endif
			endif
			return false
		endmethod

		private static method stateActionCompleted3 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			//call TransmissionFromUnit(Npcs.dragonSlayer(), tre("Ausgezeichnet! In der Nähe befindet sich eine Höhle mit einer geheimen Gruft. Sie wird von Eingeweihten auch „die Todesgruft“ genannt.", "Excellent! Nearby there is a cave with a secret crypt. It is also called \"the Death Crypt\" by insiders."), gg_snd_DragonSlayerSlaughter5)
			call this.checkForDeathVault()
		endmethod

		private static method stateActionCompleted4 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call VideoDeathVault.video().play()
			call waitForVideo(Game.videoWaitInterval)
			call questItem.quest().questItem(5).setState(thistype.stateNew)
			call questItem.quest().questItem(6).setState(thistype.stateNew)
			call questItem.quest().displayUpdate()
			call setQuestItemPingByUnitTypeId.execute(this, SpawnPoints.deathVault(), UnitTypes.medusa)
		endmethod

		// TODO Leads to crash in multiplayer?
		private method finishQuest takes nothing returns nothing
			local boolean finished = (this.questItem(thistype.questItemKillTheDiacon).isCompleted() and this.questItem(thistype.questItemKillTheMedusa).isCompleted())
			// don't start the video immediately
			if (finished) then
				set this.m_questAreaFinish = QuestAreaSlaughterFinish.create(gg_rct_quest_slaughter_finish)
				call this.questItem(thistype.questItemMeetAtTheDeathVault).setState(thistype.stateNew)
				call this.displayState()
			endif
		endmethod

		private static method isUnitMedusaAndNotDead takes unit whichUnit returns boolean
			return GetUnitTypeId(whichUnit) == UnitTypes.medusa and not IsUnitDeadBJ(whichUnit)
		endmethod

		private static method stateConditionCompleted5 takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			if (GetUnitTypeId(GetTriggerUnit()) == UnitTypes.medusa and SpawnPoints.deathVault().countUnitsIf(thistype.isUnitMedusaAndNotDead) == 0) then
				if (questItem.quest().questItem(6).state() == thistype.stateNew) then
					call TransmissionFromUnit(Npcs.dragonSlayer(), tre("Dieses Drecksschlangenvieh! Los, weiter, in die Gruft hinein!", "This mud snake cattle! Come on, continue, into the crypt!"), gg_snd_DragonSlayerSlaughter6)
					call setQuestItemPingByUnitTypeId.execute(this, SpawnPoints.deathVault(), UnitTypes.deacon)
				endif

				return true
			endif

			return false
		endmethod

		private static method stateActionCompleted5 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.finishQuest()
		endmethod

		private static method isUnitDeaconAndNotDead takes unit whichUnit returns boolean
			return GetUnitTypeId(whichUnit) == UnitTypes.deacon and not IsUnitDeadBJ(whichUnit)
		endmethod

		private static method stateConditionCompleted6 takes AQuestItem questItem returns boolean
			if (GetUnitTypeId(GetTriggerUnit()) == UnitTypes.deacon and SpawnPoints.deathVault().countUnitsIf(thistype.isUnitDeaconAndNotDead) == 0) then
				if (questItem.quest().questItem(5).state() == thistype.stateNew) then
					call TransmissionFromUnit(Npcs.dragonSlayer(), tre("Verdammter Bastard! Nun noch das Schlangenvieh, dann ist es geschafft!", "Bastard! Only the serpent beast, then it's done!"), gg_snd_DragonSlayerSlaughter7)
				endif

				return true
			endif

			return false
		endmethod

		private static method stateActionCompleted6 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call ShowUnit(GetTriggerUnit(), false) // hide him to hide the blood effect
			call this.finishQuest()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Metzelei", "Slaughter"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNCorpseExplode.blp")
			call this.setDescription(tre("Die Drachentöterin verlangt von euch, sie auf ihrem Feldzug gegen die Kreaturen des Waldes zu begleiten, damit ihr anderen von ihren Heldentaten berichten könnt.", "The Dragon Slayer requires of you to accompany her on heir campaign against the creatures of the forest, so that you can report about her heroic deeds to others."))
			call this.setReward(thistype.rewardExperience, 1000)
			set this.m_questArea = QuestAreaSlaughter.create(gg_rct_quest_slaughter_enable)

			// questItemKillTheBroodMother
			set questItem = AQuestItem.create(this, tre("Tötet die Brutmutter.", "Kill the Brood Mother."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedBroodMother)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedBroodMother)

			set questItem = AQuestItem.create(this, tre("Tötet den Vampirgebieter.", "Kill the Vampire Lord."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)

			set questItem = AQuestItem.create(this, tre("Tötet die Vampire.", "Kill the vampires."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted1)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted1)

			set questItem = AQuestItem.create(this, tre("Tötet den Todesengel.", "Kill the death angel."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted2)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted2)

			set questItem = AQuestItem.create(this, tre("Tötet die Knochendrachen.", "Kill the bone dragons."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted3)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted3)

			set questItem = AQuestItem.create(this, tre("Begebt euch zur „Todesgruft“.", "Move to the \"Death Crypt\"."))
			call questItem.setPing(true)
			call questItem.setPingCoordinatesFromRect(gg_rct_quest_slaughter_death_vault)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			set questItem = AQuestItem.create(this, tre("Tötet die Medusa.", "Kill the Medusa."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted5)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted5)

			set questItem = AQuestItem.create(this, tre("Tötet den Diakon der Finsternis.", "Kill the Deacon of Darkness."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted6)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted6)

			return this
		endmethod

		implement Quest
	endstruct

endlibrary