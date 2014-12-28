library StructMapQuestsQuestSupplyForTalras requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestSupplyForTalras extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			call this.questItem(0).setState(AAbstractQuest.stateNew)
			call this.questItem(1).setState(AAbstractQuest.stateNew)
			
			call this.displayState()
			
			return true
		endmethod
		
		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Die Versorgung von Talras"))
			local AQuestItem questItem0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNMonsterLure.blp")
			call this.setDescription(tr("Markward, die rechte Hand des Herzogs, möchte sich auf eine bevorstehende Belagerung von Talras vorbereiten. Daher will er Vorräte vom Bauern Manfred in der Burg einlagern."))
			call this.setReward(thistype.rewardExperience, 500)
			call this.setReward(thistype.rewardGold, 300)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Veranlasse dass Manfred Vorräte nach Talras schickt."))
			call questItem0.setPing(true)
			call questItem0.setPingWidget(Npcs.manfred())
			call questItem0.setPingColour(100.0, 100.0, 100.0)

			// item 1
			set questItem0 = AQuestItem.create(this, tr("Berichte Markward davon."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.markward())
			call questItem0.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary