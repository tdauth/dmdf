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
			local thistype this = thistype.allocate(character, tre("Tod der schwarzen Legion", "Death to the Black Legion"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNArthas.blp")
			call this.setDescription(tre("Haldar, der Erzengel, möchte von dir, dass du die schwarze Legion, deren Anführer der Erzdämon Baldar, Haldars Bruder, ist, vernichtest.", "Haldar the archangel wants from you that you destroy the Black Legion whose leader is the archdemon Baldar, Haldar's brother."))
			call this.setReward(thistype.rewardExperience, 2000)
			call this.setReward(thistype.rewardSkillPoints, 1)
			call this.setReward(thistype.rewardGold, 1000)
			//quest item 0
			set questItem0 = AQuestItem.create(this, tre("Zerstöre das Heerlager der schwarzen Legion.", "Destroy the camp of the Black Legion."))
			/// @todo Ping building
			//call questItem0.setPing(true)
			//call questItem0.setPingRect(gg_rct_haldar_spawn_point_0)
			//call questItem0.setPingColour(100.0, 100.0, 100.0)
			//quest item 1
			set questItem1 = AQuestItem.create(this, tre("Töte so viele Krieger der schwarzen Legion wie möglich (10 pro Belohnung).", "Kill as many warriors of the Black Legion as possible (10 per reward)."))
			// for 10 kills
			call questItem1.setReward(thistype.rewardExperience, 300)
			call questItem1.setReward(thistype.rewardGold, 200)
			call questItem1.setDistributeRewardsOnCompletion(false)
			return this
		endmethod
	endstruct

endlibrary
