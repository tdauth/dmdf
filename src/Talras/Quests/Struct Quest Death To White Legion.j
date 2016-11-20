library StructMapQuestsQuestDeathToWhiteLegion requires Asl, StructGameCharacter

	struct QuestDeathToWhiteLegion extends AQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		public stub method disable takes nothing returns boolean
			return super.disable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Tod der weißen Legion", "Death to the White Legion"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNBurningOne.blp")
			call this.setDescription(tre("Baldar, der Erzdämon, möchte von dir, dass du die weiße Legion, deren Anführer der Erzengel Haldar, Baldars Bruder, ist, vernichtest.", "Baldar the archdemon wants from you that you destroy the White Legion whose leader is the archangel Haldar, Baldar's brother."))
			call this.setReward(thistype.rewardExperience, 2000)
			call this.setReward(thistype.rewardSkillPoints, 1)
			call this.setReward(thistype.rewardGold, 1000)
			// quest item 0
			set questItem = AQuestItem.create(this, tre("Zerstöre das Heerlager der weißen Legion.", "Destroy the camp of the White Legion."))
			// quest item 1
			set questItem = AQuestItem.create(this, tre("Töte so viele Krieger der weißen Legion wie möglich (10 pro Belohnung).", "Kill as many warriors of the White Legion as possible (10 per reward)."))
			// for 10 kills
			call questItem.setReward(thistype.rewardExperience, 300)
			call questItem.setReward(thistype.rewardGold, 200)
			call questItem.setDistributeRewardsOnCompletion(false)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary
