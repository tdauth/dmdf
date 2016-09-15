library StructMapMapFellows requires StructGameFellow, StructMapMapNpcs, StructMapMapShrines

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
			set thistype.m_wigberht = Fellow.create(Npcs.wigberht(), 0)
			call thistype.m_wigberht.setTalk(false)
			call thistype.m_wigberht.setRevival(true)
			call thistype.m_wigberht.setDescription(tre("Wigberht ist der Prinz der Nordmänner. Er ist ein starker Nahkämpfer und besitzt die Fähigkeiten 'Ruf des Nordens', 'Unbeugsamkeit' und 'Rundumhieb'.", "Wigberht is the prince of the Norsemen. He is a strong melee fighter and has the abilities 'Call of the North', 'Rigidity' and 'All round blow'." ))
			call thistype.m_wigberht.setRevivalTitle(tre("Wigberht", "Wigberht"))
			call thistype.m_wigberht.setRevivalMessage(tre("Vorwärts!", "Forward!"))
			call thistype.m_wigberht.setRevivalSound(null) /// \todo FIXME
			call thistype.m_wigberht.setRevivalTime(MapData.revivalTime)
			call thistype.m_wigberht.addAbility('A0N5')
			call thistype.m_wigberht.addAbility('A05F')
			call thistype.m_wigberht.addAbility('A05I')

			set thistype.m_ricman = Fellow.create(Npcs.ricman(), 0)
			call thistype.m_ricman.setTalk(false)
			call thistype.m_ricman.setRevival(true)
			call thistype.m_ricman.setDescription(tre("Ricman ist die rechte Hand von Wigberht. Er ist ein starker Nahkämpfer und besitzt die Fähigkeiten 'Loyalität', 'Sturmschlag' und 'Schildblock'.", "Ricman is the right hand of Wigberht. He is a strong melee fighter and has the abilities 'Loyalty', 'Storm bolt' and 'Shield Block'."))
			call thistype.m_ricman.setRevivalTitle(tre("Ricman", "Ricman"))
			call thistype.m_ricman.setRevivalMessage(tre("Ihr Hundesöhne, mich besiegt man nicht so leicht!", "You bastards, you do not defeat me that easy!"))
			call thistype.m_ricman.setRevivalSound(null) /// \todo FIXME
			call thistype.m_ricman.setRevivalTime(MapData.revivalTime)
			call thistype.m_ricman.addAbility('A19M')
			call thistype.m_ricman.addAbility('A05G')
			call thistype.m_ricman.addAbility('A05J')

			// talk is created after the quest
			set thistype.m_dragonSlayer = Fellow.create(Npcs.dragonSlayer(), 0)
			call thistype.m_dragonSlayer.setTalk(false)
			call thistype.m_dragonSlayer.setRevivalTitle(tre("Drachentöterin", "Dragon Slayer"))
			call thistype.m_dragonSlayer.setRevivalMessage(tre("Für das Königreich der Hochelfen!", "For the kingdom of the high elves!"))
			call thistype.m_dragonSlayer.setRevival(true)
			call thistype.m_dragonSlayer.setRevivalSound(null) /// \todo FIXME
			call thistype.m_dragonSlayer.setRevivalTime(MapData.revivalTime)
			call thistype.m_dragonSlayer.addAbility('A18T')
			call thistype.m_dragonSlayer.addAbility('A0PW')
			call thistype.m_dragonSlayer.addAbility('A09P')
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