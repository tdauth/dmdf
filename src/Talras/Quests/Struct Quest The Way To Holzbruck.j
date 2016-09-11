library StructMapQuestsQuestTheWayToHolzbruck requires Asl, StructGameCharacter, StructMapMapNpcs, StructMapVideosVideoUpstream

	struct QuestAreaTheWayToHolzbruck extends QuestArea

		public stub method onStart takes nothing returns nothing
			call VideoUpstream.video().play()
		endmethod

		public static method create takes rect whichRect returns thistype
			return thistype.allocate(whichRect, true)
		endmethod
	endstruct

	struct QuestTheWayToHolzbruck extends SharedQuest
		private QuestAreaTheWayToHolzbruck m_questArea

		implement Quest

		public stub method enable takes nothing returns boolean
			call Missions.addMissionToAll('A1E3', 'A1RG', this)

			set this.m_questArea = QuestAreaTheWayToHolzbruck.create(gg_rct_quest_the_way_to_holzbruck)

			return super.enable()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tre("Der Weg nach Holzbruck", "The Way to Holzbruck"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNShip.blp")
			call this.setDescription(tre("Da der Herzog noch mehr Verbündete benötigt, sollt ihr in die flussaufwärts gelegene Stadt Holzbruck ziehen, um dort weitere Kriegsleute zu sammeln. ACHTUNG: Das Spiel endet mit diesem Auftrag!", "Since the duke still needs more allies you shall move to the town Holzbruck which is located upstream to gather more soldiers there. NOTE: The game ends with this mission!"))
			// item 0
			set questItem = AQuestItem.create(this, tre("Bittet die Nordmänner, euch nach Holzbruck zu bringen (ACHTUNG: Das Spiel endet hier!).", "Ask the Norsemen to bring you to Holzbruck (ATTENTION: The game ends here!)."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.wigberht())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setReward(thistype.rewardExperience, 1000)

			return this
		endmethod
	endstruct

endlibrary
