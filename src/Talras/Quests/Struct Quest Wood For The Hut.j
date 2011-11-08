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
			local thistype this = thistype.allocate(character, tr("Holz für die Hütte"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("") /// @todo fixme
			call this.setDescription(tr("Der Fährmann Trommon braucht etwas Holz für die Reparatur seiner Hütte. Da er sich nicht traut, den Holzfäller Kuno selbst darum zu bitten, musst du dich darum kümmern."))
			call this.setReward(AAbstractQuest.rewardExperience, 400)
			call this.setReward(AAbstractQuest.rewardGold, 10)
			//item 0
			set questItem0 = AQuestItem.create(this, tr("Frag Kuno nach ein paar Brettern für die Hütte."))
			call questItem0.setStateAction(AAbstractQuest.stateCompleted, thistype.stateActionCompleted0)
			call questItem0.setPing(true)
			call questItem0.setPingUnit(gg_unit_n022_0009)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			//item 1
			set questItem1 = AQuestItem.create(this, tr("Berichte Trommon davon."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(gg_unit_n021_0004)
			call questItem1.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary