library StructMapQuestsQuestTheChildren requires Asl, Game, StructMapMapNpcs

	struct QuestTheChildren extends AQuest
		public static constant integer questItemDiscover = 0
		public static constant integer questItemTalkToWotan = 1
		public static constant integer questItemSacrifice = 2
		public static constant integer questItemRescue = 3

		public stub method enable takes nothing returns boolean
			local Character character = Character(this.character())
			//call character.options().missions().addMission('A1R8', 'A1RK', this)
			return super.enableUntil(thistype.questItemTalkToWotan)
		endmethod

		private static method stateEventNew takes thistype this, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_the_children_discover)
		endmethod

		private static method stateConditionNew takes thistype this returns boolean
			local Character character = Character(this.character())
			return GetTriggerUnit() == this.character().unit()
		endmethod

		private static method stateActionNew takes thistype this returns nothing
			call this.questItem(thistype.questItemDiscover).setState(thistype.stateNew)
			call this.questItem(thistype.questItemTalkToWotan).setState(thistype.stateNew)
			call this.displayState()
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Die Kinder", "The Children"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNVillagerKid.blp")
			call this.setDescription(tr("Der Dorfälteste treibt unchristliche Dinge im Obergeschoss seines Hauses."))
			call this.setReward(thistype.rewardExperience, 40)
			call this.setStateEvent(thistype.stateNew, thistype.stateEventNew)
			call this.setStateCondition(thistype.stateNew, thistype.stateConditionNew)
			call this.setStateAction(thistype.stateNew, thistype.stateActionNew)

			// item questItemDiscover
			set questItem = AQuestItem.create(this, tr("Finde heraus, was es mit dem Dorfältesten auf sich hat."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_children_discover)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			// item questItemTalkToWotan
			set questItem = AQuestItem.create(this, tr("Sprich mit Wotan über seine Experimente."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.wotan())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			// item questItemSacrifice
			set questItem = AQuestItem.create(this, tr("Entweder: Opfere die Kinder für Wotans dämonische Macht."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_children_children)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			// item questItemRescue
			set questItem = AQuestItem.create(this, tr("Oder: Rette die Kinder vor Wotans dämonischem Wahnsinn."))
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_children_children)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 10)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary