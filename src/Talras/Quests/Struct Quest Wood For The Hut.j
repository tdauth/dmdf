library StructMapQuestsQuestWoodForTheHut requires Asl

	struct QuestWoodForTheHut extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(0)
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			call questItem.quest().questItem(1).enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Holz für die Hütte", "Wood for the Hut"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp")
			call this.setDescription(tre("Der Fährmann Trommon braucht etwas Holz für die Reparatur seiner Hütte. Da er sich nicht traut, den Holzfäller Kuno selbst darum zu bitten, musst du dich darum kümmern.", "The ferryman Trommon needs some wood for repairing his hut. Since he does not dare to ask the woodcutter Kuno himself, you need to take care of it yourself."))
			call this.setReward(thistype.rewardExperience, 400)
			call this.setReward(thistype.rewardGold, 10)
			//item 0
			set questItem0 = AQuestItem.create(this, tre("Frage Kuno nach ein paar Brettern für die Hütte.", "Ask Kuno for a few planks for the hut."))
			call questItem0.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			call questItem0.setPing(true)
			call questItem0.setPingUnit(gg_unit_n022_0009)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			//item 1
			set questItem1 = AQuestItem.create(this, tre("Bringe die Bretter zu Trommon.", "Bring the planks to Trommon."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(gg_unit_n021_0004)
			call questItem1.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary