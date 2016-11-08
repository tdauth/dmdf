library StructMapMapDungeons requires Asl, StructGameDungeon

	struct Dungeons
		private static Dungeon m_dornheim
		private static Dungeon m_wotansHouse
		private static Dungeon m_wotansSecondFloor
		private static Dungeon m_wotansBigHouse

		public static method init takes nothing returns nothing
			set thistype.m_dornheim = Dungeon.create(tre("Dornheim", "Dornheim"), gg_rct_area_playable, gg_rct_area_playable)
			call thistype.m_dornheim.setEnterTrigger(true)
			set thistype.m_wotansHouse = Dungeon.create(tre("Wotans Haus", "Wotan's House"), gg_rct_wotans_house, gg_rct_wotans_house)
			call thistype.m_wotansHouse.setEnterTrigger(true)
			call thistype.m_wotansHouse.setCameraSetup(gg_cam_wotans_house)
			set thistype.m_wotansSecondFloor = Dungeon.create(tre("Wotans Haus Zweiter Stock", "Wotan's House Second Floor"), gg_rct_wotans_house_second_floor, gg_rct_wotans_house_second_floor)
			call thistype.m_wotansSecondFloor.setEnterTrigger(true)
			call thistype.m_wotansSecondFloor.setCameraSetup(gg_cam_wotans_house_second_floor)

			set thistype.m_wotansBigHouse = Dungeon.create(tre("Wotans Dorfhalle", "Wotan's Village Hall"), gg_rct_wotans_big_house, gg_rct_wotans_big_house)
			call thistype.m_wotansBigHouse.setEnterTrigger(true)
			call thistype.m_wotansBigHouse.setCameraSetup(gg_cam_wotans_big_house)
		endmethod

		public static method addSpellbookAbilities takes nothing returns nothing
			//call DungeonSpellbook.addDungeonToAll('A1U0', 'A1U3', thistype.m_dornheim)
		endmethod

		public static method dornheim takes nothing returns Dungeon
			return thistype.m_dornheim
		endmethod
	endstruct

endlibrary