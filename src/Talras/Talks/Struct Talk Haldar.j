library StructMapTalksTalkHaldar requires Asl, StructGameCharacter, StructGameClasses, StructMapMapAos, StructMapMapNpcs, StructMapQuestsQuestDeathToBlackLegion

	struct TalkHaldar extends ATalk
		private boolean array m_gotOffer[6] /// \todo \ref MapData.maxPlayers
		private integer array m_lastRewardScore[6] /// \todo \ref MapData#maxPlayers

		implement Talk

		public method giveOffer takes nothing returns nothing
			local player user = this.character().player()
			set this.m_gotOffer[GetPlayerId(user)] = true
			set user = null
		endmethod

		/// Parameter is required since it's used by \ref TalkBaldar.
		public method gotOffer takes Character character returns boolean
			local player user = character.player()
			local boolean result = this.m_gotOffer[GetPlayerId(user)]
			set user = null
			return result
		endmethod

		private method startPageAction takes nothing returns nothing
			call this.showUntil(8)
		endmethod

		// Hallo.
		private static method infoActionGreeting takes AInfo info returns nothing
			call speech(info, false, tr("Hallo."), null)
			call speech(info, true, tr("Wer bist du und was machst du in meinem Lager?"), null)
			// (Charakter kennt noch keinen der beiden Brüder)
			if (not TalkBaldar.talk.evaluate().infoHasBeenShownToCharacter(0, info.talk().character())) then
				call speech(info, false, tr("Dein Lager?"), null)
				call speech(info, true, tr("Ja, mein Lager!"), null)
				call speech(info, true, tr("Dies ist das Lager der weißen Legion, meines Heers."), null)
			// (Charakter hat bereits Baldar getroffen)
			else
				call speech(info, false, tr("Bist du Baldars Bruder?"), null)
				call speech(info, true, tr("Woher weißt du das?"), null)
				call speech(info, false, tr("Ich habe mit ihm gesprochen."), null)
				call speech(info, true, tr("Ist das so? Ich hoffe nur, er hat dir keinen Wurm ins Ohr gesetzt. Seine Wut und Dummheit kennen keine Grenzen!"), null)

				// (Auftrag „Tod der weißen Legion“ nicht aktiv)
				if (QuestDeathToWhiteLegion.characterQuest(info.talk().character()).isNotUsed()) then
					call speech(info, true, tr("Aber bevor mein dummer Bruder noch auf die Idee kommen sollte, dich anzuwerben, tue ich das lieber."), null)
					call speech(info, true, tr("Möchtest du nicht meinem glorreichen Heer beitreten, damit ich diesem Kampf hier ein schnelleres Ende bereiten kann?"), null)
					call speech(info, false, tr("Mal sehen."), null)
					call speech(info, true, tr("Gut, lasse dir ruhig Zeit. Er wird mich sowieso nicht besiegen können."), null)
					call thistype(info.talk()).giveOffer() // (Charakter erhält somit das Angebot)
				endif
			endif
			call info.talk().showStartPage()
		endmethod

		// (Charakter hat ein Angebot bekommen und der Auftrag „Tod der weißen Legion“ ist nicht aktiv)
		private static method infoConditionGotOfferAndIsNotActive takes AInfo info returns boolean
			return thistype(info.talk()).gotOffer(info.talk().character()) and QuestDeathToWhiteLegion.characterQuest(info.talk().character()).isNotUsed()
		endmethod

		// Ich möchte der weißen Legion beitreten.
		private static method infoActionIWantToJoin takes AInfo info returns nothing
			local unit characterUnit = info.talk().character().unit()
			local item whichItem
			call speech(info, false, tr("Ich möchte der weißen Legion beitreten."), null)
			call speech(info, true, tr("Das freut mich zu hören! Auf jeden Fall war es eine weise Entscheidung."), null)
			call speech(info, true, tr("Doch nun zu deiner neuen Aufgabe: zunächst einmal bekommst du diese Standarte hier. Es ist mein ruhmreiches weißes Wappen."), null)
			call speech(info, true, tr("Damit du nicht das Gefühl hast, du müsstest hier umsonst kämpfen, hast du hier noch ein paar Goldmünzen und etwas Weihwasser, auch wenn ich eigentlich Leute nur sehr ungern gegen einen Sold für mich kämpfen lasse. Aber was tut man nicht alles im Krieg?."), null)
			call speech(info, true, tr("Gut, nun lasse mich dir erklären, was du auf dem „Schlachtfeld“ zu tun hast. Es gibt zwei Wege, die die beiden Lager miteinander verbinden. Auf beiden Wegen schicken mein Bruder und ich Truppen gegeneinander los. Es steht dir also frei, auf welchem der Wege du für mich kämpfen möchtest."), null)
			call speech(info, true, tr("Es gibt nur ein kleines Problem dabei. Mein Bruder und ich haben damals, als wir mit dem Kampf gegeneinander begannen, vereinbart, dass keiner außer uns beiden, das Recht besitzt, sich in den Streit einzumischen."), null)
			call speech(info, true, tr("Die Krieger, die ich schicke, habe ich alle selbst erschaffen, das zählt also nicht als fremde Einmischung."), null)
			call speech(info, true, tr("Du dagegen würdest gegen die Regeln verstoßen. Für gewöhnlich achte ich Regeln zwar ganz besonders, hierbei aber mache selbst ich einmal eine Ausnahme, um den Streit endlich siegreich zu beenden."), null)
			call speech(info, false, tr("Also, was soll ich tun?"), null)
			call speech(info, true, tr("Es gäbe da eine nette Lösung. Bevor du das Schlachtfeld betrittst, benutzt du einen Zauberring von mir, der dich in die Gestalt eines Engels verwandelt."), null)
			call speech(info, false, tr("Was?"), null)
			call speech(info, true, tr("Keine Sorge, sobald du ihn erneut wirken lässt, wirst du dich natürlich zurückverwandeln."), null)
			call speech(info, true, tr("Der Zauber wirkt allerdings nur innerhalb dieser Höhle. Außerhalb ist meine Aura nicht stark genug!"), null)
			call speech(info, true, tr("Ach so und noch etwas: Hast du genügend Feinde getötet, bekommst du natürlich auch entsprechende Belohnungen, die du dir bei mir persönlich abholen kannst."), null)
			/// TODO andere Standarte!
			call Character(info.talk().character()).giveQuestItem('I01B') // Standarte
			// Ring
			if (info.talk().character().class() == Classes.astralModifier()) then
				call Character(info.talk().character()).giveQuestItem('I033')
			elseif (info.talk().character().class() == Classes.dragonSlayer()) then
				call Character(info.talk().character()).giveQuestItem('I034')
			elseif (info.talk().character().class() == Classes.druid()) then
				call Character(info.talk().character()).giveQuestItem('I035')
			elseif (info.talk().character().class() == Classes.elementalMage()) then
				call Character(info.talk().character()).giveQuestItem('I036')
			elseif (info.talk().character().class() == Classes.illusionist()) then
				call Character(info.talk().character()).giveQuestItem('I037')
			elseif (info.talk().character().class() == Classes.cleric()) then
				call Character(info.talk().character()).giveQuestItem('I038')
			elseif (info.talk().character().class() == Classes.necromancer()) then
				call Character(info.talk().character()).giveQuestItem('I039')
			elseif (info.talk().character().class() == Classes.ranger()) then
				call Character(info.talk().character()).giveQuestItem('I03B')
			elseif (info.talk().character().class() == Classes.knight()) then
				call Character(info.talk().character()).giveQuestItem('I03A')
			elseif (info.talk().character().class() == Classes.wizard()) then
				call Character(info.talk().character()).giveQuestItem('I03C')
			else
				debug call Print("Warnung: Unsupported class for ring.")
				call Character(info.talk().character()).giveQuestItem('I033')
			endif
			call QuestDeathToBlackLegion.characterQuest(info.talk().character()).enable()
			call info.talk().showStartPage()
			set characterUnit = null
			set whichItem = null
		endmethod

		// (Auftrag „Tod der schwarzen Legion“ ist aktiv)
		private static method infoConditionIsActive takes AInfo info returns boolean
			return QuestDeathToBlackLegion.characterQuest(info.talk().character()).isNew()
		endmethod

		// Gib mir meine Belohnung!
		private static method infoActionReward takes AInfo info returns nothing
			local integer newScore = Aos.playerScore(info.talk().character().player()) - thistype(info.talk()).m_lastRewardScore[GetPlayerId(info.talk().character().player())]
			local integer i
			call speech(info, false, tr("Gib mir meine Belohnung!"), null)
			// (Charakter hat mindestens zehn neue Tötungspunkte)
			if (newScore >= 10) then
				call speech(info, true, tr("Gut, hier hast du sie. Mach nur weiter so und wir werden diesen Streit bald beendet haben!"), null)
				// (Charakter erhält eine Belohnung)
				set newScore = newScore / 10
				set thistype(info.talk()).m_lastRewardScore[GetPlayerId(info.talk().character().player())] = thistype(info.talk()).m_lastRewardScore[GetPlayerId(info.talk().character().player())] + newScore * 10
				call QuestDeathToWhiteLegion.characterQuest(info.talk().character()).displayUpdateMessage(tr("Belohnung:"))
				set i = 0
				loop
					exitwhen (i == newScore)
					call QuestDeathToWhiteLegion.characterQuest(info.talk().character()).distributeRewards()
					set i = i + 1
				endloop
			// (Charakter hat weniger als zehn neue Tötungspunkte)
			else
				call speech(info, true, tr("Ein paar mehr solltest du aber schon getötet haben. Es heißt ja nicht umsonst Belohnung."), null)
			endif
			call info.talk().showStartPage()
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionAfterGreeting takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(0)
		endmethod

		// Welches Heer?
		private static method infoActionWhichArmy takes AInfo info returns nothing
			call speech(info, false, tr("Welches Heer?"), null)
			call speech(info, true, tr("Sieh dich um! Dies ist mein Heer. Ich habe diese Krieger geschaffen, um meinen Bruder Baldar zur Vernunft zu bringen."), null)
			call info.talk().showStartPage()
		endmethod

		// Weiße Legion?
		private static method infoActionWhiteLegion takes AInfo info returns nothing
			call speech(info, false, tr("Weiße Legion?"), null)
			call speech(info, true, tr("Ganz genau, so nennen wir uns, mein Gefolge und ich. Wir kämpfen hier schon seit vielen Jahren gegen die schwarze Legion. Sie wird von meinem etwas dümmlichen und aggressiven Bruder Baldar angeführt, einem Erzdämon."), null)
			call info.talk().showStartPage()
		endmethod

		// (Nach „Weiße Legion?“)
		private static method infoConditionAfterBlackLegion takes AInfo info returns boolean
			return info.talk().infoHasBeenShown(4)
		endmethod

		// Wieso ist dein Bruder ein Erzdämon?
		private static method infoActionWhyIsBrother takes AInfo info returns nothing
			call speech(info, false, tr("Wieso ist dein Bruder ein Erzdämon?"), null)
			call speech(info, true, tr("Wieso sollte er es nicht sein, dieser Narr?"), null)
			call info.talk().showStartPage()
		endmethod

		// Wieso kämpft ihr gegeneinander?
		private static method infoActionWhyDoYouFight takes AInfo info returns nothing
			call speech(info, false, tr("Wieso kämpft ihr gegeneinander?"), null)
			call speech(info, true, tr("Was weiß ich? Frage doch meinen Bruder, warum er immer Streit anfängt."), null)
			call info.talk().showStartPage()
		endmethod

		// Wer ist denn der Stärkere von euch beiden?
		private static method infoActionWhoIsStronger takes AInfo info returns nothing
			call speech(info, false, tr("Wer ist denn der Stärkere von euch beiden?"), null)
			call speech(info, true, tr("(Lacht) Mein Bruder würde dir jetzt vermutlich antworten, dass er der Stärkere ist und das doch selbstverständlich wäre."), null)
			call speech(info, true, tr("Er war schon immer schwächer, aber das Ganze zieht sich jetzt schon recht lange hin und ich möchte dem ein Ende bereiten."), null)
			if (not thistype(info.talk()).gotOffer(info.talk().character()) and QuestDeathToWhiteLegion.characterQuest(info.talk().character()).isNotUsed()) then // (Charakter hat kein Angebot bekommen und der Auftrag „Tod der weißen Legion“ ist nicht aktiv)
				call speech(info, true, tr("Möchtest du mir dabei helfen?"), null)
				call thistype(info.talk()).giveOffer() // (Charakter erhält somit das Angebot)
			endif
			call info.talk().showRange(9, 10)
		endmethod

		// Warum sollte ich?
		private static method infoActionWhyShouldI takes AInfo info returns nothing
			call speech(info, false, tr("Warum sollte ich?"), null)
			call speech(info, true, tr("Ganz einfach, weil du damit einem ruhmreichen, gerechten Weg folgen würdest. Vielleicht aber auch nur für einen verächtlichen Sold."), null)
			call info.talk().showStartPage()
		endmethod

		// Klar!
		private static method infoActionOfCourse takes AInfo info returns nothing
			call speech(info, false, tr("Klar!"), null)
			call speech(info, true, tr("Du scheinst mir sehr mutig zu sein. Ich hoffe, dahinter steckt eine ehrenvolle Absicht. Das Beste ist vermutlich, wenn ich dir noch etwas Zeit zum Überlegen gebe."), null)
			call info.talk().showStartPage()
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