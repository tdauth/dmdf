library StructMapQuestsQuestTheDarkCult requires Asl, StructGameCharacter, StructMapMapNpcs, StructMapMapSpawnPoints

	struct QuestTheDarkCult extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(1)
		endmethod
		
		private static method stateEventCompleted0 takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_the_dark_cult)
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			call questItem.quest().displayUpdateMessage(tre("„Dunklen Kult“ entdeckt!", "Discovered the \"Dark Cult\"!"))
		endmethod
		
		private static method stateEventCompleted2 takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DEATH)
		endmethod

		private static method stateConditionCompleted2 takes AQuestItem questItem returns boolean
			/*
			 * Whenever a unit dies and the deacon is already dead finish this quest.
			 */
			return SpawnPoints.deathVault().countUnitsOfType(UnitTypes.deacon) == 0
		endmethod
		
		private static method stateActionCompleted2 takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			call this.displayState()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Der dunkle Kult", "The Dark Cult"))
			local AQuestItem questItem0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNAcolyte.blp")
			call this.setDescription(tre("Osman, der Burgkleriker, erzählte von einem „dunklen Kult“, der sich vor langer Zeit von den Bewohnern Talras' abspaltete und schließlich vom damaligen Herzog aufgerieben wurde. Er möchte wissen, ob der Kult noch existiert oder alle Anhänger damals erschlagen wurden.", "Osman, the castle cleric, told of a \"Dark Cult\" that split off along ago from the inhabitants of Talras and was eventually destroyed by the then duke. He asks whether the cult still exists or all followers were killed at that time."))
			call this.setReward(thistype.rewardExperience, 100)
			// item 0
			set questItem0 = AQuestItem.create(this, tre("Finde heraus, ob der „dunkle Kult“ noch existiert.", "Find out if the \"Dark Cult\" still exists."))
			call questItem0.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem0.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			call questItem0.setPing(true)
			call questItem0.setPingX(GetRectCenterX(gg_rct_quest_the_dark_cult))
			call questItem0.setPingY(GetRectCenterY(gg_rct_quest_the_dark_cult))
			call questItem0.setPingColour(100.0, 100.0, 100.0)

			// item 1
			set questItem0 = AQuestItem.create(this, tre("Berichte Osman davon.", "Report to Osman thereof."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.osman())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			
			// item 2
			set questItem0 = AQuestItem.create(this, tre("Vernichte den „dunklen Kult“.", "Destroy the \"Dark Cult\"."))
			call questItem0.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted2)
			call questItem0.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted2)
			call questItem0.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted2)
			call questItem0.setPing(true)
			call questItem0.setPingX(GetRectCenterX(gg_rct_quest_the_dark_cult))
			call questItem0.setPingY(GetRectCenterY(gg_rct_quest_the_dark_cult))
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			
			// item 3
			set questItem0 = AQuestItem.create(this, tre("Berichte Osman davon.", "Report to Osman thereof."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.osman())
			call questItem0.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary