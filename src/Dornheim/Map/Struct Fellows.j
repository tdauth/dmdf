library StructMapMapFellows requires StructGameFellow, StructMapMapNpcs, StructMapMapShrines

	struct Fellows
		private static Fellow m_ralph

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_ralph = Fellow.create(Npcs.ralph(), 0)
			call thistype.m_ralph.setTalk(false)
			call thistype.m_ralph.setRevival(true)
			call thistype.m_ralph.setDescription(tre("Ralph ist euer bester Freund in Dornheim. Seit eurer Kindheit seid ihr nun schon Freunde.", "Ralph is your best friend in Dornheim. Since your childhood you are friends." ))
			call thistype.m_ralph.setRevivalTitle(tre("Ralph", "Ralph"))
			call thistype.m_ralph.setRevivalMessage(tre("Die frische Luft hier draußen tut mir gut!", "The fresh air outside is good for me!"))
			call thistype.m_ralph.setRevivalSound(null) /// \todo FIXME
			call thistype.m_ralph.setRevivalTime(MapData.revivalTime)
		endmethod

		public static method ralph takes nothing returns Fellow
			return thistype.m_ralph
		endmethod
	endstruct

endlibrary