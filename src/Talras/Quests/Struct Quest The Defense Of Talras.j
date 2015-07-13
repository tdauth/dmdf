library StructMapQuestsQuestTheDefenseOfTalras requires Asl, StructMapQuestsQuestTheWayToHolzbruck, StructMapVideosVideoHolzbruck

	struct QuestAreaQuestTheDefenseOfTalras extends QuestArea
	
		public stub method onCheck takes nothing returns boolean
			return QuestTheDefenseOfTalras.quest.evaluate().isNew()
		endmethod
	
		public stub method onStart takes nothing returns nothing
			//call VideoUpstream.video().play()
			// TEST
			call QuestTheDefenseOfTalras.quest.evaluate().enableTimer.evaluate()
		endmethod
	
		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct

	/*
	 * TODO
	 * A battle with Wigberht, Ricman, Dragon Slayer and some characters helping out, Tobias and Haldar and Baldar.
	 */
	struct QuestTheDefenseOfTalras extends AQuest
		private QuestAreaQuestTheDefenseOfTalras m_questArea
		// TEST Finish the quest after 20 seconds, temporary solution.
		private timer m_timer
		
		implement Quest
		
		private static method timerFunctionFinish takes nothing returns nothing
			local thistype this = thistype.quest()
			call this.complete()
		endmethod
		
		public method enableTimer takes nothing returns nothing
			if (this.m_timer == null) then
				set this.m_timer = CreateTimer()
			endif
			call TimerStart(this.m_timer, 20.0, false, function thistype.timerFunctionFinish)
		endmethod

		public stub method enable takes nothing returns boolean
			set this.m_questArea = QuestAreaQuestTheDefenseOfTalras.create(gg_rct_quest_the_defense_of_talras)
			return super.enable()
		endmethod
		
		private static method stateActionCompleted takes thistype this returns nothing
			debug call Print("Before finish")
			call VideoHolzbruck.video().play()
			debug call Print("After finish")
			call waitForVideo(MapData.videoWaitInterval)
			debug call Print("After wait")
			call QuestTheWayToHolzbruck.quest().enable()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(0, tr("Die Verteidigung von Talras"))
			local AQuestItem questItem0
			set this.m_timer = null
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNGuardTower.blp")
			call this.setDescription(tr("Ein Teil der Armee der Orks und Dunkelelfen ist in Talras eingetroffen. Verteidigt Talras um jeden Preis gegen die Horden der Orks und Dunkelelfen."))
			call this.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Verteidigt den Außenposten"))
			call questItem0.setPing(true)
			call questItem0.setPingRect(gg_rct_quest_the_defense_of_talras)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(thistype.rewardExperience, 1000)
			return this
		endmethod
	endstruct

endlibrary
