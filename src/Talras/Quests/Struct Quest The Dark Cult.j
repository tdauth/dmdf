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
			call questItem.quest().displayUpdateMessage(tr("„Dunklen Kult“ entdeckt!"))
		endmethod
		
		private static method stateEventCompleted2 takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_the_dark_cult)
		endmethod

		private static method stateConditionCompleted2 takes AQuestItem questItem returns boolean
			return GetUnitTypeId(GetTriggerUnit()) == UnitTypes.deacon and SpawnPoints.deathVault().countUnitsOfType(UnitTypes.deacon) == 0
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Der dunkle Kult"))
			local AQuestItem questItem0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNAcolyte.blp")
			call this.setDescription(tr("Osman, der Burgkleriker, erzählte von einem „dunklen Kult“, der sich vor langer Zeit von den Bewohnern Talras' abspaltete und schließlich vom damaligen Herzog aufgerieben wurde. Er möchte wissen, ob der Kult noch existiert oder alle Anhänger damals erschlagen wurden."))
			call this.setReward(AAbstractQuest.rewardExperience, 100)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Finde heraus, ob der „dunkle Kult“ noch existiert."))
			call questItem0.setStateEvent(AAbstractQuest.stateCompleted, thistype.stateEventCompleted0)
			call questItem0.setStateAction(AAbstractQuest.stateCompleted, thistype.stateActionCompleted0)
			call questItem0.setPing(true)
			call questItem0.setPingX(GetRectCenterX(gg_rct_quest_the_dark_cult))
			call questItem0.setPingY(GetRectCenterY(gg_rct_quest_the_dark_cult))
			call questItem0.setPingColour(100.0, 100.0, 100.0)

			// item 1
			set questItem0 = AQuestItem.create(this, tr("Berichte Osman davon."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.osman())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			
			// item 2
			set questItem0 = AQuestItem.create(this, tr("Vernichte den „dunklen Kult“."))
			call questItem0.setStateEvent(AAbstractQuest.stateCompleted, thistype.stateEventCompleted2)
			call questItem0.setStateCondition(AAbstractQuest.stateCompleted, thistype.stateConditionCompleted2)
			call questItem0.setPing(true)
			call questItem0.setPingX(GetRectCenterX(gg_rct_quest_the_dark_cult))
			call questItem0.setPingY(GetRectCenterY(gg_rct_quest_the_dark_cult))
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			
			// item 3
			set questItem0 = AQuestItem.create(this, tr("Berichte Osman davon."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.osman())
			call questItem0.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary