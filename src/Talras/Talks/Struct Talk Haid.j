library StructMapTalksTalkHaid requires Asl, StructGameCharacter, StructMapQuestsQuestGoldForTheTradingPermission, StructMapTalksTalkFerdinand

	struct TalkHaid extends Talk
		private boolean array m_completedWithCostKnowledge[12] /// @todo MapSettings.maxPlayers()
		private AInfo m_whoAreYou
		private AInfo m_notInCastle
		private AInfo m_invasion
		private AInfo m_whatDoesTheKingSay
		private AInfo m_help
		private AInfo m_gold
		private AInfo m_goldBack
		private AInfo m_exit

		private method completeWithCostKnowledge takes player whichPlayer returns nothing
			set this.m_completedWithCostKnowledge[GetPlayerId(whichPlayer)] = true
		endmethod

		private method completedWithCostKnowledge takes player whichPlayer returns boolean
			return this.m_completedWithCostKnowledge[GetPlayerId(whichPlayer)]
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		// Wer bist du?
		private static method infoActionWhoAreYou takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wer bist du?", "Who are you?"), null)
			call speech(info, character, true, tre("Ich bin Haid, ein fahrender Händler aus Trammar. Interessierst du dich zufällig für eine meiner Waren?", "I am Haid a traveling salesman. Do you happen to be interested in one of my goods?"), gg_snd_Haid1)
			call speech(info, character, false, tre("Was verkaufst du denn?", "What are you selling?"), null)
			call speech(info, character, true, tre("Etwas zu essen und alles was man im Alltag gebrauchen kann: Brot, Äpfel, Wurst, Geschirr und noch vieles mehr.", "Something to eat and all you can use in everyday life: bread, apples, sausage, dishes and much more."), gg_snd_Haid2)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionNotInCastle takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Wieso verkaufst du deine Waren nicht in der Burg?
		private static method infoActionNotInCastle takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wieso verkaufst du deine Waren nicht in der Burg?", "Why don't you sell your goods in the castle?"), null)
			call speech(info, character, true, tre("Nun, ich bin ein fahrender Händler und die sieht man hier gar nicht mehr so gerne.", "Well, I'm a traveling salesman, and those one sees no longer here so much."), gg_snd_Haid3)
			call speech(info, character, true, tre("Das Misstrauen ist seit Beginn der Invasion einfach zu groß geworden und hier gibt es schon mehr als genug Händler. Außerdem besitze ich nicht das nötige Kleingeld, um mir einen Platz in der Burg zu erwerben.", "Mistrust has simply become too big since the invasion and there are already more than enough merchants. Besides I do not have the where withal to earn me a place in the castle."), gg_snd_Haid4)
			call info.talk().showStartPage(character)
		endmethod

		//  (Nach „Wieso verkaufst du deine Waren nicht in der Burg?“))
		private static method infoConditionInvasion takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_notInCastle.index(), character)
		endmethod

		// Invasion?
		private static method infoActionInvasion takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Invasion?", "Invasion?"), null)
			call speech(info, character, true, tre("Wo kommst du denn her oder gefällt dir der Ausdruck etwa nicht? Du glaubst doch nicht das Geschwafel unseres verehrten Herrn Königs oder doch?", "Where did you come from or do you not like the term about? You do not believe the ramblings of our honorable king or do you?"), gg_snd_Haid5)
			call speech(info, character, true, tre("Jeder hier weiß, dass diese verdammten Dunkelelfen einen Packt mit den Orks geschlossen haben. Ich habe selbst gesehen, wie diese Schweinehunde meine Heimatstadt Trammar in Flammen aufgehen ließen.", "Everyone knows that those damned Dark Elves made a pact with the Orcs. I saw for myself how those bastards let my hometown Trammar go up in flames."), gg_snd_Haid6)
			call speech(info, character, true, tre("Bin gerade nochmal so mit dem Leben davon gekommen! Der König unterschätzt die Lage vollkommen. Trammar war verdammt gut befestigt und wurde innerhalb eines einzigen Tages eingenommen.", "Just performaed again to escape with my life! The king underestimated the situation completely. Trammar was damn well secured and was taken in a single day."), gg_snd_Haid7)
			call speech(info, character, true, tre("Diese Burg hier hat zwar eine bessere Lage, aber das wird ihr nichts nützen wenn erst mal hunderte von Orks und Dunkelelfen hier anrücken.", "Although this castle here has a better location, but that it won't benefit from once hundreds of Orcs and Dark Elves advance here."), gg_snd_Haid8)
			call speech(info, character, true, tre("Aber welche Wahl hab ich denn? Ich muss mir ein paar Goldmünzen dazu verdienen und vom Gewinn leben. Danach hau ich so schnell wie möglich ab und dir würde ich genau das Gleiche raten.", "But what choice have I? I have to earn a few gold coins and to live off the profits. Then I cut it as soon as possible from here and I would recommend to you exactly the same thing."), gg_snd_Haid9)
			call speech(info, character, true, tre("Sicher, du wirst hier bestimmt einige treffen, die frohen Mutes dem Feind trotzen wollen, aber haben die etwa ihre Heimat untergehen sehen? Ich sag's dir Junge: Dieses Königreich wird untergehen!", "Sure, you'll meet some here who are determined to defy the enemy with good cheer, but have they seen their home perishing? I'm telling you boy: This kingdom will perish!"), gg_snd_Haid10)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Invasion?“)
		private static method infoConditionWhatDoesTheKingSay takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_invasion.index(), character)
		endmethod

		// Was sagt denn der König?
		private static method infoActionWhatDoesTheKingSay takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was sagt denn der König zur Invasion?", "What says the king about the invasion?"), null)
			call speech(info, character, true, tre("Der König? Dieser miese Sack, der behauptet doch glatt, dass es sich nur um kleinere Überfälle handele. Hab's nicht glauben wollen als ich's von einem Jäger gehört habe.", "The king? This lousy bag claims that it was only smaller raids. I did not want to believe it when I heard it from a hunter."), gg_snd_Haid11)
			call speech(info, character, true, tre("Verdammte Scheiße, wozu haben wir denn den ganzen Adel mit all seinen Vasallen? Wollen die sich ewig nur um ihr beschissenes Gut streiten?", "Bloody hell, what do we have all the nobility with all its vassals for? Do they want to argue only about their shitty good forever?"), gg_snd_Haid12)
			call speech(info, character, true, tre("Die sollen gefälligst ein Heer aufstellen! Ich hab viele gute Freunde in Trammer verloren. Dieser Dreckskönig, wenn ich ...", "They should kindly set forth a multitude! I lost many good friends in Trammar. This filth king, if I ..."), gg_snd_Haid13)
			call speech(info, character, true, tre("Erzähl aber keinem, dass ich so von ihm geredet habe, sonst lande ich noch am Pranger oder schlimmer noch am Galgen.", "But don't tell anybody that I have spoken thus of him, otherwise I will land pilloried or worse on the gallows."), gg_snd_Haid14)
			call speech(info, character, false, tre("Keine Sorge.", "Do not worry."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Wieso verkaufst du deine Waren nicht in der Burg?“)
		private static method infoConditionHelp takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_notInCastle.index(), character)
		endmethod

		// Kann ich dir irgendwie helfen?
		private static method infoActionHelp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kann ich dir irgendwie helfen?", "Can I help you?"), null)
			call speech(info, character, true, tre("Du willst mir helfen? Wieso solltest du das tun?", "You want to help me? Why would you do that?"), gg_snd_Haid15)
			call speech(info, character, false, tre("Wieso nicht?", "Why not?"), null)
			call speech(info, character, true, tre("Wenn du mir wirklich helfen willst, dann gib mir ein paar Goldmünzen, damit ich den Vogt dafür bezahlen kann, in die Burg eingelassen zu werden.", "If you really want to help me, give me a few gold coins, so I can pay the steward for being admitted into the castle."), gg_snd_Haid16)
			call speech(info, character, false, tre("Wie viele brauchst du denn?", "How many do you need?"), null)
			call speech(info, character, true, tre("40 Goldmünzen würden schon reichen.", "40 gold coins were already enough."), gg_snd_Haid17)
			call QuestGoldForTheTradingPermission.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat Auftrag "Gold für die Handelsgenehmigung" und die entsprechenden Goldmünzen)
		private static method infoConditionGold takes AInfo info, ACharacter character returns boolean
			local player user = character.player()
			local boolean result = QuestGoldForTheTradingPermission.characterQuest(character).state() == QuestGoldForTheTradingPermission.stateNew and ((GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) >= 40 and not TalkFerdinand.talk().knowsCost(character)) or (GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) >= 10 and TalkFerdinand.talk().knowsCost(character)))
			set user = null
			return result
		endmethod

		// Hier hast du deine Goldmünzen.
		private static method infoActionGold takes AInfo info, Character character returns nothing
			local player user = character.player()

			if (TalkFerdinand.talk().knowsCost(character) and GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) >= 10) then // Charakter hat vom Vogt erfahren, wie viel eine Handelsgenehmigung kostet.
				call speech(info, character, false, tre("Hier hast du deine 10 Goldmünzen. Ich habe mal mit dem Vogt gesprochen. Willst du mich verarschen oder was?", "Here you have your 10 gold coins. I spoke once with the steward. Are you kidding me or what?"), null)
				call speech(info, character, true, tre("Tut mir leid, aber so ist nun mal das Leben. Kriegst auch eine große Stärkung mit dazu.", "I'm sorry, but that's life. You get als o a great snack with it."), gg_snd_Haid18)
				call SetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) - 10)
				// große Stärkung geben
				call QuestGoldForTheTradingPermission.characterQuest(character).improveReward()
				call thistype(info.talk()).completeWithCostKnowledge(character.player())

				call QuestGoldForTheTradingPermission.characterQuest(character).complete()
			elseif (GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) >= 40) then
				call speech(info, character, false, tre("Hier hast du deine 40 Goldmünzen.", "Here you have your 40 gold coins."), null)
				call speech(info, character, true, tre("Danke vielmals. Hier hast du eine kleine Stärkung.", "Thank you very much. Here you have a little snack."), gg_snd_Haid19)
				call SetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) - 40)
				// kleine Stärkung geben (nichts ändern)
				call character.giveItem('I03O')
				call character.giveItem('I03O')
				call character.giveItem('I016')
				call character.giveItem('I016')

				call QuestGoldForTheTradingPermission.characterQuest(character).complete()
			else
				call speech(info, character, false, tre("Da habe ich mich wohl vertan. Ich habe nicht genügend Goldmünzen dabei.", "I was probably wrong. I do not have enough gold coins."), null)
			endif

			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat Auftrag „Gold für die Handelsgenehmigung“ mit normaler Belohnung abgeschlossen und vom Vogt erfahren, dass eine Handelsgenehmigung weniger kostet)
		private static method infoConditionGoldBack takes AInfo info, ACharacter character returns boolean
			return QuestGoldForTheTradingPermission.characterQuest(character).isCompleted() and TalkFerdinand.talk().knowsCost(character) and not thistype(info.talk()).completedWithCostKnowledge(character.player())
		endmethod

		// Gib mir meine 30 Goldmünzen!
		private static method infoActionGoldBack takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Gib mir meine 30 Goldmünzen!", "Give me my 30 gold coins!"), null)
			call speech(info, character, true, tre("Was? Welche 30 Goldmünzen?", "What? What 30 gold coins?"), gg_snd_Haid20)
			call speech(info, character, false, tre("Das weißt du ganz genau, du Penner! Ich hab mal mit dem Vogt gesprochen.", "You know perfectly well, you bum! I once talked to the steward."), null)
			call speech(info, character, true, tre("Oh, verdammte Scheiße. Hier hast du sie. Erstick an deinem Scheißgold!", "Oh, bloody hell. Here you have it. Choke on your shit gold!"), gg_snd_Haid21)
			call SetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD) + 30)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.haid(), thistype.startPageAction)

			// start page
			set this.m_whoAreYou = this.addInfo(false, false, 0, thistype.infoActionWhoAreYou, tre("Wer bist du?", "Who are you?"))
			set this.m_notInCastle = this.addInfo(false, false, thistype.infoConditionNotInCastle, thistype.infoActionNotInCastle, tre("Wieso verkaufst du deine Waren nicht in der Burg?", "Why don't you sell your goods in the castle?"))
			set this.m_invasion = this.addInfo(true, false, thistype.infoConditionInvasion, thistype.infoActionInvasion, tre("Invasion?", "Invasion?"))
			set this.m_whatDoesTheKingSay = this.addInfo(true, false, thistype.infoConditionWhatDoesTheKingSay, thistype.infoActionWhatDoesTheKingSay, tre("Was sagt denn der König zur Invasion?", "What says the king about the invasion?"))
			set this.m_help = this.addInfo(false, false, thistype.infoConditionHelp, thistype.infoActionHelp, tre("Kann ich dir irgendwie helfen?", "Can I help you?"))
			set this.m_gold = this.addInfo(true, false, thistype.infoConditionGold, thistype.infoActionGold, tre("Hier hast du deine Goldmünzen.", "Here you have your gold coins."))
			set this.m_goldBack = this.addInfo(false, false, thistype.infoConditionGoldBack, thistype.infoActionGoldBack, tre("Gib mir meine 30 Goldmünzen!", "Give me my 30 gold coins!"))
			set this.m_exit = this.addExitButton()

			return this
		endmethod

		implement Talk
	endstruct

endlibrary
