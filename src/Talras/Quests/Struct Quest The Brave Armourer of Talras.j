library StructMapQuestsQuestTheBraveArmourerOfTalras requires Asl

	struct QuestTheBraveArmourerOfTalras extends AQuest

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Talras' mutiger Waffenmeister", "The Brave Armorer of Talras"))
			local AQuestItem questItem0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNFootman.blp") // Icon of Agihard
			call this.setDescription(tre("Die Händlerin Irmina hat viel für den Waffenmeister Agihard übrig. Daraus könnte vielleicht mal mehr werden, vielleicht ist es auch schon mehr. Man weiß es nicht ...", "The merchant Irmina has much left for the armorer Agihard. It could possibly become some more, maybe it is already. One does not know ..."))
			call this.setReward(thistype.rewardExperience, 100)
			// item 0
			set questItem0 = AQuestItem.create(this, tre("￼￼Berichte Agihard von dieser unfassbaren Erkenntnis.", "Report Agihard of this incredible knowledge."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(gg_unit_n00S_0135)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(thistype.rewardExperience, 50)

			// item 1
			set questItem0 = AQuestItem.create(this, tre("Berichte Irmina von jenem Wunder.", "Report Irmina of that miracle."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(gg_unit_n01S_0201)
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(thistype.rewardExperience, 50)

			return this
		endmethod
	endstruct

endlibrary