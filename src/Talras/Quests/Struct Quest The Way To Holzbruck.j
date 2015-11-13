library StructMapQuestsQuestTheWayToHolzbruck requires Asl, StructMapMapNpcs, StructMapVideosVideoUpstream

	struct QuestAreaTheWayToHolzbruck extends QuestArea
	
		public stub method onCheck takes nothing returns boolean
			return true
		endmethod
	
		public stub method onStart takes nothing returns nothing
			call VideoUpstream.video().play()
		endmethod
	
		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect)
		endmethod
	endstruct

	struct QuestTheWayToHolzbruck extends AQuest
		private QuestAreaTheWayToHolzbruck m_questArea
	
		implement Quest

		public stub method enable takes nothing returns boolean
			set this.m_questArea = QuestAreaTheWayToHolzbruck.create(gg_rct_quest_the_way_to_holzbruck)
			return super.enable()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(0, tre("Der Weg nach Holzbruck", "The Way to Holzbruck"))
			local AQuestItem questItem0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNShip.blp")
			call this.setDescription(tr("Da der Herzog noch mehr Verbündete benötigt, sollt ihr in die flussaufwärts gelegene Stadt Holzbruck ziehen, um dort weitere Kriegsleute zu sammeln. ACHTUNG: Das Spiel endet mit diesem Auftrag!"))
			// item 0
			set questItem0 = AQuestItem.create(this, tre("Bittet die Nordmänner, euch nach Holzbruck zu bringen (ACHTUNG: Das Spiel endet hier!).", "Ask the Norsemen to bring you to Holzbruck (ATTENTION: The game ends here!)."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.wigberht())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(AAbstractQuest.rewardExperience, 1000)
			return this
		endmethod
	endstruct

endlibrary
