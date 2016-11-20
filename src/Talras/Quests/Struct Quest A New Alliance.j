library StructMapQuestsQuestANewAlliance requires Asl, StructGameQuestArea, StructMapVideosVideoRecruitTheHighElf, StructMapQuestsQuestDeranor

	struct QuestANewAlliance extends SharedQuest
		private QuestAreaANewAlliance m_questArea

		public stub method enable takes nothing returns boolean
			call Missions.addMissionToAll('A1CE', 'A1RB', this)
			set this.m_questArea = QuestAreaANewAlliance.create.evaluate(gg_rct_quest_a_new_alliance)
			return this.enableUntil(1)
		endmethod

		public stub method disable takes nothing returns boolean
			return super.disable()
		endmethod

		public method completeFinding takes nothing returns nothing
			call this.questItem(0).setState(thistype.stateCompleted)
			call this.questItem(1).setState(thistype.stateCompleted)
			call this.displayUpdate()
			call VideoRecruitTheHighElf.video().play()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Ein neues Bündnis", "A New Alliance"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNSylvanusWindrunner.blp")
			call this.setDescription(tre("Da der Herzog noch mehr Verbündete benötigt, sollt ihr eine Hochelfin aufsuchen, die durch die hiesigen Ländereien des Herzogs zieht. Sie soll den Herzog beim Kampf gegen die Orks und Dunkelelfen Unterstützung anbieten.", "Since the Duke still needs more allies you shall seek the High Elf who travels through the local estates of the Duke. She shall provide support to the Duke for the battle with the Orcs and Dark Elves."))
			call this.setReward(AAbstractQuest.rewardExperience, 400)
			call this.setReward(AAbstractQuest.rewardGold, 200)
			// quest item 0
			set questItem = AQuestItem.create(this, tre("Findet die Hochelfin in Talras.", "Find the High Elf in Talras."))

			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_a_new_alliance)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// quest item 1
			set questItem = AQuestItem.create(this, tre("Überzeugt sie davon sich mit Heimrich dem Herzog zu treffen.", "Convice her to meet with the Duke Heimrich."))

			return this
		endmethod

		implement Quest
	endstruct

	struct QuestAreaANewAlliance extends QuestArea

		public stub method onCheck takes nothing returns boolean
			if (not QuestDeranor.quest().isCompleted()) then
				call Character.displayHintToAll(tre("Sie müssen erst den Auftrag \"Deranor\" abschließen bevor dieser Auftrag begonnen werden kann.", "First you have to complete the mission \"Deranor\" before this mission can be started."))
				return false
			endif

			return true
		endmethod

		public stub method onStart takes nothing returns nothing
			call QuestANewAlliance.quest().completeFinding()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

endlibrary
