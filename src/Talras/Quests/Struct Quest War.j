library StructMapQuestsQuestWar requires Asl, StructGameQuestArea, StructMapQuestsQuestWarLumberFromKuno, StructMapQuestsQuestWarRecruit, StructMapQuestsQuestWarSupplyFromManfred, StructMapQuestsQuestWarTrapsFromBjoern, StructMapQuestsQuestWarWeaponsFromWieland, StructMapVideosVideoPrepareForTheDefense

	struct QuestAreaWarCartDestination extends QuestArea

		public stub method onCheck takes nothing returns boolean
			call Character.displayHintToAll(tre("In dieses Gebiet müssen die Versorgungswagen und die Knechte gebracht werden.", "Supply carts and servants must be brought to this area."))
			return false
		endmethod

		public stub method onStart takes nothing returns nothing
		endmethod
	endstruct

	struct QuestAreaWarReportHeimrich extends QuestArea

		public stub method onCheck takes nothing returns boolean
			// TODO change moveManfredsSupplyToTheCamp
			local boolean result = QuestWar.quest.evaluate().questItem(QuestWar.questItemWeaponsFromWieland).state() == QuestWar.stateCompleted and QuestWar.quest.evaluate().questItem(QuestWar.questItemSupplyFromManfred).state() == QuestWar.stateCompleted and QuestWar.quest.evaluate().questItem(QuestWar.questItemLumberFromKuno).state() == QuestWar.stateCompleted and QuestWar.quest.evaluate().questItem(QuestWar.questItemTrapsFromBjoern).state() == QuestWar.stateCompleted and QuestWar.quest.evaluate().questItem(QuestWar.questItemRecruit).state() == QuestWar.stateCompleted
			if (not result) then
				call Character.displayHintToAll(tre("Schließen Sie zunächst den Auftrag \"Krieg\" ab. Danach können Sie dem Herzog Bericht erstatten.", "Complete the mission \"War\" first. After that you can report to the duke."))
			endif

			return result
		endmethod

		public stub method onStart takes nothing returns nothing
			call VideoPrepareForTheDefense.video().play()
		endmethod
	endstruct

	// TODO add quest item wait for the traps.
	struct QuestWar extends SharedQuest
		public static constant integer questItemWeaponsFromWieland = 0
		public static constant integer questItemSupplyFromManfred = 1
		public static constant integer questItemLumberFromKuno = 2
		public static constant integer questItemTrapsFromBjoern = 3
		public static constant integer questItemRecruit = 4
		public static constant integer questItemReportHeimrich = 5
		public static constant real constructionTime = 30.0
		public static constant real respawnTime = 20.0
		/**
		 * Quest area without effect to mark the destination of all carts.
		 */
		private QuestAreaWarCartDestination m_questAreaCartDestination
		private QuestAreaWarReportHeimrich m_questAreaReportHeimrich

		/**
		 * Removes all carts and recruits from their destination.
		 */
		public method cleanUnits takes nothing returns nothing
			call QuestWarWeaponsFromWieland.quest().cleanUnits()
			call QuestWarSupplyFromManfred.quest().cleanUnits()
			call QuestWarLumberFromKuno.quest().cleanUnits()
			//call QuestWarTrapsFromBjoern.quest().cleanUnits()
			call QuestWarRecruit.quest().cleanUnits()
		endmethod

		public stub method enable takes nothing returns boolean
			local boolean result = this.setState(thistype.stateNew)
			call QuestWarWeaponsFromWieland.quest().enable()
			call QuestWarSupplyFromManfred.quest().enable()
			call QuestWarLumberFromKuno.quest().enable()
			call QuestWarTrapsFromBjoern.quest().enable()
			call QuestWarRecruit.quest().enable()
			set this.m_questAreaReportHeimrich = QuestAreaWarReportHeimrich.create(gg_rct_quest_war_heimrich, true)
			set this.m_questAreaCartDestination = 0
			call this.questItem(thistype.questItemWeaponsFromWieland).setState(thistype.stateNew)
			call this.questItem(thistype.questItemSupplyFromManfred).setState(thistype.stateNew)
			call this.questItem(thistype.questItemLumberFromKuno).setState(thistype.stateNew)
			call this.questItem(thistype.questItemTrapsFromBjoern).setState(thistype.stateNew)
			call this.questItem(thistype.questItemRecruit).setState(thistype.stateNew)
			call this.questItem(thistype.questItemReportHeimrich).setState(thistype.stateNew)

			call Missions.addMissionToAll('A1CD', 'A1RE', this)

			call this.displayState()

			return result
		endmethod

		/**
		 * Enables an empty quest area to mark the carts destinations.
		 */
		public method enableCartDestination takes nothing returns nothing
			if (this.m_questAreaCartDestination == 0) then
				set this.m_questAreaCartDestination = QuestAreaWarCartDestination.create(gg_rct_quest_war_cart_destination, true)
			endif
		endmethod

		/**
		 * Makes \p whichUnit invulnerable and changes its owner.
		 */
		public method setupUnitAtDestination takes unit whichUnit returns nothing
			debug call Print("Setup unit " + GetUnitName(whichUnit))
			call SetUnitPathing(whichUnit, false)
			call UnitAddAbility(whichUnit, 'Aloc') // makes the unit unselectable and disables collision
			debug call Print("Disable unit pathing of unit " + GetUnitName(whichUnit))
			call SetUnitOwner(whichUnit, MapSettings.neutralPassivePlayer(), true)
			call IssueImmediateOrder(whichUnit, "stop")
			call SetUnitInvulnerable(whichUnit, true)
		endmethod

		private static method stateActionCompletedReportHeimrich takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.m_questAreaCartDestination.destroy()
			set this.m_questAreaCartDestination = 0
		endmethod

		public stub method distributeRewards takes nothing returns nothing
			// TODO besonderer Gegenstand für die Klasse

			// call this method, otherwise the characters do not get their rewards
			call super.distributeRewards()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Krieg", "War"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNCallToArms.blp")
			call this.setDescription(tre("Um die bevorstehenden Angriffe der Orks und Dunkelelfen aufzuhalten, muss der eroberte Außenposten versorgt werden.  Außerdem müssen Fallen vor den Mauern aufgestellt werden, die es den Feinden erschweren, den Außenposten einzunehmen. Zusätzlich müssen auf dem Bauernhof kriegstaugliche Leute angeheuert werden.", "In order to stop the impeding attacks of Orcs and Dark Elves, the conquered outpost has to be supplied. In addition, traps has to be placed before the walls that make it harder for the enemies to conquer the outpost. Furthermore, war suitable people need to be hired at the farm."))
			call this.setReward(thistype.rewardExperience, 2000)
			call this.setReward(thistype.rewardGold, 2000)

			// quest item questItemWeaponsFromWieland
			set questItem = AQuestItem.create(this, tre("Besorgt Waffen vom Schmied Wieland.", "Get weapons from the smith Wieland."))

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_wieland)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// quest item questItemSupplyFromManfred
			set questItem = AQuestItem.create(this, tre("Besorgt Nahrung vom Bauern Manfred.", "Get food from the farmer Manfred."))

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_manfred)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// quest item questItemLumberFromKuno
			set questItem = AQuestItem.create(this, tre("Besorgt Holz vom Holzfäller Kuno.", "Get wood from the lumberjack Kuno."))

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_kuno)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// quest item questItemTrapsFromBjoern
			set questItem = AQuestItem.create(this, tre("Besorgt Fallen vom Jäger Björn.", "Get traps from the hunter Björn."))

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_bjoern)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// quest item questItemRecruit
			set questItem = AQuestItem.create(this, tre("Rekrutiert kriegstaugliche Leute auf dem Bauernhof.", "Recruit war suitable people at the farm."))

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_farm)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// quest item questItemReportHeimrich
			set questItem = AQuestItem.create(this, tre("Berichtet Heimrich von eurem Erfolg.", "Report Heimrich of your success."))
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedReportHeimrich)

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_war_heimrich)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement Quest
	endstruct

endlibrary
