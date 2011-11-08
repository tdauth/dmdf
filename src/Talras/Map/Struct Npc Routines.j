library StructMapMapNpcRoutines requires StructGameRoutines, StructMapMapNpcs

	struct NpcRoutines
		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			// Wigberht
			call Routines.train().addUnitTime(Npcs.wigberht(), 18.00, 5.00, gg_rct_routine_wigberhts_training)
			// Osman
			call Routines.leaveHouse().addUnitTime(Npcs.osman(), 6.00, 6.00, gg_rct_waypoint_osman_3)
			call Routines.enterHouse().addUnitTime(Npcs.osman(), 19.00, 5.30, gg_rct_waypoint_osman_3)
			// Trommon (Fährmann)
			//call Routines.moveTo().addUnitTime(gg_unit_n021_0004, 12.0, 19.0, gg_rct_ferry_boat_forward_terrain) /// @todo Check on which river side Trommon is!
			//call Routines.moveTo().addUnitTime(gg_unit_n021_0004, 19.0, 12.0, gg_rct_ferry_boat_backward_terrain) /// @todo Check on which river side Trommon is!
			// Wieland
			call Routines.leaveHouse().addUnitTime(Npcs.wieland(), MapData.morning, MapData.morning, gg_rct_waypoint_wieland_3)
			call Routines.hammer().addUnitTime(Npcs.wieland(), MapData.morning, 13.00, gg_rct_waypoint_wieland_0) // wrong rect?!
			call Routines.talk().addUnitTime(Npcs.wieland(), 13.00, 14.00, gg_rct_waypoint_wieland_1)
			call Routines.drink().addUnitTime(Npcs.wieland(), 14.00, MapData.evening, gg_rct_waypoint_wieland_2)
			//call Routines.hammer().addUnitTime(gg_unit_n01Y_0006, 18.00, 22.00, gg_rct_waypoint_wieland_0)
			call Routines.enterHouse().addUnitTime(Npcs.wieland(), 22.00, MapData.morning, gg_rct_waypoint_wieland_3)
			// Mathilda
			call Routines.leaveHouse().addUnitTime(Npcs.mathilda(), MapData.morning, MapData.morning, gg_rct_waypoint_mathilda_1)
			call Routines.moveTo().addUnitTime(Npcs.mathilda(), MapData.morning, 13.00, gg_rct_waypoint_mathilda_0) /// @todo Sit in direction
			call Routines.talk().addUnitTime(Npcs.mathilda(), 13.00, 16.00, gg_rct_waypoint_mathilda_0)
			call Routines.moveTo().addUnitTime(Npcs.mathilda(), 16.00, MapData.evening, gg_rct_waypoint_mathilda_0) /// @todo Sit in direction
			call Routines.enterHouse().addUnitTime(Npcs.mathilda(), MapData.evening, MapData.morning, gg_rct_waypoint_mathilda_1)
			
			// Irmina
			call Routines.leaveHouse().addUnitTime(Npcs.irmina(), MapData.morning, MapData.morning, gg_rct_waypoint_irmina_0) // wake up
			call Routines.moveTo().addUnitTime(Npcs.irmina(), MapData.morning, MapData.morning, gg_rct_waypoint_irmina_1) // sell
			call Routines.enterHouse().addUnitTime(Npcs.irmina(), MapData.afternoon, 17.0, gg_rct_waypoint_irmina_0) // sleep
			call Routines.leaveHouse().addUnitTime(Npcs.irmina(), 17.0, MapData.evening, gg_rct_waypoint_irmina_0) // wake up
			call Routines.moveTo().addUnitTime(Npcs.irmina(), 17.0, MapData.evening, gg_rct_waypoint_irmina_1) // sell
			call Routines.enterHouse().addUnitTime(Npcs.irmina(), MapData.evening, MapData.morning, gg_rct_waypoint_irmina_0) // sleep
			
			// Einar
			call Routines.leaveHouse().addUnitTime(Npcs.einar(), MapData.morning, MapData.morning, gg_rct_waypoint_einar_0) // wake up
			call Routines.moveTo().addUnitTime(Npcs.einar(), MapData.morning, 13.0, gg_rct_waypoint_einar_1) // sell
			call Routines.talk().addUnitTime(Npcs.einar(), 13.0, 14.0, gg_rct_waypoint_einar_1) // talk to Wieland
			call Routines.moveTo().addUnitTime(Npcs.einar(), 14.0, MapData.evening, gg_rct_waypoint_einar_2) // drinkt with Wieland in tavern
			call Routines.enterHouse().addUnitTime(Npcs.einar(), MapData.evening, MapData.morning, gg_rct_waypoint_einar_0) // sleep
			
			// menials
			call Routines.harvest().addUnitTime(gg_unit_n02J_0013, 6.00, 18.00, gg_rct_waypoint_menial_0)
			call Routines.harvest().addUnitTime(gg_unit_n02J_0157, 6.00, 18.00, gg_rct_waypoint_menial_1)
			call Routines.harvest().addUnitTime(gg_unit_n02J_0159, 6.00, 18.00, gg_rct_waypoint_menial_2)
			call Routines.harvest().addUnitTime(gg_unit_n02J_0158, 6.00, 18.00, gg_rct_waypoint_menial_3)
		endmethod
	endstruct

endlibrary