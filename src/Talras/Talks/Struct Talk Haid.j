library StructMapTalksTalkHaid requires Asl, StructGameCharacter

	struct TalkHaid extends Talk
		private boolean array m_completedWithCostKnowledge[6] /// @todo MapData.maxPlayers
		private AInfo m_whoAreYou
		private AInfo m_notInCastle
		private AInfo m_invasion
		private AInfo m_whatDoesTheKingSay
		private AInfo m_help
		private AInfo m_gold
		private AInfo m_goldBack
		private AInfo m_exit

		implement Talk

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
			call speech(info, character, false, tr("Wer bist du?"), null)
			call speech(info, character, true, tr("Ich bin Haid, ein fahrender Händler aus Trammar. Interessierst du dich zufällig für eine meiner Waren?"), gg_snd_Haid1)
			call speech(info, character, false, tr("Was verkaufst du denn?"), null)
			call speech(info, character, true, tr("Etwas zu essen und alles was man im Alltag gebrauchen kann: Brot, Äpfel, Wurst, Geschirr und noch vieles mehr."), gg_snd_Haid2)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionNotInCastle takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Wieso verkaufst du deine Waren nicht in der Burg?
		private static method infoActionNotInCastle takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wieso verkaufst du deine Waren nicht in der Burg?"), null)
			call speech(info, character, true, tr("Nun, ich bin ein fahrender Händler und die sieht man hier gar nicht mehr so gerne."), gg_snd_Haid3)
			call speech(info, character, true, tr("Das Misstrauen ist seit Beginn der Invasion einfach zu groß geworden und hier gibt es schon mehr als genug Händler. Außerdem besitze ich nicht das nötige Kleingeld, um mir einen Platz in in der Burg zu erwerben."), gg_snd_Haid4)
			call info.talk().showStartPage(character)
		endmethod
		
		//  (Nach „Wieso verkaufst du deine Waren nicht in der Burg?“))
		private static method infoConditionInvasion takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_notInCastle.index(), character)
		endmethod
		
		// Invasion?
		private static method infoActionInvasion takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Invasion?"), null)
			call speech(info, character, true, tr("Wo kommst du denn her oder gefällt dir der Ausdruck etwa nicht? Du glaubst doch nicht das Geschwafel unseres verehrten Herrn Königs oder doch?"), gg_snd_Haid5)
			call speech(info, character, true, tr("Jeder hier weiß, dass diese verdammten Dunkelelfen einen Packt mit den Orks geschlossen haben. Ich habe selbst gesehen, wie diese Schweinehunde meine Heimatstadt Trammar in Flammen aufgehen ließen."), gg_snd_Haid6)
			call speech(info, character, true, tr("Bin gerade nochmal so mit dem Leben davon gekommen! Der König unterschätzt die Lage vollkommen. Trammar war verdammt gut befestigt und wurde innerhalb eines einzigen Tages eingenommen."), gg_snd_Haid7)
			call speech(info, character, true, tr("Diese Burg hier hat zwar eine bessere Lage, aber das wird ihr nichts nützen wenn erst mal hunderte von Orks und Dunkelefen hier anrücken."), gg_snd_Haid8)
			call speech(info, character, true, tr("Aber welche Wahl hab ich denn? Ich muss mir ein paar Goldmünzen dazu verdienen und vom Gewinn leben. Danach hau ich so schnell wie möglich ab und dir würde ich genau das Gleiche raten."), gg_snd_Haid9)
			call speech(info, character, true, tr("Sicher, du wirst hier bestimmt einige treffen, die frohen Mutes dem Feind trotzen wollen, aber haben die etwa ihre Heimat untergehen sehen? Ich sag's dir Junge: Dieses Königreich wird untergehen!"), gg_snd_Haid10)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach „Invasion?“)
		private static method infoConditionWhatDoesTheKingSay takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_invasion.index(), character)
		endmethod
		
		// Was sagt denn der König?
		private static method infoActionWhatDoesTheKingSay takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was sagt denn der König?"), null)
			call speech(info, character, true, tr("Der König? Dieser miese Sack, der behauptet doch glatt, dass es sich nur um kleinere Überfälle handele. Hab's nicht glauben wollen als ich's von einem Jäger gehört habe."), gg_snd_Haid11)
			call speech(info, character, true, tr("Verdammte Scheiße, wozu haben wir denn den ganzen Adel mit all seinen Vasallen. Wollen die sich ewig nur um ihr beschissenes Gut streiten?"), gg_snd_Haid12)
			call speech(info, character, true, tr("Die sollen gefälligst ein Heer aufstellen! Ich hab viele gute Freunde in Trammer verloren. Dieser Dreckskönig, wenn ich ..."), gg_snd_Haid13)
			call speech(info, character, true, tr("Erzähl aber keinem, dass ich so von ihm geredet habe, sonst lande ich noch am Pranger oder schlimmer noch am Galgen."), gg_snd_Haid14)
			call speech(info, character, false, tr("Keine Sorge."), null)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach „Wieso verkaufst du deine Waren nicht in der Burg?“)
		private static method infoConditionHelp takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_notInCastle.index(), character)
		endmethod
		
		// Kann ich dir irgendwie helfen?
		private static method infoActionHelp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kann ich dir irgendwie helfen?"), null)
			call speech(info, character, true, tr("Du willst mir helfen? Wieso solltest du das tun?"), gg_snd_Haid15)
			call speech(info, character, false, tr("Wieso nicht?"), null)
			call speech(info, character, true, tr("Wenn du mir wirklich helfen willst, dann gib mir ein paar Goldmünzen, damit ich den Vogt dafür bezahlen kann, in die Burg eingelassen zu werden."), gg_snd_Haid16)
			call speech(info, character, false, tr("Wie viele brauchst du denn?"), null)
			call speech(info, character, true, tr("40 Goldmünzen würden schon reichen."), gg_snd_Haid17)
			call QuestGoldForTheTradingPermission.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat Auftrag "Gold für die Handelsgenehmigung" und die entsprechenden Goldmünzen)
		private static method infoConditionGold takes AInfo info, ACharacter character returns boolean
			local player user = character.player()
			local boolean result = QuestGoldForTheTradingPermission.characterQuest(character).state() == AAbstractQuest.stateNew and ((GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) >= 40 and not TalkFerdinand.talk().knowsCost(character)) or (GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) >= 10 and TalkFerdinand.talk().knowsCost(character)))
			set user = null
			return result
		endmethod

		// Hier hast du deine Goldmünzen.
		private static method infoActionGold takes AInfo info, Character character returns nothing
			local player user = character.player()
			if (TalkFerdinand.talk().knowsCost(character)) then // Charakter hat vom Vogt erfahren, wie viel eine Handelsgenehmigung kostet.
				call speech(info, character, false, tr("Hier hast du deine 10 Goldmünzen. Ich habe mal mit dem Vogt gesprochen. Willst du mich verarschen oder was?"), null)
				call speech(info, character, true, tr("Tut mir leid, aber so ist nun mal das Leben. Kriegst auch eine große Stärkung mit dazu."), gg_snd_Haid18)
				call SetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) - 10)
				// große Stärkung geben
				call QuestGoldForTheTradingPermission.characterQuest(character).improveReward()
				call thistype(info.talk()).completeWithCostKnowledge(character.player())
			else
				call speech(info, character, false, tr("Hier hast du deine 40 Goldmünzen."), null)
				call speech(info, character, true, tr("Danke vielmals. Hier hast du eine kleine Stärkung."), gg_snd_Haid19)
				call SetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(user, PLAYER_STATE_RESOURCE_GOLD) - 40)
				// kleine Stärkung geben (nichts ändern)
				call character.giveItem('I03O')
				call character.giveItem('I03O')
				call character.giveItem('I016')
				call character.giveItem('I016')
			endif
			call QuestGoldForTheTradingPermission.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat Auftrag „Gold für die Handelsgenehmigung“ mit normaler Belohnung abgeschlossen und vom Vogt erfahren, dass eine Handelsgenehmigung weniger kostet)
		private static method infoConditionGoldBack takes AInfo info, ACharacter character returns boolean
			return QuestGoldForTheTradingPermission.characterQuest(character).isCompleted() and TalkFerdinand.talk().knowsCost(character) and not thistype(info.talk()).completedWithCostKnowledge(character.player())
		endmethod

		// Gib mir meine 30 Goldmünzen!
		private static method infoActionGoldBack takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Gib mir meine 30 Goldmünzen!"), null)
			call speech(info, character, true, tr("Was? Welche 30 Goldmünzen?"), gg_snd_Haid20)
			call speech(info, character, false, tr("Das weißt du ganz genau, du Penner! Ich hab mal mit dem Vogt gesprochen."), null)
			call speech(info, character, true, tr("Oh, verdammte Scheiße. Hier hast du sie. Erstick an deinem Scheißgold!"), gg_snd_Haid21)
			call SetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD) + 30)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.haid(), thistype.startPageAction)

			// start page
			set this.m_whoAreYou = this.addInfo(false, false, 0, thistype.infoActionWhoAreYou, tr("Wer bist du?"))
			set this.m_notInCastle = this.addInfo(false, false, thistype.infoConditionNotInCastle, thistype.infoActionNotInCastle, tr("Wieso verkaufst du deine Waren nicht in der Burg?"))
			set this.m_invasion = this.addInfo(true, false, thistype.infoConditionInvasion, thistype.infoActionInvasion, tr("Invasion?"))
			set this.m_whatDoesTheKingSay = this.addInfo(true, false, thistype.infoConditionWhatDoesTheKingSay, thistype.infoActionWhatDoesTheKingSay, tr("Was sagt denn der König?"))
			set this.m_help = this.addInfo(false, false, thistype.infoConditionHelp, thistype.infoActionHelp, tr("Kann ich dir irgendwie helfen?"))
			set this.m_gold = this.addInfo(false, false, thistype.infoConditionGold, thistype.infoActionGold, tr("Hier hast du deine Goldmünzen."))
			set this.m_goldBack = this.addInfo(false, false, thistype.infoConditionGoldBack, thistype.infoActionGoldBack, tr("Gib mir meine 30 Goldmünzen wieder!"))
			set this.m_exit = this.addExitButton()

			return this
		endmethod
	endstruct

endlibrary