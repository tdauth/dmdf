library StructMapQuestsQuestWolvesHunt requires Asl, StructMapMapNpcs

	struct QuestWolvesHunt extends AQuest
		public static constant integer maxRects = 2

		implement CharacterQuest
		
		private rect array m_rect[2]
		private boolean array m_flag[2]

		public stub method enable takes nothing returns boolean
			return super.enableUntil(1)
		endmethod

		private static method stateEventCompleted0 takes AQuestItem questItem, trigger whichTrigger returns nothing
			// the units owner might be different due to abilities
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_DEATH)
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local integer count
			local integer i
			if (GetUnitTypeId(GetTriggerUnit()) == 'n02G') then
				set i = 0
				loop
					exitwhen (i == thistype.maxRects)
					if (RectContainsUnit(this.m_rect[i], GetTriggerUnit())) then
						set this.m_flag[i] = true
					endif
					set i = i + 1
				endloop
				set count = 0
				set i = 0
				loop
					exitwhen (i == thistype.maxRects)
					if (this.m_flag[i]) then
						set this.m_flag[i] = true
						set count = count + 1
					endif
					set i= i + 1
				endloop
				if (count == thistype.maxRects) then
					return true
				// get next one to ping
				else
					call questItem.quest().displayUpdateMessage(Format(tr("%1%/%2% Rudelführer")).i(thistype.maxRects - count).i(thistype.maxRects).result())
				endif
			endif
			return false
		endmethod
		
		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			call questItem.quest().displayUpdate()
		endmethod
		
		private static method stateActionCompleted takes AQuest whichQuest returns nothing
			// 3 mal Wolle
			call UnitAddItemById(whichQuest.character().unit(), 'I04X')
			call UnitAddItemById(whichQuest.character().unit(), 'I04X')
			call UnitAddItemById(whichQuest.character().unit(), 'I04X')
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tr("Wolfsjagd"))
			local integer i
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNDireWolf.blp")
			call this.setDescription(tr("Der Schafsjunge auf dem Mühlberg westlich vom Bauernhof will, dass alle Rudelführer in Talras getötet werden, damit die Wölfe seine Schafe in Ruhe lassen.
Eigentlich würde er sich ja selbst darum kümmern …"))
			// 800 Erfahrung, 30 Goldmünzen, 3 Brotlaibe, 1 Zauberpunkt
			call this.setReward(thistype.rewardExperience, 500)
			call this.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted)
			// item 0
			set questItem = AQuestItem.create(this, tr("Töte alle Rudelführer in Talras."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			
			// item 1
			set questItem = AQuestItem.create(this, tr("Berichte dem Schafsjungen davon."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.sheepBoy())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			set i = 0
			loop
				exitwhen (i == thistype.maxRects)
				set this.m_flag[i] = false
				set i = i + 1
			endloop
			set this.m_rect[0] = gg_rct_quest_wolves_hunt_0
			set this.m_rect[1] = gg_rct_quest_wolves_hunt_1

			return this
		endmethod
	endstruct

endlibrary