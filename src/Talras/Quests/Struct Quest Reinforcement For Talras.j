library StructMapQuestsQuestReinforcementForTalras requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestReinforcementForTalras extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			call this.questItem(0).setState(AAbstractQuest.stateNew)
			call this.questItem(2).setState(AAbstractQuest.stateNew)
			call this.questItem(5).setState(AAbstractQuest.stateNew)
			
			call this.displayState()
			
			return true
		endmethod
		
		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Die Befestigung von Talras"))
			local AQuestItem questItem0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNStoneArchitecture.blp")
			call this.setDescription(tr("Markward, die rechte Hand des Herzogs, will die Burg Talras wegen einer möglichen Belagerung besser befestigen lassen. Dazu braucht er Holz von Kuno und ebenso Pfeile von Dago oder Björn den Jägern in Talras. Die Pfeile müssen auf den Mauern und Türmen platziert werden."))
			call this.setReward(thistype.rewardExperience, 1000)
			call this.setReward(thistype.rewardGold, 600)
			
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Besorge Holz von Kuno."))
			call questItem0.setPing(true)
			call questItem0.setPingWidget(Npcs.kuno())
			call questItem0.setPingColour(100.0, 100.0, 100.0)

			// item 1
			set questItem0 = AQuestItem.create(this, tr("Bringe Kunos Holz zum Bauern Manfred."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.manfred())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			
			// item 2
			set questItem0 = AQuestItem.create(this, tr("Besorge Pfeile von Dago oder Björn."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.bjoern())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			
			// item 3
			set questItem0 = AQuestItem.create(this, tr("Warte zwei Tage auf Björns Pfeile."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.bjoern())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			
			// item 4
			set questItem0 = AQuestItem.create(this, tr("Platziere die Pfeile an den vorgesehenen Positionen."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.bjoern()) // TODO set rects
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			
			// item 5
			set questItem0 = AQuestItem.create(this, tr("Berichte Markward davon."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.markward())
			call questItem0.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary