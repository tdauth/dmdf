library StructMapQuestsQuestWitchingHour requires Asl, StructMapMapNpcs

	struct QuestWitchingHour extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(0)
		endmethod

		private static method stateEventCompleted1 takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_area_aos)
		endmethod

		private static method stateConditionCompleted1 takes AQuestItem questItem returns boolean
			return GetTriggerUnit() == questItem.character().unit()
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
			//800 Erfahrung, 30 Goldmünzen, 3 Brotlaibe, 1 Zauberpunkt
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