library StructMapQuestsQuestTheWayToHolzbruck requires Asl, StructMapMapNpcs

	struct QuestTheWayToHolzbruck extends AQuest
		implement Quest

		public stub method enable takes nothing returns boolean
			return super.enable()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(0, tr("Der Weg nach Holzbruck"))
			local AQuestItem questItem0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNShip.blp")
			call this.setDescription(tr("Da der Herzog noch mehr Verbündete benötigt, sollt ihr in die flussaufwärts gelegene Stadt Holzbruck ziehen, um dort weitere Kriegsleute zu sammeln."))
			// item 0
			set questItem0 = AQuestItem.create(this, tr("Bittet die Nordmänner, euch nach Holzbruck zu bringen."))
			call questItem0.setPing(true)
			call questItem0.setPingUnit(Npcs.wigberht())
			call questItem0.setPingColour(100.0, 100.0, 100.0)
			call questItem0.setReward(AAbstractQuest.rewardExperience, 1000)
			return this
		endmethod
	endstruct

endlibrary
