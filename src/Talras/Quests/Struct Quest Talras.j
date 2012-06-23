library StructMapQuestsQuestTalras requires Asl, StructMapQuestsQuestTheNorsemen, StructMapVideosVideoTheDukeOfTalras

	struct QuestTalras extends AQuest

		implement Quest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method stateEventCompleted0 takes AQuestItem questItem, trigger usedTrigger returns nothing
			local event triggerEvent = TriggerRegisterEnterRectSimple(usedTrigger, gg_rct_quest_talras_quest_item_0)
			set triggerEvent = null
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			local unit triggerUnit = GetTriggerUnit()
			local boolean result = ACharacter.isUnitCharacter(triggerUnit)
			set triggerUnit = null
			return result
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			call VideoTheCastle.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			call questItem.quest().questItem(1).enable()
			// open the gate
			call SetDoodadAnimationRect(gg_rct_doodad_gate_talras, 'D053', "Death", false)
			// remove gate blockers
			call RemoveDestructable(gg_dest_B004_2334)
			call RemoveDestructable(gg_dest_B004_2335)
			call RemoveDestructable(gg_dest_B004_2336)
			call RemoveDestructable(gg_dest_B004_2337)
		endmethod

		private static method stateEventCompleted1 takes AQuestItem questItem, trigger usedTrigger returns nothing
			local event triggerEvent = TriggerRegisterEnterRectSimple(usedTrigger, gg_rct_quest_talras_quest_item_1)
			set triggerEvent = null
		endmethod

		private static method stateConditionCompleted1 takes AQuestItem questItem returns boolean
			local unit triggerUnit = GetTriggerUnit()
			local boolean result = ACharacter.isUnitCharacter(triggerUnit)
			set triggerUnit = null
			return result
		endmethod

		private static method stateActionCompleted1 takes AQuestItem questItem returns nothing
			call VideoTheDukeOfTalras.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			call questItem.quest().displayState()
			call QuestTheNorsemen.quest().enable()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(0, tr("Talras"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNCastle.blp")
			call this.setDescription(tr("Ihr wollt dem Herzog Heimrich von Talras die Treue schwören und damit in seinen Dienst treten, um euren Lebensunterhalt zu verdienen."))
			// item 0
			call BJDebugMsg("Before first quest item")
			set questItem0 = AQuestItem.create(this, tr("Erreicht die Burg Talras."))
			call questItem0.setPing(true)
			call questItem0.setPingCoordinatesFromRect(gg_rct_quest_talras_quest_item_0)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setStateEvent(AAbstractQuest.stateCompleted, thistype.stateEventCompleted0)
			call questItem0.setStateCondition(AAbstractQuest.stateCompleted, thistype.stateConditionCompleted0)
			call questItem0.setStateAction(AAbstractQuest.stateCompleted, thistype.stateActionCompleted0)
			call questItem0.setReward(AAbstractQuest.rewardExperience, 800)
			call BJDebugMsg("Before second quest item")
			// item 1
			set questItem1 = AQuestItem.create(this, tr("Trefft den Herzog und schwört ihm die Treue."))
			call questItem1.setStateEvent(AAbstractQuest.stateCompleted, thistype.stateEventCompleted1)
			call questItem1.setStateCondition(AAbstractQuest.stateCompleted, thistype.stateConditionCompleted1)
			call questItem1.setStateAction(AAbstractQuest.stateCompleted, thistype.stateActionCompleted1)
			call questItem1.setReward(AAbstractQuest.rewardExperience, 1000)
			call BJDebugMsg("After second quest item")
			return this
		endmethod
	endstruct

endlibrary