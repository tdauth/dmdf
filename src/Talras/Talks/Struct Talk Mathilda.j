library StructMapTalksTalkMathilda requires Asl, StructGameFellow, StructMapMapFellows, StructMapMapNpcs, StructMapTalksTalkLothar, StructMapQuestsQuestABigPresent, StructMapQuestsQuestALittlePresent, StructMapQuestsQuestShawm

	struct TalkMathilda extends Talk
		private boolean array m_wasOffendedStories[12] /// \todo \ref MapSettings.maxPlayers()
		private boolean array m_wasOffendedSongs[12] /// \todo \ref MapSettings.maxPlayers()
		private boolean array m_toldStory[12] /// \todo \ref MapSettings.maxPlayers()
		private boolean array m_playedSong[12] /// \todo \ref MapSettings.maxPlayers()
		private boolean array m_toldThatSleepingInBarn[12] /// \todo \ref MapSettings.maxPlayers()

		private AInfo m_infoHi
		private AInfo m_infoWhereFrom
		private AInfo m_infoAboutTheFarm
		private AInfo m_infoHoneyPot
		private AInfo m_infoBigHoneyPot
		private AInfo m_infoAnnoyingLothar
		private AInfo m_infoLetsGo
		private AInfo m_infoAboutMusic
		private AInfo m_infoBarn
		private AInfo m_infoTellAStory
		private AInfo m_infoPlayASong
		private AInfo m_infoGoodStoriesAndSongs
		private AInfo m_infoBadStories
		private AInfo m_infoBadSongs
		private AInfo m_infoGetInstrument
		private AInfo m_infoBuildInstrument
		private AInfo m_infoBuildMeAnInstrument
		private AInfo m_infoLumberAndGold
		private AInfo m_infoFinishedInstrument
		private AInfo m_infoPlayMusic
		private AInfo m_infoWitchSong
		private AInfo m_infoExit
		private AInfo m_infoHi_YesSong
		private AInfo m_infoHi_NoSong
		private AInfo m_infoTellAStory_Bear
		private AInfo m_infoTellAStory_OrcAndWolf
		private AInfo m_infoTellAStory_WitchSong
		private AInfo m_infoTellAStory_None
		private AInfo m_infoPlayASong_War
		private AInfo m_infoPlayASong_Wayfarer
		private AInfo m_infoPlayASong_ForestSpirits
		private AInfo m_infoPlayASong_None
		private AInfo m_infoLeave
		private AInfo m_goAway

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
			if (not this.showInfo(this.m_goAway.index(), character) and not this.showInfo(this.m_infoAnnoyingLothar.index(), character)) then
				call this.showInfo(this.m_infoLeave.index(), character) // leave
				call this.showRange(0, this.m_infoExit.index(), character)
			endif
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo Wandersmann! Darf ich ein Lied für dich spielen?"), gg_snd_Mathilda1)
			call this.showRange(this.m_infoHi_YesSong.index(), this.m_infoHi_NoSong.index(), character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionAfterGreeting takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_infoHi.index(), character)
		endmethod

		// Woher kommst du?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Woher kommst du?"), null)
			call speech(info, character, true, tr("Von hier und dort. Ich weiß es schon nicht mehr, um ehrlich zu sein. Ich ziehe durchs Land, wie ich gerade Lust habe. Städte, Flüsse, Berge, Wälder, alles hat Namen, alles ist streng unterteilt. Wer braucht schon Namen und Unterteilungen, wenn man keine Grenzen hat?"), gg_snd_Mathilda5)
			call speech(info, character, true, tr("Alles ist fließend. Leider verstehen das weder die Menschen hier noch die, der anderen Orte, an denen ich war."), gg_snd_Mathilda6)
			call this.showStartPage(character)
		endmethod

		// Was hältst du vom Bauernhof?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Was hältst du vom Bauernhof?"), null)
			call speech(info, character, true, tr("Ein ganz netter Ort. Die Leute sind sehr freundlich, vor allem der Bauer Manfred. Der fette Lothar dagegen geht mir mit seinem Gerede dauernd auf die Nerven."), gg_snd_Mathilda7)
			call speech(info, character, true, tr("Ich will ihn ja nicht verletzen, aber ich denke, er macht sich was vor. Vielleicht auch die anderen hier, weil es kaum Frauen hier gibt, vor allem nicht mehr seit Manfreds Frau verstorben ist."), gg_snd_Mathilda8)
			call speech(info, character, true, tr("Über Guntrich und die Knechte weiß ich nicht viel. Ich rede kaum mit ihnen, aber das kannst du ja tun, wenn sie dich so sehr interessieren."), gg_snd_Mathilda9)
			call this.showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Ein kleines Geschenk“ ist aktiv, Charakter hat den Honigtopf dabei)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return QuestALittlePresent.characterQuest(character).questItem(0).isNew() and character.inventory().hasItemType(QuestALittlePresent.itemTypeId)
		endmethod

		// Hier hast du einen Honigtopf!
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Hier hast du einen Honigtopf!"), null)
			call speech(info, character, true, tr("Was zum … wozu?"), gg_snd_Mathilda10)
			call speech(info, character, false, tr("Na zum Essen halt!"), null)
			call speech(info, character, true, tr("Interessant. Ich nehme mal an, Lothar schickt dich."), gg_snd_Mathilda11)
			call speech(info, character, false, tr("Ähm …"), null)
			call speech(info, character, true, tr("Na gut, gib schon her! Ich will ja nicht, dass er sich noch das Leben nimmt."), gg_snd_Mathilda12)
			// Honigtopf für Mathilda wird übergeben
			call character.inventory().removeItemType(QuestALittlePresent.itemTypeId)
			// Auftragsziel 1 des Auftrags „Ein kleines Geschenk“ abgeschlossen
			call QuestALittlePresent.characterQuest(character).questItem(0).complete()
			call this.showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Ein großes Geschenk“ ist aktiv, Charakter hat den großen Honigtopf dabei)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return QuestABigPresent.characterQuest(character).questItem(0).isNew() and character.inventory().hasItemType(QuestABigPresent.itemTypeId)
		endmethod

		// Hier hast du einen großen Honigtopf!
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Hier hast du einen großen Honigtopf!"), null)
			call speech(info, character, true, tr("Also jetzt reicht es wirklich! Ich meine, was bildet er sich denn ein? Nur weil wir ab und zu miteinander plaudern."), gg_snd_Mathilda13)
			call speech(info, character, true, tr("Gib schon her! Ich will nicht als Herzensbrecherin enden."), gg_snd_Mathilda14)
			// Honigtopf für Mathilda wird übergeben
			call character.inventory().removeItemType(QuestABigPresent.itemTypeId)
			// Auftragsziel 1 des Auftrags „Ein großes Geschenk“ abgeschlossen
			call QuestABigPresent.characterQuest(character).questItem(0).complete()
			call this.showStartPage(character)
		endmethod

		// (Charakter hat beim Abschluss des Auftrags „Ein großes Geschenk“ die Wahrheit gesagt)
		private static method infoCondition5 takes AInfo info, ACharacter character returns boolean
			return TalkLothar.talk().saidTruth(character)
		endmethod

		// (Automatisch) Deinetwegen nervt mich Lothar jetzt nicht mehr so stark wie vorher.
		private static method infoAction5 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, true, tr("Deinetwegen nervt mich Lothar jetzt nicht mehr so stark wie vorher."), gg_snd_Mathilda15)
			call speech(info, character, true, tr("Ja, ich habe Augen und Ohren und ich habe gemerkt, dass er gemerkt hat, dass seine Geschenke nicht so das Wahre waren."), gg_snd_Mathilda16)
			call speech(info, character, true, tr("Das heißt also, du hast ihm die Wahrheit gesagt."), gg_snd_Mathilda17)
			// (Charakter mag beides nicht)
			if (this.wasOffendedStories(character.player()) and this.wasOffendedSongs(character.player())) then
				call speech(info, character, true, tr("Auch wenn du meine Geschichten und Lieder nicht besonders magst …"), gg_snd_Mathilda20)
			// (Charakter mag die Geschichten nicht)
			elseif (this.wasOffendedStories(character.player())) then
				call speech(info, character, true, tr("Auch wenn du meine Geschichten nicht besonders magst …"), gg_snd_Mathilda18)
			// (Charakter mag die Lieder nicht)
			elseif (this.wasOffendedSongs(character.player())) then
				call speech(info, character, true, tr("Auch wenn du meine Lieder nicht besonders magst …"), gg_snd_Mathilda19)
			endif
			call speech(info, character, true, tr("… wir könnten doch ein wenig umherziehen, falls du Lust hast."), gg_snd_Mathilda21)
			call this.showStartPage(character)
		endmethod

		// (Mathilda hat es ihm angeboten)
		private static method infoCondition6 takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_infoAnnoyingLothar.index(), character) and not Fellows.mathilda().isShared()
		endmethod

		// Lass uns umherziehen!
		private static method infoAction6 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Lass uns umherziehen!"), null)
			if (this.characters().size() == 1) then
				call speech(info, character, true, tr("Na gut."), gg_snd_Mathilda22)
				// Mathilda schließt sich dem Charakter an
				call Fellows.mathilda().shareWith(character)
				call this.close(character)
			else
				call character.displayMessage(ACharacter.messageTypeError, tr("Mathilda unterhält sich noch mit anderen Charakteren."))
				call this.showStartPage(character)
			endif
		endmethod

		// Du musizierst?
		private static method infoAction7 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Du musizierst?"), null)
			call speech(info, character, true, tr("Ja, ich kann einige Lieder auf meiner Schalmei spielen. Die habe ich schon seit ich noch sehr jung war. Das ist wahrscheinlich der einzige Besitz, den ich wirklich vermissen würde, falls er mir mal abhanden käme."), gg_snd_Mathilda23)
			call speech(info, character, true, tr("Ich mache übrigens nicht nur Musik, sondern erzähle auch gerne Geschichten. Damit verdiene ich mir meinen Lebensunterhalt. Ich brauche ja nicht gerade viel zum Leben."), gg_snd_Mathilda24)
			call speech(info, character, true, tr("Aber da hier ja bald die Hölle los sein wird, nach allem, was man so hört, verschwinde ich lieber bald wieder."), gg_snd_Mathilda25)
			call this.showStartPage(character)
		endmethod

		// (Nach Begrüßung und Mathilda geht in oder kommt aus der Scheune)
		private static method infoCondition8 takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_infoHi.index(), character) and RectContainsUnit(gg_rct_quest_supply_for_talras_supply_0, Npcs.mathilda())
		endmethod

		// Was machst du in der Scheune?
		private static method infoAction8 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Was machst du in der Scheune?"), null)
			call speech(info, character, true, tr("Schlafen, was sonst? Oder soll ich hier draußen erfrieren? Der Bauer Nado, ein sehr höflicher Mann, lässt mich dort umsonst übernachten."), gg_snd_Mathilda26)
			call this.tellThatSleepingInBarn(character.player())
			call this.showStartPage(character)
		endmethod

		// Erzähl mir eine Geschichte.
		private static method infoAction9 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Erzähl mir eine Geschichte."), null)
			if (not this.wasOffendedStories(character.player())) then
				call speech(info, character, true, tr("Gut, welche willst du hören?"), gg_snd_Mathilda27)
				call this.showRange(this.m_infoTellAStory_Bear.index(), this.m_infoTellAStory_None.index(), character)
			else
				call speech(info, character, true, tr("Mit Sicherheit nicht. Erzähl dir doch selbst eine!"), gg_snd_Mathilda44)
				call this.showStartPage(character)
			endif
		endmethod

		private static method showSongs takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, true, tr("Gut, welches willst du hören?"), gg_snd_Mathilda45)
			call this.showRange(this.m_infoPlayASong_War.index(), this.m_infoPlayASong_None.index(), character)
		endmethod

		// Spiel mir ein Lied.
		private static method infoAction10 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Spiel mir ein Lied."), null)
			if (not this.wasOffendedSongs(character.player())) then
				call thistype.showSongs(info, character)
			else
				call speech(info, character, true, tr("Bei dir hakt's wohl? Pfeif dir doch selbst eins!"), gg_snd_Mathilda50)
				call this.showStartPage(character)
			endif
		endmethod

		// (Mathilda hat mindestens eine Geschichte erzählt, Charakter hat mindestens 10 Goldmünzen)
		private static method infoCondition11 takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.toldStory(character.player()) and this.playedSong(character.player()) and character.gold() >= 10
		endmethod

		// Du kannst gut erzählen und spielen. Hier hast du ein paar Goldmünzen.
		private static method infoAction11 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Du kannst gut erzählen und spielen. Hier hast du ein paar Goldmünzen."), null)
			call character.removeGold(10)
			call this.offendStories(character.player(), false)
			call this.offendSongs(character.player(), false)
			call speech(info, character, true, tr("Oh danke. Das höre ich immer wieder gerne."), gg_snd_Mathilda51)
			call this.showStartPage(character)
		endmethod

		// (Mathilda hat mindestens eine Geschichte erzählt und fühlt sich nicht angegriffen)
		private static method infoCondition12 takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.toldStory(character.player()) and not this.wasOffendedStories(character.player())
		endmethod

		// Deine Geschichten scheinen einem Haufen Scheiße zu gleichen.
		private static method infoAction12 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Deine Geschichten scheinen einem Haufen Scheiße zu gleichen."), null)
			call this.offendStories(character.player(), true)
			call speech(info, character, true, tr("Wenn's dir nicht passt, dann erzähl ich dir halt keine mehr!"), gg_snd_Mathilda52)
			call this.showStartPage(character)
		endmethod

		// (Mathilda hat mindestens ein Lied gespielt und fühlt sich nicht angegriffen)
		private static method infoCondition13 takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.playedSong(character.player()) and not this.wasOffendedSongs(character.player())
		endmethod

		// Deine Musik ist ungefähr so hörenswert wie Gebärdensprache.
		private static method infoAction13 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Deine Musik ist ungefähr so hörenswert wie Gebärdensprache."), null)
			call this.offendSongs(character.player(), true)
			call speech(info, character, true, tr("Dir werd' ich sicher nicht nochmal ein Lied spielen!"), gg_snd_Mathilda53)
			call this.showStartPage(character)
		endmethod

		// (Charakter hat gefragt, ob Mathilda musiziert oder Mathilda hat ihm ein Lied vorgespielt)
		private static method infoCondition14 takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_infoAboutMusic.index(), character) or this.playedSong(character.player())
		endmethod

		// ￼Weißt du, wo ich mir ein Instrument besorgen kann?
		private static method infoAction14 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Weißt du, wo ich mir ein Instrument besorgen kann?"), null)
			call speech(info, character, true, tr("In Talras gibt’s bestimmt irgendwo welche zu kaufen. Ansonsten wüsste ich aber auch nichts. Hier auf dem Hof scheint's wohl keine zu geben."), gg_snd_Mathilda54)
			call speech(info, character, true, tr("Ich selbst habe mir meine Schalmei gebaut, doch das war mit viel Arbeit verbunden."), gg_snd_Mathilda55)
			//(Mathilda fühlt sich angegriffen - egal ob bezüglich ihrer Musik oder Geschichten)
			if (this.wasOffendedStories(character.player()) or this.wasOffendedSongs(character.player())) then
				call speech(info, character, true, tr("Aber was willst du schon mit einem Instrument? Geschmack scheinst du ja nicht zu haben."), gg_snd_Mathilda56)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Weißt du, wo ich mir ein Instrument besorgen kann?“ und Charakter hat noch kein Instrument)
		private static method infoConditionBuildInstrument takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_infoGetInstrument.index(), character)
		endmethod

		// Kannst du mir auch ein Instrument bauen?
		private static method infoActionBuildInstrument takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Kannst du mir auch ein Instrument bauen?"), null)
			call speech(info, character, true, tr("Das könnte ich tatsächlich, aber weißt du wie viel Arbeit das ist? Ich habe schon um meine eigene Schalmei Angst, denn ich habe sicher keine Lust mir eine neue zu bauen."), gg_snd_Mathilda57)
			if (this.wasOffendedStories(character.player()) or this.wasOffendedSongs(character.player())) then // (Wurde beleidigt)
				call speech(info, character, true, tr("Aber dir werde ich sicher keine bauen, so wie du mich behandelst."), gg_snd_Mathilda58)
			endif
			call this.showStartPage(character)
		endmethod

		// (Nach „Kannst du mir auch ein Instrument bauen?“ und Mathilda ist nicht mehr beleidigt)
		private static method infoConditionBuildMeAnInstrument takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_infoBuildInstrument.index(), character) and not this.wasOffendedStories(character.player()) and not this.wasOffendedSongs(character.player())
		endmethod

		// Baue mir eine Schalmei.
		private static method infoActionBuildMeAnInstrument takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Baue mir eine Schalmei."), null)
			call speech(info, character, true, tr("Wenn du unbedingt willst, dann besorge mir das Holz dafür und sagen wir … 100 Goldmünzen. So habe ich wenigstens eine Zeit lang meine Ruhe und kann mich von der harten Arbeit erholen."), gg_snd_Mathilda59)
			call speech(info, character, true, tr("Ich werde aber eine ganze Weile dafür brauchen, also gedulde dich."), gg_snd_Mathilda60)
			// Neuer Auftrag „Die Schalmei“
			call QuestShawm.characterQuest(character).enable()
			call this.showStartPage(character)
		endmethod

		// (Charakter hat Holz und Goldmünzen dabei)
		private static method infoConditionLumberAndGold takes AInfo info, ACharacter character returns boolean
			return character.inventory().totalRucksackItemTypeCharges('I02P') > 0 and GetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD) >= 100
		endmethod

		// Hier sind das Holz und die Goldmünzen.
		private static method infoActionLumberAndGold takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			// Check gold again, could have been reduced.
			if (GetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD) >= 100) then
				call speech(info, character, false, tr("Hier sind das Holz und die Goldmünzen."), null)
				// Give items to Mathilda.
				call character.inventory().removeItemTypeCount('I02P', 5)
				call SetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD) - 100)
				call speech(info, character, true, tr("Sieh an, dir ist es wirklich ernst damit. Na gut, aber wie gesagt gedulde dich. Handwerkliche Arbeit ist nicht gerade meine größte Leidenschaft, auch wenn ich nicht ganz ungeschickt bin."), gg_snd_Mathilda61)
				call speech(info, character, true, tr("Komm von Zeit zu Zeit zu mir und ich sage dir wie weit ich bin."), gg_snd_Mathilda62)
				// Auftragsziel 2 des Auftrags „Die Schalmei“ abgeschlossen
				call QuestShawm.characterQuest(character).questItem(QuestShawm.questItemGiveGoldAndLumber).setState(QuestShawm.stateCompleted)
				call QuestShawm.characterQuest(character).questItem(QuestShawm.questItemGetTheInstrument).setState(QuestShawm.stateNew)
				call QuestShawm.characterQuest(character).displayState()
				call QuestShawm.characterQuest(character).startConstructionTimer()
			else
				call character.displayHint(tr("Nicht genügend Goldmünzen dabei."))
			endif
			call this.showStartPage(character)
		endmethod

		// (Auftragsziel 3 des Auftrags „Die Schalmei“ ist aktiv)
		private static method infoConditionFinishedInstrument takes AInfo info, ACharacter character returns boolean
			return QuestShawm.characterQuest(character).questItem(QuestShawm.questItemGetTheInstrument).isNew()
		endmethod

		// Ist die Schalmei fertig?
		private static method infoActionFinishedInstrument takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Ist die Schalmei fertig?"), null)
			// (Schalmei ist fertig)
			if (QuestShawm.characterQuest(character).finishedConstruction()) then
				call speech(info, character, true, tr("Ja, hier hast du sie und passe gut darauf auf. Ich hoffe du kannst sie auch spielen."), gg_snd_Mathilda63)
				// Auftrag „Die Schalmei“ abgeschlossen
				call QuestShawm.characterQuest(character).complete()
			// (Schalmei ist noch nicht fertig)
			else
				call speech(info, character, true, tr("Gedulde dich noch etwas. Heute ist nicht gerade mein Tag. Vielleicht arbeite ich morgen daran weiter, mal sehen."), gg_snd_Mathilda64)
			endif
			call this.showStartPage(character)
		endmethod

		// (Charakter besitzt eine eigene Schalmei).
		private static method infoConditionPlayMusic takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return character.inventory().totalItemTypeCharges(QuestShawm.itemTypeId) > 0 or character.inventory().totalItemTypeCharges('I083') > 0
		endmethod

		// Lass uns musizieren.
		private static method infoActionPlayMusic takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Lass uns musizieren."), null)
			// (Mathilda ist beleidigt)
			if (this.wasOffendedStories(character.player()) or this.wasOffendedSongs(character.player())) then
				call speech(info, character, true, tr("Lass mich in Ruhe!"), gg_snd_Mathilda65)
			// (Mathilda ist nicht beleidigt)
			else
				call speech(info, character, true, tr("Nun gut! Fang an!"), gg_snd_Mathilda66)
				// Charakter und Mathilda spielen eine Weile
				// TODO do it
				call QueueUnitAnimationBJ(Npcs.mathilda(), "Attack Third")
				call SetUnitAnimationByIndex(character.unit(), 187) // dance
				call PlaySoundOnUnitBJ(gg_snd_mshawm, 100.0, Npcs.mathilda())
				call TriggerSleepAction(10.0)
				call ResetUnitAnimation(character.unit())
				call ResetUnitAnimation(Npcs.mathilda())
			endif

			call this.showStartPage(character)
		endmethod

		// (Charakter besitzt eine eigene Schalmei und hat die Geschichte „Das Hexenlied“ gehört)
		private static method infoConditionWitchSong takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_infoTellAStory_WitchSong.index(), character) and character.inventory().totalItemTypeCharges(QuestShawm.itemTypeId) > 0
		endmethod

		// Bring mir das Hexenlied bei.
		private static method infoActionWitchSong takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Bring mir das Hexenlied bei."), null)
			call speech(info, character, true, tr("Du hast also gut aufgepasst bei meiner Geschichte."), gg_snd_Mathilda67)
			// (Mathilda ist beleidigt)
			if (this.wasOffendedStories(character.player()) or this.wasOffendedSongs(character.player())) then
				call speech(info, character, true, tr("Aber so wie du mich behandelst bringe ich dir gar nichts bei."), gg_snd_Mathilda68)
			// (Mathilda ist nicht beleidigt)
			else
				call speech(info, character, true, tr("Zur Belohnung werde ich dir das Lied beibringen."), gg_snd_Mathilda69)
				call speech(info, character, true, tr("Wusstest du, dass ich einst mit den Hexen umherzog? Doch erzähle das keinem hier, versprich mir das!"), gg_snd_Mathilda70)
				call speech(info, character, false, tr("Sicher."), null)
				call speech(info, character, true, tr("Gut, so geht das Lied …"), gg_snd_Mathilda71)
				// (Charakter erlernt die Fähigkeit mit der Schalmei einen Riesen auf seine Seite zu bringen)
				// Switch the instrument by another one.
				call character.inventory().removeItemType(QuestShawm.itemTypeId)
				call character.giveQuestItem('I083')
			endif
		endmethod

		// Aber sicher doch.
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Aber sicher doch."), null)
			call thistype.showSongs(info, character)
		endmethod

		// Nein, lieber nicht.
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Nein, lieber nicht."), null)
			call speech(info, character, true, tr("Schade, aber vielleicht möchtest du ja später eins hören."), gg_snd_Mathilda4)
			call this.showStartPage(character)
		endmethod

		// Die Geschichte vom Bären.
		private static method infoAction9_0 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Die Geschichte vom Bären."), null)
			call speech(info, character, true, tr("Es war einmal ein Bär, der wanderte durch den Wald und dann fiel ein Baum um und erschlug den Bären."), gg_snd_Mathilda28)
			call speech(info, character, true, tr("Es war einmal ein Mann, der einen Bären sah, der durch den Wald wanderte und dann fiel ein Baum um und erschlug den Bären."), gg_snd_Mathilda29)
			call speech(info, character, true, tr("Es war einmal ein anderer Mann, der einen Mann sah, der einen Bären sah, der durch den Wald wanderte und dann fiel ein Baum um und erschlug den Bären."), gg_snd_Mathilda30)
			call speech(info, character, true, tr("Es war einmal ein weiterer Mann, der einen anderen Mann sah, der einen Mann sah, der einen Bären sah, der durch den Wald wanderte und dann fiel ein Baum um und erschlug den Bären."), gg_snd_Mathilda31)
			call speech(info, character, true, tr("Es war einmal …"), gg_snd_Mathilda32)
			call speech(info, character, false, tr("Danke, ich glaube das reicht."), null)
			call this.showStartPage(character)
		endmethod

		// Der Ork und der Wolf.
		private static method infoAction9_1 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Der Ork und der Wolf."), null)
			call speech(info, character, true, tr("Vor langer langer Zeit, da lebte ein Ork in einer Höhle in den Bergen. Er war sehr einsam dort, denn in den Bergen lebten nur Tiere und keiner mit dem er sich hätte unterhalten können."), gg_snd_Mathilda33)
			call speech(info, character, true, tr("Doch eines Tages, als der Ork sich auf die jagt begab, da traf er auf einen Wolf in der Wildnis und als sich der Ork dem Wolf näherte, da sprach der Wolf: „Wenn du mich tötest, dann bleibst du allein.“"), gg_snd_Mathilda34)
			call speech(info, character, true, tr("Der Ork antwortete erstaunt: „Sag mir Wolf, wie kommt es dass ich dich verstehe?“"), gg_snd_Mathilda35)
			call speech(info, character, true, tr("Der Wolf aber antwortete: „Sag mir Ork, wie kommt es, dass du mir zuhörst?“"), gg_snd_Mathilda36)
			call speech(info, character, true, tr("Der Ork war verwundert, aber auch froh nach so langer Zeit wieder jemanden getroffen zu haben, mit dem er sich unterhalten konnte. Also fragte er den Wolf: „Sag Wolf, wenn ich dich verschone, begleitest du mich dann?“"), gg_snd_Mathilda37)
			call speech(info, character, true, tr("Der Wolf antwortet daraufhin: „Sicher Ork, das werde ich.“ So gingen die beiden zusammen zur Höhle des Orks. Doch als sie dort ankamen sprach der Wolf: „Sieh Ork, verschont hast du mich und ich habe dich begleitet. Nun haben wir beide unser Wort gehalten, doch sieh welche Höhle du mir gezeigt hast, so warm und so groß.“ Da fraß der Wolf den Ork."), gg_snd_Mathilda38)
			call this.showStartPage(character)
		endmethod

		// Das Hexenlied.
		private static method infoAction9_2 takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Das Hexenlied."), null)
			call speech(info, character, true, tr("Im nordöstlichen Wald von Talras, auf der anderen Seite des Flusses dort leben die alten verstoßenen Hexen. Einst gefürchtet von den Bewohnern Talras' plagt sie nun die unendliche Einsamkeit."), gg_snd_Mathilda39)
			call speech(info, character, true, tr("Man erzählt sich, sie hätten schließlich Freundschaft mit den Riesen geschlossen, um ihrer Einsamkeit zu entgehen. Die Riesen, ebenfalls gefürchtet von jedem Bewohner in Talras, gingen tatsächlich auf diese Freundschaft ein."), gg_snd_Mathilda40)
			call speech(info, character, true, tr("Die Hexen spielten ein verzaubertes Lied und die Riesen folgten ihrem Befehl. Nun gehorchen sie den Hexen und wann immer man auf eine Hexe trifft, da ist auch ein Riese nicht weit."), gg_snd_Mathilda41)
			call speech(info, character, true, tr("Doch höre, wer auch immer das Lied spielen kann, dem wird auch der Riese folgen."), gg_snd_Mathilda42)
			// (Charakter erhält Hinweis, dass man mit dem Lied Riesen für sich gewinnen kann)
			call character.displayHint(tr("Mit dem Hexenlied kann der Charakter Riesen für sich gewinnen."))
			call this.showStartPage(character)
		endmethod

		// Keine. Ich hab's mir anders überlegt.
		private static method infoAction9_3 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Keine. Ich hab's mir anders überlegt."), null)
			call speech(info, character, true, tr("Wie du meinst."), gg_snd_Mathilda43)
			call this.showStartPage(character)
		endmethod

		// Das Lied des Krieges.
		private static method infoAction10_0 takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Das Lied des Krieges."), null)
			call speech(info, character, true, tr("Der Rittersmann, von unweit her, ward vom König selbst gerufen, er kam in Rüstung, samt dem Speer, mit Legenden, die ihn schufen. Träumte er von Ruhm und Stolz, so war sein Speer doch nur aus Holz, und als er vor dem Drachen stand, setzte dieser ihn in Brand. So brannten Ritter und die Sagen, an denen sich die Jungen laben, Am Ende bleibt der Tod, nicht mehr, so lange ist es gar nicht her!"), gg_snd_Mathilda46)

			// Erfahrungsbonus (Hört das Lied zum ersten Mal)
			if (not this.playedSong(character.player())) then
				call character.xpBonus(50, tr("Ihr genießt die Musik!"))
			endif

			call this.playSong(character.player())
			call this.showStartPage(character)
		endmethod

		// Der Wandersmann.
		private static method infoAction10_1 takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Der Wandersmann."), null)
			call speech(info, character, true, tr("Der Tag neigt sich dem Ende zu, und alle Vögel werden müde, nur einer, der gibt keine Ruh', in seiner Heimat ist man prüde. Er lief, ja rannte über Berge, traf fremde Wesen, auch die Zwerge, doch sollt er einen Menschen sehn, würd' er gleich wieder rückwärts gehen, sich glücklich an den Seinen rächen, gar jedem mal das Herz zerstechen, denn jeder seiner eignen Leut', hat zu viel Liebe stets gescheut. Ja dort in seiner alten Heimat, ist weder Mauer, noch ein Tor, doch wär' ihm eine neue Bleibe, gar lieber als das triste Moor."), gg_snd_Mathilda47)

			// Erfahrungsbonus (Hört das Lied zum ersten Mal)
			if (not this.playedSong(character.player())) then
				call character.xpBonus(50, tr("Ihr genießt die Musik!"))
			endif

			call this.playSong(character.player())
			call this.showStartPage(character)
		endmethod

		// Die Waldgeister.
		private static method infoAction10_2 takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Die Waldgeister."), null)
			call speech(info, character, true, tr("Im alten Wald, am großen Fluss, durch den ich täglich waten muss, dort traf ich traurig wie ich war, die mystisch schöne Geisterschaar. Sie gaben mir, was ich vermisst, doch war es eine große List, Denn wollten sie nicht meinen Segen, stattdessen nur den eignen Regen, der kommt, wenn man aus einem Rachen, mal etwas hört wie sanftes Lachen. Und wenns vergeht, ist's auch nicht schlimm, der Geist behält ja seine Stimm', kann Lieder singen, selbst oft lachen, er muss nun über gar nichts wachen, gestorben ist er sowieso, doch fragt mein Herz sich wo."), gg_snd_Mathilda48)

			// Erfahrungsbonus (Hört das Lied zum ersten Mal)
			if (not this.playedSong(character.player())) then
				call character.xpBonus(50, tr("Ihr genießt die Musik!"))
			endif

			call this.playSong(character.player())
			call this.showStartPage(character)
		endmethod

		// Keines. Ich hab's mir anders überlegt.
		private static method infoAction10_3 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Keines. Ich hab's mir anders überlegt."), null)
			call speech(info, character, true, tr("Deine Entscheidung."), gg_snd_Mathilda49)
			call this.showStartPage(character)
		endmethod

		// (Mathilda begleitet den Charakter)
		private static method infoConditionLeave takes AInfo info, ACharacter character returns boolean
			return Fellows.mathilda().isSharedToCharacter() and Fellows.mathilda().character() == character
		endmethod

		// Geh.
		private static method infoActionLeave takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tr("Geh."), null)
			// Mathilda verlässt den Charakter
			call Fellows.mathilda().reset()
			call this.close(character)
		endmethod

		// (Mathilda ist mit Charakter unterwegs)
		private static method infoConditionGoAway takes AInfo info, ACharacter character returns boolean
			return Fellows.mathilda().isSharedToCharacter() and Fellows.mathilda().character() != character
		endmethod

		private static method infoActionGoAway takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, true, tr("Lass mich in Ruhe!"), gg_snd_Mathilda72)
			call this.close(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.mathilda(), thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set this.m_wasOffendedStories[i] = false
				set this.m_wasOffendedSongs[i] = false
				set this.m_toldStory[i] = false
				set this.m_playedSong[i] = false
				set i = i + 1
			endloop

			call this.setName(tr("Mathilda"))

			// start page
			set this.m_infoHi = this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0

			set this.m_infoWhereFrom = this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoAction1, tr("Woher kommst du?")) // 1
			set this.m_infoAboutTheFarm = this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoAction2, tr("Was hältst du vom Bauernhof?")) // 2
			set this.m_infoHoneyPot = this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Hier hast du einen Honigtopf!")) // 3
			set this.m_infoBigHoneyPot = this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tr("Hier hast du einen großen Honigtopf!")) // 4
			set this.m_infoAnnoyingLothar = this.addInfo(false, true, thistype.infoCondition5, thistype.infoAction5, null) // 5
			set this.m_infoLetsGo = this.addInfo(true, false, thistype.infoCondition6, thistype.infoAction6, tr("Lass uns umherziehen!")) // 6

			set this.m_infoAboutMusic = this.addInfo(true, false, thistype.infoConditionAfterGreeting, thistype.infoAction7, tr("Du musizierst?")) // 7
			set this.m_infoBarn = this.addInfo(false, false, thistype.infoCondition8, thistype.infoAction8, tr("Was machst du in der Scheune?")) // 8
			set this.m_infoTellAStory = this.addInfo(true, false, thistype.infoConditionAfterGreeting, thistype.infoAction9, tr("Erzähl mir eine Geschichte.")) // 9
			set this.m_infoPlayASong = this.addInfo(true, false, thistype.infoConditionAfterGreeting, thistype.infoAction10, tr("Spiel mir ein Lied.")) // 10
			set this.m_infoGoodStoriesAndSongs = this.addInfo(true, false, thistype.infoCondition11, thistype.infoAction11, tr("Du kannst gut erzählen und spielen. Hier hast du ein paar Goldmünzen.")) // 11
			set this.m_infoBadStories = this.addInfo(true, false, thistype.infoCondition12, thistype.infoAction12, tr("Deine Geschichten scheinen einem Haufen Scheiße zu gleichen.")) // 12
			set this.m_infoBadSongs = this.addInfo(false, false, thistype.infoCondition13, thistype.infoAction13, tr("Deine Musik ist ungefähr so hörenswert wie Gebärdensprache.")) // 13
			set this.m_infoGetInstrument = this.addInfo(false, false, thistype.infoCondition14, thistype.infoAction14, tr("Weißt du, wo ich mir ein Instrument besorgen kann?")) // 14
			set this.m_infoBuildInstrument = this.addInfo(true, false, thistype.infoConditionBuildInstrument, thistype.infoActionBuildInstrument, tr("Kannst du mir auch ein Instrument bauen?"))
			set this.m_infoBuildMeAnInstrument = this.addInfo(false, false, thistype.infoConditionBuildMeAnInstrument, thistype.infoActionBuildMeAnInstrument, tr("Baue mir eine Schalmei."))
			set this.m_infoLumberAndGold = this.addInfo(false, false, thistype.infoConditionLumberAndGold, thistype.infoActionLumberAndGold, tr("Hier sind das Holz und die Goldmünzen."))
			set this.m_infoFinishedInstrument = this.addInfo(true, false, thistype.infoConditionFinishedInstrument, thistype.infoActionFinishedInstrument, tr("Ist die Schalmei fertig?"))
			set this.m_infoPlayMusic = this.addInfo(true, false, thistype.infoConditionPlayMusic, thistype.infoActionPlayMusic, tr("Lass uns musizieren."))
			set this.m_infoWitchSong = this.addInfo(true, false, thistype.infoConditionWitchSong, thistype.infoActionWitchSong, tr("Bring mir das Hexenlied bei."))
			set this.m_infoExit = this.addExitButton() // 15

			// info 0
			set this.m_infoHi_YesSong = this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Aber sicher doch.")) // 16
			set this.m_infoHi_NoSong = this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Nein, lieber nicht.")) // 17

			// info 9
			set this.m_infoTellAStory_Bear = this.addInfo(true, false, 0, thistype.infoAction9_0, tr("Die Geschichte vom Bären.")) // 18
			set this.m_infoTellAStory_OrcAndWolf = this.addInfo(true, false, 0, thistype.infoAction9_1, tr("Der Ork und der Wolf.")) // 19
			set this.m_infoTellAStory_WitchSong = this.addInfo(true, false, 0, thistype.infoAction9_2, tr("Das Hexenlied.")) // 20
			set this.m_infoTellAStory_None = this.addInfo(true, false, 0, thistype.infoAction9_3, tr("Keine. Ich hab's mir anders überlegt.")) // 21

			// info 10
			set this.m_infoPlayASong_War = this.addInfo(true, false, 0, thistype.infoAction10_0, tr("Das Lied des Krieges.")) // 22
			set this.m_infoPlayASong_Wayfarer = this.addInfo(true, false, 0, thistype.infoAction10_1, tr("Der Wandersmann.")) // 23
			set this.m_infoPlayASong_ForestSpirits = this.addInfo(true, false, 0, thistype.infoAction10_2, tr("Die Waldgeister.")) // 24
			set this.m_infoPlayASong_None = this.addInfo(true, false, 0, thistype.infoAction10_3, tr("Keines. Ich hab's mir anders überlegt.")) // 25

			set this.m_infoLeave = this.addInfo(true, false, thistype.infoConditionLeave, thistype.infoActionLeave, tr("Geh.")) // 26

			set this.m_goAway = this.addInfo(true, true, thistype.infoConditionGoAway, thistype.infoActionGoAway, "")

			return this
		endmethod

		implement Talk
	endstruct

endlibrary