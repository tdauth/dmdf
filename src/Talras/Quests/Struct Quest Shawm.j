library StructMapQuestsQuestShawm requires Asl, Game, StructMapMapNpcs

	struct QuestShawm extends AQuest
		public static constant integer questItemLumber = 0
		public static constant integer questItemGold = 1
		public static constant integer questItemGiveGoldAndLumber = 2
		public static constant integer questItemGetTheInstrument = 3
		public static constant integer itemTypeId = 'I082'
		private timer m_constructionTimer
		private boolean m_finishedConstruction

		public stub method enable takes nothing returns boolean
			local Character character = Character(this.character())
			//call character.options().missions().addMission('A1R8', 'A1RK', this)
			return super.enableUntil(thistype.questItemGiveGoldAndLumber)
		endmethod

		public stub method distributeRewards takes nothing returns nothing
			local Character character = Character(this.character())
			call character.giveQuestItem(thistype.itemTypeId)
		endmethod

		private static method timerFunctionConstructionDone takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), 0))
			set this.m_finishedConstruction = true
			call Character(this.character()).displayHint(tre("Mathilda ist mit dem Bau der Schalmei fertig.", "Mathilda has finished the construction of the shawm."))
			call PauseTimer(GetExpiredTimer())
		endmethod

		public method startConstructionTimer takes nothing returns nothing
			if (this.m_constructionTimer == null) then
				set this.m_constructionTimer = CreateTimer()
				call DmdfHashTable.global().setHandleInteger(this.m_constructionTimer, 0, this)
				call TimerStart(this.m_constructionTimer, 60.0, false, function thistype.timerFunctionConstructionDone)
			endif
		endmethod

		public method finishedConstruction takes nothing returns boolean
			return this.m_finishedConstruction
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Die Schalmei", "The Shawm"))
			local AQuestItem questItem = 0
			set this.m_constructionTimer = null
			set this.m_finishedConstruction = false
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNAlleriaFlute.blp")
			call this.setDescription(tre("Mathilda vom Bauernhof baut dir eine Schalmei, wenn du ihr die benötigten Gegenstände dafür besorgst. Mit einer eigenen Schalmei kannst du wunderbare Lieder spielen.", "Mathilda of the farm will build you a shawm if you get her the needed items for it. With your own shawm you can play wonderful songs."))
			call this.setReward(thistype.rewardExperience, 250)
			// item 0
			set questItem = AQuestItem.create(this, tre("Besorge fünf Holzbretter.", "Get five wooden boards."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_shawm_lumber)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem = AQuestItem.create(this, tre("Besorge 100 Goldmünzen.", "Get 100 gold coins."))

			set questItem = AQuestItem.create(this, tre("Überreiche Mathilda die Goldmünzen und Holzbretter.", "Hand over the gold coins and wooden boards to Mathilda."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.mathilda())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			set questItem = AQuestItem.create(this, tre("Warte bis Mathilda die Schalmei hergestellt hat und hole sie ab.", "Wait until Mathilda has constructed the shawmn and pick it up."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.mathilda())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary