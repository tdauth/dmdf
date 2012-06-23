library StructMapQuestsQuestDeathToBlackLegion requires Asl

	struct QuestDeathToBlackLegion extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		public stub method disable takes nothing returns boolean
			return super.disable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Tod der schwarzen Legion"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("") /// @todo fixme
			call this.setDescription(tr("Haldar, der Erzengel, möchte von dir, dass du die schwarze Legion, deren Anführer der Erzdämon Baldar, Haldars Bruder, ist, vernichtest."))
			call this.setReward(AAbstractQuest.rewardExperience, 2000)
			call this.setReward(AAbstractQuest.rewardSkillPoints, 1)
			call this.setReward(AAbstractQuest.rewardGold, 1000)
			//quest item 0
			set questItem0 = AQuestItem.create(this, tr("Zerstöre das Heerlager der schwarzen Legion."))
			/// @todo Ping building
			//call questItem0.setPing(true)
			//call questItem0.setPingRect(gg_rct_haldar_spawn_point_0)
			//call questItem0.setPingColour(100.0, 100.0, 100.0)
			//quest item 1
			set questItem1 = AQuestItem.create(this, tr("Töte so viele Krieger der schwarzen Legion wie möglich."))
			// for 10 kills
			call questItem1.setReward(AAbstractQuest.rewardExperience, 300)
			call questItem1.setReward(AAbstractQuest.rewardGold, 200)
			call questItem1.setDistributeRewardsOnCompletion(false)
			return this
		endmethod
	endstruct

endlibrary
