library StructMapQuestsQuestKunosDaughter requires Asl, StructMapMapNpcs

	struct QuestKunosDaughter extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Kunos Tochter"))
			local AQuestItem questItem0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNImprovedBows.blp")
			call this.setDescription(tr("Die Tochter des Holzfällers Kuno will sich später einmal alleine durch die Wildnis schlagen, kennt sich aber nicht mit der Jagd aus."))
			call this.setReward(AAbstractQuest.rewardExperience, 200)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("￼￼Finde einen Jagd-Lehrer für Kunos Tochter."))
			call questItem0.setReward(AAbstractQuest.rewardExperience, 50)

			// item 1
			set questItem0 = AQuestItem.create(this, tr("Berichte Kuno davon."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.kuno())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(AAbstractQuest.rewardExperience, 50)

			return this
		endmethod
	endstruct

endlibrary