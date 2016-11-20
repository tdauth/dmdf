library StructMapQuestsQuestWoodForTheHut requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestWoodForTheHut extends AQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(0)
		endmethod

		public stub method distributeRewards takes nothing returns nothing
			local Character character = Character(this.character())
			// 4 Salatköpfe
			call character.giveItem('I06U')
			call character.giveItem('I06U')
			call character.giveItem('I06U')
			call character.giveItem('I06U')

			// call this method, otherwise the characters do not get their rewards
			call super.distributeRewards()
		endmethod

		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			call questItem.quest().questItem(1).setState(thistype.stateNew)
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Holz für die Hütte", "Wood for the Hut"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNBundleOfLumber.blp")
			call this.setDescription(tre("Der Fährmann Trommon braucht etwas Holz für die Reparatur seiner Hütte. Da er sich nicht traut, den Holzfäller Kuno selbst darum zu bitten, musst du dich darum kümmern.", "The ferryman Trommon needs some wood for repairing his hut. Since he does not dare to ask the woodcutter Kuno himself, you need to take care of it yourself."))
			call this.setReward(thistype.rewardExperience, 400)
			call this.setReward(thistype.rewardGold, 10)
			// item 0
			set questItem = AQuestItem.create(this, tre("Frage Kuno nach ein paar Brettern für die Hütte.", "Ask Kuno for a few planks for the hut."))
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.kuno())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem = AQuestItem.create(this, tre("Bringe die Bretter zu Trommon.", "Bring the planks to Trommon."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.trommon())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary