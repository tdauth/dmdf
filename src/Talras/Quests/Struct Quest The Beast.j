library StructMapQuestsQuestTheBeast requires Asl

	struct QuestTheBeast extends AQuest
		private boolean m_foundTracks
		private boolean m_talkedToKuno

		implement CharacterQuest

		public method talkedToKuno takes nothing returns boolean
			return this.m_talkedToKuno
		endmethod

		public method findTracks takes nothing returns nothing
			set this.m_foundTracks = true
			call this.displayUpdateMessage(tr("Hinweis erhalten."))
			if (this.talkedToKuno()) then
				call this.questItem(0).complete()
			endif
		endmethod

		public method foundTracks takes nothing returns boolean
			return this.m_foundTracks
		endmethod

		public method talkToKuno takes nothing returns nothing
			set this.m_talkedToKuno = true
			call this.displayUpdateMessage(tr("Hinweis erhalten."))
			if (this.foundTracks()) then
				call this.questItem(0).complete()
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
				call thistype(questItem.quest()).findTracks()
			endif
			return false
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Die Bestie"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			set this.m_foundTracks = false
			set this.m_talkedToKuno = false
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNBestienhaeuptling.blp")
			call this.setDescription(tr("Die Schamanin Tanka und ihr Gefährte, der Bärenmensch Brogo, benötigen bei ihrer Suche nach einer Bestie Hilfe. Das Ungeheuer soll im Alleingang alle Bärenmenschen Brogos Stammes bis auf ihn selbst ausgerottet haben."))
			call this.setReward(AAbstractQuest.rewardExperience, 300)
			call this.setReward(AAbstractQuest.rewardGold, 30)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Such nach Hinweisen bezüglich des Ungeheuers."))
			call questItem0.setStateEvent(AAbstractQuest.stateCompleted, thistype.stateEventCompleted0)
			call questItem0.setStateCondition(AAbstractQuest.stateCompleted, thistype.stateConditionCompleted0)
			/// @todo Add event, condition and action (display message ...)
			// item 1
			set questItem1 = AQuestItem.create(this, tr("Berichte Tanka von den gefundenen Hinweisen."))

			return this
		endmethod
	endstruct

endlibrary
