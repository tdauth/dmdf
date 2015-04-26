library StructMapTalksTalkMathilda requires Asl, StructGameFellow, StructMapMapNpcs, StructMapTalksTalkLothar, StructMapQuestsQuestABigPresent, StructMapQuestsQuestALittlePresent

	struct TalkMathilda extends ATalk
		private boolean array m_wasOffendedStories[6] /// \todo \ref MapData.maxPlayers
		private boolean array m_wasOffendedSongs[6] /// \todo \ref MapData.maxPlayers
		private boolean array m_toldStory[6] /// \todo \ref MapData.maxPlayers
		private boolean array m_playedSong[6] /// \todo \ref MapData.maxPlayers
		private boolean array m_toldThatSleepingInBarn[6] /// \todo \ref MapData.maxPlayers

		implement Talk

		private method offendStories takes player whichPlayer, boolean offend returns nothing
			set this.m_wasOffendedStories[GetPlayerId(whichPlayer)] = offend
		endmethod

		private method wasOffendedStories takes player whichPlayer returns boolean
			return this.m_wasOffendedStories[GetPlayerId(whichPlayer)]
		endmethod

		private method offendSongs takes player whichPlayer, boolean offend returns nothing
			set this.m_wasOffendedSongs[GetPlayerId(whichPlayer)] = offend
		endmethod

		private method wasOffendedSongs takes player whichPlayer returns boolean
			return this.m_wasOffendedSongs[GetPlayerId(whichPlayer)]
		endmethod

		private method tellStory takes player whichPlayer returns nothing
			set this.m_toldStory[GetPlayerId(whichPlayer)] = true
		endmethod

		private method toldStory takes player whichPlayer returns boolean
			return this.m_toldStory[GetPlayerId(whichPlayer)]
		endmethod

		private method playSong takes player whichPlayer returns nothing
			set this.m_playedSong[GetPlayerId(whichPlayer)] = true
		endmethod

		private method playedSong takes player whichPlayer returns boolean
			return this.m_playedSong[GetPlayerId(whichPlayer)]
		endmethod

		private method tellThatSleepingInBarn takes player whichPlayer returns nothing
			set this.m_toldThatSleepingInBarn[GetPlayerId(whichPlayer)] = true
		endmethod

		public method toldThatSleepingInBarn takes Character character returns boolean
			return this.m_toldThatSleepingInBarn[GetPlayerId(character.player())]
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			if (not this.showInfo(5, character)) then
				call this.showUntil(15, character)
			endif
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo Wandersmann! Darf ich ein Lied für dich spielen?"), null)
			call info.talk().showRange(16, 17, character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionAfterGreeting takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Woher kommst du?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Woher kommst du?"), null)
			call speech(info, character, true, tr("Von hier und dort. Ich weiß es schon nicht mehr, um ehrlich zu sein. Ich ziehe durchs Land, wie ich gerade Lust habe. Städte, Flüsse, Berge, Wälder, alles hat Namen, alles ist streng unterteilt. Wer braucht schon Namen und Unterteilungen, wenn man keine Grenzen hat?"), null)
			call speech(info, character, true, tr("Alles ist fließend. Leider verstehen das weder die Menschen hier noch die, der anderen Orte, an denen ich war."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Was hältst du vom Bauernhof?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was hältst du vom Bauernhof?"), null)
			call speech(info, character, true, tr("Ein ganz netter Ort. Die Leute sind sehr freundlich, vor allem der Bauer Manfred. Der fette Lothar dagegen geht mir mit seinem Gerede dauernd auf die Nerven."), null)
			call speech(info, character, true, tr("Ich will ihn ja nicht verletzen, aber ich denke, er macht sich was vor. Vielleicht auch die anderen hier, weil es kaum Frauen hier gibt, vor allem nicht mehr seit Manfreds Frau verstorben ist."), null)
			call speech(info, character, true, tr("Über Guntrich und die Knechte weiß ich nicht viel. Ich rede kaum mit ihnen, aber das kannst du ja tun, wenn sie dich so sehr interessieren."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Ein kleines Geschenk“ ist aktiv, Charakter hat den Honigtopf dabei)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return QuestALittlePresent.characterQuest(character).questItem(0).isNew() and character.inventory().hasItemType(QuestALittlePresent.itemTypeId)
		endmethod

		// Hier hast du einen Honigtopf!
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hier hast du einen Honigtopf!"), null)
			call speech(info, character, true, tr("Was zum … wozu?"), null)
			call speech(info, character, false, tr("Na zum Essen halt!"), null)
			call speech(info, character, true, tr("Interessant. Ich nehme mal an, Lothar schickt dich."), null)
			call speech(info, character, false, tr("Ähm …"), null)
			call speech(info, character, true, tr("Na gut, gib schon her! Ich will ja nicht, dass er sich noch das Leben nimmt."), null)
			// Honigtopf für Mathilda wird übergeben
			call character.inventory().removeItemType(QuestALittlePresent.itemTypeId)
			// Auftragsziel 1 des Auftrags „Ein kleines Geschenk“ abgeschlossen
			call QuestALittlePresent.characterQuest(character).questItem(0).complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Ein großes Geschenk“ ist aktiv, Charakter hat den großen Honigtopf dabei)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return QuestABigPresent.characterQuest(character).questItem(0).isNew() and character.inventory().hasItemType(QuestABigPresent.itemTypeId)
		endmethod

		// Hier hast du einen großen Honigtopf!
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hier hast du einen großen Honigtopf!"), null)
			call speech(info, character, true, tr("Also jetzt reicht es wirklich! Ich meine, was bildet er sich denn ein? Nur weil wir ab und zu miteinander plaudern."), null)
			call speech(info, character, true, tr("Gib schon her! Ich will nicht als Herzensbrecherin enden."), null)
			// Honigtopf für Mathilda wird übergeben
			call character.inventory().removeItemType(QuestABigPresent.itemTypeId)
			// Auftragsziel 1 des Auftrags „Ein großes Geschenk“ abgeschlossen
			call QuestABigPresent.characterQuest(character).questItem(0).complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat beim Abschluss des Auftrags „Ein großes Geschenk“ die Wahrheit gesagt)
		private static method infoCondition5 takes AInfo info, ACharacter character returns boolean
			return TalkLothar.talk().saidTruth(character)
		endmethod

		// (Automatisch) Deinetwegen nervt mich Lothar jetzt nicht mehr so stark wie vorher.
		private static method infoAction5 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Deinetwegen nervt mich Lothar jetzt nicht mehr so stark wie vorher."), null)
			call speech(info, character, true, tr("Ja, ich habe Augen und Ohren und ich habe gemerkt, dass er gemerkt hat, dass seine Geschenke nicht so das Wahre waren."), null)
			call speech(info, character, true, tr("Das heißt also, du hast ihm die Wahrheit gesagt."), null)
			// (Charakter mag beides nicht)
			if (thistype(info.talk()).wasOffendedStories(character.player()) and thistype(info.talk()).wasOffendedSongs(character.player())) then
				call speech(info, character, true, tr("Auch wenn du meine Geschichten und Lieder nicht besonders magst …"), null)
			// (Charakter mag die Geschichten nicht)
			elseif (thistype(info.talk()).wasOffendedStories(character.player())) then
				call speech(info, character, true, tr("Auch wenn du meine Geschichten nicht besonders magst …"), null)
			// (Charakter mag die Lieder nicht)
			elseif (thistype(info.talk()).wasOffendedSongs(character.player())) then
				call speech(info, character, true, tr("Auch wenn du meine Lieder nicht besonders magst …"), null)
			endif
			call speech(info, character, true, tr("… wir könnten doch ein wenig umherziehen, falls du Lust hast."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Mathilda hat es ihm angeboten)
		private static method infoCondition6 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(5, character)
		endmethod

		// Lass uns umherziehen!
		private static method infoAction6 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Lass uns umherziehen!"), null)
			call speech(info, character, true, tr("Na gut."), null)
			// Mathilda schließt sich dem Charakter an
			call Fellow.shareWithByUnit(Npcs.mathilda(), character)
			call info.talk().close(character)
		endmethod

		// Du musizierst?
		private static method infoAction7 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Du musizierst?"), null)
			call speech(info, character, true, tr("Ja, ich kann einige Lieder auf meiner Schalmei spielen. Die habe ich schon seit ich noch sehr jung war. Das ist wahrscheinlich der einzige Besitz, den ich wirklich vermissen würde, falls er mir mal abhanden käme."), null)
			call speech(info, character, true, tr("Ich mache übrigens nicht nur Musik, sondern erzähle auch gerne Geschichten. Damit verdiene ich mir meinen Lebensunterhalt. Ich brauche ja nicht gerade viel zum Leben."), null)
			call speech(info, character, true, tr("Aber da hier ja bald die Hölle los sein wird, nach allem, was man so hört, verschwinde ich lieber bald wieder."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung und Mathilda geht in oder kommt aus der Scheune)
		private static method infoCondition8 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character) and RectContainsUnit(gg_rct_quest_supply_for_talras_supply_0, Npcs.mathilda())
		endmethod

		// Was machst du in der Scheune?
		private static method infoAction8 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was machst du in der Scheune?"), null)
			call speech(info, character, true, tr("Schlafen, was sonst? Oder soll ich hier draußen erfrieren? Der Bauer Nado, ein sehr höflicher Mann, lässt mich dort umsonst übernachten."), null)
			call thistype(info.talk()).tellThatSleepingInBarn(character.player())
			call info.talk().showStartPage(character)
		endmethod

		// Erzähl mir eine Geschichte.
		private static method infoAction9 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Erzähl mir eine Geschichte."), null)
			if (not TalkMathilda(info.talk()).wasOffendedStories(character.player())) then
				call speech(info, character, true, tr("Gut, welche willst du hören?"), null)
				call info.talk().showRange(18, 21, character)
			else
				call speech(info, character, true, tr("Mit Sicherheit nicht. Erzähl dir doch selbst eine!"), null)
				call info.talk().showStartPage(character)
			endif
		endmethod

		private static method showSongs takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Gut, welches willst du hören?"), null)
			call info.talk().showRange(22, 25, character)
		endmethod

		// Spiel mir ein Lied.
		private static method infoAction10 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Spiel mir ein Lied."), null)
			if (not TalkMathilda(info.talk()).wasOffendedSongs(character.player())) then
				call thistype.showSongs(info, character)
			else
				call speech(info, character, true, tr("Bei dir hakt's wohl? Pfeif dir doch selbst eins!"), null)
				call info.talk().showStartPage(character)
			endif
		endmethod

		// (Mathilda hat mindestens eine Geschichte erzählt, Charakter hat mindestens 10 Goldmünzen)
		private static method infoCondition11 takes AInfo info, ACharacter character returns boolean
			return TalkMathilda(info.talk()).toldStory(character.player()) and TalkMathilda(info.talk()).playedSong(character.player()) and character.gold() >= 10
		endmethod

		// Du kannst gut erzählen und spielen. Hier hast du ein paar Goldmünzen.
		private static method infoAction11 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Du kannst gut erzählen und spielen. Hier hast du ein paar Goldmünzen."), null)
			call character.removeGold(10)
			call TalkMathilda(info.talk()).offendStories(character.player(), false)
			call TalkMathilda(info.talk()).offendSongs(character.player(), false)
			call speech(info, character, true, tr("Oh danke. Das höre ich immer wieder gerne."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Mathilda hat mindestens eine Geschichte erzählt und fühlt sich nicht angegriffen)
		private static method infoCondition12 takes AInfo info, ACharacter character returns boolean
			return TalkMathilda(info.talk()).toldStory(character.player()) and not TalkMathilda(info.talk()).wasOffendedStories(character.player())
		endmethod

		// Deine Geschichten scheinen einem Haufen Scheiße zu gleichen.
		private static method infoAction12 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Deine Geschichten scheinen einem Haufen Scheiße zu gleichen."), null)
			call TalkMathilda(info.talk()).offendStories(character.player(), true)
			call speech(info, character, true, tr("Wenn's dir nicht passt, dann erzähl ich dir halt keine mehr!"), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Mathilda hat mindestens ein Lied gespielt und fühlt sich nicht angegriffen)
		private static method infoCondition13 takes AInfo info, ACharacter character returns boolean
			return TalkMathilda(info.talk()).playedSong(character.player()) and not TalkMathilda(info.talk()).wasOffendedSongs(character.player())
		endmethod

		// Deine Musik ist ungefähr so hörenswert wie Gebärdensprache.
		private static method infoAction13 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Deine Musik ist ungefähr so hörenswert wie Gebärdensprache."), null)
			call TalkMathilda(info.talk()).offendSongs(character.player(), true)
			call speech(info, character, true, tr("Dir werd' ich sicher nicht nochmal ein Lied spielen!"), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat gefragt, ob Mathilda musiziert oder Mathilda hat ihm ein Lied vorgespielt)
		private static method infoCondition14 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(7, character) or TalkMathilda(info.talk()).playedSong(character.player())
		endmethod

		// ￼Weißt du, wo ich mir ein Instrument besorgen kann?
		private static method infoAction14 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Weißt du, wo ich mir ein Instrument besorgen kann?"), null)
			call speech(info, character, true, tr("In Talras gibt’s bestimmt irgendwo welche zu kaufen. Ansonsten wüsste ich aber auch nichts. Hier auf dem Hof scheint's wohl keine zu geben."), null)
			//(Mathilda fühlt sich angegriffen - egal ob bezüglich ihrer Musik oder Geschichten)
			if (TalkMathilda(info.talk()).wasOffendedStories(character.player()) or TalkMathilda(info.talk()).wasOffendedSongs(character.player())) then
				call speech(info, character, false, tr("Aber was willst du schon mit einem Instrument? Geschmack scheinst du ja nicht zu haben."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// Aber sicher doch.
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Aber sicher doch."), null)
			call thistype.showSongs(info, character)
		endmethod

		// Nein, lieber nicht.
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Nein, lieber nicht."), null)
			call speech(info, character, true, tr("Schade, aber vielleicht möchtest du ja später eins hören."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Die Geschichte vom Bären.
		private static method infoAction9_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Die Geschichte vom Bären."), null)
			/// @todo FIXME
			call info.talk().showStartPage(character)
		endmethod

		// Der Ork und der Wolf.
		private static method infoAction9_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Der Ork und der Wolf."), null)
			/// @todo FIXME
			call info.talk().showStartPage(character)
		endmethod

		// Das Hexenlied.
		private static method infoAction9_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Das Hexenlied."), null)
			/// @todo FIXME
			call info.talk().showStartPage(character)
		endmethod

		// Keine. Ich hab's mir anders überlegt.
		private static method infoAction9_3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Keine. Ich hab's mir anders überlegt."), null)
			call speech(info, character, true, tr("Wie du meinst."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Das Lied des Krieges.
		private static method infoAction10_0 takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Das Lied des Krieges."), null)
			call speech(info, character, true, tr("Der Rittersmann, von unweit her\nward vom König selbst gerufen\ner kam in Rüstung, samt dem Speer\nmit Legenden, die ihn schufen"), null)
			call speech(info, character, true, tr("Träumte er von Ruhm und Stolz\nso war sein Speer doch nur aus Holz\nund als er vor dem Drachen stand\nsetzte dieser ihn in Brand"), null)
			call speech(info, character, true, tr("So brannten Ritter und die Sagen\nan denen sich die Jungen laben\nAm Ende bleibt der Tod, nicht mehr\nso lange ist es gar nicht her!"), null)

			// Erfahrungsbonus (Hört das Lied zum ersten Mal)
			if (not this.playedSong(character.player())) then
				call character.xpBonus(50, tr("Ihr genießt die Musik!"))
			endif
			call this.playSong(character.player())
			call info.talk().showStartPage(character)
		endmethod

		// Der Wandersmann.
		private static method infoAction10_1 takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Der Wandersmann."), null)
			call speech(info, character, true, tr("Der Tag neigt sich dem Ende zu\nund alle Vögel werden müde\nnur einer, der gibt keine Ruh'\nin seiner Heimat ist man prüde"), null)
			call speech(info, character, true, tr("Er lief, ja rannte über Berge\ntraf fremde Wesen, auch die Zwerge\ndoch sollt er einen Menschen sehn\nwürd' er gleich wieder rückwärts gehen\nsich glücklich an den Seinen rächen\ngar jedem mal das Herz zerstechen\ndenn jeder seiner eignen Leut'\nhat zu viel Liebe stets gescheut"), null)
			call speech(info, character, true, tr("Ja dort in seiner alten Heimat\nist weder Mauer, noch ein Tor\ndoch wär' ihm eine neue Bleibe\ngar lieber als das triste Moor"), null)
			
			// Erfahrungsbonus (Hört das Lied zum ersten Mal)
			if (not this.playedSong(character.player())) then
				call character.xpBonus(50, tr("Ihr genießt die Musik!"))
			endif
			call this.playSong(character.player())
			call info.talk().showStartPage(character)
		endmethod

		// Die Waldgeister.
		private static method infoAction10_2 takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Die Waldgeister."), null)
			call speech(info, character, true, tr("Im alten Wald, am großen Fluss\ndurch den ich täglich waten muss\ndort traf ich traurig wie ich war\ndie mystisch schöne Geisterschaar"), null)
			call speech(info, character, true, tr("Sie gaben mir, was ich vermisst\ndoch war es eine große List\nDenn wollten sie nicht meinen Segen\nstattdessen nur den eignen Regen\nder kommt, wenn man aus einem Rachen\nmal etwas hört wie sanftes Lachen"), null)
			call speech(info, character, true, tr("Und wenns vergeht, ist's auch nicht schlimm\nder Geist behält ja seine Stimm'\nkann Lieder singen, selbst oft lachen\ner muss nun über gar nichts wachen\ngestorben ist er sowieso\ndoch fragt mein Herz sich wo"), null)
			
			// Erfahrungsbonus (Hört das Lied zum ersten Mal)
			if (not this.playedSong(character.player())) then
				call character.xpBonus(50, tr("Ihr genießt die Musik!"))
			endif
			call this.playSong(character.player())
			call info.talk().showStartPage(character)
		endmethod

		// Keines. Ich hab's mir anders überlegt.
		private static method infoAction10_3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Keines. Ich hab's mir anders überlegt."), null)
			call speech(info, character, true, tr("Deine Entscheidung."), null)
			call info.talk().showStartPage(character)
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