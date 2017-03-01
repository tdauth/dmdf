library StructMapQuestsQuestDeranor requires Asl, StructGameCharacter, StructMapMapFellows, StructMapMapNpcRoutines, StructMapMapNpcs, StructMapTalksTalkDragonSlayer, StructMapVideosVideoDeranor, StructMapVideosVideoDeranorsDeath

	struct QuestAreaDeranor extends QuestArea

		public stub method onStart takes nothing returns nothing
			local integer i
			// hide death spawn point
			call SpawnPoints.deathVault().disable()
			set i = 0
			loop
				exitwhen (i == SpawnPoints.deathVault().countUnits())
				debug call Print("Pausing and hiding death vault spawn point unit: " + GetUnitName(SpawnPoints.deathVault().unit(i)))
				call PauseUnit(SpawnPoints.deathVault().unit(i), true)
				call ShowUnit(SpawnPoints.deathVault().unit(i), false)
				set i = i + 1
			endloop

			// TODO Maybe enable the shrine for all characters?
			// TODO Move characters down
			call VideoDeranor.video().play()
			call waitForVideo(Game.videoWaitInterval)

			call WaygateSetDestination(gg_unit_n02I_0264, GetRectCenterX(gg_rct_tomb_inside), GetRectCenterY(gg_rct_tomb_inside))
			call WaygateActivate(gg_unit_n02I_0264, true)
			call WaygateSetDestination(gg_unit_n02I_0295, GetRectCenterX(gg_rct_tomb_outside), GetRectCenterY(gg_rct_tomb_outside))
			call WaygateActivate(gg_unit_n02I_0295, true)

			call QuestDeranor.quest.evaluate().questItem(QuestDeranor.questItemEnterTheTomb).setState(QuestDeranor.stateCompleted)
			call QuestDeranor.quest.evaluate().questItem(QuestDeranor.questItemKillDeranor).setState(QuestDeranor.stateNew)
			call QuestDeranor.quest.evaluate().displayUpdate()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	struct QuestAreaDeranorsTomb extends QuestArea

		public stub method onStart takes nothing returns nothing
			call QuestDeranor.quest.evaluate().completeMeetAtDeranorsTomb.execute()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	struct QuestDeranor extends SharedQuest
		public static constant integer questItemEnterTheTomb = 0
		public static constant integer questItemKillDeranor = 1
		public static constant integer questItemMeetAtTomb = 2
		private QuestAreaDeranor m_questArea
		private QuestAreaDeranorsTomb m_questAreaDeranorsTomb

		public stub method distributeRewards takes nothing returns nothing
			local integer i
			local item whichItem

			call super.distributeRewards()
			/*
			 * Zacken von Deranors Krone
			 * 3 Schattensteine
			 */
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (Character.playerCharacter(Player(i)) != 0) then
					call Character(Character.playerCharacter(Player(i))).giveItem('I04A')
					call Character(Character.playerCharacter(Player(i))).giveItem('I04B')
					call Character(Character.playerCharacter(Player(i))).giveItem('I04B')
					call Character(Character.playerCharacter(Player(i))).giveItem('I04B')
				endif
				set i = i + 1
			endloop

			call Character.displayItemAcquiredToAll(GetObjectName('I04A'), tre("Ein verzauberter Zacken der Krone Deranors des Schrecklichen.", "An enchanted tines of the crown of Deranor the Terrible."))
			call Character.displayItemAcquiredToAll(GetObjectName('I04B'), tre("Ruft einen Schattenriesen herbei.", "Summons a Shadow Giant."))
		endmethod

		public stub method enable takes nothing returns boolean
			set this.m_questArea = QuestAreaDeranor.create(gg_rct_quest_deranor_characters)

			return super.enableUntil(thistype.questItemEnterTheTomb)
		endmethod

		private static method stateEventCompleted1 takes AQuestItem questItem, trigger usedTrigger returns nothing
			call TriggerRegisterUnitEvent(usedTrigger, Npcs.deranor(), EVENT_UNIT_DEATH)
		endmethod

		private static method stateConditionCompleted1 takes AQuestItem questItem returns boolean
			return true
		endmethod

		private static method stateActionCompleted1 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			local item whichItem
			local integer i = 0
			// drop some items as reward for every player
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (Character.playerCharacter(Player(i)) != 0) then
					set whichItem = CreateItem('I04B', GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()))
					call SetItemPlayer(whichItem, Player(i), true)
					call SetItemCharges(whichItem, 3)

					set whichItem = CreateItem('I00B', GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()))
					call SetItemPlayer(whichItem, Player(i), true)
					call SetItemCharges(whichItem, 5)

					set whichItem = CreateItem('I00C', GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()))
					call SetItemPlayer(whichItem, Player(i), true)
					call SetItemCharges(whichItem, 5)
				endif
				set i = i + 1
			endloop


			set this.m_questAreaDeranorsTomb = QuestAreaDeranorsTomb.create(gg_rct_quest_deranor_tomb)
			call this.questItem(thistype.questItemMeetAtTomb).setState(thistype.stateNew)
			call this.displayState()
		endmethod

		public method completeMeetAtDeranorsTomb takes nothing returns nothing
			local integer i = 0
			call Fellows.dragonSlayer().reset()
			call TalkDragonSlayer.initTalk()
			call NpcRoutines.initDragonSlayerSells()
			call AUnitRoutine.manualStart(Npcs.dragonSlayer())

			call VideoDeranorsDeath.video().play()
			call waitForVideo(Game.videoWaitInterval)

			call this.complete()

			// wait until the video has played to complete the quest
			// hide death spawn point
			call SpawnPoints.deathVault().enable()
			set i = 0
			loop
				exitwhen (i == SpawnPoints.deathVault().countUnits())
				debug call Print("Unpausing and showing death vault spawn point unit: " + GetUnitName(SpawnPoints.deathVault().unit(i)))
				call PauseUnit(SpawnPoints.deathVault().unit(i), false)
				call ShowUnit(SpawnPoints.deathVault().unit(i), true)
				set i = i + 1
			endloop
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Deranor der Schreckliche", "Deranor the Terrible"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNPowerLich.blp")
			call this.setDescription(tre("In der Todesgruft soll es einen Eingang zu einem Gewölbe unter der Erde geben. Dort soll sich der mächtige Nekromant Deranor der Schreckliche aufhalten. Die Drachentöterin bittet euch darum, ihn gemeinsam mit ihr zu vernichten, um Mittillant vor einer weiteren Bedrohung zu bewahren.", "In the tomb of death there will be an entrance to the vault under the ground. There the mighty necromancer Deranor the Terrible is believed to be. The dragon slayer asks you to destroy him to destroy him with her in order to preserve Mittilant before a further threat."))
			call this.setReward(thistype.rewardExperience, 1000)

			set questItem = AQuestItem.create(this, tre("Betretet das unterirdische Gewölbe.", "Enter the underground vault."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_tomb_outside)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			set questItem = AQuestItem.create(this, tre("Vernichtet Deranor den Schrecklichen.", "Destroy Deranor the Terrible."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted1)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted1)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted1)
			call questItem.setPing(true)
			call questItem.setPingUnit(gg_unit_u00A_0353)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			set questItem = AQuestItem.create(this, tre("Trefft euch in Deranors Gewölbe.", "Meet at Deranor's vault."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_deranor_tomb)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement Quest
	endstruct

endlibrary