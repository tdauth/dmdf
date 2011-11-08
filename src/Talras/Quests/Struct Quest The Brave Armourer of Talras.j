library StructMapQuestsQuestTheBraveArmourerOfTalras requires Asl

	struct QuestTheBraveArmourerOfTalras extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Talras' mutiger Waffenmeister"))
			local AQuestItem questItem0

			call this.setIconPath("") /// @todo FIXME
			call this.setDescription(tr("Die Händlerin Irmina hat viel für den Waffenmeister Agihard übrig. Daraus könnte vielleicht mal mehr werden, vielleicht ist es auch schon mehr. Man weiß es nicht ..."))
			call this.setReward(AAbstractQuest.rewardExperience, 100)
			// item 0
			set questItem0 = AQuestItem.create(this, tr("￼￼Berichte Agihard von dieser unfassbaren Erkenntnis."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(gg_unit_n00S_0135)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(AAbstractQuest.rewardExperience, 50)

			// item 1
			set questItem0 = AQuestItem.create(this, tr("Berichte Irmina von jenem Wunder."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(gg_unit_n01S_0201)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(AAbstractQuest.rewardExperience, 50)

			return this
		endmethod
	endstruct

endlibrary