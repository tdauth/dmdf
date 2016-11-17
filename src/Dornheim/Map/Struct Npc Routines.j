library StructMapMapNpcRoutines requires StructGameDmdfHashTable, StructGameRoutines, StructMapMapNpcs

	/**
	 * \brief Static struct which stores and initializes all NPC routines for specific NPCs/units.
	 */
	struct NpcRoutines
		private static ARoutine m_teleport

		private static NpcTalksRoutine m_motherTalksToGotlinde
		private static NpcTalksRoutine m_wotanPrays
		private static NpcTalksRoutine m_wotanHouse
		private static NpcTalksRoutine m_wotanPortal

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method teleportTargetAction takes NpcRoutineWithFacing period returns nothing
			call SetUnitFacing(period.unit(), period.facing())
			call QueueUnitAnimation(period.unit(), "Attack")
			call TriggerSleepAction(2.0)
			call AContinueRoutineLoop(period, thistype.teleportTargetAction)
		endmethod

		// NOTE take a look into struct Routines which ARoutinePeriod sub types you have to create and which parameters you could set for them!!!
		public static method init takes nothing returns nothing
			set thistype.m_teleport = ARoutine.create(true, true, 0, 0, 0, thistype.teleportTargetAction) // NOTE second true means loop that it returns to the position.

			set thistype.m_motherTalksToGotlinde = NpcTalksRoutine.create(Routines.talk(), Npcs.mother(), 0.00, 24.00, gg_rct_waypoint_mother)
			call thistype.m_motherTalksToGotlinde.setFacing(218.30)
			call thistype.m_motherTalksToGotlinde.setPartner(Npcs.gotlinde())
			call thistype.m_motherTalksToGotlinde.addSound(tre("Wie geht es dir?", "How are you?"), null)
			call thistype.m_motherTalksToGotlinde.addSoundAnswer(tre("Gut.", "I'm fine."), null)

			set thistype.m_wotanPrays = NpcTalksRoutine.create(Routines.talk(), Npcs.wotan(), 8.0, 23.0, gg_rct_waypoint_wotan_island)
			call thistype.m_wotanPrays.setFacing(262.95)
			call thistype.m_wotanPrays.setPartner(null)
			call thistype.m_wotanPrays.addSound(tr("Ich bin WOOOOOTAAAAAAN und herrsche über diese Insel!"), null)
			call thistype.m_wotanPrays.addSound(tr("Nennt mich einen Gott!"), null)
			call thistype.m_wotanPrays.addSound(tr("Ich herrsche, ihr dient!"), null)

			set thistype.m_wotanHouse = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.wotan(), 23.0, 4.0, gg_rct_waypoint_wotan_house)
			call thistype.m_wotanPortal.setFacing(297.03)

			set thistype.m_wotanPortal = NpcRoutineWithFacing.create(thistype.m_teleport, Npcs.wotan(), 4.0, 8.0, gg_rct_waypoint_wotan_portal)
			call thistype.m_wotanPortal.setFacing(297.03)
		endmethod

		// NOTE manual start ALL!
		public static method manualStart takes nothing returns nothing
			call AUnitRoutine.manualStart(Npcs.mother())
			call AUnitRoutine.manualStart(Npcs.wotan())
		endmethod
	endstruct

endlibrary