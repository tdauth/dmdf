library StructMapMapFellows requires StructGameFellow, StructMapMapNpcs, StructMapMapShrines

	struct Fellows
		private static Fellow m_dago
		private static Fellow m_sisgard
		private static Fellow m_mathilda
		private static Fellow m_wigberht
		private static Fellow m_ricman
		private static Fellow m_dragonSlayer
		private static Fellow m_dararos

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
			call thistype.m_dago.setRevivalTitle(tre("Dago", "Dago"))
			call thistype.m_dago.setDescription(tre("Dago ist ein einfacher Jäger.", "Dago is a simple hunter."))

			debug call Print("Before sisgard")
			set thistype.m_sisgard = Fellow.create(Npcs.sisgard(), TalkSisgard.talk.evaluate())
			/// @todo Set revival location to Talras
			call thistype.m_sisgard.setTalk(true)
			call thistype.m_sisgard.setRevival(true)
			call thistype.m_sisgard.setDescription(tre("Sisgard ist eine erfahrene Zauberin. Sie kann die Zauber 'Teleportation' und 'Magie aufheben' wirken.", "Sisgard is an experienced sorceress. She can cast the spells 'Teleportation' and 'Ban Magic'."))
			call thistype.m_sisgard.setRevivalTitle(tre("Sisgard", "Sisgard"))
			call thistype.m_sisgard.setRevivalMessage(tre("Lasst uns ein paar Zauber wirken!", "Let us cast some spells!"))
			call thistype.m_sisgard.setRevivalSound(gg_snd_SisgardRevival)
			call thistype.m_sisgard.addAbility('A0PY')
			call thistype.m_sisgard.addAbility('A0QY')

			set thistype.m_mathilda = Fellow.create(Npcs.mathilda(), TalkMathilda.talk.evaluate())
			call thistype.m_mathilda.setTalk(true)
			call thistype.m_mathilda.setRevival(true)
			call thistype.m_mathilda.setRevivalTitle(tre("Mathilda", "Mathilda"))
			call thistype.m_mathilda.setDescription(tre("Mathilda ist eine Vagabundin. Sie kann singen und musizieren, sonst nichts.", "Mathilda is a vagabond. She can sing and make music, nothing else."))

			set thistype.m_wigberht = NpcFellows.createWigberht(Npcs.wigberht(), TalkWigberht.talk.evaluate())
			set thistype.m_ricman =  NpcFellows.createRicman(Npcs.ricman(), TalkRicman.talk.evaluate())
			// talk is created after the quest
			set thistype.m_dragonSlayer = NpcFellows.createDragonSlayer(Npcs.dragonSlayer(), 0)
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

		public static method dararos takes nothing returns Fellow
			return thistype.m_dararos
		endmethod

		public static method hideDragonSlayerInVideo takes AVideo video returns nothing
			local integer actorIndex = video.saveUnitActor(Npcs.dragonSlayer())
			call ShowUnit(video.unitActor(actorIndex), false)
			call PauseUnit(video.unitActor(actorIndex), true)
		endmethod

		public static method initDararos takes unit whichUnit returns nothing
			set thistype.m_dararos = Fellow.create(whichUnit, 0)
			call thistype.m_dararos.setTalk(false)
			call thistype.m_dararos.setRevivalTitle(tre("Dararos", "Dararos"))
			call thistype.m_dararos.setRevivalMessage(tre("Ich grüße Euch!", "I greet you!"))
			call thistype.m_dararos.setRevival(true)
			call thistype.m_dararos.setRevivalSound(null) /// \todo FIXME
			call thistype.m_dararos.addAbility('A1B2')
			call thistype.m_dararos.addAbility('A1B5')
			call thistype.m_dararos.addAbility('A1B3')
			call thistype.m_dararos.addAbility('A1B4')
		endmethod
	endstruct

endlibrary