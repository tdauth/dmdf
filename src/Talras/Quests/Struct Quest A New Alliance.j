library StructMapQuestsQuestANewAlliance requires Asl, StructGameQuestArea, StructMapVideosVideoRecruitTheHighElf, StructMapQuestsQuestDeranor

	struct QuestAreaANewAlliance extends QuestArea
	
		public stub method onCheck takes nothing returns boolean
			return QuestDeranor.quest().isCompleted()
		endmethod
	
		public stub method onStart takes nothing returns nothing
			call QuestANewAlliance.quest.evaluate().questItem(0).setState(AQuest.stateCompleted)
			call QuestANewAlliance.quest.evaluate().questItem(1).setState(AQuest.stateCompleted)
			call QuestANewAlliance.quest.evaluate().displayUpdate()
			call VideoRecruitTheHighElf.video().play()
		endmethod
	
		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct

	struct QuestANewAlliance extends AQuest
		private QuestAreaANewAlliance m_questArea

		implement Quest

		public stub method enable takes nothing returns boolean
			set this.m_questArea = QuestAreaANewAlliance.create(gg_rct_quest_a_new_alliance)
			return this.enableUntil(1)
		endmethod

		public stub method disable takes nothing returns boolean
			return super.disable()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(0, tr("Ein neues Bündnis"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNSylvanusWindrunner.blp")
			call this.setDescription(tr("Da der Herzog noch mehr Verbündete benötigt, sollt ihr eine Hochelfin aufsuchen, die durch die hiesigen Ländereien des Herzogs zieht. Sie soll den Herzog beim Kampf gegen die Orks und Dunkelelfen Unterstützung anbieten."))
			call this.setReward(AAbstractQuest.rewardExperience, 400)
			call this.setReward(AAbstractQuest.rewardGold, 200)
			// quest item 0
			set questItem = AQuestItem.create(this, tr("Findet die Hochelfin in Talras."))
			
			//call questItem.setPing(true)
			//call questItem.setPingRect(gg_rct_haldar_spawn_point_0)
			//call questItem.setPingColour(100.0, 100.0, 100.0)
			// quest item 1
			set questItem = AQuestItem.create(this, tr("Überzeugt sie davon sich mit Heimrich dem Herzog zu treffen."))

			return this
		endmethod
	endstruct

endlibrary
