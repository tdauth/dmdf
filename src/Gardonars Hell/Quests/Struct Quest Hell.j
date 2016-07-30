library StructMapQuestsQuestHell requires Asl, StructMapMapFellows
	
	struct QuestHell extends SharedQuest
		public static constant integer questItemFightThroughHell = 0

		implement Quest

		public stub method enable takes nothing returns boolean
			return this.enableUntil(thistype.questItemFightThroughHell)
		endmethod
		
		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Die Hölle", "The Hell"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNDemonGate.blp")
			call this.setDescription(tre("Gardonars Hölle ist voller Dämonen, die euch allesamt töten wollen.", "Gardonar's Hell is full of demon who all want to kill you."))
			
			// item questItemFightThroughHell
			set questItem = AQuestItem.create(this, tre("Kämpft euch durch Gardonars Hölle.", "Fight through Gardonar's hell."))
			call questItem.setPing(true)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setPingCoordinatesFromRect(gg_rct_zone_holzbruck)
			call questItem.setReward(thistype.rewardExperience, 100)
			
			return this
		endmethod
		
		private static method onInit takes nothing returns nothing
		endmethod
	endstruct

endlibrary