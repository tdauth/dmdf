library StructMapQuestsQuestWielandsSword requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestWielandsSword extends AQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method stateActionCompleted takes AQuest whichQuest returns nothing
			// Edles Langschwert
			call Character(whichQuest.character()).giveItem('I04Y')
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Wielands Schwert", "Wieland's Sword"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNLongsword.blp")
			call this.setDescription(tre("Der Schmied Wieland aus Talras möchte, dass du für ihn herausfindest, wie viel der Waffenhändler Einar für das von Wieland gefertigte Schwert verlangt.", "The blacksmith Wieland from Talras wants you to find out for him, how much the arms merchant Einar demands for the sword manufactured by Wieland."))
			call this.setReward(thistype.rewardExperience, 300)
			call this.setStateAction(thistype.stateActionCompleted, thistype.stateActionCompleted)
			// item 0
			set questItem = AQuestItem.create(this, tre("Finde heraus, wie viel Einar für das Schwert verlangt.", "Figure out how much Einar demands for the sword."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.einar())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem = AQuestItem.create(this, tre("Berichte Wieland davon.", "Report Wieland thereof."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.wieland())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary
