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
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Hallo Wandersmann! Darf ich ein Lied für dich spielen?", "Hello wayfarer! May I play a song for you?"), gg_snd_Mathilda1)
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
			call speech(info, character, false, tre("Woher kommst du?", "Where are you from?"), null)
			call speech(info, character, true, tre("Von hier und dort. Ich weiß es schon nicht mehr, um ehrlich zu sein. Ich ziehe durchs Land, wie ich gerade Lust habe. Städte, Flüsse, Berge, Wälder, alles hat Namen, alles ist streng unterteilt. Wer braucht schon Namen und Unterteilungen, wenn man keine Grenzen hat?", "From here and there. I do not know anymore, to be honest. I move through the country as I just feel like. Cities, rivers, mountains, forests, everything has names, everything is strictly divided. Who needs names and subdivisions if you have no limits?"), gg_snd_Mathilda5)
			call speech(info, character, true, tre("Alles ist fließend. Leider verstehen das weder die Menschen hier noch die, der anderen Orte, an denen ich war.", "Everything is fluid. Unfortunately, neither the people here nor those of other places where I was understand this."), gg_snd_Mathilda6)
			call this.showStartPage(character)
		endmethod

		// Was hältst du vom Bauernhof?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Was hältst du vom Bauernhof?", "What do you think about the farm?"), null)
			call speech(info, character, true, tre("Ein ganz netter Ort. Die Leute sind sehr freundlich, vor allem der Bauer Manfred. Der fette Lothar dagegen geht mir mit seinem Gerede dauernd auf die Nerven.", "A very nice place. The people are very friendly, especially the farmer Manfred. The fat Lothar, on the other hand, constantlygets on my nerves with his talk."), gg_snd_Mathilda7)
			call speech(info, character, true, tre("Ich will ihn ja nicht verletzen, aber ich denke, er macht sich was vor. Vielleicht auch die anderen hier, weil es kaum Frauen hier gibt, vor allem nicht mehr seit Manfreds Frau verstorben ist.", "I do not want to hurt him, but I think he's pretending something. Perhaps the others here too, because there are hardly any women here, especially since Manfred's wife has died."), gg_snd_Mathilda8)
			call speech(info, character, true, tre("Über Guntrich und die Knechte weiß ich nicht viel. Ich rede kaum mit ihnen, aber das kannst du ja tun, wenn sie dich so sehr interessieren.", "I do not know much about Guntrich and the servants. I hardly talk to them, but you can do that if you care so much about them."), gg_snd_Mathilda9)
			call this.showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Ein kleines Geschenk“ ist aktiv, Charakter hat den Honigtopf dabei)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return QuestALittlePresent.characterQuest(character).questItem(0).isNew() and character.inventory().hasItemType(QuestALittlePresent.itemTypeId)
		endmethod

		// Hier hast du einen Honigtopf!
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Hier hast du einen Honigtopf!", "Here you have a honeypot!"), null)
			call speech(info, character, true, tre("Was zum … wozu?", "What the ... why?"), gg_snd_Mathilda10)
			call speech(info, character, false, tre("Na zum Essen halt!", "Well, to eat it!"), null)
			call speech(info, character, true, tre("Interessant. Ich nehme mal an, Lothar schickt dich.", "Interesting. I suppose Lothar sends you."), gg_snd_Mathilda11)
			call speech(info, character, false, tre("Ähm …", "Um ..."), null)
			call speech(info, character, true, tre("Na gut, gib schon her! Ich will ja nicht, dass er sich noch das Leben nimmt.", "Well, give it! I do not want him to take his life."), gg_snd_Mathilda12)
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
			call speech(info, character, false, tre("Hier hast du einen großen Honigtopf!", "Here you have a big honey pot!"), null)
			call speech(info, character, true, tre("Also jetzt reicht es wirklich! Ich meine, was bildet er sich denn ein? Nur weil wir ab und zu miteinander plaudern.", "So now it is really enough! I mean, what does he imagine? Just because we chat from time to time."), gg_snd_Mathilda13)
			call speech(info, character, true, tre("Gib schon her! Ich will nicht als Herzensbrecherin enden.", "Give it to me! I do not want to end as a heartbreaker."), gg_snd_Mathilda14)
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
			call speech(info, character, true, tre("Deinetwegen nervt mich Lothar jetzt nicht mehr so stark wie vorher.", "For your sake Lothar does not bother me as much as before."), gg_snd_Mathilda15)
			call speech(info, character, true, tre("Ja, ich habe Augen und Ohren und ich habe gemerkt, dass er gemerkt hat, dass seine Geschenke nicht so das Wahre waren.", "Yes, I have eyes and ears and I have noticed that he realized that this gifts were not so good."), gg_snd_Mathilda16)
			call speech(info, character, true, tre("Das heißt also, du hast ihm die Wahrheit gesagt.", "So you told him the truth."), gg_snd_Mathilda17)
			// (Charakter mag beides nicht)
			if (this.wasOffendedStories(character.player()) and this.wasOffendedSongs(character.player())) then
				call speech(info, character, true, tre("Auch wenn du meine Geschichten und Lieder nicht besonders magst …", "Even if you do not particularly like my stories and songs ..."), gg_snd_Mathilda20)
			// (Charakter mag die Geschichten nicht)
			elseif (this.wasOffendedStories(character.player())) then
				call speech(info, character, true, tre("Auch wenn du meine Geschichten nicht besonders magst …", "Even if you do not particularly like my stories ..."), gg_snd_Mathilda18)
			// (Charakter mag die Lieder nicht)
			elseif (this.wasOffendedSongs(character.player())) then
				call speech(info, character, true, tre("Auch wenn du meine Lieder nicht besonders magst …", "Even if you do not particularly like my songs ..."), gg_snd_Mathilda19)
			endif
			call speech(info, character, true, tre("… wir könnten doch ein wenig umherziehen, falls du Lust hast.", "... we could go around a little, if you want to."), gg_snd_Mathilda21)
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
			call speech(info, character, false, tre("Lass uns umherziehen!", "Let's move!"), null)
			if (this.characters().size() == 1) then
				call speech(info, character, true, tre("Na gut.", "Good."), gg_snd_Mathilda22)
				// Mathilda schließt sich dem Charakter an
				call Fellows.mathilda().shareWith(character)
				call this.close(character)
			else
				call character.displayMessage(ACharacter.messageTypeError, tre("Mathilda unterhält sich noch mit anderen Charakteren.", "Mathilda is still talking to other characters."))
				call this.showStartPage(character)
			endif
		endmethod

		// Du musizierst?
		private static method infoAction7 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Du musizierst?", "You are making music?"), null)
			call speech(info, character, true, tre("Ja, ich kann einige Lieder auf meiner Schalmei spielen. Die habe ich schon seit ich noch sehr jung war. Das ist wahrscheinlich der einzige Besitz, den ich wirklich vermissen würde, falls er mir mal abhanden käme.", "Yes, I can play some songs on my shawm. I've been around since I was very young. This is probably the only possession I would really miss if I would lose it."), gg_snd_Mathilda23)
			call speech(info, character, true, tre("Ich mache übrigens nicht nur Musik, sondern erzähle auch gerne Geschichten. Damit verdiene ich mir meinen Lebensunterhalt. Ich brauche ja nicht gerade viel zum Leben.", "I do not just make music, I like to tell stories. So I earn my livelihood. I do not need much to live."), gg_snd_Mathilda24)
			call speech(info, character, true, tre("Aber da hier ja bald die Hölle los sein wird, nach allem, was man so hört, verschwinde ich lieber bald wieder.", "But since the hell will soon be here, after all that you hear, I soon disappear again."), gg_snd_Mathilda25)
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
			call speech(info, character, false, tre("Was machst du in der Scheune?", "What are you doing in the barn?"), null)
			call speech(info, character, true, tre("Schlafen, was sonst? Oder soll ich hier draußen erfrieren? Der Bauer Manfred, ein sehr höflicher Mann, lässt mich dort umsonst übernachten.", "Sleep, what else? Or should I freeze here? The farmer Manfred, a very polite man, lets me stay there for nothing."), gg_snd_Mathilda26)
			call this.tellThatSleepingInBarn(character.player())
			call this.showStartPage(character)
		endmethod

		// Erzähl mir eine Geschichte.
		private static method infoAction9 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Erzähl mir eine Geschichte.", "Tell me a story."), null)
			if (not this.wasOffendedStories(character.player())) then
				call speech(info, character, true, tre("Gut, welche willst du hören?", "Well, what do you want to hear?"), gg_snd_Mathilda27)
				call this.showRange(this.m_infoTellAStory_Bear.index(), this.m_infoTellAStory_None.index(), character)
			else
				call speech(info, character, true, tre("Mit Sicherheit nicht. Erzähl dir doch selbst eine!", "Certainly not. Tell yourself one!"), gg_snd_Mathilda44)
				call this.showStartPage(character)
			endif
		endmethod

		private static method showSongs takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, true, tre("Gut, welches willst du hören?", "Well, what do you want to hear?"), gg_snd_Mathilda45)
			call this.showRange(this.m_infoPlayASong_War.index(), this.m_infoPlayASong_None.index(), character)
		endmethod

		// Spiel mir ein Lied.
		private static method infoAction10 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Spiel mir ein Lied.", "Play me a song."), null)
			if (not this.wasOffendedSongs(character.player())) then
				call thistype.showSongs(info, character)
			else
				call speech(info, character, true, tre("Bei dir hakt's wohl? Pfeif dir doch selbst eins!", "Are you crazy? Whistle yourself one!"), gg_snd_Mathilda50)
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
			call speech(info, character, false, tre("Du kannst gut erzählen und spielen. Hier hast du ein paar Goldmünzen.", "You can tell and play well. Here you have a few gold coins."), null)
			call character.removeGold(10)
			call this.offendStories(character.player(), false)
			call this.offendSongs(character.player(), false)
			call speech(info, character, true, tre("Oh danke. Das höre ich immer wieder gerne.", "Oh thank you. I always like to hear that."), gg_snd_Mathilda51)
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
			call speech(info, character, false, tre("Deine Geschichten scheinen einem Haufen Scheiße zu gleichen.", "Your stories seem like a bunch of shit."), null)
			call this.offendStories(character.player(), true)
			call speech(info, character, true, tre("Wenn's dir nicht passt, dann erzähl ich dir halt keine mehr!", "If it does not fit you, then I tell you no more!"), gg_snd_Mathilda52)
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
			call speech(info, character, false, tre("Deine Musik ist ungefähr so hörenswert wie Gebärdensprache.", "Your music is about as audible as sign language."), null)
			call this.offendSongs(character.player(), true)
			call speech(info, character, true, tre("Dir werd' ich sicher nicht nochmal ein Lied spielen!", "I will certainly not play song again!"), gg_snd_Mathilda53)
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
			call speech(info, character, false, tre("Weißt du, wo ich mir ein Instrument besorgen kann?", "Do you know where I can get an instrument?"), null)
			call speech(info, character, true, tre("In Talras gibt’s bestimmt irgendwo welche zu kaufen. Ansonsten wüsste ich aber auch nichts. Hier auf dem Hof scheint's wohl keine zu geben.", "In Talras there is definitely somewhere to buy them. Otherwise, I would have no idea. There seems o be none here on the farm."), gg_snd_Mathilda54)
			call speech(info, character, true, tre("Ich selbst habe mir meine Schalmei gebaut, doch das war mit viel Arbeit verbunden.", "I myself built my shawm, but that was connected with a lot of work."), gg_snd_Mathilda55)
			//(Mathilda fühlt sich angegriffen - egal ob bezüglich ihrer Musik oder Geschichten)
			if (this.wasOffendedStories(character.player()) or this.wasOffendedSongs(character.player())) then
				call speech(info, character, true, tre("Aber was willst du schon mit einem Instrument? Geschmack scheinst du ja nicht zu haben.", "But what do you want with an instrument?"), gg_snd_Mathilda56)
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
			call speech(info, character, false, tre("Kannst du mir auch ein Instrument bauen?", "Can you build me an instrument?"), null)
			call speech(info, character, true, tre("Das könnte ich tatsächlich, aber weißt du wie viel Arbeit das ist? Ich habe schon um meine eigene Schalmei Angst, denn ich habe sicher keine Lust mir eine neue zu bauen.", "Actually, I could, but do you know how much work that is? I've been sared for my own shawm, because I certainly do not want to build a new one."), gg_snd_Mathilda57)
			if (this.wasOffendedStories(character.player()) or this.wasOffendedSongs(character.player())) then // (Wurde beleidigt)
				call speech(info, character, true, tre("Aber dir werde ich sicher keine bauen, so wie du mich behandelst.", "But I will surely not build you one the way you treat me."), gg_snd_Mathilda58)
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
			call speech(info, character, false, tre("Baue mir eine Schalmei.", "Build me a shawm."), null)
			call speech(info, character, true, tre("Wenn du unbedingt willst, dann besorge mir das Holz dafür und sagen wir … 100 Goldmünzen. So habe ich wenigstens eine Zeit lang meine Ruhe und kann mich von der harten Arbeit erholen.", "If you really want to, get the wood for it and say ... 100 gold coins. So I have at least a time rest and can recover from the hard work."), gg_snd_Mathilda59)
			call speech(info, character, true, tre("Ich werde aber eine ganze Weile dafür brauchen, also gedulde dich.", "But I'll need quite a while for it, so be patient."), gg_snd_Mathilda60)
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
				call speech(info, character, false, tre("Hier sind das Holz und die Goldmünzen.", "Here is the wood and the gold coins."), null)
				// Give items to Mathilda.
				call character.inventory().removeItemTypeCount('I02P', 5)
				call SetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD) - 100)
				call speech(info, character, true, tre("Sieh an, dir ist es wirklich ernst damit. Na gut, aber wie gesagt gedulde dich. Handwerkliche Arbeit ist nicht gerade meine größte Leidenschaft, auch wenn ich nicht ganz ungeschickt bin.", "Look, it's really serious for you. Ok, but as I said, be patient. Craftsmanship is not exactly my greatest passion, even though I am not quite clumsy."), gg_snd_Mathilda61)
				call speech(info, character, true, tre("Komm von Zeit zu Zeit zu mir und ich sage dir wie weit ich bin.", "Come to me from time to time and I tell you how far I am."), gg_snd_Mathilda62)
				// Auftragsziel 2 des Auftrags „Die Schalmei“ abgeschlossen
				call QuestShawm.characterQuest(character).questItem(QuestShawm.questItemGiveGoldAndLumber).setState(QuestShawm.stateCompleted)
				call QuestShawm.characterQuest(character).questItem(QuestShawm.questItemGetTheInstrument).setState(QuestShawm.stateNew)
				call QuestShawm.characterQuest(character).displayState()
				call QuestShawm.characterQuest(character).startConstructionTimer()
			else
				call character.displayHint(tre("Nicht genügend Goldmünzen dabei.", "Not enough gold coins."))
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
			call speech(info, character, false, tre("Ist die Schalmei fertig?", "Have you finished the shawm?"), null)
			// (Schalmei ist fertig)
			if (QuestShawm.characterQuest(character).finishedConstruction()) then
				call speech(info, character, true, tre("Ja, hier hast du sie und passe gut darauf auf. Ich hoffe du kannst sie auch spielen.", "Yes, here you have it and take good care of it. I hope you can play it, too."), gg_snd_Mathilda63)
				// Auftrag „Die Schalmei“ abgeschlossen
				call QuestShawm.characterQuest(character).complete()
			// (Schalmei ist noch nicht fertig)
			else
				call speech(info, character, true, tre("Gedulde dich noch etwas. Heute ist nicht gerade mein Tag. Vielleicht arbeite ich morgen daran weiter, mal sehen.", "Be patient. Today is not exactly my day. Maybe, I'll work on it tomorrow, let's see."), gg_snd_Mathilda64)
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
			call speech(info, character, false, tre("Lass uns musizieren.", "Let us play music."), null)
			// (Mathilda ist beleidigt)
			if (this.wasOffendedStories(character.player()) or this.wasOffendedSongs(character.player())) then
				call speech(info, character, true, tre("Lass mich in Ruhe!", "Leave me alone!"), gg_snd_Mathilda65)
			// (Mathilda ist nicht beleidigt)
			else
				call speech(info, character, true, tre("Nun gut! Fang an!", "Well! Start!"), gg_snd_Mathilda66)
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
			call speech(info, character, false, tre("Bring mir das Hexenlied bei.", "Teach me the witch song."), null)
			call speech(info, character, true, tre("Du hast also gut aufgepasst bei meiner Geschichte.", "So you've listened very carefully to my story."), gg_snd_Mathilda67)
			// (Mathilda ist beleidigt)
			if (this.wasOffendedStories(character.player()) or this.wasOffendedSongs(character.player())) then
				call speech(info, character, true, tre("Aber so wie du mich behandelst bringe ich dir gar nichts bei.", "But as you treat me, I do not teach you anything."), gg_snd_Mathilda68)
			// (Mathilda ist nicht beleidigt)
			else
				call speech(info, character, true, tre("Zur Belohnung werde ich dir das Lied beibringen.", "For the reward I will teach you the song."), gg_snd_Mathilda69)
				call speech(info, character, true, tre("Wusstest du, dass ich einst mit den Hexen umherzog? Doch erzähle das keinem hier, versprich mir das!", "Did you know I used to go with witches? But do not tell anyone here, promise me that."), gg_snd_Mathilda70)
				call speech(info, character, false, tre("Sicher.", "For sure."), null)
				call speech(info, character, true, tre("Gut, so geht das Lied …", "Good, the song goes like that ..."), gg_snd_Mathilda71)
				// (Charakter erlernt die Fähigkeit mit der Schalmei einen Riesen auf seine Seite zu bringen)
				// Switch the instrument by another one.
				call character.inventory().removeItemType(QuestShawm.itemTypeId)
				call character.giveQuestItem('I083')
			endif

			call this.showStartPage(character)
		endmethod

		// Aber sicher doch.
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Aber sicher doch.", "Of course."), null)
			call thistype.showSongs(info, character)
		endmethod

		// Nein, lieber nicht.
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Nein, lieber nicht.", "No rather not."), null)
			call speech(info, character, true, tre("Schade, aber vielleicht möchtest du ja später eins hören.", "Too bad, but maybe you want to hear one later."), gg_snd_Mathilda4)
			call this.showStartPage(character)
		endmethod

		// Die Geschichte vom Bären.
		private static method infoAction9_0 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Die Geschichte vom Bären.", "THe story of the bear."), null)
			call speech(info, character, true, tre("Es war einmal ein Bär, der wanderte durch den Wald und dann fiel ein Baum um und erschlug den Bären.", "Once upon a time there was a bear wandering through the forest and then a tree fell and killed the bear."), gg_snd_Mathilda28)
			call speech(info, character, true, tre("Es war einmal ein Mann, der einen Bären sah, der durch den Wald wanderte und dann fiel ein Baum um und erschlug den Bären.", "Once upon a time there was a man who saw a bear wandering through the forest and then a tree fell and killed the bear."), gg_snd_Mathilda29)
			call speech(info, character, true, tre("Es war einmal ein anderer Mann, der einen Mann sah, der einen Bären sah, der durch den Wald wanderte und dann fiel ein Baum um und erschlug den Bären.", "Once upon a time there was another man who saw a man who saw a bear wandering through the forest and then a tree fell and killed the bear."), gg_snd_Mathilda30)
			call speech(info, character, true, tre("Es war einmal ein weiterer Mann, der einen anderen Mann sah, der einen Mann sah, der einen Bären sah, der durch den Wald wanderte und dann fiel ein Baum um und erschlug den Bären.", "Once upon a time there was another man who saw another man who saw a man who saw a bear wandering through the forest and then a tree fell and killed the bear."), gg_snd_Mathilda31)
			call speech(info, character, true, tre("Es war einmal …", "Once upon a time ..."), gg_snd_Mathilda32)
			call speech(info, character, false, tre("Danke, ich glaube das reicht.", "Thanks, I think that's enough."), null)
			call this.showStartPage(character)
		endmethod

		// Der Ork und der Wolf.
		private static method infoAction9_1 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Der Ork und der Wolf.", "The Orc and the Wolf."), null)
			call speech(info, character, true, tre("Vor langer langer Zeit, da lebte ein Ork in einer Höhle in den Bergen. Er war sehr einsam dort, denn in den Bergen lebten nur Tiere und keiner mit dem er sich hätte unterhalten können.", "Long ago, an Orc lived in a cave in the mountains. He was very lonely there, beause in the mountains lived only animals and no one with whom he could have talked."), gg_snd_Mathilda33)
			call speech(info, character, true, tre("Doch eines Tages, als der Ork sich auf die jagt begab, da traf er auf einen Wolf in der Wildnis und als sich der Ork dem Wolf näherte, da sprach der Wolf: „Wenn du mich tötest, dann bleibst du allein.“.", "But one day, when the Orc went hunting, he met a wolf in the wilderness, and when the Or approached the wolf, the wolf said \"If you kill me, then you will be left alone.\"."), gg_snd_Mathilda34)
			call speech(info, character, true, tre("Der Ork antwortete erstaunt: „Sag mir Wolf, wie kommt es dass ich dich verstehe?“.", "The Orc replied in amazement: \"Tell me wolf, how come I understand you?\"."), gg_snd_Mathilda35)
			call speech(info, character, true, tre("Der Wolf aber antwortete: „Sag mir Ork, wie kommt es, dass du mir zuhörst?“.", "But the wolf answered, \"Tell Orc, how is it that you are listening to me?\"."), gg_snd_Mathilda36)
			call speech(info, character, true, tre("Der Ork war verwundert, aber auch froh nach so langer Zeit wieder jemanden getroffen zu haben, mit dem er sich unterhalten konnte. Also fragte er den Wolf: „Sag Wolf, wenn ich dich verschone, begleitest du mich dann?“.", "The Orc was surprised, but glad to have met someone with whom he could talk. So he asked the wolf: \"Tell wolf, if I spare you, will you accompany me?\"."), gg_snd_Mathilda37)
			call speech(info, character, true, tre("Der Wolf antwortet daraufhin: „Sicher Ork, das werde ich.“. So gingen die beiden zusammen zur Höhle des Orks. Doch als sie dort ankamen sprach der Wolf: „Sieh Ork, verschont hast du mich und ich habe dich begleitet. Nun haben wir beide unser Wort gehalten, doch sieh welche Höhle du mir gezeigt hast, so warm und so groß.“. Da fraß der Wolf den Ork.", "The wolf replied, \"Surely Orc, I will.\". So they both went to the cave of the Orc. But when they got there, the wolf said, \"Look Orc, you spared me and I accompanied you. Now we have both kept our word, but see what cave you showed me, so warm and so great.\". Then the wolf ate the Orc."), gg_snd_Mathilda38)
			call this.showStartPage(character)
		endmethod

		// Das Hexenlied.
		private static method infoAction9_2 takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Das Hexenlied.", "The witch song."), null)
			call speech(info, character, true, tre("Im nordöstlichen Wald von Talras, auf der anderen Seite des Flusses dort leben die alten verstoßenen Hexen. Einst gefürchtet von den Bewohnern Talras' plagt sie nun die unendliche Einsamkeit.", "In the northeastern forest of Talras, on the other side of the river there live the ancient witches. Once feared by the inhabitants of Talras, it now pervades them the infinite solitude."), gg_snd_Mathilda39)
			call speech(info, character, true, tre("Man erzählt sich, sie hätten schließlich Freundschaft mit den Riesen geschlossen, um ihrer Einsamkeit zu entgehen. Die Riesen, ebenfalls gefürchtet von jedem Bewohner in Talras, gingen tatsächlich auf diese Freundschaft ein.", "It is said that they had finally made friends with the giants to escape their loneliness, The giants, also feared by any inhabitant in Talras, actually went into this friendship."), gg_snd_Mathilda40)
			call speech(info, character, true, tre("Die Hexen spielten ein verzaubertes Lied und die Riesen folgten ihrem Befehl. Nun gehorchen sie den Hexen und wann immer man auf eine Hexe trifft, da ist auch ein Riese nicht weit.", "The witches played an enchanted song and the giants followed their order. Now they obey the witches and whenever a you meet a witch, there is also a giant not far."), gg_snd_Mathilda41)
			call speech(info, character, true, tre("Doch höre, wer auch immer das Lied spielen kann, dem wird auch der Riese folgen.", "But listen, whoever can play the song, the giant will follow him."), gg_snd_Mathilda42)
			// (Charakter erhält Hinweis, dass man mit dem Lied Riesen für sich gewinnen kann)
			call character.displayHint(tre("Mit dem Hexenlied kann der Charakter Riesen für sich gewinnen.", "With the witch song the character can win giants for himself."))
			call this.showStartPage(character)
		endmethod

		// Keine. Ich hab's mir anders überlegt.
		private static method infoAction9_3 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Keine. Ich hab's mir anders überlegt.", "None. I thought about it differently."), null)
			call speech(info, character, true, tre("Wie du meinst.", "As you like."), gg_snd_Mathilda43)
			call this.showStartPage(character)
		endmethod

		private method playSongEx takes Character character returns nothing
			// Erfahrungsbonus (Hört das Lied zum ersten Mal)
			if (not this.playedSong(character.player())) then
				call character.xpBonus(50, tre("Ihr genießt die Musik!", "You enjoy the music!"))
			endif

			call this.playSong(character.player())
		endmethod

		// Das Lied des Krieges.
		private static method infoAction10_0 takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Das Lied des Krieges.", "The song of war."), null)
			call speech(info, character, true, tre("Der Rittersmann, von unweit her, ward vom König selbst gerufen, er kam in Rüstung, samt dem Speer, mit Legenden, die ihn schufen. Träumte er von Ruhm und Stolz, so war sein Speer doch nur aus Holz, und als er vor dem Drachen stand, setzte dieser ihn in Brand. So brannten Ritter und die Sagen, an denen sich die Jungen laben, Am Ende bleibt der Tod, nicht mehr, so lange ist es gar nicht her!", "The knight from nearby, was called by the king himself, he came in armor, with the spear, with legends that created him. If he dreamed of glory and pride, his spear was only made of wood, and when he stood before the dragon, the latter set him on fire. Thus the knight and the legends burned in which the boys were lividing. In the end, death remains, not more, it's not been that long ago!"), gg_snd_Mathilda46)

			call this.playSongEx(character)
			call this.showStartPage(character)
		endmethod

		// Der Wandersmann.
		private static method infoAction10_1 takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Der Wandersmann.", "The wayfarer."), null)
			call speech(info, character, true, tre("Der Tag neigt sich dem Ende zu, und alle Vögel werden müde, nur einer, der gibt keine Ruh', in seiner Heimat ist man prüde. Er lief, ja rannte über Berge, traf fremde Wesen, auch die Zwerge, doch sollt er einen Menschen sehn, würd' er gleich wieder rückwärts gehen, sich glücklich an den Seinen rächen, gar jedem mal das Herz zerstechen, denn jeder seiner eignen Leut', hat zu viel Liebe stets gescheut. Ja dort in seiner alten Heimat, ist weder Mauer, noch ein Tor, doch wär' ihm eine neue Bleibe, gar lieber als das triste Moor.", "The day is drawing to a close, and all the birds are weary, only one who gives no rest, in his homeland one is prudish. He ran, ran over mountains, met strange beings, even the dwarfs, but if he were to see a man, he would immediately go backwards, revenge himself with his own, punish every heart, for every one of his own people. Has always spared too much love. Yes, there in his old home, is neither wall nor gate, but he would prefer a new place over the dreary bog."), gg_snd_Mathilda47)

			call this.playSongEx(character)
			call this.showStartPage(character)
		endmethod

		// Die Waldgeister.
		private static method infoAction10_2 takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Die Waldgeister.", "The forest spirits."), null)
			call speech(info, character, true, tre("Im alten Wald, am großen Fluss, durch den ich täglich waten muss, dort traf ich traurig wie ich war, die mystisch schöne Geisterschaar. Sie gaben mir, was ich vermisst, doch war es eine große List, Denn wollten sie nicht meinen Segen, stattdessen nur den eignen Regen, der kommt, wenn man aus einem Rachen, mal etwas hört wie sanftes Lachen. Und wenns vergeht, ist's auch nicht schlimm, der Geist behält ja seine Stimm', kann Lieder singen, selbst oft lachen, er muss nun über gar nichts wachen, gestorben ist er sowieso, doch fragt mein Herz sich wo.", "In the old forest, on the big river, through which I have to wade every day, I met sad as I was, the mystially beautiful ghosts. They gave me what I missed, but it was a great trick, for they did not want my blessing, instead only their own rain coming from a throat something like gentle laughter. And when it goes by, it is not bad, the ghost its voie, can sing songs, laugh often, he does not have to watch anything, he is dead anyway, but my heart wonders where."), gg_snd_Mathilda48)

			call this.playSongEx(character)
			call this.showStartPage(character)
		endmethod

		// Keines. Ich hab's mir anders überlegt.
		private static method infoAction10_3 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Keines. Ich hab's mir anders überlegt.", "None. I thought about it differently."), null)
			call speech(info, character, true, tre("Deine Entscheidung.", "Your decision."), gg_snd_Mathilda49)
			call this.showStartPage(character)
		endmethod

		// (Mathilda begleitet den Charakter)
		private static method infoConditionLeave takes AInfo info, ACharacter character returns boolean
			return Fellows.mathilda().isSharedToCharacter() and Fellows.mathilda().character() == character
		endmethod

		// Geh.
		private static method infoActionLeave takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Geh.", "Leave."), null)
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
			call speech(info, character, true, tre("Lass mich in Ruhe!", "Leave me alone!"), gg_snd_Mathilda72)
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

			call this.setName(tre("Mathilda", "Mathilda"))

			// start page
			set this.m_infoHi = this.addInfo(false, false, 0, thistype.infoAction0, tre("Hallo.", "Hello.")) // 0

			set this.m_infoWhereFrom = this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoAction1, tre("Woher kommst du?", "Where are you from?")) // 1
			set this.m_infoAboutTheFarm = this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoAction2, tre("Was hältst du vom Bauernhof?", "What do you think about the farm?")) // 2
			set this.m_infoHoneyPot = this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tre("Hier hast du einen Honigtopf!", "Here you have a honeypot!")) // 3
			set this.m_infoBigHoneyPot = this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tre("Hier hast du einen großen Honigtopf!", "Here you have a big honey pot!")) // 4
			set this.m_infoAnnoyingLothar = this.addInfo(false, true, thistype.infoCondition5, thistype.infoAction5, null) // 5
			set this.m_infoLetsGo = this.addInfo(true, false, thistype.infoCondition6, thistype.infoAction6, tre("Lass uns umherziehen!", "Let's move!")) // 6

			set this.m_infoAboutMusic = this.addInfo(true, false, thistype.infoConditionAfterGreeting, thistype.infoAction7, tre("Du musizierst?", "You are making music?")) // 7
			set this.m_infoBarn = this.addInfo(false, false, thistype.infoCondition8, thistype.infoAction8, tre("Was machst du in der Scheune?", "What are you doing in the barn?")) // 8
			set this.m_infoTellAStory = this.addInfo(true, false, thistype.infoConditionAfterGreeting, thistype.infoAction9, tre("Erzähl mir eine Geschichte.", "Tell me a story.")) // 9
			set this.m_infoPlayASong = this.addInfo(true, false, thistype.infoConditionAfterGreeting, thistype.infoAction10, tre("Spiel mir ein Lied.", "Play me a song.")) // 10
			set this.m_infoGoodStoriesAndSongs = this.addInfo(true, false, thistype.infoCondition11, thistype.infoAction11, tre("Du kannst gut erzählen und spielen. Hier hast du ein paar Goldmünzen (10 Goldmünzen geben).", "You can tell and play well. Here you have a few gold coins (give 10 gold coins).")) // 11
			set this.m_infoBadStories = this.addInfo(true, false, thistype.infoCondition12, thistype.infoAction12, tre("Deine Geschichten scheinen einem Haufen Scheiße zu gleichen.", "Your stories seem like a bunch of shit.")) // 12
			set this.m_infoBadSongs = this.addInfo(false, false, thistype.infoCondition13, thistype.infoAction13, tre("Deine Musik ist ungefähr so hörenswert wie Gebärdensprache.", "Your music is about as audible as sign language.")) // 13
			set this.m_infoGetInstrument = this.addInfo(false, false, thistype.infoCondition14, thistype.infoAction14, tre("Weißt du, wo ich mir ein Instrument besorgen kann?", "Do you know where I can get an instrument?")) // 14
			set this.m_infoBuildInstrument = this.addInfo(true, false, thistype.infoConditionBuildInstrument, thistype.infoActionBuildInstrument, tre("Kannst du mir auch ein Instrument bauen?", "Can you build me an instrument?"))
			set this.m_infoBuildMeAnInstrument = this.addInfo(false, false, thistype.infoConditionBuildMeAnInstrument, thistype.infoActionBuildMeAnInstrument, tre("Baue mir eine Schalmei.", "Build me a shawm."))
			set this.m_infoLumberAndGold = this.addInfo(false, false, thistype.infoConditionLumberAndGold, thistype.infoActionLumberAndGold, tre("Hier sind das Holz und die Goldmünzen.", "Here is the wood and the gold coins."))
			set this.m_infoFinishedInstrument = this.addInfo(true, false, thistype.infoConditionFinishedInstrument, thistype.infoActionFinishedInstrument, tre("Ist die Schalmei fertig?", "Have you finished the shawm?"))
			set this.m_infoPlayMusic = this.addInfo(true, false, thistype.infoConditionPlayMusic, thistype.infoActionPlayMusic, tre("Lass uns musizieren.", "Let us play music."))
			set this.m_infoWitchSong = this.addInfo(true, false, thistype.infoConditionWitchSong, thistype.infoActionWitchSong, tre("Bring mir das Hexenlied bei.", "Teach me the witch song."))
			set this.m_infoExit = this.addExitButton() // 15

			// info 0
			set this.m_infoHi_YesSong = this.addInfo(false, false, 0, thistype.infoAction0_0, tre("Aber sicher doch.", "Of course.")) // 16
			set this.m_infoHi_NoSong = this.addInfo(false, false, 0, thistype.infoAction0_1, tre("Nein, lieber nicht.", "No rather not.")) // 17

			// info 9
			set this.m_infoTellAStory_Bear = this.addInfo(true, false, 0, thistype.infoAction9_0, tre("Die Geschichte vom Bären.", "THe story of the bear.")) // 18
			set this.m_infoTellAStory_OrcAndWolf = this.addInfo(true, false, 0, thistype.infoAction9_1, tre("Der Ork und der Wolf.", "The Orc and the Wolf.")) // 19
			set this.m_infoTellAStory_WitchSong = this.addInfo(true, false, 0, thistype.infoAction9_2, tre("Das Hexenlied.", "The witch song.")) // 20
			set this.m_infoTellAStory_None = this.addInfo(true, false, 0, thistype.infoAction9_3, tre("Keine. Ich hab's mir anders überlegt.", "None. I thought about it differently.")) // 21

			// info 10
			set this.m_infoPlayASong_War = this.addInfo(true, false, 0, thistype.infoAction10_0, tre("Das Lied des Krieges.", "The song of war.")) // 22
			set this.m_infoPlayASong_Wayfarer = this.addInfo(true, false, 0, thistype.infoAction10_1, tre("Der Wandersmann.", "The wayfarer.")) // 23
			set this.m_infoPlayASong_ForestSpirits = this.addInfo(true, false, 0, thistype.infoAction10_2, tre("Die Waldgeister.", "The forest spirits.")) // 24
			set this.m_infoPlayASong_None = this.addInfo(true, false, 0, thistype.infoAction10_3, tre("Keines. Ich hab's mir anders überlegt.", "None. I thought about it differently.")) // 25

			set this.m_infoLeave = this.addInfo(true, false, thistype.infoConditionLeave, thistype.infoActionLeave, tre("Geh.", "Leave.")) // 26

			set this.m_goAway = this.addInfo(true, true, thistype.infoConditionGoAway, thistype.infoActionGoAway, "")

			return this
		endmethod

		implement Talk
	endstruct

endlibrary