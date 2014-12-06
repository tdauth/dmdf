library StructMapTalksTalkLothar requires Asl, StructGameCharacter, StructMapMapNpcs, StructMapQuestsQuestABigPresent, StructMapQuestsQuestALittlePresent

	struct TalkLothar extends ATalk
		private boolean array m_saidTruth[6] /// \todo MapData.maxplayers

		implement Talk

		public method saidTruth takes Character character returns boolean
			return this.m_saidTruth[GetPlayerId(character.player())]
		endmethod

		private method sayTruth takes Character character returns nothing
			set this.m_saidTruth[GetPlayerId(character.player())] = true
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			if (not this.showInfo(0, character)) then
				call this.showRange(1, 9, character)
			endif
		endmethod

		// (Automatisch)
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Gegrüßt seist du, fremder Reisender! Kann ich dich vielleicht für einen leckeren Topf voll Honig von den glücklichsten Bienen im ganzen Königreich oder einen köstlichen Becher voll wunderbarem Wein begeistern?"), null)
			call speech(info, character, true, tr("Greif zu solange noch Ware da ist! Ich kann für nichts garantieren. Vielleicht kommt gleich ein anderer Interessierter, der dir alles vor der Nase wegschnappt."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Wer bist du?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wer bist du?"), null)
			call speech(info, character, true, tr("Mein Name ist Lothar und ich bin zweifellos der erfolgreichste Händler im ganzen Königreich und zudem noch der glücklichste."), null)
			call speech(info, character, true, tr("Ich verkaufe selbst hergestellten Wein und Honig. Die schönsten und genussvollsten Dinge des bescheidenen Lebens in dieser Welt!"), null)
			call info.talk().showRange(10, 13, character)
		endmethod

		// Woher kommst du?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Woher kommst du?"), null)
			call speech(info, character, true, tr("Ach, ähm, ja … es spielt doch keine Rolle woher wir kommen, vielmehr wohin wir gehen! Aber wenn du es unbedingt wissen willst, ich komme aus dem Südwesten des Königreichs."), null)
			call speech(info, character, true, tr("Vor vielen Jahren zog es mich nach Talras und zufälligerweise fehlte auf dem Bauernhof ein echter Händler, der geschickt seine Ware unters Volk bringt."), null)
			call speech(info, character, true, tr("Also zog ich in die Hütte des Totengräbers."), null)
			call speech(info, character, false, tr("Des Totengräbers?"), null)
			call speech(info, character, true, tr("Ähm, ja, ja des Totengräbers. Archibald war sein Name, wenn ich mich recht erinnere. Er war ein Mönch oder sowas und starb kurz bevor ich kam. Woran weiß ich nicht, ist mir auch egal."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Was hältst du vom Bauernhof?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was hältst du vom Bauernhof?"), null)
			call speech(info, character, true, tr("Wieso fragst du?"), null)
			call speech(info, character, true, tr("Dich schickt doch nicht etwa Manfred, oder Mathilda?"), null)
			call speech(info, character, true, tr("Mathilda … hat sie, nein das kann nicht sein! Oder doch?"), null)
			call speech(info, character, false, tr("Was?"), null)
			call speech(info, character, true, tr("Mein Herz gehört ihr, auf ewig! Aber ich werde es ihr niemals sagen können …"), null)
			call speech(info, character, true, tr("Du bist doch sicher mutig?"), null)
			call speech(info, character, false, tr("Also …"), null)
			call speech(info, character, true, tr("Bitte, du musst mir einen Gefallen tun! Gib ihr diesen Topf mit meinem besten Honig als Zeichen meiner Liebe. Sag ihr aber auf keinen Fall von wem er ist!"), null)
			call speech(info, character, false, tr("Ähm, du bist der einzige Imker auf dem …"), null)
			call speech(info, character, true, tr("Bitte!"), null)
			call info.talk().showRange(14, 16, character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Ein kleines Geschenk“ ist abgeschlossen, Auftrag ist noch aktiv)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return QuestALittlePresent.characterQuest(character).questItem(0).isCompleted() and QuestALittlePresent(QuestTheBeast.characterQuest(character)).isNew()
		endmethod

		// Ich habe Mathilda deinen Honigtopf gegeben.
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich habe Mathilda deinen Honigtopf gegeben."), null)

			call speech(info, character, true, tr("Danke, mein Freund! Wie hat sie reagiert? War sie erfreut, entzückt?"), null)
			call speech(info, character, false, tr("Na ja …"), null)
			// Auftrag „Ein kleines Geschenk“ abgeschlossen
			call QuestALittlePresent.characterQuest(character).complete()
			call speech(info, character, true, tr("Oh nein, ich habe es geahnt! Ich muss mir einfach mehr Mühe geben. Hier. Überreiche ihr diesen großen Honigtopf. Das muss ihr einfach gefallen."), null)

			call info.talk().showRange(17, 19, character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Ein großes Geschenk“ ist abgeschlossen, Auftrag ist noch aktiv)
		private static method infoCondition5 takes AInfo info, ACharacter character returns boolean
			return QuestABigPresent.characterQuest(character).questItem(0).isCompleted() and QuestABigPresent.characterQuest(character).isNew()
		endmethod

		// Ich habe Mathilda deinen großen Honigtopf gegeben.
		private static method infoAction5 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich habe Mathilda deinen großen Honigtopf gegeben."), null)
			call speech(info, character, true, tr("Hat sie sich diesmal wenigstens gefreut?"), null)
			call speech(info, character, false, tr("Na ja …"), null)
			// Auftrag „Ein großes Geschenk“ abgeschlossen
			call QuestABigPresent.characterQuest(character).complete()
			call speech(info, character, true, tr("Nun sag schon!"), null)
			call info.talk().showRange(20, 22, character)
		endmethod

		// Wie läuft das Geschäft?
		private static method infoAction6 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wie läuft das Geschäft?"), null)
			call speech(info, character, true, tr("Sehr gut, sehr gut, danke der Nachfrage! Also …"), null)
			call speech(info, character, false, tr("Also was?"), null)
			call speech(info, character, true, tr("Na ja, da ist so eine Sache …"), null)
			call speech(info, character, false, tr("Spucks aus!"), null)
			call speech(info, character, true, tr("Also, es geht um meine Weinreben, oben auf dem Mühlberg, wo auch der Müller Guntrich seine Mühle stehen hat. Vor einer Weile hat er mir von diesem Trommeln im Berg erzählt."), null)
			call speech(info, character, true, tr("Als kämpfe ein ganzes Heer gegen ein anderes, hat er gesagt. Ich bin sicher kein Feigling, aber jetzt traue selbst ich mich nicht mehr auf den Berg."), null)
			call speech(info, character, true, tr("So kann ich aber meine Trauben nicht pflücken und mir entgeht eine Menge Goldmünzen. Natürlich ist es vor allem zum Nachteil der armen Bauern, die keinen Wein mehr an ruhigen Abenden genießen können, diese Armen."), null)
			call speech(info, character, false, tr("Natürlich."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Wie läuft das Geschäft?“, Auftrag „Geisterstunde“ ist abgeschlossen)
		private static method infoCondition7 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(6, character) and QuestWitchingHour.characterQuest(character).isCompleted()
		endmethod

		// Du kannst wieder Trauben pflücken gehen.
		private static method infoAction7 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Du kannst wieder Trauben pflücken gehen."), null)
			call speech(info, character, true, tr("Wie bitte?"), null)
			call speech(info, character, false, tr("Da gibt es keine Geister. Ich habe nachgesehen."), null)
			call speech(info, character, true, tr("Bist du sicher? Aber ich dachte selbst, ich hätte mal die Trommeln gehört, als ich gerade bei der Arbeit war. Ich …"), null)
			call speech(info, character, false, tr("Da gibt es nichts, frag einfach Guntrich!"), null)
			call speech(info, character, true, tr("Na gut, ich vertraue dir mal. Hier hast du einen Topf mit feinstem Honig. Erzähl aber bitte keinem davon, vor allem nicht Mathilda!"), null)
			call speech(info, character, false, tr("Keine Sorge."), null)
			/// @todo FIXME
			// Charakter erhält einen Honigtopf
			// Charakter erhält einen Erfahrungsbonus
			call Character(character).xpBonus(50, tr("Geisterstunde"))
			call info.talk().showStartPage(character)
		endmethod

		// Was genau verkaufst du?
		private static method infoAction8 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was genau verkaufst du?"), null)
			call speech(info, character, true, tr("Wie ich es dir schon angeboten habe, Wein und Honig, aber auch andere Lebensmittel und Gebrauchsgegenstände. Aber sicher keinen Ramsch, sondern nur das Beste vom Besten!"), null)
			call speech(info, character, false, tr("Schon klar."), null)
			call speech(info, character, true, tr("Wissen kann ich dir leider nicht anbieten (sarkastisch). Dafür ist die alte Schreckschraube Ursula da (grinst)."), null)
			call speech(info, character, true, tr("Das ist so eine alte Hexe und Einsiedlerin, die im Süden ihre Grotte hat und glaubt, sie sei weise (lacht). Mich lässt schon der Gedanke an sie erschaudern."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Fettsack!
		private static method infoAction1_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Fettsack!"), null)
			call speech(info, character, true, tr("Was redest du da? Ist das etwa eine gebührliche Art, mit einem Fremden umzugehen?"), null)
			call info.talk().showStartPage(character)
		endmethod

		// Du laberst ganz schön viel.
		private static method infoAction1_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Du laberst ganz schön viel."), null)
			call speech(info, character, true, tr("Männer meines Standes müssen ihre Ware an den Mann bringen. Ich kann es mir nicht leisten, darauf zu warten, dass sich meine Ware von selbst verkauft."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Gib mir eine Kostprobe.
		private static method infoAction1_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Gib mir eine Kostprobe."), null)
			call speech(info, character, true, tr("Wie du wünschst, mein weiser Freund. Hier ist ein Krug voll köstlichem Wein, ganz umsonst für dich!"), null)
			// Charakter erhält einen Weinkrug
			/// @todo FIXME
			call info.talk().showStartPage(character)
		endmethod

		// Na gut.
		private static method infoAction3_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Na gut."), null)
			call speech(info, character, true, tr("Vielen Dank. Es wird nicht dein Schaden sein, ich werde dich selbstverständlich angemessen dafür entlohnen."), null)
			call speech(info, character, true, tr("Hier hast du den Honigtopf."), null)
			// Neuer Auftrag „Ein kleines Geschenk“
			call QuestALittlePresent.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Friss deinen Honig doch selbst, du dummer Fettsack!
		private static method infoAction3_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Friss deinen Honig doch selbst, du dummer Fettsack!"), null)
			call speech(info, character, true, tr("Was? Unerhört, dieses törichte Verhalten! Du solltest solange du hier bist besser gut auf dich aufpassen!"), null)
			call speech(info, character, false, tr("Willst du mich überrollen oder was?"), null)
			call speech(info, character, true, tr("Bitte, nimm doch etwas Rücksicht auf mich (schluchzt)!"), null)
			// Charakter erhält Erfahrungsbonus aufgrund seiner beleidigenden Art.
			call Character(character).xpBonus(50, tr("Beleidigungsbonus"))
			call info.talk().showStartPage(character)
		endmethod

		// Kein Interesse.
		private static method infoAction3_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kein Interesse."), null)
			call speech(info, character, true, tr("Zu schade. So wird sie es nie erfahren."), null)
			call info.talk().showStartPage(character)
		endmethod

		// In Ordnung.
		private static method infoAction4_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("In Ordnung."), null)
			call speech(info, character, true, tr("Gut. Vergiss aber nicht, meinen Namen nicht zu erwähnen!"), null)
			// Neuer Auftrag „Ein großes Geschenk“
			call QuestABigPresent.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Deine extreme Fettleibigkeit gefällt dagegen mir nicht!
		private static method infoAction4_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Deine extreme Fettleibigkeit gefällt dagegen mir nicht!"), null)
			call speech(info, character, true, tr("Wie kannst du es …"), null)
			call speech(info, character, false, tr("Du bist einfach fett und jetzt halt die Fresse! Du wirst nie bei ihr landen, niemals!"), null)
			call speech(info, character, true, tr("Bitte tritt nicht auf meine Träume (schluchzt)!"), null)
			// Charakter erhält Erfahrungsbonus aufgrund seiner beleidigenden Art.
			call Character(character).xpBonus(50, tr("Beleidigungsbonus.
			"))
			call info.talk().showStartPage(character)
		endmethod

		// Wie wärs eigentlich mal mit Blumen oder einem netten Gespräch?
		private static method infoAction4_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wie wärs eigentlich mal mit Blumen oder einem netten Gespräch?"), null)
			call speech(info, character, true, tr("Ich unterhalte mich mit ihr so gut wie jeden Tag, aber sie scheint nichts für mich zu empfinden."), null)
			call speech(info, character, false, tr("Und zwei Honigtöpfe sollen das ändern?"), null)
			call speech(info, character, true, tr("Wenn du mich so fragst, ja. Blumen gibt es hier in der Nähe ja kaum und ich gehe sicher nicht den weiten Weg in den Wald, nur um Gestrüpp zu pflücken."), null)
			call speech(info, character, false, tr("Alles klar!"), null)
			// Charakter erhält Erfahrungsbonus aufgrund seiner weisen Art.
			call Character(character).xpBonus(50, tr("Weisheitsbonus.
			"))
			call info.talk().showStartPage(character)
		endmethod

		// Sie hat sich sehr gefreut.
		private static method infoAction5_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Sie hat sich sehr gefreut."), null)
			call speech(info, character, true, tr("Tatsächlich? Das ist ja großartig! Hier hast du Goldmünzen und Wein. Ich werde mich heute erstmal kräftig zulaufen lassen, zur Feier des Tages!"), null)
			// Charakter erhält 100 Goldmünzen und 2 Krüge Wein
			/// \todo FIXME
			call info.talk().showStartPage(character)
		endmethod

		// Sie war eher genervt.
		private static method infoAction5_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Sie war eher genervt."), null)
			// (Erfahrungsoption bei Mathilda freigeschaltet)
			call thistype(info.talk()).sayTruth(character)
			call speech(info, character, true, tr("Oh nein! Was habe ich getan? In Zukunft werde ich vorsichtiger bei ihr sein, das wollte ich wirklich nicht!"), null)
			call info.talk().showStartPage(character)
		endmethod

		// Sie meinte nur, du seist extrem fett.
		private static method infoAction5_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Sie meinte nur, du seist extrem fett."), null)
			call speech(info, character, true, tr("Ich bin nicht fett, ich habe nur …"), null)
			call speech(info, character, false, tr("… drei Riesen gefressen?"), null)
			call speech(info, character, true, tr("Sehr lustig (zynisch)!"), null)
			// Charakter erhält Erfahrungsbonus aufgrund seiner beleidigenden Art.
			call Character(character).xpBonus(50, tr("Beleidigungsbonus.
			"))
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.lothar(), thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_saidTruth[i] = false
				set i = i + 1
			endloop

			// start page
			call this.addInfo(false, true, 0, thistype.infoAction0, null) // 0
			call this.addInfo(false, false, 0, thistype.infoAction1, tr("Wer bist du?")) // 1
			call this.addInfo(false, false, 0, thistype.infoAction2, tr("Woher kommst du?")) // 2
			call this.addInfo(false, false, 0, thistype.infoAction3, tr("Was hältst du vom Bauernhof?")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tr("Ich habe Mathilda deinen Honigtopf gegeben.")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tr("Ich habe Mathilda deinen großen Honigtopf gegeben.")) // 5
			call this.addInfo(false, false, 0, thistype.infoAction6, tr("Wie läuft das Geschäft?")) // 6
			call this.addInfo(false, false, thistype.infoCondition7, thistype.infoAction7, tr("Du kannst wieder Trauben pflücken gehen.")) // 7
			call this.addInfo(false, false, 0, thistype.infoAction8, tr("Was genau verkaufst du?")) // 8
			call this.addExitButton() // 9

			// info 1
			call this.addInfo(false, false, 0, thistype.infoAction1_0, tr("Fettsack!")) // 10
			call this.addInfo(false, false, 0, thistype.infoAction1_1, tr("Du laberst ganz schön viel.")) // 11
			call this.addInfo(false, false, 0, thistype.infoAction1_2, tr("Gib mir eine Kostprobe.")) // 12
			call this.addBackToStartPageButton() // 13

			// info 3
			call this.addInfo(false, false, 0, thistype.infoAction3_0, tr("Na gut.")) // 14
			call this.addInfo(false, false, 0, thistype.infoAction3_1, tr("Friss deinen Honig doch selbst, du dummer Fettsack!")) // 15
			call this.addInfo(false, false, 0, thistype.infoAction3_2, tr("Kein Interesse.")) // 16

			// info 4
			call this.addInfo(false, false, 0, thistype.infoAction4_0, tr("In Ordnung.")) // 17
			call this.addInfo(false, false, 0, thistype.infoAction4_1, tr("Deine extreme Fettleibigkeit gefällt dagegen mir nicht!")) // 18
			call this.addInfo(false, false, 0, thistype.infoAction4_2, tr("Wie wärs eigentlich mal mit Blumen oder einem netten Gespräch?")) // 19

			// info 5
			call this.addInfo(false, false, 0, thistype.infoAction5_0, tr("Sie hat sich sehr gefreut.")) // 20
			call this.addInfo(false, false, 0, thistype.infoAction5_1, tr("Sie war eher genervt.")) // 21
			call this.addInfo(false, false, 0, thistype.infoAction5_2, tr("Sie meinte nur, du seist extrem fett.")) // 22

			return this
		endmethod
	endstruct

endlibrary