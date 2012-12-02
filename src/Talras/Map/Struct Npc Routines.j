library StructMapMapNpcRoutines requires StructGameDmdfHashTable, StructGameRoutines, StructMapMapNpcs

	struct NpcRoutines
		private static NpcRoutineWithFacing m_wigberhtTraining

		// castle
		// Sisgard
		private static NpcLeavesHouseRoutine m_sisgardLeavesHouse
		private static NpcRoutineWithFacing m_sisgardStandsNearHerHouse
		private static AUnitRoutine m_sisgardEntersHouse
		// Agihard
		private static NpcLeavesHouseRoutine m_agihardLeavesHouse
		private static NpcRoutineWithFacing m_agihardStandsNearArena
		private static AUnitRoutine m_agihardEntersHouse
		// Björn
		private static NpcLeavesHouseRoutine m_bjoernLeavesHouse
		private static NpcRoutineWithFacing m_bjoernWorksAtFurs
		private static NpcTalksRoutine m_bjoernTalksToHisWife
		private static NpcTalksRoutine m_bjoernTalksToManfred
		private static AUnitRoutine m_bjoernEntersHouse
		// Björn's wife
		private static NpcLeavesHouseRoutine m_bjoernsWifeLeavesHouse
		private static NpcRoutineWithFacing m_bjoernsWifeStandsNearFire0
		private static NpcTalksRoutine m_bjoernsWifeTalksToBjoern
		private static NpcRoutineWithFacing m_bjoernsWifeStandsNearFire1
		private static AUnitRoutine m_bjoernsWifeEntersHouse
		// Osman
		private static NpcLeavesHouseRoutine m_osmanLeavesHouse
		private static NpcRoutineWithFacing m_osmanPrays0
		private static NpcRoutineWithFacing m_osmanStandsNearDuke
		private static NpcRoutineWithFacing m_osmanPrays1
		private static AUnitRoutine m_osmanEntersHouse
		// Ferdinand
		private static NpcLeavesHouseRoutine m_ferdinandLeavesHouse
		private static NpcRoutineWithFacing m_ferdinandStandsInCastle
		private static NpcTalksRoutine m_ferdinandTalksToHeimrich
		private static AUnitRoutine m_ferdinandEntersHouse
		// Heimrich
		private static NpcLeavesHouseRoutine m_heimrichLeavesHouse
		private static NpcTalksRoutine m_heimrichTalksToMarkward
		private static NpcTalksRoutine m_heimrichTalksToFerdinand
		private static AUnitRoutine m_heimrichEntersHouse
		// Markward
		private static NpcLeavesHouseRoutine m_markwardLeavesHouse
		private static NpcTalksRoutine m_markwardTalksToHeimrich
		private static NpcRoutineWithFacing m_markwardStandsInCastle
		private static AUnitRoutine m_markwardEntersHouse
		// Wieland
		private static NpcLeavesHouseRoutine m_wielandLeavesHouse
		private static NpcRoutineWithFacing m_wielandHammers
		private static NpcTalksRoutine m_wielandTalks
		private static AUnitRoutine m_wielandDrinks
		private static AUnitRoutine m_wielandEntersHouse
		// Irmina
		private static NpcLeavesHouseRoutine m_irminaLeavesHouse0
		private static NpcRoutineWithFacing m_irminaMovesTo0
		private static AUnitRoutine m_irminaEntersHouse0
		private static NpcLeavesHouseRoutine m_irminaLeavesHouse1
		private static NpcRoutineWithFacing m_irminaMovesTo1
		private static AUnitRoutine m_irminaEntersHouse1
		// Einar
		private static NpcLeavesHouseRoutine m_einarLeavesHouse
		private static NpcRoutineWithFacing m_einarSells
		private static NpcTalksRoutine m_einarTalks
		private static AUnitRoutine m_einarDrinks
		private static AUnitRoutine m_einarEntersHouse

		// village/farm
		// Mathilda
		private static NpcLeavesHouseRoutine m_mathildaLeavesHouse
		private static NpcRoutineWithFacing m_mathildaMovesTo0
		private static NpcTalksRoutine m_mathildaTalks
		private static NpcRoutineWithFacing m_mathildaMovesTo1
		private static AUnitRoutine m_mathildaEntersHouse
		// Lothar
		private static NpcLeavesHouseRoutine m_lotharLeavesHouse
		private static NpcRoutineWithFacing m_lotharSells0
		private static NpcTalksRoutine m_lotharFlirtsWithMathilda
		private static NpcRoutineWithFacing m_lotharSells1
		private static AUnitRoutine m_lotharEntersHouse

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		// NOTE take a look into struct Routines which ARoutinePeriod sub types you have to create and which parameters you could set for them!!!
		public static method init takes nothing returns nothing
			// Wigberht
			set thistype.m_wigberhtTraining = NpcRoutineWithFacing.create(Routines.train(), Npcs.wigberht(), 18.00, 5.00, gg_rct_waypoint_wigberht_training)
			call thistype.m_wigberhtTraining.setFacing(252.39)

			// Sisgard
			set thistype.m_sisgardLeavesHouse = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.sisgard(), MapData.morning, MapData.morning, gg_rct_waypoint_sisgard_1)
			set thistype.m_sisgardStandsNearHerHouse = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.sisgard(), MapData.morning, MapData.evening, gg_rct_waypoint_sisgard_0)
			call thistype.m_sisgardStandsNearHerHouse.setFacing(211.35)
			set thistype.m_sisgardEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.sisgard(), MapData.evening, MapData.morning, gg_rct_waypoint_sisgard_1)

			// Agihard
			set thistype.m_agihardLeavesHouse = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.agihard(), MapData.morning, MapData.morning, gg_rct_waypoint_agihard_1)
			set thistype.m_agihardStandsNearArena = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.agihard(), MapData.morning, MapData.evening, gg_rct_waypoint_agihard_0)
			call thistype.m_agihardStandsNearArena.setFacing(13.80)
			set thistype.m_agihardEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.agihard(), MapData.evening, MapData.morning, gg_rct_waypoint_agihard_1)

			// Björn
			set thistype.m_bjoernLeavesHouse = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.bjoern(), MapData.morning, MapData.morning, gg_rct_waypoint_bjoern_0)
			set thistype.m_bjoernWorksAtFurs = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.bjoern(), MapData.morning, 14.00, gg_rct_waypoint_bjoern_1)
			call thistype.m_bjoernWorksAtFurs.setFacing(35.48)
			set thistype.m_bjoernTalksToHisWife = NpcTalksRoutine.create(Routines.talk(), Npcs.bjoern(), 14.00, 16.00, gg_rct_waypoint_bjoern_2)
			call thistype.m_bjoernTalksToHisWife.setPartner(Npcs.bjoernsWife())
			set thistype.m_bjoernTalksToManfred = NpcTalksRoutine.create(Routines.talk(), Npcs.bjoern(), 16.00, MapData.evening, gg_rct_waypoint_bjoern_3)
			call thistype.m_bjoernTalksToManfred.setPartner(Npcs.manfred())
			set thistype.m_bjoernEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.bjoern(), MapData.evening, MapData.morning, gg_rct_waypoint_bjoern_0)

			// Björn's wife
			set thistype.m_bjoernsWifeLeavesHouse = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.bjoernsWife(), MapData.morning, MapData.morning, gg_rct_waypoint_bjoern_0)
			set thistype.m_bjoernsWifeStandsNearFire0 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.bjoernsWife(), MapData.morning, 14.00, gg_rct_waypoint_bjoerns_wife)
			call thistype.m_bjoernsWifeStandsNearFire0.setFacing(183.27)
			set thistype.m_bjoernsWifeTalksToBjoern = NpcTalksRoutine.create(Routines.talk(), Npcs.bjoernsWife(), 14.00, 16.00, gg_rct_waypoint_bjoerns_wife)
			call thistype.m_bjoernsWifeTalksToBjoern.setPartner(Npcs.bjoern())
			set thistype.m_bjoernsWifeStandsNearFire1 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.bjoernsWife(), 16.00, MapData.evening, gg_rct_waypoint_bjoerns_wife)
			call thistype.m_bjoernsWifeStandsNearFire1.setFacing(183.27)
			set thistype.m_bjoernsWifeEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.bjoernsWife(), MapData.evening, MapData.morning, gg_rct_waypoint_bjoern_0)

			// Osman
			set thistype.m_osmanLeavesHouse = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.osman(), MapData.morning, MapData.morning, gg_rct_waypoint_osman_3)
			set thistype.m_osmanPrays0 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.osman(), MapData.morning, 13.0, gg_rct_waypoint_osman_0)
			call thistype.m_osmanPrays0.setFacing(180.22)
			set thistype.m_osmanStandsNearDuke = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.osman(), 13.0, 16.0, gg_rct_waypoint_osman_2) // steht bei Herzog
			call thistype.m_osmanStandsNearDuke.setFacing(154.47)
			set thistype.m_osmanPrays1 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.osman(), 16.0, MapData.evening, gg_rct_waypoint_osman_0)
			call thistype.m_osmanPrays1.setFacing(180.22)
			set thistype.m_osmanEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.osman(), MapData.evening, MapData.morning, gg_rct_waypoint_osman_3)

			// Ferdinand
			set thistype.m_ferdinandLeavesHouse = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.ferdinand(), MapData.morning, MapData.morning, gg_rct_waypoint_ferdinand_0)
			set thistype.m_ferdinandStandsInCastle = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.ferdinand(), MapData.morning, 13.00, gg_rct_waypoint_ferdinand_1)
			call thistype.m_ferdinandStandsInCastle.setFacing(191.10)
			set thistype.m_ferdinandTalksToHeimrich = NpcTalksRoutine.create(Routines.talk(), Npcs.ferdinand(), 13.00, MapData.evening, gg_rct_waypoint_ferdinand_2)
			call thistype.m_ferdinandTalksToHeimrich.setPartner(Npcs.heimrich())
			set thistype.m_ferdinandEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.ferdinand(), MapData.evening, MapData.morning, gg_rct_waypoint_ferdinand_0)

			// Heimrich
			set thistype.m_heimrichLeavesHouse = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.heimrich(), MapData.morning, MapData.morning, gg_rct_waypoint_heimrich_0)
			set thistype.m_heimrichTalksToMarkward = NpcTalksRoutine.create(Routines.talk(), Npcs.heimrich(), MapData.morning, 13.00, gg_rct_waypoint_heimrich_1)
			call thistype.m_heimrichTalksToMarkward.setPartner(Npcs.markward())
			set thistype.m_heimrichTalksToFerdinand = NpcTalksRoutine.create(Routines.talk(), Npcs.heimrich(), 13.00, MapData.evening, gg_rct_waypoint_heimrich_1)
			call thistype.m_heimrichTalksToFerdinand.setPartner(Npcs.ferdinand())
			set thistype.m_heimrichEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.heimrich(), MapData.evening, MapData.morning, gg_rct_waypoint_heimrich_0)

			// Markward
			set thistype.m_markwardLeavesHouse = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.markward(), MapData.morning, MapData.morning, gg_rct_waypoint_markward_0)
			set thistype.m_markwardTalksToHeimrich = NpcTalksRoutine.create(Routines.talk(), Npcs.markward(), MapData.morning, 13.00, gg_rct_waypoint_markward_1)
			call thistype.m_ferdinandTalksToHeimrich.setPartner(Npcs.heimrich())
			set thistype.m_markwardStandsInCastle = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.markward(), 13.00, MapData.evening, gg_rct_waypoint_markward_1)
			call thistype.m_markwardStandsInCastle.setFacing(248.05)
			set thistype.m_markwardEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.markward(), MapData.evening, MapData.morning, gg_rct_waypoint_markward_0)

			// Trommon (Fährmann)
			//call Routines.moveTo().addUnitTime(gg_unit_n021_0004, 12.0, 19.0, gg_rct_ferry_boat_forward_terrain) /// @todo Check on which river side Trommon is!
			//call Routines.moveTo().addUnitTime(gg_unit_n021_0004, 19.0, 12.0, gg_rct_ferry_boat_backward_terrain) /// @todo Check on which river side Trommon is!

			// Wieland
			set thistype.m_wielandLeavesHouse = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.wieland(), MapData.morning, MapData.morning, gg_rct_waypoint_wieland_3)
			set thistype.m_wielandHammers = NpcRoutineWithFacing.create(Routines.hammer(), Npcs.wieland(), MapData.morning, 13.00, gg_rct_waypoint_wieland_0)
			call thistype.m_wielandHammers.setFacing(90.0)
			set thistype.m_wielandTalks = NpcTalksRoutine.create(Routines.talk(), Npcs.wieland(), 13.00, 14.00, gg_rct_waypoint_wieland_1)
			call thistype.m_wielandTalks.setPartner(Npcs.einar())
			set thistype.m_wielandDrinks = NpcRoutineWithFacing.create(Routines.drink(), Npcs.wieland(), 14.00, MapData.evening, gg_rct_waypoint_wieland_2)
			set thistype.m_wielandEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.wieland(), 22.00, MapData.morning, gg_rct_waypoint_wieland_3)

			// Mathilda
			set thistype.m_mathildaLeavesHouse = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.mathilda(), MapData.morning, MapData.morning, gg_rct_waypoint_mathilda_1)
			set thistype.m_mathildaMovesTo0 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.mathilda(), MapData.morning, 13.00, gg_rct_waypoint_mathilda_0)
			call thistype.m_mathildaMovesTo0.setFacing(74.69)
			set thistype.m_mathildaTalks = NpcTalksRoutine.create(Routines.talk(), Npcs.mathilda(), 13.00, 16.00, gg_rct_waypoint_mathilda_0)
			call thistype.m_mathildaTalks.setPartner(Npcs.lothar())
			set thistype.m_mathildaMovesTo1 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.mathilda(), 16.00, MapData.evening, gg_rct_waypoint_mathilda_0)
			call thistype.m_mathildaMovesTo1.setFacing(74.69)
			set thistype.m_mathildaEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.mathilda(), MapData.evening, MapData.morning, gg_rct_waypoint_mathilda_1)

			// Lothar
			set thistype.m_lotharLeavesHouse = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.lothar(), MapData.morning, MapData.morning, gg_rct_waypoint_lothar_2)
			set thistype.m_lotharSells0 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.lothar(), MapData.morning, 13.00, gg_rct_waypoint_lothar_0)
			call thistype.m_lotharSells0.setFacing(93.32)
			set thistype.m_lotharFlirtsWithMathilda = NpcTalksRoutine.create(Routines.talk(), Npcs.lothar(), 13.00, 16.00, gg_rct_waypoint_lothar_1)
			call thistype.m_lotharFlirtsWithMathilda.setPartner(Npcs.mathilda())
			set thistype.m_lotharSells1 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.lothar(), 16.00, MapData.evening, gg_rct_waypoint_lothar_0)
			call thistype.m_lotharSells1.setFacing(93.32)
			set thistype.m_lotharEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.lothar(), MapData.evening, MapData.morning, gg_rct_waypoint_lothar_2)

			// Irmina
			set thistype.m_irminaLeavesHouse0 = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.irmina(), MapData.morning, MapData.morning, gg_rct_waypoint_irmina_0) // wake up
			set thistype.m_irminaMovesTo0 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.irmina(), MapData.morning, MapData.morning, gg_rct_waypoint_irmina_1) // sell
			call thistype.m_irminaMovesTo0.setFacing(16.01)
			set thistype.m_irminaEntersHouse0 = AUnitRoutine.create(Routines.enterHouse(), Npcs.irmina(), MapData.afternoon, 17.0, gg_rct_waypoint_irmina_0) // sleep
			set thistype.m_irminaLeavesHouse1 = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.irmina(), 17.00, MapData.evening, gg_rct_waypoint_irmina_0) // wake up
			set thistype.m_irminaMovesTo1 = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.irmina(), 17.00, MapData.evening, gg_rct_waypoint_irmina_1) // sell
			call thistype.m_irminaMovesTo1.setFacing(16.01)
			set thistype.m_irminaEntersHouse1 = AUnitRoutine.create(Routines.enterHouse(), Npcs.irmina(), MapData.evening, MapData.morning, gg_rct_waypoint_irmina_0) // sleep

			// Einar
			set thistype.m_einarLeavesHouse = NpcLeavesHouseRoutine.create(Routines.leaveHouse(), Npcs.einar(), MapData.morning, MapData.morning, gg_rct_waypoint_einar_0) // wake up
			set thistype.m_einarSells = NpcRoutineWithFacing.create(Routines.moveTo(), Npcs.einar(), MapData.morning, 13.00, gg_rct_waypoint_einar_1) // sell
			call thistype.m_einarSells.setFacing(35.83)
			set thistype.m_einarTalks = NpcTalksRoutine.create(Routines.talk(), Npcs.einar(), 13.00, 14.00, gg_rct_waypoint_einar_1) // talk to Wieland
			call thistype.m_einarTalks.setPartner(Npcs.wieland())
			set thistype.m_einarDrinks = NpcRoutineWithFacing.create(Routines.drink(), Npcs.einar(), 14.00, MapData.evening, gg_rct_waypoint_einar_2) // drinks with Wieland in tavern
			set thistype.m_einarEntersHouse = AUnitRoutine.create(Routines.enterHouse(), Npcs.einar(), MapData.evening, MapData.morning, gg_rct_waypoint_einar_0) // sleep

			// menials
			call NpcRoutineWithFacing.create(Routines.harvest(), gg_unit_n02J_0013, MapData.morning, MapData.evening, gg_rct_waypoint_menial_0)
			call NpcRoutineWithFacing.create(Routines.harvest(), gg_unit_n02J_0157, MapData.morning, MapData.evening, gg_rct_waypoint_menial_1)
			call NpcRoutineWithFacing.create(Routines.harvest(), gg_unit_n02J_0159, MapData.morning, MapData.evening, gg_rct_waypoint_menial_2)
			call NpcRoutineWithFacing.create(Routines.harvest(), gg_unit_n02J_0158, MapData.morning, MapData.evening, gg_rct_waypoint_menial_3)
		endmethod

		// NOTE manual start ALL!
		public static method manualStart takes nothing returns nothing
			call AUnitRoutine.manualStart(Npcs.wigberht())
			call AUnitRoutine.manualStart(Npcs.sisgard())
			call AUnitRoutine.manualStart(Npcs.agihard())
			call AUnitRoutine.manualStart(Npcs.bjoern())
			call AUnitRoutine.manualStart(Npcs.bjoernsWife())
			call AUnitRoutine.manualStart(Npcs.osman())
			call AUnitRoutine.manualStart(Npcs.ferdinand())
			call AUnitRoutine.manualStart(Npcs.heimrich())
			call AUnitRoutine.manualStart(Npcs.markward())
			call AUnitRoutine.manualStart(Npcs.wieland())
			call AUnitRoutine.manualStart(Npcs.irmina())
			call AUnitRoutine.manualStart(Npcs.einar())
			call AUnitRoutine.manualStart(Npcs.mathilda())
			call AUnitRoutine.manualStart(Npcs.lothar())
			call AUnitRoutine.manualStart(gg_unit_n02J_0013)
			call AUnitRoutine.manualStart(gg_unit_n02J_0157)
			call AUnitRoutine.manualStart(gg_unit_n02J_0159)
			call AUnitRoutine.manualStart(gg_unit_n02J_0158)
		endmethod
	endstruct

endlibrary