library StructMapQuestsQuestPalace requires Asl, StructMapMapFellows, StructMapVideosVideoPalace

	struct QuestAreaPalace extends QuestArea
	
		public stub method onStart takes nothing returns nothing
			call VideoPalace.video().play()
			call waitForVideo(MapData.videoWaitInterval)
			call ACharacter.panCameraSmartToAll()
			call QuestPalace.quest.evaluate().questItem(QuestPalace.questItemReachPalace).complete()
			call Fellows.wigberht().shareWithAll()
			call Fellows.ricman().shareWithAll()
			call Fellows.dragonSlayer().shareWithAll()
		endmethod
	
		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct
	
	struct QuestPalace extends SharedQuest
		public static constant integer questItemReachPalace = 0
		private QuestAreaPalace m_questAreaPalace

		implement Quest

		public stub method enable takes nothing returns boolean
			set this.m_questAreaPalace = QuestAreaPalace.create(gg_rct_quest_palace_gather)
			return this.enableUntil(thistype.questItemReachPalace)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Der Palast", "The Palace"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNDemonGate.blp")
			call this.setDescription(tr("In der Nähe befindet sich ein Palast. Sammelt euch dort."))
			// item questItemReachPalace
			set questItem = AQuestItem.create(this, tr("Sammelt euch beim Palast."))
			call questItem.setPing(true)
			call questItem.setPingCoordinatesFromRect(gg_rct_quest_palace_gather)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 100)
			
			return this
		endmethod
		
		private static method onInit takes nothing returns nothing
			call SetDestructableInvulnerable(gg_dest_DTg5_0000, true)
		endmethod
	endstruct

endlibrary