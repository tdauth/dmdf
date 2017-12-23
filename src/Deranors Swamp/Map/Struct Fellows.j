library StructMapMapFellows requires StructGameNpcFellows, StructMapMapNpcs, StructMapMapShrines

	struct Fellows
		private static Fellow m_wigberht
		private static Fellow m_ricman
		private static Fellow m_dragonSlayer

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_wigberht = NpcFellows.createWigberht(Npcs.wigberht(), 0)
			set thistype.m_ricman =  NpcFellows.createRicman(Npcs.ricman(), 0)
			set thistype.m_dragonSlayer = NpcFellows.createDragonSlayer(Npcs.dragonSlayer(), 0)
		endmethod

		public static method wigberht takes nothing returns Fellow
			return thistype.m_wigberht
		endmethod

		public static method ricman takes nothing returns Fellow
			return thistype.m_ricman
		endmethod

		public static method dragonSlayer takes nothing returns Fellow
			return thistype.m_dragonSlayer
		endmethod
	endstruct

endlibrary