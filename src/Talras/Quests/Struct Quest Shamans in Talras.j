library StructMapQuestsQuestShamansInTalras requires Asl, StructMapMapNpcs

	struct QuestShamansInTalras extends AQuest

		implement CharacterQuest

		// do not enable any quest item yet
		public stub method enable takes nothing returns boolean
			return super.enableUntil(-1)
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Schamanen in Talras", "Shamans in Talras"))
			local AQuestItem questItem0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNShadowHunter.blp")
			call this.setDescription(tre("In der östlichen Region von Talras halten sich die beiden Schamanen Tellborn und Tanka auf. Da sie voneinander nichts wissen, ist es an der Zeit sie miteinander bekannt zu machen. Immerhin sind beide Schamanen!", "In the eastern region of Talras the two shamans Tellborn and Tanka are staying. Since they do not know about each other it is time to acquaint them with each other. After all, they both are shamans!"))
			call this.setReward(thistype.rewardExperience, 200)
			// item 0
			set questItem0 = AQuestItem.create(this, tre("Bringe Tanka den Brief von Tellborn.", "Bring Tanka a letter of Tellborn."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.tanka())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(thistype.rewardExperience, 50)

			// item 1
			set questItem0 = AQuestItem.create(this, tre("Bringe Tellborn das Schreiben von Tanka.", "Bring Tellborn the writing of Tanka."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.tellborn())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(thistype.rewardExperience, 50)

			return this
		endmethod
	endstruct

endlibrary