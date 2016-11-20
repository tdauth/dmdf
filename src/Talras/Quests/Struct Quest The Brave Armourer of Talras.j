library StructMapQuestsQuestTheBraveArmourerOfTalras requires Asl, StructGameCharacter, StructMapMapNpcs

	struct QuestTheBraveArmourerOfTalras extends AQuest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tre("Talras' mutiger Waffenmeister", "The Brave Armorer of Talras"))
			local AQuestItem questItem = 0

			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNFootman.blp") // Icon of Agihard
			call this.setDescription(tre("Die Händlerin Irmina hat viel für den Waffenmeister Agihard übrig. Daraus könnte vielleicht mal mehr werden, vielleicht ist es auch schon mehr. Man weiß es nicht ...", "The merchant Irmina has much left for the armorer Agihard. It could possibly become some more, maybe it is already. One does not know ..."))
			call this.setReward(thistype.rewardExperience, 100)
			// item 0
			set questItem = AQuestItem.create(this, tre("￼￼Berichte Agihard von dieser unfassbaren Erkenntnis.", "Report Agihard of this incredible knowledge."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.agihard())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 50)

			// item 1
			set questItem = AQuestItem.create(this, tre("Berichte Irmina von jenem Wunder.", "Report Irmina of that miracle."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.irmina())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 50)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary