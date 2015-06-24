library StructMapQuestsQuestDeranor requires Asl, StructGameCharacter, StructMapMapFellows, StructMapMapNpcs, StructMapVideosVideoDeranor, StructMapVideosVideoDeranorsDeath

	struct QuestDeranor extends AQuest
		public static constant integer questItemEnterTheTomb = 0
		public static constant integer questItemKillDeranor = 1

		implement Quest

		public stub method distributeRewards takes nothing returns nothing
			local integer i
			local item whichItem
			/// \todo JassHelper bug
			//call AQuest.distributeRewards()
			/*
			 * Zacken von Deranors Krone
			 * 3 Schattensteine
			 */
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (Character.playerCharacter(Player(i)) != 0) then
					call Character(Character.playerCharacter(Player(i))).giveItem('I04A')
					call Character(Character.playerCharacter(Player(i))).giveItem('I04B')
					call Character(Character.playerCharacter(Player(i))).giveItem('I04B')
					call Character(Character.playerCharacter(Player(i))).giveItem('I04B')
				endif
				set i = i + 1
			endloop

			call Character.displayItemAcquiredToAll(tr("STRING 4000"), tr("STRING 4001"))
			call Character.displayItemAcquiredToAll(tr("STRING 4003"), tr("STRING 4004"))
		endmethod
		
		public stub method enable takes nothing returns boolean
			call WaygateSetDestination(gg_unit_n02I_0264, GetRectCenterX(gg_rct_tomb_inside), GetRectCenterY(gg_rct_tomb_inside))
			call WaygateActivate(gg_unit_n02I_0264, true)
			call WaygateSetDestination(gg_unit_n02I_0295, GetRectCenterX(gg_rct_tomb_outside), GetRectCenterY(gg_rct_tomb_outside))
			call WaygateActivate(gg_unit_n02I_0295, true)
			
			return super.enableUntil(thistype.questItemEnterTheTomb)
		endmethod
		
		private static method stateEventCompleted0 takes AQuestItem questItem, trigger usedTrigger returns nothing
			call TriggerRegisterEnterRectSimple(usedTrigger, gg_rct_area_tomb)
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			return ACharacter.isUnitCharacter(GetTriggerUnit())
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call this.questItem(1).enable()
			// TODO Maybe enable the shrine for all characters?
			call VideoDeranor.video().play()
		endmethod
		
		private static method stateEventCompleted1 takes AQuestItem questItem, trigger usedTrigger returns nothing
			call TriggerRegisterUnitEvent(usedTrigger, gg_unit_u00A_0353, EVENT_UNIT_DEATH)
		endmethod

		private static method stateConditionCompleted1 takes AQuestItem questItem returns boolean
			return true
		endmethod

		private static method stateActionCompleted1 takes AQuestItem questItem returns nothing
			call Fellows.dragonSlayer().reset()
			call TalkDragonSlayer.initTalk()
			
			call VideoDeranorsDeath.video().play()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(0, tr("Deranor der Schreckliche"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNPowerLich.blp")
			call this.setDescription(tr("In der Todesgruft soll es einen Eingang zu einem Gewölbe unter der Erde geben. Dort soll sich der mächtige Nekromant Deranor der Schreckliche aufhalten. Die Drachentöterin bittet euch darum, ihn gemeinsam mit ihr zu vernichten, um Mittillant vor einer weiteren Bedrohung zu bewahren."))
			call this.setReward(AAbstractQuest.rewardExperience, 1000)

			set questItem = AQuestItem.create(this, tr("Betretet das unterirdische Gewölbe."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_tomb_outside)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			set questItem = AQuestItem.create(this, tr("Vernichtet Deranor den Schrecklichen."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted1)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted1)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted1)
			call questItem.setPing(true)
			call questItem.setPingUnit(gg_unit_u00A_0353)
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary