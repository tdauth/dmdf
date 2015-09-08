library StructMapQuestsQuestTalras requires Asl, StructMapQuestsQuestTheNorsemen, StructMapVideosVideoTheDukeOfTalras

	struct QuestAreaTalrasCastle extends QuestArea
	
		public stub method onStart takes nothing returns nothing
			call VideoTheCastle.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			call QuestTalras.quest.evaluate().enableDuke.evaluate()
		endmethod
	
		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct
	
	struct QuestAreaTalrasDuke extends QuestArea
	
		public stub method onStart takes nothing returns nothing
			call VideoTheDukeOfTalras.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			call QuestTalras.quest.evaluate().complete()
			call QuestTheNorsemen.quest().enable()
		endmethod
	
		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct

	struct QuestTalras extends AQuest
		public static constant integer questItemReachTheCastle = 0
		public static constant integer questItemMeetHeimrich = 1
		private QuestAreaTalrasCastle m_questAreaCastle
		private QuestAreaTalrasDuke m_questAreaDuke

		implement Quest

		public stub method enable takes nothing returns boolean
			set this.m_questAreaCastle = QuestAreaTalrasCastle.create(gg_rct_quest_talras_quest_item_0)
			return this.enableUntil(thistype.questItemReachTheCastle)
		endmethod

		public method enableDuke takes nothing returns nothing
			set this.m_questAreaDuke = QuestAreaTalrasDuke.create(gg_rct_quest_talras_quest_item_1)
			call thistype.quest().questItem(thistype.questItemMeetHeimrich).enable()
			// open the gate
			call SetDoodadAnimationRect(gg_rct_doodad_gate_talras, 'D053', "Death", false)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(0, tr("Talras"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNCastle.blp")
			call this.setDescription(tr("Ihr wollt dem Herzog Heimrich von Talras die Treue schwören und damit in seinen Dienst treten, um euren Lebensunterhalt zu verdienen."))
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Erreicht die Burg Talras."))
			call questItem0.setPing(true)
			call questItem0.setPingCoordinatesFromRect(gg_rct_quest_talras_quest_item_0)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(thistype.rewardExperience, 100)
			// item 1
			set questItem1 = AQuestItem.create(this, tr("Trefft den Herzog und schwört ihm die Treue."))
			call questItem1.setReward(thistype.rewardExperience, 400)
			
			return this
		endmethod
	endstruct

endlibrary