library StructMapQuestsQuestSlaughter requires Asl, StructGameCharacter, StructMapMapFellows, StructMapMapNpcs, StructMapMapSpawnPoints, StructMapVideosVideoBloodthirstiness, StructMapVideosVideoDeathVault, StructMapVideosVideoDragonHunt

	struct QuestAreaSlaughter extends QuestArea
	
		public stub method onStart takes nothing returns nothing
			local integer i
			call VideoDragonHunt.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			debug call Print("After Video")
			call QuestSlaughter.quest.evaluate().setState(AAbstractQuest.stateNew)
			debug call Print("After setting state to new")
			call QuestSlaughter.quest.evaluate().questItem(0).setState(AAbstractQuest.stateNew)
			debug call Print("After setting state to new 2")
			call QuestSlaughter.quest.evaluate().displayState()
			debug call Print("After displaying state")
			debug call Print("Fellow: " + GetUnitName(Npcs.dragonSlayer()))
			debug call Print("Sharing fellow: " + I2S(Fellows.dragonSlayer()))
			call Fellows.dragonSlayer().shareWith(0)
			debug call Print("After sharing a fellow")
			call Character.displayUnitAcquiredToAll(GetUnitName(Npcs.dragonSlayer()), "Die Drachentöterin kann zwischen Nah- und Fernkampf wechseln.")
			call TransmissionFromUnit(Npcs.dragonSlayer(), tr("In der Nähe befindet sich ein mächtiger Vampir, der über eine Hand voll Diener gebietet. Es wird Zeit, ihn abzuschlachten und dieses Land von einem weiteren Parasiten zu befreien!"), null)
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call SetPlayerAbilityAvailable(Player(i), SpellMissionSlaughter.abilityId, true)
				set i = i + 1
			endloop
		endmethod
	
		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct
	
	struct QuestAreaSlaughterEnter extends QuestArea
	
		public stub method onStart takes nothing returns nothing
			call VideoDeathVault.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			call QuestSlaughter.quest.evaluate().questItem(4).setState(AAbstractQuest.stateCompleted)
			call QuestSlaughter.quest.evaluate().questItem(5).setState(AAbstractQuest.stateNew)
			call QuestSlaughter.quest.evaluate().questItem(6).setState(AAbstractQuest.stateNew)
			call QuestSlaughter.quest.evaluate().displayUpdate()
			call QuestSlaughter.quest.evaluate().setPingByUnitTypeId.execute(SpawnPoints.deathVault(), UnitTypes.medusa)
		endmethod
	
		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct

	struct QuestSlaughter extends AQuest
		public static constant integer questItemKillTheVampireLord = 0
		public static constant integer questItemKillTheVampires = 1
		public static constant integer questItemKillTheDeathAngel = 2
		public static constant integer questItemKillTheBoneDragons = 3
		public static constant integer questItemEnterTheDeathVault = 4
		public static constant integer questItemKillTheMedusa = 5
		public static constant integer questItemKillTheDiacon = 6
		private QuestAreaSlaughter m_questArea
		private QuestAreaSlaughterEnter m_questAreaEnter

		implement Quest

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
				exitwhen (i == MapData.maxPlayers)
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

			call Character.displayItemAcquiredToAll(GetObjectName('I02L'), tr("Ein Teil des am Träger verursachten Schadens wird auf den Verursacher zurückgeworfen."))
			call Character.displayItemAcquiredToAll(GetObjectName('I02M'), tr("Macht den Verzehrenden eine Zeit lang unverwundbar."))
		endmethod

		private static method stateEventCompleted takes AQuestItem questItem, trigger whichTrigger returns nothing
			// the units owner might be different due to abilities
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DEATH)
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.vampireLord and SpawnPoints.vampireLord0().countUnitsOfType(UnitTypes.vampireLord) == 0
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			call TransmissionFromUnit(Npcs.dragonSlayer(), tr("Gute Arbeit! Das war aber nicht der einzige Vampir in dieser Gegend. Weiter westlich befinden sich noch mehr seiner Art."), null)
			call thistype(questItem.quest()).setPingByUnitTypeId.execute(SpawnPoints.vampires0(), UnitTypes.vampire)
			call questItem.quest().questItem(1).enable()
		endmethod

		private static method stateConditionCompleted1 takes AQuestItem questItem returns boolean
			local integer count
			if (GetUnitTypeId(GetTriggerUnit()) == UnitTypes.vampire) then
				set count = SpawnPoints.vampires0().countUnitsOfType(UnitTypes.vampire)
				if (count == 0) then
					return true
				// get next one to ping
				else
					call questItem.quest().displayUpdateMessage(Format(tr("%1%/3 Vampire")).i(3 - count).result())
					call thistype(questItem.quest()).setPingByUnitTypeId.execute(SpawnPoints.vampires0(), UnitTypes.vampire)
				endif
			endif
			return false
		endmethod

		private static method stateActionCompleted1 takes AQuestItem questItem returns nothing
			call TransmissionFromUnit(Npcs.dragonSlayer(), tr("Erst gestern beobachtete ich einen dunklen Engel des Todes, weiter östlich. Lasst uns ihn vernichten!"), null)
			call thistype(questItem.quest()).setPingByUnitTypeId.execute(SpawnPoints.deathAngel(), UnitTypes.deathAngel)
			call questItem.quest().questItem(2).enable()
		endmethod

		private static method stateConditionCompleted2 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.deathAngel and SpawnPoints.deathAngel().countUnitsOfType(UnitTypes.deathAngel) == 0
		endmethod

		private static method stateActionCompleted2 takes AQuestItem questItem returns nothing
			call TransmissionFromUnit(Npcs.dragonSlayer(), tr("Einige untote Drachen haben sich weiter nördlich versammelt. Auf zum Kampf!"), null)
			call thistype(questItem.quest()).setPingByUnitTypeId.execute(SpawnPoints.boneDragons(), UnitTypes.boneDragon)
			call questItem.quest().questItem(3).enable()
		endmethod

		private static method stateConditionCompleted3 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.boneDragon and SpawnPoints.boneDragons().countUnitsOfType(UnitTypes.boneDragon) == 0
		endmethod

		private static method stateActionCompleted3 takes AQuestItem questItem returns nothing
			call TransmissionFromUnit(Npcs.dragonSlayer(), tr("Ausgezeichnet! In der Nähe befindet sich eine Höhle mit einer geheimen Gruft. Sie wird von Eingeweihten auch „die Todesgruft“ genannt."), null)
			set thistype(questItem.quest()).m_questAreaEnter = QuestAreaSlaughterEnter.create(gg_rct_quest_slaughter_death_vault)
			call questItem.quest().questItem(4).enable()
		endmethod

		private static method stateActionCompleted4 takes AQuestItem questItem returns nothing
			call VideoDeathVault.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			call questItem.quest().questItem(5).setState(thistype.stateNew)
			call questItem.quest().questItem(6).setState(thistype.stateNew)
			call questItem.quest().displayUpdate()
			call thistype(questItem.quest()).setPingByUnitTypeId.execute(SpawnPoints.deathVault(), UnitTypes.medusa)
		endmethod

		private static method stateConditionCompleted5 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.medusa and SpawnPoints.deathVault().countUnitsOfType(UnitTypes.medusa) == 0
		endmethod
		
		private static method finishQuest takes nothing returns nothing
			call VideoBloodthirstiness.video().play()
		endmethod

		private static method stateActionCompleted5 takes AQuestItem questItem returns nothing
			if (questItem.quest().questItem(6).state() == thistype.stateNew) then
				call TransmissionFromUnit(Npcs.dragonSlayer(), tr("Dieses Drecksschlangenvieh! Los, weiter, in die Gruft hinein!"), null)
				call thistype(questItem.quest()).setPingByUnitTypeId.execute(SpawnPoints.deathVault(), UnitTypes.deacon)
			else
				call thistype.finishQuest()
			endif
		endmethod

		private static method stateConditionCompleted6 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.deacon and SpawnPoints.deathVault().countUnitsOfType(UnitTypes.deacon) == 0
		endmethod

		private static method stateActionCompleted6 takes AQuestItem questItem returns nothing
			if (questItem.quest().questItem(5).state() == thistype.stateNew) then
				call TransmissionFromUnit(Npcs.dragonSlayer(), tr("Verdammter Bastard! Nun noch das Schlangenvieh, dann ist es geschafft!"), null)
			else
				call thistype.finishQuest()
			endif
		endmethod

		/// Considers death units (spawn points) and continues searching for the first one with unit type id \p unitTypeId of spawn point \p spawnPoint with an 1 second interval.
		public method setPingByUnitTypeId takes ASpawnPoint spawnPoint, integer unitTypeId returns nothing
			local unit whichUnit = spawnPoint.firstUnitOfType(unitTypeId)
			if (whichUnit == null) then
				call this.setPing(false)
				call TriggerSleepAction(1.0)
				call this.setPingByUnitTypeId.execute(spawnPoint, unitTypeId) // continue searching
			else
				call this.setPing(true)
				call this.setPingUnit(whichUnit)
				call this.setPingColour(100.0, 100.0, 100.0)
			endif
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(0, tr("Metzelei"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNCorpseExplode.blp")
			call this.setDescription(tr("Die Drachentöterin verlangt von euch, sie auf ihrem Feldzug gegen die Kreaturen des Waldes zu begleiten, damit ihr anderen von ihren Heldentaten berichten könnt."))
			call this.setReward(AAbstractQuest.rewardExperience, 1000)
			set this.m_questArea = QuestAreaSlaughter.create(gg_rct_quest_slaughter_enable)

			set questItem = AQuestItem.create(this, tr("Tötet den Vampirgebieter."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)

			call this.setPingByUnitTypeId.execute(SpawnPoints.vampireLord0(), UnitTypes.vampireLord)

			set questItem = AQuestItem.create(this, tr("Tötet die Vampire."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted1)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted1)

			set questItem = AQuestItem.create(this, tr("Tötet den Todesengel."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted2)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted2)

			set questItem = AQuestItem.create(this, tr("Tötet die Knochendrachen."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted3)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted3)

			set questItem = AQuestItem.create(this, tr("Begebt euch zur „Todesgruft“."))
			call questItem.setPing(true)
			call questItem.setPingCoordinatesFromRect(gg_rct_quest_slaughter_death_vault)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			set questItem = AQuestItem.create(this, tr("Tötet die Medusa."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted5)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted5)

			set questItem = AQuestItem.create(this, tr("Tötet den Diakon der Finsternis."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted6)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted6)

			return this
		endmethod
	endstruct

endlibrary