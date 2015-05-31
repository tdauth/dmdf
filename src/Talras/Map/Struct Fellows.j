library StructMapMapFellows requires StructGameFellow, StructMapMapNpcs, StructMapMapShrines

	struct Fellows
		private static Fellow m_dago
		private static Fellow m_sisgard
		private static Fellow m_mathilda
		private static Fellow m_wigberht
		private static Fellow m_ricman
		private static Fellow m_dragonSlayer

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		public static method init takes nothing returns nothing
			debug call Print("Before dago")
			set thistype.m_dago = Fellow.create(Npcs.dago(), 0)
			call thistype.m_dago.setTalk(false)
			call thistype.m_dago.setRevival(false)
			call thistype.m_dago.setDescription(tr("Dago ist ein einfacher Jäger."))

			debug call Print("Before sisgard")
			set thistype.m_sisgard = Fellow.create(Npcs.sisgard(), TalkSisgard.talk.evaluate())
			/// @todo Set revival location to Talras
			call thistype.m_sisgard.setTalk(true)
			call thistype.m_sisgard.setRevival(true)
			call thistype.m_sisgard.setDescription(tr("Sisgard ist eine erfahrene Zauberin. Sie kann die Zauber TODO wirken usw."))
			call thistype.m_sisgard.setRevivalMessage(tr("Lasst uns ein paar Zauber wirken!"))
			call thistype.m_sisgard.setRevivalSound(null) /// \todo FIXME
			call thistype.m_sisgard.setRevivalTime(20.0)

			set thistype.m_mathilda = Fellow.create(Npcs.mathilda(), TalkMathilda.talk.evaluate())
			/// @todo Set revival location to farm

			set thistype.m_wigberht = Fellow.create(Npcs.wigberht(), TalkWigberht.talk.evaluate())
			call thistype.m_wigberht.setTalk(false)
			call thistype.m_wigberht.setRevival(true)
			call thistype.m_wigberht.setDescription(tr("Wigberht ist bla"))
			call thistype.m_wigberht.setRevivalMessage(tr("Vorwärts!"))
			call thistype.m_wigberht.setRevivalSound(null) /// \todo FIXME
			call thistype.m_wigberht.setRevivalTime(20.0)

			set thistype.m_ricman = Fellow.create(Npcs.ricman(), TalkRicman.talk.evaluate())
			call thistype.m_ricman.setTalk(false)
			call thistype.m_ricman.setRevival(true)
			call thistype.m_ricman.setDescription(tr("Ricman ist bla"))
			call thistype.m_ricman.setRevivalMessage(tr("Ihr Hundesöhne, mich besiegt man nicht so leicht!"))
			call thistype.m_ricman.setRevivalSound(null) /// \todo FIXME
			call thistype.m_ricman.setRevivalTime(20.0)

			// talk is created after the quest
			set thistype.m_dragonSlayer = Fellow.create(Npcs.dragonSlayer(), 0)
			call thistype.m_dragonSlayer.setTalk(false)
			call thistype.m_dragonSlayer.setRevival(true)
			call thistype.m_dragonSlayer.setRevivalSound(null) /// \todo FIXME
			call thistype.m_dragonSlayer.setRevivalTime(20.0)
		endmethod

		public static method dago takes nothing returns Fellow
			return thistype.m_dago
		endmethod

		public static method sisgard takes nothing returns Fellow
			return thistype.m_sisgard
		endmethod

		public static method mathilda takes nothing returns Fellow
			return thistype.m_mathilda
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