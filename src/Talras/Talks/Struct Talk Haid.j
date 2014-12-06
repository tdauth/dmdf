library StructMapTalksTalkHaid requires Asl

	struct TalkHaid extends ATalk
		private boolean array m_completedWithCostKnowledge[6] /// @todo MapData.maxPlayers

		implement Talk

		private method completeWithCostKnowledge takes player whichPlayer returns nothing
			set this.m_completedWithCostKnowledge[GetPlayerId(whichPlayer)] = true
		endmethod

		private method completedWithCostKnowledge takes player whichPlayer returns boolean
			return this.m_completedWithCostKnowledge[GetPlayerId(whichPlayer)]
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(4, character)
		endmethod

		// Wer bist du?
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wer bist du?"), null)
			call speech(info, character, true, tr("Ich bin Haid, ein fahrender Händler aus Trammar. Interessierst du dich zufällig für eine meiner Waren?"), null)
			call speech(info, character, false, tr("Was verkaufst du denn?"), null)
			call speech(info, character, true, tr("Alles was man im Alltag gebrauchen kann: Brot, Äpfel, Wurst, Geschirr und noch vieles mehr."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Wieso verkaufst du deine Waren nicht in der Burg?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wieso verkaufst du deine Waren nicht in der Burg?"), null)
			call speech(info, character, true, tr("Nun, ich bin ein fahrender Händler und die sieht man hier gar nicht mehr so gerne."), null)
			call speech(info, character, true, tr("Das Misstrauen ist seit Beginn der Invasion einfach zu groß geworden und hier gibt es schon mehr als genug Händler. Außerdem besitze ich nicht das nötige Kleingeld, um mir einen Platz in in der Burg zu erwerben."), null)
			call info.talk().showRange(5, 7, character)
		endmethod

		// (Charakter hat Auftrag "Gold für die Handelsgenehmigung" und die entsprechenden Goldmünzen)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			local player user = character.player()
			local boolean result = QuestGoldForTheTradingPermission.characterQuest(character).state() == AAbstractQuest.stateNew and ((GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) >= 40 and not TalkFerdinand.talk().knowsCost(character)) or (GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) >= 10 and TalkFerdinand.talk().knowsCost(character)))
			set user = null
			return result
		endmethod

		// Hier hast du deine Goldmünzen.
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			local player user = character.player()
			if (TalkFerdinand.talk().knowsCost(character)) then // Charakter hat vom Vogt erfahren, wie viel eine Handelsgenehmigung kostet.
				call speech(info, character, false, tr("Hier hast du deine 10 Goldmünzen. Hab mal mit dem Vogt gesprochen. Willst du mich verarschen oder was?"), null)
				call speech(info, character, true, tr("Tut mir leid, aber so ist nun mal das Leben. Kriegst auch eine große Stärkung mit dazu."), null)
				call SetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) - 10)
				// große Stärkung geben
				call QuestGoldForTheTradingPermission.characterQuest(character).improveReward()
				call thistype(info.talk()).completeWithCostKnowledge(character.player())
			else
				call speech(info, character, false, tr("Hier hast du deine 40 Goldmünzen."), null)
				call speech(info, character, true, tr("Danke vielmals. Hier hast du eine kleine Stärkung."), null)
				call SetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) - 40)
				// kleine Stärkung geben (nichts ändern)
			endif
			call QuestGoldForTheTradingPermission.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat Auftrag „Gold für die Handelsgenehmigung“ mit normaler Belohnung abgeschlossen und vom Vogt erfahren, dass eine Handelsgenehmigung weniger kostet)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return QuestGoldForTheTradingPermission.characterQuest(character).isCompleted() and TalkFerdinand.talk().knowsCost(character) and not thistype(info.talk()).completedWithCostKnowledge(character.player())
		endmethod

		// Gib mir meine 30 Goldmünzen!
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Gib mir meine 30 Goldmünzen!"), null)
			call speech(info, character, true, tr("Was? Welche 30 Goldmünzen?"), null)
			call speech(info, character, false, tr("Das weißt du ganz genau, du Penner! Ich hab mal mit dem Vogt gesprochen."), null)
			call speech(info, character, true, tr("Oh, verdammte Scheiße. Hier hast du sie. Erstick an deinem Scheißgold!"), null)
			call info.talk().showStartPage(character)
		endmethod

		// Invasion?
		private static method infoAction1_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Invasion?"), null)
			call speech(info, character, true, tr("Wo kommst du denn her oder gefällt dir der Ausdruck etwa nicht? Du glaubst doch nicht das Geschwafel unseres verehrten Herrn Königs oder doch?"), null)
			call speech(info, character, true, tr("Jeder hier weiß, dass diese verdammten Dunkelelfen einen Packt mit den Orks geschlossen haben. Ich habe selbst gesehen, wie diese Schweinehunde meine Heimatstadt Trammar in Flammen aufgehen ließen."), null)
			call speech(info, character, true, tr("Bin gerade nochmal so mit dem Leben davon gekommen! Der König unterschätzt die Lage vollkommen. Trammar war verdammt gut befestigt und wurde innerhalb eines einzigen Tages eingenommen."), null)
			call speech(info, character, true, tr("Diese Burg hier hat zwar eine bessere Lage, aber das wird ihr nichts nützen wenn erstmal hunderte von Orks und Dunkelefen hier anrücken."), null)
			call speech(info, character, true, tr("Aber welche Wahl hab ich denn? Ich muss mir ein paar Goldmünzen dazu verdienen und vom Gewinn Leben. Danach hau ich so schnell wie möglich ab und dir würde ich genau das Gleiche raten."), null)
			call speech(info, character, true, tr("Sicher, du wirst hier bestimmt einige treffen, die frohen Mutes dem Feind trotzen wollen, aber haben die etwa ihre Heimat untergehen sehen? Ich sag's dir Junge: Dieses Königreich wird untergehen!"), null)
			call info.talk().showRange(8, 10, character)
		endmethod

		// Kann ich dir irgendwie helfen?
		private static method infoAction1_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kann ich dir irgendwie helfen?"), null)
			call speech(info, character, true, tr("Du willst mir helfen? Wieso solltest du das tun?"), null)
			call speech(info, character, false, tr("(Sarkastisch) Na weil ich ein unglaublich gütiger Mensch bin."), null)
			call speech(info, character, true, tr("Wenn du mir wirklich helfen willst, dann gib mir ein paar Goldmünzen, damit ich den Vogt dafür bezahlen kann, in die Burg eingelassen zu werden."), null)
			call speech(info, character, false, tr("Wie viel brauchst du denn?"), null)
			call speech(info, character, true, tr("40 Goldmünzen würden schon reichen."), null)
			call QuestGoldForTheTradingPermission.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Das nennt man Pech.
		private static method infoAction1_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Das nennt man Pech."), null)
			call speech(info, character, true, tr("Allerdings."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Was sagt denn der König?
		private static method infoAction1_0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was sagt denn der König?"), null)
			call speech(info, character, true, tr("Der König? Dieser miese Sack, der behauptet doch glatt, dass es sich nur um kleinere Überfälle handele. Hab's nicht glauben wollen als ich's von einem Jäger gehört habe."), null)
			call speech(info, character, true, tr("Verdammte Scheiße, wozu haben wir denn den ganzen Adel mit all seinen Vasallen. Wollen die sich ewig nur um ihr beschisses Gut streiten?"), null)
			call speech(info, character, true, tr("Die sollen gefälligst ein Heer aufstellen! Ich hab viele gute Freunde in Trammer verloren. Dieser Dreckskönig, wenn ich ..."), null)
			call speech(info, character, true, tr("Erzähl aber keinem, dass ich so von ihm geredet habe, sonst lande ich noch am Pranger oder schlimmer noch am Galgen."), null)
			call speech(info, character, false, tr("Keine Sorge."), null)
			call info.talk().showRange(9, 10, character)
		endmethod

		// Hast wohl Schiss?
		private static method infoAction1_0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hast wohl Schiss?"), null)
			call speech(info, character, true, tr("Ach halt's Maul, Mann! Hast du schon mal gesehen, wie der Felsbrocken eines Katapults deine Nachbarn erschlägt?"), null)
			call speech(info, character, true, tr("Die Schweine haben Belagerungswaffen aufgestellt und dann das verdammte Tor aufgebrochen."), null)
			call speech(info, character, true, tr("In dem Gemetzel konnte ich abhauen, aber die Bilder und Schreie werde ich nie vergessen. Seitdem schlafe ich nicht mehr so ruhig wie früher, also hör mir auf mit deinem Heldengelaber!"), null)
			call speech(info, character, true, tr("Wir hatten einen Rittersmann in Trammer, ein edler Herr mit Gut im Osten. Der war verdammt mutig, ein richtiger Held und aufgeblickt haben sie zu ihm."), null)
			call speech(info, character, true, tr("Hat sich mit Soldaten hinters Stadttor gestellt als es aufgebrochen wurde und so'n verdammter Dunkelelf hat ihm den Kopf abgeschlagen, nachdem er fünf Pfeile in die Brust bekommen hat."), null)
			call speech(info, character, true, tr("Und das bevor er auch nur einmal zuschlagen konnte."), null)
			call speech(info, character, true, tr("Mut hält dich nicht am Leben verdammt!"), null)
			call info.talk().showInfo(8, character)
			call info.talk().showInfo(10, character)
			call info.talk().show(character.player())
		endmethod

		// Zurück
		private static method infoAction1_0_2 takes AInfo info, ACharacter character returns nothing
			call info.talk().showRange(5, 7, character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n017_0137, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Wer bist du?")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Wieso verkaufst du deine Waren nicht in der Burg?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Hier hast du deine Goldmünzen.")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Gib mir meine 30 Goldmünzen wieder!")) // 3
			call this.addExitButton() // 4

			// info 1
			call this.addInfo(false, false, 0, thistype.infoAction1_0, tr("Invasion?")) // 5
			call this.addInfo(false, false, 0, thistype.infoAction1_1, tr("Kann ich dir irgendwie helfen?")) // 6
			call this.addInfo(false, false, 0, thistype.infoAction1_2, tr("Das nennt man Pech.")) // 7

			call this.addInfo(false, false, 0, thistype.infoAction1_0_0, tr("Was sagt denn der König?")) // 8
			call this.addInfo(false, false, 0, thistype.infoAction1_0_1, tr("Hast wohl Schiss?")) // 9
			call this.addBackButton(thistype.infoAction1_0_2) // 10

			return this
		endmethod
	endstruct

endlibrary