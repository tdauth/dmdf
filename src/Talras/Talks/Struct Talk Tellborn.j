library StructMapTalksTalkTellborn requires Asl

	struct TalkTellborn extends ATalk

		implement Talk

		private method startPageAction takes nothing returns nothing
			call this.showUntil(5)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Hallo."), null)
			call speech(info, true, tr("Hallo, werter Herr. Bist du auch auf der Durchreise oder was treibt dich in diese Gegend?"), null)
			call speech(info, false, tr("Durchreise?"), null)
			call speech(info, true, tr("Ja, mein Freund Fulco und ich sind auf dem Weg in den Süden, vielleicht auch Osten. Das wissen wir noch nicht so genau."), null)
			call speech(info, true, tr("Hier soll es ja bald zu Kämpfen kommen und da verziehen wir uns lieber."), null)
			call speech(info, true, tr("Meinen Freund Fulco hast du sicherlich schon bemerkt. Das ist der Bär da in der Ecke. Aber keine Angst, eigentlich ist er ein Mensch."), null)
			call speech(info, true, tr("Du musst wissen, mir ist da ein kleines Missgeschick passiert."), null)
			// (Fulco hats erzählt)
			if (true) then /// @todo FIXME
				call speech(info, false, tr("Ja, Fulco hat's mir schon erzählt."), null)
				call speech(info, true, tr("Dann weißt du ja Bescheid. Es tut mir wirklich schrecklich leid, das Ganze."), null)
			else
				call speech(info, false, tr("Missgeschick?"), null)
				call speech(info, true, tr("Ja, mein Freund bekam vor einigen Tagen Fieber und da ich ja selbst ein Schamane bin, wollte ich ihm natürlich dabei helfen, die Krankheit zu besiegen."), null)
				call speech(info, true, tr("Also habe ich einen Zauber auf ihn gesprochen, nur hat das dann irgendwie nicht so ganz geklappt und er verwandelte sich plötzlich in einen Bären."), null)
				call speech(info, true, tr("Das wollte ich wirklich nicht, das musst du mir glauben! Was sollen wir denn jetzt bloß tun? Am Ende wird er noch von einem Jäger erlegt."), null)
				/// @todo Charakter lacht/grinst
			endif
			call info.talk().showStartPage()
		endmethod

		// (Charakter hat vom Missgeschick erfahren)
		private static method infoCondition1 takes AInfo info returns boolean
			return true /// @todo FIXME
		endmethod

		// Kann ich dir irgendwie bei deinem Missgeschick helfen?
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Kann ich dir irgendwie bei deinem Missgeschick helfen?"), null)
			call speech(info, true, tr("Ja, das könntest du tatsächlich."), null)
			call speech(info, true, tr("Es gäbe da eine Möglichkeit, meinen Freund von dem bösen Zauber zu befreien. Ich bräuchte nur die richtigen Zutaten und ..."), null)
			call speech(info, true, tr("Pass auf, wenn du mir wirklich helfen willst, dann gebe ich dir eine Liste mit Zutaten. Falls du es schaffen solltest, mir die zu besorgen, werde ich dich reich belohnen!"), null)
			call info.talk().showRange(6, 7)
		endmethod

		// (Charakter hat alle Zutaten im Inventar)
		private static method infoCondition2 takes AInfo info returns boolean
			return true /// @todo FIXME
		endmethod

		// Hier hast du deine Zutaten.
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Hier hast du deine Zutaten."), null)
			/// @todo Zutaten geben
			call speech(info, true, tr("Danke! Du hast es tatsächlich geschafft. Ich bin begeistert. Leider fehlen mir doch noch ein paar weitere Zutaten, um den Trank brauen zu können, der meinen Freund zurückverwandelt."), null)
			call speech(info, true, tr("Aber es sollte kein Problem sein, die selbst zusammenzusuchen."), null)
			call speech(info, true, tr("Hier hast du deine Belohnung, hast sie dir wirklich verdient!"), null)
			call QuestMyFriendTheBear.characterQuest(info.talk().character()).complete()
			call info.talk().showStartPage()
		endmethod

		// Was trägst du da für eine Kleidung?
		private static method infoAction3 takes AInfo info returns nothing
			call speech(info, false, tr("Was trägst du da für eine Kleidung?"), null)
			call speech(info, true, tr("Das ist die Schamanentracht von uns Trollen und ich bin, wie dur denken kannst, Schamane."), null)
			call speech(info, true, tr("Also wenn du Zauber, Tränke oder Sonstiges brauchst: Ich handele auch gerne."), null)
			call info.talk().showStartPage()
		endmethod

		// (Charakter hat negative Zaubereffekte an sich)
		private static method infoCondition4 takes AInfo info returns boolean
			local unit characterUnit = info.talk().character().unit()
			local boolean result = UnitCountBuffsEx(characterUnit, true, false, true, false, false, false, false) > 0
			set characterUnit = null
			return result
		endmethod

		// Böse Geister plagen mich!
		private static method infoAction4 takes AInfo info returns nothing
			local unit npc = info.talk().unit()
			local unit characterUnit = info.talk().character().unit()
			call speech(info, false, tr("Böse Geister plagen mich!"), null)
			call SetUnitAnimation(npc, "Spell")
			call ResetUnitAnimation(npc)
			call speech(info, true, tr("Verschwindet ihr Geister und lasst diesen Körper frei!"), null)
			call UnitRemoveBuffsEx(characterUnit, false, true, true, false, false, false, false)
			set npc = null
			set characterUnit = null
			call info.talk().showStartPage()
		endmethod

		// Immer doch. Nur her mit der Liste!
		private static method infoAction1_0 takes AInfo info returns nothing
			local unit characterUnit = info.talk().character().unit()
			local item createdItem
			call speech(info, false, tr("Immer doch. Nur her mit der Liste!"), null)
			call speech(info, true, tr("Hier hast du sie."), null)
			set createdItem = UnitAddItemById(characterUnit, 'I00X')
			set characterUnit = null
			set createdItem = null
			call QuestMyFriendTheBear.characterQuest(info.talk().character()).enable()
			call info.talk().showStartPage()
		endmethod

		// Eigentlich gefällt mir dein Freund ganz gut, so wie er ist. Schön flauschig, der Bär.
		private static method infoAction1_1 takes AInfo info returns nothing
			call speech(info, false, tr("Eigentlich gefällt mir dein Freund ganz gut, so wie er ist. Schön flauschig, der Bär."), null)
			call speech(info, true, tr("Ja ja, mach dich nur über mich lustig!"), null)
			call info.talk().showStartPage()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.tellborn(), thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Kann ich dir irgendwie bei deinem Missgeschick helfen?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Hier hast du deine Zutaten.")) // 2
			call this.addInfo(false, false, 0, thistype.infoAction3, tr("Was trägst du da für eine Kleidung?")) // 3
			call this.addInfo(true, false, thistype.infoCondition4, thistype.infoAction4, tr("Böse Geister plagen mich!")) // 4
			call this.addExitButton() // 5

			// info 1
			call this.addInfo(false, false, 0, thistype.infoAction1_0, tr("Immer doch. Nur her mit der Liste!")) // 6
			call this.addInfo(false, false, 0, thistype.infoAction1_1, tr("Eigentlich gefällt mir dein Freund ganz gut, so wie er ist. Schön flauschig, der Bär.")) // 7

			return this
		endmethod
	endstruct

endlibrary