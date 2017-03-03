library StructMapQuestsQuestTalras requires Asl, StructMapQuestsQuestTheNorsemen, StructMapVideosVideoTheDukeOfTalras

	struct QuestAreaTalrasCastle extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoTheCastle.video().play()
			call waitForVideo(Game.videoWaitInterval)
			call ACharacter.panCameraSmartToAll()
			call QuestTalras.quest.evaluate().enableDuke.evaluate()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	struct QuestAreaTalrasDuke extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoTheDukeOfTalras.video().play()
			call waitForVideo(Game.videoWaitInterval)
			call QuestTalras.quest.evaluate().complete()
			call QuestTheNorsemen.quest().enable()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	struct QuestTalras extends SharedQuest
		public static constant integer questItemReachTheCastle = 0
		public static constant integer questItemMeetHeimrich = 1
		private QuestAreaTalrasCastle m_questAreaCastle
		private QuestAreaTalrasDuke m_questAreaDuke

		public stub method enable takes nothing returns boolean
			set this.m_questAreaCastle = QuestAreaTalrasCastle.create(gg_rct_quest_talras_quest_item_0)
			call Missions.addMissionToAll('A1BZ', 'A1R7', this)
			return this.enableUntil(thistype.questItemReachTheCastle)
		endmethod

		public method enableDuke takes nothing returns nothing
			set this.m_questAreaDuke = QuestAreaTalrasDuke.create(gg_rct_quest_talras_quest_item_1)
			call this.questItem(thistype.questItemReachTheCastle).setState(thistype.stateCompleted)
			call this.questItem(thistype.questItemMeetHeimrich).enable()
			// open the gate
			call SetDoodadAnimationRect(gg_rct_doodad_gate_talras, 'D053', "Death", false)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Talras", "Talras"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNCastle.blp")
			call this.setDescription(tre("Ihr wollt dem Herzog Heimrich von Talras die Treue schwören und damit in seinen Dienst treten, um euren Lebensunterhalt zu verdienen.", "You want to pledge loyalty to the duke Heimrich of Talras and therefore enter into his services to earn your living."))
			// item 0
			set questItem0 = AQuestItem.create(this, tre("Erreicht die Burg Talras.", "Reach the castle Talras."))
			call questItem0.setPing(true)
			call questItem0.setPingCoordinatesFromRect(gg_rct_quest_talras_quest_item_0)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(thistype.rewardExperience, 100)
			// item 1
			set questItem1 = AQuestItem.create(this, tre("Trefft den Herzog und schwört ihm die Treue.", "Meet the duke and pledge loyalty to him."))
			call questItem1.setPing(true)
			call questItem1.setPingCoordinatesFromRect(gg_rct_quest_talras_quest_item_1)
			call questItem1.setPingColour(100.0, 100.0, 100.0)
			call questItem1.setReward(thistype.rewardExperience, 150)

			return this
		endmethod

		implement Quest
	endstruct

endlibrary