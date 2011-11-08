library StructMapTalksTalkTalrasGuardian requires Asl, StructMapQuestsQuestTalras

	struct TalkTalrasGuardian extends ATalk

		private method startPageAction takes nothing returns nothing
			call this.showUntil(3)
		endmethod

		// Wie geht's?
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Wie geht's?"), null)
			call speech(info, true, tr("Mir geht's gut. Danke der Nachfrage. Nur die Arbeit macht mir ein Wenig zu schaffen."), null)
			call info.talk().showStartPage()
		endmethod

		// Dienst du dem Herzog?
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Dienst du dem Herzog?"), null)
			call speech(info, true, tr("Ja. Ich diene Heimrich, dem Herrn von Talras."), null)
			call info.talk().showStartPage()
		endmethod

		// Was weißt du über ...
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Was weißt du über ..."), null)
			call info.talk().showRange(4, 9)
		endmethod

		//... den bevorstehenden Krieg?
		private static method infoAction2_0 takes AInfo info returns nothing
			call speech(info, false, tr("... den bevorstehenden Krieg?"), null)
			/// @todo Answer.
			call info.talk().showRange(4, 9)
		endmethod

		// (Auftrag „Talras“ abgeschlossen)
		private static method infoCondition2_1 takes AInfo info returns boolean
			return QuestTalras.quest().state() == AAbstractQuest.stateCompleted
		endmethod

		// ... die Nordmänner vor der Burg?
		private static method infoAction2_1 takes AInfo info returns nothing
			call speech(info, false, tr("... die Nordmänner vor der Burg?"), null)
			/// @todo Answer.
			call info.talk().showRange(4, 9)
		endmethod

		// ... die Bauern?
		private static method infoAction2_2 takes AInfo info returns nothing
			call speech(info, false, tr("... die Bauern?"), null)
			/// @todo Answer.
			call info.talk().showRange(4, 9)
		endmethod

		// ... den Herzog?
		private static method infoAction2_3 takes AInfo info returns nothing
			call speech(info, false, tr("... den Herzog?"), null)
			/// @todo Answer.
			call info.talk().showRange(4, 9)
		endmethod

		// ... die Gegend hier?
		private static method infoAction2_4 takes AInfo info returns nothing
			call speech(info, false, tr("... die Gegend hier?"), null)
			/// @todo Answer.
			call info.talk().showRange(4, 9)
		endmethod

		public static method create takes unit npc returns thistype
			local thistype this = thistype.allocate(npc, thistype.startPageAction)

			// start page
			call this.addInfo(true, false, 0, thistype.infoAction0, tr("Wie geht's?")) // 0
			call this.addInfo(true, false, 0, thistype.infoAction1, tr("Dienst du dem Herzog?")) // 1
			call this.addInfo(true, false, 0, thistype.infoAction2, tr("Was weißt du über ...")) // 2
			call this.addExitButton() // 3

			// info 2
			call this.addInfo(true, false, 0, thistype.infoAction2_0, tr("... den bevorstehenden Krieg?")) // 4
			call this.addInfo(true, false, thistype.infoCondition2_1, thistype.infoAction2_1, tr("... die Nordmänner vor der Burg?")) // 5
			call this.addInfo(true, false, 0, thistype.infoAction2_2, tr("... die Bauern?")) // 6
			call this.addInfo(true, false, 0, thistype.infoAction2_3, tr("... den Herzog?")) // 7
			call this.addInfo(true, false, 0, thistype.infoAction2_4, tr("... die Gegend hier?")) // 8
			call this.addBackToStartPageButton() // 9

			return this
		endmethod
	endstruct

endlibrary
