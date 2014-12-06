library StructMapTalksTalkMarkward requires Asl, StructMapMapNpcs, StructMapQuestsQuestTheNorsemen

	struct TalkMarkward extends ATalk

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			if (not this.showInfo(0, character)) then
				call this.showRange(1, 4, character)
			endif
		endmethod

		// (Automatisch)
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Gegrüßt seist du! Ich hoffe du und deine Leute, ihr benehmt euch anständig in der Burg und gegenüber dem Herzog, nun, da ihr ihm immerhin eure Treue geschworen habt."), null)
			call speech(info, character, false, tr("Sicher."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Wie ist die Lage?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wie ist die Lage?"), null)
			// (Auftrag „Die Nordmänner“ ist aktiv)
			if (QuestTheNorsemen.quest().isNew()) then
				call speech(info, character, true, tr("Heikel. Ihr solltet die Nordmänner um Unterstützung bitten, damit wir alle wieder ruhiger schlafen können."), null)
			// (Auftrag „Die Nordmänner“ ist abgeschlossen)
			else
				call speech(info, character, true, tr("Besser. Wenn ihr Verstärkung aus Holzbruck herbeischaffen könnt, haben wir eine echte Chance und durch den Sieg der Nordmänner über die Dunkelefen und Orks, haben wir zunächst etwas Ruhe und Zeit, um uns auf weitere Gefechte vorzubereiten."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// Woher kommst du?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Woher kommst du?"), null)
			call speech(info, character, true, tr("Meine Burg befindet sich südwestlich von hier. Sie ist selbstverständlich kleiner als diese, aber macht auch Einiges her."), null)
			call speech(info, character, true, tr("Wie auch der Herzog, habe ich mein Lehen von meinem Vater geerbt. Mir unterstehen einige Knechte, Bauern und Leibeigene. Meine Besitztümer …"), null)
			call speech(info, character, false, tr("Schon gut."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Was genau machst du hier?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was genau machst du hier?"), null)
			call speech(info, character, true, tr("Ich unterstütze den Herzog so gut ich kann bei seinem Kampf gegen den Feind. Wenn es nach mir ginge, müsste hier eine ganze Schar von Rittern stehen, aber die scheinen dieser Tage wohl etwas Besseres mit ihrer Zeit anfangen zu wissen."), null)
			call speech(info, character, true, tr("Vermutlich kümmern sie sich um ihre eigenen Ländereien und sind viel zu feige, dem Feind an der Front ins Auge zu blicken."), null)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.markward(), thistype.startPageAction)

			// start page
			call this.addInfo(false, true, 0, thistype.infoAction0, null) // 0
			call this.addInfo(true, false, 0, thistype.infoAction1, tr("Wie ist die Lage?")) // 1
			call this.addInfo(false, false, 0, thistype.infoAction2, tr("Woher kommst du?")) // 2
			call this.addInfo(false, false, 0, thistype.infoAction3, tr("Was genau machst du hier?")) // 3
			call this.addExitButton() // 4

			return this
		endmethod
	endstruct

endlibrary