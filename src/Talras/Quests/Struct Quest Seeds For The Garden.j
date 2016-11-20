library StructMapQuestsQuestSeedsForTheGarden requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestSeedsForTheGarden extends AQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(1)
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Samen für den Garten", "Seeds for the Garden"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNDust.blp")
			call this.setDescription(tre("Trommon möchte etwas Neues in seinem Garten anpflanzen. Da er sich selbst nicht besonders gut auskennt, braucht er Ursulas Hilfe. Besorge Trommon für seinen Garten ein paar Samen von Ursula.", "Trommon wants to plant something new in his garden. Since he knows not much himself he needs the help of Ursula. Obtain Trommon a few seeds for his garden from Ursula."))
			call this.setReward(thistype.rewardExperience, 200)
			call this.setReward(thistype.rewardGold, 200)
			// item 0
			set questItem = AQuestItem.create(this, tre("Besorge ein paar Samen von Ursula.", "Get a few seeds from Ursula."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.ursula())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 1
			set questItem = AQuestItem.create(this, tre("Bringe die Samen zu Trommon.", "Bring the seeds to Trommon."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.trommon())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 2
			set questItem = AQuestItem.create(this, tre("Pflanze den magischen Samen ein.", "Plant the magical seed."))
			call questItem.setPing(true)
			call questItem.setPingX(GetRectCenterX(gg_rct_trommons_vegetable_garden))
			call questItem.setPingY(GetRectCenterY(gg_rct_trommons_vegetable_garden))
			call questItem.setPingColour(100.0, 100.0, 100.0)

			// item 3
			set questItem = AQuestItem.create(this, tre("Berichte Trommon davon.", "Report to Trommon about it."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.trommon())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary