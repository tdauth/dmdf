library StructMapQuestsQuestSeedsForTheGarden requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestSeedsForTheGarden extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(1)
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tr("Samen für den Garten"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNDust.blp")
			call this.setDescription(tr("Trommon möchte etwas Neues in seinem Garten anpflanzen. Da er sich selbst nicht besonders gut auskennt, braucht er Ursulas Hilfe. Besorge Trommon für seinen Garten ein paar Samen von Ursula."))
			call this.setReward(AAbstractQuest.rewardExperience, 200)
			// item 0
			set questItem = AQuestItem.create(this, tr("Besorge ein paar Samen von Ursula."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.ursula())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 1
			set questItem = AQuestItem.create(this, tr("Bringe die Samen zu Trommon."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.trommon())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// item 2
			set questItem = AQuestItem.create(this, tr("Pflanze den magischen Samen ein."))
			call questItem.setPing(true)
			call questItem.setPingX(GetRectCenterX(gg_rct_trommons_vegetable_garden))
			call questItem.setPingY(GetRectCenterY(gg_rct_trommons_vegetable_garden))
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// item 3
			set questItem = AQuestItem.create(this, tr("Berichte Trommon davon."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.trommon())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary