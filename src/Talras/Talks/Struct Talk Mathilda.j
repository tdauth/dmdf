library StructMapTalksTalkMathilda requires Asl, StructGameFellow, StructMapMapNpcs, StructMapTalksTalkLothar, StructMapQuestsQuestABigPresent, StructMapQuestsQuestALittlePresent

	struct TalkMathilda extends ATalk
		private boolean array m_wasOffendedStories[6] /// \todo \ref MapData.maxPlayers
		private boolean array m_wasOffendedSongs[6] /// \todo \ref MapData.maxPlayers
		private boolean array m_toldStory[6] /// \todo \ref MapData.maxPlayers
		private boolean array m_playedSong[6] /// \todo \ref MapData.maxPlayers

		implement Talk

		private method offendStories takes boolean offend returns nothing
			local player user = this.character().player()
			set this.m_wasOffendedStories[GetPlayerId(user)] = offend
			set user = null
		endmethod

		private method wasOffendedStories takes nothing returns boolean
			local player user = this.character().player()
			local boolean result = this.m_wasOffendedStories[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		private method offendSongs takes boolean offend returns nothing
			local player user = this.character().player()
			set this.m_wasOffendedSongs[GetPlayerId(user)] = offend
			set user = null
		endmethod

		private method wasOffendedSongs takes nothing returns boolean
			local player user = this.character().player()
			local boolean result = this.m_wasOffendedSongs[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		private method tellStory takes nothing returns nothing
			local player user = this.character().player()
			set this.m_toldStory[GetPlayerId(user)] = true
			set user = null
		endmethod

		private method toldStory takes nothing returns boolean
			local player user = this.character().player()
			local boolean result = this.m_toldStory[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		private method playSong takes nothing returns nothing
			local player user = this.character().player()
			set this.m_playedSong[GetPlayerId(user)] = true
			set user = null
		endmethod

		private method playedSong takes nothing returns boolean
			local player user = this.character().player()
			local boolean result = this.m_playedSong[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		private method startPageAction takes nothing returns nothing
			if (not this.showInfo(5)) then
				call this.showUntil(15)
			endif
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info returns nothing
			call speech(info, false, tr("Hallo."), null)
			call speech(info, true, tr("Hallo Wandersmann! Darf ich ein Lied für dich spielen?"), null)
			call info.talk().showRange(16, 17)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionAfterGreeting takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Woher kommst du?
		private static method infoAction1 takes AInfo info returns nothing
			call speech(info, false, tr("Woher kommst du?"), null)
			call speech(info, true, tr("Von hier und dort. Ich weiß es schon nicht mehr, um ehrlich zu sein. Ich ziehe durchs Land, wie ich gerade Lust habe. Städte, Flüsse, Berge, Wälder, alles hat Namen, alles ist streng unterteilt. Wer braucht schon Namen und Unterteilungen, wenn man keine Grenzen hat?"), null)
			call speech(info, true, tr("Alles ist fließend. Leider verstehen das weder die Menschen hier noch die, der anderen Orte, an denen ich war."), null)
			call info.talk().showStartPage()
		endmethod

		// Was hältst du vom Bauernhof?
		private static method infoAction2 takes AInfo info returns nothing
			call speech(info, false, tr("Was hältst du vom Bauernhof?"), null)
			call speech(info, true, tr("Ein ganz netter Ort. Die Leute sind sehr freundlich, vor allem der Bauer Manfred. Der fette Lothar dagegen geht mir mit seinem Gerede dauernd auf die Nerven."), null)
			call speech(info, true, tr("Ich will ihn ja nicht verletzen, aber ich denke, er macht sich was vor. Vielleicht auch die anderen hier, weil es kaum Frauen hier gibt, vor allem nicht mehr seit Manfreds Frau verstorben ist."), null)
			call speech(info, true, tr("Über Guntrich und die Knechte weiß ich nicht viel. Ich rede kaum mit ihnen, aber das kannst du ja tun, wenn sie dich so sehr interessieren."), null)
			call info.talk().showStartPage()
		endmethod

		// (Auftragsziel 1 des Auftrags „Ein kleines Geschenk“ ist aktiv, Charakter hat den Honigtopf dabei)
		private static method infoCondition3 takes AInfo info returns boolean
			return QuestALittlePresent.characterQuest(info.talk().character()).questItem(0).isNew() and true /// @todo FIXME
		endmethod

		// Hier hast du einen Honigtopf!
		private static method infoAction3 takes AInfo info returns nothing
			call speech(info, false, tr("Hier hast du einen Honigtopf!"), null)
			call speech(info, true, tr("Was zum … wozu?"), null)
			call speech(info, false, tr("Na zum Essen halt!"), null)
			call speech(info, true, tr("Interessant. Ich nehme mal an, Lothar schickt dich."), null)
			call speech(info, false, tr("Ähm …"), null)
			call speech(info, true, tr("Na gut, gib schon her! Ich will ja nicht, dass er sich noch das Leben nimmt."), null)
			// Honigtopf für Mathilda wird übergeben
			/// @todo FIXME
			// Auftragsziel 1 des Auftrags „Ein kleines Geschenk“ abgeschlossen
			call QuestALittlePresent.characterQuest(info.talk().character()).questItem(0).complete()
			call info.talk().showStartPage()
		endmethod

		// (Auftragsziel 1 des Auftrags „Ein großes Geschenk“ ist aktiv, Charakter hat den großen Honigtopf dabei)
		private static method infoCondition4 takes AInfo info returns boolean
			return QuestABigPresent.characterQuest(info.talk().character()).questItem(0).isNew() and true /// @todo FIXME
		endmethod

		// Hier hast du einen großen Honigtopf!
		private static method infoAction4 takes AInfo info returns nothing
			call speech(info, false, tr("Hier hast du einen großen Honigtopf!"), null)
			call speech(info, true, tr("Also jetzt reicht es wirklich! Ich meine, was bildet er sich denn ein? Nur weil wir ab und zu miteinander plaudern."), null)
			call speech(info, true, tr("Gib schon her! Ich will nicht als Herzensbrecherin enden."), null)
			// Honigtopf für Mathilda wird übergeben
			/// @todo FIXME
			// Auftragsziel 1 des Auftrags „Ein großes Geschenk“ abgeschlossen
			call QuestABigPresent.characterQuest(info.talk().character()).questItem(0).complete()
			call info.talk().showStartPage()
		endmethod

		// (Charakter hat beim Abschluss des Auftrags „Ein großes Geschenk“ die Wahrheit gesagt)
		private static method infoCondition5 takes AInfo info returns boolean
			return TalkLothar.talk().saidTruth(info.talk().character())
		endmethod

		// (Automatisch) Deinetwegen nervt mich Lothar jetzt nicht mehr so stark wie vorher.
		private static method infoAction5 takes AInfo info returns nothing
			call speech(info, true, tr("Deinetwegen nervt mich Lothar jetzt nicht mehr so stark wie vorher."), null)
			call speech(info, true, tr("Ja, ich habe Augen und Ohren und ich habe gemerkt, dass er gemerkt hat, dass seine Geschenke nicht so das Wahre waren."), null)
			call speech(info, true, tr("Das heißt also, du hast ihm die Wahrheit gesagt."), null)
			// (Charakter mag beides nicht)
			if (thistype(info.talk()).wasOffendedStories() and thistype(info.talk()).wasOffendedSongs()) then
				call speech(info, true, tr("Auch wenn du meine Geschichten und Lieder nicht besonders magst …"), null)
			// (Charakter mag die Geschichten nicht)
			elseif (thistype(info.talk()).wasOffendedStories()) then
				call speech(info, true, tr("Auch wenn du meine Geschichten nicht besonders magst …"), null)
			// (Charakter mag die Lieder nicht)
			elseif (thistype(info.talk()).wasOffendedSongs()) then
				call speech(info, true, tr("Auch wenn du meine Lieder nicht besonders magst …"), null)
			endif
			call speech(info, true, tr("… wir könnten doch ein wenig umherziehen, falls du Lust hast."), null)
			call info.talk().showStartPage()
		endmethod

		// (Mathilda hat es ihm angeboten)
		private static method infoCondition6 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(5)
		endmethod

		// Lass uns umherziehen!
		private static method infoAction6 takes AInfo info returns nothing
			call speech(info, false, tr("Lass uns umherziehen!"), null)
			call speech(info, true, tr("Na gut."), null)
			// Mathilda schließt sich dem Charakter an
			call Fellow.shareWithByUnit(Npcs.mathilda(), info.talk().character())
			call info.talk().close()
		endmethod

		// Du musizierst?
		private static method infoAction7 takes AInfo info returns nothing
			call speech(info, false, tr("Du musizierst?"), null)
			call speech(info, true, tr("Ja, ich kann einige Lieder auf meiner Schalmei spielen. Die habe ich schon seit ich noch sehr jung war. Das ist wahrscheinlich der einzige Besitz, den ich wirklich vermissen würde, falls er mir mal abhanden käme."), null)
			call speech(info, true, tr("Ich mache übrigens nicht nur Musik, sondern erzähle auch gerne Geschichten. Damit verdiene ich mir meinen Lebensunterhalt. Ich brauche ja nicht gerade viel zum Leben."), null)
			call speech(info, true, tr("Aber da hier ja bald die Hölle los sein wird, nach allem, was man so hört, verschwinde ich lieber bald wieder."), null)
			call info.talk().showStartPage()
		endmethod

		// (Mathilda geht in oder kommt aus der Scheune)
		private static method infoCondition8 takes AInfo info returns boolean
			return true /// @todo FIXME
		endmethod

		// Was machst du in der Scheune?
		private static method infoAction8 takes AInfo info returns nothing
			call speech(info, false, tr("Was machst du in der Scheune?"), null)
			call speech(info, true, tr("Schlafen, was sonst? Oder soll ich hier draußen erfrieren? Der Bauer Nado, ein sehr höflicher Mann, lässt mich dort umsonst übernachten."), null)
			call info.talk().showStartPage()
		endmethod

		// Erzähl mir eine Geschichte.
		private static method infoAction9 takes AInfo info returns nothing
			call speech(info, false, tr("Erzähl mir eine Geschichte."), null)
			if (not TalkMathilda(info.talk()).wasOffendedStories()) then
				call speech(info, true, tr("Gut, welche willst du hören?"), null)
				call info.talk().showRange(18, 21)
			else
				call speech(info, true, tr("Mit Sicherheit nicht. Erzähl dir doch selbst eine!"), null)
				call info.talk().showStartPage()
			endif
		endmethod

		private static method showSongs takes AInfo info returns nothing
			call speech(info, true, tr("Gut, welches willst du hören?"), null)
			call info.talk().showRange(22, 25)
		endmethod

		// Spiel mir ein Lied.
		private static method infoAction10 takes AInfo info returns nothing
			call speech(info, false, tr("Spiel mir ein Lied."), null)
			if (not TalkMathilda(info.talk()).wasOffendedSongs()) then
				call thistype.showSongs(info)
			else
				call speech(info, true, tr("Bei dir hakt's wohl? Pfeif dir doch selbst eins!"), null)
				call info.talk().showStartPage()
			endif
		endmethod

		// (Mathilda hat mindestens eine Geschichte erzählt, Charakter hat mindestens 10 Goldmünzen)
		private static method infoCondition11 takes AInfo info returns boolean
			return TalkMathilda(info.talk()).toldStory() and TalkMathilda(info.talk()).playedSong() and info.talk().character().gold() >= 10
		endmethod

		// Du kannst gut erzählen und spielen. Hier hast du ein paar Goldmünzen.
		private static method infoAction11 takes AInfo info returns nothing
			call speech(info, false, tr("Du kannst gut erzählen und spielen. Hier hast du ein paar Goldmünzen."), null)
			call info.talk().character().removeGold(10)
			call TalkMathilda(info.talk()).offendStories(false)
			call TalkMathilda(info.talk()).offendSongs(false)
			call speech(info, true, tr("Oh danke. Das höre ich immer wieder gerne."), null)
			call info.talk().showStartPage()
		endmethod

		// (Mathilda hat mindestens eine Geschichte erzählt und fühlt sich nicht angegriffen)
		private static method infoCondition12 takes AInfo info returns boolean
			return TalkMathilda(info.talk()).toldStory() and not TalkMathilda(info.talk()).wasOffendedStories()
		endmethod

		// Deine Geschichten scheinen einem Haufen Scheiße zu gleichen.
		private static method infoAction12 takes AInfo info returns nothing
			call speech(info, false, tr("Deine Geschichten scheinen einem Haufen Scheiße zu gleichen."), null)
			call TalkMathilda(info.talk()).offendStories(true)
			call speech(info, true, tr("Wenn's dir nicht passt, dann erzähl ich dir halt keine mehr!"), null)
			call info.talk().showStartPage()
		endmethod

		// (Mathilda hat mindestens ein Lied gespielt und fühlt sich nicht angegriffen)
		private static method infoCondition13 takes AInfo info returns boolean
			return TalkMathilda(info.talk()).playedSong() and not TalkMathilda(info.talk()).wasOffendedSongs()
		endmethod

		// Deine Musik ist ungefähr so hörenswert wie Gebärdensprache.
		private static method infoAction13 takes AInfo info returns nothing
			call speech(info, false, tr("Deine Musik ist ungefähr so hörenswert wie Gebärdensprache."), null)
			call TalkMathilda(info.talk()).offendSongs(true)
			call speech(info, true, tr("Dir werd' ich sicher nicht nochmal ein Lied spielen!"), null)
			call info.talk().showStartPage()
		endmethod

		// (Charakter hat gefragt, ob Mathilda musiziert oder Mathilda hat ihm ein Lied vorgespielt)
		private static method infoCondition14 takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(7) or TalkMathilda(info.talk()).playedSong()
		endmethod

		// ￼Weißt du, wo ich mir ein Instrument besorgen kann?
		private static method infoAction14 takes AInfo info returns nothing
			call speech(info, false, tr("Weißt du, wo ich mir ein Instrument besorgen kann?"), null)
			call speech(info, true, tr("In Talras gibt’s bestimmt irgendwo welche zu kaufen. Ansonsten wüsste ich aber auch nichts. Hier auf dem Hof scheint's wohl keine zu geben."), null)
			//(Mathilda fühlt sich angegriffen - egal ob bezüglich ihrer Musik oder Geschichten)
			if (TalkMathilda(info.talk()).wasOffendedStories() or TalkMathilda(info.talk()).wasOffendedSongs()) then
				call speech(info, false, tr("Aber was willst du schon mit einem Instrument? Geschmack scheinst du ja nicht zu haben."), null)
			endif
			call info.talk().showStartPage()
		endmethod

		// Aber sicher doch.
		private static method infoAction0_0 takes AInfo info returns nothing
			call speech(info, false, tr("Aber sicher doch."), null)
			call thistype.showSongs(info)
		endmethod

		// Nein, lieber nicht.
		private static method infoAction0_1 takes AInfo info returns nothing
			call speech(info, false, tr("Nein, lieber nicht."), null)
			call speech(info, true, tr("Schade, aber vielleicht möchtest du ja später eins hören."), null)
			call info.talk().showStartPage()
		endmethod

		// Die Geschichte vom Bären.
		private static method infoAction9_0 takes AInfo info returns nothing
			call speech(info, false, tr("Die Geschichte vom Bären."), null)
			/// @todo FIXME
			call info.talk().showStartPage()
		endmethod

		// Der Ork und der Wolf.
		private static method infoAction9_1 takes AInfo info returns nothing
			call speech(info, false, tr("Der Ork und der Wolf."), null)
			/// @todo FIXME
			call info.talk().showStartPage()
		endmethod

		// Das Hexenlied.
		private static method infoAction9_2 takes AInfo info returns nothing
			call speech(info, false, tr("Das Hexenlied."), null)
			/// @todo FIXME
			call info.talk().showStartPage()
		endmethod

		// Keine. Ich hab's mir anders überlegt.
		private static method infoAction9_3 takes AInfo info returns nothing
			call speech(info, false, tr("Keine. Ich hab's mir anders überlegt."), null)
			call speech(info, true, tr("Wie du meinst."), null)
			call info.talk().showStartPage()
		endmethod

		// Das Lied des Krieges.
		private static method infoAction10_0 takes AInfo info returns nothing
			call speech(info, false, tr("Das Lied des Krieges."), null)
			/// @todo FIXME
			call info.talk().showStartPage()
		endmethod

		// Der Wandersmann.
		private static method infoAction10_1 takes AInfo info returns nothing
			call speech(info, false, tr("Der Wandersmann."), null)
			/// @todo FIXME
			call info.talk().showStartPage()
		endmethod

		// Die Waldgeister.
		private static method infoAction10_2 takes AInfo info returns nothing
			call speech(info, false, tr("Die Waldgeister."), null)
			/// @todo FIXME
			call info.talk().showStartPage()
		endmethod

		// Keines. Ich hab's mir anders überlegt.
		private static method infoAction10_3 takes AInfo info returns nothing
			call speech(info, false, tr("Keines. Ich hab's mir anders überlegt."), null)
			call speech(info, true, tr("Deine Entscheidung."), null)
			call info.talk().showStartPage()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.mathilda(), thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_wasOffendedStories[i] = false
				set this.m_wasOffendedSongs[i] = false
				set this.m_toldStory[i] = false
				set this.m_playedSong[i] = false
				set i = i + 1
			endloop

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0

			call this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoAction1, tr("Woher kommst du?")) // 1
			call this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoAction2, tr("Was hältst du vom Bauernhof?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Hier hast du einen Honigtopf!")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tr("Hier hast du einen großen Honigtopf!")) // 4
			call this.addInfo(false, true, thistype.infoCondition5, thistype.infoAction5, null) // 5
			call this.addInfo(true, false, thistype.infoCondition6, thistype.infoAction6, tr("Lass uns umherziehen!")) // 6

			call this.addInfo(true, false, thistype.infoConditionAfterGreeting, thistype.infoAction7, tr("Du musizierst?")) // 7
			call this.addInfo(false, false, thistype.infoCondition8, thistype.infoAction8, tr("Was machst du in der Scheune?")) // 8
			call this.addInfo(true, false, thistype.infoConditionAfterGreeting, thistype.infoAction9, tr("Erzähl mir eine Geschichte.")) // 9
			call this.addInfo(true, false, thistype.infoConditionAfterGreeting, thistype.infoAction10, tr("Spiel mir ein Lied.")) // 10
			call this.addInfo(true, false, thistype.infoCondition11, thistype.infoAction11, tr("Du kannst gut erzählen und spielen. Hier hast du ein paar Goldmünzen.")) // 11
			call this.addInfo(true, false, thistype.infoCondition12, thistype.infoAction12, tr("Deine Geschichten scheinen einem Haufen Scheiße zu gleichen.")) // 12
			call this.addInfo(false, false, thistype.infoCondition13, thistype.infoAction13, tr("Deine Musik ist ungefähr so hörenswert wie Gebärdensprache.")) // 13
			call this.addInfo(false, false, thistype.infoCondition14, thistype.infoAction14, tr("Weißt du, wo ich mir ein Instrument besorgen kann?")) // 14
			call this.addExitButton() // 15

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Aber sicher doch.")) // 16
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Nein, lieber nicht.")) // 17

			// info 9
			call this.addInfo(true, false, 0, thistype.infoAction9_0, tr("Die Geschichte vom Bären.")) // 18
			call this.addInfo(true, false, 0, thistype.infoAction9_1, tr("Der Ork und der Wolf.")) // 19
			call this.addInfo(true, false, 0, thistype.infoAction9_2, tr("Das Hexenlied.")) // 20
			call this.addInfo(true, false, 0, thistype.infoAction9_3, tr("Keine. Ich hab's mir anders überlegt.")) // 21

			// info 10
			call this.addInfo(true, false, 0, thistype.infoAction10_0, tr("Das Lied des Krieges.")) // 22
			call this.addInfo(true, false, 0, thistype.infoAction10_1, tr("Der Wandersmann.")) // 23
			call this.addInfo(true, false, 0, thistype.infoAction10_2, tr("Die Waldgeister.")) // 24
			call this.addInfo(true, false, 0, thistype.infoAction10_3, tr("Keines. Ich hab's mir anders überlegt.")) // 25

			return this
		endmethod
	endstruct

endlibrary