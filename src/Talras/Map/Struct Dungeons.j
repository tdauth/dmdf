library StructMapMapDungeons requires Asl, StructGameDungeon

	struct Dungeons
		private static Dungeon m_talras
		private static Dungeon m_drumCave
		private static Dungeon m_crypt

		public static method init takes nothing returns nothing
			set thistype.m_talras = Dungeon.create(tre("Talras", "Talras"), gg_rct_area_playable, gg_rct_area_playable_view)
			set thistype.m_drumCave = Dungeon.create(tre("Trommelhöhle", "Drum Cave"), gg_rct_area_aos, gg_rct_area_aos_view)
			set thistype.m_crypt = Dungeon.create(tre("Gruft", "Crypt"), gg_rct_area_tomb, gg_rct_area_tomb_view)
		endmethod

		public static method addSpellbookAbilities takes nothing returns nothing
			call DungeonSpellbook.addDungeonToAll('A1U0', 'A1U3', thistype.m_talras)
			call DungeonSpellbook.addDungeonToAll('A1U1', 'A1U5', thistype.m_drumCave)
			call DungeonSpellbook.addDungeonToAll('A1U2', 'A1U4', thistype.m_crypt)
		endmethod

		public static method talras takes nothing returns Dungeon
			return thistype.m_talras
		endmethod

		public static method drumCave takes nothing returns Dungeon
			return thistype.m_drumCave
		endmethod

		public static method crypt takes nothing returns Dungeon
			return thistype.m_crypt
		endmethod
	endstruct

endlibrary