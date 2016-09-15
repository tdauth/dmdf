library StructMapTalksTalkTellborn requires Asl, StructMapTalksTalkFulco, StructMapTalksTalkTanka, StructMapQuestsQuestShamansInTalras

	struct TalkTellborn extends Talk

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(7, character)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo, werter Herr. Bist du auch auf der Durchreise oder was treibt dich in diese Gegend?"), gg_snd_Tellborn1)
			call speech(info, character, false, tr("Durchreise?"), null)
			call speech(info, character, true, tr("Ja, mein Freund Fulco und ich sind auf dem Weg in den Süden, vielleicht auch Osten. Das wissen wir noch nicht so genau."), gg_snd_Tellborn2)
			call speech(info, character, true, tr("Hier soll es ja bald zu Kämpfen kommen und da verziehen wir uns lieber."), gg_snd_Tellborn3)
			call speech(info, character, true, tr("Meinen Freund Fulco hast du sicherlich schon bemerkt. Das ist der Bär da in der Ecke. Aber keine Angst, eigentlich ist er ein Mensch."), gg_snd_Tellborn4)
			call speech(info, character, true, tr("Du musst wissen, mir ist da ein kleines Missgeschick passiert."), gg_snd_Tellborn5)
			// (Fulco hats erzählt)
			if (TalkFulco.talk().infoHasBeenShownToCharacter(0, character)) then
				call speech(info, character, false, tr("Ja, Fulco hat's mir schon erzählt."), null)
				call speech(info, character, true, tr("Dann weißt du ja Bescheid. Es tut mir wirklich schrecklich leid, das Ganze."), gg_snd_Tellborn6)
			else
				call speech(info, character, false, tr("Missgeschick?"), null)
				call speech(info, character, true, tr("Ja, mein Freund bekam vor einigen Tagen Fieber und da ich ja selbst ein Schamane bin, wollte ich ihm natürlich dabei helfen, die Krankheit zu besiegen."), gg_snd_Tellborn7)
				call speech(info, character, true, tr("Also habe ich einen Zauber auf ihn gesprochen, nur hat das dann irgendwie nicht so ganz geklappt und er verwandelte sich plötzlich in einen Bären."), gg_snd_Tellborn8)
				call speech(info, character, true, tr("Das wollte ich wirklich nicht, das musst du mir glauben! Was sollen wir denn jetzt bloß tun? Am Ende wird er noch von einem Jäger erlegt."), gg_snd_Tellborn9)
				/// @todo Charakter lacht/grinst
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Kann ich dir irgendwie bei deinem Missgeschick helfen?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kann ich dir irgendwie bei deinem Missgeschick helfen?"), null)
			call speech(info, character, true, tr("Ja, das könntest du tatsächlich."), gg_snd_Tellborn10)
			call speech(info, character, true, tr("Es gäbe da eine Möglichkeit, meinen Freund von dem bösen Zauber zu befreien. Ich bräuchte nur die richtigen Zutaten und ..."), gg_snd_Tellborn11)
			call speech(info, character, true, tr("Pass auf, wenn du mir wirklich helfen willst, dann gebe ich dir eine Liste mit Zutaten. Falls du es schaffen solltest, mir die zu besorgen, werde ich dich reich belohnen!"), gg_snd_Tellborn12)
			call info.talk().showRange(8, 9, character)
		endmethod

		// (Auftrag „Mein Freund der Bär“ ist aktiv und Charakter hat alle Zutaten im Inventar)
		private static method infoCondition2 takes AInfo info, Character character returns boolean
			return QuestMyFriendTheBear.characterQuest(character).isNew() and character.inventory().hasItemType('I03F') and character.inventory().hasItemType('I03G') and character.inventory().hasItemType('I03H')
		endmethod

		// Hier hast du deine Zutaten.
		private static method infoAction2 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Hier hast du deine Zutaten."), gg_snd_Tellborn13)
			/// Zutaten geben
			call character.inventory().removeItemType('I03F')
			call character.inventory().removeItemType('I03G')
			call character.inventory().removeItemType('I03H')
			call speech(info, character, true, tr("Danke! Du hast es tatsächlich geschafft. Ich bin begeistert. Leider fehlen mir doch noch ein paar weitere Zutaten, um den Trank brauen zu können, der meinen Freund zurückverwandelt."), gg_snd_Tellborn15)
			call speech(info, character, true, tr("Aber es sollte kein Problem sein, die selbst zusammenzusuchen."), gg_snd_Tellborn16)
			call speech(info, character, true, tr("Hier hast du deine Belohnung, hast sie dir wirklich verdient!"), gg_snd_Tellborn17)
			call QuestMyFriendTheBear.characterQuest(character).complete()
			// 4 Spruchrollen der Geborgenheit
			call character.giveItem('I00U')
			call character.giveItem('I00U')
			call character.giveItem('I00U')
			call character.giveItem('I00U')
			// Tellborns Geisterrune
			call character.giveItem('I03I')
			call info.talk().showStartPage(character)
		endmethod

		// Was trägst du da für eine Kleidung?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was trägst du da für eine Kleidung?"), null)
			call speech(info, character, true, tr("Das ist die Schamanentracht von uns Trollen und ich bin, wie dur denken kannst, Schamane."), gg_snd_Tellborn18)
			call speech(info, character, true, tr("Also wenn du Zauber, Tränke oder Sonstiges brauchst: Ich handele auch gerne."), gg_snd_Tellborn19)
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat negative Zaubereffekte an sich)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			local unit characterUnit = character.unit()
			local boolean result = UnitCountBuffsEx(characterUnit, true, false, true, false, false, false, false) > 0
			set characterUnit = null
			return result
		endmethod

		// Böse Geister plagen mich!
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			local unit npc = info.talk().unit()
			local unit characterUnit = character.unit()
			call speech(info, character, false, tr("Böse Geister plagen mich!"), null)
			call SetUnitAnimation(npc, "Spell")
			call ResetUnitAnimation(npc)
			call speech(info, character, true, tr("Verschwindet ihr Geister und lasst diesen Körper frei!"), gg_snd_Tellborn20)
			call UnitRemoveBuffsEx(characterUnit, false, true, true, false, false, false, false)
			set npc = null
			set characterUnit = null
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Hallo“ und Charakter hat mit Tanka gesprochen und Auftrag „Schamanen in Talras“ noch nicht erhalten)
		private static method infoConditionYouKnowTanka takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character) and TalkTanka.talk().infoHasBeenShownToCharacter(0, character) and QuestShamansInTalras.characterQuest(character).isNotUsed()
		endmethod

		// Kennst du Tanka?
		private static method infoActionYouKnowTanka  takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kennst du Tanka?"), null)
			call speech(info, character, true, tr("Verzeihung, wen soll ich kennen?"), gg_snd_Tellborn21)
			call speech(info, character, false, tr("Tanka, eine Schamanin. Sie befindet sich weiter nördlich von hier und hat einen ähnlichen Freund wie du."), null)
			call speech(info, character, true, tr("Tanka … nein das sagt mir tatsächlich nichts. Du behauptest sie ist eine Schamanin? Sehr interessant … Ich muss sagen man trifft doch seltener auf unseresgleichen als man vielleicht annehmen würde."), gg_snd_Tellborn22)
			call speech(info, character, true, tr("Und sie hat auch einen Bären als Freund? Sehr merkwürdig …"), gg_snd_Tellborn23)
			call speech(info, character, false, tr("Sowas in der Art."), null)
			call speech(info, character, true, tr("Vielleicht sollte ich diese Chance nutzen. Es kann nie schaden das eigene Wissen zu erweitern und die Welt aus der Sicht einer anderen Person zu betrachten."), gg_snd_Tellborn24)
			call speech(info, character, true, tr("Sag wärst du bereit dieser Tanka einen Brief von mir zu bringen?"), gg_snd_Tellborn25)

			call info.talk().showRange(10, 11, character)
		endmethod

		// (Auftragsziel 2 des Auftrags „Schamanen in Talras“ ist aktiv und Charakter hat „Schreiben für Tellborn“ dabei)
		private static method infoConditionLetterFromTanka takes AInfo info, ACharacter character returns boolean
			return QuestShamansInTalras.characterQuest(character).questItem(1).isNew() and character.inventory().hasItemType('I03J')
		endmethod

		// Hier ist ein Schreiben von Tanka.
		private static method infoActionLetterFromTanka  takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Hier ist ein Schreiben von Tanka."), null)
			// (Charakter hat zuvor einen Brief an Tanka gebracht)
			if (QuestShamansInTalras.characterQuest(character).questItem(0).isCompleted()) then
				call speech(info, character, true, tr("Und, was hat sie gesagt?"), gg_snd_Tellborn30)
				call speech(info, character, false, tr("Nun lies doch einfach."), null)
				call speech(info, character, true, tr("Ich traue mich fast gar nicht. Na gut, gib her!"), gg_snd_Tellborn31)
				// „Schreiben für Tellborn“ übergeben
				call character.inventory().removeItemType('I03J')
				call speech(info, character, false, tr("Hier."), null)
				call speech(info, character, true, tr("Unglaublich! Ich freue mich wie ein kleines Kind darauf den Inhalt zu lesen. Hab vielen Dank, du hast mir einen großen Dienst erwiesen."), gg_snd_Tellborn32)
				call speech(info, character, true, tr("Hier nimm dies als Belohnung."), gg_snd_Tellborn33)
				// Auftrag „Schamanen in Talras“ abgeschlossen
				call QuestShamansInTalras.characterQuest(character).complete()
				// Tellborns Belohnung überreichen
				call character.giveItem('I00B')
				call character.giveItem('I00B')
				call character.giveItem('I00B')
				call character.giveItem('I00B')
				call character.giveItem('I00C')
				call character.giveItem('I00C')
				call character.giveItem('I00C')
				call character.giveItem('I00C')
				call character.giveItem('I03M')
			// (Charakter bringt einen Brief von Tanka mit ohne dass Tellborn einen Brief geschickt hat)
			else
				call speech(info, character, true, tr("Ein Schreiben von wem?"), gg_snd_Tellborn34)
				call speech(info, character, false, tr("Von Tanka, einer Schamanin nördlich von hier. Ich habe ihr von dir erzählt, da ihr beide Schamanen seid."), null)
				call speech(info, character, true, tr("Tatsächlich? Eine andere Schamanin hier in Talras? Das gibt es doch gar nicht. Nun rück schon raus mit dem Schreiben!"), gg_snd_Tellborn35)
				// „Schreiben für Tellborn“ übergeben
				call character.inventory().removeItemType('I03J')
				call speech(info, character, false, tr("Hier."), null)
				call speech(info, character, true, tr("(Liest) Faszinierend! Warte, ich werde ihr eine Antwort schreiben."), gg_snd_Tellborn36)
				call speech(info, character, true, tr("(Schreibt einen Brief)"), null)
				call speech(info, character, true, tr("Hier hast du den Brief und verliere ihn bloß nicht! Hoffentlich werde ich sie damit nicht verärgern."), gg_snd_Tellborn37)
				// „Brief an Tanka“ erhalten
				call character.giveQuestItem('I03K')
				// Auftragsziel 2 des Auftrags „Schamanen in Talras“ abgeschlossen
				call QuestShamansInTalras.characterQuest(character).questItem(1).complete()
				// Auftragsziel 1 des Auftrags „Schamanen in Talras“ aktiviert
				call QuestShamansInTalras.characterQuest(character).questItem(0).enable()
			endif

			call info.talk().showStartPage(character)
		endmethod

		// Immer doch. Nur her mit der Liste!
		private static method infoAction1_0 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Immer doch. Nur her mit der Liste!"), null)
			call speech(info, character, true, tr("Hier hast du sie."), null)
			call character.giveQuestItem('I00X')
			call QuestMyFriendTheBear.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Eigentlich gefällt mir dein Freund ganz gut, so wie er ist. Schön flauschig, der Bär.
		private static method infoAction1_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Eigentlich gefällt mir dein Freund ganz gut, so wie er ist. Schön flauschig, der Bär."), null)
			call speech(info, character, true, tr("Ja ja, mach dich nur über mich lustig!"), gg_snd_Tellborn14)
			call info.talk().showStartPage(character)
		endmethod

		// Klar.
		private static method infoActionYouKnowTanka_Sure takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Klar."), null)
			call speech(info, character, true, tr("Beim Felle meines behaarten Freundes! Hab vielen Dank dafür, ich werde dich natürlich auch entsprechend belohnen."), gg_snd_Tellborn26)
			call speech(info, character, false, tr("Der Brief …"), null)
			call speech(info, character, true, tr("Aber natürlich, warte einen kurzen Moment."), gg_snd_Tellborn27)
			call speech(info, character, true, tr("(Schreibt einen Brief)"), null)
			call speech(info, character, true, tr("Da hast du ihn. Ich hoffe ich habe den richtigen Ton gewählt."), gg_snd_Tellborn28)
			// Neuer Auftrag „Schamanen in Talras“
			call QuestShamansInTalras.characterQuest(character).enable()
			// Auftragsziel 1 aktiviert
			call QuestShamansInTalras.characterQuest(character).questItem(0).enable()
			// „Brief an Tanka“ erhalten
			call character.giveQuestItem('I03K')
			call info.talk().showStartPage(character)
		endmethod

		// Nein.
		private static method infoActionYouKnowTanka_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Nein."), null)
			call speech(info, character, true, tr("Schade, vielleicht überlegst du es dir noch mal."), gg_snd_Tellborn29)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.tellborn(), thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Kann ich dir irgendwie bei deinem Missgeschick helfen?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Hier hast du deine Zutaten.")) // 2
			call this.addInfo(false, false, 0, thistype.infoAction3, tr("Was trägst du da für eine Kleidung?")) // 3
			call this.addInfo(true, false, thistype.infoCondition4, thistype.infoAction4, tr("Böse Geister plagen mich!")) // 4
			call this.addInfo(true, false, thistype.infoConditionYouKnowTanka, thistype.infoActionYouKnowTanka, tr("Kennst du Tanka?")) // 5
			call this.addInfo(false, false, thistype.infoConditionLetterFromTanka, thistype.infoActionLetterFromTanka, tr("Hier ist ein Schreiben von Tanka.")) // 6
			call this.addExitButton() // 7

			// info 1
			call this.addInfo(false, false, 0, thistype.infoAction1_0, tr("Immer doch. Nur her mit der Liste!")) // 8
			call this.addInfo(false, false, 0, thistype.infoAction1_1, tr("Eigentlich gefällt mir dein Freund ganz gut, so wie er ist. Schön flauschig, der Bär.")) // 9

			// info 5
			call this.addInfo(true, false, 0, thistype.infoActionYouKnowTanka_Sure, tr("Klar.")) // 10
			call this.addInfo(true, false, 0, thistype.infoActionYouKnowTanka_No, tr("Nein.")) // 11

			return this
		endmethod
	endstruct

endlibrary