library StructMapMapDungeons requires Asl, StructGameDungeon

	struct Dungeons
		private static Dungeon m_dornheim
		private static Dungeon m_ralphsHouse

		public static method init takes nothing returns nothing
			set thistype.m_dornheim = Dungeon.create(tre("Dornheim", "Dornheim"), gg_rct_area_playable, gg_rct_area_playable)
			call thistype.m_dornheim.setEnterTrigger(true)
			set thistype.m_ralphsHouse = Dungeon.create(tre("Ralphs Haus", "Ralph's House"), gg_rct_ralphs_house, gg_rct_ralphs_house)
			call thistype.m_ralphsHouse.setEnterTrigger(true)
		endmethod

		public static method addSpellbookAbilities takes nothing returns nothing
			//call DungeonSpellbook.addDungeonToAll('A1U0', 'A1U3', thistype.m_dornheim)
		endmethod

		public static method dornheim takes nothing returns Dungeon
			return thistype.m_dornheim
		endmethod
	endstruct

endlibrary