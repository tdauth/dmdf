library StructMapQuestsQuestTheBeast requires Asl

	struct QuestTheBeast extends AQuest
		private boolean m_foundTracks
		private boolean m_talkedToKuno

		implement CharacterQuest

		public method talkedToKuno takes nothing returns boolean
			return this.m_talkedToKuno
		endmethod

		public method findTracks takes nothing returns boolean
			set this.m_foundTracks = true
			call this.displayUpdateMessage(tre("Hinweis erhalten: Auf dem Boden befinden sich Blutspuren. Das könnte Tanka interessieren!", "Received clue: On the ground there are traces of blood. That might interest Tanka!"))
			if (this.talkedToKuno()) then
				return true
			else
				call this.displayUpdateMessage(tre("Finde noch mehr Hinweise!", "Find even more clues!"))
			endif
			
			return false
		endmethod

		public method foundTracks takes nothing returns boolean
			return this.m_foundTracks
		endmethod

		public method talkToKuno takes nothing returns nothing
			set this.m_talkedToKuno = true
			call this.displayUpdateMessage(tre("Hinweis erhalten.", "Received clue."))
			if (this.foundTracks()) then
				call this.questItem(0).complete()
			else
				call this.displayUpdateMessage(tre("Finde noch mehr Hinweise!", "Find even more clues!"))
			endif
		endmethod

		public stub method enable takes nothing returns boolean
			return super.enableUntil(1)
		endmethod

		private static method stateEventCompleted0 takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_the_beast_hint)
		endmethod

		// return always false since it will be completed by method findTracks
		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			if (GetTriggerUnit() == questItem.character().unit() and not thistype(questItem.quest()).foundTracks()) then
				return thistype(questItem.quest()).findTracks()
			endif
			return false
		endmethod
		
		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			call thistype(questItem.quest()).displayState()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Die Bestie", "The Beast"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			set this.m_foundTracks = false
			set this.m_talkedToKuno = false
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNBestienhaeuptling.blp")
			call this.setDescription(tre("Die Schamanin Tanka und ihr Gefährte, der Bärenmensch Brogo, benötigen bei ihrer Suche nach einer Bestie Hilfe. Das Ungeheuer soll im Alleingang alle Bärenmenschen Brogos Stammes bis auf ihn selbst ausgerottet haben.", "The shaman Tanka and her companion, the man bear Brogo need help with their search for a beast. The monster is said to have wiped out single-handedly all bear men of Brogo's tribe up on himself."))
			call this.setReward(thistype.rewardExperience, 300)
			call this.setReward(thistype.rewardGold, 30)
			// item 0
			set questItem0 = AQuestItem.create(this, tre("Suche nach Hinweisen bezüglich des Ungeheuers.", "Search for clues regarding the monster."))
			call questItem0.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem0.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem0.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)

			// item 1
			set questItem1 = AQuestItem.create(this, tre("Berichte Tanka von den gefundenen Hinweisen.", "Report Tanka about the found clues."))

			return this
		endmethod
	endstruct

endlibrary
