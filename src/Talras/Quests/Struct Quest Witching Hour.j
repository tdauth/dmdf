library StructMapQuestsQuestWitchingHour requires Asl, StructMapMapNpcs

	struct QuestWitchingHour extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(0)
		endmethod

		private static method stateEventCompleted2 takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_area_aos)
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_witching_hour_mill)
		endmethod

		private static method stateConditionCompleted2 takes AQuestItem questItem returns boolean
			if (GetTriggerUnit() == questItem.character().unit()) then
				if (RectContainsUnit(gg_rct_area_aos, GetTriggerUnit())) then
					call questItem.quest().displayUpdateMessage("Du hast eine Höhle entdeckt aus der das Trommeln kommt.")
					return true
				endif
				call questItem.quest().displayUpdateMessage("Bei der Mühle ist nichts Auffälliges zu finden, was auf Geister hinweist. Das Trommeln muss von einem anderen Ort kommen.")
			endif
		
			return false
		endmethod

		private static method stateActionCompleted takes AQuestItem questItem returns nothing
			// 3 Brotlaibe
			call UnitAddItemById(questItem.character().unit(), 'I016')
			call UnitAddItemById(questItem.character().unit(), 'I016')
			call UnitAddItemById(questItem.character().unit(), 'I016')
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tr("Geisterstunde"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNGhostOfKelThuzad.blp")
			call this.setDescription(tr("Der Müller Guntrich traut sich nicht mehr zu seiner Mühle auf dem Berg nahe des Bauernhofs, da es dort seiner Meinung nach spukt."))
			// 800 Erfahrung, 30 Goldmünzen, 3 Brotlaibe, 1 Zauberpunkt
			call this.setReward(thistype.rewardExperience, 800)
			call this.setReward(thistype.rewardGold, 30)
			call this.setReward(thistype.rewardSkillPoints, 1)
			call this.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted)
			// item 0
			set questItem = AQuestItem.create(this, tr("Sprich mit dem Burgkleriker Osman über Guntrichs Problem und bitte ihn um Hilfe."))
			call questItem.setReward(thistype.rewardExperience, 200)
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.osman())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem = AQuestItem.create(this, tr("Berichte Guntrich davon."))
			call questItem.setReward(thistype.rewardGold, 20)
			call questItem.setReward(thistype.rewardExperience, 200)
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.guntrich())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// item 2
			set questItem = AQuestItem.create(this, tr("Kümmere dich selbst um das Problem, indem du zur Mühle gehst und die Gegend dort erkundest."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted2)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted2)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateConditionCompleted2)
			call questItem.setReward(thistype.rewardExperience, 200)
			// item 3
			set questItem = AQuestItem.create(this, tr("Berichte Guntrich von deiner Entdeckung."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.guntrich())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary