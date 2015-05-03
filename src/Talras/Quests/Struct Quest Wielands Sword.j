library StructMapQuestsQuestWielandsSword requires Asl, StructGameCharacter

	struct QuestWielandsSword extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod
		
		private static method stateActionCompleted takes AQuest whichQuest returns nothing
			// Edles Langschwert
			call Character(whichQuest.character()).giveItem('I04Y')
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Wielands Schwert"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNLongsword.blp")
			call this.setDescription(tr("Der Schmied Wieland aus Talras möchte, dass du für ihn herausfindest, wie viel der Waffenhändler Einar für das von Wieland gefertigte Schwert verlangt."))
			call this.setReward(AAbstractQuest.rewardExperience, 300)
			call this.setStateAction(thistype.stateActionCompleted, thistype.stateActionCompleted)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Finde heraus, wie viel Einar für das Schwert verlangt."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(gg_unit_n01Y_0006)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem1 = AQuestItem.create(this, tr("Berichte Wieland davon."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(gg_unit_n01J_0154)
			call questItem1.setPingColour(100.0, 100.0, 100.0)
			return this
		endmethod
	endstruct

endlibrary
