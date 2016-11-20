library StructMapQuestsQuestWolvesHunt requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestWolvesHunt extends AQuest
		public static constant integer maxRects = 2
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
			local integer count = 0
			local integer i = 0
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
						set count = count + 1
					endif
					set i = i + 1
				endloop
				if (count == thistype.maxRects) then
					return true
				// get next one to ping
				else
					call questItem.quest().displayUpdateMessage(Format(tre("%1%/%2% Rudelführer", "%1%/%2% Pack Leader")).i(count).i(thistype.maxRects).result())
				endif
			endif
			return false
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			call questItem.quest().displayUpdate()
		endmethod

		private static method stateActionCompleted takes AQuest whichQuest returns nothing
			local Character character = Character(whichQuest.character())
			// 3 mal Wolle
			call character.giveItem('I04X')
			call character.giveItem('I04X')
			call character.giveItem('I04X')
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Wolfsjagd", "Wolf Hunting"))
			local integer i = 0
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNDireWolf.blp")
			call this.setDescription(tre("Der Schafsjunge auf dem Mühlberg westlich vom Bauernhof will, dass alle Rudelführer in Talras getötet werden, damit die Wölfe seine Schafe in Ruhe lassen.
Eigentlich würde er sich ja selbst darum kümmern …", "The sheep boy on the Mill Hill west of the farm wants all pack leaders in Talras to be killed, so the wolves leave his sheeps in peace. Actually, he would take care of it himself ..."))
			// 800 Erfahrung, 30 Goldmünzen, 3 Brotlaibe, 1 Zauberpunkt
			call this.setReward(thistype.rewardExperience, 500)
			call this.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted)
			// item 0
			set questItem = AQuestItem.create(this, tre("Töte alle Rudelführer in Talras.", "Kill all pack leaders in Talras."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)

			// item 1
			set questItem = AQuestItem.create(this, tre("Berichte dem Schafsjungen davon.", "Report to the sheep boy thereof."))
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

		implement CharacterQuest
	endstruct

endlibrary