library StructMapQuestsQuestThePaedophilliacCleric requires Asl

	struct QuestThePaedophilliacCleric extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Der pädophile Kleriker"))
			local AQuestItem questItem0
			local AQuestItem questItem1
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNVillagerKid.blp")
			call this.setDescription(tr("Osman, der Burgkleriker, war wohl von deiner überaus menschlichen Art nicht so ganz begeistert. Er will sich beim Herzog über dich beschweren, was nicht unbedingt gute Folgen für dich hätte, da du ja sozusagen für ihn arbeiten möchtest."))
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Schwärze Osman beim Herzog an."))
			//call questItem0.setPing(true)
			//call questItem0.setPingUnit(gg_unit_n00Q_0028)
			//call questItem0.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem1 = AQuestItem.create(this, tr("Ärgere Osman damit."))
			call questItem1.setPing(true)
			call questItem1.setPingUnit(gg_unit_n00R_0101)
			call questItem1.setPingColour(100.0, 100.0, 100.0)
			return this
		endmethod
	endstruct

endlibrary