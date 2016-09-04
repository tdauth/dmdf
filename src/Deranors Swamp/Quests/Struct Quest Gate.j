library StructMapQuestsQuestGate requires Asl, StructMapMapFellows

	struct QuestGate extends SharedQuest
		public static constant integer questItemGateActivator0 = 0
		public static constant integer questItemGateActivator1 = 1
		public static constant integer questItemGateActivator2 = 2
		public static constant integer questItemActivate = 3

		implement Quest

		public stub method enable takes nothing returns boolean
			return this.enableUntil(thistype.questItemActivate)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(tr("Das versiegelte Tor"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNDemonGate.blp")
			call this.setDescription(tr("Deranor der Schreckliche hat das Tor seiner Welt mit einem Zauber versiegelt. Die Kraftfelder müssen zunächst deaktiviert werden, bevor die Versiegelung aufgehoben werden kann."))

			// questItemGateActivator0
			set questItem = AQuestItem.create(this, tr("Deaktviert das erste Kraftfeld."))
			call questItem.setPing(true)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setPingCoordinatesFromRect(gg_rct_gate_activator_0)
			call questItem.setReward(thistype.rewardExperience, 100)

			// questItemGateActivator1
			set questItem = AQuestItem.create(this, tr("Deaktviert das zweite Kraftfeld."))
			call questItem.setPing(true)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setPingCoordinatesFromRect(gg_rct_gate_activator_1)
			call questItem.setReward(thistype.rewardExperience, 100)

			// questItemGateActivator2
			set questItem = AQuestItem.create(this, tr("Deaktviert das dritte Kraftfeld."))
			call questItem.setPing(true)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setPingCoordinatesFromRect(gg_rct_gate_activator_2)
			call questItem.setReward(thistype.rewardExperience, 100)

			// questItemGateActivator2
			set questItem = AQuestItem.create(this, tr("Hebt die Versiegelung von Deranor auf."))
			call questItem.setPing(true)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			call questItem.setPingCoordinatesFromRect(gg_rct_gate_weather)
			call questItem.setReward(thistype.rewardExperience, 100)

			return this
		endmethod

		private static method onInit takes nothing returns nothing
		endmethod
	endstruct

endlibrary