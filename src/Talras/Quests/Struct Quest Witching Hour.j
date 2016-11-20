library StructMapQuestsQuestWitchingHour requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestWitchingHour extends AQuest
		private region m_aosRegion

		public stub method enable takes nothing returns boolean
			return super.enableUntil(0)
		endmethod

		private static method stateEventCompleted2 takes AQuestItem questItem, trigger whichTrigger returns nothing
			local thistype this = thistype(questItem.quest())
			call TriggerRegisterEnterRegionSimple(whichTrigger, this.m_aosRegion)
			call TriggerRegisterEnterRectSimple(whichTrigger, gg_rct_quest_witching_hour_mill)
		endmethod

		private static method stateConditionCompleted2 takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			if (GetTriggerUnit() == questItem.character().unit()) then
				if (GetTriggeringRegion() == this.m_aosRegion) then
					return true
				endif
				call this.displayUpdateMessage("Bei der Mühle ist nichts Auffälliges zu finden, was auf Geister hinweist. Das Trommeln muss von einem anderen Ort kommen.")
			endif

			return false
		endmethod

		private static method stateActionCompleted2 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.questItem(3).enable()
			call this.displayUpdateMessage("Du hast eine Höhle entdeckt aus der das Trommeln kommt.")
		endmethod

		private static method stateActionCompleted takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			local Character character = Character(this.character())
			// 3 Brotlaibe
			call character.giveItem('I016')
			call character.giveItem('I016')
			call character.giveItem('I016')
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Geisterstunde", "Witching Hour"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNGhostOfKelThuzad.blp")
			call this.setDescription(tre("Der Müller Guntrich traut sich nicht mehr zu seiner Mühle auf dem Berg nahe des Bauernhofs, da es dort seiner Meinung nach spukt.", "The miller Guntrich dares not to his mill on the mountain near the farm, as the place is haunted to his oppinion."))
			// 800 Erfahrung, 30 Goldmünzen, 3 Brotlaibe, 1 Zauberpunkt
			call this.setReward(thistype.rewardExperience, 800)
			call this.setReward(thistype.rewardGold, 30)
			call this.setReward(thistype.rewardSkillPoints, 1)
			call this.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted)
			// item 0
			set questItem = AQuestItem.create(this, tre("Sprich mit dem Burgkleriker Osman über Guntrichs Problem und bitte ihn um Hilfe.", "Talk to the castle cleric Osman about Guntrich's problem and ask him for help."))
			call questItem.setReward(thistype.rewardExperience, 200)
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.osman())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem = AQuestItem.create(this, tre("Berichte Guntrich davon.", "Report to Guntrich thereof."))
			call questItem.setReward(thistype.rewardGold, 20)
			call questItem.setReward(thistype.rewardExperience, 200)
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.guntrich())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// item 2
			set this.m_aosRegion = CreateRegion()
			call RegionAddRect(this.m_aosRegion, gg_rct_area_aos)
			set questItem = AQuestItem.create(this, tre("Kümmere dich selbst um das Problem, indem du zur Mühle gehst und die Gegend dort erkundest.", "Take care of the problem by yourself by going to the mill and checking out the area there."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted2)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted2)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted2)
			call questItem.setReward(thistype.rewardExperience, 200)
			// item 3
			set questItem = AQuestItem.create(this, tre("Berichte Guntrich von deiner Entdeckung.", "Report to Guntrich about your discovery."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.guntrich())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary