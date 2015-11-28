library StructMapTalksTalkHaldar requires Asl, StructGameCharacter, StructGameClasses, StructMapMapAos, StructMapMapNpcs, StructMapQuestsQuestDeathToBlackLegion

	struct TalkHaldar extends Talk
		private boolean array m_gotOffer[6] /// \todo \ref MapData.maxPlayers
		private integer array m_lastRewardScore[6] /// \todo \ref MapData#maxPlayers

		implement Talk

		public method giveOffer takes player whichPlayer returns nothing
			set this.m_gotOffer[GetPlayerId(whichPlayer)] = true
		endmethod

		/// Parameter is required since it's used by \ref TalkBaldar.
		public method gotOffer takes player whichPlayer returns boolean
			return this.m_gotOffer[GetPlayerId(whichPlayer)]
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(8, character)
		endmethod

		// Hallo.
		private static method infoActionGreeting takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Wer bist du und was machst du in meinem Lager?"), null)
			// (Charakter kennt noch keinen der beiden Brüder)
			if (not TalkBaldar.talk.evaluate().infoHasBeenShownToCharacter(0, character)) then
				call speech(info, character, false, tr("Dein Lager?"), null)
				call speech(info, character, true, tr("Ja, mein Lager!"), null)
				call speech(info, character, true, tr("Dies ist das Lager der weißen Legion, meines Heers."), null)
			// (Charakter hat bereits Baldar getroffen)
			else
				call speech(info, character, false, tr("Bist du Baldars Bruder?"), null)
				call speech(info, character, true, tr("Woher weißt du das?"), null)
				call speech(info, character, false, tr("Ich habe mit ihm gesprochen."), null)
				call speech(info, character, true, tr("Ist das so? Ich hoffe nur, er hat dir keinen Wurm ins Ohr gesetzt. Seine Wut und Dummheit kennen keine Grenzen!"), null)

				// (Auftrag „Tod der weißen Legion“ nicht aktiv)
				if (QuestDeathToWhiteLegion.characterQuest(character).isNotUsed()) then
					call speech(info, character, true, tr("Aber bevor mein dummer Bruder noch auf die Idee kommen sollte, dich anzuwerben, tue ich das lieber."), null)
					call speech(info, character, true, tr("Möchtest du nicht meinem glorreichen Heer beitreten, damit ich diesem Kampf hier ein schnelleres Ende bereiten kann?"), null)
					call speech(info, character, false, tr("Mal sehen."), null)
					call speech(info, character, true, tr("Gut, lasse dir ruhig Zeit. Er wird mich sowieso nicht besiegen können."), null)
					call thistype(info.talk()).giveOffer(character.player()) // (Charakter erhält somit das Angebot)
				endif
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat ein Angebot bekommen und der Auftrag „Tod der weißen Legion“ ist nicht aktiv)
		private static method infoConditionGotOfferAndIsNotActive takes AInfo info, ACharacter character returns boolean
			return thistype(info.talk()).gotOffer(character.player()) and QuestDeathToWhiteLegion.characterQuest(character).isNotUsed()
		endmethod

		// Ich möchte der weißen Legion beitreten.
		private static method infoActionIWantToJoin takes AInfo info, ACharacter character returns nothing
			local unit characterUnit = character.unit()
			local item whichItem
			call speech(info, character, false, tr("Ich möchte der weißen Legion beitreten."), null)
			call speech(info, character, true, tr("Das freut mich zu hören! Auf jeden Fall war es eine weise Entscheidung."), null)
			call speech(info, character, true, tr("Doch nun zu deiner neuen Aufgabe: zunächst einmal bekommst du diese Standarte hier. Es ist mein ruhmreiches weißes Wappen."), null)
			call speech(info, character, true, tr("Damit du nicht das Gefühl hast, du müsstest hier umsonst kämpfen, hast du hier noch ein paar Goldmünzen und etwas Weihwasser, auch wenn ich eigentlich Leute nur sehr ungern gegen einen Sold für mich kämpfen lasse. Aber was tut man nicht alles im Krieg?."), null)
			call speech(info, character, true, tr("Gut, nun lasse mich dir erklären, was du auf dem „Schlachtfeld“ zu tun hast. Es gibt zwei Wege, die die beiden Lager miteinander verbinden. Auf beiden Wegen schicken mein Bruder und ich Truppen gegeneinander los. Es steht dir also frei, auf welchem der Wege du für mich kämpfen möchtest."), null)
			call speech(info, character, true, tr("Es gibt nur ein kleines Problem dabei. Mein Bruder und ich haben damals, als wir mit dem Kampf gegeneinander begannen, vereinbart, dass keiner außer uns beiden, das Recht besitzt, sich in den Streit einzumischen."), null)
			call speech(info, character, true, tr("Die Krieger, die ich schicke, habe ich alle selbst erschaffen, das zählt also nicht als fremde Einmischung."), null)
			call speech(info, character, true, tr("Du dagegen würdest gegen die Regeln verstoßen. Für gewöhnlich achte ich Regeln zwar ganz besonders, hierbei aber mache selbst ich einmal eine Ausnahme, um den Streit endlich siegreich zu beenden."), null)
			call speech(info, character, false, tr("Also, was soll ich tun?"), null)
			call speech(info, character, true, tr("Es gäbe da eine nette Lösung. Bevor du das Schlachtfeld betrittst, benutzt du einen Zauberring von mir, der dich in die Gestalt eines Engels verwandelt."), null)
			call speech(info, character, false, tr("Was?"), null)
			call speech(info, character, true, tr("Keine Sorge, sobald du ihn erneut wirken lässt, wirst du dich natürlich zurückverwandeln."), null)
			call speech(info, character, true, tr("Der Zauber wirkt allerdings nur innerhalb dieser Höhle. Außerhalb ist meine Aura nicht stark genug!"), null)
			call speech(info, character, true, tr("Ach so und noch etwas: Hast du genügend Feinde getötet, bekommst du natürlich auch entsprechende Belohnungen, die du dir bei mir persönlich abholen kannst."), null)
			call Character(character).giveQuestItem('I01C') // Standarte
			// Ring
			if (character.class() == Classes.dragonSlayer()) then
				call Character(character).giveQuestItem('I034')
			elseif (character.class() == Classes.druid()) then
				call Character(character).giveQuestItem('I035')
			elseif (character.class() == Classes.elementalMage()) then
				call Character(character).giveQuestItem('I036')
			elseif (character.class() == Classes.cleric()) then
				call Character(character).giveQuestItem('I038')
			elseif (character.class() == Classes.necromancer()) then
				call Character(character).giveQuestItem('I039')
			elseif (character.class() == Classes.ranger()) then
				call Character(character).giveQuestItem('I03B')
			elseif (character.class() == Classes.knight()) then
				call Character(character).giveQuestItem('I03A')
			elseif (character.class() == Classes.wizard()) then
				call Character(character).giveQuestItem('I03C')
			else
				debug call Print("Warnung: Unsupported class for ring.")
				call Character(character).giveQuestItem('I033')
			endif
			call QuestDeathToBlackLegion.characterQuest(character).enable()
			call info.talk().showStartPage(character)
			set characterUnit = null
			set whichItem = null
		endmethod

		// (Auftrag „Tod der schwarzen Legion“ ist aktiv)
		private static method infoConditionIsActive takes AInfo info, ACharacter character returns boolean
			return QuestDeathToBlackLegion.characterQuest(character).isNew()
		endmethod

		// Gib mir meine Belohnung!
		private static method infoActionReward takes AInfo info, ACharacter character returns nothing
			local integer newScore = Aos.playerScore(character.player()) - thistype(info.talk()).m_lastRewardScore[GetPlayerId(character.player())]
			local integer i
			call speech(info, character, false, tr("Gib mir meine Belohnung!"), null)
			// (Charakter hat mindestens zehn neue Tötungspunkte)
			if (newScore >= 10) then
				call speech(info, character, true, tr("Gut, hier hast du sie. Mach nur weiter so und wir werden diesen Streit bald beendet haben!"), null)
				// (Charakter erhält eine Belohnung)
				set newScore = newScore / 10
				set thistype(info.talk()).m_lastRewardScore[GetPlayerId(character.player())] = thistype(info.talk()).m_lastRewardScore[GetPlayerId(character.player())] + newScore * 10
				call QuestDeathToWhiteLegion.characterQuest(character).displayUpdateMessage(tr("Belohnung:"))
				set i = 0
				loop
					exitwhen (i == newScore)
					call QuestDeathToWhiteLegion.characterQuest(character).questItem(1).distributeRewards()
					set i = i + 1
				endloop
			// (Charakter hat weniger als zehn neue Tötungspunkte)
			else
				call speech(info, character, true, tr("Ein paar mehr solltest du aber schon getötet haben. Es heißt ja nicht umsonst Belohnung."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionAfterGreeting takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Welches Heer?
		private static method infoActionWhichArmy takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Welches Heer?"), null)
			call speech(info, character, true, tr("Sieh dich um! Dies ist mein Heer. Ich habe diese Krieger geschaffen, um meinen Bruder Baldar zur Vernunft zu bringen."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Weiße Legion?
		private static method infoActionWhiteLegion takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Weiße Legion?"), null)
			call speech(info, character, true, tr("Ganz genau, so nennen wir uns, mein Gefolge und ich. Wir kämpfen hier schon seit vielen Jahren gegen die schwarze Legion. Sie wird von meinem etwas dümmlichen und aggressiven Bruder Baldar angeführt, einem Erzdämon."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Weiße Legion?“)
		private static method infoConditionAfterBlackLegion takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(4, character)
		endmethod

		// Wieso ist dein Bruder ein Erzdämon?
		private static method infoActionWhyIsBrother takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wieso ist dein Bruder ein Erzdämon?"), null)
			call speech(info, character, true, tr("Wieso sollte er es nicht sein, dieser Narr?"), null)
			call info.talk().showStartPage(character)
		endmethod

		// Wieso kämpft ihr gegeneinander?
		private static method infoActionWhyDoYouFight takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wieso kämpft ihr gegeneinander?"), null)
			call speech(info, character, true, tr("Was weiß ich? Frage doch meinen Bruder, warum er immer Streit anfängt."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Wer ist denn der Stärkere von euch beiden?
		private static method infoActionWhoIsStronger takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wer ist denn der Stärkere von euch beiden?"), null)
			call speech(info, character, true, tr("(Lacht) Mein Bruder würde dir jetzt vermutlich antworten, dass er der Stärkere ist und das doch selbstverständlich wäre."), null)
			call speech(info, character, true, tr("Er war schon immer schwächer, aber das Ganze zieht sich jetzt schon recht lange hin und ich möchte dem ein Ende bereiten."), null)
			if (not thistype(info.talk()).gotOffer(character.player()) and QuestDeathToWhiteLegion.characterQuest(character).isNotUsed()) then // (Charakter hat kein Angebot bekommen und der Auftrag „Tod der weißen Legion“ ist nicht aktiv)
				call speech(info, character, true, tr("Möchtest du mir dabei helfen?"), null)
				call thistype(info.talk()).giveOffer(character.player()) // (Charakter erhält somit das Angebot)
			endif
			call info.talk().showRange(9, 10, character)
		endmethod

		// Warum sollte ich?
		private static method infoActionWhyShouldI takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Warum sollte ich?"), null)
			call speech(info, character, true, tr("Ganz einfach, weil du damit einem ruhmreichen, gerechten Weg folgen würdest. Vielleicht aber auch nur für einen verächtlichen Sold."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Klar!
		private static method infoActionOfCourse takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Klar!"), null)
			call speech(info, character, true, tr("Du scheinst mir sehr mutig zu sein. Ich hoffe, dahinter steckt eine ehrenvolle Absicht. Das Beste ist vermutlich, wenn ich dir noch etwas Zeit zum Überlegen gebe."), null)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.haldar(), thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_gotOffer[i] = false
				set this.m_lastRewardScore[i] = 0
				set i = i + 1
			endloop

			// start page
			call this.addInfo(false, false, 0, thistype.infoActionGreeting, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoConditionGotOfferAndIsNotActive, thistype.infoActionIWantToJoin, tr("Ich möchte der weißen Legion beitreten.")) // 1
			call this.addInfo(true, false, thistype.infoConditionIsActive, thistype.infoActionReward, tr("Gib mir meine Belohnung!")) // 2
			call this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoActionWhichArmy, tr("Welches Heer?")) // 3
			call this.addInfo(false, false, thistype.infoConditionAfterGreeting, thistype.infoActionWhiteLegion, tr("Weiße Legion?")) // 4
			call this.addInfo(false, false, thistype.infoConditionAfterBlackLegion, thistype.infoActionWhyIsBrother, tr("Wieso ist dein Bruder ein Erzdämon?")) // 5
			call this.addInfo(false, false, thistype.infoConditionAfterBlackLegion, thistype.infoActionWhyDoYouFight, tr("Wieso kämpft ihr gegeneinander?")) // 6
			call this.addInfo(false, false, thistype.infoConditionAfterBlackLegion, thistype.infoActionWhoIsStronger, tr("Wer ist denn der Stärkere von euch beiden?")) // 7
			call this.addExitButton() // 8

			// sub info from infoActionWhoIsStronger
			call this.addInfo(false, false, 0, thistype.infoActionWhyShouldI, tr("Warum sollte ich?")) // 9
			call this.addInfo(false, false, 0, thistype.infoActionOfCourse, tr("Klar!")) // 10

			return this
		endmethod
	endstruct

endlibrary