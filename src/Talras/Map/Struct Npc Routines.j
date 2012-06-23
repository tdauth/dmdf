library StructMapMapNpcRoutines requires StructGameDmdfHashTable, StructGameRoutines, StructMapMapNpcs

	struct NpcRoutines
		private static AUnitRoutine m_wigberhtTraining
		private static AUnitRoutine m_osmanLeavesHouse
		private static AUnitRoutine m_osmanEntersHouse
		private static AUnitRoutine m_wielandLeavesHouse
		private static AUnitRoutine m_wielandHammers
		private static AUnitRoutine m_wielandTalks
		private static AUnitRoutine m_wielandDrinks
		private static AUnitRoutine m_wielandEntersHouse
		private static AUnitRoutine m_mathildaLeavesHouse
		private static AUnitRoutine m_mathildaMovesTo0
		private static AUnitRoutine m_mathildaTalks
		private static AUnitRoutine m_mathildaMovesTo1
		private static AUnitRoutine m_mathildaEntersHouse
		private static AUnitRoutine m_irminaLeavesHouse0
		private static AUnitRoutine m_irminaMovesTo0
		private static AUnitRoutine m_irminaEntersHouse0
		private static AUnitRoutine m_irminaLeavesHouse1
		private static AUnitRoutine m_irminaMovesTo1
		private static AUnitRoutine m_irminaEntersHouse1
		private static AUnitRoutine m_einarLeavesHouse
		private static AUnitRoutine m_einarSells
		private static AUnitRoutine m_einarTalks
		private static AUnitRoutine m_einarDrinks
		private static AUnitRoutine m_einarEntersHouse

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			// Wigberht
			set thistype.m_wigberhtTraining = AUnitRoutine.create(Routines.train(), Npcs.wigberht(), 18.00, 5.00, gg_rct_routine_wigberhts_training)

			// Osman
			set thistype.m_osmanLeavesHouse = AUnitRoutine.create(Routines.leaveHouse(), Npcs.osman(), 6.00, 6.00, gg_rct_waypoint_osman_3)
			set thistype.m_osmanEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.osman(), 19.00, 5.30, gg_rct_waypoint_osman_3)

			// Trommon (Fährmann)
			//call Routines.moveTo().addUnitTime(gg_unit_n021_0004, 12.0, 19.0, gg_rct_ferry_boat_forward_terrain) /// @todo Check on which river side Trommon is!
			//call Routines.moveTo().addUnitTime(gg_unit_n021_0004, 19.0, 12.0, gg_rct_ferry_boat_backward_terrain) /// @todo Check on which river side Trommon is!

			// Wieland
			set thistype.m_wielandLeavesHouse = AUnitRoutine.create(Routines.leaveHouse(), Npcs.wieland(), MapData.morning, MapData.morning, gg_rct_waypoint_wieland_3)
			set thistype.m_wielandHammers = AUnitRoutine.create(Routines.hammer(), Npcs.wieland(), MapData.morning, 13.00, gg_rct_waypoint_wieland_0) // wrong rect?!
			set thistype.m_wielandTalks = AUnitRoutine.create(Routines.talk(), Npcs.wieland(), 13.00, 14.00, gg_rct_waypoint_wieland_1)
			set thistype.m_wielandDrinks = AUnitRoutine.create(Routines.drink(), Npcs.wieland(), 14.00, MapData.evening, gg_rct_waypoint_wieland_2)
			set thistype.m_wielandEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.wieland(), 22.00, MapData.morning, gg_rct_waypoint_wieland_3)

			// Mathilda
			set thistype.m_mathildaLeavesHouse = AUnitRoutine.create(Routines.leaveHouse(), Npcs.mathilda(), MapData.morning, MapData.morning, gg_rct_waypoint_mathilda_1)
			set thistype.m_mathildaMovesTo0 = AUnitRoutine.create(Routines.moveTo(), Npcs.mathilda(), MapData.morning, 13.00, gg_rct_waypoint_mathilda_0) /// @todo Sit in direction
			set thistype.m_mathildaTalks = AUnitRoutine.create(Routines.talk(), Npcs.mathilda(), 13.00, 16.00, gg_rct_waypoint_mathilda_0)
			set thistype.m_mathildaMovesTo1 = AUnitRoutine.create(Routines.moveTo(), Npcs.mathilda(), 16.00, MapData.evening, gg_rct_waypoint_mathilda_0) /// @todo Sit in direction
			set thistype.m_mathildaEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.mathilda(), MapData.evening, MapData.morning, gg_rct_waypoint_mathilda_1)

			// Irmina
			set thistype.m_irminaLeavesHouse0 = AUnitRoutine.create(Routines.leaveHouse(), Npcs.irmina(), MapData.morning, MapData.morning, gg_rct_waypoint_irmina_0) // wake up
			set thistype.m_irminaMovesTo0 = AUnitRoutine.create(Routines.moveTo(), Npcs.irmina(), MapData.morning, MapData.morning, gg_rct_waypoint_irmina_1) // sell
			set thistype.m_irminaEntersHouse0 = AUnitRoutine.create(Routines.enterHouse(), Npcs.irmina(), MapData.afternoon, 17.0, gg_rct_waypoint_irmina_0) // sleep
			set thistype.m_irminaLeavesHouse1 = AUnitRoutine.create(Routines.leaveHouse(), Npcs.irmina(), 17.0, MapData.evening, gg_rct_waypoint_irmina_0) // wake up
			set thistype.m_irminaMovesTo1 = AUnitRoutine.create(Routines.moveTo(), Npcs.irmina(), 17.0, MapData.evening, gg_rct_waypoint_irmina_1) // sell
			set thistype.m_irminaEntersHouse1 = AUnitRoutine.create(Routines.enterHouse(), Npcs.irmina(), MapData.evening, MapData.morning, gg_rct_waypoint_irmina_0) // sleep

			// Einar
			set thistype.m_einarLeavesHouse = AUnitRoutine.create(Routines.leaveHouse(), Npcs.einar(), MapData.morning, MapData.morning, gg_rct_waypoint_einar_0) // wake up
			set thistype.m_einarSells = AUnitRoutine.create(Routines.moveTo(), Npcs.einar(), MapData.morning, 13.0, gg_rct_waypoint_einar_1) // sell
			set thistype.m_einarTalks = AUnitRoutine.create(Routines.talk(), Npcs.einar(), 13.0, 14.0, gg_rct_waypoint_einar_1) // talk to Wieland
			set thistype.m_einarDrinks = AUnitRoutine.create(Routines.drink(), Npcs.einar(), 14.0, MapData.evening, gg_rct_waypoint_einar_2) // drinks with Wieland in tavern
			set thistype.m_einarEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.einar(), MapData.evening, MapData.morning, gg_rct_waypoint_einar_0) // sleep

			// menials
			call AUnitRoutine.create(Routines.harvest(), gg_unit_n02J_0013, 6.00, 18.00, gg_rct_waypoint_menial_0)
			call AUnitRoutine.create(Routines.harvest(), gg_unit_n02J_0157, 6.00, 18.00, gg_rct_waypoint_menial_1)
			call AUnitRoutine.create(Routines.harvest(), gg_unit_n02J_0159, 6.00, 18.00, gg_rct_waypoint_menial_2)
			call AUnitRoutine.create(Routines.harvest(), gg_unit_n02J_0158, 6.00, 18.00, gg_rct_waypoint_menial_3)
		endmethod
	endstruct

endlibrary