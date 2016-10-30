library StructMapMapNpcRoutines requires StructGameDmdfHashTable, StructGameRoutines, StructMapMapNpcs

	/**
	 * \brief Static struct which stores and initializes all NPC routines for specific NPCs/units.
	 */
	struct NpcRoutines
		private static NpcTalksRoutine m_motherTalksToGotlinde

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		// NOTE take a look into struct Routines which ARoutinePeriod sub types you have to create and which parameters you could set for them!!!
		public static method init takes nothing returns nothing
			// Björn
			set thistype.m_motherTalksToGotlinde = NpcTalksRoutine.create(Routines.talk(), Npcs.mother(), 0.00, 24.00, gg_rct_waypoint_mother)
			call thistype.m_motherTalksToGotlinde.setFacing(218.30)
			call thistype.m_motherTalksToGotlinde.setPartner(Npcs.gotlinde())
			call thistype.m_motherTalksToGotlinde.addSound(tre("Wie geht es dir?", "How are you?"), null)
			call thistype.m_motherTalksToGotlinde.addSoundAnswer(tre("Gut.", "I'm fine."), null)
		endmethod

		// NOTE manual start ALL!
		public static method manualStart takes nothing returns nothing
			call AUnitRoutine.manualStart(Npcs.mother())
		endmethod
	endstruct

endlibrary